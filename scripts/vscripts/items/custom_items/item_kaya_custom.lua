item_kaya_custom_lua = class({})

item_kaya_custom_lua1 = item_kaya_custom_lua
item_kaya_custom_lua2 = item_kaya_custom_lua
item_kaya_custom_lua3 = item_kaya_custom_lua
item_kaya_custom_lua4 = item_kaya_custom_lua
item_kaya_custom_lua5 = item_kaya_custom_lua
item_kaya_custom_lua6 = item_kaya_custom_lua
item_kaya_custom_lua7 = item_kaya_custom_lua
item_kaya_custom_lua8 = item_kaya_custom_lua

item_kaya_custom_lua1_gem1 = item_kaya_custom_lua
item_kaya_custom_lua2_gem1 = item_kaya_custom_lua
item_kaya_custom_lua3_gem1 = item_kaya_custom_lua
item_kaya_custom_lua4_gem1 = item_kaya_custom_lua
item_kaya_custom_lua5_gem1 = item_kaya_custom_lua
item_kaya_custom_lua6_gem1 = item_kaya_custom_lua
item_kaya_custom_lua7_gem1 = item_kaya_custom_lua
item_kaya_custom_lua8_gem1 = item_kaya_custom_lua

item_kaya_custom_lua1_gem2 = item_kaya_custom_lua
item_kaya_custom_lua2_gem2 = item_kaya_custom_lua
item_kaya_custom_lua3_gem2 = item_kaya_custom_lua
item_kaya_custom_lua4_gem2 = item_kaya_custom_lua
item_kaya_custom_lua5_gem2 = item_kaya_custom_lua
item_kaya_custom_lua6_gem2 = item_kaya_custom_lua
item_kaya_custom_lua7_gem2 = item_kaya_custom_lua
item_kaya_custom_lua8_gem2 = item_kaya_custom_lua

item_kaya_custom_lua1_gem3 = item_kaya_custom_lua
item_kaya_custom_lua2_gem3 = item_kaya_custom_lua
item_kaya_custom_lua3_gem3 = item_kaya_custom_lua
item_kaya_custom_lua4_gem3 = item_kaya_custom_lua
item_kaya_custom_lua5_gem3 = item_kaya_custom_lua
item_kaya_custom_lua6_gem3 = item_kaya_custom_lua
item_kaya_custom_lua7_gem3 = item_kaya_custom_lua
item_kaya_custom_lua8_gem3 = item_kaya_custom_lua

item_kaya_custom_lua1_gem4 = item_kaya_custom_lua
item_kaya_custom_lua2_gem4 = item_kaya_custom_lua
item_kaya_custom_lua3_gem4 = item_kaya_custom_lua
item_kaya_custom_lua4_gem4 = item_kaya_custom_lua
item_kaya_custom_lua5_gem4 = item_kaya_custom_lua
item_kaya_custom_lua6_gem4 = item_kaya_custom_lua
item_kaya_custom_lua7_gem4 = item_kaya_custom_lua
item_kaya_custom_lua8_gem4 = item_kaya_custom_lua

item_kaya_custom_lua1_gem5 = item_kaya_custom_lua
item_kaya_custom_lua2_gem5 = item_kaya_custom_lua
item_kaya_custom_lua3_gem5 = item_kaya_custom_lua
item_kaya_custom_lua4_gem5 = item_kaya_custom_lua
item_kaya_custom_lua5_gem5 = item_kaya_custom_lua
item_kaya_custom_lua6_gem5 = item_kaya_custom_lua
item_kaya_custom_lua7_gem5 = item_kaya_custom_lua
item_kaya_custom_lua8_gem5 = item_kaya_custom_lua

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