modifier_charge_controller = class({})

function modifier_charge_controller:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED
	}
end

function modifier_charge_controller:IsHidden()
	return true
end

function modifier_charge_controller:RemoveOnDeath( ... )
	return false
end

function modifier_charge_controller:IsPurgable()
	return false
end

refresher_type_abilities = {
	["item_refresher"] = 1,
	['item_refresher_shard'] = 1,
	["rattletrap_overclocking"] = 1,
}

function modifier_charge_controller:OnAbilityExecuted(params)
	if not IsServer() then return end

	local parent = self:GetParent()

	local ability = params.ability
	local caster = ability:GetCaster()
	local target = ability:GetCursorTarget()

	if not ability then return end
	if not caster then return end

	local ability_name = ability:GetName()

	if target == parent and ability_name == "keeper_of_the_light_chakra_magic" then
		ErrorTracking.Try(AbilityCharges.ReduceChargesCooldown, AbilityCharges, parent, ability:GetSpecialValueFor("cooldown_reduction"))
	end

	if caster ~= parent then return end


	if ability.charge_modifier then
		ErrorTracking.Try(AbilityCharges.OnAbilityExecuted, AbilityCharges, ability)
	end

	if refresher_type_abilities[ability_name] then
		ErrorTracking.Try(AbilityCharges.RefreshCharges, AbilityCharges, caster)
	end
end
