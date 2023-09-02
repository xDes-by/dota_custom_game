item_radiance_lua = class({})

item_radiance_lua1 = item_radiance_lua
item_radiance_lua2 = item_radiance_lua
item_radiance_lua3 = item_radiance_lua
item_radiance_lua4 = item_radiance_lua
item_radiance_lua5 = item_radiance_lua
item_radiance_lua6 = item_radiance_lua
item_radiance_lua7 = item_radiance_lua
item_radiance_lua8 = item_radiance_lua

item_radiance_lua1_gem1 = item_radiance_lua
item_radiance_lua2_gem1 = item_radiance_lua
item_radiance_lua3_gem1 = item_radiance_lua
item_radiance_lua4_gem1 = item_radiance_lua
item_radiance_lua5_gem1 = item_radiance_lua
item_radiance_lua6_gem1 = item_radiance_lua
item_radiance_lua7_gem1 = item_radiance_lua
item_radiance_lua8_gem1 = item_radiance_lua

item_radiance_lua1_gem2 = item_radiance_lua
item_radiance_lua2_gem2 = item_radiance_lua
item_radiance_lua3_gem2 = item_radiance_lua
item_radiance_lua4_gem2 = item_radiance_lua
item_radiance_lua5_gem2 = item_radiance_lua
item_radiance_lua6_gem2 = item_radiance_lua
item_radiance_lua7_gem2 = item_radiance_lua
item_radiance_lua8_gem2 = item_radiance_lua

item_radiance_lua1_gem3 = item_radiance_lua
item_radiance_lua2_gem3 = item_radiance_lua
item_radiance_lua3_gem3 = item_radiance_lua
item_radiance_lua4_gem3 = item_radiance_lua
item_radiance_lua5_gem3 = item_radiance_lua
item_radiance_lua6_gem3 = item_radiance_lua
item_radiance_lua7_gem3 = item_radiance_lua
item_radiance_lua8_gem3 = item_radiance_lua

item_radiance_lua1_gem4 = item_radiance_lua
item_radiance_lua2_gem4 = item_radiance_lua
item_radiance_lua3_gem4 = item_radiance_lua
item_radiance_lua4_gem4 = item_radiance_lua
item_radiance_lua5_gem4 = item_radiance_lua
item_radiance_lua6_gem4 = item_radiance_lua
item_radiance_lua7_gem4 = item_radiance_lua
item_radiance_lua8_gem4 = item_radiance_lua

item_radiance_lua1_gem5 = item_radiance_lua
item_radiance_lua2_gem5 = item_radiance_lua
item_radiance_lua3_gem5 = item_radiance_lua
item_radiance_lua4_gem5 = item_radiance_lua
item_radiance_lua5_gem5 = item_radiance_lua
item_radiance_lua6_gem5 = item_radiance_lua
item_radiance_lua7_gem5 = item_radiance_lua
item_radiance_lua8_gem5 = item_radiance_lua

LinkLuaModifier("modifier_item_radiance_lua", 'items/custom_items/item_radiance_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_radiance_burn_lua", 'items/custom_items/item_radiance_lua.lua', LUA_MODIFIER_MOTION_NONE)

function item_radiance_lua:GetIntrinsicModifierName()
	return "modifier_item_radiance_lua"
end

function item_radiance_lua:OnOwnerDied()
	self:ToggleAbility()
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
	self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_flameguard.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	if not IsServer() then
		return
	end
	self.value = self:GetAbility():GetSpecialValueFor("bonus_gem")
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {ability = self:GetAbility():entindex(), value = self.value})
	end
end

function modifier_item_radiance_lua:OnDestroy()
	ParticleManager:DestroyParticle(self.particle, false)
	ParticleManager:ReleaseParticleIndex(self.particle)
	if not IsServer() then
		return
	end
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {ability = self:GetAbility():entindex(), value = self.value * -1})
	end
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
if not self:GetAbility() then self:Destroy() return end
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
	return {MODIFIER_PROPERTY_MISS_PERCENTAGE}
end

function modifier_item_radiance_burn_lua:GetModifierMiss_Percentage()
	return self.blind
end