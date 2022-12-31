night_stalker_hunter_in_the_night_lua = class({})

LinkLuaModifier("night_stalker_hunter_in_the_night_handler_lua", "heroes/hero_night_stalker/night_stalker_hunter_in_the_night_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("night_stalker_hunter_in_the_night_lua_buff", "heroes/hero_night_stalker/night_stalker_hunter_in_the_night_lua", LUA_MODIFIER_MOTION_NONE)

function night_stalker_hunter_in_the_night_lua:GetBehavior()
	if self:GetCaster():HasShard() then return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET end

	return DOTA_ABILITY_BEHAVIOR_PASSIVE 
end

function night_stalker_hunter_in_the_night_lua:GetCooldown(level)
	if self:GetCaster():HasShard() then
		return self:GetSpecialValueFor("shard_cooldown")
	end
end

function night_stalker_hunter_in_the_night_lua:GetCastRange(loc, target)
	if self:GetCaster():HasShard() then
		return self:GetSpecialValueFor("shard_cast_range")
	end
end

-- Cannot target Ancients
function night_stalker_hunter_in_the_night_lua:CastFilterResultTarget(target)
	if target:HasModifier("modifier_creature_ancient") then return UF_FAIL_ANCIENT end

	return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO, self:GetCaster():GetTeamNumber())
end

-- Refresh buff when upgraded
function night_stalker_hunter_in_the_night_lua:OnUpgrade()
	if IsClient() then return end

	local night_modifier = self:GetCaster():FindModifierByName("night_stalker_hunter_in_the_night_lua_buff")
	if night_modifier then night_modifier:ForceRefresh() end
end

function night_stalker_hunter_in_the_night_lua:OnSpellStart()
	if IsClient() then return end

	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if not caster or caster:IsNull() then return end
	if not target or target:IsNull() then return end

	local heal_health = caster:GetMaxHealth() * self:GetSpecialValueFor("shard_hp_restore_pct") * 0.01
	local heal_mana = caster:GetMaxMana() * self:GetSpecialValueFor("shard_mana_restore_pct") * 0.01

	-- Play ability effects
	target:EmitSound("Hero_Nightstalker.Hunter.Target")

	local hunter_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_night_stalker/nightstalker_shard_hunter.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(hunter_pfx, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(hunter_pfx, 1, caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(hunter_pfx)

	-- Assume that we have the right target given the cast filter
	target:Kill(self, caster)
	caster:Heal(heal_health, self)
	caster:GiveMana(heal_mana)

	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, caster, heal_health, nil)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, caster, heal_mana, nil)
end

function night_stalker_hunter_in_the_night_lua:GetIntrinsicModifierName()
	return "night_stalker_hunter_in_the_night_handler_lua"
end



night_stalker_hunter_in_the_night_handler_lua = class({})

function night_stalker_hunter_in_the_night_handler_lua:IsHidden() return true end
function night_stalker_hunter_in_the_night_handler_lua:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function night_stalker_hunter_in_the_night_handler_lua:OnCreated()
	if IsClient() then return end

	self:StartIntervalThink(0.5)
end

function night_stalker_hunter_in_the_night_handler_lua:OnDestroy()
	if IsClient() then return end

	self:GetParent():RemoveModifierByName("night_stalker_hunter_in_the_night_lua_buff")
end

function night_stalker_hunter_in_the_night_handler_lua:OnIntervalThink()
	if not self or self:IsNull() then return end
	local parent = self:GetParent()
	if not parent or parent:IsNull() then return end

	if GameRules:IsDaytime() then
		parent:RemoveModifierByName("night_stalker_hunter_in_the_night_lua_buff")
	elseif not parent:HasModifier("night_stalker_hunter_in_the_night_lua_buff") then
		parent:AddNewModifier(parent, self:GetAbility(), "night_stalker_hunter_in_the_night_lua_buff", {})
	end
end



night_stalker_hunter_in_the_night_lua_buff = class({})

