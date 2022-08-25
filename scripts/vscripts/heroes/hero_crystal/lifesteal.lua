npc_dota_hero_crystal_maiden_str10 = class({})

function npc_dota_hero_crystal_maiden_str10:GetIntrinsicModifierName()
	return "modifier_crystal_maiden_lifesteal"
end

LinkLuaModifier( "modifier_crystal_maiden_lifesteal", "heroes/hero_crystal/lifesteal", LUA_MODIFIER_MOTION_NONE )

modifier_crystal_maiden_lifesteal = class({})

function modifier_crystal_maiden_lifesteal:IsHidden()
	return false
end

function modifier_crystal_maiden_lifesteal:OnCreated( kv )
end

function modifier_crystal_maiden_lifesteal:OnRefresh( kv )
end

function modifier_crystal_maiden_lifesteal:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end


function modifier_crystal_maiden_lifesteal:GetModifierProcAttack_Feedback( params )
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

function modifier_crystal_maiden_lifesteal:OnTakeDamage( params )
	if IsServer() then

		local pass = false
		if self.attack_record and params.record == self.attack_record then
			pass = true
			self.attack_record = nil
		end

		if pass then
			local heal = params.damage * 25/100
			self:GetParent():Heal( heal, self:GetAbility() )
			self:PlayEffects( self:GetParent() )
		end
	end
end

function modifier_crystal_maiden_lifesteal:PlayEffects( target )
	local particle_cast = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end