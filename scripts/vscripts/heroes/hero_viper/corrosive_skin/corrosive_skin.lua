LinkLuaModifier( "modifier_viper_corrosive_skin_lua", "heroes/hero_viper/corrosive_skin/corrosive_skin.lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_viper_corrosive_skin_lua_slow", "heroes/hero_viper/corrosive_skin/corrosive_skin.lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_viper_corrosive_skin_lua_cd", "heroes/hero_viper/corrosive_skin/corrosive_skin.lua" ,LUA_MODIFIER_MOTION_NONE )

if viper_corrosive_skin_lua == nil then
    viper_corrosive_skin_lua = class({})
end

--------------------------------------------------------------------------------

function viper_corrosive_skin_lua:GetIntrinsicModifierName()
    return "modifier_viper_corrosive_skin_lua"
end

function viper_corrosive_skin_lua:GetCastRange(vLocation, hTarget)
    if self:GetCaster():FindAbilityByName("npc_dota_hero_viper_str8") then
        return self:GetSpecialValueFor("max_range_tooltip") * 2
    end
end

function viper_corrosive_skin_lua:GetBehavior()
    if self:GetCaster():FindAbilityByName("npc_dota_hero_viper_agi8") then
        return DOTA_ABILITY_BEHAVIOR_NO_TARGET
    end
end

function viper_corrosive_skin_lua:GetManaCost()
    if self:GetCaster():FindAbilityByName("npc_dota_hero_viper_agi8") then
        return 100 + math.min(65000, self:GetCaster():GetIntellect()/100)
    end
end

function viper_corrosive_skin_lua:GetCooldown()
    if self:GetCaster():FindAbilityByName("npc_dota_hero_viper_agi8") then
        return 40
    end
end

function viper_corrosive_skin_lua:OnSpellStart()
    local radius = self:GetSpecialValueFor("max_range_tooltip")
    if self:GetCaster():FindAbilityByName("npc_dota_hero_viper_agi8") then
        radius = radius * 2
    end
    local stack = 0
    if self:GetCaster():FindAbilityByName("npc_dota_hero_viper_str_last") then
        stack = 5
    end
    local duration = self:GetSpecialValueFor("duration")
    local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, 0, false)
    for _,enemy in pairs(enemies) do
        local modifier = enemy:AddNewModifier(self:GetCaster(), self, "modifier_viper_corrosive_skin_lua_slow", {duration = duration})
        modifier:SetStackCount(stack)
    end
end

--------------------------------------------------------------------------------


modifier_viper_corrosive_skin_lua = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsPurgeException        = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self)
        return {
            MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
            MODIFIER_EVENT_ON_TAKEDAMAGE,
            MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_UNIQUE,
        }
    end,
})


--------------------------------------------------------------------------------

function modifier_viper_corrosive_skin_lua:OnCreated()
    self.bonus_magic_resistance = self:GetAbility():GetSpecialValueFor("bonus_magic_resistance")
    self.duration = self:GetAbility():GetSpecialValueFor("duration")
    self.max_range_tooltip = self:GetAbility():GetSpecialValueFor("max_range_tooltip")
    if self:GetCaster():FindAbilityByName("npc_dota_hero_viper_str8") then
        self.max_range_tooltip = self.max_range_tooltip * 2
    end
    self.as = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

function modifier_viper_corrosive_skin_lua:OnRefresh()
    self:OnCreated()
end

function modifier_viper_corrosive_skin_lua:GetModifierMagicalResistanceBonus(k) if not self:GetParent():IsIllusion() then return self.bonus_magic_resistance end end