function night_stalker_hunter_in_the_night_lua_buff:IsHidden() return true end
function night_stalker_hunter_in_the_night_lua_buff:IsDebuff() return false end
function night_stalker_hunter_in_the_night_lua_buff:IsPurgable() return false end
function night_stalker_hunter_in_the_night_lua_buff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function night_stalker_hunter_in_the_night_lua_buff:GetEffectName()
	return "particles/units/heroes/hero_night_stalker/nightstalker_night_buff.vpcf"
end

function night_stalker_hunter_in_the_night_lua_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function night_stalker_hunter_in_the_night_lua_buff:OnCreated(keys)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	if not self.parent or self.parent:IsNull() then return end
	if not self.ability or self.ability:IsNull() then return end
	
	self.move_speed_bonus = self.ability:GetSpecialValueFor("bonus_movement_speed_pct_night")
	self.attack_speed_bonus = self.ability:GetSpecialValueFor("bonus_attack_speed_night")
	self.status_resist_bonus = self.ability:GetSpecialValueFor("bonus_status_resist_night")

	self.normal_model = "models/heroes/nightstalker/nightstalker.vmdl"
	self.night_model = "models/heroes/nightstalker/nightstalker_night.vmdl"

	if not IsServer() then return end
	
	-- Apply transformation particle
	if self.parent:IsRealHero() then
		local transform_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_night_stalker/nightstalker_change.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControl(transform_pfx, 0, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(transform_pfx, 1, self.parent:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(transform_pfx)
	end

	if self.parent:GetUnitName() ~= "npc_dota_hero_night_stalker" then return end
	if self.ability:IsStolen() then return end

	-- Apply night model
	self.parent:SetModel(self.night_model)
	self.parent:SetOriginalModel(self.night_model)
	
	if self.wings then
		-- Remove old wearables
		UTIL_Remove(self.wings)
		UTIL_Remove(self.legs)
		UTIL_Remove(self.tail)
	end

	-- Set new wearables
	self.wings = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/nightstalker/nightstalker_wings_night.vmdl"})
	self.legs = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/nightstalker/nightstalker_legarmor_night.vmdl"})
	self.tail = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/nightstalker/nightstalker_tail_night.vmdl"})
	-- lock to bone
	self.wings:FollowEntity(self.parent, true)
	self.legs:FollowEntity(self.parent, true)
	self.tail:FollowEntity(self.parent, true)
end

function night_stalker_hunter_in_the_night_lua_buff:OnRefresh(keys)
	self:OnCreated(keys)
end

function night_stalker_hunter_in_the_night_lua_buff:OnDestroy()
	if not IsServer() then return end
	if not self or self:IsNull() then return end
	if not self.parent or self.parent:IsNull() then return end

	-- Apply transformation particle
	local transform_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_night_stalker/nightstalker_change.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(transform_pfx, 0, self.parent:GetAbsOrigin())
	ParticleManager:SetParticleControl(transform_pfx, 1, self.parent:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(transform_pfx)

	if self.parent:GetUnitName() ~= "npc_dota_hero_night_stalker" then return end
	if self.ability:IsStolen() then return end

	-- Revert Models
	self.parent:SetModel(self.normal_model)
	self.parent:SetOriginalModel(self.normal_model)
	
	if self.wings then
		-- Remove old wearables
		UTIL_Remove(self.wings)
		UTIL_Remove(self.legs)
		UTIL_Remove(self.tail)
	end
end

function night_stalker_hunter_in_the_night_lua_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	}
end

function night_stalker_hunter_in_the_night_lua_buff:GetModifierStatusResistanceStacking()
	if self.parent and not self.parent:PassivesDisabled() then
		return self.status_resist_bonus
	end
end

function night_stalker_hunter_in_the_night_lua_buff:GetModifierAttackSpeedBonus_Constant()
	if self.parent and not self.parent:PassivesDisabled() then
		return self.attack_speed_bonus
	end
end

function night_stalker_hunter_in_the_night_lua_buff:GetModifierMoveSpeedBonus_Percentage()
	if self.parent and not self.parent:PassivesDisabled() then
		return self.move_speed_bonus
	end
end

function night_stalker_hunter_in_the_night_lua_buff:GetActivityTranslationModifiers()
	if IsValidEntity(self.parent) and self.parent:HasModifier("modifier_night_stalker_darkness") then
		return "hunter_night"
	end
end
