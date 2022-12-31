LinkLuaModifier("modifier_bc_frozen_cooldown", "libraries/better_cooldown.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bc_cooldown_speed", "libraries/better_cooldown.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bc_charge_cooldown_speed", "libraries/better_cooldown.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_test_reduction", "libraries/better_cooldown.lua", LUA_MODIFIER_MOTION_NONE)

if not BetterCooldowns then 
	BetterCooldowns = class({})
end

ListenToGameEvent("game_rules_state_change", function()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		BetterCooldowns:Init()
	end
end, nil)

function BetterCooldowns:Init()
	print("[BetterCooldowns] initialized BetterCooldowns")
	self.units = {}
	local mode = GameRules:GetGameModeEntity()
	ListenToGameEvent('dota_player_used_ability', Dynamic_Wrap(BetterCooldowns, 'OnAbilityCast'), self)
	ListenToGameEvent('dota_non_player_used_ability', Dynamic_Wrap(BetterCooldowns, 'OnAbilityCast'), self)
	-- ListenToGameEvent('dota_player_learned_ability', Dynamic_Wrap(BetterCooldowns, 'OnAbilityUpgrade'), self)
end

function BetterCooldowns:OnAbilityCast(event)
	local unit = EntIndexToHScript(event.caster_entindex)
	local cdr = unit:GetCooldownReduction()
	local tab = CustomNetTables:GetTableValue("better_cooldowns_cdr", tostring(event.caster_entindex)) or {}
		if (cdr ~= 1 and not self.units[event.caster_entindex]) or (self.units[event.caster_entindex] and cdr ~= self.units[event.caster_entindex]) then
		self.units[event.caster_entindex] = cdr
		tab.cdr = cdr
	end
	local ability = unit:FindAbilityByName(event.abilityname)
	if ability then
		if ability.GetChargeCooldown then
			local chargeCooldown = ability:GetChargeCooldown()
			if chargeCooldown ~= 0 then
				if not tab.chargeCD then tab.chargeCD = {} end
				tab.chargeCD[event.abilityname] = chargeCooldown
			end
		end
	end
	CustomNetTables:SetTableValue("better_cooldowns_cdr", tostring(event.caster_entindex), tab)
end

function BetterCooldowns:OnAbilityUpgrade(event)
	-- later
end

if IsServer() then
	function CDOTABaseAbility:SetFrozenCooldown(state)
		local caster = self:GetCaster()
		local entIndex = self:entindex()
		for _,modifier in pairs(caster:FindAllModifiersByName("modifier_bc_frozen_cooldown")) do
			if modifier.entindex == entIndex then
				modifier:Destroy()
			end
		end

		self.frozen_cooldown = nil

		if state == true then
			self.frozen_cooldown = true
			caster:AddNewModifier(caster, self, "modifier_bc_frozen_cooldown", {Entindex = entIndex})
		end
	end

	function CDOTABaseAbility:SetCooldownSpeed(speed)
		local caster = self:GetCaster()
		local entIndex = self:entindex()
		for _,modifier in pairs(caster:FindAllModifiersByName("modifier_bc_cooldown_speed")) do
			if modifier.entindex == entIndex then
				if speed == 1 then
					modifier:Destroy()
				else
					modifier.speed = speed
				end
			end
		end
		for _,modifier in pairs(caster:FindAllModifiersByName("modifier_bc_charge_cooldown_speed")) do
			if modifier.entindex == entIndex then
				if speed == 1 then
					modifier:Destroy()
				else
					modifier.speed = speed
				end
			end
		end
		if speed ~= 1 then
			if self.charge_modifier then
				caster:AddNewModifier(caster, self, "modifier_bc_charge_cooldown_speed", {Entindex = entIndex, speed=speed-1})
			else
				caster:AddNewModifier(caster, self, "modifier_bc_cooldown_speed", {Entindex = entIndex, speed=speed-1})
			end
		end
	end
end

modifier_bc_frozen_cooldown = class({})

function modifier_bc_frozen_cooldown:IsHidden()
	return true
end

function modifier_bc_frozen_cooldown:IsDebuff()
	return true
end

function modifier_bc_frozen_cooldown:IsPurgable()
	return false
end

