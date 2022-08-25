item_satanic_lua1_gem1 = item_satanic_lua1_gem1 or class({})
item_satanic_lua2_gem1 = item_satanic_lua1_gem1 or class({})
item_satanic_lua3_gem1 = item_satanic_lua1_gem1 or class({})
item_satanic_lua4_gem1 = item_satanic_lua1_gem1 or class({})
item_satanic_lua5_gem1 = item_satanic_lua1_gem1 or class({})
item_satanic_lua6_gem1 = item_satanic_lua1_gem1 or class({})
item_satanic_lua7_gem1 = item_satanic_lua1_gem1 or class({})
item_satanic_lua8_gem1 = item_satanic_lua1_gem1 or class({})

item_satanic_lua1_gem2 = item_satanic_lua1_gem2 or class({})
item_satanic_lua2_gem2 = item_satanic_lua1_gem2 or class({})
item_satanic_lua3_gem2 = item_satanic_lua1_gem2 or class({})
item_satanic_lua4_gem2 = item_satanic_lua1_gem2 or class({})
item_satanic_lua5_gem2 = item_satanic_lua1_gem2 or class({})
item_satanic_lua6_gem2 = item_satanic_lua1_gem2 or class({})
item_satanic_lua7_gem2 = item_satanic_lua1_gem2 or class({})
item_satanic_lua8_gem2 = item_satanic_lua1_gem2 or class({})

item_satanic_lua1_gem3 = item_satanic_lua1_gem3 or class({})
item_satanic_lua2_gem3 = item_satanic_lua1_gem3 or class({})
item_satanic_lua3_gem3 = item_satanic_lua1_gem3 or class({})
item_satanic_lua4_gem3 = item_satanic_lua1_gem3 or class({})
item_satanic_lua5_gem3 = item_satanic_lua1_gem3 or class({})
item_satanic_lua6_gem3 = item_satanic_lua1_gem3 or class({})
item_satanic_lua7_gem3 = item_satanic_lua1_gem3 or class({})
item_satanic_lua8_gem3 = item_satanic_lua1_gem3 or class({})

item_satanic_lua1_gem4 = item_satanic_lua1_gem4 or class({})
item_satanic_lua2_gem4 = item_satanic_lua1_gem4 or class({})
item_satanic_lua3_gem4 = item_satanic_lua1_gem4 or class({})
item_satanic_lua4_gem4 = item_satanic_lua1_gem4 or class({})
item_satanic_lua5_gem4 = item_satanic_lua1_gem4 or class({})
item_satanic_lua6_gem4 = item_satanic_lua1_gem4 or class({})
item_satanic_lua7_gem4 = item_satanic_lua1_gem4 or class({})
item_satanic_lua8_gem4 = item_satanic_lua1_gem4 or class({})

item_satanic_lua1_gem5 = item_satanic_lua1_gem5 or class({})
item_satanic_lua2_gem5 = item_satanic_lua1_gem5 or class({})
item_satanic_lua3_gem5 = item_satanic_lua1_gem5 or class({})
item_satanic_lua4_gem5 = item_satanic_lua1_gem5 or class({})
item_satanic_lua5_gem5 = item_satanic_lua1_gem5 or class({})
item_satanic_lua6_gem5 = item_satanic_lua1_gem5 or class({})
item_satanic_lua7_gem5 = item_satanic_lua1_gem5 or class({})
item_satanic_lua8_gem5 = item_satanic_lua1_gem5 or class({})

LinkLuaModifier("modifier_gem1", 'items/items_gems/gem1', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem2", 'items/items_gems/gem2', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem3", 'items/items_gems/gem3', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem4", 'items/items_gems/gem4', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem5", 'items/items_gems/gem5', LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_satanic_lua1", "items/items_gems/item_satanic", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_satanic_lua2", "items/items_gems/item_satanic", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_satanic_lua3", "items/items_gems/item_satanic", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_satanic_lua4", "items/items_gems/item_satanic", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_satanic_lua5", "items/items_gems/item_satanic", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_satanic_lua_active", "items/items_gems/item_satanic", LUA_MODIFIER_MOTION_NONE)

