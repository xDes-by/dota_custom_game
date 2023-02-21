modifier_axe_enrage_all_damage_lua_from_int_last = class({})

function modifier_axe_enrage_all_damage_lua_from_int_last:IsHidden()
	return false
end

function modifier_axe_enrage_all_damage_lua_from_int_last:IsDebuff()
	return false
end

function modifier_axe_enrage_all_damage_lua_from_int_last:IsPurgable()
	return false
end

function modifier_axe_enrage_all_damage_lua_from_int_last:OnCreated( kv )
	self.caster = self:GetCaster()
end

function modifier_axe_enrage_all_damage_lua_from_int_last:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
    return funcs
end

function modifier_axe_enrage_all_damage_lua_from_int_last:OnAttackLanded(params)
    if IsServer() then
		
        local target = params.target
		
		if target == nil then
			target = params.unit
		end
		
        if target:GetTeamNumber()==self:GetParent():GetTeamNumber() then return end

        local parent = self:GetParent()
        ApplyDamage({
				victim = target,
				attacker = parent,
				damage = params.damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
				ability = self:GetAbility()
			})
    end
end