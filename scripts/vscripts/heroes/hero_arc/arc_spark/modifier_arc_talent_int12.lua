modifier_arc_talent_int12 = {}

function modifier_arc_talent_int12:IsHidden()
	return true
end

function modifier_arc_talent_int12:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
	}
end

function modifier_arc_talent_int12:GetModifierProcAttack_Feedback(keys)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_arc_warden_int_last") ~= nil then
		if keys.attacker == self:GetParent() and not keys.target:IsBuilding() and RandomInt(1, 100) <= 10 then
			local enemy_projectile =
				{
					Target = keys.target,
					Source = keys.attacker,
					Ability = self:GetAbility(),
					EffectName = "particles/units/heroes/hero_arc_warden/arc_warden_wraith_prj.vpcf",
					bDodgeable = false,
					bProvidesVision = false,
					iMoveSpeed = 700,
					flExpireTime = GameRules:GetGameTime() + 60,
					iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
				}
				

			ProjectileManager:CreateTrackingProjectile(enemy_projectile)
		end
	end
end