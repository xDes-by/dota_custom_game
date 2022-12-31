item_stat_book = item_stat_book or class({})
LinkLuaModifier("custom_modifier_book_stat_strength", "items/item_stat_book", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("custom_modifier_book_stat_agility", "items/item_stat_book", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("custom_modifier_book_stat_intelligence", "items/item_stat_book", LUA_MODIFIER_MOTION_NONE)
local colors = {
	strength = {Vector(255, 69, 0), Vector(255, 0, 0)};
	agility = {Vector(124, 252, 0), Vector(0, 252, 8)};
	intelligence = {Vector(0, 229, 230), Vector(32, 178, 170)};
}
local base_color = Vector(0, 0, 0)

function item_stat_book:OnSpellStart()
	local caster = self:GetCaster()
	if not caster then return end
	
	local ability_name = self:GetAbilityName()
	if not ability_name then return end
	
	local stat = string.match(ability_name, "item_book_of_([a-z]*)")
	local stat_bonus = self:GetSpecialValueFor("bonus_stat")
	local stat_modifier = caster:FindModifierByName("custom_modifier_book_stat_" .. stat)
	
	if not stat_modifier then
		stat_modifier = caster:AddNewModifier(caster, self, "custom_modifier_book_stat_" .. stat, { duration= -1 })
	end

	if not stat_modifier then return end

	stat_modifier:SetStackCount(stat_modifier:GetStackCount() + stat_bonus)
	caster:CalculateStatBonus(false)
	self:SpendCharge()
	caster:EmitSound("stat_book.start")

	local particle = ParticleManager:CreateParticle("particles/custom/use_book.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster);
	ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true);
	ParticleManager:SetParticleControl(particle, 2, Vector(0, 0, -30))
	ParticleManager:SetParticleControl(particle, 4, Vector(30, 0, -5))
	ParticleManager:SetParticleControl(particle, 1, colors[stat][1] or base_color)
	ParticleManager:SetParticleControl(particle, 3, colors[stat][2] or base_color)
	ParticleManager:SetParticleControl(particle, 5, Vector(75 + stat_bonus * 2, 15 + stat_bonus / 2, 300 + stat_bonus * 20))
	ParticleManager:ReleaseParticleIndex(particle)
end

item_book_of_strength = item_book_of_strength or class(item_stat_book)
item_book_of_strength_2 = item_book_of_strength_2 or class(item_stat_book)

item_book_of_agility = item_book_of_agility or class(item_stat_book)
item_book_of_agility_2 = item_book_of_agility_2 or class(item_stat_book)

item_book_of_intelligence = item_book_of_intelligence or class(item_stat_book)
item_book_of_intelligence_2 = item_book_of_intelligence_2 or class(item_stat_book)


custom_modifier_book_stat_base = custom_modifier_book_stat_base or class({})

function custom_modifier_book_stat_base:IsHidden() return false end
function custom_modifier_book_stat_base:IsPurgable() return false end
function custom_modifier_book_stat_base:IsPurgeException() return false end
function custom_modifier_book_stat_base:RemoveOnDeath() return false end
function custom_modifier_book_stat_base:AllowIllusionDuplicate() return true end
function custom_modifier_book_stat_base:IsDebuff() return false end

custom_modifier_book_stat_strength = custom_modifier_book_stat_strength or class(custom_modifier_book_stat_base)
function custom_modifier_book_stat_strength:DeclareFunctions() return { MODIFIER_PROPERTY_STATS_STRENGTH_BONUS } end
function custom_modifier_book_stat_strength:GetModifierBonusStats_Strength()
	if IsServer() and self:GetParent():IsClone() then return end
	return self:GetStackCount()
end
function custom_modifier_book_stat_strength:GetTexture() return "item_book_of_strength" end

custom_modifier_book_stat_agility = custom_modifier_book_stat_agility or class(custom_modifier_book_stat_base)
function custom_modifier_book_stat_agility:DeclareFunctions() return { MODIFIER_PROPERTY_STATS_AGILITY_BONUS } end
function custom_modifier_book_stat_agility:GetModifierBonusStats_Agility()
	if IsServer() and self:GetParent():IsClone() then return end
	return self:GetStackCount()
end
function custom_modifier_book_stat_agility:GetTexture() return "item_book_of_agility" end

custom_modifier_book_stat_intelligence = custom_modifier_book_stat_intelligence or class(custom_modifier_book_stat_base)
function custom_modifier_book_stat_intelligence:DeclareFunctions() return { MODIFIER_PROPERTY_STATS_INTELLECT_BONUS } end
function custom_modifier_book_stat_intelligence:GetModifierBonusStats_Intellect()
	if IsServer() and self:GetParent():IsClone() then return end
	return self:GetStackCount()
end
function custom_modifier_book_stat_intelligence:GetTexture() return "item_book_of_intelligence" end
