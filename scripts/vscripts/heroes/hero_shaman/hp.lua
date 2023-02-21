LinkLuaModifier("modifier_npc_dota_hero_shadow_shaman_str6", "heroes/hero_shaman/hp", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_shadow_shaman_str6 = class({})

function npc_dota_hero_shadow_shaman_str6:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_shadow_shaman_str6"
end

if modifier_npc_dota_hero_shadow_shaman_str6 == nil then 
    modifier_npc_dota_hero_shadow_shaman_str6 = class({})
end

function modifier_npc_dota_hero_shadow_shaman_str6:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS
    }
end

function modifier_npc_dota_hero_shadow_shaman_str6:GetModifierExtraHealthBonus(params)
    return 150 * self:GetCaster():GetLevel()
end

function modifier_npc_dota_hero_shadow_shaman_str6:IsHidden()
	return false
end

function modifier_npc_dota_hero_shadow_shaman_str6:IsPurgable()
    return false
end
 
function modifier_npc_dota_hero_shadow_shaman_str6:RemoveOnDeath()
    return false
end

LinkLuaModifier( "modifier_hex_ampl_spirit", "heroes/hero_shaman/shaman_hex/shaman_hex.lua", LUA_MODIFIER_MOTION_NONE )
-------------------------------------------------------------------------------
function modifier_npc_dota_hero_shadow_shaman_str6:OnAttackLanded( params )
	local caster = self:GetCaster()
	local target = params.target
	local point = self:GetCaster():GetAbsOrigin()
	self.chanse = 5
	if params.attacker~=self:GetParent() then return end
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_shadow_shaman_str9")             
	if abil ~= nil then 
	local ability = self:GetCaster():FindAbilityByName( "shaman_hex" )
		if ability~=nil and ability:GetLevel()>=1 then
		local rand = RandomInt(1,100)
        	if self:GetCaster():FindAbilityByName("npc_dota_hero_shadow_shaman_str_last") ~= nil then
		        self.chanse = 25
	        end
					if rand <= self.chanse then
					local spawn_hex = CreateUnitByName( "npc_shaman_hex", point + RandomVector( RandomFloat( 150, 150 )), true, nil, nil, DOTA_TEAM_GOODGUYS )
					spawn_hex:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
					spawn_hex:SetOwner(caster)
					spawn_hex:AddNewModifier(spawn_hex, nil, "modifier_hex_ampl_spirit",  { }) 	
					caster:EmitSound("Hero_ShadowShaman.Hex.Target")		
			end
		end
	end
end