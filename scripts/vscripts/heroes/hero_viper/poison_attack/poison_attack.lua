LinkLuaModifier( "modifier_viper_poison_attack_lua", "heroes/hero_viper/poison_attack/poison_attack" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_viper_poison_attack_lua_slow", "heroes/hero_viper/poison_attack/poison_attack" ,LUA_MODIFIER_MOTION_NONE )

if viper_poison_attack_lua == nil then
    viper_poison_attack_lua = class({})
end

function viper_poison_attack_lua:GetIntrinsicModifierName()
    return "modifier_viper_poison_attack_lua"
end

function viper_poison_attack_lua:GetProjectileName()
    return "particles/units/heroes/hero_viper/viper_poison_attack.vpcf"
end

function viper_poison_attack_lua:OnOrbFire( params )
    local sound_cast = "hero_viper.poisonAttack.Cast"
    EmitSoundOn( sound_cast, self:GetCaster() )
end

function viper_poison_attack_lua:OnOrbImpact( params )
    local duration = self:GetSpecialValueFor( "duration" )

    local modif = params.target:AddNewModifier(self:GetCaster(), self, "modifier_viper_poison_attack_lua_slow", {duration=duration})
    modif:SetStackCount(modif:GetStackCount() + 1)

    local sound_cast = "hero_viper.poisonAttack.Target"
    EmitSoundOn( sound_cast, params.target )
end

function viper_poison_attack_lua:GetManaCost( level )
    if self:GetCaster():FindAbilityByName("npc_dota_hero_viper_int6") then 
        return 0 
    end
    return 40 + math.min(65000, self:GetCaster():GetIntellect() / 250)
end

--------------------------------------------------------------------------------


modifier_viper_poison_attack_lua = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsPurgeException        = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self)
        return {
            MODIFIER_EVENT_ON_ATTACK,
            MODIFIER_EVENT_ON_ATTACK_FAIL,
            MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
            MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY,

            MODIFIER_EVENT_ON_ORDER,

            MODIFIER_PROPERTY_PROJECTILE_NAME,
            MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		    MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
        }
    end,
    GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_PERMANENT end,
})


--------------------------------------------------------------------------------

