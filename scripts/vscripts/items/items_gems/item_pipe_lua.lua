item_pipe_lua1_gem1 = item_pipe_lua1_gem1 or class({})
item_pipe_lua2_gem1 = item_pipe_lua1_gem1 or class({})
item_pipe_lua3_gem1 = item_pipe_lua1_gem1 or class({})
item_pipe_lua4_gem1 = item_pipe_lua1_gem1 or class({})
item_pipe_lua5_gem1 = item_pipe_lua1_gem1 or class({})
item_pipe_lua6_gem1 = item_pipe_lua1_gem1 or class({})
item_pipe_lua7_gem1 = item_pipe_lua1_gem1 or class({})
item_pipe_lua8_gem1 = item_pipe_lua1_gem1 or class({})

item_pipe_lua1_gem2 = item_pipe_lua1_gem2 or class({})
item_pipe_lua2_gem2 = item_pipe_lua1_gem2 or class({})
item_pipe_lua3_gem2 = item_pipe_lua1_gem2 or class({})
item_pipe_lua4_gem2 = item_pipe_lua1_gem2 or class({})
item_pipe_lua5_gem2 = item_pipe_lua1_gem2 or class({})
item_pipe_lua6_gem2 = item_pipe_lua1_gem2 or class({})
item_pipe_lua7_gem2 = item_pipe_lua1_gem2 or class({})
item_pipe_lua8_gem2 = item_pipe_lua1_gem2 or class({})

item_pipe_lua1_gem3 = item_pipe_lua1_gem3 or class({})
item_pipe_lua2_gem3 = item_pipe_lua1_gem3 or class({})
item_pipe_lua3_gem3 = item_pipe_lua1_gem3 or class({})
item_pipe_lua4_gem3 = item_pipe_lua1_gem3 or class({})
item_pipe_lua5_gem3 = item_pipe_lua1_gem3 or class({})
item_pipe_lua6_gem3 = item_pipe_lua1_gem3 or class({})
item_pipe_lua7_gem3 = item_pipe_lua1_gem3 or class({})
item_pipe_lua8_gem3 = item_pipe_lua1_gem3 or class({})

item_pipe_lua1_gem4 = item_pipe_lua1_gem4 or class({})
item_pipe_lua2_gem4 = item_pipe_lua1_gem4 or class({})
item_pipe_lua3_gem4 = item_pipe_lua1_gem4 or class({})
item_pipe_lua4_gem4 = item_pipe_lua1_gem4 or class({})
item_pipe_lua5_gem4 = item_pipe_lua1_gem4 or class({})
item_pipe_lua6_gem4 = item_pipe_lua1_gem4 or class({})
item_pipe_lua7_gem4 = item_pipe_lua1_gem4 or class({})
item_pipe_lua8_gem4 = item_pipe_lua1_gem4 or class({})

item_pipe_lua1_gem5 = item_pipe_lua1_gem5 or class({})
item_pipe_lua2_gem5 = item_pipe_lua1_gem5 or class({})
item_pipe_lua3_gem5 = item_pipe_lua1_gem5 or class({})
item_pipe_lua4_gem5 = item_pipe_lua1_gem5 or class({})
item_pipe_lua5_gem5 = item_pipe_lua1_gem5 or class({})
item_pipe_lua6_gem5 = item_pipe_lua1_gem5 or class({})
item_pipe_lua7_gem5 = item_pipe_lua1_gem5 or class({})
item_pipe_lua8_gem5 = item_pipe_lua1_gem5 or class({})

