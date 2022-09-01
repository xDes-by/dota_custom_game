ability_npc_boss_plague_squirrel_spell4 = class({})

function ability_npc_boss_plague_squirrel_spell4:OnSpellStart()
    local position = self:GetCaster():GetAbsOrigin()
    for i=1,2 do
        local npc = CreateUnitByName("npc_boss_plague_squirrel_totem", position + RandomVector(500), true, nil, nil, self:GetCaster():GetTeamNumber() )
		npc:AddNewModifier(npc, nil, "modifier_kill", {duration = 7})
        local pfx = ParticleManager:CreateParticle("particles/econ/items/spectre/spectre_arcana/spectre_arcana_haunt_caster_v2.vpcf", PATTACH_POINT, npc)
        ParticleManager:ReleaseParticleIndex(pfx)
        EmitSoundOn("DOTA_Item.DoE.Activate", self:GetCaster())
    end
end