boss_4_eidolon = class({})

function boss_4_eidolon:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local sound_cast = "Hero_Enigma.Demonic_Conversion"
	EmitSoundOn( sound_cast, caster )
	for i = 1, 5 do
		local eidolon = CreateUnitByName("boss_4_eidolon", target:GetOrigin(), true, caster, caster, caster:GetTeamNumber())
		eidolon:AddNewModifier(caster, self, "modifier_kill", {duration = 15})
		Rules:difficality_modifier(eidolon)
		setting(caster, eidolon)
	end
	if target:IsRealHero() then
		ApplyDamage({victim = target, attacker = caster, damage = target:GetMaxHealth()*0.5, damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION })
	else
		target:ForceKill(false)
	end
end

function setting(caster, eidolon)
	eidolon:SetBaseDamageMin(caster:GetBaseDamageMin()/10)
	eidolon:SetBaseDamageMax(caster:GetBaseDamageMax()/10)
	eidolon:SetPhysicalArmorBaseValue(caster:GetPhysicalArmorBaseValue()/10)
	eidolon:SetBaseMagicalResistanceValue(caster:GetBaseMagicalResistanceValue()/10)
	eidolon:SetMaxHealth(caster:GetMaxHealth()/10)
	eidolon:SetBaseMaxHealth(caster:GetBaseMaxHealth()/10)
	eidolon:SetHealth(caster:GetHealth()/10)
	eidolon:SetDeathXP(caster:GetDeathXP()/10)
end