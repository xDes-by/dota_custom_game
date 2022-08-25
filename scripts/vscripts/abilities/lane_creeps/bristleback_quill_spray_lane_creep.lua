bristleback_quill_spray_lane_creep = class({})

LinkLuaModifier( "modifier_bristleback_quill_spray_lane_creep", "abilities/lane_creeps/bristleback_quill_spray_lane_creep", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bristleback_quill_spray_lane_creep_stack", "abilities/lane_creeps/bristleback_quill_spray_lane_creep", LUA_MODIFIER_MOTION_NONE )

function bristleback_quill_spray_lane_creep:OnSpellStart()
    local radius = self:GetSpecialValueFor("radius")
    local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
    for _,unit in pairs(enemies) do
        unit:AddNewModifier(self:GetCaster(), self, "modifier_bristleback_quill_spray_lane_creep", {})
    end
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_bristleback/bristleback_quill_spray.vpcf", PATTACH_ABSORIGIN, self:GetCaster() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( "Hero_Bristleback.QuillSpray.Cast", self:GetCaster() )
end

modifier_bristleback_quill_spray_lane_creep = class({})
--Classifications template
function modifier_bristleback_quill_spray_lane_creep:IsHidden()
    return false
end

function modifier_bristleback_quill_spray_lane_creep:IsDebuff()
    return true
end

function modifier_bristleback_quill_spray_lane_creep:IsPurgable()
    return false
end

function modifier_bristleback_quill_spray_lane_creep:RemoveOnDeath()
    return true
end

function modifier_bristleback_quill_spray_lane_creep:OnCreated()
    if IsClient() then
        return
    end
    self.duration = self:GetAbility():GetSpecialValueFor("quill_stack_duration")
    self:SetStackCount(0)
    self:IncrementStackCount()
end

function modifier_bristleback_quill_spray_lane_creep:OnRefresh()
    if IsClient() then
        return
    end
    ApplyDamage({victim = self:GetParent(),
    damage = self:GetAbility():GetSpecialValueFor("quill_stack_damage") + self:GetAbility():GetSpecialValueFor("quill_stack_damage") * self:GetStackCount(),
    damage_type = DAMAGE_TYPE_PHYSICAL,
    damage_flags = DOTA_DAMAGE_FLAG_NONE,
    attacker = self:GetCaster(),
    ability = self:GetAbility()})
    self:SetDuration(self.duration, true)
    self:IncrementStackCount()
end