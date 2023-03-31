modifier_earthshaker_enchant_totem_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_earthshaker_enchant_totem_lua:IsHidden()
	return false
end

function modifier_earthshaker_enchant_totem_lua:IsDebuff()
	return false
end

function modifier_earthshaker_enchant_totem_lua:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_earthshaker_enchant_totem_lua:OnCreated( kv )
	-- references
	self.bonus = self:GetAbility():GetSpecialValueFor( "totem_damage_percentage" ) -- special value
	self.range = self:GetAbility():GetSpecialValueFor( "bonus_attack_range" ) -- special value
	if IsServer() then
		self:PlayEffects1()
	end
end

function modifier_earthshaker_enchant_totem_lua:OnRefresh( kv )
	-- references
	self.bonus = self:GetAbility():GetSpecialValueFor( "totem_damage_percentage" ) -- special value
	self.range = self:GetAbility():GetSpecialValueFor( "bonus_attack_range" ) -- special value
end

function modifier_earthshaker_enchant_totem_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_earthshaker_enchant_totem_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	}

	return funcs
end

function modifier_earthshaker_enchant_totem_lua:GetModifierBaseDamageOutgoing_Percentage()
	return self.bonus
end

function modifier_earthshaker_enchant_totem_lua:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		-- effects
		local sound_cast = "Hero_EarthShaker.Totem.Attack"
		EmitSoundOn( sound_cast, params.target )
		local cleave_distance = 800
		-- DoCleaveAttack( self:GetParent(), params.target, self:GetAbility(), params.damage * 3, 1100, 150, 360,  "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf" )
		
		local direction = params.target:GetOrigin()-self:GetParent():GetOrigin()
		direction.z = 0
		direction = direction:Normalized()
		local range = self:GetParent():GetOrigin() + direction*1100/2
		local enemies = FindUnitsInCone( self:GetParent():GetTeamNumber(), params.target:GetOrigin(), self:GetParent():GetOrigin(), range, 150, 360, nil, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		for _,enemy in pairs(enemies) do
			if enemy ~= params.target then
				ApplyDamage({victim = enemy, attacker = self:GetParent(), damage = params.damage*2, damage_type = DAMAGE_TYPE_PHYSICAL, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
			end
		end
		self:PlayEffects2( direction )
		params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_earthshaker_enchant_totem_debuff1_lua", {duration = 3})
		self:Destroy()
	end
end

-- function modifier_earthshaker_enchant_totem_lua:GetEffectAttachType()
-- 	return PATTACH_OVERHEAD_FOLLOW
-- end

function modifier_earthshaker_enchant_totem_lua:GetEffectName()
	return "particles/act_2/storegga_channel.vpcf"
end

function modifier_earthshaker_enchant_totem_lua:GetModifierAttackRangeBonus()
	return self.range
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_earthshaker_enchant_totem_lua:CheckState()
	local state = {
		[MODIFIER_STATE_CANNOT_MISS] = true,
	}

	return state
end



--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_earthshaker_enchant_totem_lua:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_earthshaker/earthshaker_totem_buff.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, self:GetParent() )

	local attach = "attach_attack1"
	if self:GetCaster():ScriptLookupAttachment( "attach_totem" )~=0 then attach = "attach_totem" end
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		attach,
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)

	-- buff particle
	self:AddParticle(
		effect_cast,
		false,
		false,
		-1,
		false,
		false
	)
end

function modifier_earthshaker_enchant_totem_lua:PlayEffects2(direction )
	local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function FindUnitsInCone( nTeamNumber, vCenterPos, vStartPos, vEndPos, fStartRadius, fEndRadius, hCacheUnit, nTeamFilter, nTypeFilter, nFlagFilter, nOrderFilter, bCanGrowCache )
	local direction = vEndPos-vStartPos
	direction.z = 0

	local distance = direction:Length2D()
	direction = direction:Normalized()

	local big_radius = distance + math.max(fStartRadius, fEndRadius)

	local units = FindUnitsInRadius(
		nTeamNumber,	-- int, your team number
		vCenterPos,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		big_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		nTeamFilter,	-- int, team filter
		nTypeFilter,	-- int, type filter
		nFlagFilter,	-- int, flag filter
		nOrderFilter,	-- int, order filter
		bCanGrowCache	-- bool, can grow cache
	)

	local targets = {}
	for _,unit in pairs(units) do
		local vUnitPos = unit:GetOrigin()-vStartPos
		local fProjection = vUnitPos.x*direction.x + vUnitPos.y*direction.y + vUnitPos.z*direction.z
		fProjection = math.max(math.min(fProjection,distance),0)
		local vProjection = direction*fProjection
		local fUnitRadius = (vUnitPos - vProjection):Length2D()
		local fInterpRadius = (fProjection/distance)*(fEndRadius-fStartRadius) + fStartRadius
		if fUnitRadius<=fInterpRadius then
			table.insert( targets, unit )
		end
	end
	return targets
end