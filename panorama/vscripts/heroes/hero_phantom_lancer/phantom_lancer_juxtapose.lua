---@class phantom_lancer_juxtapose_lua:CDOTA_Ability_Lua
phantom_lancer_juxtapose_lua = class({})
LinkLuaModifier("modifier_phantom_lancer_juxtapose_lua", "heroes/hero_phantom_lancer/phantom_lancer_juxtapose.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_phantom_lancer_juxtapose_illusion_lua", "heroes/hero_phantom_lancer/phantom_lancer_juxtapose.lua", LUA_MODIFIER_MOTION_NONE)

function phantom_lancer_juxtapose_lua:GetIntrinsicModifierName()
	return "modifier_phantom_lancer_juxtapose_lua"
end

function phantom_lancer_juxtapose_lua:OnUpgrade()
	if self:IsCooldownReady() and GameMode:IsTeamFighting(self:GetTeam()) then
		self:SpawnIllusion()
	end
end

function phantom_lancer_juxtapose_lua:OnOwnerSpawned()
	if self:IsTrained() and self:IsCooldownReady() and GameMode:IsTeamFighting(self:GetTeam())
	and (not IsValidEntity(self.illusion) or not self.illusion:IsAlive()) then
		self:SpawnIllusion()
	end
end

function phantom_lancer_juxtapose_lua:SpawnIllusion()
	self:KillIllusion()

	local caster = self:GetCaster()

	if caster:IsIllusion() or not caster:IsAlive() then return end

	local mod_params = {
		outgoing_damage = self:GetSpecialValueFor("illusion_damage_out_pct") + caster:FindTalentValue("special_bonus_unique_phantom_lancer_6"),
		incoming_damage = self:GetSpecialValueFor("illusion_damage_in_pct"),

		--Doppleganger ability adds 1 second to illusion lifetime, 
		--for Juxtapose illusion lifetime not defined(infinite) == -1, 
		--when Doppleganger apply 1 additional second,lifetime sets to 0 and illusion dies
		duration = 9999
	}
	self.illusion = CreateIllusions(caster, caster, mod_params, 1, 150, false, false)[1]

	if self.illusion then
		self.illusion.unit_state = GameMode:GetTeamState(caster:GetTeam()) -- for bounds enforcer proper work
		self.illusion:AddNewModifier(self.illusion, self, "modifier_phantom_lancer_juxtapose_illusion_lua", nil)
		
		Timers:CreateTimer(0.03, function()
			local pos = caster:GetAbsOrigin() + RandomVector(150)
			FindClearSpaceForUnit(self.illusion, pos, true)
		end)
	end
end

function phantom_lancer_juxtapose_lua:KillIllusion()
	if IsValidEntity(self.illusion) and self.illusion:IsAlive() then
		self.illusion.force_kill = true
		self.illusion:ForceKill(false)
	end
	self.illusion = nil
end


---@class modifier_phantom_lancer_juxtapose_lua:CDOTA_Modifier_Lua
modifier_phantom_lancer_juxtapose_lua = class({})

function modifier_phantom_lancer_juxtapose_lua:IsHidden() return true end
function modifier_phantom_lancer_juxtapose_lua:IsPurgable() return false end
function modifier_phantom_lancer_juxtapose_lua:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_phantom_lancer_juxtapose_lua:OnCreated()
	if not IsServer() then return end

	local parent = self:GetParent()

	self.player_id = parent:GetPlayerOwnerID()
	self.team = parent:GetTeamNumber()
end

function modifier_phantom_lancer_juxtapose_lua:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH
	}
end

function modifier_phantom_lancer_juxtapose_lua:OnDestroy()
	if IsClient() then return end
	self:GetAbility():KillIllusion()
end


function modifier_phantom_lancer_juxtapose_lua:OnDeath(event)
	local ability = self:GetAbility() ---@type phantom_lancer_juxtapose_lua

	if ability and ability.illusion == event.unit and GameMode:IsTeamFighting(ability:GetTeam()) and not ability.illusion.force_kill then
		local respawn_delay = ability:GetCooldown(-1)
		
		ability:StartCooldown(respawn_delay)
		
		Timers:CreateTimer(respawn_delay, function()
			if IsValidEntity(ability) and not self:IsNull() and GameMode:IsTeamFighting(ability:GetTeam()) then
				ability:SpawnIllusion()
			end
		end)
	end
end



-- 
function modifier_phantom_lancer_juxtapose_lua:OnRoundStart()
	local ability = self:GetAbility() ---@type phantom_lancer_juxtapose_lua
	if not ability or ability:IsNull() then return end

	if Enfos:IsEnfosMode() then
		if not EnfosPVP:IsPlayerDueling(self.team, self.player_id) then
			ability:SpawnIllusion()
		end
	else
		if not PvpManager:IsPvpTeamThisRound(self.team) then
			ability:SpawnIllusion()
		end
	end
end

function modifier_phantom_lancer_juxtapose_lua:OnPvpStart()
	local ability = self:GetAbility() ---@type phantom_lancer_juxtapose_lua
	if not ability or ability:IsNull() then return end

	if Enfos:IsEnfosMode() then
		if EnfosPVP:IsPlayerDueling(self.team, self.player_id) then
			ability:SpawnIllusion()
		end
	else
		if PvpManager:IsPvpTeamThisRound(self.team) then
			ability:SpawnIllusion()
		end
	end
end

function modifier_phantom_lancer_juxtapose_lua:OnRoundEndForTeam()
	if Enfos:IsEnfosMode() then return end
	self:OnPvpEndedForDuelists()
end

function modifier_phantom_lancer_juxtapose_lua:OnPvpEndedForDuelists()
	local ability = self:GetAbility() ---@type phantom_lancer_juxtapose_lua

	if ability then
		ability:KillIllusion()
	end
end

---@class modifier_phantom_lancer_juxtapose_illusion_lua:CDOTA_Modifier_Lua
modifier_phantom_lancer_juxtapose_illusion_lua = class({})

function modifier_phantom_lancer_juxtapose_illusion_lua:IsHidden() return true end
function modifier_phantom_lancer_juxtapose_illusion_lua:IsPurgable() return false end
function modifier_phantom_lancer_juxtapose_illusion_lua:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_phantom_lancer_juxtapose_illusion_lua:GetStatusEffectName()
	return "particles/status_fx/status_effect_phantom_lancer_illstrong.vpcf"
end

function modifier_phantom_lancer_juxtapose_illusion_lua:StatusEffectPriority()
	return 9999999
end
