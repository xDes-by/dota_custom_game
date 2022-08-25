ability_npc_boss_plague_squirrel_spell3 = class({})

LinkLuaModifier( "modifier_ability_npc_boss_plague_squirrel_spell3", "abilities/bosses/plague_squirrel/ability_npc_boss_plague_squirrel_spell3", LUA_MODIFIER_MOTION_NONE )

function ability_npc_boss_plague_squirrel_spell3:OnSpellStart()
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_ability_npc_boss_plague_squirrel_spell3", {duration = self:GetSpecialValueFor("duration")})
end

modifier_ability_npc_boss_plague_squirrel_spell3 = class({})
--Classifications template
function modifier_ability_npc_boss_plague_squirrel_spell3:IsHidden()
    return false
end

function modifier_ability_npc_boss_plague_squirrel_spell3:IsDebuff()
    return false
end

function modifier_ability_npc_boss_plague_squirrel_spell3:IsPurgable()
    return false
end

function modifier_ability_npc_boss_plague_squirrel_spell3:RemoveOnDeath()
    return true
end

function modifier_ability_npc_boss_plague_squirrel_spell3:DestroyOnExpire()
    return true
end

function modifier_ability_npc_boss_plague_squirrel_spell3:OnCreated()
	self.effect_cast = ParticleManager:CreateParticle( "particles/econ/items/hoodwink/hood_2021_blossom/hood_2021_blossom_scurry_passive.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
    EmitSoundOn("Hero_Hoodwink.Scurry.Cast", self:GetCaster())
    if IsClient() then
        return
    end
    self.startPos = self:GetParent():GetAbsOrigin()
    self.startPos.z = 0
    self.range = 0
    self.move_range = self:GetAbility():GetSpecialValueFor("move_range")
    self.persent_from_target_healt = self:GetAbility():GetSpecialValueFor("persent_from_target_healt") * 0.01
    self.damage_range = self:GetAbility():GetSpecialValueFor("damage_range")
    self.damage = self:GetAbility():GetSpecialValueFor("damage")
    self.dt = DAMAGE_TYPE_MAGICAL
    self:StartIntervalThink(0.03)
end

function modifier_ability_npc_boss_plague_squirrel_spell3:OnDestroy()
    if IsClient() then
        return
    end
	ParticleManager:DestroyParticle( self.effect_cast, false )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )
    EmitSoundOn("Hero_Hoodwink.Scurry.End", self:GetCaster())
end

function modifier_ability_npc_boss_plague_squirrel_spell3:OnIntervalThink()
    self.endPos = self:GetParent():GetAbsOrigin()
    self.endPos.z = 0
    local curRange = (self.startPos - self.endPos):Length2D() + self.range
    if curRange > self.move_range then
        self.startPos = self.endPos
        local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
        for _,enemy in pairs(enemies) do
	        ApplyDamage({victim = enemy, 
            attacker = self:GetParent(), 
            damage = self.persent_from_target_healt * enemy:GetHealth(), 
            damage_type = self.dt,
            damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
            
	        ApplyDamage({victim = enemy, 
            attacker = self:GetParent(), 
            damage = self.damage, 
            damage_type = self.dt,
            damage_flags = DOTA_DAMAGE_FLAG_NONE})
        end
        self.range = 0
        local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_primal_beast/primal_beast_trample.vpcf", PATTACH_ABSORIGIN, self:GetParent() )
        ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.damage_range, 0, 0 ) )
        ParticleManager:ReleaseParticleIndex( effect_cast )
        EmitSoundOn( "Hero_PrimalBeast.Trample", self:GetParent() )
    else
        self.range = curRange + self.range
    end
end

function modifier_ability_npc_boss_plague_squirrel_spell3:GetEffectName()
	return "particles/econ/items/hoodwink/hood_2021_blossom/hood_2021_blossom_scurry_aura.vpcf"
end

function modifier_ability_npc_boss_plague_squirrel_spell3:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_ability_npc_boss_plague_squirrel_spell3:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_ALLOW_PATHING_THROUGH_TREES] = true,
	}
end