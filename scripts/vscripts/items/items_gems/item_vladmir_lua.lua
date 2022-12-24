item_vladmir_lua1_gem1 = item_vladmir_lua1_gem1 or class({})
item_vladmir_lua2_gem1 = item_vladmir_lua1_gem1 or class({})
item_vladmir_lua3_gem1 = item_vladmir_lua1_gem1 or class({})
item_vladmir_lua4_gem1 = item_vladmir_lua1_gem1 or class({})
item_vladmir_lua5_gem1 = item_vladmir_lua1_gem1 or class({})
item_vladmir_lua6_gem1 = item_vladmir_lua1_gem1 or class({})
item_vladmir_lua7_gem1 = item_vladmir_lua1_gem1 or class({})
item_vladmir_lua8_gem1 = item_vladmir_lua1_gem1 or class({})

item_vladmir_lua1_gem2 = item_vladmir_lua1_gem2 or class({})
item_vladmir_lua2_gem2 = item_vladmir_lua1_gem2 or class({})
item_vladmir_lua3_gem2 = item_vladmir_lua1_gem2 or class({})
item_vladmir_lua4_gem2 = item_vladmir_lua1_gem2 or class({})
item_vladmir_lua5_gem2 = item_vladmir_lua1_gem2 or class({})
item_vladmir_lua6_gem2 = item_vladmir_lua1_gem2 or class({})
item_vladmir_lua7_gem2 = item_vladmir_lua1_gem2 or class({})
item_vladmir_lua8_gem2 = item_vladmir_lua1_gem2 or class({})

item_vladmir_lua1_gem3 = item_vladmir_lua1_gem3 or class({})
item_vladmir_lua2_gem3 = item_vladmir_lua1_gem3 or class({})
item_vladmir_lua3_gem3 = item_vladmir_lua1_gem3 or class({})
item_vladmir_lua4_gem3 = item_vladmir_lua1_gem3 or class({})
item_vladmir_lua5_gem3 = item_vladmir_lua1_gem3 or class({})
item_vladmir_lua6_gem3 = item_vladmir_lua1_gem3 or class({})
item_vladmir_lua7_gem3 = item_vladmir_lua1_gem3 or class({})
item_vladmir_lua8_gem3 = item_vladmir_lua1_gem3 or class({})

item_vladmir_lua1_gem4 = item_vladmir_lua1_gem4 or class({})
item_vladmir_lua2_gem4 = item_vladmir_lua1_gem4 or class({})
item_vladmir_lua3_gem4 = item_vladmir_lua1_gem4 or class({})
item_vladmir_lua4_gem4 = item_vladmir_lua1_gem4 or class({})
item_vladmir_lua5_gem4 = item_vladmir_lua1_gem4 or class({})
item_vladmir_lua6_gem4 = item_vladmir_lua1_gem4 or class({})
item_vladmir_lua7_gem4 = item_vladmir_lua1_gem4 or class({})
item_vladmir_lua8_gem4 = item_vladmir_lua1_gem4 or class({})

item_vladmir_lua1_gem5 = item_vladmir_lua1_gem5 or class({})
item_vladmir_lua2_gem5 = item_vladmir_lua1_gem5 or class({})
item_vladmir_lua3_gem5 = item_vladmir_lua1_gem5 or class({})
item_vladmir_lua4_gem5 = item_vladmir_lua1_gem5 or class({})
item_vladmir_lua5_gem5 = item_vladmir_lua1_gem5 or class({})
item_vladmir_lua6_gem5 = item_vladmir_lua1_gem5 or class({})
item_vladmir_lua7_gem5 = item_vladmir_lua1_gem5 or class({})
item_vladmir_lua8_gem5 = item_vladmir_lua1_gem5 or class({})

