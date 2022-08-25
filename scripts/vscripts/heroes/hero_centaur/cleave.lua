npc_dota_hero_centaur_agi11 = class({})
LinkLuaModifier( "modifier_centaur_cleave", "heroes/hero_centaur/cleave", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function npc_dota_hero_centaur_agi11:GetIntrinsicModifierName()
	return "modifier_centaur_cleave"
end

-------------------------------------------
-------------------------------------------

modifier_centaur_cleave = class({})

function modifier_centaur_cleave:IsHidden()
	return true
end

function modifier_centaur_cleave:IsPurgable()
	return false
end

function modifier_centaur_cleave:OnCreated( kv )
end

function modifier_centaur_cleave:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		
	}
	return funcs
end

function modifier_centaur_cleave:OnAttackLanded(keys)
	if not (
		IsServer()
		and self:GetParent() == keys.attacker
		and keys.attacker:GetTeam() ~= keys.target:GetTeam()
		and not keys.attacker:IsRangedAttacker()
	) then return end
	
	local ability = self:GetAbility()
	local damage = keys.original_damage
	local damageMod = 50
	local radius = 300
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