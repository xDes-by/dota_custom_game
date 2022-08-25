ability_npc_boss_location8_spell3 = class({})

LinkLuaModifier( "modifier_ability_npc_boss_location8_spell3", "abilities/bosses/location8/ability_npc_boss_location8_spell3", LUA_MODIFIER_MOTION_NONE )

function ability_npc_boss_location8_spell3:OnSpellStart()

	EmitSoundOn( "Hero_Snapfire.Shotgun.Fire", self:GetCaster() )
	
    local projectile_direction = self:GetCaster():GetForwardVector()
    projectile_direction.z = 0
    self.damage = self:GetSpecialValueFor("damage")
    self.info = {
		Source = self:GetCaster(),
		Ability = self,
		vSpawnOrigin = self:GetCaster():GetAbsOrigin(),
		
	    bDeleteOnHit = false,
	    
	    iUnitTargetTeam = self:GetAbilityTargetTeam(),
	    iUnitTargetFlags = self:GetAbilityTargetFlags(),
	    iUnitTargetType = self:GetAbilityTargetType(),
	    
	    EffectName = "particles/units/heroes/hero_snapfire/hero_snapfire_shotgun.vpcf",
	    fDistance = self:GetSpecialValueFor("distance"),
	    fStartRadius = 225,
	    fEndRadius =400,
		vVelocity = projectile_direction * 3000,
	
		bProvidesVision = false,
	}
   
   	for i = 1, 6 do
		local angle = 0
		local angle = 60 * i
		
		ProjectileManager:CreateLinearProjectile(self.info)
		self.right = self.info
		self.right.vVelocity = RotatePosition( Vector(0,0,0), QAngle( 0, angle, 0 ), self:GetCaster():GetForwardVector() * 3000 )
		ProjectileManager:CreateLinearProjectile(self.right)
	end
   
end

function ability_npc_boss_location8_spell3:OnProjectileHit(hTarget, vLocation)
    if hTarget then
        if (self:GetCaster():GetAbsOrigin() - hTarget:GetAbsOrigin()):Length2D() < 300 then
            hTarget:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = 0.3})
        end
        ApplyDamage({victim = hTarget,
        damage = hTarget:GetMaxHealth() * self.damage/100,
        damage_type = DAMAGE_TYPE_MAGICAL,
        damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
        attacker = self:GetCaster(),
        ability = self})
    end
end
