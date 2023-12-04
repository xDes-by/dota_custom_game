static_link_lua = static_link_lua or class({})
LinkLuaModifier("modifier_static_link_drain", "heroes/hero_razor/static_link_lua/static_link_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_static_link_hit", "heroes/hero_razor/static_link_lua/static_link_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_static_link_lua", "heroes/hero_razor/static_link_lua/static_link_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_static_link_lua_permanent", "heroes/hero_razor/static_link_lua/static_link_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_static_link_lua_attribute", "heroes/hero_razor/static_link_lua/static_link_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_static_link_lua_attribute_permanent", "heroes/hero_razor/static_link_lua/static_link_lua.lua", LUA_MODIFIER_MOTION_NONE)

function static_link_lua:GetIntrinsicModifierName()
  return "modifier_static_link_lua"
end

function static_link_lua:GetBehavior()
  if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_razor_agi50") then
    return DOTA_ABILITY_BEHAVIOR_PASSIVE
  end
end
function static_link_lua:GetManaCost(iLevel)
  if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_razor_agi50") then
    return 0
  end
  return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end
function static_link_lua:GetCooldown(iLevel)
  if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_razor_agi50") then
    return 0
  end
end
function static_link_lua:OnSpellStart(target)
  local ability = self
  local caster = self:GetCaster()
  target = target or self:GetCursorTarget()

  local soundStart = "Ability.static.start"
  
  local drain_duration = self:GetSpecialValueFor("drain_duration") 

  caster:EmitSound(sound)

  target:AddNewModifier(caster, ability, "modifier_static_link_drain", {duration = drain_duration})
end

