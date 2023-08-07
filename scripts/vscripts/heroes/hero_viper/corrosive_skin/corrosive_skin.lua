LinkLuaModifier( "modifier_viper_corrosive_skin_lua", "heroes/hero_viper/corrosive_skin/corrosive_skin.lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_viper_corrosive_skin_lua_slow", "heroes/hero_viper/corrosive_skin/corrosive_skin.lua" ,LUA_MODIFIER_MOTION_NONE )

if viper_corrosive_skin_lua == nil then
    viper_corrosive_skin_lua = class({})
end

--------------------------------------------------------------------------------

function viper_corrosive_skin_lua:GetIntrinsicModifierName()
    return "modifier_viper_corrosive_skin_lua"
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
            MODIFIER_EVENT_ON_TAKEDAMAGE
        }
    end,
})


--------------------------------------------------------------------------------

function modifier_viper_corrosive_skin_lua:OnCreated()
    self.bonus_magic_resistance = self:GetAbility():GetSpecialValueFor("bonus_magic_resistance")
    self.duration = self:GetAbility():GetSpecialValueFor("duration")
    self.max_range_tooltip = self:GetAbility():GetSpecialValueFor("max_range_tooltip")
end

function modifier_viper_corrosive_skin_lua:OnRefresh()
    self:OnCreated()
end

function modifier_viper_corrosive_skin_lua:GetModifierMagicalResistanceBonus(k) if not self:GetParent():IsIllusion() then return self.bonus_magic_resistance end end

function modifier_viper_corrosive_skin_lua:OnTakeDamage(k)
    local attacker = k.attacker
    local target = k.unit
    local caster = self:GetCaster()
    local damage_flags = k.damage_flags

    if target == caster and not caster:PassivesDisabled() and not attacker:IsOther() and not attacker:IsMagicImmune() and bit.band(damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION and bit.band(damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS then
        local distance = (attacker:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D()

        if distance < self.max_range_tooltip then
            attacker:AddNewModifier(caster, self:GetAbility(), "modifier_viper_corrosive_skin_lua_slow", {duration=self.duration})
        end
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
            MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
        }
    end,
})


--------------------------------------------------------------------------------

function modifier_viper_corrosive_skin_lua_slow:OnCreated()
    self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed") * (-1)
    self.damage = self:GetAbility():GetSpecialValueFor("damage")

    if IsServer() then
        EmitSoundOn("hero_viper.CorrosiveSkin", self:GetParent())

        self:StartIntervalThink(1.0)
    end
end

function modifier_viper_corrosive_skin_lua_slow:OnRefresh()
    self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed") * (-1)
    self.damage = self:GetAbility():GetSpecialValueFor("damage")
end

function modifier_viper_corrosive_skin_lua_slow:GetModifierAttackSpeedBonus_Constant(k) return self.bonus_attack_speed end

if IsServer() then
function modifier_viper_corrosive_skin_lua_slow:OnIntervalThink()
    ApplyDamage({
        victim = self:GetParent(),
        attacker = self:GetCaster(),
        damage = self.damage,
        damage_type = self:GetAbility():GetAbilityDamageType(),
        damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
        ability = self:GetAbility()
    })

    SendOverheadEventMessage( self:GetParent(), OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), self.damage, nil )
end
end