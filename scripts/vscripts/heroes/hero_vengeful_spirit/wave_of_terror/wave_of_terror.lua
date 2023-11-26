LinkLuaModifier( "modifier_vengeful_spirit_wave_of_terror_debuff", "heroes/hero_vengeful_spirit/wave_of_terror/wave_of_terror" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_vengeful_spirit_wave_of_terror_burning", "heroes/hero_vengeful_spirit/wave_of_terror/wave_of_terror" ,LUA_MODIFIER_MOTION_NONE )

if vengeful_spirit_wave_of_terror == nil then
    vengeful_spirit_wave_of_terror = class({})
end

--------------------------------------------------------------------------------
function vengeful_spirit_wave_of_terror:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end
function vengeful_spirit_wave_of_terror:OnSpellStart()
    local caster = self:GetCaster()
    local position = self:GetCursorPosition()
    local direction = (position - caster:GetAbsOrigin()):Normalized()

    local speed = self:GetSpecialValueFor("wave_speed")
    local width = self:GetSpecialValueFor("wave_width")
    self.vision_aoe = self:GetSpecialValueFor("vision_aoe")
    self.vision_duration = self:GetSpecialValueFor("vision_duration")

    caster:EmitSound("Hero_VengefulSpirit.WaveOfTerror")

    local proj = "particles/units/heroes/hero_vengeful/vengeful_wave_of_terror.vpcf"

    local directions = {
        caster:GetForwardVector()  -- Original direction
    }
    if self:GetCaster():FindAbilityByName("npc_dota_hero_vengefulspirit_agi8") then
        table.insert(directions, RotatePosition(Vector(0, 0, 0), QAngle(0, 40, 0), caster:GetForwardVector()))
        table.insert(directions, RotatePosition(Vector(0, 0, 0), QAngle(0, -40, 0), caster:GetForwardVector()))
    end
    for _, direction in pairs(directions) do
        local info = {
            Ability = self,
            EffectName = proj,
            vSpawnOrigin = caster:GetAbsOrigin(),
            fDistance = 1400,
            fStartRadius = width,
            fEndRadius = width,
            Source = caster,
            bHasFrontalCone = false,
            bReplaceExisting = false,
            iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
            iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
            iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            bDeleteOnHit = false,
            vVelocity = direction * speed,
            bProvidesVision = true,
            iVisionRadius = self:GetSpecialValueFor("vision_aoe"),
            iVisionTeamNumber = caster:GetTeamNumber(),
        }

        ProjectileManager:CreateLinearProjectile(info)
    end

    caster:EmitSound("Hero_VengefulSpirit.WaveOfTerror")
end

function vengeful_spirit_wave_of_terror:OnProjectileHit(Target, Location)
    if Target ~= nil and not Target:IsInvulnerable() then
        local damage = self:GetAbilityDamage()
        local armor_reduction_duration = self:GetDuration()
        if self:GetCaster():FindAbilityByName("npc_dota_hero_vengefulspirit_agi6") then 
            armor_reduction_duration = armor_reduction_duration + 5
        end
        if self:GetCaster():FindAbilityByName("npc_dota_hero_vengefulspirit_agi11") then 
            damage = damage + self:GetCaster():GetAgility() * 0.5
        end
        if self:GetCaster():FindAbilityByName("npc_dota_hero_vengefulspirit_int7") then 
            damage = damage + self:GetCaster():GetIntellect() * 0.4
        end
        
        ApplyDamage({
            victim = Target,
            attacker = self:GetCaster(),
            damage = damage,
            damage_type = self:GetAbilityDamageType(),
            ability = self
        })

        Target:AddNewModifier(self:GetCaster(), self, "modifier_vengeful_spirit_wave_of_terror_debuff", {duration=armor_reduction_duration})
        if self:GetCaster():FindAbilityByName("npc_dota_hero_vengefulspirit_int10") then
            Target:AddNewModifier(self:GetCaster(), self, "modifier_vengeful_spirit_wave_of_terror_burning", {duration=3, damage = damage})
        end
    end
    return false
end

function vengeful_spirit_wave_of_terror:OnProjectileThink(vLocation)
    local caster = self:GetCaster()

    AddFOWViewer(caster:GetTeamNumber(), vLocation, self.vision_aoe, self.vision_duration, false)
end

--------------------------------------------------------------------------------


modifier_vengeful_spirit_wave_of_terror_debuff = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return true end,
    IsDebuff                = function(self) return true end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self)
        return {
            MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
            MODIFIER_PROPERTY_TOOLTIP,
            MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        }
    end,
    GetEffectName           = function(self) return "particles/units/heroes/hero_vengeful/vengeful_wave_of_terror_recipient.vpcf" end,
    GetEffectAttachType     = function(self) return PATTACH_POINT_FOLLOW end,
    OnTooltip               = function(self) return self:GetArrmorReduction() end,
})


--------------------------------------------------------------------------------

function modifier_vengeful_spirit_wave_of_terror_debuff:OnCreated()
    self.armor_reduction = self:GetAbility():GetSpecialValueFor("armor_reduction")
    if IsServer() then
        if self:GetCaster():FindAbilityByName("npc_dota_hero_vengefulspirit_agi6") then
            self:SetStackCount(1)
        end
    end
end

function modifier_vengeful_spirit_wave_of_terror_debuff:OnRefresh()
    if IsServer() then
        if self:GetCaster():FindAbilityByName("npc_dota_hero_vengefulspirit_agi6") and self:GetStackCount() < 6 then
            self:IncrementStackCount()
        end
    end
end

function modifier_vengeful_spirit_wave_of_terror_debuff:GetModifierPhysicalArmorBonus()
    return self:GetArrmorReduction() 
end

function modifier_vengeful_spirit_wave_of_terror_debuff:GetModifierDamageOutgoing_Percentage()
    if self:GetCaster():FindAbilityByName("npc_dota_hero_vengefulspirit_str9") then
        return -30
    end
end

function modifier_vengeful_spirit_wave_of_terror_debuff:GetArrmorReduction()
    local armor_reduction = self.armor_reduction
    if self:GetStackCount() > 0 then
        armor_reduction = armor_reduction + (self:GetStackCount()-1) * armor_reduction * 0.2
    end
    return armor_reduction 
end


modifier_vengeful_spirit_wave_of_terror_burning = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return true end,
    IsDebuff                = function(self) return true end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self)
        return {
            -- MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
            -- MODIFIER_PROPERTY_TOOLTIP,
        }
    end,
    GetEffectName           = function(self) return "particles/units/heroes/hero_vengeful/vengeful_wave_of_terror_recipient.vpcf" end,
    GetEffectAttachType     = function(self) return PATTACH_POINT_FOLLOW end,
    OnTooltip               = function(self) return self:GetArrmorReduction() end,
})


--------------------------------------------------------------------------------

function modifier_vengeful_spirit_wave_of_terror_burning:OnCreated( kv )
    if IsServer() then
        self.damage = kv.damage * 0.20 * 0.5
        self:StartIntervalThink( 0.5 )
    end
end

function modifier_vengeful_spirit_wave_of_terror_burning:OnIntervalThink()
    if IsServer() then
        ApplyDamage({
            victim = self:GetParent(),
            attacker = self:GetCaster(),
            damage = self.damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self:GetAbility(),
        })
    end
end
