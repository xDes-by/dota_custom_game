shaman_wards_custom = class({})

function shaman_wards_custom:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
end

function shaman_wards_custom:GetManaCost(iLevel)
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_shadow_shaman_int7")             
	if abil ~= nil then 
        return self:GetCaster():GetIntellect() * 1.5
    end
	return self:GetCaster():GetIntellect()*3
end


function shaman_wards_custom:GetAOERadius()
	return 150
end

function shaman_wards_custom:OnSpellStart()
	local caster  =   self:GetCaster()
	local position      =   self:GetCursorPosition()
	local count = self:GetSpecialValueFor("count")
	local sound_cast = "Hero_ShadowShaman.SerpentWard"
	EmitSoundOn( sound_cast, caster )
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_shadow_shaman_int10")             
	if abil ~= nil then 
	count = count + 5
	end

	for i = 1, count do	  

	shadow_ward = CreateUnitByName("shadow_shaman_ward", position + RandomVector( RandomFloat( 10, 100 )), true, caster, nil, caster:GetTeam())
	shadow_ward:SetControllableByPlayer(caster:GetPlayerID(), true)
	shadow_ward:SetOwner(caster)
	shadow_ward:AddAbility("summon_buff"):SetLevel(1)
	shadow_ward:AddNewModifier( shadow_ward, nil, "modifier_shadow_ward", {} )
	
	end
end

function boom(data)
		local caster = data.caster
		data.caster:ForceKill(false)
		UTIL_Remove( data.caster )
end

LinkLuaModifier("modifier_shadow_ward", "heroes/hero_shaman/shaman_wards/shaman_wards", LUA_MODIFIER_MOTION_NONE)

if modifier_shadow_ward == nil then
	modifier_shadow_ward = class({})
end

function modifier_shadow_ward:CheckState()
	local state = {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = false,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
	}
  	return state
end

function modifier_shadow_ward:IsHidden()
    return true
end