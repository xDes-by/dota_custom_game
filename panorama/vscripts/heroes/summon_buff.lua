---@class summon_buff:CDOTA_Ability_Lua
summon_buff = class({})

local power_exceptions = {
	npc_dota_shadow_shaman_ward_1 = 	0.8,
	npc_dota_shadow_shaman_ward_2 = 	0.8,
	npc_dota_shadow_shaman_ward_3 = 	0.8,
	
	npc_dota_lone_druid_bear1 = 		0.85,
	npc_dota_lone_druid_bear2 = 		0.85,
	npc_dota_lone_druid_bear3 = 		0.85,
	npc_dota_lone_druid_bear4 = 		0.85,
	
	npc_dota_witch_doctor_death_ward =	0.9,
	
	npc_dota_warlock_golem_1 =			1.0,
	npc_dota_warlock_golem_2 =			1.0,
	npc_dota_warlock_golem_3 =			1.0,
	npc_dota_warlock_golem_scepter_1 =	1.0,
	npc_dota_warlock_golem_scepter_2 =	1.0,
	npc_dota_warlock_golem_scepter_3 =	1.0,
	
	npc_dota_unit_tombstone1 = 			1.15,
	npc_dota_unit_tombstone2 = 			1.15,
	npc_dota_unit_tombstone3 = 			1.15,
	npc_dota_unit_tombstone4 = 			1.15,

	npc_dota_lesser_eidolon = 			1.2,
	npc_dota_eidolon = 					1.2,
	npc_dota_greater_eidolon = 			1.2,
	npc_dota_dire_eidolon = 			1.2,
	
	npc_dota_visage_familiar1 = 		1.2,
	npc_dota_visage_familiar2 = 		1.2,
	npc_dota_visage_familiar3 = 		1.2,
	
	npc_dota_furion_treant_1 = 			1.25,
	npc_dota_furion_treant_2 = 			1.25,
	npc_dota_furion_treant_3 = 			1.25,
	npc_dota_furion_treant_4 = 			1.25,
	npc_dota_furion_treant_large = 		1.25,
	
	npc_dota_venomancer_plague_ward_1 = 1.45,
	npc_dota_venomancer_plague_ward_2 = 1.45,
	npc_dota_venomancer_plague_ward_3 = 1.45,
	npc_dota_venomancer_plague_ward_4 = 1.45,
	
	npc_dota_invoker_forged_spirit = 	1.6,
	
	npc_dota_lycan_wolf1 =				1.6,
	npc_dota_lycan_wolf2 =				1.6,
	npc_dota_lycan_wolf3 =				1.6,
	npc_dota_lycan_wolf4 =				1.6,
	
	npc_dota_beastmaster_boar =			1.65,
	
	npc_dota_broodmother_spiderling = 	1.7,
	npc_dota_broodmother_spiderite = 	1.7,
	
	npc_dota_techies_land_mine =		1.7,
}

-- does not receive hp manipulation
local hp_exceptions = {
	npc_dota_zeus_cloud = true,
}

function summon_buff:Spawn()
	if IsServer() then self:SetLevel(1) end
end

function summon_buff:GetIntrinsicModifierName() return "modifier_summon_buff" end


LinkLuaModifier("modifier_summon_buff", "heroes/summon_buff", LUA_MODIFIER_MOTION_NONE)

---@class modifier_summon_buff:CDOTA_Modifier_Lua
modifier_summon_buff = class({})

function modifier_summon_buff:IsHidden() return true end
function modifier_summon_buff:IsDebuff() return false end
function modifier_summon_buff:IsPurgable() return false end
function modifier_summon_buff:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_summon_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE, 	-- GetModifierDamageOutgoing_Percentage
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE, 	-- GetModifierSpellAmplify_Percentage
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, 		-- GetModifierPhysicalArmorBonus
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, 	-- GetModifierAttackSpeedBonus_Constant
		MODIFIER_PROPERTY_MODEL_SCALE,					-- GetModifierModelScale
		MODIFIER_EVENT_ON_DEATH
	}
end

