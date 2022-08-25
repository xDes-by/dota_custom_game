modifier_don10 = class({})

function modifier_don10:IsHidden()
	return true
end

function modifier_don10:IsPurgable()
	return false
end

function modifier_don10:RemoveOnDeath()
	return false
end

function modifier_don10:OnCreated( kv )
end


function modifier_don10:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

if IsServer() then
	function modifier_don10:OnAttackLanded(keys)
		local attacker = keys.attacker
		if attacker ~= self:GetParent() then return end
		local ability = self:GetAbility()
		local damage = attacker:GetAttackDamage()
		local target = keys.target
			ApplyDamage({
				victim = target,
				attacker = attacker,
				damage = damage * 0.05,
				damage_type = DAMAGE_TYPE_PURE,
				damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
			})
	end
end