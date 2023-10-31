item_ring_of_flux_lua = class({})

LinkLuaModifier( "modifier_item_ring_of_flux_lua", "items/custom_items/item_ring_of_flux", LUA_MODIFIER_MOTION_NONE )

function item_ring_of_flux_lua:GetAbilityTextureName()
	local level = self:GetLevel()
	if self:GetSecondaryCharges() == 0 then
		return "all/ring" .. level
	else
		return "gem" .. self:GetSecondaryCharges() .. "/item_ring_of_flux_lua" .. level
	end
end

function item_ring_of_flux_lua:GetIntrinsicModifierName()
	return "modifier_item_ring_of_flux_lua"
end

modifier_item_ring_of_flux_lua = class({})

function modifier_item_ring_of_flux_lua:IsHidden()
	return true
end

function modifier_item_ring_of_flux_lua:IsPurgable()
	return false
end

function modifier_item_ring_of_flux_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_ring_of_flux_lua:OnCreated( kv )
	self.parent = self:GetParent()
	self.caster = self:GetCaster()
	self.cast_range = self:GetAbility():GetSpecialValueFor( "cast_range" )
	self.mana_back_chance = self:GetAbility():GetSpecialValueFor( "mana_back_chance" )
	self.spell_amp = self:GetAbility():GetSpecialValueFor( "spell_amp" )
	self.mana = self:GetAbility():GetSpecialValueFor( "mana" )
	self.manacostred = self:GetAbility():GetSpecialValueFor( "manacostred")
end

function modifier_item_ring_of_flux_lua:OnRefresh()
	self.parent = self:GetParent()
	self.caster = self:GetCaster()
	self.cast_range = self:GetAbility():GetSpecialValueFor( "cast_range" )
	self.mana_back_chance = self:GetAbility():GetSpecialValueFor( "mana_back_chance" )
	self.spell_amp = self:GetAbility():GetSpecialValueFor( "spell_amp" )
	self.mana = self:GetAbility():GetSpecialValueFor( "mana" )
	self.manacostred = self:GetAbility():GetSpecialValueFor( "manacostred")
end

function modifier_item_ring_of_flux_lua:DeclareFunctions()
	return	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS,
		MODIFIER_EVENT_ON_SPENT_MANA,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
	}
end

function modifier_item_ring_of_flux_lua:GetModifierManaBonus()
	return self.mana
end

function modifier_item_ring_of_flux_lua:GetModifierSpellAmplify_Percentage()
	return self.spell_amp
end

function modifier_item_ring_of_flux_lua:GetModifierCastRangeBonus()
	return self.cast_range
end

function modifier_item_ring_of_flux_lua:GetModifierPercentageManacost()
	return self.manacostred
end

function modifier_item_ring_of_flux_lua:OnSpentMana(keys)
	if keys.unit == self:GetParent() and not keys.ability:IsToggle() and not keys.ability:IsItem() and self:GetParent().GetMaxMana then
		if RollPercentage(self.mana_back_chance ) then
			self.proc_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_essence_effect.vpcf", PATTACH_ABSORIGIN, self:GetParent())
			ParticleManager:SetParticleControlEnt(self.proc_particle, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(self.proc_particle)
			keys.ability:RefundManaCost()
		end
	end
end
