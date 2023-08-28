LinkLuaModifier("modifier_razor_unstable_current_bh", "heroes/hero_razor/razor_storm_surge_lua/razor_unstable_current_bh.lua", LUA_MODIFIER_MOTION_NONE)


razor_unstable_current_bh = class({})

function razor_unstable_current_bh:GetAbilityTextureName()
    return "razor_unstable_current"	 -- return self.BaseClass.GetAbilityTextureName(self)
end

function razor_unstable_current_bh:GetAOERadius()
	return self:GetSpecialValueFor("radius")	 -- return self.BaseClass.GetAOERadius(self)
end


function razor_unstable_current_bh:GetCooldown(iLevel)
    if self:GetCaster():FindAbilityByName("npc_dota_hero_razor_int7") then
        return 1
    end
    return self:GetSpecialValueFor("passive_area_interval")	-- return self.BaseClass.GetCooldown(self, iLevel)
end


function razor_unstable_current_bh:GetDamageType()
    return DAMAGE_TYPE_MAGICAL
end
function razor_unstable_current_bh:GetAbilityDamageType()
    return self:GetDamageType()
end
function razor_unstable_current_bh:GetUnitDamageType()
    return self:GetDamageType()
end

function razor_unstable_current_bh:GetIntrinsicModifierName()
	return "modifier_razor_unstable_current_bh"
end

-- function razor_unstable_current_bh:_IsReady( )
--     return self:GetToggleState() and self:_IsCooldownReady()
-- end
-- function razor_unstable_current_bh:_IsCooldownReady()    
--     local caster = self:GetCaster()
--     local ability = self
--     local cooldown_time = ability:GetSpecialValueFor("passive_area_interval")
--     self._prev_spell_time = self._prev_spell_time or GameRules:GetGameTime()
--     local isCooldownReady = GameRules:GetGameTime() > (self._prev_spell_time + cooldown_time)
--     return isCooldownReady
-- end
-- function razor_unstable_current_bh:_StartCooldown()    
--     local ability = self
--     ability:StartCooldown( ability:GetCooldown(ability:GetLevel() - 1) )
--     self._prev_spell_time = GameRules:GetGameTime()
-- end










modifier_razor_unstable_current_bh = class({})

function modifier_razor_unstable_current_bh:IsPassive()
	return true
end
function modifier_razor_unstable_current_bh:IsHidden()
	return true
end
function modifier_razor_unstable_current_bh:IsPurgable()	-- 能否被驱散
	return false
end


function modifier_razor_unstable_current_bh:OnRefresh(table)

end

function modifier_razor_unstable_current_bh:OnCreated( kv )
    local caster = self:GetParent()
    local ability = self:GetAbility()
    
    if IsServer() then
        -- if not caster:IsIllusion() then
        --     self:StartIntervalThink(0.25)		
        -- end
    end
end

function modifier_razor_unstable_current_bh:OnDestroy()
    self:StartIntervalThink(-1)		-- stop
end

function modifier_razor_unstable_current_bh:OnIntervalThink( )
    -- local ability = self:GetAbility()
    
    -- if ability:IsToggle() then
    --     self:_MovementSpeed()
    --     self:_SpellStart()
    -- end
end

function modifier_razor_unstable_current_bh:DeclareFunctions( )
    return {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
    }
end

function modifier_razor_unstable_current_bh:OnTakeDamage(params)
    if params.unit == self:GetParent() and self:GetAbility():IsFullyCastable() and RollPseudoRandomPercentage(self:GetAbility():GetSpecialValueFor("chance"), self:GetCaster():entindex(), self:GetCaster()) then
        local ability = self:GetAbility()
        local caster = self:GetCaster()
        local radius = ability:GetSpecialValueFor("radius")
        local max_targets = ability:GetSpecialValueFor("max_targets")
        local enemy_list = FindTargetEnemy(caster, caster:GetAbsOrigin(), radius)

        local damage = ability:GetSpecialValueFor("passive_area_damage")
        if caster:FindAbilityByName("npc_dota_hero_razor_str11") then
            damage = damage + self:GetCaster():GetStrength() * 0.75
        end
        if caster:FindAbilityByName("npc_dota_hero_razor_int10") then
            damage = damage + self:GetCaster():GetIntellect() * 0.5
        end
        
        if #enemy_list > 0 then
            caster:EmitSound('Hero_Razor.UnstableCurrent.Strike')
            for i = 1, max_targets do
                if enemy_list[i] then
                    self:_SpellTarget(enemy_list[i], damage)
                end
            end
            ability:UseResources(false, false, false, true)
        end
    end