function modifier_viper_poison_attack_lua:GetModifierOverrideAbilitySpecial(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "magic_resistance" then
			return 1
		end
		if data.ability_special_value == "damage" then
			return 1
		end
	end
	return 0
end

function modifier_viper_poison_attack_lua:GetModifierOverrideAbilitySpecialValue(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "magic_resistance" then
			local value = self:GetAbility():GetLevelSpecialValueNoOverride( "magic_resistance", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_viper_str10") then
                value = value * 2
            end
            return value
		end
		if data.ability_special_value == "damage" then
			local value = self:GetAbility():GetLevelSpecialValueNoOverride( "damage", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_viper_int9") then
                value = value + self:GetCaster():GetIntellect() * 0.3
            end
            return value
		end
	end
	return 0
end

function modifier_viper_poison_attack_lua:OnCreated()
    self.ability = self:GetAbility()
    self.cast = false
    self.records = {}
end

function modifier_viper_poison_attack_lua:OnAttack( params )
    -- if not IsServer() then return end
    if params.attacker~=self:GetParent() then return end

    -- register attack if being cast and fully castable
    if self:ShouldLaunch( params.target ) then
        -- use mana and cd
        self.ability:UseResources(true, false, false, true)

        -- record the attack
        self.records[params.record] = true

        -- run OrbFire script if available
        if self.ability.OnOrbFire then self.ability:OnOrbFire( params ) end
    end

    self.cast = false
end
function modifier_viper_poison_attack_lua:GetModifierProcAttack_Feedback( params )
    if self.records[params.record] then
        -- apply the effect
        if self.ability.OnOrbImpact then self.ability:OnOrbImpact( params ) end
    end
end
function modifier_viper_poison_attack_lua:OnAttackFail( params )
    if self.records[params.record] then
        -- apply the fail effect
        if self.ability.OnOrbFail then self.ability:OnOrbFail( params ) end
    end
end
function modifier_viper_poison_attack_lua:OnAttackRecordDestroy( params )
    -- destroy attack record
    self.records[params.record] = nil
end

function modifier_viper_poison_attack_lua:OnOrder( params )
    if params.unit~=self:GetParent() then return end

    if params.ability then
        -- if this ability, cast
        if params.ability==self:GetAbility() then
            self.cast = true
            return
        end

        -- if casting other ability that cancel channel while casting this ability, turn off
        local pass = false
        local behavior = params.ability:GetBehavior()
        if self:FlagExist( behavior, DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_CHANNEL ) or 
            self:FlagExist( behavior, DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_MOVEMENT ) or
            self:FlagExist( behavior, DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL )
        then
            local pass = true -- do nothing
        end

        if self.cast and (not pass) then
            self.cast = false
        end
    else
        -- if ordering something which cancel channel, turn off
        if self.cast then
            if self:FlagExist( params.order_type, DOTA_UNIT_ORDER_MOVE_TO_POSITION ) or
                self:FlagExist( params.order_type, DOTA_UNIT_ORDER_MOVE_TO_TARGET ) or
                self:FlagExist( params.order_type, DOTA_UNIT_ORDER_ATTACK_MOVE ) or
                self:FlagExist( params.order_type, DOTA_UNIT_ORDER_ATTACK_TARGET ) or
                self:FlagExist( params.order_type, DOTA_UNIT_ORDER_STOP ) or
                self:FlagExist( params.order_type, DOTA_UNIT_ORDER_HOLD_POSITION )
            then
                self.cast = false
            end
        end
    end
end

function modifier_viper_poison_attack_lua:GetModifierProjectileName()
    if not self.ability.GetProjectileName then return end

    if self:ShouldLaunch( self:GetCaster():GetAggroTarget() ) then
        return self.ability:GetProjectileName()
    end
end

function modifier_viper_poison_attack_lua:ShouldLaunch( target )
    -- check autocast
    if self.ability:GetAutoCastState() then
        -- filter whether target is valid
        if self.ability.CastFilterResultTarget~=CDOTA_Ability_Lua.CastFilterResultTarget then
            -- check if ability has custom target cast filter
            if self.ability:CastFilterResultTarget( target )==UF_SUCCESS then
                self.cast = true
            end
        else
            local nResult = UnitFilter(
                target,
                self.ability:GetAbilityTargetTeam(),
                self.ability:GetAbilityTargetType(),
                self.ability:GetAbilityTargetFlags(),
                self:GetCaster():GetTeamNumber()
            )
            if nResult == UF_SUCCESS then
                self.cast = true
            end
        end
    end

    if self.cast and self.ability:IsFullyCastable() and (not self:GetParent():IsSilenced()) then
        return true
    end

    return false
end

function modifier_viper_poison_attack_lua:FlagExist(a,b)
    if type(a) ~= 'number' or type(b) ~= 'number' then return false end
    local p,c,d=1,0,b
    while a>0 and b>0 do
        local ra,rb=a%2,b%2
        if ra+rb>1 then c=c+p end
        a,b,p=(a-ra)/2,(b-rb)/2,p*2
    end
    return c==d
end

--------------------------------------------------------------------------------


modifier_viper_poison_attack_lua_slow = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return true end,
    IsPurgeException        = function(self) return true end,
    IsDebuff                = function(self) return true end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self)
        return {
            MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
            MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        }
    end,
    GetEffectName           = function(self) return "particles/units/heroes/hero_viper/viper_poison_debuff.vpcf" end,
    GetEffectAttachType     = function(self) return PATTACH_ABSORIGIN_FOLLOW end,
})


--------------------------------------------------------------------------------

function modifier_viper_poison_attack_lua_slow:OnCreated()
    if self:GetParent():IsBuilding() then self:OnDestroy() end
    self.damage = self:GetAbility():GetSpecialValueFor("damage")
    self.movement_speed = self:GetAbility():GetSpecialValueFor("movement_speed") * (-1)
    self.magic_resistance = self:GetAbility():GetSpecialValueFor("magic_resistance") * (-1)
    self.max_stacks = self:GetAbility():GetSpecialValueFor("max_stacks")
    self:StartIntervalThink(0.2)
end

function modifier_viper_poison_attack_lua_slow:OnRefresh()
    self.damage = self:GetAbility():GetSpecialValueFor("damage")
    self.movement_speed = self:GetAbility():GetSpecialValueFor("movement_speed") * (-1)
    self.magic_resistance = self:GetAbility():GetSpecialValueFor("magic_resistance") * (-1)
    self.max_stacks = self:GetAbility():GetSpecialValueFor("max_stacks")
    if self:GetCaster():FindAbilityByName("npc_dota_hero_viper_int13") == nil and self:GetStackCount() > self.max_stacks then
        self:SetStackCount(self.max_stacks)
    end
end
function modifier_viper_poison_attack_lua_slow:GetDamageValue()
    local damage = self:GetAbility():GetSpecialValueFor("damage")
    if self:GetCaster():FindAbilityByName("npc_dota_hero_viper_agi6") and self:GetParent():HasModifier("modifier_viper_viper_strike_lua") then
        damage = damage * 2
    end
    if self:GetCaster():FindAbilityByName("npc_dota_hero_viper_int13") then
        local r = 0.9
        local n = self:GetStackCount()
        return damage * (1 - r^n) / (1 - r)
    end
    return damage * self:GetStackCount()
end
if IsServer() then
function modifier_viper_poison_attack_lua_slow:OnIntervalThink()
    local damage = self:GetDamageValue()
    damage_type = self:GetAbility():GetAbilityDamageType()
    ApplyDamage({
        victim = self:GetParent(),
        attacker = self:GetCaster(),
        damage = damage,
        damage_type = damage_type,
        ability = self:GetAbility()
    })

    SendOverheadEventMessage( self:GetParent(), OVERHEAD_ALERT_BONUS_POISON_DAMAGE, self:GetParent(), damage, nil )
    self:StartIntervalThink(1)
end
end

function modifier_viper_poison_attack_lua_slow:GetModifierMoveSpeedBonus_Percentage() 
    local stack_count = self:GetStackCount()
    if stack_count > self:GetAbility():GetSpecialValueFor('max_stacks') then
        stack_count = self:GetAbility():GetSpecialValueFor('max_stacks')
    end
    return self.movement_speed * stack_count
end
function modifier_viper_poison_attack_lua_slow:GetModifierMagicalResistanceBonus()
    local stack_count = self:GetStackCount()
    if stack_count > self:GetAbility():GetSpecialValueFor('max_stacks') then
        stack_count = self:GetAbility():GetSpecialValueFor('max_stacks')
    end
    return self.magic_resistance * stack_count
end