LinkLuaModifier("modifier_boss_7_flux", "abilities/bosses/line/boss_7/boss_7_flux", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_boss_walk", "abilities/bosses/line/boss_7/boss_7_flux", LUA_MODIFIER_MOTION_NONE)

boss_7_flux = class({})

function boss_7_flux:OnSpellStart()
if not IsServer() then return end
	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	if #enemies > 0 then
		for _, enemy in pairs( enemies ) do
			if not enemy:TriggerSpellAbsorb(self) then
				self:GetCaster():EmitSound("Hero_ArcWarden.Flux.Cast")
				enemy:EmitSound("Hero_ArcWarden.Flux.Target")
				
				local cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_flux_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
				ParticleManager:SetParticleControlEnt(cast_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(cast_particle, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(cast_particle, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetAbsOrigin(), true)
			
				enemy:AddNewModifier(self:GetCaster(), self, "modifier_boss_7_flux", {duration = self:GetSpecialValueFor("duration")})
			end
		end	
	end	
end


function boss_7_flux:GetIntrinsicModifierName()
	return "modifier_boss_walk"
end

--------------------------------------------------------------------------------------

modifier_boss_walk = class({})

function modifier_boss_walk:IsHidden()
	return true
end

function modifier_boss_walk:IsPurgable()
	return false
end

function modifier_boss_walk:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}
	return funcs
end

function modifier_boss_walk:GetActivityTranslationModifiers( params )
	return "run"
end

-----------------------------------

modifier_boss_7_flux = class({})

function modifier_boss_7_flux:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_boss_7_flux:IgnoreTenacity()
	return true	
end

function modifier_boss_7_flux:OnCreated()
	if not self:GetAbility() then self:Destroy() return end
	
	self.damage_per_second		= self:GetAbility():GetSpecialValueFor("damage_per_second")
	self.think_interval			= self:GetAbility():GetSpecialValueFor("think_interval")
	self.move_speed_slow_pct	= self:GetAbility():GetSpecialValueFor("move_speed_slow_pct")
	
	if not IsServer() then return end
	
	self.damage_per_interval	= self.damage_per_second * self.think_interval
	self.damage_type			= self:GetAbility():GetAbilityDamageType()
	
	self.flux_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_flux_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(self.flux_particle, 2, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true)
	self:AddParticle(self.flux_particle, false, false, -1, false, false)
	
	self:OnIntervalThink()
	self:StartIntervalThink(self.think_interval)
end

function modifier_boss_7_flux:OnIntervalThink()
	ParticleManager:SetParticleControl(self.flux_particle, 4, Vector(1, 0, 0))	
	self:SetStackCount(self.move_speed_slow_pct * (1 - self:GetParent():GetStatusResistance()) * (-1))
		
	ApplyDamage({
		victim 			= self:GetParent(),
		damage 			= self.damage_per_interval,
		damage_type		= self.damage_type,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self:GetCaster(),
		ability 		= self:GetAbility()
	})
end

function modifier_boss_7_flux:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end

function modifier_boss_7_flux:GetModifierMoveSpeedBonus_Percentage()
	return self:GetStackCount()
end