function modifier_bc_frozen_cooldown:RemoveOnDeath()
	return false
end

function modifier_bc_frozen_cooldown:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_bc_frozen_cooldown:OnCreated(event)
	if IsClient() then return end
	self.entindex = event.Entindex
	self.ability = EntIndexToHScript(self.entindex)
	self.cooldown = self.ability:GetCooldownTimeRemaining()

	self:StartIntervalThink(1/30)
end

function modifier_bc_frozen_cooldown:OnIntervalThink()
	if not IsValidEntity(self.ability) then 
		self:Destroy() 
		return 
	end

	self.ability:StartCooldown(self.cooldown)
end

modifier_bc_cooldown_speed = class({})

function modifier_bc_cooldown_speed:IsHidden()
	return true
end

function modifier_bc_cooldown_speed:IsDebuff()
	return true
end

function modifier_bc_cooldown_speed:IsPurgable()
	return false
end

function modifier_bc_cooldown_speed:RemoveOnDeath()
	return false
end

function modifier_bc_cooldown_speed:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_bc_cooldown_speed:OnCreated(event)
	if IsClient() then return end
	self.entindex = event.Entindex
	if not self.entindex or not type(self.entindex) == "number" then
		self:Destroy()
		return
	end
	self.ability = EntIndexToHScript(self.entindex)
	self.lastCooldown = self.ability:GetCooldownTimeRemaining()
	self.gameTime = GameRules:GetGameTime()
	self.speed = event.speed
	self.tickSpeed = 0.5
	self:StartIntervalThink(self.tickSpeed)
end

function modifier_bc_cooldown_speed:OnIntervalThink()
	local gameTime = GameRules:GetGameTime()
	local diff = gameTime - self.gameTime
	self.gameTime = gameTime
	local reduction = diff * self.speed
	if not self.ability or self.ability:IsNull() or not self.ability.ReduceCooldown then
		self:Destroy()
		return
	end
	local curCooldown = self.ability:GetCooldownTimeRemaining()
	local newCooldown = curCooldown - reduction
	self.ability:ReduceCooldown(reduction)
end

modifier_bc_charge_cooldown_speed = class({})

function modifier_bc_charge_cooldown_speed:IsHidden()
	return true
end

function modifier_bc_charge_cooldown_speed:IsDebuff()
	return true
end

function modifier_bc_charge_cooldown_speed:IsPurgable()
	return false
end

function modifier_bc_charge_cooldown_speed:RemoveOnDeath()
	return false
end

function modifier_bc_charge_cooldown_speed:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_bc_charge_cooldown_speed:OnCreated(event)
	if IsClient() then return end
	self.entindex = event.Entindex
	if not self.entindex or not type(self.entindex) == "number" then
		self:Destroy()
		return
	end
	self.ability = EntIndexToHScript(self.entindex)
	self.lastCooldown = self.ability:GetCooldownTimeRemaining()
	self.chargeModifier = self.ability.charge_modifier
	self.gameTime = GameRules:GetGameTime()
	self.speed = event.speed
	self.tickSpeed = 0.5
	self:StartIntervalThink(self.tickSpeed)
end

function modifier_bc_charge_cooldown_speed:OnIntervalThink()
	local gameTime = GameRules:GetGameTime()
	local diff = gameTime - self.gameTime
	self.gameTime = gameTime
	local reduction = diff * self.speed
	if not self.ability or self.ability:IsNull() or not self.ability.ReduceCooldown then
		self:Destroy()
		return
	end
	if not (reduction > 0) then return end
	self.ability:ReduceCooldown(reduction)
end

modifier_test_reduction = class({})

function modifier_test_reduction:OnCreated(event)
	if IsClient() then return end
	self.maxDuration = 15
	self.interval = 0.5
	self:StartIntervalThink(self.interval)
	self:SetStackCount(2)
end

function modifier_test_reduction:OnIntervalThink()
	local duration = self:GetDuration()
	if duration > 0 then
		self:SetDuration(-1, true)
	else
		self:SetDuration(self.maxDuration, true)
		self.maxDuration = self.maxDuration - self.interval
	end
end

function modifier_test_reduction:DestroyOnExpire( ... )
	return false
end
