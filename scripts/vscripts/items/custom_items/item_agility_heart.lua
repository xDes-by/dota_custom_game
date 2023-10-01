item_agility_heart_lua = class({})

LinkLuaModifier("modifier_item_agility_heart_passive", 'items/custom_items/item_agility_heart.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_agility_heart_hast", 'items/custom_items/item_agility_heart.lua', LUA_MODIFIER_MOTION_NONE)

function item_agility_heart_lua:GetIntrinsicModifierName()
	return "modifier_item_agility_heart_passive"
end

function item_agility_heart_lua:OnSpellStart()
	if IsServer() then
		local parent = self:GetParent()
		local caster = self:GetCaster()
		self.duration = self:GetSpecialValueFor( "duration" )	
		caster:AddNewModifier( self:GetCaster(), self, "modifier_item_agility_heart_hast", { duration = self.duration } )
		self:GetCaster():EmitSound("DOTA_Item.PhaseBoots.Activate")
	end
end

-----------------------------------------------------------------------------------------------

modifier_item_agility_heart_passive = class({})

function modifier_item_agility_heart_passive:IsHidden()
	return true
end

function modifier_item_agility_heart_passive:IsPurgable()
	return false
end

function modifier_item_agility_heart_passive:DestroyOnExpire()
	return false
end

function modifier_item_agility_heart_passive:RemoveOnDeath()
	return false
end

function modifier_item_agility_heart_passive:OnCreated( kv )
	self.parent = self:GetParent()
    self.bonus_agi = self:GetAbility():GetSpecialValueFor("bonus_agi")
    self.bonus_dmg = self:GetAbility():GetSpecialValueFor("bonus_dmg")
	if not IsServer() then
		return
	end
	self.value = self:GetAbility():GetSpecialValueFor("bonus_gem")
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {value = self.value})
	end
end

function modifier_item_agility_heart_passive:OnDestroy()
	if not IsServer() then
		return
	end
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {value = self.value * -1})
	end
end

function modifier_item_agility_heart_passive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
	}
end

function modifier_item_agility_heart_passive:GetModifierBonusStats_Agility( params )
	return self.bonus_agi
end

function modifier_item_agility_heart_passive:GetModifierBaseAttack_BonusDamage( params )
	return self.bonus_dmg
end

-------------------------------------------------------------------------------------------------


modifier_item_agility_heart_hast = class({})

function modifier_item_agility_heart_hast:IsHidden()
	return false
end

function modifier_item_agility_heart_hast:IsPurgable()
	return false
end

function modifier_item_agility_heart_hast:OnCreated( kv )
    self.bonus_ms = self:GetAbility():GetSpecialValueFor("bonus_ms")
end

function modifier_item_agility_heart_hast:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
	}
end

function modifier_item_agility_heart_hast:GetModifierPreAttack_CriticalStrike( params )
	return self.bonus_ms
end
