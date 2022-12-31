innate_linkens = class({})

LinkLuaModifier("modifier_innate_linkens", "heroes/innates/linkens", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_innate_linkens_cooldown", "heroes/innates/linkens", LUA_MODIFIER_MOTION_NONE)

function innate_linkens:GetIntrinsicModifierName()
	return "modifier_innate_linkens"
end

modifier_innate_linkens = class({})

function modifier_innate_linkens:IsHidden() return true end
function modifier_innate_linkens:IsDebuff() return false end
function modifier_innate_linkens:IsPurgable() return false end
function modifier_innate_linkens:GetTexture() return "innate_linkens" end
function modifier_innate_linkens:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_linkens:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ABSORB_SPELL,
	}
	return funcs
end

function modifier_innate_linkens:GetAbsorbSpell(params)
	local parent = self:GetParent()
	
	if params.ability:GetCaster():GetTeamNumber() == parent:GetTeamNumber() then
		return nil
	end

	if parent:FindModifierByName("modifier_innate_linkens_cooldown") then
		return nil
	end

	parent:EmitSound("DOTA_Item.LinkensSphere.Activate")
	
	local pfx = ParticleManager:CreateParticle("particles/items_fx/immunity_sphere.vpcf", PATTACH_POINT_FOLLOW, parent)
	ParticleManager:SetParticleControlEnt(pfx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx)
	
	local cooldown = self:GetAbility():GetLevelSpecialValueFor("cooldown", self:GetAbility():GetLevel())
	
	parent:AddNewModifier(parent, self:GetAbility(), "modifier_innate_linkens_cooldown", {duration = cooldown})
	
	return 1
end

modifier_innate_linkens_cooldown = class({})

function modifier_innate_linkens_cooldown:IsHidden() return false end
function modifier_innate_linkens_cooldown:IsDebuff() return true end
function modifier_innate_linkens_cooldown:IsPurgable() return false end
function modifier_innate_linkens_cooldown:GetTexture() return "innate_linkens" end
function modifier_innate_linkens_cooldown:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end