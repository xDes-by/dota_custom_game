death_prophet_ghastly_haunting = class({})

-- function death_prophet_ghastly_haunting:GetCooldown( iLvl )
-- 	return self.BaseClass.GetCooldown( self, iLvl ) * math.max( 1, self:GetCaster():FindTalentValue("special_bonus_unique_death_prophet_ghastly_haunting_2") )
-- end

function death_prophet_ghastly_haunting:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function death_prophet_ghastly_haunting:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end
function death_prophet_ghastly_haunting:OnSpellStart()
	local caster = self:GetCaster()
	local position = self:GetCursorPosition()
	
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")
	local talent = caster:FindAbilityByName("npc_dota_hero_death_prophet_int10")
	for _, enemy in ipairs( 
        FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false) 
    ) do
		if not enemy:TriggerSpellAbsorb(self) then
			local modifier = enemy:AddNewModifier( caster, self, "modifier_death_prophet_ghastly_haunting", {duration = duration} )
			if talent then
				ApplyDamage({
					victim = enemy,
					attacker = caster,
					damage = caster:GetIntellect() * 1.5,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = self
				})
			end
		end
	end
	
	EmitSoundOnLocationWithCaster( position, "Hero_DeathProphet.Silence", caster )
    local params = {
        [0] = position,
        [1] = Vector(radius, 0, 0)
    }

    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_death_prophet/death_prophet_silence.vpcf", PATTACH_WORLDORIGIN, caster)
    for key, value in pairs(params) do
        ParticleManager:SetParticleControl(particle, key, value)
    end

end

modifier_death_prophet_ghastly_haunting = class({})
LinkLuaModifier("modifier_death_prophet_ghastly_haunting", "heroes/hero_death_prophet/death_prophet_ghastly_haunting/death_prophet_ghastly_haunting", LUA_MODIFIER_MOTION_NONE)

function modifier_death_prophet_ghastly_haunting:OnCreated()
	if IsServer() then 
		-- if self:GetCaster():HasTalent("special_bonus_unique_death_prophet_ghastly_haunting_1") then
		-- 	self.damage = self:GetCaster():FindTalentValue("special_bonus_unique_death_prophet_ghastly_haunting_1") / 100
		-- 	self:StartIntervalThink(1)
		-- end
		local nFX = ParticleManager:CreateParticle("particles/generic_gameplay/generic_silenced.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
		self:AddEffect(nFX)
	end
end

function modifier_death_prophet_ghastly_haunting:OnRefresh()
	if IsServer() then 
		-- if self:GetCaster():HasTalent("special_bonus_unique_death_prophet_ghastly_haunting_1") then
		-- 	self.damage = self:GetCaster():FindTalentValue("special_bonus_unique_death_prophet_ghastly_haunting_1") / 100
		-- 	self:StartIntervalThink(1)
		-- end
		local nFX = ParticleManager:CreateParticle("particles/generic_gameplay/generic_silenced.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
		self:AddEffect(nFX)
	end
end

function modifier_death_prophet_ghastly_haunting:OnIntervalThink()
	self:GetAbility():DealDamage( self:GetCaster(), self:GetParent(), self:GetCaster():GetAverageTrueAttackDamage( self:GetParent() ) * self.damage, {damage_type = DAMAGE_TYPE_MAGICAL, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION} )
end

function modifier_death_prophet_ghastly_haunting:CheckState()
	return {[MODIFIER_STATE_SILENCED] = true}
end

function modifier_death_prophet_ghastly_haunting:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_START
	}
end

-- function modifier_death_prophet_ghastly_haunting:OnAttackStart(keys)
-- 	if IsServer() then
-- 		if self:GetCaster():FindAbilityByName("npc_dota_hero_death_prophet_agi6") then 
-- 			local owner = self:GetParent()
-- 			if owner == keys.target then
-- 				local attacker = keys.attacker
-- 				attacker:AddNewModifier(owner, self:GetAbility(), "modifier_item_imba_bloodthorn_attacker_crit2", {duration = 1.0, target_crit_multiplier = 150})
-- 			end
-- 		end
-- 	end
-- end


modifier_item_imba_bloodthorn_attacker_crit2 = modifier_item_imba_bloodthorn_attacker_crit2 or class({})
LinkLuaModifier("modifier_item_imba_bloodthorn_attacker_crit2", "heroes/hero_death_prophet/death_prophet_ghastly_haunting/death_prophet_ghastly_haunting", LUA_MODIFIER_MOTION_NONE)

function modifier_item_imba_bloodthorn_attacker_crit2:IsHidden() return true end
function modifier_item_imba_bloodthorn_attacker_crit2:IsDebuff() return false end
function modifier_item_imba_bloodthorn_attacker_crit2:IsPurgable() return false end

-- Track parameters to prevent errors if the item is unequipped
function modifier_item_imba_bloodthorn_attacker_crit2:OnCreated(keys)
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
	
	if IsServer() then
		self.target_crit_multiplier = keys.target_crit_multiplier
	end
end

-- Declare modifier events/properties
function modifier_item_imba_bloodthorn_attacker_crit2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

-- Grant the crit damage multiplier
function modifier_item_imba_bloodthorn_attacker_crit2:GetModifierPreAttack_CriticalStrike()
	if IsServer() then
		return self.target_crit_multiplier
	end
end

-- Remove the crit modifier when the attack is concluded
function modifier_item_imba_bloodthorn_attacker_crit2:OnAttackLanded(keys)
	if IsServer() then

		-- If this unit is the attacker, remove its crit modifier
		if self:GetParent() == keys.attacker then
			self:GetParent():RemoveModifierByName("modifier_item_imba_bloodthorn_attacker_crit2")
		end
	end
end