end

-- function modifier_razor_unstable_current_bh:_SpellStart( )
--     local caster = self:GetCaster()
--     local ability = self:GetAbility()

--     if caster:IsIllusion() then return nil end

--     if ability:_IsReady() then
--         local radius = ability:GetAOERadius()
--         local enemy_list = FindTargetEnemy(caster, caster:GetAbsOrigin(), radius)

--         if #enemy_list > 0 then
--             ability:_StartCooldown()

--             caster:EmitSound('Hero_Razor.UnstableCurrent.Strike')

--             local damage_base = GetTalentSpecialValueFor(ability, 'passive_area_damage')
--             local attack_damage_pct = ability:GetSpecialValueFor('attack_damage_pct')
--             local caster_attack = caster:GetAverageTrueAttackDamage(caster)
--             local damage_attack = caster_attack * ( attack_damage_pct / 100)
--             local damage_amount = damage_base + damage_attack

--             for _,enemy in pairs(enemy_list) do
--                 self:_SpellTarget(enemy, damage_amount)
--             end
--         end
--     end
-- end

function modifier_razor_unstable_current_bh:_SpellTarget( target, damage )
    local caster = self:GetCaster()
    local ability = self:GetAbility()

    target:EmitSound('Hero_Razor.UnstableCurrent.Target')

    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_razor/razor_unstable_current.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, target)
    ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT, "follow_origin", caster:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT, "follow_origin", target:GetAbsOrigin(), true)
    ParticleManager:ReleaseParticleIndex(particle)

    local damage_info = {
        victim = target,
        attacker = caster,
        damage = damage,
        damage_type = ability:GetAbilityDamageType(),
        ability = ability
    }
    ApplyDamage( damage_info )
end

function modifier_razor_unstable_current_bh:GetModifierMoveSpeedBonus_Percentage(keys)
    speed = self:GetAbility():GetSpecialValueFor("movement_speed_pct")
    if self:GetCaster():FindAbilityByName("npc_dota_hero_razor_str8") then
        speed = speed * 2
    end
    return speed
end

function modifier_razor_unstable_current_bh:GetModifierIgnoreMovespeedLimit()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_razor_str8") then
        return 1
    end
end


-- 获得技能数据中的数据值，如果学习了连接的天赋技能，就返回相加结果
function GetTalentSpecialValueFor(ability, value)
    local base = ability:GetSpecialValueFor(value)
    local talentName
    local kv = ability:GetAbilityKeyValues()
    for k,v in pairs(kv) do -- trawl through keyvalues
        if k == "AbilitySpecial" then
            for l,m in pairs(v) do
                if m[value] then
                    talentName = m["LinkedSpecialBonus"]
                end
            end
        end
    end
    if talentName then 
        local talent = ability:GetCaster():FindAbilityByName(talentName)
        if talent and talent:GetLevel() > 0 then base = base + talent:GetSpecialValueFor("value") end
    end
    return base
end

-- 获得技能数据中的数据值，如果学习了连接的天赋技能，就返回相加结果
function GetTalentSpecialValueFor2(ability, value, talentName)
    local base = ability:GetSpecialValueFor(value)
    if talentName then 
        local talent = ability:GetCaster():FindAbilityByName(talentName)
        if talent and talent:GetLevel() > 0 then base = base + talent:GetSpecialValueFor("value") end
    end
    return base
end

-- 搜索目标位置所有的敌人单位
function FindTargetEnemy(unit, point, radius)
    local iTeamNumber = unit:GetTeamNumber()
    local vPosition = point   				-- 搜索中心点
    local hCacheUnit = nil                  -- 通常值
    local flRadius = radius                 -- 搜索范围
    local iTeamFilter = DOTA_UNIT_TARGET_TEAM_ENEMY  -- 目标是敌人单位
    -- 目标单位类型
	local iTypeFilter = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC --DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP           
	-- 仅针对可见的单位、忽视建筑物、支持魔法免疫
    local iFlagFilter = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE   
    local iOrder = FIND_CLOSEST                         -- 寻找最近的
    local bCanGrowCache = false             -- 通常值
    return FindUnitsInRadius( iTeamNumber, vPosition, hCacheUnit, 
        flRadius, iTeamFilter, iTypeFilter, iFlagFilter, iOrder, bCanGrowCache )
end
