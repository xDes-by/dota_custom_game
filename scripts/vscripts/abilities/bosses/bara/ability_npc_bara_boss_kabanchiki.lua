ability_npc_bara_boss_kabanchiki = class({})

LinkLuaModifier("modifier_kabanchiki", "abilities/bosses/bara/ability_npc_bara_boss_kabanchiki", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kabanchiki_aura_effect", "abilities/bosses/bara/ability_npc_bara_boss_kabanchiki", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bara_boss_danser", "abilities/bosses/bara/ability_npc_bara_boss_kabanchiki", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kabanchiki_inacive", "abilities/bosses/bara/ability_npc_bara_boss_kabanchiki", LUA_MODIFIER_MOTION_NONE)

function ability_npc_bara_boss_kabanchiki:OnOwnerDied()
    if self.kabanchiki ~= nil then
        for i,unit in pairs(self.kabanchiki) do
            UTIL_Remove(unit)
        end
    end
end

function ability_npc_bara_boss_kabanchiki:OnSpellStart()
    if self.kabanchiki == nil then
        self.kabanchiki = {}
        local count = self:GetSpecialValueFor("count")
        local pos = self:GetCaster():GetAbsOrigin()
        for i = 1, count do
            local unit = CreateUnitByName("npc_bara_boss_kabanchik", pos, false, nil, nil, self:GetCaster():GetTeamNumber())
            table.insert( self.kabanchiki, unit )
        end
    end
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_bara_boss_danser", {duration = self:GetSpecialValueFor("duration") + 1.5})
    local fv = self:GetCaster():GetForwardVector()
    for i,unit in pairs(self.kabanchiki) do
        unit:AddNewModifier(self:GetCaster(), self, "modifier_kabanchiki", {duration = self:GetSpecialValueFor("duration") + i / #self.kabanchiki, delay = i / #self.kabanchiki})
        unit:SetForwardVector(fv)
    end
end

modifier_kabanchiki = class({})
--Classifications template
function modifier_kabanchiki:IsHidden()
    return true
end

function modifier_kabanchiki:IsDebuff()
    return false
end

function modifier_kabanchiki:IsPurgable()
    return false
end

function modifier_kabanchiki:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_kabanchiki:IsStunDebuff()
    return false
end

function modifier_kabanchiki:RemoveOnDeath()
    return true
end

function modifier_kabanchiki:DestroyOnExpire()
    return true
end

function modifier_kabanchiki:OnCreated(data)
    if not IsServer() then return end
    self.parent = self:GetParent()
    self.current_radius = self:GetAbility():GetSpecialValueFor("start_radius")
    self.end_radius = self:GetAbility():GetSpecialValueFor("end_radius")
    self.uncreased_radius = (self.end_radius - self.current_radius) / self:GetDuration() * FrameTime()
    self.counter = 0 
    if data.delay then
        self.delay = true
        self:StartIntervalThink(data.delay)
        return
    end
    local m = self.parent:FindModifierByName("modifier_kabanchiki_inacive")
    if m then
        m:Destroy()
    end
    self:StartIntervalThink(FrameTime())
    self:OnIntervalThink()
end

function modifier_kabanchiki:OnDestroy()
    if not IsServer() then return end
    self:GetParent():AddNewModifier(self:GetCaster(), self, "modifier_kabanchiki_inacive", {})
end

function modifier_kabanchiki:OnIntervalThink()
    if self.delay then
        self.delay = false
        local m = self.parent:FindModifierByName("modifier_kabanchiki_inacive")
        if m then
            m:Destroy()
        end
        self:StartIntervalThink(FrameTime())
    end
    local pos = self:GetCaster():GetAbsOrigin()
    local fv = self.parent:GetForwardVector()
    local origin = RotatePosition(Vector(0, 0, 0), QAngle(0, 360 * FrameTime() * self.counter, 0), fv * self.current_radius) + pos
    self.parent:SetAbsOrigin(origin)
    self.parent:FaceTowards(self:GetCaster():GetAbsOrigin())
    self.current_radius = self.current_radius + self.uncreased_radius
    self.counter = self.counter + 1
end

function modifier_kabanchiki:CheckState()
    return {
        [MODIFIER_STATE_UNTARGETABLE] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        -- [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
        [MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        -- [MODIFIER_STATE_INVISIBLE] = true,
        [MODIFIER_STATE_ATTACK_IMMUNE] = true,
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        -- [MODIFIER_STATE_OUT_OF_GAME] = true
    }   
end

function modifier_kabanchiki:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }
end

function modifier_kabanchiki:GetOverrideAnimation()
    return ACT_DOTA_RUN
end


--------------------------------------------------------------------------------
-- Aura Effects
function modifier_kabanchiki:IsAura()
    return true
end

function modifier_kabanchiki:GetModifierAura()
    return "modifier_kabanchiki_aura_effect"
end

function modifier_kabanchiki:GetAuraRadius()
    return 150
end

function modifier_kabanchiki:GetAuraDuration()
    return 0.01
end

function modifier_kabanchiki:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_kabanchiki:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO
end

function modifier_kabanchiki:GetAuraSearchFlags()
    return 0
end

modifier_kabanchiki_aura_effect = class({})
--Classifications template
function modifier_kabanchiki_aura_effect:IsHidden()
    return true
end

function modifier_kabanchiki_aura_effect:IsDebuff()
    return false
end

function modifier_kabanchiki_aura_effect:IsPurgable()
    return false
end

function modifier_kabanchiki_aura_effect:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_kabanchiki_aura_effect:IsStunDebuff()
    return false
end

function modifier_kabanchiki_aura_effect:RemoveOnDeath()
    return true
end

function modifier_kabanchiki_aura_effect:DestroyOnExpire()
    return true
end

function modifier_kabanchiki_aura_effect:OnCreated()
    if not IsServer() then
        return
    end
    local target = self:GetParent()
    self.parent = self:GetCaster()
    self.ability = self:GetAbility()
	local direction = target:GetOrigin()-self.parent:GetOrigin()
	direction.z = 0
	direction = direction:Normalized()

	-- create arc
	target:AddNewModifier(self.parent,self.ability,"modifier_generic_arc_lua",
		{dir_x = direction.x,dir_y = direction.y,duration = 0.5,distance = 50,height = 50,activity = ACT_DOTA_FLAIL})

	-- stun
	target:AddNewModifier(self.parent, self.ability, "modifier_stunned", {duration = 0.3})

	-- calculate damage
	local damage = self:GetParent():GetHealth() * 0.03

	-- apply damage
	local damageTable = {
		victim = target,
		attacker = self.parent,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self.ability
	}
    ApplyDamage(damageTable)

    local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf", PATTACH_POINT_FOLLOW, target )
    ParticleManager:SetParticleControlEnt(effect_cast,0,target,PATTACH_POINT_FOLLOW,"attach_hitloc",Vector(0,0,0),true)
    ParticleManager:ReleaseParticleIndex( effect_cast )

    EmitSoundOn( "Hero_Spirit_Breaker.GreaterBash", target )
end







modifier_kabanchiki_inacive = class({})
--Classifications template
function modifier_kabanchiki_inacive:IsHidden()
    return true
end

function modifier_kabanchiki_inacive:IsDebuff()
    return false
end

function modifier_kabanchiki_inacive:IsPurgable()
    return false
end

function modifier_kabanchiki_inacive:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_kabanchiki_inacive:IsStunDebuff()
    return false
end

function modifier_kabanchiki_inacive:RemoveOnDeath()
    return false
end

function modifier_kabanchiki_inacive:DestroyOnExpire()
    return true
end

function modifier_kabanchiki_inacive:OnCreated()
    if not IsServer() then
        return
    end
    self:GetParent():AddNoDraw()
end

function modifier_kabanchiki_inacive:OnDestroy()
    if not IsServer() then
        return
    end
    self:GetParent():RemoveNoDraw()
end

function modifier_kabanchiki_inacive:CheckState()
    return {
        [MODIFIER_STATE_UNTARGETABLE] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
        [MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_INVISIBLE] = true,
        [MODIFIER_STATE_ATTACK_IMMUNE] = true,
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_OUT_OF_GAME] = true
    }   
end












modifier_bara_boss_danser = class({})
--Classifications template
function modifier_bara_boss_danser:IsHidden()
    return true
end

function modifier_bara_boss_danser:IsDebuff()
    return false
end

function modifier_bara_boss_danser:IsPurgable()
    return false
end

function modifier_bara_boss_danser:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_bara_boss_danser:IsStunDebuff()
    return false
end

function modifier_bara_boss_danser:RemoveOnDeath()
    return true
end

function modifier_bara_boss_danser:DestroyOnExpire()
    return true
end

function modifier_bara_boss_danser:OnCreated()
    if not IsServer() then
        return
    end
    self:GetParent():StartGesture(ACT_DOTA_TELEPORT)
end

function modifier_bara_boss_danser:OnDestroy()
    if not IsServer() then
        return
    end
    self:GetParent():RemoveGesture(ACT_DOTA_TELEPORT)
end

function modifier_bara_boss_danser:CheckState()
    return {
        [MODIFIER_STATE_UNTARGETABLE] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        -- [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
        [MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        -- [MODIFIER_STATE_INVISIBLE] = true,
        [MODIFIER_STATE_ATTACK_IMMUNE] = true,
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        -- [MODIFIER_STATE_OUT_OF_GAME] = true
    }   
end