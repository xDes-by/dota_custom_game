innate_unrelenting = class({})

LinkLuaModifier("modifier_innate_unrelenting", "heroes/innates/unrelenting", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_innate_unrelenting_invulnerability", "heroes/innates/unrelenting", LUA_MODIFIER_MOTION_NONE)

function innate_unrelenting:GetIntrinsicModifierName()
	return "modifier_innate_unrelenting"
end

modifier_innate_unrelenting = class({})

function modifier_innate_unrelenting:IsHidden() return true end
function modifier_innate_unrelenting:IsDebuff() return false end
function modifier_innate_unrelenting:IsPurgable() return false end
function modifier_innate_unrelenting:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_unrelenting:DeclareFunctions()
	return { 
		MODIFIER_EVENT_ON_DEATH 
	}
end

function modifier_innate_unrelenting:OnDeath(keys)
	if keys.attacker ~= self:GetParent() then return end

	local caster = self:GetParent()
	local ability = self:GetAbility()
	if (not caster or caster:IsNull()) or (not ability or ability:IsNull()) then return end
	if not keys.unit or keys.unit:IsIllusion() then return end

	local duration = ability:GetSpecialValueFor("damage_immunity")

	caster:AddNewModifier(caster, ability, "modifier_innate_unrelenting_invulnerability", {duration = 2})
end

modifier_innate_unrelenting_invulnerability = class({})

function modifier_innate_unrelenting_invulnerability:OnCreated()
	if IsServer() then
		self:GetParent():EmitSound("Unrelenting.Immunity")
	end
end

function modifier_innate_unrelenting_invulnerability:OnDestroy()
	if IsServer() then
		self:GetParent():EmitSound("Unrelenting.Immunity_Destroy")
	end
end

function modifier_innate_unrelenting_invulnerability:GetEffectName()
	return "particles/custom/innates/unrelenting_buff.vpcf"
end

function modifier_innate_unrelenting_invulnerability:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_innate_unrelenting_invulnerability:DeclareFunctions()
	if IsServer() then return {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
	} end
end

function modifier_innate_unrelenting_invulnerability:GetAbsoluteNoDamagePhysical() return 1 end
function modifier_innate_unrelenting_invulnerability:GetAbsoluteNoDamageMagical() return 1 end
function modifier_innate_unrelenting_invulnerability:GetAbsoluteNoDamagePure() return 1 end
