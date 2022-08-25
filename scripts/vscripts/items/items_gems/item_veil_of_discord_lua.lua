item_veil_of_discord_lua1_gem1 = item_veil_of_discord_lua1_gem1 or class({})
item_veil_of_discord_lua2_gem1 = item_veil_of_discord_lua1_gem1 or class({})
item_veil_of_discord_lua3_gem1 = item_veil_of_discord_lua1_gem1 or class({})
item_veil_of_discord_lua4_gem1 = item_veil_of_discord_lua1_gem1 or class({})
item_veil_of_discord_lua5_gem1 = item_veil_of_discord_lua1_gem1 or class({})
item_veil_of_discord_lua6_gem1 = item_veil_of_discord_lua1_gem1 or class({})
item_veil_of_discord_lua7_gem1 = item_veil_of_discord_lua1_gem1 or class({})
item_veil_of_discord_lua8_gem1 = item_veil_of_discord_lua1_gem1 or class({})

item_veil_of_discord_lua1_gem2 = item_veil_of_discord_lua1_gem2 or class({})
item_veil_of_discord_lua2_gem2 = item_veil_of_discord_lua1_gem2 or class({})
item_veil_of_discord_lua3_gem2 = item_veil_of_discord_lua1_gem2 or class({})
item_veil_of_discord_lua4_gem2 = item_veil_of_discord_lua1_gem2 or class({})
item_veil_of_discord_lua5_gem2 = item_veil_of_discord_lua1_gem2 or class({})
item_veil_of_discord_lua6_gem2 = item_veil_of_discord_lua1_gem2 or class({})
item_veil_of_discord_lua7_gem2 = item_veil_of_discord_lua1_gem2 or class({})
item_veil_of_discord_lua8_gem2 = item_veil_of_discord_lua1_gem2 or class({})

item_veil_of_discord_lua1_gem3 = item_veil_of_discord_lua1_gem3 or class({})
item_veil_of_discord_lua2_gem3 = item_veil_of_discord_lua1_gem3 or class({})
item_veil_of_discord_lua3_gem3 = item_veil_of_discord_lua1_gem3 or class({})
item_veil_of_discord_lua4_gem3 = item_veil_of_discord_lua1_gem3 or class({})
item_veil_of_discord_lua5_gem3 = item_veil_of_discord_lua1_gem3 or class({})
item_veil_of_discord_lua6_gem3 = item_veil_of_discord_lua1_gem3 or class({})
item_veil_of_discord_lua7_gem3 = item_veil_of_discord_lua1_gem3 or class({})
item_veil_of_discord_lua8_gem3 = item_veil_of_discord_lua1_gem3 or class({})

item_veil_of_discord_lua1_gem4 = item_veil_of_discord_lua1_gem4 or class({})
item_veil_of_discord_lua2_gem4 = item_veil_of_discord_lua1_gem4 or class({})
item_veil_of_discord_lua3_gem4 = item_veil_of_discord_lua1_gem4 or class({})
item_veil_of_discord_lua4_gem4 = item_veil_of_discord_lua1_gem4 or class({})
item_veil_of_discord_lua5_gem4 = item_veil_of_discord_lua1_gem4 or class({})
item_veil_of_discord_lua6_gem4 = item_veil_of_discord_lua1_gem4 or class({})
item_veil_of_discord_lua7_gem4 = item_veil_of_discord_lua1_gem4 or class({})
item_veil_of_discord_lua8_gem4 = item_veil_of_discord_lua1_gem4 or class({})

