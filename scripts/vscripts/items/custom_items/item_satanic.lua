LinkLuaModifier("modifier_satanic_lua", "items/custom_items/item_satanic", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_satanic_lua_active", "items/custom_items/item_satanic", LUA_MODIFIER_MOTION_NONE)

item_satanic_lua = class({})

function item_satanic_lua:GetAbilityTextureName()
	local level = self:GetLevel()
	if self:GetSecondaryCharges() == 0 then
		return "all/satanic" .. level
	else
		return "gem" .. self:GetSecondaryCharges() .. "/item_satanic_lua" .. level
	end
end

function item_satanic_lua:GetIntrinsicModifierName()
	if (self:GetItemSlot() > 5 or self:GetItemSlot() == -1) then
		return
	end
	return "modifier_satanic_lua"
end

function item_satanic_lua:OnSpellStart()
	EmitSoundOn("DOTA_Item.Satanic.Activate", self:GetCaster())
	self:GetCaster():Purge(false, true, false, false, false)
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_satanic_lua_active", {duration = self:GetSpecialValueFor("duration")})
end

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

modifier_satanic_lua = class({})

function modifier_satanic_lua:IsHidden() return true end
function modifier_satanic_lua:IsPurgable() return false end
function modifier_satanic_lua:RemoveOnDeath() return false end
function modifier_satanic_lua:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_satanic_lua:OnCreated()
	self.parent = self:GetParent()
	self.lifesteal_aura = self:GetAbility():GetSpecialValueFor("lifesteal_pct")
	self.damage_bonus = self:GetAbility():GetSpecialValueFor("damage_bonus")
	self.strength_bonus = self:GetAbility():GetSpecialValueFor("strength_bonus")
end

function modifier_satanic_lua:OnRefresh()
	self.parent = self:GetParent()
	self.lifesteal_aura = self:GetAbility():GetSpecialValueFor("lifesteal_pct")
	self.damage_bonus = self:GetAbility():GetSpecialValueFor("damage_bonus")
	self.strength_bonus = self:GetAbility():GetSpecialValueFor("strength_bonus")
end

function modifier_satanic_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_satanic_lua:OnAttackLanded( params )
	if self:GetParent() ~= params.attacker then
		return
	end
	local heal = params.damage * self.lifesteal_aura/100
	self:GetParent():HealWithParams(heal, self:GetAbility(), true, true, self:GetParent(), false)
	self:PlayEffects( self:GetParent() )
end

function modifier_satanic_lua:PlayEffects( target )
	local particle_cast = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function modifier_satanic_lua:GetModifierPreAttack_BonusDamage()
	return self.damage_bonus
end

function modifier_satanic_lua:GetModifierBonusStats_Strength()
	return self.strength_bonus
end

------------------------------------------------------------------------------------------------------

modifier_satanic_lua_active = class({})

function modifier_satanic_lua_active:GetEffectName()
	return "particles/items2_fx/satanic_buff.vpcf"
end

function modifier_satanic_lua_active:OnCreated()
	self.lifesteal_aura = self:GetAbility():GetSpecialValueFor("lifesteal_bonus")
end

function modifier_satanic_lua_active:OnRefresh()
	self.lifesteal_aura = self:GetAbility():GetSpecialValueFor("lifesteal_bonus")
end

function modifier_satanic_lua_active:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_satanic_lua_active:OnAttackLanded( params )	
	if self:GetParent() ~= params.attacker then
		return
	end
	local heal = params.damage * self.lifesteal_aura/100
	self:GetParent():HealWithParams(heal, self:GetAbility(), true, true, self:GetParent(), false)
	self:PlayEffects( self:GetParent() )
end

function modifier_satanic_lua_active:PlayEffects( target )
	local particle_cast = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end