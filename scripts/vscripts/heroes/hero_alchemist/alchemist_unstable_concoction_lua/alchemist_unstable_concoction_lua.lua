LinkLuaModifier( "modifier_alchemist_unstable_concoction_lua_effect", "heroes/hero_alchemist/alchemist_unstable_concoction_lua/alchemist_unstable_concoction_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_unstable_concoction_lua_debuff", "heroes/hero_alchemist/alchemist_unstable_concoction_lua/alchemist_unstable_concoction_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_acid_spray_lua", "heroes/hero_alchemist/alchemist_acid_spray_lua/alchemist_acid_spray_lua", LUA_MODIFIER_MOTION_NONE )

alchemist_unstable_concoction_lua = class({})

function alchemist_unstable_concoction_lua:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end


function alchemist_unstable_concoction_lua:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local count = 1
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_alchemist_int10")	
	if abil ~= nil then 
		count = 3
	end
	
	Timers:CreateTimer(0.1, function()
		count = count - 1
		local info = {
			Target = target,
			Source = caster,
			Ability = self,	
			EffectName = "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_projectile.vpcf",
			iMoveSpeed = 500,
		}
		ProjectileManager:CreateTrackingProjectile(info)
		EmitSoundOn( "Hero_Alchemist.UnstableConcoction.Throw", caster )
		
		if count > 0 then
			return 0.5
		else	
			return nil
		end
	end)	
end

function alchemist_unstable_concoction_lua:OnProjectileHit( target, location )
	if not target then return end
	local damage = self:GetSpecialValueFor( "damage" )
	local duration = self:GetSpecialValueFor( "duration" )
	local radius = self:GetSpecialValueFor( "radius" )
	local tick_damage = self:GetSpecialValueFor( "tick_damage" )
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_alchemist_agi9")	
	if abil ~= nil then 
		target:AddNewModifier( self:GetCaster(), self, "modifier_alchemist_unstable_concoction_lua_debuff", { duration = 3 } )
	end	
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_alchemist_int8")	
	if abil ~= nil then 
		damage = self:GetCaster():GetIntellect()
	end
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_alchemist_agi7")	
	if abil ~= nil then 
		damage = self:GetCaster():GetAgility()
	end
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_alchemist_str7")	
	if abil ~= nil then 
		damage = self:GetCaster():GetStrength()
	end
	
	self.damage_type = DAMAGE_TYPE_PHYSICAL
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_alchemist_int7")	
	if abil ~= nil then 
		self.damage_type = DAMAGE_TYPE_MAGICAL
	end
	
	local damageTable = {
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self.damage_type,
		ability = self, --Optional.
	}

	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), target:GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )
	for _,enemy in pairs(enemies) do
		damageTable.victim = enemy
		ApplyDamage( damageTable )

		enemy:AddNewModifier( self:GetCaster(), self, "modifier_alchemist_unstable_concoction_lua_effect", { duration = duration } )
	end

	self:PlayEffects( target )
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_alchemist_int11")	
	if abil ~= nil then
		local abil2 = self:GetCaster():FindAbilityByName("alchemist_acid_spray_lua")
		if abil2 and abil2:GetLevel() > 0 then
			dur = abil2:GetSpecialValueFor( "duration" )
			CreateModifierThinker( self:GetCaster(), abil2, "modifier_alchemist_acid_spray_lua", { duration = dur }, target:GetOrigin(), self:GetCaster():GetTeamNumber(), false )
		end	
	end
end

function alchemist_unstable_concoction_lua:PlayEffects( target )
	local particle_cast = "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_explosion.vpcf"
	local sound_cast = "Hero_Alchemist.UnstableConcoction.Stun"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( sound_cast, target )
end

------------------------------------------------------------------------------------------------------

modifier_alchemist_unstable_concoction_lua_effect = class({})

function modifier_alchemist_unstable_concoction_lua_effect:IsHidden()
	return false
end

function modifier_alchemist_unstable_concoction_lua_effect:IsDebuff()
	return true
end

function modifier_alchemist_unstable_concoction_lua_effect:IsStunDebuff()
	return false
end

function modifier_alchemist_unstable_concoction_lua_effect:IsPurgable()
	return false
end

function modifier_alchemist_unstable_concoction_lua_effect:OnCreated( kv )
	local damage = self:GetAbility():GetSpecialValueFor( "damage" )
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_alchemist_int8")	
	if abil ~= nil then 
		damage = self:GetCaster():GetIntellect()
	end
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_alchemist_agi7")	
	if abil ~= nil then 
		damage = self:GetCaster():GetAgility()
	end
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_alchemist_str7")	
	if abil ~= nil then 
		damage = self:GetCaster():GetStrength()
	end

	if not IsServer() then return end
	
	self.damage_type = DAMAGE_TYPE_PHYSICAL
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_alchemist_int7")	
	if abil ~= nil then 
		self.damage_type = DAMAGE_TYPE_MAGICAL
	end

	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage / 8,
		damage_type = self.damage_type,
		ability = self:GetAbility(),
	}
	self:StartIntervalThink(0.5)
end

function modifier_alchemist_unstable_concoction_lua_effect:OnIntervalThink()
	ApplyDamage( self.damageTable )
end

function modifier_alchemist_unstable_concoction_lua_effect:GetEffectName()
	return "particles/units/heroes/hero_alchemist/alchemist_acid_spray_debuff.vpcf"
end

function modifier_alchemist_unstable_concoction_lua_effect:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

------------------------------------------------------------------

modifier_alchemist_unstable_concoction_lua_debuff = class({})

function modifier_alchemist_unstable_concoction_lua_debuff:IsHidden()
	return false
end

function modifier_alchemist_unstable_concoction_lua_debuff:IsDebuff()
	return true
end

function modifier_alchemist_unstable_concoction_lua_debuff:IsStunDebuff()
	return false
end

function modifier_alchemist_unstable_concoction_lua_debuff:IsPurgable()
	return false
end

function modifier_alchemist_unstable_concoction_lua_debuff:OnCreated( kv )
end

function modifier_alchemist_unstable_concoction_lua_debuff:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

function modifier_alchemist_unstable_concoction_lua_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
	return funcs
end

function modifier_alchemist_unstable_concoction_lua_debuff:GetModifierIncomingDamage_Percentage( params )
	if params.attacker == self:GetCaster() then
		return 15
	end
	return 0
end

function modifier_alchemist_unstable_concoction_lua_debuff:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

function modifier_alchemist_unstable_concoction_lua_debuff:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_alchemist_unstable_concoction_lua_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------
