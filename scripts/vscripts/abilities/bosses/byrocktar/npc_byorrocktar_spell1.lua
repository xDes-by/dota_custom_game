npc_byorrocktar_spell1 = class({})

LinkLuaModifier( "modifier_npc_byorrocktar_spell1","abilities/bosses/byrocktar/npc_byorrocktar_spell1", LUA_MODIFIER_MOTION_NONE )

function npc_byorrocktar_spell1:GetIntrinsicModifierName()
    return "modifier_npc_byorrocktar_spell1"
end

function npc_byorrocktar_spell1:OnOwnerDied()
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0,false)
    for _,unit in pairs(enemies) do
        unit:Kill(self, self:GetCaster())
    end
    local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_suicide.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
    ParticleManager:SetParticleControl(pfx, 1, Vector(2000 / 4, 0, 0))
    ParticleManager:SetParticleControl(pfx, 2, Vector(2000,1,1))
    ParticleManager:ReleaseParticleIndex(pfx)
    self:GetCaster():EmitSound("Hero_Techies.BlastOff.Cast")
end

------------------------------------------------

modifier_npc_byorrocktar_spell1 = class({})

function modifier_npc_byorrocktar_spell1:IsHidden()
    return true
end

function modifier_npc_byorrocktar_spell1:IsPurgable()
    return false
end

function modifier_npc_byorrocktar_spell1:RemoveOnDeath()
    return false
end

function modifier_npc_byorrocktar_spell1:DestroyOnExpire()
    return false
end

function modifier_npc_byorrocktar_spell1:CheckState()
	local state = {
		[MODIFIER_STATE_FLYING] = true,
	}
	return state
end

function modifier_npc_byorrocktar_spell1:OnCreated()
    if IsClient() then
        return
    end
	self:GetParent():SetRenderColor( 127, 127, 127 )
	
    self.radius = self:GetAbility():GetSpecialValueFor("radius")
    self.speed = self:GetAbility():GetSpecialValueFor("proj_speed")
    self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("interval") or self:GetCaster():GetBaseAttackTime())
end

function modifier_npc_byorrocktar_spell1:OnIntervalThink()
	local allies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0,false)
	if #allies > 0 then
		if allies[1] then
			ProjectileManager:CreateTrackingProjectile({
				Target 				= allies[1],
				Source 				= self:GetCaster(),
				Ability 			= self:GetAbility(),
				EffectName 			= "particles/units/heroes/hero_tinker/tinker_missile.vpcf",
				bDodgeable 			= false,
				bProvidesVision 	= false,
				iMoveSpeed 			= self.speed,
				iSourceAttachment	= self:GetCaster():ScriptLookupAttachment("attach_attack3"),
				--ExtraData			= {}
			})
		end
		if allies[2] then
			ProjectileManager:CreateTrackingProjectile({
				Target 				= allies[2],
				Source 				= self:GetCaster(),
				Ability 			= self:GetAbility(),
				EffectName 			= "particles/units/heroes/hero_tinker/tinker_missile.vpcf",
				bDodgeable 			= false,
				bProvidesVision 	= false,
				iMoveSpeed 			= self.speed,
				iSourceAttachment	= self:GetCaster():ScriptLookupAttachment("attach_attack3"),
				--ExtraData			= {}
			})
		end
		if allies[1] then
			EmitSoundOn("Hero_Tinker.Heat-Seeking_Missile", self:GetCaster())
		else
			EmitSoundOn("Hero_Tinker.Heat-Seeking_Missile_Dud", self:GetCaster())
		end
	end
end

function npc_byorrocktar_spell1:OnProjectileHit_ExtraData(hTarget, vLocation, table)
    ApplyDamage({victim = hTarget,
    damage = self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster()) * 3,
    damage_type = DAMAGE_TYPE_PHYSICAL,
    damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
    attacker = self:GetCaster(),
    ability = self})
end