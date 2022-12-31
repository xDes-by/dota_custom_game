innate_tinkerer = class({})

LinkLuaModifier("modifier_innate_tinkerer", "heroes/innates/tinkerer", LUA_MODIFIER_MOTION_NONE)

function innate_tinkerer:GetIntrinsicModifierName()
	return "modifier_innate_tinkerer"
end

local ignored_special_values = {
	item_eye_of_midas 			= {active_cooldown = true},
	item_witless_shako 			= {max_mana = true},
	item_spell_prism 			= {bonus_cooldown = true},
	item_spell_fractal 			= {bonus_cooldown = true},
	item_quickening_charm 		= {bonus_cooldown = true},
	item_force_boots 			= {push_duration = true},
	item_mirror_shield 			= {block_cooldown = true},
	item_fallen_sky 			= {land_time = true, burn_interval = true, blink_damage_cooldown = true},
	item_bullwhip 				= {bullwhip_delay_time = true},
	item_stormcrafter 			= {interval = true},
	item_teleports_behind_you 	= {meteor_fall_time = true, blink_damage_cooldown = true},
	item_nether_shawl 			= {bonus_armor = true},
	item_ninja_gear 			= {visibility_radius = true, duration = true},
	item_misericorde 			= {missing_hp = true },
	item_spy_gadget				= {scan_cooldown_reduction = true},
	item_havoc_hammer			= {angle = true},
	item_eye_of_the_vizier		= {mana_reduction_pct = true},
	item_dagger_of_ristul		= {health_sacrifice = true},
	item_ogre_seal_totem		= {leap_distance = true},
	item_book_of_shadows		= {duration = true},
	item_unstable_wand			= {duration = true},
}

local ignored_special_values_names = {
	AbilityManaCost = true,
	AbilityCooldown = true,
	AbilityChannelTime = true,
	AbilityChargeRestoreTime = true,
}

modifier_innate_tinkerer = class({})

function modifier_innate_tinkerer:IsHidden() return true end
function modifier_innate_tinkerer:IsDebuff() return false end
function modifier_innate_tinkerer:IsPurgable() return false end
function modifier_innate_tinkerer:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_tinkerer:OnCreated()
	RegisterSpecialValuesModifier(self)

	self.ability = self:GetAbility()
	self.neutral_list = {}

	local neutralItemKV = LoadKeyValues("scripts/npc/neutral_items.txt")
	for neutralTier, levelData in pairs(neutralItemKV) do
		if levelData and type(levelData) == "table" then
			for key,data in pairs(levelData) do
				if key =="items" then
					for k,v in pairs(data) do
						self.neutral_list[k] = tonumber(neutralTier)
					end
				end
			end
		end
	end

	if IsServer() then self:StartIntervalThink(1) end
end

function modifier_innate_tinkerer:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_innate_tinkerer:GetAbilitySpecialValueMultiplier(keys)
	if not self.ability or not keys.ability then return end
	if ignored_special_values_names[keys.ability_special_value] then return 0 end

	local ability_name = keys.ability:GetAbilityName()

	if self.neutral_list and self.neutral_list[keys.ability:GetAbilityName()] and not (ignored_special_values[ability_name] and ignored_special_values[ability_name][keys.ability_special_value]) then
		return 0.01 * self.ability:GetLevelSpecialValueFor("neutral_item_stats_pct_increase", self.neutral_list[keys.ability:GetAbilityName()] - 1)
	end

	return 0
end

function modifier_innate_tinkerer:OnAttackLanded(keys)
	if not IsServer() then return end

	local parent = self:GetParent()
	if parent ~= keys.attacker then return end
	if not parent:HasModifier("modifier_item_heavy_blade") then return end
	
	local target = keys.target

	if parent:IsRealHero() and parent:GetTeam() ~= target:GetTeam() and target.GetMaxMana and target:GetMaxMana() and target:GetMaxMana() > 1 then
		-- take 4% of max mana and multiply by 0.85
		-- the vanila witchbane damage is already applied
		local damage = target:GetMaxMana() * 0.04 * 0.01 * self.ability:GetLevelSpecialValueFor("neutral_item_stats_pct_increase", self.neutral_list["item_heavy_blade"] - 1)
		ApplyDamage({
			victim = target, 
			attacker = parent, 
			damage = damage, 
			damage_type = DAMAGE_TYPE_MAGICAL, 
			damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
		})
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, target, damage, nil)
	end
end

function modifier_innate_tinkerer:OnIntervalThink()
	local parent = self:GetParent()
	local ability = self:GetAbility()

	if parent then
		local item = parent:GetItemInSlot(DOTA_ITEM_NEUTRAL_SLOT)
		if item and not item:IsNull() then
			if ability then ability:SetLevel(self.neutral_list[item:GetAbilityName()] or 0) end
		else
			if ability then ability:SetLevel(0) end
		end
	end
end