LinkLuaModifier("modifier_gem1", 'items/items_gems/gem1', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem2", 'items/items_gems/gem2', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem3", 'items/items_gems/gem3', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem4", 'items/items_gems/gem4', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem5", 'items/items_gems/gem5', LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_item_pipe_lua1", 'items/items_gems/item_pipe_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_pipe_lua2", 'items/items_gems/item_pipe_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_pipe_lua3", 'items/items_gems/item_pipe_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_pipe_lua4", 'items/items_gems/item_pipe_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_pipe_lua5", 'items/items_gems/item_pipe_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_pipe_aura_lua", 'items/items_gems/item_pipe_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_pipe_active_lua", 'items/items_gems/item_pipe_lua.lua', LUA_MODIFIER_MOTION_NONE)

function item_pipe_lua1_gem1:GetIntrinsicModifierName()
	return "modifier_item_pipe_lua1"
end

function item_pipe_lua1_gem1:OnSpellStart()
	EmitSoundOn("DOTA_Item.Pipe.Activate", self:GetCaster())
	local allys = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,units in pairs(allys) do
		units:AddNewModifier(self:GetCaster(), self, "modifier_item_pipe_active_lua", {duration = 12})
	end
end
------------------------------------------------------------------------------------
function item_pipe_lua1_gem2:GetIntrinsicModifierName()
	return "modifier_item_pipe_lua2"
end

function item_pipe_lua1_gem2:OnSpellStart()
	EmitSoundOn("DOTA_Item.Pipe.Activate", self:GetCaster())
	local allys = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,units in pairs(allys) do
		units:AddNewModifier(self:GetCaster(), self, "modifier_item_pipe_active_lua", {duration = 12})
	end
end
------------------------------------------------------------------------------------
function item_pipe_lua1_gem3:GetIntrinsicModifierName()
	return "modifier_item_pipe_lua3"
end

function item_pipe_lua1_gem3:OnSpellStart()
	EmitSoundOn("DOTA_Item.Pipe.Activate", self:GetCaster())
	local allys = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,units in pairs(allys) do
		units:AddNewModifier(self:GetCaster(), self, "modifier_item_pipe_active_lua", {duration = 12})
	end
end
------------------------------------------------------------------------------------
function item_pipe_lua1_gem4:GetIntrinsicModifierName()
	return "modifier_item_pipe_lua4"
end

function item_pipe_lua1_gem4:OnSpellStart()
	EmitSoundOn("DOTA_Item.Pipe.Activate", self:GetCaster())
	local allys = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,units in pairs(allys) do
		units:AddNewModifier(self:GetCaster(), self, "modifier_item_pipe_active_lua", {duration = 12})
	end
end
------------------------------------------------------------------------------------
function item_pipe_lua1_gem5:GetIntrinsicModifierName()
	return "modifier_item_pipe_lua5"
end

function item_pipe_lua1_gem5:OnSpellStart()
	EmitSoundOn("DOTA_Item.Pipe.Activate", self:GetCaster())
	local allys = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,units in pairs(allys) do
		units:AddNewModifier(self:GetCaster(), self, "modifier_item_pipe_active_lua", {duration = 12})
	end
end
-------------------------------------------------------------------------------------

modifier_item_pipe_active_lua = class({})

function modifier_item_pipe_active_lua:OnCreated()

	self.particle = ParticleManager:CreateParticle("particles/items2_fx/pipe_of_insight.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControlEnt(self.particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_origin", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(self.particle, 2, Vector(self:GetParent():GetModelRadius() * 1.2, 0, 0))
	self:AddParticle(self.particle, false, false, -1, false, false)

	self.barrier_block = self:GetAbility():GetSpecialValueFor("barrier_block")
end

function modifier_item_pipe_active_lua:DeclareFunctions()
	return {MODIFIER_PROPERTY_INCOMING_SPELL_DAMAGE_CONSTANT}
end

function modifier_item_pipe_active_lua:GetModifierIncomingSpellDamageConstant(keys)
		if keys.damage_type == DAMAGE_TYPE_MAGICAL then
			if keys.original_damage >= self.barrier_block then
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_MAGICAL_BLOCK, self:GetParent(), self.barrier_block, nil)
			
				self:Destroy()
				return self.barrier_block * (-1)
			else
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_MAGICAL_BLOCK, self:GetParent(), keys.original_damage, nil)
			
				self.barrier_block = self.barrier_block - keys.original_damage
				return keys.original_damage * (-1)
			end
		end
end

----------------------------------------------------------------------------------

modifier_item_pipe_lua1 = class({})

function modifier_item_pipe_lua1:IsHidden()
	return true
end

function modifier_item_pipe_lua1:IsPurgable()
	return false
end

function modifier_item_pipe_lua1:RemoveOnDeath()	
	return false 
end