--item_satanic_lua1_gem1
function item_satanic_lua1_gem1:GetIntrinsicModifierName()
	return "modifier_satanic_lua1"
end

function item_satanic_lua1_gem1:OnSpellStart()
	EmitSoundOn("DOTA_Item.Satanic.Activate", self:GetCaster())
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_satanic_lua_active", {duration = self:GetSpecialValueFor("duration")})
end
--item_satanic_lua1_gem2
function item_satanic_lua1_gem2:GetIntrinsicModifierName()
	return "modifier_satanic_lua2"
end

function item_satanic_lua1_gem2:OnSpellStart()
	EmitSoundOn("DOTA_Item.Satanic.Activate", self:GetCaster())
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_satanic_lua_active", {duration = self:GetSpecialValueFor("duration")})
end
--item_satanic_lua1_gem3
function item_satanic_lua1_gem3:GetIntrinsicModifierName()
	return "modifier_satanic_lua3"
end

function item_satanic_lua1_gem3:OnSpellStart()
	EmitSoundOn("DOTA_Item.Satanic.Activate", self:GetCaster())
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_satanic_lua_active", {duration = self:GetSpecialValueFor("duration")})
end
--item_satanic_lua1_gem4
function item_satanic_lua1_gem4:GetIntrinsicModifierName()
	return "modifier_satanic_lua4"
end

function item_satanic_lua1_gem4:OnSpellStart()
	EmitSoundOn("DOTA_Item.Satanic.Activate", self:GetCaster())
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_satanic_lua_active", {duration = self:GetSpecialValueFor("duration")})
end
--item_satanic_lua1_gem5
function item_satanic_lua1_gem5:GetIntrinsicModifierName()
	return "modifier_satanic_lua5"
end

function item_satanic_lua1_gem5:OnSpellStart()
	EmitSoundOn("DOTA_Item.Satanic.Activate", self:GetCaster())
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_satanic_lua_active", {duration = self:GetSpecialValueFor("duration")})
end
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

modifier_satanic_lua1 = class({})

function modifier_satanic_lua1:IsHidden() return true end
function modifier_satanic_lua1:IsPurgable() return false end
function modifier_satanic_lua1:RemoveOnDeath() return false end

function modifier_satanic_lua1:OnCreated()
self.lifesteal_aura = self:GetAbility():GetSpecialValueFor("lifesteal_pct")

	
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_satanic_lua1:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_satanic_lua1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_satanic_lua1:OnAttackLanded( params )
	if IsServer() then
	local attacker = self:GetParent()	
	if attacker ~= params.attacker then
		return
	end
		local heal = params.damage * self.lifesteal_aura/100
		self:GetParent():Heal( heal, self:GetAbility() )
		self:PlayEffects( self:GetParent() )
	end
end

function modifier_satanic_lua1:PlayEffects( target )
	local particle_cast = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function modifier_satanic_lua1:GetModifierPreAttack_BonusDamage()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("damage_bonus")
	end
end

function modifier_satanic_lua1:GetModifierBonusStats_Strength()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("strength_bonus")
	end
end

modifier_satanic_lua2 = class({})

function modifier_satanic_lua2:IsHidden() return true end
function modifier_satanic_lua2:IsPurgable() return false end
function modifier_satanic_lua2:RemoveOnDeath() return false end

function modifier_satanic_lua2:OnCreated()
self.lifesteal_aura = self:GetAbility():GetSpecialValueFor("lifesteal_pct")

	
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_satanic_lua2:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_satanic_lua2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_satanic_lua2:OnAttackLanded( params )
	if IsServer() then
	local attacker = self:GetParent()	
	if attacker ~= params.attacker then
		return
	end
		local heal = params.damage * self.lifesteal_aura/100
		self:GetParent():Heal( heal, self:GetAbility() )
		self:PlayEffects( self:GetParent() )
	end
end

function modifier_satanic_lua2:PlayEffects( target )
	local particle_cast = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function modifier_satanic_lua2:GetModifierPreAttack_BonusDamage()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("damage_bonus")
	end
end

function modifier_satanic_lua2:GetModifierBonusStats_Strength()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("strength_bonus")
	end
end

