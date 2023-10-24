mega_boss_emp_lua = class({})

LinkLuaModifier( "modifier_mega_boss_emp_lua_thinker", "abilities/bosses/mega/mega_boss_emp_lua", LUA_MODIFIER_MOTION_NONE )

function mega_boss_emp_lua:OnSpellStart()
	local delay = self:GetSpecialValueFor("delay")
	CreateModifierThinker(self:GetCaster(), self, "modifier_mega_boss_emp_lua_thinker", {duration = delay}, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)
	EmitSoundOn( "Hero_Invoker.EMP.Cast", self:GetCaster() )
end

modifier_mega_boss_emp_lua_thinker = class({})

function modifier_mega_boss_emp_lua_thinker:IsHidden()
	return true
end

function modifier_mega_boss_emp_lua_thinker:IsPurgable()
	return false
end

function modifier_mega_boss_emp_lua_thinker:OnCreated( kv )
    if not IsServer() then
        return
    end
    self.radius = self:GetAbility():GetSpecialValueFor("area_of_effect")
    self.damage_pct = self:GetAbility():GetSpecialValueFor("damage_per_mana_pct")/100

	self.effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_invoker/invoker_emp.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius, 0, 0 ) )
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "Hero_Invoker.EMP.Charge", self:GetCaster() )
end

function modifier_mega_boss_emp_lua_thinker:OnDestroy( kv )
    if not IsServer() then
        return
    end
    local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MANA_ONLY, 0, false)
    for _,u in pairs(enemies) do
        enemy:Script_ReduceMana( u:GetMana() * self.damage_pct, self:GetAbility() )
        ApplyDamage({
            victim = u,
            attacker = self:GetCaster(),
            damage = u:GetMana() * self.damage_pct,
            damage_type = DAMAGE_TYPE_MAGICAL,
            damage_flags = 0,
            ability = self:GetAbility()
        })
    end

    ParticleManager:DestroyParticle( self.effect_cast, false )
    ParticleManager:ReleaseParticleIndex( self.effect_cast )
    EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "Hero_Invoker.EMP.Discharge", self:GetCaster() )
    UTIL_Remove( self:GetParent() )
end