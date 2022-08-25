ability_npc_boss_location8_spell1 = class({})

LinkLuaModifier( "modifier_ability_npc_boss_location8_spell1", "abilities/bosses/location8/ability_npc_boss_location8_spell1", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_npc_boss_location8_animation", "abilities/bosses/location8/ability_npc_boss_location8_spell1", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_npc_boss_location8_spell1_debuff", "abilities/bosses/location8/ability_npc_boss_location8_spell1", LUA_MODIFIER_MOTION_NONE )

function ability_npc_boss_location8_spell1:Precache(context)
    PrecacheResource( "particle", "particles/units/heroes/hero_snapfire/hero_snapfire_shells_buff.vpcf", context )
end

function ability_npc_boss_location8_spell1:GetIntrinsicModifierName()
    return "modifier_npc_boss_location8_animation"
end

function ability_npc_boss_location8_spell1:OnSpellStart()
    self.duration = self:GetSpecialValueFor("debuff_duration")
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_ability_npc_boss_location8_spell1", {duration = self:GetSpecialValueFor("duration")})
end

function ability_npc_boss_location8_spell1:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
    ApplyDamage({victim = hTarget,
    damage = self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster()),
    damage_type = DAMAGE_TYPE_PHYSICAL,
    damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL,
    attacker = self:GetCaster(),
    ability = self})
    hTarget:AddNewModifier(self:GetCaster(), self, "modifier_ability_npc_boss_location8_spell1_debuff", {duration = self.duration})
    EmitSoundOn( "Hero_Snapfire.ExplosiveShellsBuff.Target", hTarget )
end

modifier_ability_npc_boss_location8_spell1 = class({})
function modifier_ability_npc_boss_location8_spell1:IsHidden()
    return false
end

function modifier_ability_npc_boss_location8_spell1:IsDebuff()
    return false
end

function modifier_ability_npc_boss_location8_spell1:IsPurgable()
    return false
end

function modifier_ability_npc_boss_location8_spell1:RemoveOnDeath()
    return true
end

function modifier_ability_npc_boss_location8_spell1:DestroyOnExpire()
    return true
end

function modifier_ability_npc_boss_location8_spell1:OnCreated()
    self:SetStackCount(self:GetAbility():GetSpecialValueFor("buffed_attacks"))
    self.duration = self:GetAbility():GetSpecialValueFor("debuff_duration")
    self.attack_speed_bonus = self:GetAbility():GetSpecialValueFor("attack_speed_bonus")
    self.attack_range_bonus = self:GetAbility():GetSpecialValueFor("attack_range_bonus")
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_snapfire/hero_snapfire_shells_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	self:AddParticle(effect_cast,false,false,-1,false,false)
end

function modifier_ability_npc_boss_location8_spell1:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PROJECTILE_NAME,
        MODIFIER_PROPERTY_IGNORE_ATTACKSPEED_LIMIT,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
        MODIFIER_EVENT_ON_ATTACK,
        MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
    }
end

function modifier_ability_npc_boss_location8_spell1:GetModifierProjectileName()
	return "particles/units/heroes/hero_snapfire/hero_snapfire_shells_projectile.vpcf"
end

function modifier_ability_npc_boss_location8_spell1:GetModifierAttackSpeed_Limit()
	return 1
end

function modifier_ability_npc_boss_location8_spell1:GetModifierAttackRangeBonus()
	return self.attack_range_bonus 
end

function modifier_ability_npc_boss_location8_spell1:GetModifierAttackSpeedBonus_Constant()
    return self.attack_speed_bonus
end

function modifier_ability_npc_boss_location8_spell1:OnAttack( data )
	if data.attacker ~= self:GetParent() then 
        return 
    end
    if self:GetStackCount() ~= 0 then
        self:DecrementStackCount()
        EmitSoundOn( "Hero_Snapfire.ExplosiveShellsBuff.Attack", self:GetParent() )
        local enemies = FindUnitsInRadius(data.attacker:GetTeamNumber(), data.attacker:GetAbsOrigin(), nil, self:GetParent():Script_GetAttackRange(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
        for _,unit in ipairs(enemies) do
            if unit ~= data.target then
                ProjectileManager:CreateTrackingProjectile({
                    Target = unit,
                    Source = data.attacker,
                    Ability = self:GetAbility(),	
                    EffectName = "particles/units/heroes/hero_snapfire/hero_snapfire_shells_projectile.vpcf",
                    iMoveSpeed = 1800,
                    iSourceAttachment = 1
                })
            end
        end
    end
end

function modifier_ability_npc_boss_location8_spell1:GetModifierProcAttack_Feedback( data )
    data.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_ability_npc_boss_location8_spell1_debuff", {duration = self.duration})
    EmitSoundOn( "Hero_Snapfire.ExplosiveShellsBuff.Target", data.target )
    if self:GetStackCount() == 0 then
        self:Destroy()
    end
end

modifier_ability_npc_boss_location8_spell1_debuff = class({})
--Classifications template
function modifier_ability_npc_boss_location8_spell1_debuff:IsHidden()
    return false
end

function modifier_ability_npc_boss_location8_spell1_debuff:IsDebuff()
    return true
end

function modifier_ability_npc_boss_location8_spell1_debuff:IsPurgable()
    return false
end

function modifier_ability_npc_boss_location8_spell1_debuff:RemoveOnDeath()
    return true
end

function modifier_ability_npc_boss_location8_spell1_debuff:DestroyOnExpire()
    return true
end

function modifier_ability_npc_boss_location8_spell1_debuff:OnCreated()
    self.amor = -self:GetAbility():GetSpecialValueFor("armor")
    self:SetStackCount(1)
end

function modifier_ability_npc_boss_location8_spell1_debuff:OnRefresh()
    if IsClient() then
        return
    end
    self:IncrementStackCount()
end

function modifier_ability_npc_boss_location8_spell1_debuff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
end

function modifier_ability_npc_boss_location8_spell1_debuff:GetModifierPhysicalArmorBonus()
    return self:GetStackCount() * self.amor
end

modifier_npc_boss_location8_animation = class({})

function modifier_npc_boss_location8_animation:IsHidden()
    return true
end

function modifier_npc_boss_location8_animation:IsPurgable()
    return true
end

function modifier_npc_boss_location8_animation:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }
end

function modifier_npc_boss_location8_animation:GetActivityTranslationModifiers()
    return "run"
end
