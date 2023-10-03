item_kaya_custom_lua = class({})

LinkLuaModifier( "modifier_item_kaya_custom", "items/custom_items/item_kaya_custom", LUA_MODIFIER_MOTION_NONE )

function item_kaya_custom_lua:GetIntrinsicModifierName()
	return "modifier_item_kaya_custom"
end

modifier_item_kaya_custom = class({})

function modifier_item_kaya_custom:IsHidden()
	return true
end

function modifier_item_kaya_custom:RemoveOnDeath()
	return false
end

function modifier_item_kaya_custom:IsPurgable()
	return false
end

function modifier_item_kaya_custom:OnCreated( kv )
	self.parent = self:GetParent()
	self.bonus_dmg = self:GetAbility():GetSpecialValueFor( "bonus_dmg" )
	self.bonus_manaregen = self:GetAbility():GetSpecialValueFor( "mana_regen" )
	self.bonus_life = self:GetAbility():GetSpecialValueFor( "bonus_life" )
	self.bonus_int = self:GetAbility():GetSpecialValueFor( "bonus_int" )
	self.particle_name = "particles/items3_fx/octarine_core_lifesteal.vpcf"
	if not IsServer() then
		return
	end
	self.value = self:GetAbility():GetSpecialValueFor("bonus_gem")
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {value = self.value})
	end
end

function modifier_item_kaya_custom:OnDestroy()
	if not IsServer() then
		return
	end
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {value = self.value * -1})
	end
end

--------------------------------------------------------------------------------

function modifier_item_kaya_custom:DeclareFunctions()
	return	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
end

--------------------------------------------------------------------------------

function modifier_item_kaya_custom:GetModifierSpellAmplify_Percentage( params )

	local intellect = self:GetCaster():GetIntellect()
	local truedmg = intellect * self.bonus_dmg
	return truedmg
end

function modifier_item_kaya_custom:GetModifierBonusStats_Intellect( params )
	return self.bonus_int
end

function modifier_item_kaya_custom:GetModifierConstantManaRegen( params )
	return self.bonus_manaregen
end

function modifier_item_kaya_custom:OnTakeDamage(keys)
	if keys.attacker == self:GetParent() and not keys.unit:IsBuilding() and not keys.unit:IsOther() then	

		if keys.damage_category == 0 and keys.inflictor and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL) ~= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then

			self.lifesteal_pfx = ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
			ParticleManager:SetParticleControl(self.lifesteal_pfx, 0, keys.attacker:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.lifesteal_pfx)
			heal = keys.damage * (self.bonus_life / 100)
			if heal > 2^30 then
				heal = 2^30
			end
			keys.attacker:HealWithParams(heal, self:GetAbility(), true, true, self:GetParent(), true)
		end
	end
end