function modifier_summon_buff:OnCreated()
	self:SetHasCustomTransmitterData(true)
	if IsClient() then return end
	
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if not IsValidEntity(self.parent) or not IsValidEntity(self.ability) then self:Destroy() return end

	self.owner = self.parent:GetOwner()
	self.exception_power = power_exceptions[self.parent:GetUnitName()] or 1

	if not IsValidEntity(self.owner) then self:Destroy() return end

	self.hero = PlayerResource:GetSelectedHeroEntity(self.parent:GetPlayerOwnerID())

	if not IsValidEntity(self.hero) then self:Destroy() return end

	--For summons whose abilities have type MULTICAST_TYPE_SUMMON in multicast.lua
	self.multicast_multiplier = 1
	if self.hero:HasModifier("modifier_multicast_lua") then
		local summon_ability = GetAbilityCorrespondingSummon(self.hero, self.parent)

		if summon_ability then
			self.multicast_multiplier = summon_ability.multicast_count or 1
		end
	end

	Timers:CreateTimer(0.01, function()

		if not IsValidEntity(self.parent) then return end

		if self.multicast_multiplier > 1 then
			self.parent:SetBaseDamageMin(self.parent:GetBaseDamageMin()*self.multicast_multiplier)
			self.parent:SetBaseDamageMax(self.parent:GetBaseDamageMax()*self.multicast_multiplier)

			local multicast_modifier = self.hero:FindModifierByName("modifier_multicast_lua")
			if self.multicast_multiplier > 1 and multicast_modifier then
				multicast_modifier:PlaySummonFX(self.parent, self.multicast_multiplier)
			end
		end

		self:OnRefresh(true)

		if self.parent:IsAlive() then 
			self.parent:SetHealth(self.parent:GetMaxHealth()) 
		end
	end)

	if SUMMON_TELEPORTABLE_SUMMONS[self.parent:GetUnitName()] then
		self:StartIntervalThink(1)
	end
end

function modifier_summon_buff:OnRefresh(forced)
	if IsClient() then return end

	if not IsValidEntity(self.parent) or not IsValidEntity(self.hero) or not IsValidEntity(self.ability) then return end

	self.level = 1 + self:GetCrownLevel()

	if self.level ~= self.ability:GetLevel() then self.ability:SetLevel(self.level) end

	self.multiplier = self:GetBonusMultiplier() * self:GetDuelingMultiplier() * self.exception_power
	
	self:SetValues()
	
	local str = self.hero:GetStrength() or 0
	local agi = self.hero:GetAgility() or 0
	local int = self.hero:GetIntellect() or 0

	self.total_hp			= math.floor((self.original_base_health + self:GetExternalHealthAddition()) 
								* (1 + self.multiplier * self.hp_per_str * 0.01 * str) 
								* self:GetExternalHealthMultiplier() 
								* self.multicast_multiplier)
	self.bonus_dmg			= math.floor(self.multiplier * self.dmg_per_int * int)
	self.spell_amp_per_int	= math.floor(self.multiplier * self.spell_amp_per_int * int)
	self.bonus_armor		= math.floor(self.multiplier * self.armor_per_agi * agi)
	self.bonus_as			= math.floor(self.multiplier * self.as_per_agi * agi)
	self.model_scale		= math.floor(min(40, self.multiplier * self.scale_per_stats * (agi + int + str)))

	if self.parent:GetMaxHealth() ~= self.total_hp and not hp_exceptions[self.parent:GetUnitName()] then
		local current_hp_pct = self.parent:GetHealthPercent()
		self.parent:SetBaseMaxHealth(math.max(1, self.total_hp))
		self.parent:SetMaxHealth(math.max(1, self.total_hp))

		if self.parent:IsAlive() then
			self.parent:SetHealth(math.max(1, self.total_hp * current_hp_pct * 0.01))
		end
	end

	self:SendBuffRefreshToClients()
	self:CheckTempestDoubleAbility()
	
	if not SUMMON_TELEPORTABLE_SUMMONS[self.parent:GetUnitName()] then self:StartIntervalThink(-1) end
end

function modifier_summon_buff:OnIntervalThink() self:OnRefresh() end

