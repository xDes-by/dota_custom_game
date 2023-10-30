ability_npc_boss_plague_squirrel_spell9 = class({})

function ability_npc_boss_plague_squirrel_spell9:OnSpellStart()
    local pos = self:GetCaster():GetAbsOrigin()
    local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), pos, nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    
    for _,unit in pairs(units) do
        local unit_pos = unit:GetAbsOrigin()
        local direction = unit_pos - self:GetCaster():GetAbsOrigin()
        direction.z = 0
        direction = direction:Normalized()
        local point = unit_pos  + direction * 300
        local arc = unit:AddNewModifier(self:GetCaster(),self,"modifier_generic_arc_lua",
		    {target_x = point.x,target_y = point.y,distance = 300,duration = 0.8,height = 250,fix_end = true,activity = ACT_DOTA_FLAIL})
        arc:SetEndCallback(function()
            local find_trees = GridNav:GetAllTreesAroundPoint(unit:GetAbsOrigin(), 300, true)
            if #find_trees > 0 then
                GridNav:DestroyTreesAroundPoint(unit:GetAbsOrigin(), 300, true)
                unit:AddNewModifier(unit,self, "modifier_stunned", {duration = 3})
            end
        end)
        local p = ParticleManager:CreateParticle("particles/neutral_fx/wildkin_ripper_hurricane_cast.vpcf", PATTACH_POINT_FOLLOW, unit)
        ParticleManager:ReleaseParticleIndex(p)
        EmitSoundOn("n_creep_Wildkin.SummonTornado", unit)
    end
end