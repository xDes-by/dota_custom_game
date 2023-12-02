modifier_riki_smoke_screen_lua			= modifier_riki_smoke_screen_lua or class({})
function modifier_riki_smoke_screen_lua:GetEffectName()		return "particles/generic_gameplay/generic_silenced.vpcf" end
function modifier_riki_smoke_screen_lua:GetEffectAttachType()	return PATTACH_OVERHEAD_FOLLOW end
	
function modifier_riki_smoke_screen_lua:OnCreated()
	if self:GetAbility() then
		self.miss_rate					= self:GetAbility():GetSpecialValueFor("miss_rate")
		self.remnants_movespeed_slow	= self:GetAbility():GetSpecialValueFor("remnants_movespeed_slow") * (-1)
		self.remnants_vision			= self:GetAbility():GetSpecialValueFor("remnants_vision")
		self.solid_turn_rate_slow		= self:GetAbility():GetSpecialValueFor("solid_turn_rate_slow") * (-1)
	else
		self.miss_rate					= 0
		self.remnants_movespeed_slow	= 0
		self.remnants_vision_reduction	= 0
		self.solid_turn_rate_slow		= 0
	end
	if not IsServer() then return end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_riki_int7") then
		self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = self:GetCaster():GetIntellect() * 0.5 * 0.2,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(), --Optional.
		}
		self:StartIntervalThink(0.2)
	end
end

function modifier_riki_smoke_screen_lua:OnIntervalThink()
	ApplyDamage(self.damageTable)
end

function modifier_riki_smoke_screen_lua:CheckState()
	return {[MODIFIER_STATE_SILENCED] = true}
end

function modifier_riki_smoke_screen_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MISS_PERCENTAGE,
		
		-- Remnants of Smokescren
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_FIXED_DAY_VISION,
		MODIFIER_PROPERTY_FIXED_NIGHT_VISION,
		
		-- Solid Fog
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_START,
	}
end

function modifier_riki_smoke_screen_lua:GetModifierMiss_Percentage()
	return self.miss_rate
end

function modifier_riki_smoke_screen_lua:GetModifierMoveSpeedBonus_Percentage()
	return self.remnants_movespeed_slow
end

function modifier_riki_smoke_screen_lua:GetFixedDayVision()
	return self.remnants_vision
end

function modifier_riki_smoke_screen_lua:GetFixedNightVision()
	return self.remnants_vision
end

function modifier_riki_smoke_screen_lua:GetModifierTurnRate_Percentage()
	return self.solid_turn_rate_slow
end

function modifier_riki_smoke_screen_lua:OnAttackStart(keys)
	if IsServer() then
		if self:GetCaster():FindAbilityByName("npc_dota_hero_riki_agi10") then 
			local owner = self:GetParent()
			if owner == keys.target then
				local attacker = keys.attacker
				attacker:AddNewModifier(owner, self:GetAbility(), "modifier_item_imba_bloodthorn_attacker_crit", {duration = 1.0, target_crit_multiplier = 150})
			end
		end
	end
end

modifier_item_imba_bloodthorn_attacker_crit = class({})
function modifier_item_imba_bloodthorn_attacker_crit:IsHidden() return true end
function modifier_item_imba_bloodthorn_attacker_crit:IsDebuff() return false end
function modifier_item_imba_bloodthorn_attacker_crit:IsPurgable() return false end

-- Track parameters to prevent errors if the item is unequipped
function modifier_item_imba_bloodthorn_attacker_crit:OnCreated(keys)
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
	
	if IsServer() then
		self.target_crit_multiplier = keys.target_crit_multiplier
	end
end

-- Declare modifier events/properties
function modifier_item_imba_bloodthorn_attacker_crit:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

-- Grant the crit damage multiplier
function modifier_item_imba_bloodthorn_attacker_crit:GetModifierPreAttack_CriticalStrike()
	if IsServer() then
		return self.target_crit_multiplier
	end
end

-- Remove the crit modifier when the attack is concluded
function modifier_item_imba_bloodthorn_attacker_crit:OnAttackLanded(keys)
	if IsServer() then

		-- If this unit is the attacker, remove its crit modifier
		if self:GetParent() == keys.attacker then
			self:GetParent():RemoveModifierByName("modifier_item_imba_bloodthorn_attacker_crit")
		end
	end
end