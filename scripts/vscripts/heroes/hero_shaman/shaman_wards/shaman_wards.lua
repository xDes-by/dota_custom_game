shaman_wards_custom = class({})

function shaman_wards_custom:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
end

function shaman_wards_custom:GetManaCost(iLevel)         
	if self:GetCaster():FindAbilityByName("npc_dota_hero_shadow_shaman_int7")    ~= nil then 
        return 50 + math.min(65000, self:GetCaster():GetIntellect() / 200)
    end
	return 100 + math.min(65000, self:GetCaster():GetIntellect()/100)
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
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_shadow_shaman_agi50") then
		self.special_bonus_unique_npc_dota_hero_shadow_shaman_agi50 = true
		self.ass = self:GetCaster():FindItemInInventory("item_assault_lua")
		self.des = self:GetCaster():FindItemInInventory("item_desolator_lua")
	end
	for i = 1, count do	  
		shadow_ward = CreateUnitByName("shadow_shaman_ward", position + RandomVector( RandomFloat( 10, 100 )), true, caster, nil, caster:GetTeam())
		shadow_ward:SetControllableByPlayer(caster:GetPlayerID(), true)
		shadow_ward:SetOwner(caster)
		shadow_ward:AddAbility("summon_buff"):SetLevel(1)
		shadow_ward:AddNewModifier( shadow_ward, nil, "modifier_shadow_ward", {} )
		if self.special_bonus_unique_npc_dota_hero_shadow_shaman_agi50 then
			if self.ass then
				shadow_ward:AddItemByName("item_assault_lua"):SetLevel(self.ass:GetLevel())
			end
			if self.des then
				shadow_ward:AddItemByName("item_desolator_lua"):SetLevel(self.des:GetLevel())
			end
		end
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