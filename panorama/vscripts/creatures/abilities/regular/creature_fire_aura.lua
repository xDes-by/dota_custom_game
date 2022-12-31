LinkLuaModifier("modifier_creature_fire_aura", "creatures/abilities/regular/creature_fire_aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_fire_aura_debuff", "creatures/abilities/regular/creature_fire_aura", LUA_MODIFIER_MOTION_NONE)

creature_fire_aura = class({})

function creature_fire_aura:GetIntrinsicModifierName()
	return "modifier_creature_fire_aura"
end



modifier_creature_fire_aura = class({})

function modifier_creature_fire_aura:IsHidden() return true end
function modifier_creature_fire_aura:IsDebuff() return false end
function modifier_creature_fire_aura:IsPurgable() return false end
function modifier_creature_fire_aura:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creature_fire_aura:IsAura() return true end
function modifier_creature_fire_aura:GetAuraRadius() return 600 end
function modifier_creature_fire_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_creature_fire_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_creature_fire_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_creature_fire_aura:GetModifierAura() return "modifier_creature_fire_aura_debuff" end

function modifier_creature_fire_aura:GetEffectName()
	return "particles/creature/fire_aura.vpcf"
end

function modifier_creature_fire_aura:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_creature_fire_aura:OnCreated()
	self:OnRefresh()
end

function modifier_creature_fire_aura:OnRefresh()
	if IsClient() then return end

	self.dps = self:GetAbility():GetSpecialValueFor("dps")
	self:StartIntervalThink(1.0)
end

function modifier_creature_fire_aura:OnIntervalThink()
	local parent = self:GetParent()

	if (not parent) or parent:IsNull() then return end

	ApplyDamage({victim = parent, attacker = parent, damage = self.dps, damage_type = DAMAGE_TYPE_MAGICAL})
end



modifier_creature_fire_aura_debuff = class({})

function modifier_creature_fire_aura_debuff:IsHidden() return false end
function modifier_creature_fire_aura_debuff:IsDebuff() return true end
function modifier_creature_fire_aura_debuff:IsPurgable() return false end

function modifier_creature_fire_aura_debuff:OnCreated()
	if IsClient() then return end

	self.dps = self:GetAbility():GetSpecialValueFor("dps")
	self:StartIntervalThink(1.0)
end

function modifier_creature_fire_aura_debuff:OnIntervalThink()
	local parent = self:GetParent()
	local caster = self:GetCaster()

	if (not parent) or (not caster) or (parent:IsNull() or caster:IsNull()) or parent:IsMagicImmune() then return end

	ApplyDamage({victim = parent, attacker = caster, damage = self.dps, damage_type = DAMAGE_TYPE_MAGICAL})
end
