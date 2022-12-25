LinkLuaModifier( "modifier_hex_ampl_spirit", "heroes/hero_shaman/shaman_hex/shaman_hex.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_npc_dota_hero_shadow_shaman_str9", "heroes/hero_shaman/npc_dota_hero_shadow_shaman_str9", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_shadow_shaman_str9 = class({})

function npc_dota_hero_shadow_shaman_str9:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_shadow_shaman_str9"
end

modifier_npc_dota_hero_shadow_shaman_str9 = class({})
--Classifications template
function modifier_npc_dota_hero_shadow_shaman_str9:IsHidden()
    return false
end

function modifier_npc_dota_hero_shadow_shaman_str9:IsPurgable()
    return false
end

function modifier_npc_dota_hero_shadow_shaman_str9:RemoveOnDeath()
    return false
end

function modifier_npc_dota_hero_shadow_shaman_str9:DeclareFunctions()
    return {
       MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
    }
end

function modifier_npc_dota_hero_shadow_shaman_str9:GetModifierProcAttack_Feedback(params)
	local caster = self:GetCaster()
	local target = params.target
	local point = params.target:GetAbsOrigin()
	self.chanse = 5
	local ability = self:GetCaster():FindAbilityByName( "shaman_hex" )
    if ability~=nil and ability:GetLevel() > 0 then
        local rand = RandomInt(1,100)
        if self:GetCaster():FindAbilityByName("npc_dota_hero_shadow_shaman_str_last") ~= nil then
            self.chanse = 25
        end
        if rand <= self.chanse then
            local spawn_hex = CreateUnitByName( "npc_shaman_hex", point + RandomVector( 150), true, nil, nil, DOTA_TEAM_GOODGUYS )
            spawn_hex:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
            spawn_hex:SetOwner(caster)
            spawn_hex:AddNewModifier(spawn_hex, nil, "modifier_hex_ampl_spirit",  { }) 	
            caster:EmitSound("Hero_ShadowShaman.Hex.Target")		
        end
    end
end