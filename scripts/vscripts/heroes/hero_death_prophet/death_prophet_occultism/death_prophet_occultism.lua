death_prophet_occultism = class({})

function death_prophet_occultism:GetIntrinsicModifierName()
	return "modifier_death_prophet_occultism"
end

function death_prophet_occultism:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function death_prophet_occultism:OnAbilityPhaseStart()
	if IsServer() then
		self.nPreviewFX = ParticleManager:CreateParticle( "particles/dark_moon/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( 60, 60, 60 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 255, 0, 0 ) )
	end

	return true
end

--------------------------------------------------------------------------------

function death_prophet_occultism:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
	end 
end

function death_prophet_occultism:OnSpellStart()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )

		if self:GetCaster() == nil or self:GetCaster():IsNull() then
			return
		end
		local hTombstone = CreateUnitByName( "npc_dota_undead_tusk_tombstone", self:GetCursorPosition(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
		local rotatedVector = RotatePosition(Vector(0, 0, 0), QAngle(0, -90, 0), hTombstone:GetForwardVector() )  -- Поворачиваем вектор направления
		hTombstone:SetForwardVector(rotatedVector)  
		if hTombstone ~= nil then

			local flDuration = self:GetSpecialValueFor( "duration" )
			hTombstone:AddNewModifier( self:GetCaster(), self, "modifier_undead_tusk_mage_tombstone", { duration = flDuration } )
			hTombstone:AddNewModifier( self:GetCaster(), self, "modifier_kill", { duration = flDuration } )
			hTombstone:AddNewModifier( self:GetCaster(), nil, "modifier_provides_fow_position", { duration = -1 } )

			local nTombstoneFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_undying/undying_tombstone.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControl( nTombstoneFX, 0, self:GetCursorPosition() )	
			ParticleManager:SetParticleControlEnt( nTombstoneFX, 1, self:GetCaster(), flDuration, "attach_attack1", self:GetCaster():GetOrigin(), true )
			ParticleManager:SetParticleControl( nTombstoneFX, 2, Vector( flDuration, flDuration, duration ) )
			ParticleManager:ReleaseParticleIndex( nTombstoneFX )

			EmitSoundOn( "UndeadTuskMage.Tombstone", hTombstone )

			local exorcism = self:GetCaster():FindAbilityByName("death_prophet_exorcism_bh")
			if exorcism:GetLevel() > 0 then
				for i = 0, self:GetSpecialValueFor("ghost_count") do
					exorcism:CreateGhost(hTombstone, self:GetSpecialValueFor("radius"), flDuration)
				end
			end
		end
	end
end

modifier_death_prophet_occultism = class({})
LinkLuaModifier("modifier_death_prophet_occultism", "heroes/hero_death_prophet/death_prophet_occultism/death_prophet_occultism", LUA_MODIFIER_MOTION_NONE)

-- function modifier_death_prophet_occultism:OnCreated()
-- 	self.parent = self:GetParent()
-- 	self.ability = self:GetAbility()
-- 	self.ms = self.ability:GetSpecialValueFor("bonus_movespeed")
-- 	self.as = self.ability:GetSpecialValueFor("bonus_attackspeed")
-- 	self:GetCaster().passiveModifier = self
-- 	self:GetParent():HookInModifier( "GetMoveSpeedLimitBonus", self )
-- 	if IsServer() then
-- 		self:SetStackCount( self:GetCaster():GetLevel() )
-- 	end
-- end

-- function modifier_death_prophet_occultism:OnDestroy()
-- 	self:GetParent():HookInModifier( "GetMoveSpeedLimitBonus", self )
-- end

-- function modifier_death_prophet_occultism:DeclareFunctions()
-- 	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
-- end

-- function modifier_death_prophet_occultism:GetModifierAttackSpeedBonus_Constant()
-- 	return self.as * self:GetStackCount()
-- end

-- function modifier_death_prophet_occultism:GetMoveSpeedLimitBonus()
-- 	return self.ms * self:GetStackCount()
-- end

-- function modifier_death_prophet_occultism:GetModifierMoveSpeedBonus_Constant()
-- 	return self.ms * self:GetStackCount()
-- end

-- function modifier_death_prophet_occultism:IsHidden()
-- 	return true
-- end