function modifier_summon_buff:GetCrownLevel()
	if not IsValidEntity(self.parent) or not IsValidEntity(self.hero) then return end
	
	local item_list = {}
	for slot = DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_6 do
		local item = self.hero:GetItemInSlot(slot)
		if item then
			item_list[item:GetAbilityName()] = true
		end
	end
	
	if item_list["item_summoner_crown_3"] then
		return 3
	elseif item_list["item_summoner_crown_2"] then
		return 2
	elseif item_list["item_summoner_crown"] then
		return 1
	else
		return 0
	end
end

function modifier_summon_buff:GetDuelingMultiplier()
	if not IsValidEntity(self.parent) or not IsValidEntity(self.hero) then return end

	if self.hero:IsDueling() then
		return (self.duel_multiplier or 1)
	end

	return 1
end

function modifier_summon_buff:GetBonusMultiplier()
	if not IsValidEntity(self.parent) or not IsValidEntity(self.hero) then return end

	local mult = 1

	local innate = self.hero:FindAbilityByName("innate_soul_link")
	if innate then
		mult =  1 + 0.01 * (innate:GetSpecialValueFor("bonus_power") or 0)
	end

	local mastery = self.hero:FindModifierByName("modifier_chc_mastery_summon_power_1") 
		or self.hero:FindModifierByName("modifier_chc_mastery_summon_power_2")
		or self.hero:FindModifierByName("modifier_chc_mastery_summon_power_3")

	if mastery then
		mult =  mult + 0.01 * mastery:GetBonusSummonPower()
	end

	return mult
end

modifier_summon_buff.externalHealthMultipliers = {
	npc_dota_furion_treant_1 = function(self)
		if self.hero and self.hero:HasAbility("special_bonus_unique_furion") then
			local talent = self.hero:FindAbilityByName("special_bonus_unique_furion")
			if talent:GetLevel() > 0 then
				return talent:GetSpecialValueFor("value")
			end
		end
		return 0
	end,
	npc_dota_furion_treant_2 = function(self)
		if self.hero and self.hero:HasAbility("special_bonus_unique_furion") then
			local talent = self.hero:FindAbilityByName("special_bonus_unique_furion")
			if talent:GetLevel() > 0 then
				return talent:GetSpecialValueFor("value")
			end
		end
		return 0
	end,
	npc_dota_furion_treant_3 = function(self)
		if self.hero and self.hero:HasAbility("special_bonus_unique_furion") then
			local talent = self.hero:FindAbilityByName("special_bonus_unique_furion")
			if talent:GetLevel() > 0 then
				return talent:GetSpecialValueFor("value")
			end
		end
		return 0
	end,
	npc_dota_furion_treant_4 = function(self)
		if self.hero and self.hero:HasAbility("special_bonus_unique_furion") then
			local talent = self.hero:FindAbilityByName("special_bonus_unique_furion")
			if talent:GetLevel() > 0 then
				return talent:GetSpecialValueFor("value")
			end
		end
		return 0
	end,
	npc_dota_furion_treant_large = function(self)
		if self.hero and self.hero:HasAbility("special_bonus_unique_furion") then
			local talent = self.hero:FindAbilityByName("special_bonus_unique_furion")
			if talent:GetLevel() > 0 then
				return talent:GetSpecialValueFor("value")
			end
		end
		return 0
	end,
}


modifier_summon_buff.externalHealthAdditions = {
	npc_dota_lone_druid_bear1 = function(self)
		return self.hero:GetTalentValue("special_bonus_unique_lone_druid_7")
	end,

	npc_dota_lone_druid_bear2 = function(self)
		return self.hero:GetTalentValue("special_bonus_unique_lone_druid_7")
	end,

	npc_dota_lone_druid_bear3 = function(self)
		return self.hero:GetTalentValue("special_bonus_unique_lone_druid_7")
	end,

	npc_dota_lone_druid_bear4 = function(self)
		return self.hero:GetTalentValue("special_bonus_unique_lone_druid_7")
	end,
}

