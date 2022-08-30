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
    local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
    if #enemies > 0 then
        location = enemies[1]:GetAbsOrigin()
    end
    self:GetCaster():RemoveNoDraw()
	FindClearSpaceForUnit(self:GetCaster(), location + RandomVector(400), false)
		CreateCustomIllusion( self:GetCaster(), location + RandomVector(400), 10, 100, 100 )
		CreateCustomIllusion( self:GetCaster(), location + RandomVector(400), 10, 100, 100 )
	EmitSoundOn("DOTA_Item.Manta.End", self:GetCaster())
end

---------------------------------------------------------------------------

modifier_ability_npc_boss_plague_squirrel_spell5_illusion = class({})

function modifier_ability_npc_boss_plague_squirrel_spell5_illusion:IsHidden()
    return true
end

function modifier_ability_npc_boss_plague_squirrel_spell5_illusion:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end

function modifier_ability_npc_boss_plague_squirrel_spell5_illusion:OnAttackLanded(data)
    if IsClient() then
        return
    end
    if data.target == self:GetParent() then
        self:GetCaster():FindAbilityByName("ability_npc_boss_plague_squirrel_spell1"):CreateTree_OtherAbilities(data.attacker:GetOrigin())
        UTIL_Remove(self:GetParent())
    end
end



function CreateCustomIllusion( caster, location, duration, outgoing_damage, incoming_damage )
	local illusions = {}
	local modifyIllusion = function ( illusion )
		illusion:SetForwardVector( caster:GetForwardVector() )
		illusion:MakeIllusion()

		illusion:AddNewModifier(
			caster,
			self,
			"modifier_illusion",
			{
				duration = duration,
				outgoing_damage = outgoing_damage,
				incoming_damage = incoming_damage,
			}
		)
		illusion:AddNewModifier(
			caster,
			self,
			"modifier_ability_npc_boss_plague_squirrel_spell5_illusion",
			{
				duration = duration,
				outgoing_damage = outgoing_damage,
				incoming_damage = incoming_damage,
			}
		)
		table.insert( illusions, illusion )
	end

	-- Create unit
	local illusion = CreateUnitByNameAsync(
		caster:GetUnitName(), -- szUnitName
		location, -- vLocation,
		true, -- bFindClearSpace,
		nil, -- hNPCOwner,
		nil, -- hUnitOwner,
		caster:GetTeamNumber(), -- iTeamNumber
		modifyIllusion
	)
	
	illusion:AddNewModifier(illusion, nil, "modifier_kill", {duration = 9})

	return illusions
end