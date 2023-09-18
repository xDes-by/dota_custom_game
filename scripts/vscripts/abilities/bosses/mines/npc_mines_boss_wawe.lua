npc_mines_boss_wawe = class({})

function npc_mines_boss_wawe:OnSpellStart()
    local dir = self:GetCaster():GetForwardVector()
    local pos = self:GetCaster():GetAbsOrigin()
    local targeted_units = {}
    local rad = 0
    local abi = self
    local caster = self:GetCaster()
    Timers:CreateTimer(0.03,function()
	    local units = FindUnitsInRadius(self:GetCaster():GetTeam(), pos, nil, rad, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
        for _,u in pairs(units) do
            if not targeted_units[u] then
                print(u:GetName())
                targeted_units[u] = true
                u:AddNewModifier(caster, abi, "modifier_silence", {duration = 1})
            end
        end
        rad = rad + 10
        if rad % 150 == 0 then
            local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf", PATTACH_WORLDORIGIN, caster )
            ParticleManager:SetParticleControl( effect_cast, 0, pos )
            ParticleManager:SetParticleControl( effect_cast, 1, Vector( rad, 0, 0 ) )
            ParticleManager:ReleaseParticleIndex( effect_cast )
            EmitSoundOnLocationWithCaster( pos, "Hero_Leshrac.Split_Earth", caster )
        end
        if rad > 600 then
            return
        end
        return 0.03
    end)
end