modifier_hero_refreshing = modifier_hero_refreshing or class({})


function modifier_hero_refreshing:GetTexture()
	return "rune_regen"
end

function modifier_hero_refreshing:IsHidden()
	return false
end

function modifier_hero_refreshing:IsDebuff()
	return false
end

function modifier_hero_refreshing:IsPurgable()
	return false
end

function modifier_hero_refreshing:OnCreated( kv )
	self.kv = {
		health_regen_pct	= 200,
		mana_regen_pct		= 200,
		cooldown_reduction	= 1, -- reduce cooldowns by this value
		cdr_delay			= 1, -- with this delay
		cooldown_speed		= 2,
		disable_damage		= 1,
		status_resistance	= 100,
	}

	if not IsServer() then return end

	local parent = self:GetParent()
	parent:Purge(false, true, false, true, true)
	parent:InterruptMotionControllers(true)

	for _, modifier_name in pairs(HeroBuilder.fountain_removed_modifiers) do
		for __, modifier in pairs(parent:FindAllModifiersByName(modifier_name)) do
			modifier:Destroy()
		end
	end

	self:OnIntervalThink()
	self:StartIntervalThink( self.kv.cdr_delay )

	if parent.dummyCaster then
		parent.dummyCaster:AddNewModifier(parent.dummyCaster, nil, "modifier_hero_refreshing", {})
	end
end

function modifier_hero_refreshing:OnDestroy( kv )
	if not IsServer() then return end
	local parent = self:GetParent()

	parent:Purge(false, true, false, true, true)
	parent:InterruptMotionControllers(true)

	for ability_name, _ in pairs(HeroBuilder.fountain_disabled_skills) do
		local ability = parent:FindAbilityByName(ability_name)
		if ability then
			ability:SetActivated(true)
			ability.fountain_disabled = nil

            if ability_name == "skeleton_king_vampiric_aura" then
                ability:RefreshIntrinsicModifier()
			end
		end
	end

	if parent.tempest_double_clone and (not parent.tempest_double_clone:IsNull()) then
		parent.tempest_double_clone:RemoveModifierByName("modifier_hero_refreshing")
	end

	self:SetAbilitiesCooldownSpeed(1)

	if parent.dummy_caster then
		parent.dummy_caster:RemoveModifierByName("modifier_hero_refreshing")
	end
end

function modifier_hero_refreshing:ReduceCooldowns(value)
	local parent = self:GetParent()

	self:SetAbilitiesCooldownSpeed(self.kv.cooldown_speed)
	for i = 0, 16 do -- 0-8 inventory, 9-14 stash, 15 - tp scroll, 16 - neutral slot
		local item = parent:GetItemInSlot(i)
		if item and item.GetCooldownTimeRemaining then
			item:ReduceCooldown(value)
		end
	end
end

function modifier_hero_refreshing:SetAbilitiesCooldownSpeed(value)
	local parent = self:GetParent()

	for i = 0, (DOTA_MAX_ABILITIES - 1) do
		local ability = parent:GetAbilityByIndex(i)
		if ability and not ability:IsNull() and ((ability.GetCooldownTimeRemaining and ability:IsActivated()) 
		or HeroBuilder.fountain_disabled_skills[ability:GetAbilityName()]) then
			local ability_name = ability:GetAbilityName()
			if not string.find(ability_name, "empty_") and not string.find(ability_name, "special_bonus_") then
				if not ability.refreshing_cooldown_speed or ability.refreshing_cooldown_speed ~= value then
					ability.refreshing_cooldown_speed = value
					ability:SetCooldownSpeed(value)
				end
			end
		end
	end
end

function modifier_hero_refreshing:OnIntervalThink()
	self:ReduceCooldowns(self.kv.cooldown_reduction)
	
	local parent = self:GetParent()
	parent:Purge(false, true, false, true, true)
	parent:InterruptMotionControllers(true)

	if parent.GetPlayerID then
		local summons = Util:FindAllOwnedUnits(parent:GetPlayerID())

		for _, summon in pairs(summons) do
			if IsValidEntity(summon) and summon:IsAlive() and SUMMON_TELEPORTABLE_SUMMONS[summon:GetUnitName()] then
				summon:AddNewModifier(summon, nil, "modifier_summon_refreshing", self.kv)
			end
		end
	end

	if TestMode:IsTestMode() then return end

	for ability_name, _ in pairs(HeroBuilder.fountain_disabled_skills) do
		local ability = parent:FindAbilityByName(ability_name)
		if ability and ability:IsActivated() then
			ability:SetActivated(false)
			ability.fountain_disabled = true
		end
	end
end

function modifier_hero_refreshing:GetPriority()
	return 9999
end

function modifier_hero_refreshing:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_INVISIBLE] = false
	}
end

function modifier_hero_refreshing:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
		MODIFIER_PROPERTY_STATUS_RESISTANCE,
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,

		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,  
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_hero_refreshing:OnTooltip()
	return self.kv.cooldown_reduction
end

function modifier_hero_refreshing:GetModifierHealthRegenPercentage(params)
	return self.kv.health_regen_pct
end

function modifier_hero_refreshing:GetModifierTotalPercentageManaRegen(params)
	return self.kv.mana_regen_pct
end

function modifier_hero_refreshing:GetAbsoluteNoDamagePhysical()
	return self.kv.disable_damage
end

function modifier_hero_refreshing:GetAbsoluteNoDamageMagical()
	return self.kv.disable_damage
end

function modifier_hero_refreshing:GetAbsoluteNoDamagePure()
	return self.kv.disable_damage
end

function modifier_hero_refreshing:GetModifierStatusResistance()
	if IsServer() then
		return self.kv.status_resistance
	end
	return 0
end

function modifier_hero_refreshing:GetModifierInvisibilityLevel()
	return 0
end
