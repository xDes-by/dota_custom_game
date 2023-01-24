LinkLuaModifier("modifier_item_meteor_hammer_passive1_burn", 'items/items_gems/item_meteor_hammer_lua', LUA_MODIFIER_MOTION_NONE)

item_meteor_hammer_lua1_gem1 = item_meteor_hammer_lua1_gem1 or class({})
item_meteor_hammer_lua2_gem1 = item_meteor_hammer_lua1_gem1 or class({})
item_meteor_hammer_lua3_gem1 = item_meteor_hammer_lua1_gem1 or class({})
item_meteor_hammer_lua4_gem1 = item_meteor_hammer_lua1_gem1 or class({})
item_meteor_hammer_lua5_gem1 = item_meteor_hammer_lua1_gem1 or class({})
item_meteor_hammer_lua6_gem1 = item_meteor_hammer_lua1_gem1 or class({})
item_meteor_hammer_lua7_gem1 = item_meteor_hammer_lua1_gem1 or class({})
item_meteor_hammer_lua8_gem1 = item_meteor_hammer_lua1_gem1 or class({})

item_meteor_hammer_lua1_gem2 = item_meteor_hammer_lua1_gem2 or class({})
item_meteor_hammer_lua2_gem2 = item_meteor_hammer_lua1_gem2 or class({})
item_meteor_hammer_lua3_gem2 = item_meteor_hammer_lua1_gem2 or class({})
item_meteor_hammer_lua4_gem2 = item_meteor_hammer_lua1_gem2 or class({})
item_meteor_hammer_lua5_gem2 = item_meteor_hammer_lua1_gem2 or class({})
item_meteor_hammer_lua6_gem2 = item_meteor_hammer_lua1_gem2 or class({})
item_meteor_hammer_lua7_gem2 = item_meteor_hammer_lua1_gem2 or class({})
item_meteor_hammer_lua8_gem2 = item_meteor_hammer_lua1_gem2 or class({})

item_meteor_hammer_lua1_gem3 = item_meteor_hammer_lua1_gem3 or class({})
item_meteor_hammer_lua2_gem3 = item_meteor_hammer_lua1_gem3 or class({})
item_meteor_hammer_lua3_gem3 = item_meteor_hammer_lua1_gem3 or class({})
item_meteor_hammer_lua4_gem3 = item_meteor_hammer_lua1_gem3 or class({})
item_meteor_hammer_lua5_gem3 = item_meteor_hammer_lua1_gem3 or class({})
item_meteor_hammer_lua6_gem3 = item_meteor_hammer_lua1_gem3 or class({})
item_meteor_hammer_lua7_gem3 = item_meteor_hammer_lua1_gem3 or class({})
item_meteor_hammer_lua8_gem3 = item_meteor_hammer_lua1_gem3 or class({})

item_meteor_hammer_lua1_gem4 = item_meteor_hammer_lua1_gem4 or class({})
item_meteor_hammer_lua2_gem4 = item_meteor_hammer_lua1_gem4 or class({})
item_meteor_hammer_lua3_gem4 = item_meteor_hammer_lua1_gem4 or class({})
item_meteor_hammer_lua4_gem4 = item_meteor_hammer_lua1_gem4 or class({})
item_meteor_hammer_lua5_gem4 = item_meteor_hammer_lua1_gem4 or class({})
item_meteor_hammer_lua6_gem4 = item_meteor_hammer_lua1_gem4 or class({})
item_meteor_hammer_lua7_gem4 = item_meteor_hammer_lua1_gem4 or class({})
item_meteor_hammer_lua8_gem4 = item_meteor_hammer_lua1_gem4 or class({})

item_meteor_hammer_lua1_gem5 = item_meteor_hammer_lua1_gem5 or class({})
item_meteor_hammer_lua2_gem5 = item_meteor_hammer_lua1_gem5 or class({})
item_meteor_hammer_lua3_gem5 = item_meteor_hammer_lua1_gem5 or class({})
item_meteor_hammer_lua4_gem5 = item_meteor_hammer_lua1_gem5 or class({})
item_meteor_hammer_lua5_gem5 = item_meteor_hammer_lua1_gem5 or class({})
item_meteor_hammer_lua6_gem5 = item_meteor_hammer_lua1_gem5 or class({})
item_meteor_hammer_lua7_gem5 = item_meteor_hammer_lua1_gem5 or class({})
item_meteor_hammer_lua8_gem5 = item_meteor_hammer_lua1_gem5 or class({})

