
modifier_axe_enrage_cleave_lua = class({})

function modifier_axe_enrage_cleave_lua:IsHidden()
	return true
end

function modifier_axe_enrage_cleave_lua:IsPurgable()
	return false
end

function modifier_axe_enrage_cleave_lua:OnCreated( kv )
end

function modifier_axe_enrage_cleave_lua:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		
	}
	return funcs
end

function modifier_axe_enrage_cleave_lua:OnAttackLanded(keys)
	if not (
		IsServer()
		and self:GetParent() == keys.attacker
		and keys.attacker:GetTeam() ~= keys.target:GetTeam()
		and not keys.attacker:IsRangedAttacker()
	) then return end
	
	local ability = self:GetAbility()
	local damage = keys.original_damage
	local damageMod = 100
	local radius = 360
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