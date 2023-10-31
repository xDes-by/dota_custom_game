item_mage_heart_lua = class({})

LinkLuaModifier("modifier_item_mage_heart_passive", 'items/custom_items/item_mage_heart.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_mage_heart", 'items/custom_items/item_mage_heart.lua', LUA_MODIFIER_MOTION_NONE)

function item_mage_heart_lua:GetAbilityTextureName()
	local level = self:GetLevel()
	if self:GetSecondaryCharges() == 0 then
		return "all/mage" .. level
	else
		return "gem" .. self:GetSecondaryCharges() .. "/item_mage_heart_lua" .. level
	end
end

function item_mage_heart_lua:GetIntrinsicModifierName()
	return "modifier_item_mage_heart_passive"
end

-----------------------------------------------------------------------------------------------

modifier_item_mage_heart_passive = class({})

function modifier_item_mage_heart_passive:IsHidden()
	return true
end

function modifier_item_mage_heart_passive:IsPurgable()
	return false
end

function modifier_item_mage_heart_passive:DestroyOnExpire()
	return false
end

function modifier_item_mage_heart_passive:OnCreated()
	self.parent = self:GetParent()
    self.bonus_int = self:GetAbility():GetSpecialValueFor("bonus_int")
    self.tick = self:GetAbility():GetSpecialValueFor("tick")
	if not IsServer() then
		return
	end
	self:StartIntervalThink(self.tick)
end

function modifier_item_mage_heart_passive:OnRefresh()
    self.bonus_int = self:GetAbility():GetSpecialValueFor("bonus_int")
    self.tick = self:GetAbility():GetSpecialValueFor("tick")
end

function modifier_item_mage_heart_passive:OnIntervalThink()		
	local parent = self:GetParent()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	
	local maxcount = ability:GetSpecialValueFor('count')
	local radius = ability:GetSpecialValueFor('radius')
	local damage = caster:GetIntellect() /2

	local enemy_list = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)		
	
	local count = 0
	for _,enemy in pairs(enemy_list) do
		if count < maxcount then
			count = count + 1
			self:_FireEffect(enemy)
			self:_ApplyDamage(enemy)
		end
	end
end

function modifier_item_mage_heart_passive:_OnAttacked(attacker)
	local parent = self:GetParent()
	local ability = self:GetAbility()

	if parent.attack_counter > 1 then
		parent.attack_counter = parent.attack_counter - 1
		parent:SetHealth(parent.attack_counter)
		parent:ModifyHealth(parent.attack_counter, ability, false, 0)
	end
end

function modifier_item_mage_heart_passive:_FireEffect(target)
	local parent = self:GetParent()
	local caster = self:GetCaster()
	local ability = self:GetAbility()

	local ward = parent
	-- There are some light/medium/heavy unused versions
	local p_list = {
		"particles/units/heroes/hero_pugna/pugna_ward_attack.vpcf",
		"particles/units/heroes/hero_pugna/pugna_ward_attack_light.vpcf",
		"particles/units/heroes/hero_pugna/pugna_ward_attack_medium.vpcf",
		"particles/units/heroes/hero_pugna/pugna_ward_attack_heavy.vpcf",
	}
	local p_id = RandomInt(1, #p_list)
	local p_name = p_list[p_id]
	local p_attack = ParticleManager:CreateParticle(p_name, PATTACH_ABSORIGIN_FOLLOW, ward)
	ParticleManager:SetParticleControl(p_attack, 1, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(p_attack)

	--target:EmitSound("Hero_Pugna.NetherWard.Target")
	-- caster:EmitSound("Hero_Pugna.NetherWard.Attack")
	ward:EmitSound("Hero_Pugna.NetherWard.Attack")
end

function modifier_item_mage_heart_passive:_ApplyDamage(target)
	local parent = self:GetParent()
	local caster = self:GetCaster()
	local ability = self:GetAbility()

	local damage = caster:GetIntellect() /2

	ApplyDamage({
		attacker = caster,
		victim = target,
		ability = ability,
		damage_type = ability:GetAbilityDamageType(),
		damage = damage
	})
end

function modifier_item_mage_heart_passive:GetAttributes() 
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_mage_heart_passive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
end

function modifier_item_mage_heart_passive:GetModifierBonusStats_Intellect( params )
	return self.bonus_int
end