function modifier_summon_buff:GetExternalHealthMultiplier()
	local total_health_multiplier = 0
	local className = self.parent:GetClassname()
	local unitName = self.parent:GetUnitName()
	
	if self.externalHealthMultipliers[className] then
		total_health_multiplier = total_health_multiplier + self.externalHealthMultipliers[className](self)
	end
	if self.externalHealthMultipliers[unitName] then
		total_health_multiplier = total_health_multiplier + self.externalHealthMultipliers[unitName](self)
	end
	return math.max(total_health_multiplier, 1)
end

function modifier_summon_buff:GetExternalHealthAddition()
	local total_health_addition = 0
	local className = self.parent:GetClassname()
	local unitName = self.parent:GetUnitName()

	if not self.hero or self.hero:IsNull() then return 0 end

	if self.externalHealthAdditions[className] then
		total_health_addition = total_health_addition + self.externalHealthAdditions[className](self)
	end

	if self.externalHealthAdditions[unitName] then
		total_health_addition = total_health_addition + self.externalHealthAdditions[unitName](self)
	end

	return total_health_addition
end

function modifier_summon_buff:SetValues()
	self.hp_per_str			= self.ability:GetSpecialValueFor("hp_per_str")
	self.as_per_agi			= self.ability:GetSpecialValueFor("as_per_agi")
	self.dmg_per_int		= self.ability:GetSpecialValueFor("dmg_per_int")
	self.spell_amp_per_int	= self.ability:GetSpecialValueFor("spell_amp_per_int")
	self.armor_per_agi		= self.ability:GetSpecialValueFor("armor_per_agi")
	self.scale_per_stats	= self.ability:GetSpecialValueFor("scale_per_stats")
	self.duel_multiplier	= 0.01 * self.ability:GetSpecialValueFor("duel_multiplier")

	self.original_base_health = (self.original_base_health or self.parent:GetBaseMaxHealth()) or 1

	-- Bear exception
	local special_unit_health = {
		npc_dota_lone_druid_bear1 = 1100,
		npc_dota_lone_druid_bear2 = 1400,
		npc_dota_lone_druid_bear3 = 1700,
		npc_dota_lone_druid_bear4 = 2000,
	}

	if special_unit_health[self.parent:GetUnitName()] then
		self.original_base_health = special_unit_health[self.parent:GetUnitName()] + 75 * (self.parent:GetLevel() - 1)
	end
end

function modifier_summon_buff:CheckTempestDoubleAbility()
	if self.parent and self.owner and not (self.parent:IsNull() or self.owner:IsNull()) and self.owner:IsTempestDouble() then
		if (not self.hero) or self.hero:IsNull() or (not self.hero:HasAbility("arc_warden_tempest_double_lua")) then
			if self.parent:IsAlive() then self.parent:ForceKill(false) end
		end
	end
end

function modifier_summon_buff:GetModifierAttackSpeedBonus_Constant() return self.bonus_as end
function modifier_summon_buff:GetModifierDamageOutgoing_Percentage() return self.bonus_dmg end
function modifier_summon_buff:GetModifierSpellAmplify_Percentage() return self.spell_amp_per_int end
function modifier_summon_buff:GetModifierPhysicalArmorBonus() return self.bonus_armor end
function modifier_summon_buff:GetModifierModelScale() return self.model_scale end

function modifier_summon_buff:AddCustomTransmitterData()
	return {
		bonus_as = self.bonus_as,
		bonus_dmg = self.bonus_dmg,
		spell_amp_per_int = self.spell_amp_per_int,
		bonus_armor = self.bonus_armor,
	}
end

function modifier_summon_buff:HandleCustomTransmitterData(data)
	self.bonus_as = tonumber(data.bonus_as)
	self.bonus_dmg = tonumber(data.bonus_dmg)
	self.spell_amp_per_int = tonumber(data.spell_amp_per_int)
	self.bonus_armor = tonumber(data.bonus_armor)
end

function modifier_summon_buff:OnDeath(event)
	if event.unit == self.parent then
		-- https://github.com/arcadia-redux/custom_hero_clash_issues/issues/2107
		self.parent:SetHealth(0)
	end
end
