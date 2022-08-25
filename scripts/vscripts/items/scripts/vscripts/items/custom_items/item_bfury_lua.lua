item_bfury_lua1 = item_bfury_lua1 or class({})
item_bfury_lua2 = item_bfury_lua1 or class({})
item_bfury_lua3 = item_bfury_lua1 or class({})
item_bfury_lua4 = item_bfury_lua1 or class({})
item_bfury_lua5 = item_bfury_lua1 or class({})
item_bfury_lua6 = item_bfury_lua1 or class({})
item_bfury_lua7 = item_bfury_lua1 or class({})

LinkLuaModifier("modifier_item_bfury_lua", 'items/custom_items/item_bfury_lua.lua', LUA_MODIFIER_MOTION_NONE)

modifier_item_bfury_lua = class({})

function item_bfury_lua1:GetIntrinsicModifierName()
	return "modifier_item_bfury_lua"
end

function modifier_item_bfury_lua:IsHidden()
	return true
end

function modifier_item_bfury_lua:IsPurgable()
	return false
end

function modifier_item_bfury_lua:DestroyOnExpire()
	return false
end

function modifier_item_bfury_lua:RemoveOnDeath()	
	return false 
end

function modifier_item_bfury_lua:OnCreated()
	
	

	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_health_regen = self:GetAbility():GetSpecialValueFor("bonus_health_regen")
	self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
	self.cleave_damage_percent = self:GetAbility():GetSpecialValueFor("cleave_damage_percent")
	self.cleave_ending_width = self:GetAbility():GetSpecialValueFor("cleave_ending_width")
	self.quelling_bonus = self:GetAbility():GetSpecialValueFor("quelling_bonus")
	self.quelling_bonus_ranged = self:GetAbility():GetSpecialValueFor("quelling_bonus_ranged")

end

function modifier_item_bfury_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_item_bfury_lua:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end

function modifier_item_bfury_lua:GetModifierConstantHealthRegen()
	return self.bonus_health_regen
end

function modifier_item_bfury_lua:GetModifierPreAttack_BonusDamage(keys)
	if keys.target and not keys.target:IsHero() and not keys.target:IsOther() and not keys.target:IsBuilding() and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
		if not self:GetParent():IsRangedAttacker() then
			return self.bonus_damage + self.quelling_bonus
		else
			return self.bonus_damage + self.quelling_bonus_ranged
		end
	else
		return self.bonus_damage
	end
end

function modifier_item_bfury_lua:OnAttackLanded(keys)
    if not (
        IsServer()
        and self:GetParent() == keys.attacker
        and keys.attacker:GetTeam() ~= keys.target:GetTeam()
        and not keys.attacker:IsRangedAttacker()
    ) then return end
    
    local ability = self:GetAbility()
    local damage = keys.original_damage
    local damageMod = ability:GetSpecialValueFor( "cleave_damage_percent" )
    local radius = ability:GetSpecialValueFor( "cleave_distance" )
    local particle_cast = 'particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf'
    
    damageMod = damageMod * 0.01
    damage = damage * damageMod
    
    DoCleaveAttack(
        self:GetParent(),
        keys.target,
        ability,
        damage,
        150,
        360,
        radius,
        particle_cast
    )
end

--------------------дерево

function item_bfury_lua1:OnSpellStart()
	local caster = self:GetCaster()
	local target_point = self:GetCursorPosition()
	GridNav:DestroyTreesAroundPoint(target_point, 1, false)
end