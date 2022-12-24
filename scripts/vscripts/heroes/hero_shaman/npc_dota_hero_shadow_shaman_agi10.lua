LinkLuaModifier("modifier_npc_dota_hero_shadow_shaman_agi10", "heroes/hero_shaman/npc_dota_hero_shadow_shaman_agi10", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shadow_ward", "heroes/hero_shaman/shaman_wards/shaman_wards", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_shadow_shaman_agi10 = class({})

function npc_dota_hero_shadow_shaman_agi10:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_shadow_shaman_agi10"
end

modifier_npc_dota_hero_shadow_shaman_agi10 = class({})
--Classifications template
function modifier_npc_dota_hero_shadow_shaman_agi10:IsHidden()
    return false
end

function modifier_npc_dota_hero_shadow_shaman_agi10:IsPurgable()
    return false
end

function modifier_npc_dota_hero_shadow_shaman_agi10:RemoveOnDeath()
    return false
end

function modifier_npc_dota_hero_shadow_shaman_agi10:DeclareFunctions()
    return {
       MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
    }
end

function modifier_npc_dota_hero_shadow_shaman_agi10:GetModifierProcAttack_Feedback(params)
    local ability = self:GetCaster():FindAbilityByName( "shaman_wards_custom" )
    if ability~=nil and ability:GetLevel()>=1 then
        if RandomInt(1,100) <= 5 then
            target = params.target

            local caster = self:GetCaster()
            local position = target:GetAbsOrigin()
            local sound_cast = "Hero_ShadowShaman.SerpentWard"
            EmitSoundOn( sound_cast, caster )

            shadow_ward = CreateUnitByName("shadow_shaman_ward", position + RandomVector( 150 ), true, caster, nil, caster:GetTeam())
            shadow_ward:SetControllableByPlayer(caster:GetPlayerID(), true)
            shadow_ward:SetOwner(caster)
            shadow_ward:AddAbility("summon_buff"):SetLevel(1)
            shadow_ward:AddNewModifier( shadow_ward, nil, "modifier_shadow_ward", {} )
        end
    end	
end