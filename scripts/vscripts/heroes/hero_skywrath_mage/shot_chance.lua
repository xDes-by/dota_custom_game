npc_dota_hero_skywrath_mage_agi10 = class({})
LinkLuaModifier( "modifier_npc_dota_hero_skywrath_mage_agi10", "heroes/hero_skywrath_mage/shot_chance", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function npc_dota_hero_skywrath_mage_agi10:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_skywrath_mage_agi10"
end

--------------------------------------------------------------------------------

modifier_npc_dota_hero_skywrath_mage_agi10 = class({})

function modifier_npc_dota_hero_skywrath_mage_agi10:IsHidden()
	return true
end

function modifier_npc_dota_hero_skywrath_mage_agi10:IsDebuff( kv )
	return false
end

function modifier_npc_dota_hero_skywrath_mage_agi10:IsPurgable( kv )
	return false
end


function modifier_npc_dota_hero_skywrath_mage_agi10:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_npc_dota_hero_skywrath_mage_agi10:OnAttack( params )
	if params.attacker==self:GetParent() then
		local abil = self:GetParent():FindAbilityByName("npc_dota_hero_skywrath_mage_agi10")	
			if abil ~= nil then 
				if RandomInt(1,100) < 5 then
					local ability = self:GetParent():FindAbilityByName("skywrath_mage_concussive_shot_lua")	
						if ability ~= nil and ability:IsTrained() and not self:GetParent():IsIllusion() then
					ability:OnSpellStart()
					ability:UseResources(true, false, false, false)
				end
			end
		end
	end
end