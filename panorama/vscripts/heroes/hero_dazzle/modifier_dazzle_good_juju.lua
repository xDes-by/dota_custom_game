modifier_dazzle_good_juju_lua = class({})

modifier_dazzle_good_juju_lua.restricted_abilities = {
	dark_willow_shadow_realm = true,
	abaddon_borrowed_time = true,
	slark_shadow_dance = true,
	slark_depth_shroud = true,
	skeleton_king_reincarnation = true,
	dazzle_shallow_grave = true,
	oracle_false_promise = true,
	faceless_void_chronosphere = true,
	tinker_rearm_lua = true,
}

function modifier_dazzle_good_juju_lua:IsHidden() return true end
function modifier_dazzle_good_juju_lua:IsPurgable() return false end
function modifier_dazzle_good_juju_lua:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_dazzle_good_juju_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}
end

function modifier_dazzle_good_juju_lua:OnCreated()
	self.cooldown_reduction = self:GetAbility():GetSpecialValueFor("cooldown_reduction")
	self.item_cooldown_reduction = self:GetAbility():GetSpecialValueFor("item_cooldown_reduction")
end

function modifier_dazzle_good_juju_lua:OnRefresh()
	self.cooldown_reduction = self:GetAbility():GetSpecialValueFor("cooldown_reduction")
	self.item_cooldown_reduction = self:GetAbility():GetSpecialValueFor("item_cooldown_reduction")
end

function modifier_dazzle_good_juju_lua:CanHaveReducedCooldown(ability)
	return ability 
		and not ability:IsItem()
		and not ability:IsToggle() 
		and not self.restricted_abilities[ability:GetAbilityName()]
end

function modifier_dazzle_good_juju_lua:OnAbilityFullyCast(event)
	local caster = self:GetCaster()
	local mod_ability = self:GetAbility()

	if caster ~= event.unit then return end
	if not event.ability.charge_modifier and event.ability:GetEffectiveCooldown(-1) <= self.cooldown_reduction then return end
	if event.ability:IsItem() then return end

	for i = 0, DOTA_MAX_ABILITIES - 1 do
		local ability = caster:GetAbilityByIndex(i)

		if ability and ability ~= event.ability and self:CanHaveReducedCooldown(ability) then
			ability:ReduceCooldown(self.cooldown_reduction)
		end
	end
end

function modifier_dazzle_good_juju_lua:GetModifierPercentageCooldown(params)
	local caster = self:GetCaster()
	local ability = self:GetAbility()

	if not params.ability or not caster:HasScepter() then return end

	if params.ability and params.ability:IsItem() then
		return self.item_cooldown_reduction
	end
end

