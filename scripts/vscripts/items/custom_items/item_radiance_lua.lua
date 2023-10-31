item_radiance_lua = class({})

LinkLuaModifier("modifier_item_radiance_lua", 'items/custom_items/item_radiance_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_radiance_burn_lua", 'items/custom_items/item_radiance_lua.lua', LUA_MODIFIER_MOTION_NONE)

function item_radiance_lua:GetIntrinsicModifierName()
	return "modifier_item_radiance_lua"
end

function item_radiance_lua:GetAbilityTextureName()
	if not self:GetToggleState() then
		return "radiance_inactive_png"
	end
	
	local level = self:GetLevel()
	if self:GetSecondaryCharges() == 0 then
		return "all/rad_" .. level
	else
		return "gem" .. self:GetSecondaryCharges() .. "/item_radiance_lua" .. level
	end
end

function item_radiance_lua:ResetToggleOnRespawn()
	return true
end

function item_radiance_lua:OnToggle()
	if self:GetToggleState() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_radiance_aura_lua", {})
	else
		self:GetCaster():RemoveModifierByName("modifier_item_radiance_aura_lua")
	end
end

------------------------------------------------------------------------------------------------

modifier_item_radiance_lua = class({})

function modifier_item_radiance_lua:IsHidden()		
	return true 
end
function modifier_item_radiance_lua:IsPurgable()		
	return false 
end
function modifier_item_radiance_lua:GetAttributes()	
	return MODIFIER_ATTRIBUTE_MULTIPLE 
end

function modifier_item_radiance_lua:RemoveOnDeath()	
	return false 
end

function modifier_item_radiance_lua:OnCreated()
	self.parent = self:GetParent()
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	if not IsServer() then
		return
	end
	self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_flameguard.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
end

function modifier_item_radiance_lua:OnRefresh()
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_item_radiance_lua:OnDestroy()
	if not IsServer() then
		return
	end
	ParticleManager:DestroyParticle(self.particle, false)
	ParticleManager:ReleaseParticleIndex(self.particle)
end

function modifier_item_radiance_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
end

function modifier_item_radiance_lua:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_item_radiance_lua:IsAura()
	return true
end

function modifier_item_radiance_lua:GetAuraRadius()
	return 700
end

function modifier_item_radiance_lua:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_item_radiance_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_item_radiance_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_item_radiance_lua:GetModifierAura()
	return "modifier_item_radiance_burn_lua"
end

-----------------------------------------------------------

modifier_item_radiance_burn_lua = class({})

function modifier_item_radiance_burn_lua:OnCreated()
	if not self:GetAbility() then 
		self:Destroy() 
		return 
	end
	self.damage = self:GetAbility():GetSpecialValueFor("aura_damage")
	self.blind = self:GetAbility():GetSpecialValueFor("blind_pct")
	if self.particle == nil then
		self.particle = ParticleManager:CreateParticle("particles/items2_fx/radiance.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	end
	if not IsServer() then
		return
	end
	self:StartIntervalThink(1)
end

function modifier_item_radiance_burn_lua:OnDestroy()
	if self.particle ~= nil then
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
		self.particle = nil
	end	
end

function modifier_item_radiance_burn_lua:OnIntervalThink()
	ApplyDamage({
		attacker = self:GetCaster(), 
		victim = self:GetParent(),  
		damage = self.damage,
		ability = self:GetAbility(), 
		damage_type = DAMAGE_TYPE_MAGICAL
	})
end
------------------------------------------------

function modifier_item_radiance_burn_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MISS_PERCENTAGE
	}
end

function modifier_item_radiance_burn_lua:GetModifierMiss_Percentage()
	return self.blind
end