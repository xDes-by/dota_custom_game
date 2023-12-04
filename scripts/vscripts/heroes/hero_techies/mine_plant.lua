LinkLuaModifier("modifier_npc_dota_hero_techies_agi_last", "heroes/hero_techies/mine_plant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_land_mines", "heroes/hero_techies/techies_land_mines/techies_land_mines.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_land_mines_explose_delay", "heroes/hero_techies/techies_land_mines/techies_land_mines.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dummy_thinker", "heroes/hero_techies/techies_land_mines/techies_land_mines.lua", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_techies_agi_last = class({})

function npc_dota_hero_techies_agi_last:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_techies_agi_last"
end

if modifier_npc_dota_hero_techies_agi_last == nil then 
    modifier_npc_dota_hero_techies_agi_last = class({})
end

function modifier_npc_dota_hero_techies_agi_last:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_npc_dota_hero_techies_agi_last:OnAttackLanded( params )
	local caster = self:GetCaster()
	local target = params.target
	if params.attacker~=self:GetParent() then return end
	local chance = 5
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_techies_agi50") then
		chance = 15
	end
	if RandomInt(1,100) <= chance then
		local pos = target:GetAbsOrigin()
		local mine = CreateUnitByName("land_mine_trap", pos, true, caster, caster, caster:GetTeamNumber())
		local abil = caster:FindAbilityByName("techies_land_mines_lua")
		
		mine:EmitSound("Hero_Techies.LandMine.Plant")
		mine:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
		mine:AddNewModifier(caster, abil, "modifier_land_mines", {})
	end
end