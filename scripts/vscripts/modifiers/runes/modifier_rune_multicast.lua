modifier_rune_multicast = class({})

--------------------------------------------------------------------------------

function modifier_rune_multicast:IsHidden()
	return true
end

function modifier_rune_multicast:IsPurgable()
	return false
end

function modifier_rune_multicast:RemoveOnDeath()
	return false
end

function modifier_rune_multicast:OnCreated( kv )
end

function modifier_rune_multicast:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}
end

function modifier_rune_multicast:OnAbilityFullyCast( params )	
	if IsServer() then
		if params.unit ~= self:GetParent() then
			return 0
		end
		local ability = params.ability
		if ability == nil then
			return 0
		end

		if not ability:IsItem() and RandomInt(1,100) <= 5 then
			ability:EndCooldown()
			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_ogre_magi/ogre_magi_multicast.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 1, 2, 1 ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
			EmitSoundOn( "Bogduggs.LuckyFemur", self:GetParent() )
		end
	end
	return 0
end