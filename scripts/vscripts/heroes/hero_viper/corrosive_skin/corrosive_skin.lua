LinkLuaModifier( "modifier_viper_corrosive_skin_lua", "heroes/hero_viper/corrosive_skin/corrosive_skin.lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_viper_corrosive_skin_lua_slow", "heroes/hero_viper/corrosive_skin/corrosive_skin.lua" ,LUA_MODIFIER_MOTION_NONE )

if viper_corrosive_skin_lua == nil then
    viper_corrosive_skin_lua = class({})
end

--------------------------------------------------------------------------------

function viper_corrosive_skin_lua:GetIntrinsicModifierName()
    return "modifier_viper_corrosive_skin_lua"
end

function viper_corrosive_skin_lua:GetBehavior()
    if self:GetCaster():FindAbilityByName("npc_dota_hero_viper_str12") then
        return DOTA_ABILITY_BEHAVIOR_TOGGLE
    end
end

function viper_corrosive_skin_lua:OnOwnerSpawned()
	if self.toggle_state then
		self:ToggleAbility()
	end
end

function viper_corrosive_skin_lua:OnOwnerDied()
	self.toggle_state = self:GetToggleState()
end

function viper_corrosive_skin_lua:OnToggle()
	if not IsServer() then return end
end

function viper_corrosive_skin_lua:GetCooldown(level)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_viper_str12") then 
	    return 1
	end
	return self.BaseClass.GetCooldown(self, level)
end

function viper_corrosive_skin_lua:GetCastRange(vLocation, hTarget)
    return self:GetSpecialValueFor("aura_radius")
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
            MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
            MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		    MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
        }
    end,
})


--------------------------------------------------------------------------------

function modifier_viper_corrosive_skin_lua:GetModifierOverrideAbilitySpecial(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "bonus_arrmor" then
			return 1
		end
		if data.ability_special_value == "bonus_magic_resistance" then
			return 1
		end
        if data.ability_special_value == "damage" then
			return 1
		end
        if data.ability_special_value == "aura_radius" then
			return 1
		end
        if data.ability_special_value == "bonus_attack_speed" then
			return 1
		end
	end
	return 0
end

function modifier_viper_corrosive_skin_lua:GetModifierOverrideAbilitySpecialValue(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "bonus_arrmor" then
			local value = self:GetAbility():GetLevelSpecialValueNoOverride( "bonus_arrmor", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_viper_str7") then
                value = self:GetAbility():GetSpecialValueFor("attack_speed_reduction")
            end
            return value
		end
		if data.ability_special_value == "bonus_magic_resistance" then
			local value = self:GetAbility():GetLevelSpecialValueNoOverride( "bonus_magic_resistance", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_viper_str8") then
                value = value * 2
            end
            return value
		end
        if data.ability_special_value == "damage" then
			local value = self:GetAbility():GetLevelSpecialValueNoOverride( "damage", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_viper_str11") then
                value = value + self:GetCaster():GetStrength() * 0.5
            end
            return value
		end
        if data.ability_special_value == "aura_radius" then
			local value = self:GetAbility():GetLevelSpecialValueNoOverride( "aura_radius", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_viper_str12") then
                value = 800
            end
            return value
		end
        if data.ability_special_value == "bonus_attack_speed" then
			local value = self:GetAbility():GetLevelSpecialValueNoOverride( "bonus_attack_speed", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_viper_agi8") then
                value = self:GetAbility():GetSpecialValueFor("attack_speed_reduction")
            end
            return value
		end
	end
	return 0
end

function modifier_viper_corrosive_skin_lua:IsAura()
	return self:GetAbility():GetToggleState()
end

function modifier_viper_corrosive_skin_lua:GetModifierAura() 
	return "modifier_viper_corrosive_skin_lua_slow" 
end

function modifier_viper_corrosive_skin_lua:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("aura_radius")
end

function modifier_viper_corrosive_skin_lua:GetAuraSearchFlags() 
	return DOTA_UNIT_TARGET_FLAG_NONE 
end

function modifier_viper_corrosive_skin_lua:GetAuraSearchTeam() 
	return DOTA_UNIT_TARGET_TEAM_ENEMY 
end

function modifier_viper_corrosive_skin_lua:GetAuraSearchType() 
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_viper_corrosive_skin_lua:OnCreated()
    self.duration = self:GetAbility():GetSpecialValueFor("duration")
end

modifier_viper_corrosive_skin_lua.OnRefresh = modifier_viper_corrosive_skin_lua.OnCreated

function modifier_viper_corrosive_skin_lua:GetModifierMagicalResistanceBonus(k) 
    return self:GetAbility():GetSpecialValueFor("bonus_magic_resistance")
end

function modifier_viper_corrosive_skin_lua:OnTakeDamage(k)
    if not IsServer() then return end
    local attacker = k.attacker
    local target = k.unit
    local caster = self:GetCaster()
    local damage_flags = k.damage_flags

    if target == caster and not caster:PassivesDisabled() and not attacker:IsOther() and not attacker:IsMagicImmune() and bit.band(damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION and bit.band(damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS then
        if not self:GetAbility():GetToggleState() then
            local mod = attacker:AddNewModifier(caster, self:GetAbility(), "modifier_viper_corrosive_skin_lua_slow", {duration=self.duration})
        end
    end
end

function modifier_viper_corrosive_skin_lua:GetModifierPhysicalArmorBonusUnique()
	return self:GetAbility():GetSpecialValueFor("bonus_arrmor")
end
function modifier_viper_corrosive_skin_lua:GetModifierAttackSpeedBonus_Constant(k) 
    return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
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
end

function modifier_viper_corrosive_skin_lua_slow:CalculateDamage()
    local damage = self:GetAbility():GetSpecialValueFor("damage")
    if self:GetStackCount() > 0 then
        damage = damage + damage * self:GetStackCount() * 0.5
    end
    return damage * self.dmgMulti
end

function modifier_viper_corrosive_skin_lua_slow:CalculateSpeed()
    self.attack_speed_reduction = self:GetAbility():GetSpecialValueFor("attack_speed_reduction") * (-1)
    if self:GetStackCount() > 0 then
        self.attack_speed_reduction = self.attack_speed_reduction + self.attack_speed_reduction * self:GetStackCount() * 0.5
    end
end

function modifier_viper_corrosive_skin_lua_slow:GetModifierAttackSpeedBonus_Constant(k) 
    return self.attack_speed_reduction 
end

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
        if self:GetCaster():FindAbilityByName("npc_dota_hero_viper_int12") then
            local poison_attack = self.caster:FindAbilityByName("viper_poison_attack_lua")
            if poison_attack then
                local duration = poison_attack:GetSpecialValueFor( "duration" )
                local modif = self.parent:AddNewModifier(self:GetCaster(), poison_attack, "modifier_viper_poison_attack_lua_slow", {duration=duration})
                modif:IncrementStackCount()
            end
        end
        local damage = self:CalculateDamage()
        ApplyDamage({
            victim = self:GetParent(),
            attacker = self:GetCaster(),
            damage = damage,
            damage_type = self:GetAbility():GetAbilityDamageType(),
            damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
            ability = self:GetAbility()
        })
        SendOverheadEventMessage( self:GetParent(), OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), damage, nil )
        if self:GetCaster():FindAbilityByName("npc_dota_hero_viper_str13") and self:GetStackCount() < 5 then
            self:IncrementStackCount()
        end
        self:StartIntervalThink(1.0)
    end
end
