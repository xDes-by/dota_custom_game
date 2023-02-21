ability_npc_boss_plague_squirrel_spell5 = class({})

LinkLuaModifier( "modifier_ability_npc_boss_plague_squirrel_spell5", "abilities/bosses/plague_squirrel/ability_npc_boss_plague_squirrel_spell5", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_npc_boss_plague_squirrel_spell5_illusion", "abilities/bosses/plague_squirrel/ability_npc_boss_plague_squirrel_spell5", LUA_MODIFIER_MOTION_NONE )

function ability_npc_boss_plague_squirrel_spell5:OnSpellStart()
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_ability_npc_boss_plague_squirrel_spell5", {duration = 1})
    self:GetCaster():AddNoDraw()
	EmitSoundOn("DOTA_Item.Manta.Activate", self:GetCaster())
end

---------------------------------------------------------------------

modifier_ability_npc_boss_plague_squirrel_spell5 = class({})

function modifier_ability_npc_boss_plague_squirrel_spell5:IsHidden()
    return true
end

function modifier_ability_npc_boss_plague_squirrel_spell5:CheskState()
    return {
        [MODIFIER_STATE_OUT_OF_GAME] = true
    }
end

function modifier_ability_npc_boss_plague_squirrel_spell5:OnDestroy()
if not IsServer() then return end
	local location = self:GetCaster():GetAbsOrigin()
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_FARTHEST, false )
	if #enemies > 0 then
		location = enemies[1]:GetAbsOrigin()
	end
	self:GetCaster():RemoveNoDraw()
	FindClearSpaceForUnit(self:GetCaster(), location + RandomVector(400), false)
	
	local caster = self:GetCaster()
		
	local illusion = CreateUnitByName( "npc_boss_plague_squirrel_copy", location + RandomVector(400), true, nil, nil, caster:GetTeamNumber())
	illusion:AddNewModifier(illusion, nil, "modifier_kill", {duration = 8})
	illusion:AddNewModifier(illusion, nil, "modifier_ability_npc_boss_plague_squirrel_spell5_illusion", {duration = 8})
	illusion:RemoveAbility("ability_npc_boss_plague_squirrel_spell5")
	
	Timers:CreateTimer(0.5, function()
		local illusion = CreateUnitByName( "npc_boss_plague_squirrel_copy", location + RandomVector(400), true, nil, nil, caster:GetTeamNumber())
		illusion:AddNewModifier(illusion, nil, "modifier_kill", {duration = 8})
		illusion:AddNewModifier(illusion, nil, "modifier_ability_npc_boss_plague_squirrel_spell5_illusion", {duration = 8})
		illusion:RemoveAbility("ability_npc_boss_plague_squirrel_spell5")
	end	)
	EmitSoundOn("DOTA_Item.Manta.End", self:GetCaster())
end

---------------------------------------------------------------------------

modifier_ability_npc_boss_plague_squirrel_spell5_illusion = class({})

function modifier_ability_npc_boss_plague_squirrel_spell5_illusion:IsHidden()
    return true
end

