npc_byorrocktar_spell2 = class({})

function npc_byorrocktar_spell2:GetCastRange(vLocation, hTarget)
    return 400
end

function npc_byorrocktar_spell2:OnSpellStart()
    local pos = self:GetCursorPosition()
    local rocket_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_rattletrap/rattletrap_rocket_flare.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(rocket_particle, 0, self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_rocket")))
    ParticleManager:SetParticleControl(rocket_particle, 1, pos)
    ParticleManager:SetParticleControl(rocket_particle, 2, Vector(400, 0, 0))
    EmitSoundOn("Hero_Rattletrap.Rocket_Flare.Fire", self:GetCaster())
    Timers:CreateTimer(1,function()
        ParticleManager:DestroyParticle(rocket_particle, false)
        ParticleManager:ReleaseParticleIndex(rocket_particle)
	    local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0,false)
        for _,unit in pairs(enemies) do
            ApplyDamage({victim = unit,
            damage = self:GetSpecialValueFor("damage") + unit:GetMaxHealth() * 0.05,
            damage_type = DAMAGE_TYPE_MAGICAL,
            damage_flags = DOTA_DAMAGE_FLAG_NONE,
            attacker = self:GetCaster(),
            ability = self})
        end
        EmitSoundOn("Hero_Rattletrap.Rocket_Flare.Explode", self:GetCaster())
    end)
end