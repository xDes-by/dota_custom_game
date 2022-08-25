npc_dota_hero_drow_ranger_str11 = class({})

LinkLuaModifier( "modifier_npc_dota_hero_drow_ranger_str11", "heroes/hero_drow_ranger/other/other", LUA_MODIFIER_MOTION_NONE )

function npc_dota_hero_drow_ranger_str11:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_drow_ranger_str11"
end
----------------------------------------------------------------------------------------------------------------

modifier_npc_dota_hero_drow_ranger_str11 = class({})

function modifier_npc_dota_hero_drow_ranger_str11:IsHidden()
	return false
end

function modifier_npc_dota_hero_drow_ranger_str11:OnCreated( kv )
end

function modifier_npc_dota_hero_drow_ranger_str11:OnRefresh( kv )
end

function modifier_npc_dota_hero_drow_ranger_str11:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end


function modifier_npc_dota_hero_drow_ranger_str11:GetModifierProcAttack_Feedback( params )
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

function modifier_npc_dota_hero_drow_ranger_str11:OnTakeDamage( params )
	if IsServer() then

		local pass = false
		if self.attack_record and params.record == self.attack_record then
			pass = true
			self.attack_record = nil
		end

		if pass then
			local heal = params.damage * 0.2
			self:GetParent():Heal( heal, self:GetAbility() )
			self:PlayEffects( self:GetParent() )
		end
	end
end

function modifier_npc_dota_hero_drow_ranger_str11:PlayEffects( target )
	local particle_cast = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end