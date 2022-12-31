obsidian_destroyer_equilibrium = class({})
LinkLuaModifier("modifier_obsidian_destroyer_equilibrium_lua", "heroes/hero_obsidian_destroyer/obsidian_destroyer_equilibrium", LUA_MODIFIER_MOTION_NONE)

function obsidian_destroyer_equilibrium:GetIntrinsicModifierName()
	return "modifier_obsidian_destroyer_equilibrium_lua"
end

modifier_obsidian_destroyer_equilibrium_lua = class({})

modifier_obsidian_destroyer_equilibrium_lua.exceptions = {
	obsidian_destroyer_arcane_orb = true,
}

function modifier_obsidian_destroyer_equilibrium_lua:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_obsidian_destroyer_equilibrium_lua:IsHidden() return true end
function modifier_obsidian_destroyer_equilibrium_lua:IsPurgable() return true end

function modifier_obsidian_destroyer_equilibrium_lua:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED
	}
end

function modifier_obsidian_destroyer_equilibrium_lua:OnAbilityExecuted(event)
	local parent = self:GetParent()

    local cast_ability = event.ability

    if not cast_ability or event.unit ~= parent or cast_ability:IsItem() then return end
	
	if parent:PassivesDisabled() then return end

    local level = cast_ability:GetLevel()

    local cooldown = cast_ability:GetCooldown(level)
    local manacost = cast_ability:GetManaCost(level)

    if (cooldown == 0 or (cooldown < 2 and manacost == 0) or cast_ability:IsToggle()) and not self.exceptions[cast_ability:GetAbilityName()] then return end
	
	local ability = self:GetAbility()
	local proc_chance = ability:GetSpecialValueFor("proc_chance")

	if RollPseudoRandomPercentage(proc_chance, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_2, parent) then
		local mana = parent:GetMaxMana() * ability:GetSpecialValueFor("mana_restore") * 0.01
		parent:GiveMana(mana)

		ParticleManager:CreateParticle("particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_essence_effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
	end
end
