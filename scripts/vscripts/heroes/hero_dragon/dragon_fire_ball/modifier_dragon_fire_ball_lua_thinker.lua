modifier_dragon_fire_ball_lua_thinker = class({})
LinkLuaModifier( "modifier_dragon_fire_ball_lua", "heroes/hero_dragon/dragon_fire_ball/modifier_dragon_fire_ball_lua_thinker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dragon_debuff_fireball", "heroes/hero_dragon/dragon_fire_ball/modifier_dragon_fire_ball_lua_thinker", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
function modifier_dragon_fire_ball_lua_thinker:IsHidden()
	return true
end

function modifier_dragon_fire_ball_lua_thinker:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.burn_interval = self:GetAbility():GetSpecialValueFor( "burn_interval" )
	local interval = self.burn_interval
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_dragon_knight_int8")	
	if abil ~= nil then 
		self.damage = self:GetCaster():GetIntellect()
	end
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_dragon_knight_agi6")	
	if abil ~= nil then 
		self.damage = self:GetCaster():GetAgility()
	end
	
	local abil = self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_dragon_knight_int50")	
	if abil ~= nil then 
		self.damage = self:GetCaster():GetIntellect() * 2 + self.damage
	end

	if IsServer() then
		GridNav:DestroyTreesAroundPoint( self:GetParent():GetOrigin(), self.radius, true )

		self.damageTable = {
			attacker = self:GetCaster(),
			damage_type = self:GetAbility():GetAbilityDamageType(),
			ability = self:GetAbility(),
		}

		self:StartIntervalThink( interval )

		self:PlayEffects()
	end
end

function modifier_dragon_fire_ball_lua_thinker:OnDestroy()
	if IsServer() then

		UTIL_Remove( self:GetParent() )
	end
end

--------------------------------------------------------------------------------
function modifier_dragon_fire_ball_lua_thinker:OnIntervalThink()
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	for _,enemy in pairs(enemies) do
		self.damageTable.victim = enemy
		self.damageTable.damage = self.damage
		ApplyDamage( self.damageTable )
	end
	
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_dragon_knight_str7")	
		if abil ~= nil then 
			local allies = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(),	-- int, your team number
			self:GetParent():GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)
		for _,ally in pairs(allies) do
			if ally == self:GetCaster() then
				ally:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_magic_immune",{ duration = 0.8 }	)
				ally:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_dragon_debuff_fireball",{ duration = 0.8 }	)
			end
		end
	end
end

function modifier_dragon_fire_ball_lua_thinker:PlayEffects()
	local particle_cast =  "particles/dk.vpcf"
	self.sound_cast =  "hero_jakiro.macropyre"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	EmitSoundOn( self.sound_cast, self:GetParent() )
end

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

modifier_dragon_debuff_fireball = class({})

function modifier_dragon_debuff_fireball:IsHidden()
	return false
end

function modifier_dragon_debuff_fireball:IsDebuff()
	return true
end

function modifier_dragon_debuff_fireball:IsPurgable()
	return false
end

function modifier_dragon_debuff_fireball:OnCreated( kv )
end

function modifier_dragon_debuff_fireball:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE,
    }
end

function modifier_dragon_debuff_fireball:GetModifierIncomingPhysicalDamage_Percentage()
    return 50
end

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

modifier_dragon_fire_ball_lua = class({})

function modifier_dragon_fire_ball_lua:IsHidden()
	return false
end

function modifier_dragon_fire_ball_lua:IsDebuff()
	return true
end

function modifier_dragon_fire_ball_lua:IsStunDebuff()
	return false
end

function modifier_dragon_fire_ball_lua:IsPurgable()
	return false
end

function modifier_dragon_fire_ball_lua:OnCreated( kv )
	if not IsServer() then return end
	local interval = kv.interval
	local damage = kv.damage
	local damage_type = kv.damage_type
	
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetParent(),
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
	}
	 ApplyDamage(damageTable)

	self:StartIntervalThink( interval )
end

function modifier_dragon_fire_ball_lua:OnRefresh( kv )
	if not IsServer() then return end
	local damage = kv.damage
	local damage_type = kv.damage_type
	self.damageTable.damage = damage
	self.damageTable.damage_type = damage_type
end

function modifier_dragon_fire_ball_lua:OnRemoved()
end

function modifier_dragon_fire_ball_lua:OnDestroy()
end

function modifier_dragon_fire_ball_lua:OnIntervalThink()
	ApplyDamage( self.damageTable )
end

function modifier_dragon_fire_ball_lua:GetEffectName()
	return "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_debuff.vpcf"
end

function modifier_dragon_fire_ball_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end