function modifier_item_pipe_lua1:GetIntrinsicModifierName()
	return "modifier_item_pipe_aura_lua"
end

function modifier_item_pipe_lua1:OnCreated()
	
	
	self.health_regen = self:GetAbility():GetSpecialValueFor("health_regen")
	self.magic_resistance = self:GetAbility():GetSpecialValueFor("magic_resistance")
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_pipe_lua1:OnDestroy()
	if not IsServer() then return end 
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_pipe_lua1:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
end

function modifier_item_pipe_lua1:GetModifierConstantHealthRegen()
	return self.health_regen
end

function modifier_item_pipe_lua1:GetModifierMagicalResistanceBonus()
	return self.magic_resistance
end
function modifier_item_pipe_lua1:IsAura()						return true end
function modifier_item_pipe_lua1:IsAuraActiveOnDeath() 			return false end

function modifier_item_pipe_lua1:GetAuraRadius()				return self:GetAbility():GetSpecialValueFor("aura_radius") end
function modifier_item_pipe_lua1:GetAuraSearchFlags()			return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_item_pipe_lua1:GetAuraSearchTeam()			return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_item_pipe_lua1:GetAuraSearchType()			return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_item_pipe_lua1:GetModifierAura()				return "modifier_item_pipe_aura_lua" end
-----------------------------------------------------------------------------------------
modifier_item_pipe_lua2 = class({})

function modifier_item_pipe_lua2:IsHidden()
	return true
end

function modifier_item_pipe_lua2:IsPurgable()
	return false
end

function modifier_item_pipe_lua2:RemoveOnDeath()	
	return false 
end

function modifier_item_pipe_lua2:GetIntrinsicModifierName()
	return "modifier_item_pipe_aura_lua"
end

function modifier_item_pipe_lua2:OnCreated()
	
	
	self.health_regen = self:GetAbility():GetSpecialValueFor("health_regen")
	self.magic_resistance = self:GetAbility():GetSpecialValueFor("magic_resistance")
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_pipe_lua2:OnDestroy()
	if not IsServer() then return end 
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_pipe_lua2:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
end

function modifier_item_pipe_lua2:GetModifierConstantHealthRegen()
	return self.health_regen
end

function modifier_item_pipe_lua2:GetModifierMagicalResistanceBonus()
	return self.magic_resistance
end
function modifier_item_pipe_lua2:IsAura()						return true end
function modifier_item_pipe_lua2:IsAuraActiveOnDeath() 			return false end

function modifier_item_pipe_lua2:GetAuraRadius()				return self:GetAbility():GetSpecialValueFor("aura_radius") end
function modifier_item_pipe_lua2:GetAuraSearchFlags()			return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_item_pipe_lua2:GetAuraSearchTeam()			return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_item_pipe_lua2:GetAuraSearchType()			return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_item_pipe_lua2:GetModifierAura()				return "modifier_item_pipe_aura_lua" end
----------------------------------------------------------------------------------------------------------
modifier_item_pipe_lua3 = class({})

function modifier_item_pipe_lua3:IsHidden()
	return true
end

function modifier_item_pipe_lua3:IsPurgable()
	return false
end

function modifier_item_pipe_lua3:RemoveOnDeath()	
	return false 
end

function modifier_item_pipe_lua3:GetIntrinsicModifierName()
	return "modifier_item_pipe_aura_lua"
end

function modifier_item_pipe_lua3:OnCreated()
	
	
	self.health_regen = self:GetAbility():GetSpecialValueFor("health_regen")
	self.magic_resistance = self:GetAbility():GetSpecialValueFor("magic_resistance")
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_pipe_lua3:OnDestroy()
	if not IsServer() then return end 
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_pipe_lua3:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
end

function modifier_item_pipe_lua3:GetModifierConstantHealthRegen()
	return self.health_regen
end

function modifier_item_pipe_lua3:GetModifierMagicalResistanceBonus()
	return self.magic_resistance
end
function modifier_item_pipe_lua3:IsAura()						return true end
function modifier_item_pipe_lua3:IsAuraActiveOnDeath() 			return false end

