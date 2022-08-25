item_kaya_custom_lua1 = item_kaya_custom_lua1 or class({})
item_kaya_custom_lua2 = item_kaya_custom_lua1 or class({})
item_kaya_custom_lua3 = item_kaya_custom_lua1 or class({})
item_kaya_custom_lua4 = item_kaya_custom_lua1 or class({})
item_kaya_custom_lua5 = item_kaya_custom_lua1 or class({})
item_kaya_custom_lua6 = item_kaya_custom_lua1 or class({})
item_kaya_custom_lua7 = item_kaya_custom_lua1 or class({})
LinkLuaModifier( "modifier_item_kaya_custom", "items/custom_items/item_kaya_custom", LUA_MODIFIER_MOTION_NONE )

function item_kaya_custom_lua1:GetIntrinsicModifierName()
	return "modifier_item_kaya_custom"
end

modifier_item_kaya_custom = class({})

--------------------------------------------------------------------------------

function modifier_item_kaya_custom:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_item_kaya_custom:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_item_kaya_custom:OnCreated( kv )
		
		
		self.caster = self:GetCaster()
		self.bonus_dmg = self:GetAbility():GetSpecialValueFor( "bonus_dmg" )
		self.bonus_life = self:GetAbility():GetSpecialValueFor( "bonus_life" )
		self.bonus_int = self:GetAbility():GetSpecialValueFor( "bonus_int" )
		self.bonus_manaregen = self:GetAbility():GetSpecialValueFor( "mana_regen" )
		
		self.particle_name = "particles/items3_fx/octarine_core_lifesteal.vpcf"
end

--------------------------------------------------------------------------------

function modifier_item_kaya_custom:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_kaya_custom:GetModifierSpellAmplify_Percentage( params )
local intellect = self.caster:GetIntellect()
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
		if self:GetParent():FindAllModifiersByName(self:GetName())[1] == self and keys.damage_category == 0 and keys.inflictor and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL) ~= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
			self.lifesteal_pfx = ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
			ParticleManager:SetParticleControl(self.lifesteal_pfx, 0, keys.attacker:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.lifesteal_pfx)
			
			if keys.attacker:GetHealth() <= (keys.original_damage * (self.bonus_life / 100)) and keys.inflictor and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then
			keys.attacker:ForceKill(true)
			else
			keys.attacker:Heal(keys.original_damage * (self.bonus_life / 100), self)
			end
		end
	end
end