LinkLuaModifier("modifier_shopkeeper2_aura", "modifiers/modifier_shopkeeper2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shop2", "modifiers/modifier_shopkeeper2.lua", LUA_MODIFIER_MOTION_NONE)

modifier_shopkeeper2 = class({})

function modifier_shopkeeper2:DeclareFunctions()
    local funcs = {
        --MODIFIER_PROPERTY_DISABLE_AUTOATTACK,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
        MODIFIER_PROPERTY_MIN_HEALTH,
    }

    return funcs
end

function modifier_shopkeeper2:CheckState()
  local state = {
    [MODIFIER_STATE_UNSELECTABLE] = true,
    [MODIFIER_STATE_INVULNERABLE] = true,
    [MODIFIER_STATE_MAGIC_IMMUNE] = true,
    [MODIFIER_STATE_ATTACK_IMMUNE] = true,
    [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
    [MODIFIER_STATE_NO_HEALTH_BAR] = true,
    [MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
  }

  return state
end

function modifier_shopkeeper2:GetAbsoluteNoDamageMagical()
  return 1
end

function modifier_shopkeeper2:GetAbsoluteNoDamagePhysical()
  return 1
end

function modifier_shopkeeper2:GetAbsoluteNoDamagePure()
  return 1
end

function modifier_shopkeeper2:GetMinHealth()
  return 1
end

function modifier_shopkeeper2:IsHidden()
    return false--true
end



modifier_shop2 = class({})       --Аура магазина

function modifier_shop2:IsAura()
  return true
end

function modifier_shop2:GetModifierAura()
  return "modifier_shopkeeper2_aura"
end

function modifier_shop2:GetAuraRadius()
  return 300
end

function modifier_shop2:GetAuraSearchType()
  return DOTA_UNIT_TARGET_HERO
end

function modifier_shop2:GetAuraSearchTeam()
  return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_shop2:GetAuraDuration()
  return 0.2
end


modifier_shopkeeper2_aura = class({})

function modifier_shopkeeper2_aura:IsHidden()
  return true
end

function modifier_shopkeeper2_aura:OnCreated(t) --вызов активации магазина
  if IsServer() then
   		self.pid = self:GetParent():GetPlayerOwnerID()
	--	self:GetParent().res['activeshops'][self:GetCaster():GetUnitName()] = true
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.pid),"ActivateShop2",{name = self:GetCaster():GetUnitName()})
		--print(self:GetCaster():GetUnitName())
  end
end

function modifier_shopkeeper2_aura:OnDestroy(t) --соответсвенно деактивации
  if IsServer() then
   	--	self:GetParent().res['activeshops'][self:GetCaster():GetUnitName()] = false
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.pid),"DeactivateShop2",{})
  end
end