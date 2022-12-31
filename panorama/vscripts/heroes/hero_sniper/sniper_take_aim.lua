---@class sniper_take_aim_lua:CDOTA_Ability_Lua
sniper_take_aim_lua = class({})
LinkLuaModifier("modifier_sniper_take_aim_lua", "heroes/hero_sniper/sniper_take_aim", LUA_MODIFIER_MOTION_NONE)

function sniper_take_aim_lua:GetIntrinsicModifierName()
	return "modifier_sniper_take_aim_lua"
end

function sniper_take_aim_lua:OnSpellStart()
	local caster = self:GetCaster()
	caster:AddNewModifier(caster, self, "modifier_sniper_take_aim_bonus", { duration = self:GetSpecialValueFor("duration") })
end

---@class modifier_sniper_take_aim_lua:CDOTA_Modifier_Lua
modifier_sniper_take_aim_lua = class({})

function modifier_sniper_take_aim_lua:IsHidden() return true end
function modifier_sniper_take_aim_lua:IsPurgable() return false end
function modifier_sniper_take_aim_lua:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_sniper_take_aim_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	}
end

function modifier_sniper_take_aim_lua:OnCreated()
	 self.bonus_cast_range = self:GetAbility():GetSpecialValueFor("bonus_attack_range")
end

modifier_sniper_take_aim_lua.OnRefresh = modifier_sniper_take_aim_lua.OnCreated

function modifier_sniper_take_aim_lua:GetModifierAttackRangeBonus()
	return self.bonus_cast_range
end
