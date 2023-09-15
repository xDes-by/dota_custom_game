LinkLuaModifier( "modifier_silencer_global_silence_lua", "heroes/hero_silencer/global_silence_lua/global_silence_lua.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_silencer_global_silence_damage_lua", "heroes/hero_silencer/global_silence_lua/global_silence_lua.lua", LUA_MODIFIER_MOTION_NONE )

silencer_global_silence_lua = {}

function silencer_global_silence_lua:GetManaCost(iLevel)
    return 150 + math.min(65000, self:GetCaster():GetIntellect() / 30)
end

function silencer_global_silence_lua:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor( "tooltip_duration" )
	-- if self:GetCaster():FindAbilityByName("npc_dota_hero_silencer_str_last") then
	-- 	duration = duration * 3
	-- end
	local damage = self:ColculateDamageValue()
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),
		caster:GetOrigin(),
		nil,
		FIND_UNITS_EVERYWHERE,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_MANA_ONLY,
		0,
		false
	)
	local count = 1
	for _,enemy in pairs(enemies) do
		if damage > 0 then
			interval = count * 0.01
		end
		enemy:AddNewModifier(
			caster,
			self,
			"modifier_silencer_global_silence_lua",
			{ 
				duration = duration,
				interval = interval,
				damage = damage,
		 	}
		)
		if enemy:IsHero() then
			local effect_cast = ParticleManager:CreateParticle(
				"particles/units/heroes/hero_silencer/silencer_global_silence_hero.vpcf",
				PATTACH_ABSORIGIN_FOLLOW,
				enemy
			)
			ParticleManager:SetParticleControlEnt(
				effect_cast,
				1,
				enemy,
				PATTACH_ABSORIGIN_FOLLOW,
				"attach_attack1",
				Vector(),
				true
			)
			ParticleManager:ReleaseParticleIndex( effect_cast )

			EmitSoundOnClient( "Hero_Silencer.GlobalSilence.Effect", enemy:GetPlayerOwner() )
		end
		count = count + 1
	end

	local effect_cast =  ParticleManager:CreateParticle(
		"particles/units/heroes/hero_silencer/silencer_global_silence.vpcf",
		PATTACH_ABSORIGIN_FOLLOW,
		self:GetCaster()
	)
	ParticleManager:SetParticleControlForward( effect_cast, 0, self:GetCaster():GetForwardVector() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_attack1",
		Vector(),
		true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitGlobalSound( "Hero_Silencer.GlobalSilence.Cast" )
end

function silencer_global_silence_lua:ColculateDamageValue()
	damage = 0
	if self:GetCaster():FindAbilityByName("npc_dota_hero_silencer_str_last") then
		local multi = 1 + ( 1 / 15 * self:GetLevel() )
		damage = damage + self:GetCaster():GetIntellect() * multi
	end
	return damage
end

function silencer_global_silence_lua:GlobalKill()
	if self.globalKill == nil then self.globalKill = 0 end
	self.globalKill = self.globalKill + 1
	if self.globalKill % 3 > 0 then
		self:GetCaster():FindModifierByName("modifier_silencer_glaives_of_wisdom_lua"):DecrementStackCount()
	end
end

modifier_silencer_global_silence_lua = {}

function modifier_silencer_global_silence_lua:IsDebuff()
	return true
end

function modifier_silencer_global_silence_lua:IsStunDebuff()
	return false
end

function modifier_silencer_global_silence_lua:IsPurgable()
	return true
end

function modifier_silencer_global_silence_lua:CheckState()
	return { [MODIFIER_STATE_SILENCED] = true }
end

function modifier_silencer_global_silence_lua:GetEffectName()
	return "particles/generic_gameplay/generic_silenced.vpcf"
end

function modifier_silencer_global_silence_lua:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_silencer_global_silence_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_silencer_global_silence_lua:OnCreated( kv )
	if not IsServer() then return end
	self.damage = kv.damage
	if kv.interval ~= nil then
		self:StartIntervalThink(kv.interval)
	end
end

function modifier_silencer_global_silence_lua:OnIntervalThink( kv )
	if not IsServer() then return end
	ApplyDamage({
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL,
		ability = self:GetAbility(),
	})
	SendOverheadEventMessage(
		nil,
		OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,
		self:GetParent(),
		self.damage,
		nil
	)
	self:StartIntervalThink(-1)
end

function modifier_silencer_global_silence_lua:DeclareFunctions()
	return { 
		MODIFIER_EVENT_ON_DEATH,
	}
end

function modifier_silencer_global_silence_lua:OnDeath(params)
	if params.attacker == self:GetCaster() and params.unit == self:GetParent() then
		self:GetAbility():GlobalKill()
	end
end

function IsMyKilledBadGuys(hero, params)
    if params.unit:GetTeamNumber() ~= DOTA_TEAM_BADGUYS then
        return false
    end
    local attacker = params.attacker
    if hero == attacker then
        return true
    else
        if hero == attacker:GetOwner() then
            return true
        else
            return false
        end
    end
end