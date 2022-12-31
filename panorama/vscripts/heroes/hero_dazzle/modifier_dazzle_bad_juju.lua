---@class modifier_dazzle_bad_juju_lua:CDOTA_Modifier_Lua
modifier_dazzle_bad_juju_lua = class({})

function modifier_dazzle_bad_juju_lua:IsHidden() return true end
function modifier_dazzle_bad_juju_lua:IsPurgable() return false end
function modifier_dazzle_bad_juju_lua:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_dazzle_bad_juju_lua:DeclareFunctions() 
	return {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED
	}
end

function modifier_dazzle_bad_juju_lua:OnAbilityExecuted(event)
	local parent = self:GetParent()
	local cast_ability = event.ability

	if parent:IsIllusion() then return end
	if not cast_ability or event.unit ~= parent or cast_ability:IsItem() then return end

	local level = cast_ability:GetLevel()
	local cooldown = cast_ability:GetCooldown(level)
	local manacost = cast_ability:GetManaCost(level)

	if (cooldown == 0 or (cooldown < 2 and manacost == 0) or cast_ability:IsToggle()) then return end

	local ability = self:GetAbility()
	local duration = ability:GetSpecialValueFor("duration")
	local radius = ability:GetSpecialValueFor("radius")
	local location = parent:GetAbsOrigin()

	local targets = FindUnitsInRadius(parent:GetTeam(), 
		location, 
		nil, 
		radius, 
		DOTA_UNIT_TARGET_TEAM_BOTH,
		DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		true
	)

	for _, unit in pairs(targets) do
		unit:AddNewModifier(parent, ability, "modifier_dazzle_bad_juju_armor_lua", { duration = duration })
		EmitSoundOn("Hero_Dazzle.BadJuJu.Target", unit)
	end
end
