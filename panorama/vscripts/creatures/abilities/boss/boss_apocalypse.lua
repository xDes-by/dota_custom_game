boss_apocalypse = class({})

function boss_apocalypse:OnAbilityPhaseStart()
	if IsServer() then
		self.target_direction = (self:GetCursorTarget():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()
	end
	return true
end

function boss_apocalypse:OnSpellStart()
	local caster = self:GetCaster()
	local caster_loc = caster:GetAbsOrigin()
	local amount = self:GetSpecialValueFor("amount")
	local speed = self:GetSpecialValueFor("speed")

	if not self.target_direction then
		self.target_direction = (self:GetCursorTarget():GetAbsOrigin() - caster_loc):Normalized()
	end

	caster:EmitSound("BossApocalypse.Cast")

	local apocalypse_projectile = {
		Ability				=	self,
		EffectName			=	"particles/creature/boss_apocalypse.vpcf",
		vSpawnOrigin		=	caster_loc,
		fDistance			=	self:GetSpecialValueFor("distance"),
		fStartRadius		=	self:GetSpecialValueFor("radius"),
		fEndRadius			=	self:GetSpecialValueFor("radius"),
		Source				=	caster,
		bHasFrontalCone		=	false,
		bReplaceExisting	=	false,
		iUnitTargetTeam		=	DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags	=	DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType		=	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime 		=	GameRules:GetGameTime() + 1,
		bDeleteOnHit		=	false,
		vVelocity			=	self.target_direction * speed,
		bProvidesVision		=	false
	}

	for i = 1, amount do
		apocalypse_projectile.vVelocity = speed * RotatePosition(self.target_direction, QAngle(0, i * 360 / (amount - 1), 0), self.target_direction * 100):Normalized(),
		ProjectileManager:CreateLinearProjectile(apocalypse_projectile)
	end
end

function boss_apocalypse:OnProjectileHit(unit, location)
	local caster = self:GetCaster()
	if caster and unit then	
		ApplyDamage({
			victim		= unit, 
			attacker	= caster, 
			damage		= self:GetSpecialValueFor("damage"), 
			damage_type = DAMAGE_TYPE_MAGICAL
		})
	end
end