modifier_satanic_lua3 = class({})

function modifier_satanic_lua3:IsHidden() return true end
function modifier_satanic_lua3:IsPurgable() return false end
function modifier_satanic_lua3:RemoveOnDeath() return false end

function modifier_satanic_lua3:OnCreated()
self.lifesteal_aura = self:GetAbility():GetSpecialValueFor("lifesteal_pct")

	
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_satanic_lua3:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_satanic_lua3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_satanic_lua3:OnAttackLanded( params )
	if IsServer() then
	local attacker = self:GetParent()	
	if attacker ~= params.attacker then
		return
	end
		local heal = params.damage * self.lifesteal_aura/100
		self:GetParent():Heal( heal, self:GetAbility() )
		self:PlayEffects( self:GetParent() )
	end
end

function modifier_satanic_lua3:PlayEffects( target )
	local particle_cast = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function modifier_satanic_lua3:GetModifierPreAttack_BonusDamage()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("damage_bonus")
	end
end

function modifier_satanic_lua3:GetModifierBonusStats_Strength()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("strength_bonus")
	end
end

modifier_satanic_lua4 = class({})

function modifier_satanic_lua4:IsHidden() return true end
function modifier_satanic_lua4:IsPurgable() return false end
function modifier_satanic_lua4:RemoveOnDeath() return false end

function modifier_satanic_lua4:OnCreated()
self.lifesteal_aura = self:GetAbility():GetSpecialValueFor("lifesteal_pct")

	
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_satanic_lua4:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_satanic_lua4:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_satanic_lua4:OnAttackLanded( params )
	if IsServer() then
	local attacker = self:GetParent()	
	if attacker ~= params.attacker then
		return
	end
		local heal = params.damage * self.lifesteal_aura/100
		self:GetParent():Heal( heal, self:GetAbility() )
		self:PlayEffects( self:GetParent() )
	end
end

function modifier_satanic_lua4:PlayEffects( target )
	local particle_cast = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function modifier_satanic_lua4:GetModifierPreAttack_BonusDamage()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("damage_bonus")
	end
end

function modifier_satanic_lua4:GetModifierBonusStats_Strength()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("strength_bonus")
	end
end

modifier_satanic_lua5 = class({})

function modifier_satanic_lua5:IsHidden() return true end
function modifier_satanic_lua5:IsPurgable() return false end
function modifier_satanic_lua5:RemoveOnDeath() return false end

function modifier_satanic_lua5:OnCreated()
self.lifesteal_aura = self:GetAbility():GetSpecialValueFor("lifesteal_pct")

	
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_satanic_lua5:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_satanic_lua5:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_satanic_lua5:OnAttackLanded( params )
	if IsServer() then
	local attacker = self:GetParent()	
	if attacker ~= params.attacker then
		return
	end
		local heal = params.damage * self.lifesteal_aura/100
		self:GetParent():Heal( heal, self:GetAbility() )
		self:PlayEffects( self:GetParent() )
	end
end

function modifier_satanic_lua5:PlayEffects( target )
	local particle_cast = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function modifier_satanic_lua5:GetModifierPreAttack_BonusDamage()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("damage_bonus")
	end
end

function modifier_satanic_lua5:GetModifierBonusStats_Strength()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("strength_bonus")
	end
end

------------------------------------------------------------------------------------------------------

modifier_satanic_lua_active = modifier_satanic_lua_active or class({})

function modifier_satanic_lua_active:GetEffectName()
	return "particles/items2_fx/satanic_buff.vpcf"
end

function modifier_satanic_lua_active:OnCreated()
self.lifesteal_aura = self:GetAbility():GetSpecialValueFor("lifesteal_bonus")
end

function modifier_satanic_lua_active:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_satanic_lua_active:OnAttackLanded( params )
	if IsServer() then
	local attacker = self:GetParent()	
	if attacker ~= params.attacker then
		return
	end
		local heal = params.damage * self.lifesteal_aura/100
		self:GetParent():Heal( heal, self:GetAbility() )
		self:PlayEffects( self:GetParent() )
	end
end

function modifier_satanic_lua_active:PlayEffects( target )
	local particle_cast = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end