LinkLuaModifier("modifier_gem1", 'items/items_gems/gem1', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem2", 'items/items_gems/gem2', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem3", 'items/items_gems/gem3', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem4", 'items/items_gems/gem4', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem5", 'items/items_gems/gem5', LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_item_meteor_hammer_passive1", 'items/items_gems/item_meteor_hammer_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_meteor_hammer_passive2", 'items/items_gems/item_meteor_hammer_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_meteor_hammer_passive3", 'items/items_gems/item_meteor_hammer_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_meteor_hammer_passive4", 'items/items_gems/item_meteor_hammer_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_meteor_hammer_passive5", 'items/items_gems/item_meteor_hammer_lua.lua', LUA_MODIFIER_MOTION_NONE)

function item_meteor_hammer_lua1_gem1:GetIntrinsicModifierName()
	return "modifier_item_meteor_hammer_passive1"
end
function item_meteor_hammer_lua1_gem2:GetIntrinsicModifierName()
	return "modifier_item_meteor_hammer_passive2"
end
function item_meteor_hammer_lua1_gem3:GetIntrinsicModifierName()
	return "modifier_item_meteor_hammer_passive3"
end
function item_meteor_hammer_lua1_gem4:GetIntrinsicModifierName()
	return "modifier_item_meteor_hammer_passive4"
end
function item_meteor_hammer_lua1_gem5:GetIntrinsicModifierName()
	return "modifier_item_meteor_hammer_passive5"
end

-----------------------------------------------------------------------------------------

function item_meteor_hammer_lua1_gem1:GetAOERadius()
	return self:GetSpecialValueFor("impact_radius")
end

function item_meteor_hammer_lua1_gem1:OnSpellStart()
	self.caster = self:GetCaster()
	
	self.burn_dps_buildings			=	self:GetSpecialValueFor("burn_dps_buildings")
	self.burn_dps_units				=	self:GetSpecialValueFor("burn_dps_units")
	self.burn_duration				=	self:GetSpecialValueFor("burn_duration")
	self.stun_duration				=	self:GetSpecialValueFor("stun_duration")
	self.burn_interval				=	self:GetSpecialValueFor("burn_interval")
	self.land_time					=	self:GetSpecialValueFor("land_time")
	self.impact_radius				=	self:GetSpecialValueFor("impact_radius")
	self.max_duration				=	self:GetSpecialValueFor("max_duration")
	self.impact_damage_buildings	=	self:GetSpecialValueFor("impact_damage_buildings")
	self.impact_damage_units		=	self:GetSpecialValueFor("impact_damage_units")

	if not IsServer() then return end

	local position	= self:GetCursorPosition()
	
	self.caster:EmitSound("DOTA_Item.MeteorHammer.Channel")
	
	AddFOWViewer(self.caster:GetTeam(), position, self.impact_radius, 3.8, false)

	self.particle = ParticleManager:CreateParticleForTeam("particles/items4_fx/meteor_hammer_aoe.vpcf", PATTACH_WORLDORIGIN, self.caster, self.caster:GetTeam())
	ParticleManager:SetParticleControl(self.particle, 0, position)
	ParticleManager:SetParticleControl(self.particle, 1, Vector(self.impact_radius, 1, 1))
	
	self.particle2 = ParticleManager:CreateParticle("particles/items4_fx/meteor_hammer_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
	self.caster:StartGesture(ACT_DOTA_GENERIC_CHANNEL_1)
end

function item_meteor_hammer_lua1_gem1:OnChannelFinish(bInterrupted)
	if not IsServer() then return end

	self.position = self:GetCursorPosition()

	self.caster:RemoveGesture(ACT_DOTA_GENERIC_CHANNEL_1)

	if bInterrupted then
		self.caster:StopSound("DOTA_Item.MeteorHammer.Channel")
	
		ParticleManager:DestroyParticle(self.particle, true)
		ParticleManager:DestroyParticle(self.particle2, true)
	else
		self.caster:EmitSound("DOTA_Item.MeteorHammer.Cast")
	
		self.particle3	= ParticleManager:CreateParticle("particles/items4_fx/meteor_hammer_spell.vpcf", PATTACH_WORLDORIGIN, self.caster)
		ParticleManager:SetParticleControl(self.particle3, 0, self.position + Vector(0, 0, 1000))
		ParticleManager:SetParticleControl(self.particle3, 1, self.position)
		ParticleManager:SetParticleControl(self.particle3, 2, Vector(self.land_time, 0, 0))
		ParticleManager:ReleaseParticleIndex(self.particle3)
		
		Timers:CreateTimer(self.land_time, function()
			if not self:IsNull() then
				GridNav:DestroyTreesAroundPoint(self.position, self.impact_radius, true)
			
				EmitSoundOnLocationWithCaster(self.position, "DOTA_Item.MeteorHammer.Impact", self.caster)
			
				local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.position, nil, self.impact_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				
				for _, enemy in pairs(enemies) do
					enemy:EmitSound("DOTA_Item.MeteorHammer.Damage")
				
					enemy:AddNewModifier(self.caster, self, "modifier_stunned", {duration = self.stun_duration * (1 - enemy:GetStatusResistance())})
					enemy:AddNewModifier(self.caster, self, "modifier_item_meteor_hammer_passive1_burn", {duration = self.burn_duration})
					
					local impactDamage = self.impact_damage_units
					
					if enemy:IsBuilding() then
						impactDamage = self.impact_damage_buildings
					end
					
					local damageTable = {
						victim 			= enemy,
						damage 			= impactDamage,
						damage_type		= DAMAGE_TYPE_MAGICAL,
						damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
						attacker 		= self.caster,
						ability 		= self
					}
									
					ApplyDamage(damageTable)
				end
			end
		end)
	end
	
	ParticleManager:ReleaseParticleIndex(self.particle)
	ParticleManager:ReleaseParticleIndex(self.particle2)
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

modifier_item_meteor_hammer_passive1 = class({})

function modifier_item_meteor_hammer_passive1:IsHidden()			return true end
function modifier_item_meteor_hammer_passive1:IsPurgable()		return false end
function modifier_item_meteor_hammer_passive1:RemoveOnDeath()	return false end

function modifier_item_meteor_hammer_passive1:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
	
	self.ability = self:GetAbility()
	
	if self.ability == nil then return end
	
	self.bonus_strength				=	self.ability:GetSpecialValueFor("bonus_all_stats")
	self.bonus_intellect			=	self.ability:GetSpecialValueFor("bonus_all_stats")
	self.bonus_agility			=	self.ability:GetSpecialValueFor("bonus_all_stats")
	self.bonus_health_regen			=	self.ability:GetSpecialValueFor("bonus_health_regen")
	self.bonus_mana_regen			=	self.ability:GetSpecialValueFor("bonus_mana_regen")
	if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_meteor_hammer_passive1:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end


function modifier_item_meteor_hammer_passive1:DeclareFunctions()
    local decFuncs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
    }
    return decFuncs
