---@class silencer_global_silence:CDOTA_Ability_Lua
silencer_global_silence = class({})

function silencer_global_silence:GetAOERadius()
	return self:GetCastRange(Vector(0,0,0), nil)
end

function silencer_global_silence:OnSpellStart()
	local caster = self:GetCaster()
	local origin = caster:GetAbsOrigin()
	local duration = self:GetDuration()

	local targets = FindUnitsInRadius(self:GetTeam(), 
		origin, 
		nil, 
		self:GetCastRange(origin, nil), 
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_ALL,
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_ANY_ORDER,
		false)

	for _, unit in pairs(targets) do
		unit:AddNewModifier(caster, self, "modifier_silencer_global_silence", { 
			duration = unit:ApplyStatusResistance(duration)
		})

		if unit:IsRealHero() then
			EmitSoundOnClient("Hero_Silencer.GlobalSilence.Effect", unit:GetPlayerOwner())
		end

		ParticleManager:CreateParticle("particles/units/heroes/hero_silencer/silencer_global_silence_hero.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
	end

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_silencer/silencer_global_silence.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl( particle, 0, origin)
	EmitSoundOn("Hero_Silencer.GlobalSilence.Cast", caster)
end