function modifier_item_pipe_lua3:GetAuraRadius()				return self:GetAbility():GetSpecialValueFor("aura_radius") end
function modifier_item_pipe_lua3:GetAuraSearchFlags()			return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_item_pipe_lua3:GetAuraSearchTeam()			return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_item_pipe_lua3:GetAuraSearchType()			return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_item_pipe_lua3:GetModifierAura()				return "modifier_item_pipe_aura_lua" end
-------------------------------------------------------------------------------------------------
modifier_item_pipe_lua4 = class({})

function modifier_item_pipe_lua4:IsHidden()
	return true
end

function modifier_item_pipe_lua4:IsPurgable()
	return false
end

function modifier_item_pipe_lua4:RemoveOnDeath()	
	return false 
end

function modifier_item_pipe_lua4:GetIntrinsicModifierName()
	return "modifier_item_pipe_aura_lua"
end

function modifier_item_pipe_lua4:OnCreated()
	
	
	self.health_regen = self:GetAbility():GetSpecialValueFor("health_regen")
	self.magic_resistance = self:GetAbility():GetSpecialValueFor("magic_resistance")
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_pipe_lua4:OnDestroy()
	if not IsServer() then return end 
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_pipe_lua4:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
end

function modifier_item_pipe_lua4:GetModifierConstantHealthRegen()
	return self.health_regen
end

function modifier_item_pipe_lua4:GetModifierMagicalResistanceBonus()
	return self.magic_resistance
end

function modifier_item_pipe_lua4:IsAura()						return true end
function modifier_item_pipe_lua4:IsAuraActiveOnDeath() 			return false end

function modifier_item_pipe_lua4:GetAuraRadius()				return self:GetAbility():GetSpecialValueFor("aura_radius") end
function modifier_item_pipe_lua4:GetAuraSearchFlags()			return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_item_pipe_lua4:GetAuraSearchTeam()			return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_item_pipe_lua4:GetAuraSearchType()			return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_item_pipe_lua4:GetModifierAura()				return "modifier_item_pipe_aura_lua" end
------------------------------------------------------------------------------------------------------------
modifier_item_pipe_lua5 = class({})

function modifier_item_pipe_lua5:IsHidden()
	return true
end

function modifier_item_pipe_lua5:IsPurgable()
	return false
end

function modifier_item_pipe_lua5:RemoveOnDeath()	
	return false 
end

function modifier_item_pipe_lua5:GetIntrinsicModifierName()
	return "modifier_item_pipe_aura_lua"
end

function modifier_item_pipe_lua5:OnCreated()
	
	
	self.health_regen = self:GetAbility():GetSpecialValueFor("health_regen")
	self.magic_resistance = self:GetAbility():GetSpecialValueFor("magic_resistance")
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_pipe_lua5:OnDestroy()
	if not IsServer() then return end 
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_pipe_lua5:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
end

function modifier_item_pipe_lua5:GetModifierConstantHealthRegen()
	return self.health_regen
end

function modifier_item_pipe_lua5:GetModifierMagicalResistanceBonus()
	return self.magic_resistance
end

function modifier_item_pipe_lua5:IsAura()						return true end
function modifier_item_pipe_lua5:IsAuraActiveOnDeath() 			return false end

function modifier_item_pipe_lua5:GetAuraRadius()				return self:GetAbility():GetSpecialValueFor("aura_radius") end
function modifier_item_pipe_lua5:GetAuraSearchFlags()			return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_item_pipe_lua5:GetAuraSearchTeam()			return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_item_pipe_lua5:GetAuraSearchType()			return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_item_pipe_lua5:GetModifierAura()				return "modifier_item_pipe_aura_lua" end

-------------------------------------------------------------------------------------------

modifier_item_pipe_aura_lua = class({})

function modifier_item_pipe_aura_lua:OnCreated()
	self.aura_health_regen = self:GetAbility():GetSpecialValueFor("aura_health_regen")
	self.magic_resistance_aura = self:GetAbility():GetSpecialValueFor("magic_resistance_aura")
end

function modifier_item_pipe_aura_lua:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
end

function modifier_item_pipe_aura_lua:GetModifierConstantHealthRegen()
	return self.aura_health_regen
end

function modifier_item_pipe_aura_lua:GetModifierMagicalResistanceBonus()
	return self.magic_resistance_aura
end