end

function modifier_item_meteor_hammer_passive1:GetModifierBonusStats_Strength()
	return self.bonus_strength	
end

function modifier_item_meteor_hammer_passive1:GetModifierBonusStats_Intellect()
	return self.bonus_intellect
end

function modifier_item_meteor_hammer_passive1:GetModifierBonusStats_Agility()
	return self.bonus_agility
end

function modifier_item_meteor_hammer_passive1:GetModifierConstantHealthRegen()
	return self.bonus_health_regen
end

function modifier_item_meteor_hammer_passive1:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end



-----------------------------------------------------------------------------------------

function item_meteor_hammer_lua1_gem2:GetAOERadius()
	return self:GetSpecialValueFor("impact_radius")
end

function item_meteor_hammer_lua1_gem2:OnSpellStart()
	self.caster = self:GetCaster()
	
	self.burn_dps_buildings			=	self:GetSpecialValueFor("burn_dps_buildings")
	self.burn_dps_units				=	self:GetSpecialValueFor("burn_dps_units")
	self.burn_duration				=	self:GetSpecialValueFor("burn_duration")
	self.stun_duration				=	self:GetSpecialValueFor("stun_duration")
	self.burn_interval				=	self:GetSpecialValueFor("burn_interval")
	self.land_time					=	self:GetSpecialValueFor("land_time")
	self.impact_radius				=	self:GetSpecialValueFor("impact_radius")
	self.max_duration				=	self:GetSpecialValueFor("max_duration")
	self.impact_damage_buildings	=	self:GetSpecialValueFor("impact_damage_buildings")
	self.impact_damage_units		=	self:GetSpecialValueFor("impact_damage_units")

	if not IsServer() then return end

	local position	= self:GetCursorPosition()
	
	self.caster:EmitSound("DOTA_Item.MeteorHammer.Channel")
	
	AddFOWViewer(self.caster:GetTeam(), position, self.impact_radius, 3.8, false)

	self.particle = ParticleManager:CreateParticleForTeam("particles/items4_fx/meteor_hammer_aoe.vpcf", PATTACH_WORLDORIGIN, self.caster, self.caster:GetTeam())
	ParticleManager:SetParticleControl(self.particle, 0, position)
	ParticleManager:SetParticleControl(self.particle, 1, Vector(self.impact_radius, 1, 1))
	
	self.particle2 = ParticleManager:CreateParticle("particles/items4_fx/meteor_hammer_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
	self.caster:StartGesture(ACT_DOTA_GENERIC_CHANNEL_1)
end

function item_meteor_hammer_lua1_gem2:OnChannelFinish(bInterrupted)
	if not IsServer() then return end

	self.position = self:GetCursorPosition()

	self.caster:RemoveGesture(ACT_DOTA_GENERIC_CHANNEL_1)

	if bInterrupted then
		self.caster:StopSound("DOTA_Item.MeteorHammer.Channel")
	
		ParticleManager:DestroyParticle(self.particle, true)
		ParticleManager:DestroyParticle(self.particle2, true)
	else
		self.caster:EmitSound("DOTA_Item.MeteorHammer.Cast")
	
		self.particle3	= ParticleManager:CreateParticle("particles/items4_fx/meteor_hammer_spell.vpcf", PATTACH_WORLDORIGIN, self.caster)
		ParticleManager:SetParticleControl(self.particle3, 0, self.position + Vector(0, 0, 1000))
		ParticleManager:SetParticleControl(self.particle3, 1, self.position)
		ParticleManager:SetParticleControl(self.particle3, 2, Vector(self.land_time, 0, 0))
		ParticleManager:ReleaseParticleIndex(self.particle3)
		
		Timers:CreateTimer(self.land_time, function()
			if not self:IsNull() then
				GridNav:DestroyTreesAroundPoint(self.position, self.impact_radius, true)
			
				EmitSoundOnLocationWithCaster(self.position, "DOTA_Item.MeteorHammer.Impact", self.caster)
			
				local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.position, nil, self.impact_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				
				for _, enemy in pairs(enemies) do
					enemy:EmitSound("DOTA_Item.MeteorHammer.Damage")
				
					enemy:AddNewModifier(self.caster, self, "modifier_stunned", {duration = self.stun_duration * (1 - enemy:GetStatusResistance())})
					enemy:AddNewModifier(self.caster, self, "modifier_item_meteor_hammer_passive1_burn", {duration = self.burn_duration})
					
					local impactDamage = self.impact_damage_units
					
					if enemy:IsBuilding() then
						impactDamage = self.impact_damage_buildings
					end
					
					local damageTable = {
						victim 			= enemy,
						damage 			= impactDamage,
						damage_type		= DAMAGE_TYPE_MAGICAL,
						damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
						attacker 		= self.caster,
						ability 		= self
					}
									
					ApplyDamage(damageTable)
				end
			end
		end)
	end
	
	ParticleManager:ReleaseParticleIndex(self.particle)
	ParticleManager:ReleaseParticleIndex(self.particle2)
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

modifier_item_meteor_hammer_passive2 = class({})

function modifier_item_meteor_hammer_passive2:IsHidden()			return true end
function modifier_item_meteor_hammer_passive2:IsPurgable()		return false end
function modifier_item_meteor_hammer_passive2:RemoveOnDeath()	return false end

function modifier_item_meteor_hammer_passive2:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
	
	self.ability = self:GetAbility()
	
	if self.ability == nil then return end
	
	self.bonus_strength				=	self.ability:GetSpecialValueFor("bonus_all_stats")
	self.bonus_intellect			=	self.ability:GetSpecialValueFor("bonus_all_stats")
	self.bonus_agility			=	self.ability:GetSpecialValueFor("bonus_all_stats")
	self.bonus_health_regen			=	self.ability:GetSpecialValueFor("bonus_health_regen")
	self.bonus_mana_regen			=	self.ability:GetSpecialValueFor("bonus_mana_regen")
	if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_meteor_hammer_passive2:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end


function modifier_item_meteor_hammer_passive2:DeclareFunctions()
    local decFuncs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
    }
    return decFuncs
