-- Created by Elfansoer
--[[
Ability checklist (erase if done/checked):
- Scepter Upgrade
- Break behavior
- Linken/Reflect behavior
- Spell Immune/Invulnerable/Invisible behavior
- Illusion behavior
- Stolen behavior
]]
--------------------------------------------------------------------------------
modifier_spirit_breaker_bulldoze_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_spirit_breaker_bulldoze_lua:IsHidden()
	return false
end

function modifier_spirit_breaker_bulldoze_lua:IsDebuff()
	return false
end

function modifier_spirit_breaker_bulldoze_lua:IsPurgable()
	return false
end

function modifier_spirit_breaker_bulldoze_lua:RemoveOnDeath()
	return false
end

function modifier_spirit_breaker_bulldoze_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_spirit_breaker_bulldoze_lua:OnCreated( kv )
	-- references
	self.movespeed = self:GetAbility():GetSpecialValueFor( "movement_speed" )
	self.resistance = self:GetAbility():GetSpecialValueFor( "status_resistance" )
	self.caster = self:GetCaster()
	self.thinker = kv.isProvidedByAura~=1
	if not self.thinker and self.caster == self:GetParent() then
		self:Destroy()
		return
	end
	if IsServer() then
		-- local particle_cast = ""
		-- self.particle = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		-- ParticleManager:SetParticleControl( self.particle, 1, self:GetParent():GetOrigin() )
		-- ParticleManager:ReleaseParticleIndex( self.particle )
		self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_spirit_breaker/spirit_breaker_haste_owner.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(self.particle, false, false, -1, false, false)
		local sound_cast = "Hero_Spirit_Breaker.Bulldoze.Cast"
		EmitSoundOn( sound_cast, self:GetParent() )
	end
end

function modifier_spirit_breaker_bulldoze_lua:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_spirit_breaker_bulldoze_lua:OnDestroy( kv )
	if IsServer() and self.particle then
		ParticleManager:DestroyParticle(self.particle, false)
	end
end

function modifier_spirit_breaker_bulldoze_lua:GetBonusMsConstant()
	if self.caster:FindAbilityByName("npc_dota_hero_spirit_breaker_str6") then
		local movement_bonus = self.caster:GetLevel() * 5
		if movement_bonus > 500 then 
			movement_bonus = 500
		end
		return movement_bonus
	end
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_spirit_breaker_bulldoze_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_STATUS_RESISTANCE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	}

	return funcs
end

function modifier_spirit_breaker_bulldoze_lua:GetModifierMoveSpeedBonus_Percentage()
	return self.movespeed
end

function modifier_spirit_breaker_bulldoze_lua:GetModifierStatusResistance()
	return self.resistance
end

function modifier_spirit_breaker_bulldoze_lua:GetModifierMagicalResistanceBonus()
	if self.caster:FindAbilityByName("npc_dota_hero_spirit_breaker_str8") then
		return self.resistance
	end
end

function modifier_spirit_breaker_bulldoze_lua:GetModifierPercentageCooldown()
	if self.caster:FindAbilityByName("npc_dota_hero_spirit_breaker_int6") then
		return 50
	end
end

function modifier_spirit_breaker_bulldoze_lua:GetModifierMoveSpeedBonus_Constant()
	return self:GetBonusMsConstant()
end

function modifier_spirit_breaker_bulldoze_lua:GetModifierIgnoreMovespeedLimit()
	return 1
end

function modifier_spirit_breaker_bulldoze_lua:GetModifierHealthRegenPercentage()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_spirit_breaker_str9") then
		return 5
	end
end

--------------------------------------------------------------------------------

function modifier_spirit_breaker_bulldoze_lua:IsAura()
	if self.caster:FindAbilityByName("npc_dota_hero_spirit_breaker_str11") and self.thinker then
		return true
	end
end

function modifier_spirit_breaker_bulldoze_lua:GetModifierAura() 
	return "modifier_spirit_breaker_bulldoze_lua" 
end

function modifier_spirit_breaker_bulldoze_lua:GetAuraRadius()
	return 800
end

function modifier_spirit_breaker_bulldoze_lua:GetAuraSearchFlags() 
	return DOTA_UNIT_TARGET_FLAG_NONE 
end

function modifier_spirit_breaker_bulldoze_lua:GetAuraSearchTeam() 
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY 
end

function modifier_spirit_breaker_bulldoze_lua:GetAuraSearchType() 
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

modifier_spirit_breaker_bulldoze_lua_flying_vision = class({})

function modifier_spirit_breaker_bulldoze_lua_flying_vision:IsHidden()
	return true
end

function modifier_spirit_breaker_bulldoze_lua_flying_vision:CheckState()
	local state =
		{
			[MODIFIER_STATE_FORCED_FLYING_VISION] = true
		}
	return state
end