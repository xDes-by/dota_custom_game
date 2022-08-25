item_radiance_lua1_gem1 = item_radiance_lua1_gem1 or class({})
item_radiance_lua2_gem1 = item_radiance_lua1_gem1 or class({})
item_radiance_lua3_gem1 = item_radiance_lua1_gem1 or class({})
item_radiance_lua4_gem1 = item_radiance_lua1_gem1 or class({})
item_radiance_lua5_gem1 = item_radiance_lua1_gem1 or class({})
item_radiance_lua6_gem1 = item_radiance_lua1_gem1 or class({})
item_radiance_lua7_gem1 = item_radiance_lua1_gem1 or class({})
item_radiance_lua8_gem1 = item_radiance_lua1_gem1 or class({})

item_radiance_lua1_gem2 = item_radiance_lua1_gem2 or class({})
item_radiance_lua2_gem2 = item_radiance_lua1_gem2 or class({})
item_radiance_lua3_gem2 = item_radiance_lua1_gem2 or class({})
item_radiance_lua4_gem2 = item_radiance_lua1_gem2 or class({})
item_radiance_lua5_gem2 = item_radiance_lua1_gem2 or class({})
item_radiance_lua6_gem2 = item_radiance_lua1_gem2 or class({})
item_radiance_lua7_gem2 = item_radiance_lua1_gem2 or class({})
item_radiance_lua8_gem2 = item_radiance_lua1_gem2 or class({})

item_radiance_lua1_gem3 = item_radiance_lua1_gem3 or class({})
item_radiance_lua2_gem3 = item_radiance_lua1_gem3 or class({})
item_radiance_lua3_gem3 = item_radiance_lua1_gem3 or class({})
item_radiance_lua4_gem3 = item_radiance_lua1_gem3 or class({})
item_radiance_lua5_gem3 = item_radiance_lua1_gem3 or class({})
item_radiance_lua6_gem3 = item_radiance_lua1_gem3 or class({})
item_radiance_lua7_gem3 = item_radiance_lua1_gem3 or class({})
item_radiance_lua8_gem3 = item_radiance_lua1_gem3 or class({})

item_radiance_lua1_gem4 = item_radiance_lua1_gem4 or class({})
item_radiance_lua2_gem4 = item_radiance_lua1_gem4 or class({})
item_radiance_lua3_gem4 = item_radiance_lua1_gem4 or class({})
item_radiance_lua4_gem4 = item_radiance_lua1_gem4 or class({})
item_radiance_lua5_gem4 = item_radiance_lua1_gem4 or class({})
item_radiance_lua6_gem4 = item_radiance_lua1_gem4 or class({})
item_radiance_lua7_gem4 = item_radiance_lua1_gem4 or class({})
item_radiance_lua8_gem4 = item_radiance_lua1_gem4 or class({})

item_radiance_lua1_gem5 = item_radiance_lua1_gem5 or class({})
item_radiance_lua2_gem5 = item_radiance_lua1_gem5 or class({})
item_radiance_lua3_gem5 = item_radiance_lua1_gem5 or class({})
item_radiance_lua4_gem5 = item_radiance_lua1_gem5 or class({})
item_radiance_lua5_gem5 = item_radiance_lua1_gem5 or class({})
item_radiance_lua6_gem5 = item_radiance_lua1_gem5 or class({})
item_radiance_lua7_gem5 = item_radiance_lua1_gem5 or class({})
item_radiance_lua8_gem5 = item_radiance_lua1_gem5 or class({})