LinkLuaModifier("modifier_gem1", 'items/items_gems/gem1', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem2", 'items/items_gems/gem2', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem3", 'items/items_gems/gem3', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem4", 'items/items_gems/gem4', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem5", 'items/items_gems/gem5', LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_item_vladmir_lua1", 'items/items_gems/item_vladmir_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_vladmir_lua2", 'items/items_gems/item_vladmir_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_vladmir_lua3", 'items/items_gems/item_vladmir_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_vladmir_lua4", 'items/items_gems/item_vladmir_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_vladmir_lua5", 'items/items_gems/item_vladmir_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_vladmir_aura_lua", 'items/custom_items/item_vladmir_lua.lua', LUA_MODIFIER_MOTION_NONE)

function item_vladmir_lua1_gem1:GetIntrinsicModifierName()
	return "modifier_item_vladmir_lua1"
end
function item_vladmir_lua1_gem2:GetIntrinsicModifierName()
	return "modifier_item_vladmir_lua2"
end
function item_vladmir_lua1_gem3:GetIntrinsicModifierName()
	return "modifier_item_vladmir_lua3"
end
function item_vladmir_lua1_gem4:GetIntrinsicModifierName()
	return "modifier_item_vladmir_lua4"
end
function item_vladmir_lua1_gem5:GetIntrinsicModifierName()
	return "modifier_item_vladmir_lua5"
end

modifier_item_vladmir_lua1 = class({})

function modifier_item_vladmir_lua1:IsHidden() return true end
function modifier_item_vladmir_lua1:IsPurgable() return false end
function modifier_item_vladmir_lua1:RemoveOnDeath() return false end

function modifier_item_vladmir_lua1:OnCreated()
	self.armor_aura = self:GetAbility():GetSpecialValueFor("armor_aura")
	self.mana_regen_aura = self:GetAbility():GetSpecialValueFor("mana_regen_aura")
	self.lifesteal_aura = self:GetAbility():GetSpecialValueFor("lifesteal_aura")
	self.damage_aura = self:GetAbility():GetSpecialValueFor("damage_aura")
	self.aura_radius = self:GetAbility():GetSpecialValueFor("aura_radius")
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end
function modifier_item_vladmir_lua1:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end
function modifier_item_vladmir_lua1:GetAuraRadius()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("aura_radius")
	end
end


function modifier_item_vladmir_lua1:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_item_vladmir_lua1:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_item_vladmir_lua1:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_item_vladmir_lua1:GetModifierAura()
	return "modifier_item_vladmir_aura_lua"
end

function modifier_item_vladmir_lua1:IsAura()
	return true
end

modifier_item_vladmir_lua2 = class({})

function modifier_item_vladmir_lua2:IsHidden() return true end
function modifier_item_vladmir_lua2:IsPurgable() return false end
function modifier_item_vladmir_lua2:RemoveOnDeath() return false end

function modifier_item_vladmir_lua2:OnCreated()
	self.armor_aura = self:GetAbility():GetSpecialValueFor("armor_aura")
	self.mana_regen_aura = self:GetAbility():GetSpecialValueFor("mana_regen_aura")
	self.lifesteal_aura = self:GetAbility():GetSpecialValueFor("lifesteal_aura")
	self.damage_aura = self:GetAbility():GetSpecialValueFor("damage_aura")
	self.aura_radius = self:GetAbility():GetSpecialValueFor("aura_radius")
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end
function modifier_item_vladmir_lua2:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end
function modifier_item_vladmir_lua2:GetAuraRadius()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("aura_radius")
	end
end


function modifier_item_vladmir_lua2:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_item_vladmir_lua2:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_item_vladmir_lua2:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_item_vladmir_lua2:GetModifierAura()
	return "modifier_item_vladmir_aura_lua"
end

function modifier_item_vladmir_lua2:IsAura()
	return true
end

modifier_item_vladmir_lua3 = class({})

function modifier_item_vladmir_lua3:IsHidden() return true end
function modifier_item_vladmir_lua3:IsPurgable() return false end
function modifier_item_vladmir_lua3:RemoveOnDeath() return false end

function modifier_item_vladmir_lua3:OnCreated()
	self.armor_aura = self:GetAbility():GetSpecialValueFor("armor_aura")
	self.mana_regen_aura = self:GetAbility():GetSpecialValueFor("mana_regen_aura")
	self.lifesteal_aura = self:GetAbility():GetSpecialValueFor("lifesteal_aura")
	self.damage_aura = self:GetAbility():GetSpecialValueFor("damage_aura")
	self.aura_radius = self:GetAbility():GetSpecialValueFor("aura_radius")
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end
function modifier_item_vladmir_lua3:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end
function modifier_item_vladmir_lua3:GetAuraRadius()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("aura_radius")
	end
end


function modifier_item_vladmir_lua3:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_item_vladmir_lua3:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_item_vladmir_lua3:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_item_vladmir_lua3:GetModifierAura()
	return "modifier_item_vladmir_aura_lua"
end

function modifier_item_vladmir_lua3:IsAura()
	return true
end

modifier_item_vladmir_lua4 = class({})

function modifier_item_vladmir_lua4:IsHidden() return true end
function modifier_item_vladmir_lua4:IsPurgable() return false end
function modifier_item_vladmir_lua4:RemoveOnDeath() return false end

function modifier_item_vladmir_lua4:OnCreated()
	self.armor_aura = self:GetAbility():GetSpecialValueFor("armor_aura")
	self.mana_regen_aura = self:GetAbility():GetSpecialValueFor("mana_regen_aura")
	self.lifesteal_aura = self:GetAbility():GetSpecialValueFor("lifesteal_aura")
	self.damage_aura = self:GetAbility():GetSpecialValueFor("damage_aura")
	self.aura_radius = self:GetAbility():GetSpecialValueFor("aura_radius")
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end
function modifier_item_vladmir_lua4:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end
function modifier_item_vladmir_lua4:GetAuraRadius()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("aura_radius")
	end
end


function modifier_item_vladmir_lua4:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_item_vladmir_lua4:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_item_vladmir_lua4:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_item_vladmir_lua4:GetModifierAura()
	return "modifier_item_vladmir_aura_lua"
end

function modifier_item_vladmir_lua4:IsAura()
	return true
end

modifier_item_vladmir_lua5 = class({})

function modifier_item_vladmir_lua5:IsHidden() return true end
function modifier_item_vladmir_lua5:IsPurgable() return false end
function modifier_item_vladmir_lua5:RemoveOnDeath() return false end

function modifier_item_vladmir_lua5:OnCreated()
	self.armor_aura = self:GetAbility():GetSpecialValueFor("armor_aura")
	self.mana_regen_aura = self:GetAbility():GetSpecialValueFor("mana_regen_aura")
	self.lifesteal_aura = self:GetAbility():GetSpecialValueFor("lifesteal_aura")
	self.damage_aura = self:GetAbility():GetSpecialValueFor("damage_aura")
	self.aura_radius = self:GetAbility():GetSpecialValueFor("aura_radius")
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end
function modifier_item_vladmir_lua5:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end
function modifier_item_vladmir_lua5:GetAuraRadius()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("aura_radius")
	end
end


function modifier_item_vladmir_lua5:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_item_vladmir_lua5:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_item_vladmir_lua5:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_item_vladmir_lua5:GetModifierAura()
	return "modifier_item_vladmir_aura_lua"
end

function modifier_item_vladmir_lua5:IsAura()
	return true
end

------------------------------------------------------------------------------------------------
modifier_item_vladmir_aura_lua = class({})
function modifier_item_vladmir_aura_lua:IsHidden() return false end
function modifier_item_vladmir_aura_lua:IsPurgable() return false end
function modifier_item_vladmir_aura_lua:RemoveOnDeath() return false end
function modifier_item_vladmir_aura_lua:IsAuraActiveOnDeath() return false end

function modifier_item_vladmir_aura_lua:OnCreated()
	self.armor_aura = self:GetAbility():GetSpecialValueFor("armor_aura")
	self.mana_regen_aura = self:GetAbility():GetSpecialValueFor("mana_regen_aura")
	self.lifesteal_aura = self:GetAbility():GetSpecialValueFor("lifesteal_aura")
	self.damage_aura = self:GetAbility():GetSpecialValueFor("damage_aura")
	self.aura_radius = self:GetAbility():GetSpecialValueFor("aura_radius")
end

function modifier_item_vladmir_aura_lua:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_UNIQUE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,

		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
end

function modifier_item_vladmir_aura_lua:GetModifierBaseDamageOutgoing_Percentage()
	return self.damage_aura
end

function modifier_item_vladmir_aura_lua:GetModifierPhysicalArmorBonusUnique()
	return self.armor_aura 
end

function modifier_item_vladmir_aura_lua:GetModifierConstantManaRegen()
	return self.mana_regen_aura
end

function modifier_item_vladmir_aura_lua:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		local pass = false
		if params.target:GetTeamNumber()~=self:GetParent():GetTeamNumber() then
			if (not params.target:IsBuilding()) and (not params.target:IsOther()) then
				pass = true
			end
		end

		if pass then
			self.attack_record = params.record
		end
	end
end

function modifier_item_vladmir_aura_lua:OnTakeDamage( params )
	if IsServer() then
		local pass = false
		if self.attack_record and params.record == self.attack_record then
			pass = true
			self.attack_record = nil
		end

		if pass then
			local heal = params.damage * self.lifesteal_aura/100
			self:GetParent():Heal( heal, self:GetAbility() )
			self:PlayEffects( self:GetParent() )
		end
	end
end

function modifier_item_vladmir_aura_lua:PlayEffects( target )
	local particle_cast = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

