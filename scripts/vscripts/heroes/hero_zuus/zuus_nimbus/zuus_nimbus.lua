LinkLuaModifier("modifier_zuus_nimbus_storm", "heroes/hero_zuus/zuus_nimbus/zuus_nimbus.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_spell_ampl_nimbus", "heroes/hero_zuus/zuus_nimbus/zuus_nimbus.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_other", "modifiers/modifier_other.lua", LUA_MODIFIER_MOTION_NONE )

zuus_nimbus = zuus_nimbus or class({})

function zuus_nimbus:IsInnateAbility() return true end

function zuus_nimbus:GetAOERadius()
	return self:GetSpecialValueFor("cloud_radius")
end

function zuus_nimbus:IsInnateAbility() return true end

function zuus_nimbus:GetAssociatedPrimaryAbilities()
	return "zuus_arc_lightning_lua"
end

function zuus_nimbus:GetManaCost(iLevel)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_int10")	 ~= nil then 
        return 50 + math.min(65000, self:GetCaster():GetIntellect()/200)
	end
        return 100 + math.min(65000, self:GetCaster():GetIntellect()/100)
end

function zuus_nimbus:OnSpellStart()
	if IsServer() then
		self.target_point 			= self:GetCursorPosition()
		local caster 				= self:GetCaster()
		
		local cloud_interval 	= self:GetSpecialValueFor("cloud_interval")
		local cloud_duration 		= self:GetSpecialValueFor("cloud_duration")
		local cloud_radius 			= self:GetSpecialValueFor("cloud_radius")
		local level						= self:GetLevel()
		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_int8")	
		if abil ~= nil then 
		cloud_interval = cloud_interval/2
		end

		EmitSoundOnLocationWithCaster(self.target_point, "Hero_Zuus.Cloud.Cast", caster)
		
		self.zuus_nimbus_unit = CreateUnitByName("npc_dota_zeus_cloud", Vector(self.target_point.x, self.target_point.y, 450), false, caster, nil, caster:GetTeam())
		self.zuus_nimbus_unit:SetControllableByPlayer(caster:GetPlayerID(), true)
		self.zuus_nimbus_unit:SetModelScale(0.7)
		self.zuus_nimbus_unit:SetOwner(caster)
		self.zuus_nimbus_unit:AddAbility("nimbus_lightning"):SetLevel(level)
		self.zuus_nimbus_unit:AddNewModifier(self.zuus_nimbus_unit, self, "modifier_other", {})
		self.zuus_nimbus_unit:AddNewModifier(self.zuus_nimbus_unit, self, "modifier_spell_ampl_nimbus",  { }) 
		self.zuus_nimbus_unit:AddNewModifier(caster, self, "modifier_zuus_nimbus_storm", {duration = cloud_duration, cloud_interval = cloud_interval, cloud_radius = cloud_radius})
		self.zuus_nimbus_unit:AddNewModifier(caster, nil, "modifier_kill", {duration = cloud_duration})
	end
end

modifier_zuus_nimbus_storm = class({})

function modifier_zuus_nimbus_storm:IsHidden() return true end

function modifier_zuus_nimbus_storm:OnCreated(keys)
	if IsServer() then
		self.ability 				= self
		self.cloud_radius 			= keys.cloud_radius
		self.cloud_interval 		= keys.cloud_interval
		local target_point 			= GetGroundPosition(self:GetParent():GetAbsOrigin(), self:GetParent())
		self:StartIntervalThink(self.cloud_interval)
	end
end

function modifier_zuus_nimbus_storm:OnIntervalThink()
	if IsServer() then
	local nearby_enemy_units = nil
			local nearby_enemy_units = FindUnitsInRadius(
				self:GetCaster():GetTeamNumber(), 
				self:GetParent():GetAbsOrigin(), 
				nil, 
				self.cloud_radius, 
				DOTA_UNIT_TARGET_TEAM_ENEMY, 
				DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_NONE,
				FIND_CLOSEST,
				false
			)
			local ability2 = self:GetParent():FindAbilityByName("nimbus_lightning")	
			for _,unit in pairs(nearby_enemy_units) do
				if unit:IsAlive() then
					self:GetParent():CastAbilityOnTarget(unit, ability2, self:GetCaster():GetPlayerID())
			end
		end
	end
end

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

modifier_spell_ampl_nimbus = class({})

function modifier_spell_ampl_nimbus:IsHidden()
	return false
end

function modifier_spell_ampl_nimbus:IsPurgable()
	return false
end

function modifier_spell_ampl_nimbus:OnCreated()
if IsServer() then
	caster = self:GetCaster()
    player = caster:GetOwner()
	spell_amp_spirits = player:GetSpellAmplification(false) * 100
	end
end

function modifier_spell_ampl_nimbus:DeclareFunctions()
	return {MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE}
end

function modifier_spell_ampl_nimbus:GetModifierSpellAmplify_Percentage()
	return spell_amp_spirits
end