end

function modifier_item_meteor_hammer_passive2:GetModifierBonusStats_Strength()
	return self.bonus_strength	
end

function modifier_item_meteor_hammer_passive2:GetModifierBonusStats_Intellect()
	return self.bonus_intellect
end

function modifier_item_meteor_hammer_passive2:GetModifierBonusStats_Agility()
	return self.bonus_agility
end

function modifier_item_meteor_hammer_passive2:GetModifierConstantHealthRegen()
	return self.bonus_health_regen
end

function modifier_item_meteor_hammer_passive2:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end


-----------------------------------------------------------------------------------------

function item_meteor_hammer_lua1_gem3:GetAOERadius()
	return self:GetSpecialValueFor("impact_radius")
end

function item_meteor_hammer_lua1_gem3:OnSpellStart()
	self.caster = self:GetCaster()
	
	self.burn_dps_buildings			=	self:GetSpecialValueFor("burn_dps_buildings")
	self.burn_dps_units				=	self:GetSpecialValueFor("burn_dps_units")
	self.burn_duration				=	self:GetSpecialValueFor("burn_duration")
	self.stun_duration				=	self:GetSpecialValueFor("stun_duration")
	self.burn_interval				=	self:GetSpecialValueFor("burn_interval")
	self.land_time					=	self:GetSpecialValueFor("land_time")
	self.impact_radius				=	self:GetSpecialValueFor("impact_radius")
	self.max_duration				=	self:GetSpecialValueFor("max_duration")
	self.impact_damage_buildings	=	self:GetSpecialValueFor("impact_damage_buildings")
	self.impact_damage_units		=	self:GetSpecialValueFor("impact_damage_units")

	if not IsServer() then return end

	local position	= self:GetCursorPosition()
	
	self.caster:EmitSound("DOTA_Item.MeteorHammer.Channel")
	
	AddFOWViewer(self.caster:GetTeam(), position, self.impact_radius, 3.8, false)

	self.particle = ParticleManager:CreateParticleForTeam("particles/items4_fx/meteor_hammer_aoe.vpcf", PATTACH_WORLDORIGIN, self.caster, self.caster:GetTeam())
	ParticleManager:SetParticleControl(self.particle, 0, position)
	ParticleManager:SetParticleControl(self.particle, 1, Vector(self.impact_radius, 1, 1))
	
	self.particle2 = ParticleManager:CreateParticle("particles/items4_fx/meteor_hammer_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
	self.caster:StartGesture(ACT_DOTA_GENERIC_CHANNEL_1)
end

function item_meteor_hammer_lua1_gem3:OnChannelFinish(bInterrupted)
	if not IsServer() then return end

	self.position = self:GetCursorPosition()

	self.caster:RemoveGesture(ACT_DOTA_GENERIC_CHANNEL_1)

	if bInterrupted then
		self.caster:StopSound("DOTA_Item.MeteorHammer.Channel")
	
		ParticleManager:DestroyParticle(self.particle, true)
		ParticleManager:DestroyParticle(self.particle2, true)
	else
		self.caster:EmitSound("DOTA_Item.MeteorHammer.Cast")
	
		self.particle3	= ParticleManager:CreateParticle("particles/items4_fx/meteor_hammer_spell.vpcf", PATTACH_WORLDORIGIN, self.caster)
		ParticleManager:SetParticleControl(self.particle3, 0, self.position + Vector(0, 0, 1000))
		ParticleManager:SetParticleControl(self.particle3, 1, self.position)
		ParticleManager:SetParticleControl(self.particle3, 2, Vector(self.land_time, 0, 0))
		ParticleManager:ReleaseParticleIndex(self.particle3)
		
		Timers:CreateTimer(self.land_time, function()
			if not self:IsNull() then
				GridNav:DestroyTreesAroundPoint(self.position, self.impact_radius, true)
			
				EmitSoundOnLocationWithCaster(self.position, "DOTA_Item.MeteorHammer.Impact", self.caster)
			
				local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.position, nil, self.impact_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				
				for _, enemy in pairs(enemies) do
					enemy:EmitSound("DOTA_Item.MeteorHammer.Damage")
				
					enemy:AddNewModifier(self.caster, self, "modifier_stunned", {duration = self.stun_duration * (1 - enemy:GetStatusResistance())})
					enemy:AddNewModifier(self.caster, self, "modifier_item_meteor_hammer_passive1_burn", {duration = self.burn_duration})
					
					local impactDamage = self.impact_damage_units
					
					if enemy:IsBuilding() then
						impactDamage = self.impact_damage_buildings
					end
					
					local damageTable = {
						victim 			= enemy,
						damage 			= impactDamage,
						damage_type		= DAMAGE_TYPE_MAGICAL,
						damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
						attacker 		= self.caster,
						ability 		= self
					}
									
					ApplyDamage(damageTable)
				end
			end
		end)
	end
	
	ParticleManager:ReleaseParticleIndex(self.particle)
	ParticleManager:ReleaseParticleIndex(self.particle2)
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

modifier_item_meteor_hammer_passive3 = class({})

function modifier_item_meteor_hammer_passive3:IsHidden()			return true end
function modifier_item_meteor_hammer_passive3:IsPurgable()		return false end
function modifier_item_meteor_hammer_passive3:RemoveOnDeath()	return false end

function modifier_item_meteor_hammer_passive3:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
	
	self.ability = self:GetAbility()
	
	if self.ability == nil then return end
	
	self.bonus_strength				=	self.ability:GetSpecialValueFor("bonus_all_stats")
	self.bonus_intellect			=	self.ability:GetSpecialValueFor("bonus_all_stats")
	self.bonus_agility			=	self.ability:GetSpecialValueFor("bonus_all_stats")
	self.bonus_health_regen			=	self.ability:GetSpecialValueFor("bonus_health_regen")
	self.bonus_mana_regen			=	self.ability:GetSpecialValueFor("bonus_mana_regen")
	if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_meteor_hammer_passive3:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end


function modifier_item_meteor_hammer_passive3:DeclareFunctions()
    local decFuncs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
    }
    return decFuncs
