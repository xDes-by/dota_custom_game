npc_byorrocktar_spell4  = class({})

function npc_byorrocktar_spell4:OnSpellStart()
    self.position = self:GetCursorPosition()
    self.radius = self:GetSpecialValueFor("radius")
    local delay = self:GetSpecialValueFor("delay")
    local damage = self:GetSpecialValueFor("damage")
    local calldown_first_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_calldown_first.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(calldown_first_particle, 0, self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_rocket1")))
	ParticleManager:SetParticleControl(calldown_first_particle, 1, self.position)
	ParticleManager:SetParticleControl(calldown_first_particle, 5, Vector(self.radius, self.radius, self.radius))
	ParticleManager:ReleaseParticleIndex(calldown_first_particle)
	EmitSoundOn("Hero_Gyrocopter.CallDown.Fire", self:GetCaster())
	local calldown_second_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_calldown_second.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(calldown_second_particle, 0, self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_rocket2")))
	ParticleManager:SetParticleControl(calldown_second_particle, 1, self.position)
	ParticleManager:SetParticleControl(calldown_second_particle, 5, Vector(self.radius, self.radius, self.radius))
	ParticleManager:ReleaseParticleIndex(calldown_second_particle)

    Timers:CreateTimer(delay,function()
	    local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.position, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0,false)
        for _,unit in pairs(enemies) do
            ApplyDamage({victim = unit,
            damage = damage + unit:GetMaxHealth() * 0.1,
            damage_type = DAMAGE_TYPE_MAGICAL,
            damage_flags = DOTA_DAMAGE_FLAG_NONE,
            attacker = self:GetCaster(),
            ability = self})
        end
	    EmitSoundOn("Hero_Gyrocopter.CallDown.Damage", self:GetCaster())
    end)
    Timers:CreateTimer(delay * 2,function()
	    local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.position, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0,false)
        for _,unit in pairs(enemies) do
            ApplyDamage({victim = unit,
            damage = damage / 2 + unit:GetMaxHealth() * 0.05,
            damage_type = DAMAGE_TYPE_MAGICAL,
            damage_flags = DOTA_DAMAGE_FLAG_NONE,
            attacker = self:GetCaster(),
            ability = self})    
        end
	    EmitSoundOn("Hero_Gyrocopter.CallDown.Damage", self:GetCaster())
    end)
end