LinkLuaModifier("modifier_hero_destroyer_third_skill", "abilities/bosses/2023/third_skill/third_skill", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hero_destroyer_third_skill_debuff", "abilities/bosses/2023/third_skill/third_skill", LUA_MODIFIER_MOTION_NONE)

hero_destroyer_third_skill = class({})

function hero_destroyer_third_skill:GetIntrinsicModifierName()
	return "modifier_hero_destroyer_third_skill"
end

-----------------------------------------------------------------------

modifier_hero_destroyer_third_skill = class({})

function modifier_hero_destroyer_third_skill:IsHidden()
	return true
end

function modifier_hero_destroyer_third_skill:IsPurgable()
	return false
end

function modifier_hero_destroyer_third_skill:DestroyOnExpire()
	return false
end

function modifier_hero_destroyer_third_skill:RemoveOnDeath()	
	return false 
end

function modifier_hero_destroyer_third_skill:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
end

function modifier_hero_destroyer_third_skill:GetModifierIncomingDamage_Percentage(params)
	return self.incom
end

function modifier_hero_destroyer_third_skill:OnAttackLanded(keys)
    if not IsServer() then return end
	
	local block = self:GetAbility():GetSpecialValueFor("incom_damage")
	

	if keys.target == self:GetParent() and keys.attacker:HasModifier("modifier_hero_destroyer_third_skill_debuff") then
		self.incom = -1 * block
	else
		self.incom = 0
	end	

	if self:GetParent() == keys.attacker and keys.attacker:GetTeamNumber() ~= keys.target:GetTeamNumber() and not self:GetParent():PassivesDisabled() then
		local damage = keys.original_damage
		local particle_cast = 'particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf'
		
		local direction = keys.target:GetOrigin()-self:GetParent():GetOrigin()
		direction.z = 0
		direction = direction:Normalized()
		local range = self:GetParent():GetOrigin() + direction *400 / 2
						
		local enemies = FindUnitsInCone( self:GetParent():GetTeamNumber(), keys.target:GetOrigin(), self:GetParent():GetOrigin(), range, 150, 360, nil, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
		for _,enemy in pairs(enemies) do
			enemy:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_hero_destroyer_third_skill_debuff", {duration = self:GetAbility():GetSpecialValueFor("duration")})
			if keys.target ~= enemy then
				ApplyDamage({victim = enemy, attacker = self:GetParent(), damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
			end
		end
		self:PlayEffects1(direction )
	end
end

function modifier_hero_destroyer_third_skill:PlayEffects1(direction )
	local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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

--------------------------------------

modifier_hero_destroyer_third_skill_debuff = class({})

function modifier_hero_destroyer_third_skill_debuff:IsHidden() return false end
function modifier_hero_destroyer_third_skill_debuff:IsDebuff() return true end
function modifier_hero_destroyer_third_skill_debuff:IsPurgable() return true end

function modifier_hero_destroyer_third_skill_debuff:OnCreated(kv)
end

function modifier_hero_destroyer_third_skill_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end

function modifier_hero_destroyer_third_skill_debuff:GetModifierAttackSpeedBonus_Constant()
	return -self:GetAbility():GetSpecialValueFor("slow_as")
end

function modifier_hero_destroyer_third_skill_debuff:GetModifierMoveSpeedBonus_Percentage()
	return -self:GetAbility():GetSpecialValueFor("slow_as")
end

