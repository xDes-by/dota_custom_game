LinkLuaModifier( "modifier_spectre_desolate_lua", "heroes/hero_spectre/spectre_desolate_dd/spectre_desolate_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_spectre_desolate_debuff", "heroes/hero_spectre/spectre_desolate_dd/spectre_desolate_lua", LUA_MODIFIER_MOTION_NONE )

spectre_desolate_lua = class({})
function spectre_desolate_lua:GetIntrinsicModifierName()
	return "modifier_spectre_desolate_lua"
end

function spectre_desolate_lua:GetCastRange(vLocation, hTarget)
    if self:GetCaster():FindAbilityByName("npc_dota_hero_spectre_agi10") then
	    return 500
    end
end

modifier_spectre_desolate_lua = class({})

function modifier_spectre_desolate_lua:IsHidden()
    return true
end

function modifier_spectre_desolate_lua:IsPurgable()
    return false
end

function modifier_spectre_desolate_lua:IsPurgeException() 	
	return false 
end

function modifier_spectre_desolate_lua:IsAura()
    if self:GetCaster():FindAbilityByName("npc_dota_hero_spectre_agi10") then
	    return true
    end
    return false
end

function modifier_spectre_desolate_lua:OnCreated()
    if not IsServer() then
        return
    end
end

function modifier_spectre_desolate_lua:OnRefresh()
    self:OnCreated()
end

function modifier_spectre_desolate_lua:GetModifierAura() 
	return "modifier_spectre_desolate_debuff" 
end

function modifier_spectre_desolate_lua:GetAuraRadius()
	return 500
end

function modifier_spectre_desolate_lua:GetAuraSearchFlags() 
	return DOTA_UNIT_TARGET_FLAG_NONE 
end

function modifier_spectre_desolate_lua:GetAuraSearchTeam() 
	return DOTA_UNIT_TARGET_TEAM_ENEMY 
end

function modifier_spectre_desolate_lua:GetAuraSearchType() 
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_spectre_desolate_lua:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_spectre_desolate_lua:OnAttackLanded( params )
	local attacker = params.attacker
    local target = params.target
	if attacker == self:GetParent() then 
        EmitSoundOn("Hero_Spectre.Desolate", self:GetCaster())

    
        if self:GetCaster():FindAbilityByName("npc_dota_hero_spectre_agi11") then
            local enemies = FindUnitsInRadius(
                self:GetParent():GetTeamNumber(),	-- int, your team number
                target:GetOrigin(),	-- point, center point
                nil,	-- handle, cacheUnit. (not known)
                150,	-- float, radius. or use FIND_UNITS_EVERYWHERE
                DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
                DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
                0,	-- int, order filter
                false	-- bool, can grow cache
            )
    
            for _,enemy in pairs(enemies) do
                if enemy ~= target then
                    self:ApplyEffect(enemy, 0.75)
                end
            end
        end
        self:ApplyEffect(target, 1)
    end
end


function modifier_spectre_desolate_lua:GetDamageValue()
    local damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
    local base_damage_multi = self:GetAbility():GetSpecialValueFor("base_damage_perc") / 100
    if self:GetCaster():FindAbilityByName("npc_dota_hero_spectre_agi_last") then
        base_damage_multi = base_damage_multi + 0.5
    end
    if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_spectre_agi50") then
        base_damage_multi = base_damage_multi + 0.5
    end
    if self:GetCaster():FindAbilityByName("npc_dota_hero_spectre_int8") then 
        base_damage_multi = base_damage_multi / 2
    end
    damage = damage + self:GetCaster():GetBaseDamageMax() * base_damage_multi
    if self:GetCaster():FindAbilityByName("npc_dota_hero_spectre_int11") then
        damage = damage + self:GetCaster():GetIntellect() * 0.5
    end
    if self:GetCaster():HasModifier("modifier_step_buff") then
        damage = damage * 2
    end
    return damage
end

function modifier_spectre_desolate_lua:ApplyEffect(target, multi)
    if target:IsBuilding() then return end
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_spectre/spectre_desolate.vpcf", PATTACH_POINT, target)
    ParticleManager:SetParticleControl(particle, 0, Vector( target:GetAbsOrigin().x, target:GetAbsOrigin().y, GetGroundPosition(target:GetAbsOrigin(), target).z + 140))
    local direction = (target:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()                                                        
    ParticleManager:SetParticleControlForward(particle, 0, direction)
    
    
    damage_type = DAMAGE_TYPE_PURE
    damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
        
    if self:GetCaster():FindAbilityByName("npc_dota_hero_spectre_int8") ~= nil then 
        damage_type = DAMAGE_TYPE_MAGICAL
        damage_flags = DOTA_DAMAGE_FLAG_NONE
    end

    local damageTable = {
        victim = target,
        attacker = self:GetCaster(),
        damage = self:GetDamageValue() * multi,
        damage_type = damage_type,
        damage_flags = damage_flags,
        ability = self:GetAbility(),
    }
        
    ApplyDamage(damageTable)
end

function modifier_spectre_desolate_lua:GetModifierAttackSpeedBonus_Constant()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_spectre_agi8") then
        return self:GetAbility():GetSpecialValueFor("bonus_damage")
    end
    return 0
end


modifier_spectre_desolate_debuff = class({})

function modifier_spectre_desolate_debuff:IsPurgable()
    return false
end

function modifier_spectre_desolate_debuff:IsDebuff()
    return true
end

function modifier_spectre_desolate_debuff:OnCreated( kv )
    self:StartIntervalThink(0.1)
end

function modifier_spectre_desolate_debuff:OnIntervalThink()
    if not IsServer() then return end
    local modifier = self:GetCaster():FindModifierByName("modifier_spectre_desolate_lua")
    modifier:ApplyEffect(self:GetParent(), 0.5)
    self:StartIntervalThink(1 / self:GetCaster():GetAttacksPerSecond() + 0.1)
end