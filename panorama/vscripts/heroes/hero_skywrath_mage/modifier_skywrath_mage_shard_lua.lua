modifier_skywrath_mage_shard_lua = class({})

function modifier_skywrath_mage_shard_lua:IsHidden() return true end
function modifier_skywrath_mage_shard_lua:IsDebuff() return false end
function modifier_skywrath_mage_shard_lua:IsPurgable() return false end
function modifier_skywrath_mage_shard_lua:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_skywrath_mage_shard_lua:OnCreated()
	if not IsServer() then return end

	self.ability_exceptions = {
		timbersaw_chakram_lua_return = true,
		timbersaw_chakram_lua_2_return = true,
		nyx_assassin_burrow = true,
		nyx_assassin_unburrow = true,
		pugna_life_drain = true,
		tinker_rearm_lua = true,
		techies_focused_detonate = true,
		rubick_telekinesis_land = true,
		rubick_telekinesis_land_self = true,
		puck_ethereal_jaunt = true,
		shadow_demon_shadow_poison_release = true,
		brewmaster_drunken_brawler = true,
		elder_titan_return_spirit_lua = true,
		elder_titan_move_spirit_lua = true,
	}

	if not self:GetAbility() or self:GetAbility():IsNull() then 
		self:Destroy()
		return
	end
end

function modifier_skywrath_mage_shard_lua:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}
end

function modifier_skywrath_mage_shard_lua:OnAbilityFullyCast(event) 
	local parent = self:GetParent()
	local cast_ability = event.ability
	local duration = 35

	local ability = self:GetAbility() or parent:FindAbilityByName("skywrath_mage_arcane_bolt")

	if not ability then return end
	if not parent or parent:IsNull() then return end
	if not cast_ability or cast_ability:IsNull() then return end
	if cast_ability:IsItem() then return end
	if cast_ability:IsToggle() then return end
	if self.ability_exceptions and self.ability_exceptions[cast_ability:GetAbilityName()] then return end
	
	if parent == event.unit then
		local modifier = parent:AddNewModifier(parent, ability, "modifier_skywrath_mage_shard_bonus_counter_lua", {duration = duration})
		if modifier and not modifier:IsNull() then
			modifier:AddIndependentStack(duration, nil, false, {stacks = self.stacks})
		end
	end
end



modifier_skywrath_mage_shard_bonus_counter_lua = class({})

function modifier_skywrath_mage_shard_bonus_counter_lua:IsHidden()
	return self:GetStackCount() == 0
end
function modifier_skywrath_mage_shard_bonus_counter_lua:IsDebuff() return false end
function modifier_skywrath_mage_shard_bonus_counter_lua:IsPurgable() return false end
function modifier_skywrath_mage_shard_bonus_counter_lua:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_skywrath_mage_shard_bonus_counter_lua:OnCreated()
	if not IsServer() then return end
	if not self:GetAbility() or self:GetAbility():IsNull() then 
		self:Destroy()
		return
	end
end

function modifier_skywrath_mage_shard_bonus_counter_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_skywrath_mage_shard_bonus_counter_lua:GetModifierBonusStats_Intellect()
	return 5 * self:GetStackCount()
end

function modifier_skywrath_mage_shard_bonus_counter_lua:GetModifierPhysicalArmorBonus()
	return self:GetStackCount()
end