function modifier_viper_corrosive_skin_lua:OnTakeDamage(k)
    if not IsServer() then return end
    local attacker = k.attacker
    local target = k.unit
    local caster = self:GetCaster()
    local damage_flags = k.damage_flags

    if target == caster and not caster:PassivesDisabled() and not attacker:IsOther() and not attacker:IsMagicImmune() and bit.band(damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION and bit.band(damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS then
        local distance = (attacker:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D()

        if distance < self.max_range_tooltip then
            local mod = attacker:AddNewModifier(caster, self:GetAbility(), "modifier_viper_corrosive_skin_lua_slow", {duration=self.duration})
            if mod:GetStackCount() < 5 and self:GetCaster():FindAbilityByName("npc_dota_hero_viper_str_last") and not self:GetCaster():HasModifier("modifier_viper_corrosive_skin_lua_cd") then
                self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_viper_corrosive_skin_lua_cd", {duration = 1})
                mod:IncrementStackCount()
            end
        end
    end
end

function modifier_viper_corrosive_skin_lua:GetModifierPhysicalArmorBonusUnique(params)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_viper_str7") then
        return self.as
    end
end

--------------------------------------------------------------------------------


modifier_viper_corrosive_skin_lua_slow = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return true end,
    IsPurgeException        = function(self) return true end,
    IsDebuff                = function(self) return true end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    GetEffectName           = function(self) return "particles/units/heroes/hero_viper/viper_corrosive_debuff.vpcf" end,
    GetEffectAttachType     = function(self) return PATTACH_ABSORIGIN_FOLLOW end,
    DeclareFunctions        = function(self)
        return {
            MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
            MODIFIER_EVENT_ON_ATTACK_LANDED,
        }
    end,
})


--------------------------------------------------------------------------------

function modifier_viper_corrosive_skin_lua_slow:OnCreated()
    self:CalculateDamage()
    self:CalculateSpeed()
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.dmgMulti = 1
    if IsServer() then
        EmitSoundOn("hero_viper.CorrosiveSkin", self:GetParent())

        self:StartIntervalThink(0.2)
    end
end

function modifier_viper_corrosive_skin_lua_slow:OnRefresh()
    self:CalculateSpeed()
    self:CalculateDamage()
end

function modifier_viper_corrosive_skin_lua_slow:CalculateDamage()
    self.damage = self:GetAbility():GetSpecialValueFor("damage")
    if self:GetCaster():FindAbilityByName("npc_dota_hero_viper_str11") then
        self.damage = self.damage + self:GetCaster():GetStrength() * 0.5
    end
    if self:GetStackCount() > 0 then
        self.damage = self.damage + self.damage * self:GetStackCount() * 0.5
    end
end

function modifier_viper_corrosive_skin_lua_slow:CalculateSpeed()
    self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed") * (-1)
    if self:GetStackCount() > 0 then
        self.bonus_attack_speed = self.bonus_attack_speed + self.bonus_attack_speed * self:GetStackCount() * 0.5
    end
end

function modifier_viper_corrosive_skin_lua_slow:GetModifierAttackSpeedBonus_Constant(k) return self.bonus_attack_speed end

function modifier_viper_corrosive_skin_lua_slow:OnAttackLanded( params )
	if IsServer() then
        if self.caster == params.attacker and self.parent == params.target and self.caster:FindAbilityByName("npc_dota_hero_viper_agi11") then
            self.dmgMulti = 0.5
            self:OnIntervalThink()
            self.dmgMulti = 1
        end
    end
end

function modifier_viper_corrosive_skin_lua_slow:OnIntervalThink()
    if IsServer() then
        if self:GetCaster():FindAbilityByName("npc_dota_hero_viper_int_last") then
            local poison_attack = self.caster:FindAbilityByName("viper_poison_attack_lua")
            if poison_attack then
                local duration = poison_attack:GetSpecialValueFor( "duration" )
                local modif = self.parent:AddNewModifier(self:GetCaster(), poison_attack, "modifier_viper_poison_attack_lua_slow", {duration=duration})
                modif:IncrementStackCount()
            end
        end
        ApplyDamage({
            victim = self:GetParent(),
            attacker = self:GetCaster(),
            damage = self.damage * self.dmgMulti,
            damage_type = self:GetAbility():GetAbilityDamageType(),
            damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
            ability = self:GetAbility()
        })

        SendOverheadEventMessage( self:GetParent(), OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), self.damage * self.dmgMulti, nil )
        self:StartIntervalThink(1.0)
    end
end

function modifier_viper_corrosive_skin_lua_slow:GetSlowValue()
end

modifier_viper_corrosive_skin_lua_cd = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return true end,
    IsPurgeException        = function(self) return true end,
    IsDebuff                = function(self) return true end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
})