item_veil_of_discord_lua1_gem5 = item_veil_of_discord_lua1_gem5 or class({})
item_veil_of_discord_lua2_gem5 = item_veil_of_discord_lua1_gem5 or class({})
item_veil_of_discord_lua3_gem5 = item_veil_of_discord_lua1_gem5 or class({})
item_veil_of_discord_lua4_gem5 = item_veil_of_discord_lua1_gem5 or class({})
item_veil_of_discord_lua5_gem5 = item_veil_of_discord_lua1_gem5 or class({})
item_veil_of_discord_lua6_gem5 = item_veil_of_discord_lua1_gem5 or class({})
item_veil_of_discord_lua7_gem5 = item_veil_of_discord_lua1_gem5 or class({})
item_veil_of_discord_lua8_gem5 = item_veil_of_discord_lua1_gem5 or class({})

LinkLuaModifier("modifier_gem1", 'items/items_gems/gem1', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem2", 'items/items_gems/gem2', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem3", 'items/items_gems/gem3', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem4", 'items/items_gems/gem4', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem5", 'items/items_gems/gem5', LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_item_veil_of_discord_lua1", 'items/items_gems/item_veil_of_discord_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_veil_of_discord_lua2", 'items/items_gems/item_veil_of_discord_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_veil_of_discord_lua3", 'items/items_gems/item_veil_of_discord_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_veil_of_discord_lua4", 'items/items_gems/item_veil_of_discord_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_veil_of_discord_lua5", 'items/items_gems/item_veil_of_discord_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_veil_of_discord_active_lua", 'items/items_gems/item_veil_of_discord_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_veil_of_discord_aura_lua", 'items/items_gems/item_veil_of_discord_lua.lua', LUA_MODIFIER_MOTION_NONE)

function item_veil_of_discord_lua1_gem1:GetIntrinsicModifierName()
	return "modifier_item_veil_of_discord_lua1"
end
function item_veil_of_discord_lua1_gem2:GetIntrinsicModifierName()
	return "modifier_item_veil_of_discord_lua2"
end
function item_veil_of_discord_lua1_gem3:GetIntrinsicModifierName()
	return "modifier_item_veil_of_discord_lua3"
end
function item_veil_of_discord_lua1_gem4:GetIntrinsicModifierName()
	return "modifier_item_veil_of_discord_lua4"
end
function item_veil_of_discord_lua1_gem5:GetIntrinsicModifierName()
	return "modifier_item_veil_of_discord_lua5"
end

function item_veil_of_discord_lua1_gem1:OnSpellStart()
	local target_loc    =   self:GetCursorPosition()
	local particle      =   "particles/items2_fx/veil_of_discord.vpcf"

	self:GetCaster():EmitSound("DOTA_Item.VeilofDiscord.Activate")

	local particle_fx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(particle_fx, 0, target_loc)
	ParticleManager:SetParticleControl(particle_fx, 1, Vector(self:GetSpecialValueFor("debuff_radius"), 1, 1))
	ParticleManager:ReleaseParticleIndex(particle_fx)

	local enemies =   FindUnitsInRadius(self:GetCaster():GetTeamNumber(),
		target_loc,
		nil,
		self:GetSpecialValueFor("debuff_radius"),
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		0,
		FIND_ANY_ORDER,
		false)

	for _,enemy in pairs(enemies) do
		enemy:AddNewModifier(self:GetCaster(), self, "modifier_item_veil_of_discord_active_lua", {duration = self:GetSpecialValueFor("resist_debuff_duration") * (1 - enemy:GetStatusResistance())})
	end
end

function item_veil_of_discord_lua1_gem2:OnSpellStart()
	local target_loc = self:GetCursorPosition()
	local particle = "particles/items2_fx/veil_of_discord.vpcf"

	self:GetCaster():EmitSound("DOTA_Item.VeilofDiscord.Activate")

	local particle_fx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(particle_fx, 0, target_loc)
	ParticleManager:SetParticleControl(particle_fx, 1, Vector(self:GetSpecialValueFor("debuff_radius"), 1, 1))
	ParticleManager:ReleaseParticleIndex(particle_fx)

	local enemies =   FindUnitsInRadius(self:GetCaster():GetTeamNumber(),
		target_loc,
		nil,
		self:GetSpecialValueFor("debuff_radius"),
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		0,
		FIND_ANY_ORDER,
		false)

	for _,enemy in pairs(enemies) do
		enemy:AddNewModifier(self:GetCaster(), self, "modifier_item_veil_of_discord_active_lua", {duration = self:GetSpecialValueFor("resist_debuff_duration") * (1 - enemy:GetStatusResistance())})
	end
end

function item_veil_of_discord_lua1_gem3:OnSpellStart()
	local target_loc = self:GetCursorPosition()
	local particle = "particles/items2_fx/veil_of_discord.vpcf"
 
	self:GetCaster():EmitSound("DOTA_Item.VeilofDiscord.Activate")
 
	local particle_fx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(particle_fx, 0, target_loc)
	ParticleManager:SetParticleControl(particle_fx, 1, Vector(self:GetSpecialValueFor("debuff_radius"), 1, 1))
	ParticleManager:ReleaseParticleIndex(particle_fx)
 
	local enemies =   FindUnitsInRadius(self:GetCaster():GetTeamNumber(),
		target_loc,
		nil,
		self:GetSpecialValueFor("debuff_radius"),
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		0,
		FIND_ANY_ORDER,
		false)
 
	for _,enemy in pairs(enemies) do
		enemy:AddNewModifier(self:GetCaster(), self, "modifier_item_veil_of_discord_active_lua", {duration = self:GetSpecialValueFor("resist_debuff_duration") * (1 - enemy:GetStatusResistance())})
	end
end

function item_veil_of_discord_lua1_gem4:OnSpellStart()
		-- Ability properties
	
	local target_loc    =   self:GetCursorPosition()
	local particle      =   "particles/items2_fx/veil_of_discord.vpcf"

	-- Emit sound
	self:GetCaster():EmitSound("DOTA_Item.VeilofDiscord.Activate")

	-- Emit the particle
	local particle_fx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(particle_fx, 0, target_loc)
	ParticleManager:SetParticleControl(particle_fx, 1, Vector(self:GetSpecialValueFor("debuff_radius"), 1, 1))
	ParticleManager:ReleaseParticleIndex(particle_fx)

	-- Find units around the target point
	local enemies =   FindUnitsInRadius(self:GetCaster():GetTeamNumber(),
		target_loc,
		nil,
		self:GetSpecialValueFor("debuff_radius"),
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		0,
		FIND_ANY_ORDER,
		false)

	-- Iterate through the unit table and give each unit its respective modifier
	for _,enemy in pairs(enemies) do
		-- Give enemies a debuff
		enemy:AddNewModifier(self:GetCaster(), self, "modifier_item_veil_of_discord_active_lua", {duration = self:GetSpecialValueFor("resist_debuff_duration") * (1 - enemy:GetStatusResistance())})
	end
end
function item_veil_of_discord_lua1_gem5:OnSpellStart()
		-- Ability properties
	
	local target_loc    =   self:GetCursorPosition()
	local particle      =   "particles/items2_fx/veil_of_discord.vpcf"

	-- Emit sound
	self:GetCaster():EmitSound("DOTA_Item.VeilofDiscord.Activate")

	-- Emit the particle
	local particle_fx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(particle_fx, 0, target_loc)
	ParticleManager:SetParticleControl(particle_fx, 1, Vector(self:GetSpecialValueFor("debuff_radius"), 1, 1))
	ParticleManager:ReleaseParticleIndex(particle_fx)

	-- Find units around the target point
	local enemies =   FindUnitsInRadius(self:GetCaster():GetTeamNumber(),
		target_loc,
		nil,
		self:GetSpecialValueFor("debuff_radius"),
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		0,
		FIND_ANY_ORDER,
		false)

	-- Iterate through the unit table and give each unit its respective modifier
	for _,enemy in pairs(enemies) do
		-- Give enemies a debuff
		enemy:AddNewModifier(self:GetCaster(), self, "modifier_item_veil_of_discord_active_lua", {duration = self:GetSpecialValueFor("resist_debuff_duration") * (1 - enemy:GetStatusResistance())})
	end
end
-----------------------------------------------------------------------------------
modifier_item_veil_of_discord_active_lua = class({})

function modifier_item_veil_of_discord_active_lua:IsDebuff() return true end
function modifier_item_veil_of_discord_active_lua:IsHidden() return false end
function modifier_item_veil_of_discord_active_lua:IsPurgable() return true end

function modifier_item_veil_of_discord_active_lua:OnCreated()
	self.spell_amp    =   self:GetAbility():GetSpecialValueFor("spell_amp")
end

function modifier_item_veil_of_discord_active_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end

function modifier_item_veil_of_discord_active_lua:GetModifierIncomingDamage_Percentage(keys)
	if keys.damage_category == DOTA_DAMAGE_CATEGORY_SPELL then
		return self.spell_amp
	end
end

function modifier_item_veil_of_discord_active_lua:GetEffectName()
	return "particles/items2_fx/veil_of_discord_debuff.vpcf"
end

-----------------------------------------------------------------------------------

modifier_item_veil_of_discord_lua1 = class({})

function modifier_item_veil_of_discord_lua1:OnCreated()
	
	

	self.bonus_all_stats = self:GetAbility():GetSpecialValueFor("bonus_all_stats")
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end
function modifier_item_veil_of_discord_lua1:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end
function modifier_item_veil_of_discord_lua1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
end

function modifier_item_veil_of_discord_lua1:GetModifierBonusStats_Strength()
	return self.bonus_all_stats
end

function modifier_item_veil_of_discord_lua1:GetModifierBonusStats_Agility()
	return self.bonus_all_stats
end

function modifier_item_veil_of_discord_lua1:GetModifierBonusStats_Intellect()
	return self.bonus_all_stats
end

-------------------------------------------------------------------------------

function modifier_item_veil_of_discord_lua1:GetModifierAura()
	return "modifier_item_veil_of_discord_aura_lua"
end

function modifier_item_veil_of_discord_lua1:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_item_veil_of_discord_lua1:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_item_veil_of_discord_lua1:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_item_veil_of_discord_lua1:IsAura()
	return true
end

function modifier_item_veil_of_discord_lua1:GetAuraRadius()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("aura_radius")
	end
end
modifier_item_veil_of_discord_lua2 = class({})

function modifier_item_veil_of_discord_lua2:OnCreated()
	
	

	self.bonus_all_stats = self:GetAbility():GetSpecialValueFor("bonus_all_stats")
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end
function modifier_item_veil_of_discord_lua2:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end
function modifier_item_veil_of_discord_lua2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
end

function modifier_item_veil_of_discord_lua2:GetModifierBonusStats_Strength()
	return self.bonus_all_stats
end

function modifier_item_veil_of_discord_lua2:GetModifierBonusStats_Agility()
	return self.bonus_all_stats
end

function modifier_item_veil_of_discord_lua2:GetModifierBonusStats_Intellect()
	return self.bonus_all_stats
end

-------------------------------------------------------------------------------

function modifier_item_veil_of_discord_lua2:GetModifierAura()
	return "modifier_item_veil_of_discord_aura_lua"
end

function modifier_item_veil_of_discord_lua2:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_item_veil_of_discord_lua2:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_item_veil_of_discord_lua2:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_item_veil_of_discord_lua2:IsAura()
	return true
end

function modifier_item_veil_of_discord_lua2:GetAuraRadius()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("aura_radius")
	end
end
modifier_item_veil_of_discord_lua3 = class({})

function modifier_item_veil_of_discord_lua3:OnCreated()
	
	

	self.bonus_all_stats = self:GetAbility():GetSpecialValueFor("bonus_all_stats")
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end
function modifier_item_veil_of_discord_lua3:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end
function modifier_item_veil_of_discord_lua3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
end

function modifier_item_veil_of_discord_lua3:GetModifierBonusStats_Strength()
	return self.bonus_all_stats
end

function modifier_item_veil_of_discord_lua3:GetModifierBonusStats_Agility()
	return self.bonus_all_stats
end

function modifier_item_veil_of_discord_lua3:GetModifierBonusStats_Intellect()
	return self.bonus_all_stats
end

-------------------------------------------------------------------------------

function modifier_item_veil_of_discord_lua3:GetModifierAura()
	return "modifier_item_veil_of_discord_aura_lua"
end

function modifier_item_veil_of_discord_lua3:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_item_veil_of_discord_lua3:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_item_veil_of_discord_lua3:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_item_veil_of_discord_lua3:IsAura()
	return true
end

function modifier_item_veil_of_discord_lua3:GetAuraRadius()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("aura_radius")
	end
end
modifier_item_veil_of_discord_lua4 = class({})

function modifier_item_veil_of_discord_lua4:OnCreated()
	
	

	self.bonus_all_stats = self:GetAbility():GetSpecialValueFor("bonus_all_stats")
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end
function modifier_item_veil_of_discord_lua4:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end
function modifier_item_veil_of_discord_lua4:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
end

function modifier_item_veil_of_discord_lua4:GetModifierBonusStats_Strength()
	return self.bonus_all_stats
end

function modifier_item_veil_of_discord_lua4:GetModifierBonusStats_Agility()
	return self.bonus_all_stats
end

function modifier_item_veil_of_discord_lua4:GetModifierBonusStats_Intellect()
	return self.bonus_all_stats
end

-------------------------------------------------------------------------------

function modifier_item_veil_of_discord_lua4:GetModifierAura()
	return "modifier_item_veil_of_discord_aura_lua"
end

function modifier_item_veil_of_discord_lua4:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_item_veil_of_discord_lua4:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_item_veil_of_discord_lua4:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_item_veil_of_discord_lua4:IsAura()
	return true
end

function modifier_item_veil_of_discord_lua4:GetAuraRadius()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("aura_radius")
	end
end
modifier_item_veil_of_discord_lua5 = class({})

function modifier_item_veil_of_discord_lua5:OnCreated()
	
	

	self.bonus_all_stats = self:GetAbility():GetSpecialValueFor("bonus_all_stats")
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end
function modifier_item_veil_of_discord_lua5:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end
function modifier_item_veil_of_discord_lua5:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
end

function modifier_item_veil_of_discord_lua5:GetModifierBonusStats_Strength()
	return self.bonus_all_stats
end

function modifier_item_veil_of_discord_lua5:GetModifierBonusStats_Agility()
	return self.bonus_all_stats
end

function modifier_item_veil_of_discord_lua5:GetModifierBonusStats_Intellect()
	return self.bonus_all_stats
end

-------------------------------------------------------------------------------

function modifier_item_veil_of_discord_lua5:GetModifierAura()
	return "modifier_item_veil_of_discord_aura_lua"
end

function modifier_item_veil_of_discord_lua5:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_item_veil_of_discord_lua5:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_item_veil_of_discord_lua5:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_item_veil_of_discord_lua5:IsAura()
	return true
end

function modifier_item_veil_of_discord_lua5:GetAuraRadius()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("aura_radius")
	end
end

------------------------------------------------------------------------------

modifier_item_veil_of_discord_aura_lua = class({})

function modifier_item_veil_of_discord_aura_lua:IsHidden() return false end
function modifier_item_veil_of_discord_aura_lua:IsPurgable() return false end
function modifier_item_veil_of_discord_aura_lua:RemoveOnDeath() return false end
function modifier_item_veil_of_discord_aura_lua:IsAuraActiveOnDeath() return false end

function modifier_item_veil_of_discord_aura_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
	}
end

function modifier_item_veil_of_discord_aura_lua:GetModifierConstantManaRegen()
			return self:GetAbility():GetSpecialValueFor("aura_mana_regen")
end