---@class pangolier_lucky_shot:CDOTA_Ability_Lua
pangolier_lucky_shot = class({})
LinkLuaModifier("modifier_pangolier_lucky_shot_lua", "heroes/hero_pangolier/pangolier_lucky_shot", LUA_MODIFIER_MOTION_NONE)

local proc_abilities = {
	pangolier_swashbuckle = true,
	pangolier_shield_crash = true,
	pangolier_heartpiercer = true,
	pangolier_gyroshell = true,
	pangolier_rollup = true,
}

function pangolier_lucky_shot:GetIntrinsicModifierName()
	return "modifier_pangolier_lucky_shot_lua"
end

---@class modifier_pangolier_lucky_shot_lua:CDOTA_Modifier_Lua
modifier_pangolier_lucky_shot_lua = class({})

function modifier_pangolier_lucky_shot_lua:IsHidden() return true end
function modifier_pangolier_lucky_shot_lua:IsPurgable() return false end
function modifier_pangolier_lucky_shot_lua:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_pangolier_lucky_shot_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
	}
end

function modifier_pangolier_lucky_shot_lua:OnCreated()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
end

function modifier_pangolier_lucky_shot_lua:GetModifierTotalDamageOutgoing_Percentage(params)
	if self.parent:PassivesDisabled() or self.parent:IsIllusion() then return end

	if params.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK 
	or params.inflictor and proc_abilities[params.inflictor:GetAbilityName()] then
		local chance = self.ability:GetSpecialValueFor("chance_pct")
		
		if not params.target:IsMagicImmune() and RollPseudoRandomPercentage(chance, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_3, self.parent) then
			local duration = params.target:ApplyStatusResistance(self.ability:GetSpecialValueFor("duration"))
			params.target:AddNewModifier(self.parent, self.ability, "modifier_pangolier_luckyshot_disarm", { duration = duration })
		end
	end
end
