ability_npc_swamp_boss = class({})

LinkLuaModifier( "modifier_ability_npc_swamp_boss_ice_blast", "abilities/bosses/swamp/ability_npc_swamp_boss", LUA_MODIFIER_MOTION_NONE )

function ability_npc_swamp_boss:OnSpellStart()
    local radius = 0
    local caster = self:GetCaster()
    local abi = self
    local targets = {}
	self.nova_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_venomancer/venomancer_poison_nova.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	-- ParticleManager:SetParticleControlEnt(self.nova_particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(self.nova_particle, 1, Vector(900, 2, 550))
    Timers:CreateTimer(0.03,function()
        local units = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
        for _,u in pairs(units) do
            if not targets[u] then
                u:AddNewModifier(caster, abi, "modifier_ability_npc_swamp_boss_ice_blast", {duration = 10})
            end
        end
        radius = radius + 20
        if radius > 900 then
            return
        end
        return 0.03
    end)
end

modifier_ability_npc_swamp_boss_ice_blast = class({})

function modifier_ability_npc_swamp_boss_ice_blast:IsDebuff()		return true end
function modifier_ability_npc_swamp_boss_ice_blast:IsPurgable()	return false end

function modifier_ability_npc_swamp_boss_ice_blast:GetEffectName()
	return "particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_debuff.vpcf"
end

function modifier_ability_npc_swamp_boss_ice_blast:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost.vpcf"
end

function modifier_ability_npc_swamp_boss_ice_blast:OnCreated(params)
	if not IsServer() then return end
	
	self.dot_damage		= self:GetParent():GetHealth() * 0.01
	self.kill_pct		= 20
	self.caster = self:GetCaster()
	
	self.damage_table	= {
		victim 			= self:GetParent(),
		damage 			= self.dot_damage,
		damage_type		= DAMAGE_TYPE_MAGICAL,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self.caster,
		ability 		= self:GetAbility()
	}
	
	self:StartIntervalThink(1)
end

function modifier_ability_npc_swamp_boss_ice_blast:OnIntervalThink()
	self:GetParent():EmitSound("Hero_Ancient_Apparition.IceBlastRelease.Tick")

	ApplyDamage(self.damage_table)
	
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), self.dot_damage, nil)
	if self:GetParent():GetHealthPercent() < 10 then
		self:GetParent():Kill(self:GetAbility(), self:GetCaster())
	end
end

function modifier_ability_npc_swamp_boss_ice_blast:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_DISABLE_HEALING
	}
end

function modifier_ability_npc_swamp_boss_ice_blast:GetDisableHealing()
	return 1
end