end

function modifier_item_meteor_hammer_passive3:GetModifierBonusStats_Strength()
	return self.bonus_strength	
end

function modifier_item_meteor_hammer_passive3:GetModifierBonusStats_Intellect()
	return self.bonus_intellect
end

function modifier_item_meteor_hammer_passive3:GetModifierBonusStats_Agility()
	return self.bonus_agility
end

function modifier_item_meteor_hammer_passive3:GetModifierConstantHealthRegen()
	return self.bonus_health_regen
end

function modifier_item_meteor_hammer_passive3:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end



-----------------------------------------------------------------------------------------

function item_meteor_hammer_lua1_gem4:GetAOERadius()
	return self:GetSpecialValueFor("impact_radius")
end

function item_meteor_hammer_lua1_gem4:OnSpellStart()
	self.caster = self:GetCaster()
	
	self.burn_dps_buildings			=	self:GetSpecialValueFor("burn_dps_buildings")
	self.burn_dps_units				=	self:GetSpecialValueFor("burn_dps_units")
	self.burn_duration				=	self:GetSpecialValueFor("burn_duration")
	self.stun_duration				=	self:GetSpecialValueFor("stun_duration")
	self.burn_interval				=	self:GetSpecialValueFor("burn_interval")
	self.land_time					=	self:GetSpecialValueFor("land_time")
	self.impact_radius				=	self:GetSpecialValueFor("impact_radius")
	self.max_duration				=	self:GetSpecialValueFor("max_duration")
	self.impact_damage_buildings	=	self:GetSpecialValueFor("impact_damage_buildings")
	self.impact_damage_units		=	self:GetSpecialValueFor("impact_damage_units")

	if not IsServer() then return end

	local position	= self:GetCursorPosition()
	
	self.caster:EmitSound("DOTA_Item.MeteorHammer.Channel")
	
	AddFOWViewer(self.caster:GetTeam(), position, self.impact_radius, 3.8, false)

	self.particle = ParticleManager:CreateParticleForTeam("particles/items4_fx/meteor_hammer_aoe.vpcf", PATTACH_WORLDORIGIN, self.caster, self.caster:GetTeam())
	ParticleManager:SetParticleControl(self.particle, 0, position)
	ParticleManager:SetParticleControl(self.particle, 1, Vector(self.impact_radius, 1, 1))
	
	self.particle2 = ParticleManager:CreateParticle("particles/items4_fx/meteor_hammer_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
	self.caster:StartGesture(ACT_DOTA_GENERIC_CHANNEL_1)
end

function item_meteor_hammer_lua1_gem4:OnChannelFinish(bInterrupted)
	if not IsServer() then return end

	self.position = self:GetCursorPosition()

	self.caster:RemoveGesture(ACT_DOTA_GENERIC_CHANNEL_1)

	if bInterrupted then
		self.caster:StopSound("DOTA_Item.MeteorHammer.Channel")
	
		ParticleManager:DestroyParticle(self.particle, true)
		ParticleManager:DestroyParticle(self.particle2, true)
	else
		self.caster:EmitSound("DOTA_Item.MeteorHammer.Cast")
	
		self.particle3	= ParticleManager:CreateParticle("particles/items4_fx/meteor_hammer_spell.vpcf", PATTACH_WORLDORIGIN, self.caster)
		ParticleManager:SetParticleControl(self.particle3, 0, self.position + Vector(0, 0, 1000))
		ParticleManager:SetParticleControl(self.particle3, 1, self.position)
		ParticleManager:SetParticleControl(self.particle3, 2, Vector(self.land_time, 0, 0))
		ParticleManager:ReleaseParticleIndex(self.particle3)
		
		Timers:CreateTimer(self.land_time, function()
			if not self:IsNull() then
				GridNav:DestroyTreesAroundPoint(self.position, self.impact_radius, true)
			
				EmitSoundOnLocationWithCaster(self.position, "DOTA_Item.MeteorHammer.Impact", self.caster)
			
				local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.position, nil, self.impact_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				
				for _, enemy in pairs(enemies) do
					enemy:EmitSound("DOTA_Item.MeteorHammer.Damage")
				
					enemy:AddNewModifier(self.caster, self, "modifier_stunned", {duration = self.stun_duration * (1 - enemy:GetStatusResistance())})
					enemy:AddNewModifier(self.caster, self, "modifier_item_meteor_hammer_passive1_burn", {duration = self.burn_duration})
					
					local impactDamage = self.impact_damage_units
					
					if enemy:IsBuilding() then
						impactDamage = self.impact_damage_buildings
					end
					
					local damageTable = {
						victim 			= enemy,
						damage 			= impactDamage,
						damage_type		= DAMAGE_TYPE_MAGICAL,
						damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
						attacker 		= self.caster,
						ability 		= self
					}
									
					ApplyDamage(damageTable)
				end
			end
		end)
	end
	
	ParticleManager:ReleaseParticleIndex(self.particle)
	ParticleManager:ReleaseParticleIndex(self.particle2)
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

modifier_item_meteor_hammer_passive4 = class({})

function modifier_item_meteor_hammer_passive4:IsHidden()			return true end
function modifier_item_meteor_hammer_passive4:IsPurgable()		return false end
function modifier_item_meteor_hammer_passive4:RemoveOnDeath()	return false end

function modifier_item_meteor_hammer_passive4:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
	
	self.ability = self:GetAbility()
	
	if self.ability == nil then return end
	
	self.bonus_strength				=	self.ability:GetSpecialValueFor("bonus_all_stats")
	self.bonus_intellect			=	self.ability:GetSpecialValueFor("bonus_all_stats")
	self.bonus_agility			=	self.ability:GetSpecialValueFor("bonus_all_stats")
	self.bonus_health_regen			=	self.ability:GetSpecialValueFor("bonus_health_regen")
	self.bonus_mana_regen			=	self.ability:GetSpecialValueFor("bonus_mana_regen")
	if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_meteor_hammer_passive4:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end


function modifier_item_meteor_hammer_passive4:DeclareFunctions()
    local decFuncs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
    }
    return decFuncs
