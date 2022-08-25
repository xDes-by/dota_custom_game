npc_dota_hero_skywrath_mage_str11 = class({})

function npc_dota_hero_skywrath_mage_str11:GetIntrinsicModifierName()
	return "modifier_skywrath_mage_str11"
end

LinkLuaModifier( "modifier_skywrath_mage_str11", "heroes/hero_skywrath_mage/spell_lifesteal", LUA_MODIFIER_MOTION_NONE )

modifier_skywrath_mage_str11 = class({})

function modifier_skywrath_mage_str11:IsHidden()
	return false
end

function modifier_skywrath_mage_str11:OnCreated( kv )
end

function modifier_skywrath_mage_str11:OnRefresh( kv )
end

function modifier_skywrath_mage_str11:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end


function modifier_skywrath_mage_str11:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		local pass = false
		if params.target:GetTeamNumber()~=self:GetParent():GetTeamNumber() then
			if (not params.target:IsBuilding()) and (not params.target:IsOther()) then
				pass = true
			end
		end

		if pass then
			self.attack_record = params.record
		end
	end
end

function modifier_skywrath_mage_str11:OnTakeDamage( params )
	if params.attacker == self:GetParent() and not params.unit:IsBuilding() and not params.unit:IsOther() then		
		if self:GetParent():FindAllModifiersByName(self:GetName())[1] == self and params.damage_category == 0 and params.inflictor and bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL) ~= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
			self.lifesteal_pfx = ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.attacker)
			ParticleManager:SetParticleControl(self.lifesteal_pfx, 0, params.attacker:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.lifesteal_pfx)
			
			if params.attacker:GetHealth() <= (params.original_damage * (50 / 100)) and params.inflictor and bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then
			params.attacker:ForceKill(true)
			else
			params.attacker:Heal(params.original_damage * (50 / 100), self)
			end
		end
	end
end