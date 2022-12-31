innate_sweeping_edge = class({})

LinkLuaModifier("modifier_innate_sweeping_edge", "heroes/innates/sweeping_edge", LUA_MODIFIER_MOTION_NONE)

function innate_sweeping_edge:GetIntrinsicModifierName()
	return "modifier_innate_sweeping_edge"
end

modifier_innate_sweeping_edge = class({})

function modifier_innate_sweeping_edge:IsHidden() return true end
function modifier_innate_sweeping_edge:IsDebuff() return false end
function modifier_innate_sweeping_edge:IsPurgable() return false end
function modifier_innate_sweeping_edge:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

if not IsServer() then return end

function modifier_innate_sweeping_edge:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
	}
	return funcs
end

function modifier_innate_sweeping_edge:GetModifierProcAttack_Feedback(keys)
	if keys.attacker:GetTeam() == keys.target:GetTeam() then return end
	
	local ability = self:GetAbility()
	local damage = keys.original_damage
	local damageMod = ability:GetSpecialValueFor( "cleave_amount" )
	local radius = ability:GetSpecialValueFor( "cleave_radius" )
	local particle_cast = 'particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf'
	
	damageMod = damageMod * 0.01
	damage = damage * damageMod
	
	DoCleaveAttack(
		self:GetParent(),
		keys.target,
		ability,
		damage,
		150,
		360,
		radius,
		particle_cast
	)
end
