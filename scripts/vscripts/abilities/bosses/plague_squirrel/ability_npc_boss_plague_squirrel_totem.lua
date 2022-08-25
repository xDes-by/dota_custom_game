ability_npc_boss_plague_squirrel_totem = class({})

LinkLuaModifier( "modifier_ability_npc_boss_plague_squirrel_totem", "abilities/bosses/plague_squirrel/ability_npc_boss_plague_squirrel_totem", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_npc_boss_plague_squirrel_hit", "abilities/bosses/plague_squirrel/ability_npc_boss_plague_squirrel_totem", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_npc_boss_plague_squirrel_silense", "abilities/bosses/plague_squirrel/ability_npc_boss_plague_squirrel_totem", LUA_MODIFIER_MOTION_NONE )

function ability_npc_boss_plague_squirrel_totem:GetIntrinsicModifierName()
    return "modifier_ability_npc_boss_plague_squirrel_totem"
end

modifier_ability_npc_boss_plague_squirrel_totem = class({})

function modifier_ability_npc_boss_plague_squirrel_totem:IsHidden()
   return true
end

function modifier_ability_npc_boss_plague_squirrel_totem:IsPurgable()
   return false
end

function modifier_ability_npc_boss_plague_squirrel_totem:IsPurgeException()
    return false
end

function modifier_ability_npc_boss_plague_squirrel_totem:RemoveOnDeath()
   return true
end

function modifier_ability_npc_boss_plague_squirrel_totem:DeclareFunctions()
   return {
       MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
       MODIFIER_EVENT_ON_ATTACKED
}
end

function modifier_ability_npc_boss_plague_squirrel_totem:CheckState()
	return {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}
end

function modifier_ability_npc_boss_plague_squirrel_totem:OnCreated()
    if not IsServer() then return end
    self:GetCaster():StartGesture(ACT_DOTA_IDLE)
    self.health = self:GetAbility():GetSpecialValueFor("health")
    self:GetParent():SetBaseMaxHealth(self.health)
    self:GetParent():SetMaxHealth(self.health)
    self:GetParent():SetHealth(self.health)
    self:StartIntervalThink(1)
end

function modifier_ability_npc_boss_plague_squirrel_totem:OnIntervalThink()
    local npc = CreateUnitByName("npc_plague_squirrel", self:GetCaster():GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS )
	npc:AddNewModifier(npc, nil, "modifier_kill", {duration = 5})
    npc:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_ability_npc_boss_plague_squirrel_hit", {})
	self:StartIntervalThink(-1)
	self:StartIntervalThink(3)
end

function modifier_ability_npc_boss_plague_squirrel_totem:GetModifierIncomingDamage_Percentage(data)
    return -100
end

function modifier_ability_npc_boss_plague_squirrel_totem:OnAttacked(data)
    if not IsServer() then return end
    if data.attacker:IsRealHero() and data.target == self:GetParent() then
        self:GetParent():SetHealth( self:GetParent():GetHealth() - 1 )
        if self:GetParent():GetHealth() == 0 then 
            self:GetParent():ForceKill(false)
        end
    end
end

--------------------------------------------------------------------------------

modifier_ability_npc_boss_plague_squirrel_hit = class({})

function modifier_ability_npc_boss_plague_squirrel_hit:IsHidden()
   return true
end

function modifier_ability_npc_boss_plague_squirrel_hit:IsPurgable()
   return false
end

function modifier_ability_npc_boss_plague_squirrel_hit:IsPurgeException()
    return false
end

function modifier_ability_npc_boss_plague_squirrel_hit:RemoveOnDeath()
   return true
end

function modifier_ability_npc_boss_plague_squirrel_hit:DeclareFunctions()
   return {
       MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
       MODIFIER_EVENT_ON_ATTACKED,
       MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
	   MODIFIER_EVENT_ON_ATTACK_LANDED
}
end

function modifier_ability_npc_boss_plague_squirrel_hit:CheckState()
	return {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
end

function modifier_ability_npc_boss_plague_squirrel_hit:OnCreated()
    if not IsServer() then return end
    self.health = self:GetAbility():GetSpecialValueFor("squirrel_health")
    self:GetParent():SetBaseMaxHealth(self.health)
    self:GetParent():SetMaxHealth(self.health)
    self:GetParent():SetHealth(self.health)
    local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
    if #enemies > 0 then
		enemy = enemies[RandomInt(1, #enemies)]
		self:GetParent():SetForceAttackTarget(enemy)
	end	
end

function modifier_ability_npc_boss_plague_squirrel_hit:GetModifierIncomingDamage_Percentage(data)
    return -100
end

function modifier_ability_npc_boss_plague_squirrel_hit:OnAttacked(data)
    if not IsServer() then return end
    if data.attacker:IsRealHero() and data.target == self:GetParent() then
        self:GetParent():SetHealth( self:GetParent():GetHealth() - 1 )
        if self:GetParent():GetHealth() == 0 then 
            self:GetParent():ForceKill(false)
        end
    end
end


function modifier_ability_npc_boss_plague_squirrel_hit:OnAttackLanded(params)
    if not IsServer() then return end
	if params.attacker == self:GetParent() then
		params.target:AddNewModifier(params.attacker, nil, "modifier_ability_npc_boss_plague_squirrel_silense", {duration = 2})
		self:GetParent():ForceKill(false)
	end
end

function modifier_ability_npc_boss_plague_squirrel_hit:GetModifierMoveSpeed_Absolute()
    return 500
end

--------------------------------------------------------------------------

modifier_ability_npc_boss_plague_squirrel_silense = class({})

function modifier_ability_npc_boss_plague_squirrel_silense:IsHidden()
    return false
end

function modifier_ability_npc_boss_plague_squirrel_silense:IsDebuff()
    return true
end

function modifier_ability_npc_boss_plague_squirrel_silense:IsPurgable()
    return false
end

function modifier_ability_npc_boss_plague_squirrel_silense:RemoveOnDeath()
    return true
end

function modifier_ability_npc_boss_plague_squirrel_silense:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_ability_npc_boss_plague_squirrel_silense:OnCreated()
if not IsServer() then return end
    ApplyDamage({
	victim = self:GetParent(),
    damage = self:GetParent():GetHealth()/10,
    damage_type = DAMAGE_TYPE_MAGICAL,
    damage_flags = DOTA_DAMAGE_FLAG_NONE,
    attacker = self:GetCaster()
	})
end

function modifier_ability_npc_boss_plague_squirrel_silense:CheckState()
	return {
		[MODIFIER_STATE_BLIND] = true,
        [MODIFIER_STATE_SILENCED] = true,
        [MODIFIER_STATE_MUTED] = true,
        [MODIFIER_STATE_PASSIVES_DISABLED] = true,
	}
end