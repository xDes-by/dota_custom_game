ability_npc_boss_plague_squirrel_shoter = class({})

function ability_npc_boss_plague_squirrel_shoter:OnSpellStart()
    local dir = (self:GetCursorPosition() - self:GetCaster():GetOrigin()):Normalized()
    self.info = {
		Source = self:GetCaster(),
		Ability = self,
		vSpawnOrigin = self:GetCaster():GetAbsOrigin(),
		
	    bDeleteOnHit = false,
	    
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,

	    EffectName = "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_projectile.vpcf",
	    fDistance = 1000,
	    fStartRadius = 125,
	    fEndRadius = 125,
		vVelocity = dir * 1300,
	
		bHasFrontalCone = false,
		bReplaceExisting = false,
		
		bProvidesVision = true,
		iVisionRadius = 200,
		iVisionTeamNumber = self:GetCaster():GetTeamNumber()
	}
    ProjectileManager:CreateLinearProjectile( self.info )
	EmitSoundOn( "Hero_Hoodwink.Sharpshooter.Projectile", self:GetCaster() )
end

function ability_npc_boss_plague_squirrel_shoter:OnProjectileHit_ExtraData(hTarget, vLocation, table)
    if hTarget then
        ApplyDamage({victim = hTarget,
        damage = hTarget:GetMaxHealth() * self:GetSpecialValueFor("persent") /100,
        damage_type = DAMAGE_TYPE_MAGICAL,
        damage_flags = DOTA_DAMAGE_FLAG_NONE,
        attacker = self:GetCaster(),
        ability = self})
        StopSoundOn( "Hero_Hoodwink.Sharpshooter.Projectile", sound )
    end
    UTIL_Remove(self:GetCaster())
    return true
end