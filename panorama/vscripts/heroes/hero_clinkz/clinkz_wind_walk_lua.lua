LinkLuaModifier("modifier_clinkz_skeletons", "heroes/hero_clinkz/modifier_clinkz_skeletons", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_clinkz_wind_walk_lua", "heroes/hero_clinkz/clinkz_wind_walk_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_clinkz_wind_walk_fade_lua", "heroes/hero_clinkz/clinkz_wind_walk_lua", LUA_MODIFIER_MOTION_NONE )


clinkz_wind_walk_lua = class({})

function clinkz_wind_walk_lua:GetCooldown(nLevel)
	local caster = self:GetCaster()
	local cooldown = self.BaseClass.GetCooldown( self, nLevel )
	if caster and caster:HasTalent("special_bonus_unique_clinkz_10") then
		cooldown = cooldown - caster:FindTalentValue("special_bonus_unique_clinkz_10")
	end
	return cooldown
end

function clinkz_wind_walk_lua:OnSpellStart()

	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")

	if caster and not caster:IsNull() then
		caster:EmitSound("Hero_Clinkz.WindWalk")
		caster:AddNewModifier(caster, self, "modifier_clinkz_wind_walk_lua", {duration = duration})
	end

end

modifier_clinkz_wind_walk_lua = class({})

function modifier_clinkz_wind_walk_lua:IsHidden() return false end
function modifier_clinkz_wind_walk_lua:IsDebuff() return false end
function modifier_clinkz_wind_walk_lua:IsPurgable() return false end

function modifier_clinkz_wind_walk_lua:OnCreated()
	self.move_speed_bonus_pct = self:GetAbility():GetSpecialValueFor("move_speed_bonus_pct")
	
	if not IsServer() then return end
	local caster = self:GetCaster()
	local fade_time = self:GetAbility():GetSpecialValueFor("fade_time")

	if caster and not caster:IsNull() then
		caster:AddNewModifier(caster, self, "modifier_clinkz_wind_walk_fade_lua", {duration = fade_time})
	end
end

function modifier_clinkz_wind_walk_lua:OnRefresh()
	self:OnCreated()
	if not IsServer() then return end
	self:SpawnSkeletons()
end

function modifier_clinkz_wind_walk_lua:OnDestroy()
	if not IsServer() then return end
	self:SpawnSkeletons()
end

function modifier_clinkz_wind_walk_lua:SpawnSkeletons()
	local caster = self:GetCaster()
	if not caster or caster:IsNull() or not caster:HasShard() then return end
	
	local skeleton_count = self:GetAbility():GetSpecialValueFor("shard_skeletons")
	local skeleton_duration = self:GetAbility():GetSpecialValueFor("shard_skeleton_duration")
	local unit_name = "npc_dota_clinkz_skeleton_archer"

	local fv = caster:GetForwardVector()
	local angle = VectorToAngles(fv)
	local origin = caster:GetAbsOrigin()
	local offset = Vector(250, 0, 0)		-- distance from caster to skeletons
	local angle_offset = angle.y - 90		-- normal of given angle

	for i=1, skeleton_count do
		-- Y angle is yaw, don't ask me why
		local vector_rotate = RotatePosition(Vector(0, 0, 0), QAngle(0, angle_offset, 0), offset)	-- rotational offset vector
		local position = origin + vector_rotate		-- final positional vector of each skeleton

		local skeleton = CreateUnitByName(unit_name, position, true, caster, caster, caster:GetTeamNumber())
		if skeleton ~= nil then
			skeleton:AddNewModifier(caster, self, "modifier_clinkz_skeletons", {duration = skeleton_duration})
			skeleton:SetControllableByPlayer(caster:GetPlayerID(), false)
			skeleton:SetForwardVector(fv)
		end

		angle_offset = angle_offset + 180	-- rotate by X degrees for each skeleton
	end
end

function modifier_clinkz_wind_walk_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
	}
end

function modifier_clinkz_wind_walk_lua:GetModifierProcAttack_Feedback(keys)
	if not IsServer() then return end
	local parent = self:GetParent()
	if (not keys.target) or (not keys.attacker) or (keys.target:IsNull() or keys.attacker:IsNull()) then return end
	parent:RemoveModifierByName("modifier_clinkz_wind_walk_lua")
	parent:RemoveModifierByName("modifier_clinkz_wind_walk_fade_lua")
end

function modifier_clinkz_wind_walk_lua:OnAbilityExecuted(keys)
	if not IsServer() then return end
	local parent = self:GetParent()
	if parent ~= keys.unit then return end

	local ability = keys.ability
	-- Only original clinkz abilities should not break invis and remove the modifiers
	local exceptions = {
		["clinkz_strafe"] = true,
		["clinkz_wind_walk_lua"] = true,
		["clinkz_death_pact_lua"] = true,
		["clinkz_burning_army"] = true,
	}

	if exceptions[ability:GetName()] then return end

	parent:RemoveModifierByName("modifier_clinkz_wind_walk_lua")
	parent:RemoveModifierByName("modifier_clinkz_wind_walk_fade_lua")
end

function modifier_clinkz_wind_walk_lua:GetModifierMoveSpeedBonus_Percentage(params)
	return self.move_speed_bonus_pct
end

function modifier_clinkz_wind_walk_lua:CheckState()
	local states = {
		[MODIFIER_STATE_INVISIBLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return states
end

function modifier_clinkz_wind_walk_lua:GetModifierInvisibilityLevel()
	return 1
end



modifier_clinkz_wind_walk_fade_lua = class({})

function modifier_clinkz_wind_walk_fade_lua:IsHidden() return true end
function modifier_clinkz_wind_walk_fade_lua:IsDebuff() return false end
function modifier_clinkz_wind_walk_fade_lua:IsPurgable() return false end

function modifier_clinkz_wind_walk_fade_lua:GetEffectName()
	return "particles/generic_hero_status/status_invisibility_start.vpcf"
end

function modifier_clinkz_wind_walk_fade_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_clinkz_wind_walk_fade_lua:OnCreated()
	local caster = self:GetCaster()
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_clinkz/clinkz_windwalk.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:ReleaseParticleIndex(particle);
end