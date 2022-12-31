LinkLuaModifier("modifier_spectre_dispersion_lua", "heroes/hero_spectre/spectre_dispersion_lua", LUA_MODIFIER_MOTION_NONE)

spectre_dispersion_lua = class({})

function spectre_dispersion_lua:GetBehavior()
	if self:GetCaster():HasShard() then return DOTA_ABILITY_BEHAVIOR_POINT end

	return DOTA_ABILITY_BEHAVIOR_PASSIVE 
end

function spectre_dispersion_lua:GetIntrinsicModifierName()
	return "modifier_spectre_dispersion_lua"
end

function spectre_dispersion_lua:OnAbilityPhaseStart()
	
	local caster = self:GetCaster()
	if caster and caster:HasShard() then
		local modifier = caster:FindModifierByName("modifier_spectre_dispersion_lua")
		self.recent_attackers = modifier:GetRecentAttackers()			-- This self.recent_attackers is different from the one in the modifier so we need to fetch it
		if (self.recent_attackers and table.count(self.recent_attackers) == 0) or not self.recent_attackers then
			DisplayError(caster:GetPlayerID(),'#dota_hud_error_no_recent_attackers')
			return false
		end
	end
	
	return true
end

function spectre_dispersion_lua:OnSpellStart()
	local caster = self:GetCaster()
	local target_point = self:GetCursorPosition()
	
	-- Create Shard Illusion on cast
	if not caster or not caster:HasShard() then return end

	-- Find closest unit to the cursor position among the recent attackers
	local illusion_position = target_point -- Failsafe, should always be overwritten
	local closest_distance = 9999999 -- Arbitrary large value to compare with
	for ent_index, flag in pairs(self.recent_attackers or {}) do
		local recent_attacker = EntIndexToHScript(ent_index)
		if recent_attacker and recent_attacker:IsAlive() then
			local position = recent_attacker:GetAbsOrigin()
			local distance = (target_point - position):Length2D()
			if distance <= closest_distance then
				closest_distance = distance
				illusion_position = position
			end
		end
	end

	local illusions = CreateIllusions(caster, caster, {}, 1, caster:GetHullRadius(), false, true)
	local shard_illusion = illusions[1]

	if shard_illusion ~= nil and not shard_illusion:IsNull() then

		FindClearSpaceForUnit(shard_illusion, illusion_position, true)

		shard_illusion.IsMainHero = function() return false end
		shard_illusion.IsRealHero = function() return false end

		local shard_duration = self:GetSpecialValueFor("shard_haunt_duration")
		shard_illusion:AddNewModifier( caster, self, "modifier_illusion", { duration = shard_duration } )
		shard_illusion:AddNewModifier( caster, self, "modifier_spectre_haunt", { duration = shard_duration } )

	end

	local modifier = caster:FindModifierByName("modifier_spectre_dispersion_lua")
	if modifier then
		modifier:ResetRecentAttackers()	-- Reset the attacker table after the spell is cast
	end

end


---@class modifier_spectre_dispersion_lua:CDOTA_Modifier_Lua
modifier_spectre_dispersion_lua = class({})									-- Used for shard OnTakeDamage function

function modifier_spectre_dispersion_lua:IsHidden() return true end
function modifier_spectre_dispersion_lua:IsPurgable() return false end
function modifier_spectre_dispersion_lua:RemoveOnDeath() return false end

function modifier_spectre_dispersion_lua:OnCreated()
	self.shard_recent_damage_time = self:GetAbility():GetSpecialValueFor("shard_recent_damage_time")
	
	if not IsServer() then return end
	local caster = self:GetCaster()
	local ability = self:GetAbility()

	self.recent_attackers = {}

	if caster and not caster:IsNull() and not caster:IsIllusion() then
		caster:AddNewModifier(caster, ability, "modifier_spectre_dispersion", {})
		self:StartIntervalThink(1)
	end
end

function modifier_spectre_dispersion_lua:OnRefresh()
	self:OnCreated()
end

function modifier_spectre_dispersion_lua:OnIntervalThink()
	local caster = self:GetCaster()
	local ability = self:GetAbility()

	if caster and ability and not caster:HasModifier("modifier_spectre_dispersion") then
		--reapply vanilla modifier since it can be purged somehow
		caster:AddNewModifier(caster, ability, "modifier_spectre_dispersion", nil)
	end
end

function modifier_spectre_dispersion_lua:OnDestroy()
	if not IsServer() then return end
	local caster = self:GetCaster()
	if caster and not caster:IsNull() and caster:HasModifier("modifier_spectre_dispersion") then
		caster:RemoveModifierByName("modifier_spectre_dispersion")
	end
end

function modifier_spectre_dispersion_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_AVOID_DAMAGE
	}
	return funcs
end

function modifier_spectre_dispersion_lua:GetModifierAvoidDamage(keys)
	local parent = self:GetParent()
	local attacker = keys.attacker
	if not attacker or not attacker:IsAlive() then return end
	if attacker:IsIllusion() or attacker:IsBuilding() or attacker:IsMonkeyClone() then return end
	if not parent or not parent:HasShard() then return end
	local ent_index = attacker:GetEntityIndex()
	if not self.recent_attackers[ent_index] then
		self.recent_attackers[ent_index] = true
		Timers:CreateTimer(self.shard_recent_damage_time, function()
			self.recent_attackers[ent_index] = nil
		end)
	end

	return 0
end

function modifier_spectre_dispersion_lua:GetRecentAttackers()
	return self.recent_attackers
end

function modifier_spectre_dispersion_lua:ResetRecentAttackers()
	self.recent_attackers = {}
end