LinkLuaModifier("modifier_gem1", 'items/items_gems/gem1', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem2", 'items/items_gems/gem2', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem3", 'items/items_gems/gem3', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem4", 'items/items_gems/gem4', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem5", 'items/items_gems/gem5', LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_item_radiance_lua1", 'items/items_gems/item_radiance_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_radiance_lua2", 'items/items_gems/item_radiance_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_radiance_lua3", 'items/items_gems/item_radiance_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_radiance_lua4", 'items/items_gems/item_radiance_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_radiance_lua5", 'items/items_gems/item_radiance_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_radiance_aura_lua", 'items/items_gems/item_radiance_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_radiance_burn_lua", 'items/items_gems/item_radiance_lua.lua', LUA_MODIFIER_MOTION_NONE)

function item_radiance_lua1_gem1:GetIntrinsicModifierName()
	return "modifier_item_radiance_lua1"
end
function item_radiance_lua1_gem2:GetIntrinsicModifierName()
	return "modifier_item_radiance_lua2"
end
function item_radiance_lua1_gem3:GetIntrinsicModifierName()
	return "modifier_item_radiance_lua3"
end
function item_radiance_lua1_gem4:GetIntrinsicModifierName()
	return "modifier_item_radiance_lua4"
end
function item_radiance_lua1_gem5:GetIntrinsicModifierName()
	return "modifier_item_radiance_lua5"
end

function item_radiance_lua1_gem1:OnToggle()
	if self:GetToggleState() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_radiance_aura_lua", {})
	else
		self:GetCaster():RemoveModifierByName("modifier_item_radiance_aura_lua")
	end
end

function item_radiance_lua1_gem2:OnToggle()
	if self:GetToggleState() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_radiance_aura_lua", {})
	else
		self:GetCaster():RemoveModifierByName("modifier_item_radiance_aura_lua")
	end
end

function item_radiance_lua1_gem3:OnToggle()
	if self:GetToggleState() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_radiance_aura_lua", {})
	else
		self:GetCaster():RemoveModifierByName("modifier_item_radiance_aura_lua")
	end
end

function item_radiance_lua1_gem4:OnToggle()
	if self:GetToggleState() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_radiance_aura_lua", {})
	else
		self:GetCaster():RemoveModifierByName("modifier_item_radiance_aura_lua")
	end
end

function item_radiance_lua1_gem5:OnToggle()
	if self:GetToggleState() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_radiance_aura_lua", {})
	else
		self:GetCaster():RemoveModifierByName("modifier_item_radiance_aura_lua")
	end
end

------------------------------------------------------------------------------------------------

modifier_item_radiance_lua1 = class({})

function modifier_item_radiance_lua1:IsHidden()		
	return true 
end
function modifier_item_radiance_lua1:IsPurgable()		
	return false 
end

function modifier_item_radiance_lua1:RemoveOnDeath()	
	return false 
end

function modifier_item_radiance_lua1:OnCreated()
	
	
	if not self:GetCaster():HasModifier("modifier_item_radiance_aura_lua") then
	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_radiance_aura_lua", {})
	end
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_radiance_lua1:OnDestroy()
	if not self:GetCaster():HasModifier("modifier_item_radiance_lua1") then
		self:GetCaster():RemoveModifierByName("modifier_item_radiance_aura_lua")
	end
	if self.particle ~= nil then
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
		self.particle = nil
	end	

	if not IsServer() then return end 
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_radiance_lua1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
end

function modifier_item_radiance_lua1:GetModifierPreAttack_BonusDamage()
	if self:GetAbility() then
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
	end
end
------------------------------------------------------------------------------------------------

modifier_item_radiance_lua2 = class({})

function modifier_item_radiance_lua2:IsHidden()		
	return true 
end
function modifier_item_radiance_lua2:IsPurgable()		
	return false 
end


function modifier_item_radiance_lua2:RemoveOnDeath()	
	return false 
end

function modifier_item_radiance_lua2:OnCreated()
	
	
	if not self:GetCaster():HasModifier("modifier_item_radiance_aura_lua") then
	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_radiance_aura_lua", {})
	end
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_radiance_lua2:OnDestroy()
	if not self:GetCaster():HasModifier("modifier_item_radiance_lua2") then
		self:GetCaster():RemoveModifierByName("modifier_item_radiance_aura_lua")
	end
	if self.particle ~= nil then
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
		self.particle = nil
	end	

	if not IsServer() then return end 
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_radiance_lua2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
end

function modifier_item_radiance_lua2:GetModifierPreAttack_BonusDamage()
	if self:GetAbility() then
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
	end
end
------------------------------------------------------------------------------------------------

modifier_item_radiance_lua3 = class({})

function modifier_item_radiance_lua3:IsHidden()		
	return true 
end
function modifier_item_radiance_lua3:IsPurgable()		
	return false 
end


function modifier_item_radiance_lua3:RemoveOnDeath()	
	return false 
end

function modifier_item_radiance_lua3:OnCreated()
	
	
	if not self:GetCaster():HasModifier("modifier_item_radiance_aura_lua") then
	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_radiance_aura_lua", {})
	end
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_radiance_lua3:OnDestroy()
	if not self:GetCaster():HasModifier("modifier_item_radiance_lua3") then
		self:GetCaster():RemoveModifierByName("modifier_item_radiance_aura_lua")
	end
	if self.particle ~= nil then
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
		self.particle = nil
	end	

	if not IsServer() then return end 
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_radiance_lua3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
end

function modifier_item_radiance_lua3:GetModifierPreAttack_BonusDamage()
	if self:GetAbility() then
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
	end
end
------------------------------------------------------------------------------------------------

modifier_item_radiance_lua4 = class({})

function modifier_item_radiance_lua4:IsHidden()		
	return true 
end
function modifier_item_radiance_lua4:IsPurgable()		
	return false 
end


function modifier_item_radiance_lua4:RemoveOnDeath()	
	return false 
end

function modifier_item_radiance_lua4:OnCreated()
	
	
	if not self:GetCaster():HasModifier("modifier_item_radiance_aura_lua") then
	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_radiance_aura_lua", {})
	end
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_radiance_lua4:OnDestroy()
	if not self:GetCaster():HasModifier("modifier_item_radiance_lua4") then
		self:GetCaster():RemoveModifierByName("modifier_item_radiance_aura_lua")
	end
	if self.particle ~= nil then
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
		self.particle = nil
	end	

	if not IsServer() then return end 
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_radiance_lua4:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
end

function modifier_item_radiance_lua4:GetModifierPreAttack_BonusDamage()
	if self:GetAbility() then
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
	end
end
------------------------------------------------------------------------------------------------

modifier_item_radiance_lua5 = class({})

function modifier_item_radiance_lua5:IsHidden()		
	return true 
end
function modifier_item_radiance_lua5:IsPurgable()		
	return false 
end


function modifier_item_radiance_lua5:RemoveOnDeath()	
	return false 
end

function modifier_item_radiance_lua5:OnCreated()
	
	
	if not self:GetCaster():HasModifier("modifier_item_radiance_aura_lua") then
	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_radiance_aura_lua", {})
	end
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_radiance_lua5:OnDestroy()
	if not self:GetCaster():HasModifier("modifier_item_radiance_lua5") then
		self:GetCaster():RemoveModifierByName("modifier_item_radiance_aura_lua")
	end
	if self.particle ~= nil then
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
		self.particle = nil
	end	

	if not IsServer() then return end 
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_radiance_lua5:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
end

function modifier_item_radiance_lua5:GetModifierPreAttack_BonusDamage()
	if self:GetAbility() then
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
	end
end

-------------------------------------------------------------------

modifier_item_radiance_aura_lua = class({})

function modifier_item_radiance_aura_lua:RemoveOnDeath()	
	return false 
end

function modifier_item_radiance_aura_lua:IsAura()
	return true
end

function modifier_item_radiance_aura_lua:GetAuraRadius()
	return 700
end

function modifier_item_radiance_aura_lua:OnCreated()
	--self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_flameguard.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
end

function modifier_item_radiance_aura_lua:OnDestroy()
	--ParticleManager:DestroyParticle(self.particle, false)
	--ParticleManager:ReleaseParticleIndex(self.particle)
end

function modifier_item_radiance_aura_lua:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_item_radiance_aura_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_item_radiance_aura_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_item_radiance_aura_lua:GetModifierAura()
	return "modifier_item_radiance_burn_lua"
end

-----------------------------------------------------------

modifier_item_radiance_burn_lua = class({})

function modifier_item_radiance_burn_lua:OnCreated()
if not self:GetAbility() then self:Destroy() return end
	self.damage = self:GetAbility():GetSpecialValueFor("aura_damage")
	self.blind = self:GetAbility():GetSpecialValueFor("blind_pct")
	-- if self.particle == nil then
		-- self.particle = ParticleManager:CreateParticle("particles/items2_fx/radiance.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	-- end
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

	if IsServer() then
				ApplyDamage({attacker = self:GetCaster(), 
							victim = self:GetParent(),  
							damage = self.damage,
							ability = self:GetAbility(), 
							damage_type = DAMAGE_TYPE_MAGICAL})
	end
end
------------------------------------------------

function modifier_item_radiance_burn_lua:DeclareFunctions()
	return {MODIFIER_PROPERTY_MISS_PERCENTAGE}
end

function modifier_item_radiance_burn_lua:GetModifierMiss_Percentage()
	return self.blind
end