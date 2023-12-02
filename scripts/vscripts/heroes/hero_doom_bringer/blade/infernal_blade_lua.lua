ability_infernal_blade_lua = class({})

LinkLuaModifier( "modifier_ability_infernal_blade_attack", 'heroes/hero_doom_bringer/blade/infernal_blade_lua.lua', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_infernal_blade_stun", 'heroes/hero_doom_bringer/blade/infernal_blade_lua.lua', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_infernal_blade_lua", 'heroes/hero_doom_bringer/blade/infernal_blade_lua.lua', LUA_MODIFIER_MOTION_NONE )

function ability_infernal_blade_lua:GetIntrinsicModifierName()
	return "modifier_ability_infernal_blade_lua"
end
function ability_infernal_blade_lua:GetManaCost(iLevel)
    return 50 + math.min(65000, self:GetCaster():GetIntellect() / 200)
end
function ability_infernal_blade_lua:GetCooldown(level)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_doom_bringer_int10") then
		return 4
	end
    return self.BaseClass.GetCooldown( self, level )
end

modifier_ability_infernal_blade_lua = class({})

modifier_ability_infernal_blade_attack = class({})

modifier_ability_infernal_blade_stun = class({})

function modifier_ability_infernal_blade_lua:RemoveOnDeath()
	return false
end

function modifier_ability_infernal_blade_lua:IsHidden()
	return true
end

function modifier_ability_infernal_blade_lua:IsDebuff()
	return false
end

function modifier_ability_infernal_blade_lua:IsPurgable()
	return false
end

function modifier_ability_infernal_blade_lua:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
	}
end

function modifier_ability_infernal_blade_lua:GetModifierOverrideAbilitySpecial(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "burn_damage" then
			return 1
		end
		if data.ability_special_value == "burn_duration" then
			return 1
		end
		if data.ability_special_value == "burn_damage_pct" then
			return 1
		end
	end
	return 0
end

function modifier_ability_infernal_blade_lua:GetModifierOverrideAbilitySpecialValue(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "burn_damage" then
			local burn_damage = self:GetAbility():GetLevelSpecialValueNoOverride( "burn_damage", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_doom_bringer_str7") then
                burn_damage = burn_damage + self:GetCaster():GetStrength() * 0.5
            end
			if self:GetCaster():FindAbilityByName("npc_dota_hero_doom_bringer_int13") then
				burn_damage = burn_damage + self:GetCaster():GetIntellect() * 0.4
			elseif self:GetCaster():FindAbilityByName("npc_dota_hero_doom_bringer_int12") then
				burn_damage = burn_damage + self:GetCaster():GetIntellect() * 0.2
			end
            return burn_damage
		end
		if data.ability_special_value == "burn_duration" then
			local burn_duration = self:GetAbility():GetLevelSpecialValueNoOverride( "burn_duration", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_doom_bringer_str11") then
                burn_duration = 10
            end
            return burn_duration
		end
		if data.ability_special_value == "burn_damage_pct" then
			local burn_damage_pct = self:GetAbility():GetLevelSpecialValueNoOverride( "burn_damage_pct", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_doom_bringer_int11") then
                burn_damage_pct = 2.5
            end
            return burn_damage_pct
		end
	end
	return 0
end

function modifier_ability_infernal_blade_lua:OnAttackLanded(keys)
	if keys.attacker == self:GetParent() and not keys.target:IsBuilding() and not keys.target:IsOther() and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and self:GetAbility():IsFullyCastable() and self:GetAbility():GetAutoCastState() then
		keys.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_ability_infernal_blade_attack",  {duration = self:GetAbility():GetSpecialValueFor("burn_duration")})
		keys.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_ability_infernal_blade_stun",  {duration = self:GetAbility():GetSpecialValueFor("ministun_duration")})
		local effect_cast = ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_infernal_blade_impact.vpcf",PATTACH_ABSORIGIN_FOLLOW,keys.target)
		ParticleManager:ReleaseParticleIndex( effect_cast )

		EmitSoundOn( "Hero_DoomBringer.InfernalBlade.Target", self:GetParent() )
		self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
	end
end

function modifier_ability_infernal_blade_lua:GetModifierPreAttack_CriticalStrike()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_doom_bringer_agi7") and self:GetAbility():GetAutoCastState() and self:GetAbility():IsFullyCastable() then
		return 1000
	end
	return 0
end

function modifier_ability_infernal_blade_attack:IsHidden()
	return false
end

function modifier_ability_infernal_blade_attack:IsDebuff()
	return true
end

function modifier_ability_infernal_blade_attack:IsStunDebuff()
	return false
end

function modifier_ability_infernal_blade_attack:IsPurgable()
	return true
end
-- 
function modifier_ability_infernal_blade_attack:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_ability_infernal_blade_attack:GetModifierPhysicalArmorBonus()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_doom_bringer_agi10") then
		return self:GetAbility():GetLevel() * -1
	end
	return 0
end

function modifier_ability_infernal_blade_attack:OnCreated( kv )
	self.interval = 0.5
	local stacks = self:GetCaster():GetModifierStackCount("modifier_devour_intrinsic_lua", self:GetCaster())
	if self:GetCaster():FindAbilityByName("npc_dota_hero_doom_bringer_int6") then
		stacks = stacks * 1.5
	end
	local souls_multi = 1 + (self:GetAbility():GetSpecialValueFor( "burn_damage_pct" ) * stacks / 100)
	self.damage = self:GetAbility():GetSpecialValueFor( "burn_damage" ) * souls_multi
	
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage * self.interval,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility()
	}
	if not IsServer() then return end
	self:StartIntervalThink( 0.2 )
end

function modifier_ability_infernal_blade_attack:OnIntervalThink()
	ApplyDamage( self.damageTable )
	self:StartIntervalThink( self.interval )
end

function modifier_ability_infernal_blade_stun:IsDebuff()
	return true
end

function modifier_ability_infernal_blade_stun:IsStunDebuff()
	return true
end

function modifier_ability_infernal_blade_stun:IsPurgable()
	return true
end

function modifier_ability_infernal_blade_stun:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
	}
end

function modifier_ability_infernal_blade_stun:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
end

function modifier_ability_infernal_blade_stun:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

function modifier_ability_infernal_blade_stun:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_ability_infernal_blade_stun:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

