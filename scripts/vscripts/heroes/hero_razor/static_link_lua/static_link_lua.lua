static_link_lua = static_link_lua or class({})
LinkLuaModifier("modifier_static_link_drain", "heroes/hero_razor/static_link_lua/static_link_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_static_link_lua", "heroes/hero_razor/static_link_lua/static_link_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_static_link_lua_attribute", "heroes/hero_razor/static_link_lua/static_link_lua.lua", LUA_MODIFIER_MOTION_NONE)

function static_link_lua:GetIntrinsicModifierName()
  return "modifier_static_link_lua"
end

function static_link_lua:GetBehavior()
  if self:GetCaster():FindAbilityByName("npc_dota_hero_razor_agi_last") then
    return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
  end
end

function static_link_lua:OnSpellStart(target)
  local ability = self
  local caster = self:GetCaster()
  local interval = 0.25
  if target then 
    interval = interval * 1.4
  end
  target = target or self:GetCursorTarget()

  local soundStart = "Ability.static.start"
  
  local drain_duration = self:GetSpecialValueFor("drain_duration")  

  caster:EmitSound(sound)

  target:AddNewModifier(caster, ability, "modifier_static_link_drain", {duration = drain_duration, interval = interval})
end


modifier_static_link_lua = class({
  IsHidden                = function(self) return false end,
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
    self.duration = self:GetAbility():GetSpecialValueFor("drain_duration")
    self.stack_table = {}
    self:StartIntervalThink(0.1)
  end
end

function modifier_static_link_lua:OnIntervalThink()
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

  if self:GetCaster():FindAbilityByName("npc_dota_hero_razor_agi_last") and self:GetAbility():GetAutoCastState() and self:GetAbility():IsFullyCastable() then
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
        link_drain = enemy:FindModifierByName("modifier_static_link_drain")
        if not link_drain or link_drain:GetStackCount() < link_drain.maximum_damage_reduction then
          self:GetAbility():OnSpellStart(enemy)
          local min_value = 1.5
          local max_value = 5
          self:GetAbility():StartCooldown( max_value - self:GetAbility():GetLevel() * ((max_value - min_value) / 15) )
          break
        end
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
    if self:GetCaster():FindAbilityByName("npc_dota_hero_razor_agi9") then
      self:SetStackCount( self:GetStackCount() + kv.count * 2 )
      return
    end
    self:SetStackCount( self:GetStackCount() + kv.count )
  end
end

function modifier_static_link_lua:GetModifierPreAttack_BonusDamage()
  return self:GetStackCount()
end



modifier_static_link_lua_attribute = class({
  IsHidden                = function(self) return false end,
  IsPurgable              = function(self) return false end,
  IsDebuff                = function(self) return false end,
  IsBuff                  = function(self) return true end,
  RemoveOnDeath           = function(self) return false end,
  DeclareFunctions        = function(self)
    return {
      MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
      MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
      MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
      MODIFIER_PROPERTY_TOOLTIP,
    }
end,
OnTooltip               = function(self) return self:GetStackCount() / 20 / 100 * self:GetAbility():GetLevel() / 0.15 end,
})

function modifier_static_link_lua_attribute:OnCreated()
  if IsServer() then
    self.duration = self:GetAbility():GetSpecialValueFor("drain_duration")
    self.stack_table = {}
    self:StartIntervalThink(0.1)
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
  return self:GetStackCount() / 20 / 100 * self:GetAbility():GetLevel() / 0.15
end

function modifier_static_link_lua_attribute:GetModifierBonusStats_Agility()
  return self:GetStackCount() / 20 / 100 * self:GetAbility():GetLevel() / 0.15
end

function modifier_static_link_lua_attribute:GetModifierBonusStats_Intellect()
  return self:GetStackCount() / 20 / 100 * self:GetAbility():GetLevel() / 0.15
end
--------------------------------------------------------------------------------

modifier_static_link_drain = class({
  IsHidden                = function(self) return false end,
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

  self.caster:StopSound(self.soundLoop)
  self.caster:EmitSound(self.soundLoop)

  local particleFile = "particles/units/heroes/hero_razor/razor_static_link.vpcf"
  self.particle = ParticleManager:CreateParticle(particleFile, PATTACH_POINT_FOLLOW, self.caster)
  ParticleManager:SetParticleControlEnt(self.particle, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_static", self.caster:GetAbsOrigin(), true)
  ParticleManager:SetParticleControlEnt(self.particle, 1, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), true)
  
  self.interval = kv.interval
  self:StartIntervalThink(self.interval)
end

function modifier_static_link_drain:OnDestroy()
  if not IsServer() then return end

  local soundEnd = "Ability.static.end"

  self.caster:StopSound(self.soundLoop)
  self.caster:EmitSound(soundEnd)

  ParticleManager:DestroyParticle(self.particle, true)
end

function modifier_static_link_drain:OnIntervalThink()
  if not IsServer() then return end

  local outOfRange = CalcDistanceBetweenEntityOBB(self.caster,self.target) > self.break_range
  if outOfRange or not self.caster:IsAlive() or not self.target:IsAlive() then
    self:Destroy()
  end
  local mainModifier = self:GetCaster():FindModifierByName("modifier_static_link_lua")
  local mainModifierAttribute = self:GetCaster():FindModifierByName("modifier_static_link_lua_attribute")
  local damage_count = self.drain_rate * 0.25
  if self:GetStackCount() + damage_count >= self.maximum_damage_reduction then
    mainModifier:AddLinkDamage({count = self.maximum_damage_reduction - self:GetStackCount()})
    self:SetStackCount( self.maximum_damage_reduction )
  else
    mainModifier:AddLinkDamage({count = damage_count})
    self:SetStackCount( self:GetStackCount() + damage_count )
  end
  if self:GetCaster():FindAbilityByName("npc_dota_hero_razor_agi8") and self.attribute_count < 20 then
    self.attribute_count = self.attribute_count + 1
    mainModifierAttribute:AddLinkDamage({count = 1})
  end
  -- local damageTable = {
  --   victim = self.target,
  --   damage = self.drain_rate,
  --   damage_type = DAMAGE_TYPE_MAGICAL,
  --   attacker = self.caster,
  --   ability = self.ability
  -- }

  -- local damageDealt = ApplyDamage(damageTable)
  
end

function modifier_static_link_drain:GetModifierPreAttack_BonusDamage()
  return -self:GetStackCount()
end