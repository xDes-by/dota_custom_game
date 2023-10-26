LinkLuaModifier('modifier_broodmother_poison_debuff', "heroes/hero_broodmother/broodmother_poison/broodmother_poison", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_broodmother_poison', "heroes/hero_broodmother/broodmother_poison/broodmother_poison", LUA_MODIFIER_MOTION_NONE)

broodmother_poison = class({})

function broodmother_poison:GetIntrinsicModifierName() 
    return 'modifier_broodmother_poison'
end

--------------------------------------------------------

modifier_broodmother_poison = class({})

function modifier_broodmother_poison:IsHidden() return true end
function modifier_broodmother_poison:IsPurgable() return false end

function modifier_broodmother_poison:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}
	return funcs
end

function modifier_broodmother_poison:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		if params.attacker == self:GetParent() and not params.target:IsBuilding() then
			
			duration = self:GetAbility():GetSpecialValueFor("duration")
			if self:GetParent():FindAbilityByName("npc_dota_hero_broodmother_int8") then
				duration = duration + 10
			end
			
			stacks = self:GetAbility():GetSpecialValueFor("stacks")
			if self:GetParent():FindAbilityByName("npc_dota_hero_broodmother_str9") then
				stacks = stacks + 5
			end

			if self:GetParent():FindAbilityByName("special_bonus_unique_npc_dota_hero_broodmother_agi50") then
				stacks = stacks + 3
				self.special_bonus_unique_npc_dota_hero_broodmother_agi50 = true
			end

			modifier = params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_broodmother_poison_debuff", { duration = duration})
			if modifier:GetStackCount() < stacks then
				modifier:IncrementStackCount()
				if self.special_bonus_unique_npc_dota_hero_broodmother_agi50 then
					modifier:SetStackCount(stacks)
				end
			end
		end
	end
end

------------------------------------------------------------------

modifier_broodmother_poison_debuff = class({})

function modifier_broodmother_poison_debuff:IsHidden()
	return false
end

function modifier_broodmother_poison_debuff:IsDebuff()
	return true
end

function modifier_broodmother_poison_debuff:IsPurgable()
	return false
end

function modifier_broodmother_poison_debuff:OnCreated( kv )
	self.disarm = self:GetAbility():GetSpecialValueFor( "disarm" )
	if self:GetCaster():FindAbilityByName("npc_dota_hero_broodmother_agi11") then
		self.disarm = self.disarm * 3
	end
	if IsServer() then
		self:StartIntervalThink( 1 )
	end
end

function modifier_broodmother_poison_debuff:OnIntervalThink()
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	if self:GetCaster():FindAbilityByName("npc_dota_hero_broodmother_int9") then
		self.damage = self.damage + self:GetCaster():GetIntellect() * 0.3
	end

	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_broodmother_int50") then
		self.damage = self.damage + self:GetCaster():GetIntellect()
	end

	if self:GetCaster():FindAbilityByName("npc_dota_hero_broodmother_agi8") then
		self.damage = self.damage + self:GetCaster():GetAgility() * 0.3
	end
	
	ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), damage_type = DAMAGE_TYPE_MAGICAL, damage = self:GetStackCount() * self.damage, ability = self:GetAbility()})
end

function modifier_broodmother_poison_debuff:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
    }
end
       
function modifier_broodmother_poison_debuff:GetModifierPhysicalArmorBonus(params)
    return -self.disarm * self:GetStackCount()
end

function modifier_broodmother_poison_debuff:GetModifierMagicalResistanceBonus(params)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_broodmother_int6") then
		return -2 * self:GetStackCount()
	end
	return 0	
end