LinkLuaModifier("modifier_arc_warden_magnetic_field_lua_thinker_attack_speed", "heroes/hero_arc/arc_field/arc_field", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_arc_warden_magnetic_field_lua_thinker_evasion", "heroes/hero_arc/arc_field/arc_field", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_arc_warden_magnetic_field_lua_attack_speed", "heroes/hero_arc/arc_field/arc_field", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_arc_warden_magnetic_field_lua_evasion", "heroes/hero_arc/arc_field/arc_field", LUA_MODIFIER_MOTION_NONE)


arc_warden_magnetic_field_lua									= arc_warden_magnetic_field_lua or class({})
modifier_arc_warden_magnetic_field_lua_thinker_attack_speed	= modifier_arc_warden_magnetic_field_lua_thinker_attack_speed or class({})
modifier_arc_warden_magnetic_field_lua_thinker_evasion			= modifier_arc_warden_magnetic_field_lua_thinker_evasion or class({})
modifier_arc_warden_magnetic_field_lua_attack_speed			= modifier_arc_warden_magnetic_field_lua_attack_speed or class({})
modifier_arc_warden_magnetic_field_lua_evasion					= modifier_arc_warden_magnetic_field_lua_evasion or class({})

function arc_warden_magnetic_field_lua:GetManaCost(iLevel)
 	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_arc_warden_int8")
	if abil ~= nil then
		return 50 + math.min(65000, self:GetCaster():GetIntellect() / 200)
	else
        return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
	end
end

function arc_warden_magnetic_field_lua:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function arc_warden_magnetic_field_lua:OnSpellStart()
	self:GetCaster():EmitSound("Hero_ArcWarden.MagneticField.Cast")
	
	local cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_magnetic_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt(cast_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(cast_particle)
	duration = self:GetSpecialValueFor("duration")
	if self:GetCaster():FindAbilityByName("npc_dota_hero_arc_warden_str_last") ~= nil then
		duration = self:GetSpecialValueFor("duration") + 5
	end
	
	CreateModifierThinker(self:GetCaster(), self, "modifier_arc_warden_magnetic_field_lua_thinker_attack_speed", {
		duration = duration
	}, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)
	CreateModifierThinker(self:GetCaster(), self, "modifier_arc_warden_magnetic_field_lua_thinker_evasion", {
		duration = duration
	}, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_arc_warden_int11")
	if abil ~= nil then
		local ability = self:GetCaster():FindAbilityByName( "ark_spark_lua")
		if ability~=nil and ability:GetLevel()>=1 then
			ability:OnSpellStart()
		end
	end
end

------------------------------------------------------------------
-- MODIFIER_arc_warden_magnetic_field_lua_THINKER_ATTACK_SPEED --
------------------------------------------------------------------

function modifier_arc_warden_magnetic_field_lua_thinker_attack_speed:OnCreated()
	if not self:GetAbility() then self:Destroy() return end
	
	self.radius				= self:GetAbility():GetSpecialValueFor("radius")
	self.attack_speed_bonus	= self:GetAbility():GetSpecialValueFor("attack_speed_bonus")
	
	if not IsServer() then return end
	
	self:GetParent():EmitSound("Hero_ArcWarden.MagneticField")
	
	self.magnetic_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_magnetic.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.magnetic_particle, 1, Vector(self.radius, 1, 1))
	self:AddParticle(self.magnetic_particle, false, false, 1, false, false)
end

function modifier_arc_warden_magnetic_field_lua_thinker_attack_speed:OnDestroy()
	if not IsServer() then return end
	
	self:GetParent():StopSound("Hero_ArcWarden.MagneticField")
end

function modifier_arc_warden_magnetic_field_lua_thinker_attack_speed:IsAura()						return true end
function modifier_arc_warden_magnetic_field_lua_thinker_attack_speed:IsAuraActiveOnDeath() 		return false end

function modifier_arc_warden_magnetic_field_lua_thinker_attack_speed:GetAuraDuration()				return 0.1 end
function modifier_arc_warden_magnetic_field_lua_thinker_attack_speed:GetAuraRadius()				return self.radius end
function modifier_arc_warden_magnetic_field_lua_thinker_attack_speed:GetAuraSearchFlags()			return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_arc_warden_magnetic_field_lua_thinker_attack_speed:GetAuraSearchTeam()			return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_arc_warden_magnetic_field_lua_thinker_attack_speed:GetAuraSearchType()			return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING end
function modifier_arc_warden_magnetic_field_lua_thinker_attack_speed:GetModifierAura()				return "modifier_arc_warden_magnetic_field_lua_attack_speed" end

-------------------------------------------------------------
-- MODIFIER_arc_warden_magnetic_field_lua_THINKER_EVASION --
-------------------------------------------------------------

function modifier_arc_warden_magnetic_field_lua_thinker_evasion:OnCreated()
	if not self:GetAbility() then self:Destroy() return end
	
	self.radius				= self:GetAbility():GetSpecialValueFor("radius")
	self.evasion_chance		= self:GetAbility():GetSpecialValueFor("evasion_chance")
end

function modifier_arc_warden_magnetic_field_lua_thinker_evasion:IsAura()						return true end
function modifier_arc_warden_magnetic_field_lua_thinker_evasion:IsAuraActiveOnDeath() 			return false end

function modifier_arc_warden_magnetic_field_lua_thinker_evasion:GetAuraDuration()				return 0.1 end
function modifier_arc_warden_magnetic_field_lua_thinker_evasion:GetAuraRadius()				return self.radius end
function modifier_arc_warden_magnetic_field_lua_thinker_evasion:GetAuraSearchFlags()			return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_arc_warden_magnetic_field_lua_thinker_evasion:GetAuraSearchTeam()			return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_arc_warden_magnetic_field_lua_thinker_evasion:GetAuraSearchType()			return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING end
function modifier_arc_warden_magnetic_field_lua_thinker_evasion:GetModifierAura()				return "modifier_arc_warden_magnetic_field_lua_evasion" end

----------------------------------------------------------
-- MODIFIER_arc_warden_magnetic_field_lua_ATTACK_SPEED --
----------------------------------------------------------

function modifier_arc_warden_magnetic_field_lua_attack_speed:OnCreated()
	if self:GetAbility() then
		self.attack_speed_bonus	= self:GetAbility():GetSpecialValueFor("attack_speed_bonus")
	elseif self:GetAuraOwner() and self:GetAuraOwner():HasModifier("modifier_arc_warden_magnetic_field_lua_thinker_attack_speed") then
		self.attack_speed_bonus	= self:GetAuraOwner():FindModifierByName("modifier_arc_warden_magnetic_field_lua_thinker_attack_speed").attack_speed_bonus
	else
		self:Destroy()
	end
end

function modifier_arc_warden_magnetic_field_lua_attack_speed:DeclareFunctions()
	return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
	MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_arc_warden_magnetic_field_lua_attack_speed:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed_bonus
end


function modifier_arc_warden_magnetic_field_lua_attack_speed:GetModifierPreAttack_BonusDamage()
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_arc_warden_agi10")
			if abil ~= nil	then 
			return self:GetCaster():GetAgility()
		end
	return 0
end

function modifier_arc_warden_magnetic_field_lua_attack_speed:GetModifierPhysicalArmorBonus()
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_arc_warden_str6")
			if abil ~= nil	then 
			return self:GetCaster():GetPhysicalArmorBaseValue()
		end
	return 0
end

function modifier_arc_warden_magnetic_field_lua_attack_speed:GetAbsoluteNoDamagePhysical()
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_arc_warden_str10")
			if abil ~= nil	then 
			return 1
		end
	return 0
end

function modifier_arc_warden_magnetic_field_lua_attack_speed:GetAbsoluteNoDamageMagical()
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_arc_warden_int6")
			if abil ~= nil	then 
			return 1
		end
	return 0
end
-----------------------------------------------------
-- MODIFIER_arc_warden_magnetic_field_lua_EVASION --
-----------------------------------------------------

function modifier_arc_warden_magnetic_field_lua_evasion:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_arc_warden_magnetic_field_lua_evasion:OnCreated()
	if self:GetAbility() then
		self.evasion_chance	= self:GetAbility():GetSpecialValueFor("evasion_chance")
	elseif self:GetAuraOwner() and self:GetAuraOwner():HasModifier("modifier_arc_warden_magnetic_field_lua_thinker_evasion") then
		self.evasion_chance	= self:GetAuraOwner():FindModifierByName("modifier_arc_warden_magnetic_field_lua_thinker_evasion").evasion_chance
	else
		self:Destroy()
	end
end

function modifier_arc_warden_magnetic_field_lua_evasion:DeclareFunctions()
	return {MODIFIER_PROPERTY_EVASION_CONSTANT}
end

function modifier_arc_warden_magnetic_field_lua_evasion:GetModifierEvasion_Constant(keys)
	if keys.attacker and self:GetAuraOwner() and self:GetAuraOwner():HasModifier("modifier_arc_warden_magnetic_field_lua_thinker_evasion") and self:GetAuraOwner():FindModifierByName("modifier_arc_warden_magnetic_field_lua_thinker_evasion").radius and (keys.attacker:GetAbsOrigin() - self:GetAuraOwner():GetAbsOrigin()):Length2D() > self:GetAuraOwner():FindModifierByName("modifier_arc_warden_magnetic_field_lua_thinker_evasion").radius then
		return self.evasion_chance
	end
end