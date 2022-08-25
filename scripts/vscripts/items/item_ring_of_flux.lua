item_ring_of_flux_lua1 = item_ring_of_flux_lua1 or class({})
item_ring_of_flux_lua2 = item_ring_of_flux_lua1 or class({})
item_ring_of_flux_lua3 = item_ring_of_flux_lua1 or class({})
item_ring_of_flux_lua4 = item_ring_of_flux_lua1 or class({})
item_ring_of_flux_lua5 = item_ring_of_flux_lua1 or class({})
item_ring_of_flux_lua6 = item_ring_of_flux_lua1 or class({})
item_ring_of_flux_lua7 = item_ring_of_flux_lua1 or class({})
item_ring_of_flux_lua8 = item_ring_of_flux_lua1 or class({})

LinkLuaModifier( "modifier_item_ring_of_flux_lua", "items/item_ring_of_flux", LUA_MODIFIER_MOTION_NONE )

function item_ring_of_flux_lua1:GetIntrinsicModifierName()
	return "modifier_item_ring_of_flux_lua"
end

modifier_item_ring_of_flux_lua = class({})

--------------------------------------------------------------------------------

function modifier_item_ring_of_flux_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_item_ring_of_flux_lua:IsPurgable()
	return false
end
function modifier_item_ring_of_flux_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
--------------------------------------------------------------------------------

function modifier_item_ring_of_flux_lua:OnCreated( kv )	
	self.caster = self:GetCaster()
	self.cast_range = self:GetAbility():GetSpecialValueFor( "cast_range" )
	self.mana_back_chance = self:GetAbility():GetSpecialValueFor( "mana_back_chance" )
	self.spell_amp = self:GetAbility():GetSpecialValueFor( "spell_amp" )
	self.mana = self:GetAbility():GetSpecialValueFor( "mana" )
	self.manacostred = self:GetAbility():GetSpecialValueFor( "manacostred")
end

--------------------------------------------------------------------------------

function modifier_item_ring_of_flux_lua:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS,
		MODIFIER_EVENT_ON_SPENT_MANA,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_ring_of_flux_lua:GetModifierManaBonus( params )
	return self.mana
end

function modifier_item_ring_of_flux_lua:GetModifierSpellAmplify_Percentage( params )
	return self.spell_amp
end

function modifier_item_ring_of_flux_lua:GetModifierCastRangeBonus( params )
	return self.cast_range
end

function modifier_item_ring_of_flux_lua:GetModifierPercentageManacost( params )
	return self.manacostred
end

function modifier_item_ring_of_flux_lua:OnSpentMana(keys)
	if keys.unit == self:GetParent() and not keys.ability:IsToggle() and not keys.ability:IsItem() and self:GetParent().GetMaxMana then
		self:RollForProc()
	end
end

function modifier_item_ring_of_flux_lua:RollForProc()
	chance = self:GetAbility():GetSpecialValueFor( "mana_back_chance" )
	local ran = RandomInt(1,100)
		if ran <= chance then
		self.proc_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_essence_effect.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:SetParticleControlEnt(self.proc_particle, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(self.proc_particle)
	
		self:GetParent():GiveMana(self:GetParent():GetMaxMana() * self:GetAbility():GetSpecialValueFor( "mana_back" ) * 0.01)
	end
end