end

function modifier_item_meteor_hammer_passive4:GetModifierBonusStats_Strength()
	return self.bonus_strength	
end

function modifier_item_meteor_hammer_passive4:GetModifierBonusStats_Intellect()
	return self.bonus_intellect
end

function modifier_item_meteor_hammer_passive4:GetModifierBonusStats_Agility()
	return self.bonus_agility
end

function modifier_item_meteor_hammer_passive4:GetModifierConstantHealthRegen()
	return self.bonus_health_regen
end

function modifier_item_meteor_hammer_passive4:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end


-----------------------------------------------------------------------------------------

function item_meteor_hammer_lua1_gem5:GetAOERadius()
	return self:GetSpecialValueFor("impact_radius")
end

function item_meteor_hammer_lua1_gem5:OnSpellStart()
	self.caster = self:GetCaster()
	
	self.burn_dps_buildings			=	self:GetSpecialValueFor("burn_dps_buildings")
	self.burn_dps_units				=	self:GetSpecialValueFor("burn_dps_units")
	self.burn_duration				=	self:GetSpecialValueFor("burn_duration")
	self.stun_duration				=	self:GetSpecialValueFor("stun_duration")
	self.burn_interval				=	self:GetSpecialValueFor("burn_interval")
	self.land_time					=	self:GetSpecialValueFor("land_time")
	self.impact_radius				=	self:GetSpecialValueFor("impact_radius")
	self.max_duration				=	self:GetSpecialValueFor("max_duration")
	self.impact_damage_buildings	=	self:GetSpecialValueFor("impact_damage_buildings")
	self.impact_damage_units		=	self:GetSpecialValueFor("impact_damage_units")

	if not IsServer() then return end

	local position	= self:GetCursorPosition()
	
	self.caster:EmitSound("DOTA_Item.MeteorHammer.Channel")
	
	AddFOWViewer(self.caster:GetTeam(), position, self.impact_radius, 3.8, false)

	self.particle = ParticleManager:CreateParticleForTeam("particles/items4_fx/meteor_hammer_aoe.vpcf", PATTACH_WORLDORIGIN, self.caster, self.caster:GetTeam())
	ParticleManager:SetParticleControl(self.particle, 0, position)
	ParticleManager:SetParticleControl(self.particle, 1, Vector(self.impact_radius, 1, 1))
	
	self.particle2 = ParticleManager:CreateParticle("particles/items4_fx/meteor_hammer_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
	self.caster:StartGesture(ACT_DOTA_GENERIC_CHANNEL_1)
end

function item_meteor_hammer_lua1_gem5:OnChannelFinish(bInterrupted)
	if not IsServer() then return end

	self.position = self:GetCursorPosition()

	self.caster:RemoveGesture(ACT_DOTA_GENERIC_CHANNEL_1)

	if bInterrupted then
		self.caster:StopSound("DOTA_Item.MeteorHammer.Channel")
	
		ParticleManager:DestroyParticle(self.particle, true)
		ParticleManager:DestroyParticle(self.particle2, true)
	else
		self.caster:EmitSound("DOTA_Item.MeteorHammer.Cast")
	
		self.particle3	= ParticleManager:CreateParticle("particles/items4_fx/meteor_hammer_spell.vpcf", PATTACH_WORLDORIGIN, self.caster)
		ParticleManager:SetParticleControl(self.particle3, 0, self.position + Vector(0, 0, 1000))
		ParticleManager:SetParticleControl(self.particle3, 1, self.position)
		ParticleManager:SetParticleControl(self.particle3, 2, Vector(self.land_time, 0, 0))
		ParticleManager:ReleaseParticleIndex(self.particle3)
		
		Timers:CreateTimer(self.land_time, function()
			if not self:IsNull() then
				GridNav:DestroyTreesAroundPoint(self.position, self.impact_radius, true)
			
				EmitSoundOnLocationWithCaster(self.position, "DOTA_Item.MeteorHammer.Impact", self.caster)
			
				local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.position, nil, self.impact_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				
				for _, enemy in pairs(enemies) do
					enemy:EmitSound("DOTA_Item.MeteorHammer.Damage")
				
					enemy:AddNewModifier(self.caster, self, "modifier_stunned", {duration = self.stun_duration * (1 - enemy:GetStatusResistance())})
					enemy:AddNewModifier(self.caster, self, "modifier_item_meteor_hammer_passive1_burn", {duration = self.burn_duration})
					
					local impactDamage = self.impact_damage_units
					
					if enemy:IsBuilding() then
						impactDamage = self.impact_damage_buildings
					end
					
					local damageTable = {
						victim 			= enemy,
						damage 			= impactDamage,
						damage_type		= DAMAGE_TYPE_MAGICAL,
						damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
						attacker 		= self.caster,
						ability 		= self
					}
									
					ApplyDamage(damageTable)
				end
			end
		end)
	end
	
	ParticleManager:ReleaseParticleIndex(self.particle)
	ParticleManager:ReleaseParticleIndex(self.particle2)
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

modifier_item_meteor_hammer_passive5 = class({})

function modifier_item_meteor_hammer_passive5:IsHidden()			return true end
function modifier_item_meteor_hammer_passive5:IsPurgable()		return false end
function modifier_item_meteor_hammer_passive5:RemoveOnDeath()	return false end

function modifier_item_meteor_hammer_passive5:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
	
	self.ability = self:GetAbility()
	
	if self.ability == nil then return end
	
	self.bonus_strength				=	self.ability:GetSpecialValueFor("bonus_all_stats")
	self.bonus_intellect			=	self.ability:GetSpecialValueFor("bonus_all_stats")
	self.bonus_agility			=	self.ability:GetSpecialValueFor("bonus_all_stats")
	self.bonus_health_regen			=	self.ability:GetSpecialValueFor("bonus_health_regen")
	self.bonus_mana_regen			=	self.ability:GetSpecialValueFor("bonus_mana_regen")
	if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_meteor_hammer_passive5:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end


function modifier_item_meteor_hammer_passive5:DeclareFunctions()
    local decFuncs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
    }
    return decFuncs
