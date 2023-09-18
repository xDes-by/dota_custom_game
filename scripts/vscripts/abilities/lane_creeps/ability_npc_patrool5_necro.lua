ability_npc_patrool5_necro = class({})

function ability_npc_patrool5_necro:GetIntrinsicModifierName()
    return "modifier_ability_npc_patrool5_necro"
end

modifier_ability_npc_patrool5_necro = class({})

LinkLuaModifier("modifier_ability_npc_patrool5_necro", "abilities/lane_creeps/ability_npc_patrool5_necro.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ability_npc_patrool5_necro_effect", "abilities/lane_creeps/ability_npc_patrool5_necro.lua", LUA_MODIFIER_MOTION_NONE)

--Classifications template
function modifier_ability_npc_patrool5_necro:IsHidden()
    return true
end

function modifier_ability_npc_patrool5_necro:IsDebuff()
    return false
end

function modifier_ability_npc_patrool5_necro:IsPurgable()
    return false
end

function modifier_ability_npc_patrool5_necro:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_ability_npc_patrool5_necro:IsStunDebuff()
    return false
end

function modifier_ability_npc_patrool5_necro:RemoveOnDeath()
    return false
end

function modifier_ability_npc_patrool5_necro:DestroyOnExpire()
    return false
end

function modifier_ability_npc_patrool5_necro:OnCreated()
    self.parent = self:GetParent()
    self.min_radius = 300
    self.damage_reflect_pct = 0.1
    if not IsServer() then
        return
    end
    self.pos = self.parent:GetAbsOrigin()
    local fv = self.parent:GetForwardVector() * 400
    self:StartIntervalThink(0.1)
end

function modifier_ability_npc_patrool5_necro:OnIntervalThink()
    local pos = self.parent:GetAbsOrigin()
	local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(), pos, nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, FIND_CLOSEST, false)
    for _,unit in pairs(enemies) do
        if not unit:HasModifier("modifier_ability_npc_patrool5_necro_effect") then
            local p = ParticleManager:CreateParticle("particles/econ/items/phoenix/phoenix_solar_forge/phoenix_sunray_solar_forge.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
            ParticleManager:SetParticleControlEnt(p, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", pos, true)
            ParticleManager:SetParticleControl(p, 1, unit:GetAbsOrigin())
            unit:AddNewModifier(self.parent, self:GetAbility(), "modifier_ability_npc_patrool5_necro_effect", {particle = p})
        end
    end
end

function modifier_ability_npc_patrool5_necro:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
    }
end

function modifier_ability_npc_patrool5_necro:OnTakeDamage(event)
	if event.unit == self:GetParent() then
		if event.damage_flags ~= 16 then
			local post_damage = event.damage
			local original_damage = event.original_damage
			
			local unit = event.attacker
			if unit:GetTeam() ~= self:GetParent():GetTeam() then
				local vparent = self:GetParent():GetAbsOrigin()
				local vUnit = unit:GetAbsOrigin()

				local reflect_damage = 0.0
				local particle_name = ""

				local distance = (vUnit - vparent):Length2D()
				--Within 300 radius		
				if distance <= self.min_radius then
					reflect_damage = original_damage * self.damage_reflect_pct
					particle_name = "particles/units/heroes/hero_spectre/spectre_dispersion.vpcf"
					if self:GetParent():IsAlive() then
						self:GetParent():SetHealth(self:GetParent():GetHealth() + (post_damage * self.damage_reflect_pct) )
					end
				--Between 301 and 475 radius
				else
					local ratio = self.damage_reflect_pct * (1 - (distance - self.min_radius) * 0.142857 * 0.01)
					reflect_damage = original_damage *  ratio
					particle_name = "particles/units/heroes/hero_spectre/spectre_dispersion_b_fallback_mid.vpcf"
					if self:GetParent():IsAlive() then
						self:GetParent():SetHealth(self:GetParent():GetHealth() + (post_damage * ratio) )
					end
				end
				
				--Create particle
				local particle = ParticleManager:CreateParticle( particle_name, PATTACH_POINT_FOLLOW, self:GetParent() )
				ParticleManager:SetParticleControl(particle, 0, vparent)
				ParticleManager:SetParticleControl(particle, 1, vUnit)
				ParticleManager:SetParticleControl(particle, 2, vparent)	
				ApplyDamage({
					ability = self:GetAbility(),
					attacker = self:GetParent(),
					damage = reflect_damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL,
					victim = unit,
				})

			end
		end
	end
end

function modifier_ability_npc_patrool5_necro:GetModifierProcAttack_Feedback(data)
    data.target:AddNewModifier(self.parent, self:GetAbility(), "modifier_hexxed", {duration = 1.8})
end

modifier_ability_npc_patrool5_necro_effect = class({})
--Classifications template
function modifier_ability_npc_patrool5_necro_effect:IsHidden()
    return true
end

function modifier_ability_npc_patrool5_necro_effect:IsDebuff()
    return true
end

function modifier_ability_npc_patrool5_necro_effect:IsPurgable()
    return false
end

function modifier_ability_npc_patrool5_necro_effect:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_ability_npc_patrool5_necro_effect:IsStunDebuff()
    return true
end

function modifier_ability_npc_patrool5_necro_effect:RemoveOnDeath()
    return true
end

function modifier_ability_npc_patrool5_necro_effect:DestroyOnExpire()
    return true
end

function modifier_ability_npc_patrool5_necro_effect:OnCreated(data)
    self.parent = self:GetParent()
    self.caster = self:GetCaster()
    if not IsServer() then
        return
    end
    self.particle = data.particle
    self:SetHasCustomTransmitterData( true )
    self:StartIntervalThink(0.03)
end

function modifier_ability_npc_patrool5_necro_effect:OnIntervalThink()
    if (self.parent:GetOrigin() - self.caster:GetOrigin()):Length2D() > 900 or not self.caster:IsAlive() then
        self:Destroy()
    end
    ParticleManager:SetParticleControl(self.particle, 1, self.parent:GetAbsOrigin())
    ApplyDamage({
        victim = self.parent,
        attacker = self.caster,
        damage = self.parent:GetMaxHealth() * 0.002,
        damage_type = DAMAGE_TYPE_MAGICAL,
        damage_flags = 0,
        ability = self:GetAbility()
    })
end

function modifier_ability_npc_patrool5_necro_effect:OnDestroy()
    ParticleManager:DestroyParticle(self.particle, false)
end

function modifier_ability_npc_patrool5_necro_effect:AddCustomTransmitterData()
    return {
        particle = self.particle
    }
end

function modifier_ability_npc_patrool5_necro_effect:HandleCustomTransmitterData( data )
    self.particle = data.particle
end
