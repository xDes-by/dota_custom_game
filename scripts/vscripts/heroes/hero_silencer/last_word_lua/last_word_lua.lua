LinkLuaModifier( "modifier_silencer_last_word_lua_silence", "heroes/hero_silencer/last_word_lua/last_word_lua.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_silencer_last_word_lua", "heroes/hero_silencer/last_word_lua/last_word_lua.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_special_bonus_unique_npc_dota_hero_silencer_str50", "heroes/hero_silencer/last_word_lua/last_word_lua.lua", LUA_MODIFIER_MOTION_NONE )

silencer_last_word_lua = {}

function silencer_last_word_lua:GetIntrinsicModifierName()
    return "modifier_special_bonus_unique_npc_dota_hero_silencer_str50"
end

function silencer_last_word_lua:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end

function silencer_last_word_lua:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local duration = self:GetSpecialValueFor( "debuff_duration" )
	if caster:FindAbilityByName("npc_dota_hero_silencer_str7") then
		duration = 0.1
	end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_silencer_int8") then
		local enemies = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(),	-- int, your team number
			self:GetCaster():GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			900,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
			FIND_CLOSEST,	-- int, order filter
			false	-- bool, can grow cache
		)
		for _,enemy in pairs(enemies) do
			self:AddEffect(enemy, duration)
		end
	else
		self:AddEffect(target, duration)
	end
	EmitSoundOn( "Hero_Silencer.LastWord.Cast", self:GetCaster() )
end

function silencer_last_word_lua:AddEffect(target, duration)
	target:AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_silencer_last_word_lua",
		{ duration = duration }
	)
	local direction = target:GetOrigin()-self:GetCaster():GetOrigin()
	direction.z = 0
	direction = direction:Normalized()
	local effect_cast = ParticleManager:CreateParticle(
		"particles/units/heroes/hero_silencer/silencer_last_word_status_cast.vpcf",
		PATTACH_ABSORIGIN_FOLLOW,
		self:GetCaster()
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_attack1",
		Vector(),
		true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function silencer_last_word_lua:GetBehavior()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_silencer_int8") then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET
	end
end

function silencer_last_word_lua:GetCooldown(level)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_silencer_str7")	then 
		return self.BaseClass.GetCooldown( self, level ) * 0.7
	end
	return self.BaseClass.GetCooldown( self, level )
end

modifier_silencer_last_word_lua = {}

function modifier_silencer_last_word_lua:IsHidden()
	return false
end

function modifier_silencer_last_word_lua:IsDebuff()
	return true
end

function modifier_silencer_last_word_lua:IsStunDebuff()
	return false
end

function modifier_silencer_last_word_lua:IsPurgable()
	return true
end

function modifier_silencer_last_word_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_silencer_last_word_lua:OnCreated( kv )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	if not IsServer() then return end
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" ) + self:GetCaster():GetIntellect() * self:GetAbility():GetSpecialValueFor("int_dmg")

	if self:GetCaster():FindAbilityByName("npc_dota_hero_silencer_int11") then
		self.damage = self.damage * 2
	end

	self:StartIntervalThink( kv.duration )
	EmitSoundOn( "Hero_Silencer.LastWord.Target", self:GetParent() )
end

function modifier_silencer_last_word_lua:OnRefresh( kv )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
end

function modifier_silencer_last_word_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}
end

function modifier_silencer_last_word_lua:GetModifierProvidesFOWVision()
	return 1
end

function modifier_silencer_last_word_lua:OnAbilityFullyCast( params )
	if not IsServer() then return end
	if params.unit~=self:GetParent() then return end
	if params.ability:IsItem() then return end

	self:Silence()
end

function modifier_silencer_last_word_lua:OnIntervalThink()
	self:Silence()
end

function modifier_silencer_last_word_lua:Silence()
	self:GetParent():AddNewModifier(
		self:GetCaster(),
		self:GetAbility(),
		"modifier_silencer_last_word_lua_silence",
		{ duration = self.duration }
	)

	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self
	}
	ApplyDamage( damageTable )

	local effect_cast = ParticleManager:CreateParticle(
		"particles/units/heroes/hero_silencer/silencer_last_word_dmg.vpcf",
		PATTACH_ABSORIGIN_FOLLOW,
		self:GetParent()
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( "Hero_Silencer.LastWord.Damage", self:GetParent() )
	StopSoundOn( "Hero_Silencer.LastWord.Target", self:GetParent() )

	self:Destroy()
end

function modifier_silencer_last_word_lua:GetEffectName()
	return "particles/units/heroes/hero_silencer/silencer_last_word_status.vpcf"
end

function modifier_silencer_last_word_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

modifier_silencer_last_word_lua_silence = {}

function modifier_silencer_last_word_lua_silence:IsDebuff()
	return true
end

function modifier_silencer_last_word_lua_silence:IsStunDebuff()
	return false
end

function modifier_silencer_last_word_lua_silence:IsPurgable()
	return true
end

function modifier_silencer_last_word_lua_silence:CheckState()
	return { [MODIFIER_STATE_SILENCED] = true }
end

function modifier_silencer_last_word_lua_silence:GetEffectName()
	return "particles/generic_gameplay/generic_silenced.vpcf"
end

function modifier_silencer_last_word_lua_silence:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

modifier_special_bonus_unique_npc_dota_hero_silencer_str50 = class({})
--Classifications template
function modifier_special_bonus_unique_npc_dota_hero_silencer_str50:IsHidden()
	return true
end

function modifier_special_bonus_unique_npc_dota_hero_silencer_str50:IsDebuff()
	return false
end

function modifier_special_bonus_unique_npc_dota_hero_silencer_str50:IsPurgable()
	return false
end

function modifier_special_bonus_unique_npc_dota_hero_silencer_str50:IsPurgeException()
	return false
end

-- Optional Classifications
function modifier_special_bonus_unique_npc_dota_hero_silencer_str50:IsStunDebuff()
	return false
end

function modifier_special_bonus_unique_npc_dota_hero_silencer_str50:RemoveOnDeath()
	return false
end

function modifier_special_bonus_unique_npc_dota_hero_silencer_str50:DestroyOnExpire()
	return false
end

function modifier_special_bonus_unique_npc_dota_hero_silencer_str50:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	}
end

function modifier_special_bonus_unique_npc_dota_hero_silencer_str50:GetModifierDamageOutgoing_Percentage(data)
	if IsClient() then
		return 0
	end
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_silencer_str50") and data.target and data.target:IsSilenced() then
		print("silence")
		return 100
	end
	return 0
end