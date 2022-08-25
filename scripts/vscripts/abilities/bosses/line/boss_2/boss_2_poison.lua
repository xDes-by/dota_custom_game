boss_2_poison = class({})

function boss_2_poison:OnSpellStart()
	for i=1, RandomInt(4,10) do	
		local effect_name = "particles/units/heroes/hero_venomancer/venomancer_venomous_gale.vpcf" 
		local info = {
			EffectName = effect_name,
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetOrigin(), 
			fStartRadius = 100,
			fEndRadius = 100,
			vVelocity = RandomVector(1) * 300,
			fDistance = 1500,
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO,
		}

		ProjectileManager:CreateLinearProjectile( info )
	end
	
	Timers:CreateTimer(2, function()
	EmitSoundOn( "Hero_Venomancer.VenomousGale", self:GetCaster() )
		for i=1, RandomInt(4,10) do	
			local effect_name = "particles/units/heroes/hero_venomancer/venomancer_venomous_gale.vpcf" 
			local info = {
				EffectName = effect_name,
				Ability = self,
				vSpawnOrigin = self:GetCaster():GetOrigin(), 
				fStartRadius = 100,
				fEndRadius = 100,
				vVelocity = RandomVector(1) * 300,
				fDistance = 1500,
				Source = self:GetCaster(),
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO,
			}

			ProjectileManager:CreateLinearProjectile( info )
		end
	end)
	EmitSoundOn( "Hero_Venomancer.VenomousGale", self:GetCaster() )
end


function boss_2_poison:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = hTarget:GetHealthPercent() * 0.5,
			damage_type = DAMAGE_TYPE_PURE,
			ability = self
		}
		ApplyDamage( damage )
	end
	return false
end
