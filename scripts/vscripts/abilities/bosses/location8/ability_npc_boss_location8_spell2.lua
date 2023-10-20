ability_npc_boss_location8_spell2 = class({})

LinkLuaModifier( "modifier_generic_knockback_lua", "heroes/generic/modifier_generic_knockback_lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_ability_npc_boss_location8_spell2", "abilities/bosses/location8/ability_npc_boss_location8_spell2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_npc_boss_location8_spell2_effect", "abilities/bosses/location8/ability_npc_boss_location8_spell2", LUA_MODIFIER_MOTION_NONE )

function ability_npc_boss_location8_spell2:Precache(context)
    PrecacheResource( "particle", "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_selfcast.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_buff.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_receive.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_landing.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_mars/mars_spear_burning_trail.vpcf", context )
end

function ability_npc_boss_location8_spell2:OnSpellStart()
    local distance = self:GetSpecialValueFor("distance") - 200
    local height = 200
    local duration = 0.3
	
	if IsServer() then 
	count = 5
	
	Timers:CreateTimer(0, function()
		count = count - 1
		
		local angle = self:GetCaster():GetAngles()
		local new_angle = RotateOrientation(angle, QAngle(0,72*count,0))
		self:GetCaster():SetAngles(new_angle[1], new_angle[2], new_angle[3])
	
		local forvard = self:GetCaster():GetForwardVector()
		local stun_duration = self:GetSpecialValueFor("stun_duration")
		local jump_damage = self:GetSpecialValueFor("jump_damage")
		local fire_tail_duration = self:GetSpecialValueFor("fire_tail_duration") + 0.5
		local end_pos = self:GetCaster():GetAbsOrigin() + forvard * distance
		local start_pos = self:GetCaster():GetAbsOrigin()
		local stun_radius = self:GetSpecialValueFor("stun_radius")
		local mod = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_generic_knockback_lua", {distance = distance, height = height, duration = duration, direction_x = forvard.x, direction_y = forvard.y, IsStun = true})
		
		local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_selfcast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:ReleaseParticleIndex( effect_cast )

		local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:ReleaseParticleIndex( effect_cast )

		local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_receive.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		EmitSoundOn( "Hero_Snapfire.FeedCookie.Consume", self:GetCaster() )
		local npc = CreateModifierThinker(self:GetCaster(), self, "modifier_ability_npc_boss_location8_spell2", {duration = 3}, end_pos, self:GetCaster():GetTeamNumber(), false)
		local func = function()
			ParticleManager:DestroyParticle(effect_cast, false)
			local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, stun_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
			for _,unit in ipairs(enemies) do
				unit:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = stun_duration})
				ApplyDamage({victim = unit,
				damage = jump_damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				damage_flags = DOTA_DAMAGE_FLAG_NONE,
				attacker = self:GetCaster(),
				ability = self})
			end
			local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_landing.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
			ParticleManager:SetParticleControl( effect_cast, 1, Vector( 300, 300, 300 ) )
			ParticleManager:ReleaseParticleIndex( effect_cast )
			EmitSoundOn( "Hero_Snapfire.FeedCookie.Impact", target )
			self.active = true
			npc:FindModifierByName("modifier_ability_npc_boss_location8_spell2"):Active()
		end
		if mod then
			mod:SetEndCallback( func )
		end
		if count > 0 then
			return 0.5
		else
			return nil
		end
		
		end)
	end
end

modifier_ability_npc_boss_location8_spell2 = class({})

function modifier_ability_npc_boss_location8_spell2:Active()
    local loc = self:GetParent():GetOrigin()
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_snapfire/hero_snapfire_ultimate_impact.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 3, loc )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_snapfire/hero_snapfire_ultimate_linger.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, loc )
	ParticleManager:SetParticleControl( effect_cast, 1, loc )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOnLocationWithCaster( loc, "Hero_Snapfire.MortimerBlob.Impact", self:GetCaster() )
    self.aura = true
end

function modifier_ability_npc_boss_location8_spell2:OnDestroy()
    UTIL_Remove(self:GetParent())
end

-- Aura template
function modifier_ability_npc_boss_location8_spell2:IsAura()
    return self.aura
end

function modifier_ability_npc_boss_location8_spell2:GetModifierAura()
    return "modifier_ability_npc_boss_location8_spell2_effect"
end

function modifier_ability_npc_boss_location8_spell2:GetAuraRadius()
    return 300
end

function modifier_ability_npc_boss_location8_spell2:GetAuraDuration()
    return 0.5
end

function modifier_ability_npc_boss_location8_spell2:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_ability_npc_boss_location8_spell2:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_ability_npc_boss_location8_spell2:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

modifier_ability_npc_boss_location8_spell2_effect = class({})
--Classifications template
function modifier_ability_npc_boss_location8_spell2_effect:IsHidden()
    return false
end

function modifier_ability_npc_boss_location8_spell2_effect:IsDebuff()
    return true
end

function modifier_ability_npc_boss_location8_spell2_effect:IsPurgable()
    return true
end

function modifier_ability_npc_boss_location8_spell2_effect:RemoveOnDeath()
    return true
end

function modifier_ability_npc_boss_location8_spell2_effect:DestroyOnExpire()
    return true
end

function modifier_ability_npc_boss_location8_spell2_effect:OnCreated()
    if IsClient() then
        return
    end
    self.damage = self:GetAbility():GetSpecialValueFor("fire_tail_damage")
    self.slow = self:GetAbility():GetSpecialValueFor("slow")
    self:StartIntervalThink(0.1)
end

function modifier_ability_npc_boss_location8_spell2_effect:OnIntervalThink()
    ApplyDamage({
	victim = self:GetParent(),
    damage = self:GetParent():GetHealth() * self.damage / 100,
    damage_type = DAMAGE_TYPE_MAGICAL,
    damage_flags = DOTA_DAMAGE_FLAG_NONE,
    attacker = self:GetCaster(),
    ability = self:GetAbility()})
end