LinkLuaModifier("modifier_creature_acid_aura", "creatures/abilities/regular/creature_acid_aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_acid_aura_debuff", "creatures/abilities/regular/creature_acid_aura", LUA_MODIFIER_MOTION_NONE)

creature_acid_aura = class({})

function creature_acid_aura:GetIntrinsicModifierName()
	return "modifier_creature_acid_aura"
end



modifier_creature_acid_aura = class({})

function modifier_creature_acid_aura:IsHidden() return true end
function modifier_creature_acid_aura:IsDebuff() return false end
function modifier_creature_acid_aura:IsPurgable() return false end
function modifier_creature_acid_aura:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creature_acid_aura:IsAura() return true end
function modifier_creature_acid_aura:GetAuraRadius() return 1200 end
function modifier_creature_acid_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_creature_acid_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_creature_acid_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_creature_acid_aura:GetModifierAura() return "modifier_creature_acid_aura_debuff" end

function modifier_creature_acid_aura:GetEffectName()
	return "particles/creature/acid_aura.vpcf"
end

function modifier_creature_acid_aura:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end



modifier_creature_acid_aura_debuff = class({})

function modifier_creature_acid_aura_debuff:IsHidden() return false end
function modifier_creature_acid_aura_debuff:IsDebuff() return true end
function modifier_creature_acid_aura_debuff:IsPurgable() return false end

function modifier_creature_acid_aura_debuff:OnCreated()
	self.armor = self:GetAbility():GetSpecialValueFor("armor")

	if IsClient() then return end

	self.dps = 0.01 * self:GetAbility():GetSpecialValueFor("dps")
	self:StartIntervalThink(1.0)
end

function modifier_creature_acid_aura_debuff:OnIntervalThink()
	local parent = self:GetParent()
	local caster = self:GetCaster()

	if not parent or not caster or (parent:IsNull() or caster:IsNull()) or parent:IsMagicImmune() then return end

	local damage = self.dps * parent:GetHealth()
	ApplyDamage({victim = parent, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL})
end

function modifier_creature_acid_aura_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end

function modifier_creature_acid_aura_debuff:GetModifierPhysicalArmorBonus()
	return self.armor
end