end

function modifier_item_meteor_hammer_passive5:GetModifierBonusStats_Strength()
	return self.bonus_strength	
end

function modifier_item_meteor_hammer_passive5:GetModifierBonusStats_Intellect()
	return self.bonus_intellect
end

function modifier_item_meteor_hammer_passive5:GetModifierBonusStats_Agility()
	return self.bonus_agility
end

function modifier_item_meteor_hammer_passive5:GetModifierConstantHealthRegen()
	return self.bonus_health_regen
end

function modifier_item_meteor_hammer_passive5:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

modifier_item_meteor_hammer_passive1_burn = class({})

function modifier_item_meteor_hammer_passive1_burn:GetEffectName()
	return "particles/items4_fx/meteor_hammer_spell_debuff.vpcf"
end

function modifier_item_meteor_hammer_passive1_burn:IgnoreTenacity()
	return true
end

function modifier_item_meteor_hammer_passive1_burn:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()
	
	if self.ability == nil then return end
	
	self.burn_dps_buildings			=	self.ability:GetSpecialValueFor("burn_dps_buildings")
	self.burn_dps_units				=	self.ability:GetSpecialValueFor("burn_dps_units")
	self.burn_duration				=	self.ability:GetSpecialValueFor("burn_duration")
	self.stun_duration				=	self.ability:GetSpecialValueFor("stun_duration")
	self.burn_interval				=	self.ability:GetSpecialValueFor("burn_interval")
	self.land_time					=	self.ability:GetSpecialValueFor("land_time")
	self.impact_radius				=	self.ability:GetSpecialValueFor("impact_radius")
	self.max_duration				=	self.ability:GetSpecialValueFor("max_duration")
	self.impact_damage_buildings	=	self.ability:GetSpecialValueFor("impact_damage_buildings")
	self.impact_damage_units		=	self.ability:GetSpecialValueFor("impact_damage_units")
	self.spell_reduction_pct		=	self.ability:GetSpecialValueFor("spell_reduction_pct")
	
	self.affectedUnits				= {}
	
	table.insert(self.affectedUnits, self.parent)
	
	self.burn_dps					= self.burn_dps_units
	
	if self.parent:IsBuilding() then
		self.burn_dps	= self.burn_dps_buildings
	end
	
	self.damageTable				= {
										victim 			= self.parent,
										damage 			= self.burn_dps,
										damage_type		= DAMAGE_TYPE_MAGICAL,
										damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
										attacker 		= self.caster,
										ability 		= self.ability
									}
	
	if not IsServer() then return end

	self:StartIntervalThink(self.burn_interval)
end

function modifier_item_meteor_hammer_passive1_burn:OnIntervalThink()
	if not IsServer() then return end
				
	ApplyDamage(self.damageTable)
	
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self.parent, self.burn_dps, nil)
end