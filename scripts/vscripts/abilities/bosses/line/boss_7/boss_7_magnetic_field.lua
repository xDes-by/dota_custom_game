LinkLuaModifier("modifier_boss_7_magnetic_field_thinker_evasion", "abilities/bosses/line/boss_7/boss_7_magnetic_field", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_boss_7_magnetic_field_evasion", "abilities/bosses/line/boss_7/boss_7_magnetic_field", LUA_MODIFIER_MOTION_NONE)

boss_7_magnetic_field = class({})

function boss_7_magnetic_field:OnSpellStart()
	self:GetCaster():EmitSound("Hero_ArcWarden.MagneticField.Cast")
	
	local cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_magnetic_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt(cast_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(cast_particle)
	
	CreateModifierThinker(self:GetCaster(), self, "modifier_boss_7_magnetic_field_thinker_evasion", {
		duration = self:GetSpecialValueFor("duration")
	}, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
end

------------------------------------------------------------------

modifier_boss_7_magnetic_field_thinker_evasion = class({})

function modifier_boss_7_magnetic_field_thinker_evasion:OnCreated()
	if not self:GetAbility() then self:Destroy() return end
	self.radius				= self:GetAbility():GetSpecialValueFor("radius")
	self.evasion_chance		= self:GetAbility():GetSpecialValueFor("evasion_chance")
	
			self.magnetic_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_magnetic.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.magnetic_particle, 1, Vector(self.radius, 1, 1))
		self:AddParticle(self.magnetic_particle, false, false, 1, false, false)
end

function modifier_boss_7_magnetic_field_thinker_evasion:IsAura()						return true end
function modifier_boss_7_magnetic_field_thinker_evasion:IsAuraActiveOnDeath() 			return false end
function modifier_boss_7_magnetic_field_thinker_evasion:GetAuraDuration()				return 0.1 end
function modifier_boss_7_magnetic_field_thinker_evasion:GetAuraRadius()				return self.radius end
function modifier_boss_7_magnetic_field_thinker_evasion:GetAuraSearchFlags()			return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_boss_7_magnetic_field_thinker_evasion:GetAuraSearchTeam()			return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_boss_7_magnetic_field_thinker_evasion:GetAuraSearchType()			return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING end
function modifier_boss_7_magnetic_field_thinker_evasion:GetModifierAura()				return "modifier_boss_7_magnetic_field_evasion" end

-------------------------------------------------------------------------------------
modifier_boss_7_magnetic_field_evasion = class({})

function modifier_boss_7_magnetic_field_evasion:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_boss_7_magnetic_field_evasion:OnCreated()
	if self:GetAbility() then

	
		self.evasion_chance	= self:GetAbility():GetSpecialValueFor("evasion_chance")
	elseif self:GetAuraOwner() and self:GetAuraOwner():HasModifier("modifier_boss_7_magnetic_field_thinker_evasion") then
		self.evasion_chance	= self:GetAuraOwner():FindModifierByName("modifier_boss_7_magnetic_field_thinker_evasion").evasion_chance
	else
		self:Destroy()
	end
end

function modifier_boss_7_magnetic_field_evasion:DeclareFunctions()
	return {MODIFIER_PROPERTY_EVASION_CONSTANT}
end

function modifier_boss_7_magnetic_field_evasion:GetModifierEvasion_Constant(keys)
	if keys.attacker and self:GetAuraOwner() and self:GetAuraOwner():HasModifier("modifier_boss_7_magnetic_field_thinker_evasion") and self:GetAuraOwner():FindModifierByName("modifier_boss_7_magnetic_field_thinker_evasion").radius and (keys.attacker:GetAbsOrigin() - self:GetAuraOwner():GetAbsOrigin()):Length2D() > self:GetAuraOwner():FindModifierByName("modifier_boss_7_magnetic_field_thinker_evasion").radius then
		return self.evasion_chance
	end
end