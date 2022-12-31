item_vladmirs_wrath = class({})

LinkLuaModifier("modifier_item_vladmirs_wrath", "items/vladmirs_wrath", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_vladmirs_wrath_aura", "items/vladmirs_wrath", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_vladmirs_wrath_active", "items/vladmirs_wrath", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
function item_vladmirs_wrath:GetIntrinsicModifierName()
	return "modifier_item_vladmirs_wrath"
end

function item_vladmirs_wrath:OnSpellStart()
	local parent = self:GetCaster()

	EmitSoundOn("Hero_ArcWarden.Flux.Target", parent)
	EmitSoundOn("Hero_Axe.Battle_Hunger", parent)

	if IsClient() then return end

	parent:AddNewModifier(parent, self, "modifier_item_vladmirs_wrath_active", {duration = self:GetSpecialValueFor("active_duration")})
end

-- Item Stats
modifier_item_vladmirs_wrath = class({})

function modifier_item_vladmirs_wrath:IsDebuff() return false end
function modifier_item_vladmirs_wrath:IsHidden() return true end
function modifier_item_vladmirs_wrath:IsPurgable() return false end
function modifier_item_vladmirs_wrath:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_item_vladmirs_wrath:OnCreated(keys)
    local ability = self:GetAbility()
    
	self.bonus_str = ability:GetSpecialValueFor("bonus_str")
	self.bonus_agi = ability:GetSpecialValueFor("bonus_agi")
	self.bonus_int = ability:GetSpecialValueFor("bonus_int")

	self.aura_radius = ability:GetSpecialValueFor("aura_radius")
end

function modifier_item_vladmirs_wrath:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
end

function modifier_item_vladmirs_wrath:GetModifierBonusStats_Strength()
	return self.bonus_str
end

function modifier_item_vladmirs_wrath:GetModifierBonusStats_Agility()
	return self.bonus_agi
end

function modifier_item_vladmirs_wrath:GetModifierBonusStats_Intellect()
	return self.bonus_int
end

function modifier_item_vladmirs_wrath:IsAura()
	return true
end

function modifier_item_vladmirs_wrath:GetModifierAura()
	return "modifier_item_vladmirs_wrath_aura"
end

function modifier_item_vladmirs_wrath:GetAuraRadius()
	return self.aura_radius
end

function modifier_item_vladmirs_wrath:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_item_vladmirs_wrath:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_OTHER
end

item_vladmirs_wrath.aura_all_values = {
	crystal_maiden_brilliance_aura_lua = true,
	lycan_feral_impulse = true,
}

item_vladmirs_wrath.aura_certain_values = {
	beastmaster_inner_beast = {
		bonus_attack_speed = true,
	},

	centaur_return = {
		return_damage = true,
		return_damage_str = true,
	},

	luna_lunar_blessing = {
		bonus_damage = true,
		bonus_night_vision = true,
	},

	chen_divine_favor = {
		heal_amp = true,
		heal_rate = true,
	},

	abyssal_underlord_atrophy_aura = {
		damage_reduction_pct = true,
	},

	elder_titan_natural_order_lua = {
		armor_reduction_pct = true,
		magic_resistance_pct = true,
	},

	omniknight_degen_aura = {
		speed_bonus = true,
	},

	nevermore_dark_lord = {
		presence_armor_reduction = true,
	},

	item_vladmirs_wrath = {
		aura_bonus_attack_damage_pct = true,
		aura_lifesteal_pct = true,
		aura_armor = true,
		aura_attack_speed = true,
	},

	drow_ranger_marksmanship_lua = {
		agility_multiplier = true,
	},

	doom_bringer_scorched_earth = {
		damage_per_second = true,
		bonus_movement_speed_pct = true,
	},

	lycan_shapeshift = {
		speed = true,
		bonus_night_vision = true,
		crit_chance = true,
		crit_multiplier = true,
	},

	naga_siren_song_of_the_siren = {
		regen_rate = true,
		regen_rate_self = true,
		regen_rate_tooltip_scepter = true,
	},

	vengefulspirit_command_aura = {
		bonus_base_damage = true,
	},

	witch_doctor_voodoo_restoration = {
		heal = true,
	},

	item_assault = {
		aura_attack_speed = true,
		aura_positive_armor = true,
		aura_negative_armor = true,
	},

	item_buckler = {
		bonus_aoe_armor = true,
	},

	item_guardian_greaves = {
		aura_health_regen = true,
		aura_armor = true,
		aura_health_regen_bonus = true,
		aura_armor_bonus = true,
		aura_bonus_threshold = true,
	},

	item_mekansm = {
		aura_health_regen = true,
	},

	item_pipe = {
		aura_health_regen = true,
		magic_resistance_aura = true,
	},

	item_ring_of_basilius = {
		aura_mana_regen = true,
	},

	item_veil_of_discord = {
		aura_mana_regen = true,
	},

	item_vladmir = {
		armor_aura = true,
		mana_regen_aura = true,
		lifesteal_aura = true,
		damage_aura = true,
	},

	invoker_ghost_walk_ad = {
		area_of_effect = true,
		enemy_slow = true,
	},

	necrolyte_sadist = {
		heal_bonus = true,
		movement_speed = true,
	},

	necrolyte_heartstopper_aura = {
		aura_damage = true,
	},

	phoenix_supernova = {
		damage_per_sec = true,
	},

	pudge_rot = {
		rot_slow = true,
		rot_damage = true,
		scepter_rot_damage_bonus = true,
	},

	tusk_tag_team = {
		bonus_damage = true,
		movement_slow = true,
		slow_duration = true,
	},

	windrunner_windrun = {
		enemy_movespeed_bonus_pct = true,
	},

	item_radiance = {
		aura_damage = true,
		aura_damage_illusions = true,
		blind_pct = true,
	},

	item_luminance = {
		aura_damage = true,
		str_aura_multiplier_round = true,
		str_aura_multiplier_duel = true,
		high_str_multiplier = true,
	},

	item_shivas_guard = {
		aura_attack_speed = true,
		hp_regen_degen_aura = true,
	},
}

-- Aura Doubler
modifier_item_vladmirs_wrath_active = class({})
function modifier_item_vladmirs_wrath_active:IsDebuff() return false end
function modifier_item_vladmirs_wrath_active:IsHidden() return false end
function modifier_item_vladmirs_wrath_active:IsPurgable() return false end
function modifier_item_vladmirs_wrath_active:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_item_vladmirs_wrath_active:OnCreated()
	local ability = self:GetAbility()

	local roar_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_sven/sven_spell_gods_strength.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(roar_pfx, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(roar_pfx)

	self.aura_all_values = ability.aura_all_values
	self.aura_certain_values = ability.aura_certain_values
	self.aura_multiplication = ability:GetSpecialValueFor("active_multiplication_pct")
end

function modifier_item_vladmirs_wrath_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
	}
end

function modifier_item_vladmirs_wrath_active:GetModifierOverrideAbilitySpecial( params )
	local ability = params.ability

	if self.aura_all_values[ability:GetAbilityName()] or self.aura_certain_values[ability:GetAbilityName()] then
		return 1
	end

	return 0
end

function modifier_item_vladmirs_wrath_active:GetModifierOverrideAbilitySpecialValue( params )
	local szAbilityName = params.ability:GetAbilityName() 
	local szSpecialValueName = params.ability_special_value
	local nSpecialLevel = params.ability_special_level

	local flBaseValue = params.ability:GetLevelSpecialValueNoOverride( szSpecialValueName, nSpecialLevel )
	local flTotalValue = flBaseValue

	if self.aura_all_values[szAbilityName] or (self.aura_certain_values[szAbilityName] and self.aura_certain_values[szAbilityName][szSpecialValueName]) then
		flTotalValue = flTotalValue * (1 + (self.aura_multiplication or 0) / 100)
	end

	return flTotalValue
end


function modifier_item_vladmirs_wrath_active:GetEffectName()
	return "particles/items_fx/aura_vlads.vpcf"
end

modifier_item_vladmirs_wrath_aura = class({})
function modifier_item_vladmirs_wrath_aura:IsDebuff() return false end
function modifier_item_vladmirs_wrath_aura:IsHidden() return false end
function modifier_item_vladmirs_wrath_aura:IsPurgable() return false end
function modifier_item_vladmirs_wrath_aura:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_item_vladmirs_wrath_aura:OnCreated(keys)
    local ability = self:GetAbility()
    
	-- This implementation means that the auras wont update with the active
	-- self.aura_bonus_attack_damage_pct = ability:GetSpecialValueFor("aura_bonus_attack_damage_pct")
	-- self.aura_lifesteal_pct = ability:GetSpecialValueFor("aura_lifesteal_pct")
	-- self.aura_armor = ability:GetSpecialValueFor("aura_armor")
	-- self.aura_attack_speed = ability:GetSpecialValueFor("aura_attack_speed")
end

function modifier_item_vladmirs_wrath_aura:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_item_vladmirs_wrath_aura:GetModifierDamageOutgoing_Percentage()
	return self:GetAbility():GetSpecialValueFor("aura_bonus_attack_damage_pct")
end

function modifier_item_vladmirs_wrath_aura:OnAttackLanded(kv)
	if IsClient() then return end
	if kv.attacker ~= self:GetParent() then return end

	-- Lifesteal particles
	local lifesteal_pfx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, kv.attacker)
	ParticleManager:SetParticleControl(lifesteal_pfx, 0, kv.attacker:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(lifesteal_pfx)
	
	-- HEAL
	kv.attacker:Heal(kv.damage * self:GetAbility():GetSpecialValueFor("aura_lifesteal_pct")/100, kv.attacker)
end

function modifier_item_vladmirs_wrath_aura:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("aura_armor")
end

function modifier_item_vladmirs_wrath_aura:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("aura_attack_speed")
end

function modifier_item_vladmirs_wrath_aura:OnTooltip()
	return self:GetAbility():GetSpecialValueFor("aura_lifesteal_pct")
end