modifier_static_link_lua = class({
  IsHidden                = function(self) return self:GetStackCount() == 0 end,
  IsPurgable              = function(self) return false end,
  IsDebuff                = function(self) return false end,
  IsBuff                  = function(self) return true end,
  RemoveOnDeath           = function(self) return false end,
  DeclareFunctions        = function(self)
    return {
      MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
end,
})

function modifier_static_link_lua:OnCreated()
  if IsServer() then
    self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_static_link_lua_attribute", {})
    self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_static_link_lua_permanent", {})
    self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_static_link_lua_attribute_permanent", {})
    self.duration = self:GetAbility():GetSpecialValueFor("drain_duration")
    self.stack_table = {}
    self:StartIntervalThink(0.1)
  end
end

function modifier_static_link_lua:OnIntervalThink()
  if not IsServer() then return end
  local duration = self.duration
  if self:GetCaster():FindAbilityByName("npc_dota_hero_razor_agi10") then
    duration = duration * 2
  end
  if #self.stack_table > 0 then
    local repeat_needed = true
    while repeat_needed do
      if #self.stack_table > 0 and GameRules:GetGameTime() - self.stack_table[1] >= duration then
        if self:GetStackCount() == 1 then
          self:Destroy()
          break
        else
          table.remove(self.stack_table, 1)
          self:DecrementStackCount()
        end
      else
        repeat_needed = false
      end
    end
  end
  local caster = self:GetCaster()
  local ability = self:GetAbility()
  local duration = self:GetAbility():GetSpecialValueFor("drain_duration")
  if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_razor_agi50") then
    local enemies = FindUnitsInRadius(
      self:GetParent():GetTeamNumber(),	-- int, your team number
      self:GetParent():GetOrigin(),	-- point, center point
      nil,	-- handle, cacheUnit. (not known)
      600,	-- float, radius. or use FIND_UNITS_EVERYWHERE
      DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
      DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
      DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
      0,	-- int, order filter
      false	-- bool, can grow cache
    )
    if #enemies > 0 then
      for _,enemy in pairs(enemies) do
        enemy:AddNewModifier(caster, ability, "modifier_static_link_drain", {duration = duration, isProvidedByAura = 1})
      end
    end
  end
end

function modifier_static_link_lua:OnStackCountChanged(prev_stacks)
	if not IsServer() then return end
	local stacks = self:GetStackCount()
	if stacks > prev_stacks then
		table.insert(self.stack_table, GameRules:GetGameTime())
		self:ForceRefresh()
	end
end

function modifier_static_link_lua:AddLinkDamage( kv )
  if IsServer() then
    self:SetStackCount( self:GetStackCount() + kv.count )
  end
end

function modifier_static_link_lua:GetModifierPreAttack_BonusDamage()
  if self:GetCaster():FindAbilityByName("npc_dota_hero_razor_agi7") then
    return self:GetStackCount() * 0.25 * self:GetAbility():GetSpecialValueFor("drain_rate") * 2
  end
  return self:GetStackCount() * 0.25 * self:GetAbility():GetSpecialValueFor("drain_rate")
end

-- function modifier_static_link_lua:IsAura() 
-- 	return self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_razor_agi50") ~= nil
-- end

-- function modifier_static_link_lua:GetModifierAura() 
-- 	return "modifier_static_link_drain" 
-- end

-- function modifier_static_link_lua:GetAuraRadius()
-- 	return 600
-- end

-- function modifier_static_link_lua:GetAuraSearchFlags() 
-- 	return DOTA_UNIT_TARGET_FLAG_NONE 
-- end

-- function modifier_static_link_lua:GetAuraSearchTeam() 
-- 	return DOTA_UNIT_TARGET_TEAM_ENEMY 
-- end

-- function modifier_static_link_lua:GetAuraSearchType() 
-- 	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
-- end

modifier_static_link_lua_attribute = class({
  IsHidden                = function(self) return self:GetStackCount() == 0 end,
  IsPurgable              = function(self) return false end,
  IsDebuff                = function(self) return false end,
  IsBuff                  = function(self) return true end,
  RemoveOnDeath           = function(self) return false end,
  DeclareFunctions        = function(self)
    return {
      MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
      MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
      MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end,
})

function modifier_static_link_lua_attribute:OnCreated()
  if IsServer() then
    self.duration = self:GetAbility():GetSpecialValueFor("drain_duration")
    self.stack_table = {}
    self:StartIntervalThink(0.25)
  end
end

function modifier_static_link_lua_attribute:OnIntervalThink()
  if not IsServer() then return end
  if #self.stack_table > 0 then
    local repeat_needed = true
    while repeat_needed do
      local item_time = self.stack_table[1]
      if GameRules:GetGameTime() - item_time >= self.duration then
        if self:GetStackCount() == 1 then
          self:Destroy()
          break
        else
          table.remove(self.stack_table, 1)
          self:DecrementStackCount()
        end
      else
        repeat_needed = false
      end
    end
  end
end

function modifier_static_link_lua_attribute:OnStackCountChanged(prev_stacks)
	if not IsServer() then return end
	local stacks = self:GetStackCount()
	if stacks > prev_stacks then
		table.insert(self.stack_table, GameRules:GetGameTime())
		self:ForceRefresh()
	end
end

function modifier_static_link_lua_attribute:AddLinkDamage( kv )
  if IsServer() then
    self:SetStackCount( self:GetStackCount() + kv.count )
  end
end

function modifier_static_link_lua_attribute:GetModifierBonusStats_Strength()
  return self:GetStackCount() / 4
end

function modifier_static_link_lua_attribute:GetModifierBonusStats_Agility()
  return self:GetStackCount() / 4
end

function modifier_static_link_lua_attribute:GetModifierBonusStats_Intellect()
  return self:GetStackCount() / 4
end
--------------------------------------------------------------------------------

modifier_static_link_drain = class({
  IsHidden                = function(self) return self:GetStackCount() == 0 end,
  IsPurgable              = function(self) return false end,
  IsDebuff                = function(self) return true end,
  GetModifierProvidesFOWVision           = function(self) return true end,
  DeclareFunctions        = function(self)
    return {
      MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
  end,
})

function modifier_static_link_drain:OnCreated( kv )
  if not IsServer() then return end

  self.caster = self:GetCaster()
  self.target = self:GetParent()
  self.ability = self:GetAbility()
  self.maximum_damage_reduction = self:GetParent():GetAverageTrueAttackDamage(self:GetParent()) * self:GetAbility():GetSpecialValueFor("maximum_damage_reduction") / 100
  self.drain_rate = self.ability:GetSpecialValueFor("drain_rate")
  self.drain_range_buffer = self.ability:GetSpecialValueFor("drain_range_buffer")
  self.radius = self.ability:GetSpecialValueFor("radius")
  self.vision_radius = self.ability:GetSpecialValueFor("vision_radius")
  self.vision_duration = self.ability:GetSpecialValueFor("vision_duration")
  self.attribute_count = 0

  local castRange = self.ability:GetCastRange(self.caster:GetAbsOrigin(), self.target)
  self.break_range = castRange + self.drain_range_buffer

  self.soundLoop = "Ability.static.loop"
  self.isAura = kv.isProvidedByAura==1
  if self.isAura == false then
    self.caster:StopSound(self.soundLoop)
    self.caster:EmitSound(self.soundLoop)
    local particleFile = "particles/units/heroes/hero_razor/razor_static_link.vpcf"
    self.particle = ParticleManager:CreateParticle(particleFile, PATTACH_POINT_FOLLOW, self.caster)
    ParticleManager:SetParticleControlEnt(self.particle, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_static", self.caster:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(self.particle, 1, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), true)
  end

  
  if self.caster:FindAbilityByName("npc_dota_hero_razor_agi9") then
    self.target:AddNewModifier(self.caster, self.ability, "modifier_static_link_hit", {duration = self:GetDuration()})
  end
  self:StartIntervalThink(0.25)
end

function modifier_static_link_drain:OnDestroy()
  if not IsServer() then return end
  if self.isAura == false then
    local soundEnd = "Ability.static.end"

    self.caster:StopSound(self.soundLoop)
    self.caster:EmitSound(soundEnd)

    ParticleManager:DestroyParticle(self.particle, true)
  end
end

function modifier_static_link_drain:OnIntervalThink()
  if not IsServer() then return end
  local outOfRange = CalcDistanceBetweenEntityOBB(self.caster,self.target) > self.break_range
  if outOfRange or not self.caster:IsAlive() then
    self:Destroy()
  end
  local mainModifier = self:GetCaster():FindModifierByName("modifier_static_link_lua")
  local modifier_static_link_lua_permanent = self:GetCaster():FindModifierByName("modifier_static_link_lua_permanent")
  local mainModifierAttribute = self:GetCaster():FindModifierByName("modifier_static_link_lua_attribute")
  local modifier_static_link_lua_attribute_permanent = self:GetCaster():FindModifierByName("modifier_static_link_lua_attribute_permanent")
  if self:GetStackCount() * self.drain_rate * 0.25 < self.maximum_damage_reduction then
    if self:GetCaster():FindAbilityByName("npc_dota_hero_razor_agi_last") and RollPercentage(5) then
      modifier_static_link_lua_permanent:IncrementStackCount()
    else
      mainModifier:AddLinkDamage({count = 1})
    end
    self:IncrementStackCount()
  end
  if self:GetCaster():FindAbilityByName("npc_dota_hero_razor_agi8") and self.attribute_count < 4 * self:GetAbility():GetLevel() then
    if self:GetCaster():FindAbilityByName("npc_dota_hero_razor_agi_last") and RollPercentage(5) then
      modifier_static_link_lua_attribute_permanent:IncrementStackCount()
    else
      mainModifierAttribute:AddLinkDamage({count = 1})
    end
    self.attribute_count = self.attribute_count + 1
    
  end
end

function modifier_static_link_drain:GetModifierPreAttack_BonusDamage()
  return self:GetStackCount() * -0.25 * self:GetAbility():GetSpecialValueFor("drain_rate")
end

modifier_static_link_hit = class({
  IsHidden                = function(self) return false end,
  IsPurgable              = function(self) return false end,
  IsDebuff                = function(self) return true end,
})

function modifier_static_link_hit:OnCreated( kv )
  self.interval = 1 / self:GetCaster():GetAttacksPerSecond() * 3
  if self.interval > 1.5 then
    self.interval = 1.5
  end
  self:StartIntervalThink(self.interval)
end

function modifier_static_link_hit:OnIntervalThink()
  if not IsServer() then return end
  if not self:GetParent():HasModifier("modifier_static_link_drain") then
    self:Destroy()
    return
  end
  self:GetCaster():PerformAttack(self:GetParent(), true, true, true, false, true, false, false)
  self.interval = 1 / self:GetCaster():GetAttacksPerSecond() * 3
  if self.interval > 1.5 then
    self.interval = 1.5
  end
  self:StartIntervalThink(self.interval)
end

modifier_static_link_lua_permanent = class({
  IsHidden                = function(self) return self:GetStackCount() == 0 end,
  IsPurgable              = function(self) return false end,
  IsDebuff                = function(self) return false end,
  IsBuff                  = function(self) return true end,
  RemoveOnDeath           = function(self) return false end,
  DeclareFunctions        = function(self)
    return {
      MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
  end,
  GetModifierPreAttack_BonusDamage = function(self)
    if self:GetCaster():FindAbilityByName("npc_dota_hero_razor_agi7") then
      return self:GetStackCount() * 0.25 * self:GetAbility():GetSpecialValueFor("drain_rate") * 2
    end
    return self:GetStackCount() * 0.25 * self:GetAbility():GetSpecialValueFor("drain_rate")
  end,
})

modifier_static_link_lua_attribute_permanent = class({
  IsHidden                = function(self) return self:GetStackCount() == 0 end,
  IsPurgable              = function(self) return false end,
  IsDebuff                = function(self) return false end,
  IsBuff                  = function(self) return true end,
  RemoveOnDeath           = function(self) return false end,
  DeclareFunctions        = function(self)
    return {
      MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
      MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
      MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
  end,
  GetModifierBonusStats_Strength = function(self)
    return self:GetStackCount() * 0.25
  end,
  GetModifierBonusStats_Agility = function(self)
    return self:GetStackCount() * 0.25
  end,
  GetModifierBonusStats_Intellect = function(self)
    return self:GetStackCount() * 0.25
  end,
})