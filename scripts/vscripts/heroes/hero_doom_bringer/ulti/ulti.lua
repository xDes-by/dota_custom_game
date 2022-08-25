doom_ulti_lua = {}

LinkLuaModifier( "doom_ulti_think_lua", 'heroes/hero_doom_bringer/ulti/ulti.lua', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "doom_ulti_burn_lua", 'heroes/hero_doom_bringer/ulti/ulti.lua', LUA_MODIFIER_MOTION_NONE )

doom_ulti_think_lua = {}

doom_ulti_burn_lua = {}

function doom_ulti_lua:OnSpellStart()

    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_other", { duration = 5 })

    self:GetCaster():AddNewModifier(self:GetCaster(), self, "doom_ulti_think_lua", { duration = 5 })

    StartAnimation(self:GetCaster(), {duration = 5, activity = ACT_DOTA_CHANNEL_ABILITY_4})

end

function doom_ulti_think_lua:RemoveOnDeath()
	return false
end

function doom_ulti_think_lua:IsHidden()
	return false
end

function doom_ulti_think_lua:IsPurgable()
	return false
end

function doom_ulti_think_lua:OnCreated()
    self.effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_dark_willow/dark_willow_shadow_realm.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(self.effect_cast,1,self:GetCaster(),PATTACH_ABSORIGIN_FOLLOW,"attach_hitloc",Vector(0,0,0), true)
    EmitSoundOn( "Hero_DoomBringer.Doom", self:GetCaster() )
end

function doom_ulti_think_lua:OnDestroy()
    ParticleManager:DestroyParticle( self.effect_cast, false )
end

function doom_ulti_think_lua:IsAura()
	return true
end

function doom_ulti_think_lua:GetAuraRadius()
	return 700
end

function doom_ulti_think_lua:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function doom_ulti_think_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function doom_ulti_think_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function doom_ulti_think_lua:GetModifierAura()
	return "doom_ulti_burn_lua"
end

function doom_ulti_burn_lua:RemoveOnDeath()
	return false
end

function doom_ulti_burn_lua:IsHidden()
	return false
end

function doom_ulti_burn_lua:IsPurgable()
	return false
end

function doom_ulti_burn_lua:OnCreated()

    local damage = (self:GetCaster():GetModifierStackCount("modifier_ability_devour_souls", self:GetCaster())) * (self:GetAbility():GetSpecialValueFor("dmg_per_soul"))

    self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self,
		damage_type = DAMAGE_TYPE_PURE, 
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL
	}
    self:StartIntervalThink(1)
    ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_liquid_fire_debuff.vpcf", PATTACH_ABSORIGIN, enemy)
end

function doom_ulti_burn_lua:OnIntervalThink()
    if IsServer() then
        ApplyDamage(self.damageTable)
    end
end