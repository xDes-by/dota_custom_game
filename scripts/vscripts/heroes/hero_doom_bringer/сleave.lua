npc_dota_hero_doom_bringer_agi9 = class({})
LinkLuaModifier( "modifier_npc_dota_hero_doom_bringer_agi9", "heroes/hero_doom_bringer/сleave", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function npc_dota_hero_doom_bringer_agi9:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_doom_bringer_agi9"
end

--------------------------------------------------------------------------------

modifier_npc_dota_hero_doom_bringer_agi9 = class({})

function modifier_npc_dota_hero_doom_bringer_agi9:IsHidden()
end

function modifier_npc_dota_hero_doom_bringer_agi9:IsDebuff( kv )
	return false
end

function modifier_npc_dota_hero_doom_bringer_agi9:IsPurgable( kv )
	return false
end


function modifier_npc_dota_hero_doom_bringer_agi9:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_npc_dota_hero_doom_bringer_agi9:OnAttackLanded( params )
	if IsServer() then
		if params.attacker == self:GetParent() and ( not self:GetParent():IsIllusion() ) then
			local target = params.target
			if target ~= nil and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
			
				local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_sven_int7")
				if abil ~= nil then 
				params.target:AddNewModifier(self:GetCaster(), ability, "modifier_magic_debuff", {duration = 2})
				end
				
				DoCleaveAttack( self:GetParent(), target, self:GetAbility(), params.damage, 440, 150, 360, "particles/units/heroes/hero_sven/sven_spell_great_cleave.vpcf" )
			end
		end
	end
	return 0
end