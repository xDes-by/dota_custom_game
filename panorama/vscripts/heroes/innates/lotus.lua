innate_lotus = class({})

LinkLuaModifier("modifier_innate_lotus", "heroes/innates/lotus", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_innate_lotus_cooldown", "heroes/innates/lotus", LUA_MODIFIER_MOTION_NONE)

function innate_lotus:GetIntrinsicModifierName()
	return "modifier_innate_lotus"
end

modifier_innate_lotus = class({})

function modifier_innate_lotus:IsHidden() return true end
function modifier_innate_lotus:IsDebuff() return false end
function modifier_innate_lotus:IsPurgable() return false end
function modifier_innate_lotus:GetTexture() return "innate_lotus" end
function modifier_innate_lotus:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_lotus:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_REFLECT_SPELL,
	}
	return funcs
end

function modifier_innate_lotus:OnCreated()	
	self:GetParent().tOldSpells = {}

	self:StartIntervalThink(0.2)
end

function modifier_innate_lotus:OnIntervalThink()
	local old_spells = self:GetParent().tOldSpells
	for i = #old_spells, 1, -1 do
		local hSpell = old_spells[i]

		if not hSpell or hSpell:IsNull() then
			table.remove(old_spells, i)
		elseif hSpell:NumModifiersUsingAbility() == 0 and not hSpell:IsChanneling() then
			hSpell:RemoveSelf()
			table.remove(self:GetParent().tOldSpells,i)
		end
	end
end

function modifier_innate_lotus:GetReflectSpell(params)

	local reflected_spell_name = params.ability:GetAbilityName()
	local target = params.ability:GetCaster()
	local parent = self:GetParent()
	local ability = nil

	if parent:FindModifierByName("modifier_innate_lotus_cooldown") then
		return 0
	end

	if target:GetTeamNumber() == parent:GetTeamNumber() then
		return 0
	end

	if params.ability.spell_shield_reflect then
		return 0
	end

	local cooldown = self:GetAbility():GetLevelSpecialValueFor("cooldown", self:GetAbility():GetLevel())
	parent:AddNewModifier(parent, self:GetAbility(), "modifier_innate_lotus_cooldown", {duration = cooldown})

	local old_spell = false

	for _,hSpell in pairs(parent.tOldSpells) do
		if hSpell ~= nil and hSpell:GetAbilityName() == reflected_spell_name then
			old_spell = true
			break
		end
	end

	if old_spell then
		ability = parent:FindAbilityByName(reflected_spell_name)
	else
		ability = parent:AddAbility(reflected_spell_name)
		ability:SetStolen(true)
		ability:SetHidden(true)
		
		ability.spell_shield_reflect = true
		
		ability:SetRefCountsModifiers(true)
		table.insert(parent.tOldSpells, ability)
	end

	ability:SetLevel(params.ability:GetLevel())
	parent:SetCursorCastTarget(target)
	ability:OnSpellStart()
	
	if ability.OnChannelFinish then
		ability:OnChannelFinish(false)
	end	
	
	self:GetCaster():EmitSound("Item.LotusOrb.Activate")
	local pfx = ParticleManager:CreateParticle("particles/econ/items/crystal_maiden/ti9_immortal_staff/cm_ti9_golden_staff_lvlup_globe_spawn.vpcf", PATTACH_POINT_FOLLOW, parent)
	ParticleManager:SetParticleControlEnt(pfx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx)
	
	return 1
end

modifier_innate_lotus_cooldown = class({})

function modifier_innate_lotus_cooldown:IsHidden() return false end
function modifier_innate_lotus_cooldown:IsDebuff() return true end
function modifier_innate_lotus_cooldown:IsPurgable() return false end
function modifier_innate_lotus_cooldown:GetTexture() return "innate_lotus" end
function modifier_innate_lotus_cooldown:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
