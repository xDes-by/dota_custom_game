LinkLuaModifier( "modifier_medusa_stone_gaze_lua_petrified", "heroes/hero_medusa/medusa_mystic_snake_lua/medusa_mystic_snake_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_medusa_mystic_snake_lua_autocast", "heroes/hero_medusa/medusa_mystic_snake_lua/medusa_mystic_snake_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_medusa_poison_arrow_lua", "heroes/hero_medusa/medusa_mystic_snake_lua/modifier_medusa_poison_arrow_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_medusa_magic_resist", "heroes/hero_medusa/medusa_mystic_snake_lua/modifier_medusa_poison_arrow_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_agil_lua", "heroes/hero_medusa/medusa_mystic_snake_lua/medusa_mystic_snake_lua", LUA_MODIFIER_MOTION_NONE )

medusa_mystic_snake_lua = class({})

function medusa_mystic_snake_lua:OnOwnerSpawned()
	if self.toggle_state then
		self:ToggleAbility()
	end
end

function medusa_mystic_snake_lua:OnOwnerDied()
	self.toggle_state = self:GetToggleState()
end

function medusa_mystic_snake_lua:GetManaCost(iLevel)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_medusa_int11") ~= nil then
		return math.min(65000, self:GetCaster():GetMana() * 0.3	)
	end
	return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end

function medusa_mystic_snake_lua:GetCastRange(vLocation, hTarget)
    return self:GetSpecialValueFor("radius")
end

function medusa_mystic_snake_lua:CastFilterResultTarget(hTarget)
    if self:GetCaster():GetTeamNumber() == hTarget:GetTeamNumber() then
        return UF_FAIL_FRIENDLY
    end

    return UF_SUCCESS
end

function medusa_mystic_snake_lua:GetIntrinsicModifierName()
    return "modifier_medusa_mystic_snake_lua_autocast"
end
medusa_mystic_snake_lua.double_snake = false
function medusa_mystic_snake_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	self.phys_dmg = caster:GetAverageTrueAttackDamage(caster) * 5
	if _G.snaketarget ~= nil then
		target = _G.snaketarget
	else
	 	target = self:GetCursorTarget()
	end
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_medusa_int6") ~= nil and not medusa_mystic_snake_lua.double_snake then
		medusa_mystic_snake_lua.double_snake_target = target
		Timers:CreateTimer(0.5, function()
			if medusa_mystic_snake_lua.double_snake_target then
				_G.snaketarget = medusa_mystic_snake_lua.double_snake_target
				medusa_mystic_snake_lua.double_snake = true
				self:OnSpellStart()
				medusa_mystic_snake_lua.double_snake = false
			end
		end)
	end
	-- load data
	local mana_steal = self:GetSpecialValueFor( "snake_mana_steal" )
	local jumps = self:GetSpecialValueFor( "snake_jumps" )
	local radius = self:GetSpecialValueFor( "radius" )
	local base_damage = self:GetSpecialValueFor( "snake_damage" )
	local mult_damage = self:GetSpecialValueFor( "snake_scale" )/100

	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_medusa_int50") then
		jumps = jumps * 2
	end
	local base_stun = 0
	local mult_stun = 0
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_medusa_int10")                         
	if abil ~= nil then 
		base_damage = base_damage + self:GetCaster():GetIntellect()
	end                     
	if self:GetCaster():FindAbilityByName("npc_dota_hero_medusa_str6") ~= nil then 
		base_damage = base_damage + self:GetCaster():GetStrength()
	end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_medusa_agi8") ~= nil then
		base_damage = base_damage + self:GetCaster():GetAgility()
	end

	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_medusa_int9")                         
	if abil ~= nil then 
		base_stun = self:GetSpecialValueFor( "stone_form_scepter_base" )
	end

	local projectile_name = "particles/econ/items/medusa/medusa_ti10_immortal_tail/medusa_ti10_projectile.vpcf"
	local projectile_speed = self:GetSpecialValueFor( "initial_speed" )
	local projectile_vision = 100

	local index = self:GetUniqueInt()

	-- create projectile
	local info = {
		Target = target,
		Source = caster,
		Ability = self,	
		
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bDodgeable = false,                           -- Optional
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
	
		bDrawsOnMinimap = false,                          -- Optional
		bVisibleToEnemies = true,                         -- Optional
		bProvidesVision = true,                           -- Optional
		iVisionRadius = projectile_vision,                              -- Optional
		iVisionTeamNumber = caster:GetTeamNumber(),        -- Optional

		ExtraData = {
			index = index,
		}
	}
	ProjectileManager:CreateTrackingProjectile(info)

	-- register projectile
	local data = {}
	data.jump = 0
	data.mana_stolen = 0
	data.isReturning = false
	data.hit_units = {}

	data.jumps = jumps
	data.radius = radius
	data.base_damage = base_damage
	data.mult_damage = mult_damage
	data.base_stun = base_stun
	data.mult_stun = mult_stun
	data.mana_steal = mana_steal
	data.projectile_info = info

	self.projectiles[index] = data

	-- play effects
	local sound_cast = "Hero_Medusa.MysticSnake.Cast"
	EmitSoundOn( sound_cast, caster )
	_G.snaketarget = nil
end
--------------------------------------------------------------------------------
-- Projectile
medusa_mystic_snake_lua.projectiles = {}
function medusa_mystic_snake_lua:OnProjectileHit_ExtraData( target, location, ExtraData )
	local snake_poison_duration = self:GetSpecialValueFor( "snake_poison_duration" )
	if self:GetCaster():FindAbilityByName("npc_dota_hero_medusa_int_last") ~= nil then 
		snake_poison_duration = snake_poison_duration + 2
	end
	if target ~= self:GetCaster() then
		target:AddNewModifier(self:GetCaster(), self, "modifier_medusa_poison_arrow_lua", { duration = snake_poison_duration })
		if self:GetCaster():FindAbilityByName("npc_dota_hero_medusa_int7") ~= nil then
			target:AddNewModifier(self:GetCaster(), self, "modifier_medusa_magic_resist", { duration = snake_poison_duration })
		end
	end
		-- load data
	local data = self.projectiles[ ExtraData.index ]

	-- if returning, returns mana
	if data.isReturning then
		self:Returned( data )
		return
	end

	-- if target turns magic immune or invulnerable or somehow there is no target even though it is undisjointable, skip
	if target and (not target:IsMagicImmune()) and (not target:IsInvulnerable()) then
		-- mark as hit
		data.hit_units[target] = true

		-- stun if scepter
		if data.base_stun>0 then
			if not target:IsAncient() then
				target:AddNewModifier(
					self:GetCaster(), -- player source
					self, -- ability source
					"modifier_medusa_stone_gaze_lua_petrified", -- modifier name
					{
						duration = data.base_stun + data.mult_stun * data.jump,
						physical_bonus = 50, -- hard coded because caster may not have Stone Gaze
						center_unit = self:GetCaster():entindex()
					}
				)
			end
		end

		local damage_type = self:GetAbilityDamageType()

		local damage = data.base_damage + data.base_damage * data.mult_damage * data.jump
		
		local damageTable = {
			victim = target,
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = damage_type,
			ability = self, --Optional.
		}
		ApplyDamage(damageTable)
		if self:GetCaster():FindAbilityByName("npc_dota_hero_medusa_agi6") ~= nil then
			ApplyDamage({
				victim = target,
				attacker = self:GetCaster(),
				damage = self.phys_dmg,
				damage_type = DAMAGE_TYPE_PHYSICAL,
				ability = self, --Optional.
				damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
			})
		end
		
		-- take mana
		local mana_taken = self:GetCaster():GetMaxMana() / 100 * data.mana_steal
		data.mana_stolen = data.mana_stolen + mana_taken

		-- play effects
		local sound_cast = "Hero_Medusa.MysticSnake.Target"
		EmitSoundOn( sound_cast, target )

		-- counter
		data.jump = data.jump + 1
		if data.jump>=data.jumps then
			-- return projectile with target
			self:Returning( data, target )
			return
		end
	end

	-- jump to nearby target
	local pos = location
	if target then
		pos = target:GetOrigin()
	end

	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		pos,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		data.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		FIND_CLOSEST,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- pick next target
	local next_target = nil
	for _,enemy in pairs(enemies) do

		local found = false
		if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_medusa_int50") then
			goto continue
		end
		-- check if it is already hit
		for unit,_ in pairs(data.hit_units) do
			if enemy==unit then
				found = true
				break
			end
		end
		::continue::

		if enemy ~= target then
			next_target = enemy
			break
		end
	end

	-- not found
	if not next_target then
		-- return projectile without target
		self:Returning( data, target )
		return
	end

	-- create bounce projectile
	data.projectile_info.Target = next_target
	data.projectile_info.Source = target
	ProjectileManager:CreateTrackingProjectile( data.projectile_info )
	
end

function medusa_mystic_snake_lua:Returning( data, target )
	if not target then
		self:Returned( data )
		return
	end

	-- set returning
	data.isReturning = true

	-- create projectile
	local projectile_name = "particles/units/heroes/hero_medusa/medusa_mystic_snake_projectile_return.vpcf"
	data.projectile_info.Target = self:GetCaster()
	data.projectile_info.Source = target
	data.projectile_info.EffectName = projectile_name
	ProjectileManager:CreateTrackingProjectile( data.projectile_info )
end

function medusa_mystic_snake_lua:Returned( data )
	-- unregister projectile
	local index = data.projectile_info.ExtraData.index
	self.projectiles[ index ] = nil
	self:DelUniqueInt( index )

	-- only do things if alive
	if not self:GetCaster():IsAlive() then return end

	-- give mana
	self:GetCaster():GiveMana( data.mana_stolen )

	-- play effects
	local sound_cast = "Hero_Medusa.MysticSnake.Return"
	EmitSoundOn( sound_cast, self:GetCaster() )
	SendOverheadEventMessage(
		nil, -- DOTAPlayer sendToPlayer,
		OVERHEAD_ALERT_MANA_ADD, --int iMessageType,
		self:GetCaster(),-- Entity targetEntity,
		data.mana_stolen,-- int iValue,
		self:GetCaster():GetPlayerOwner() -- DOTAPlayer sourcePlayer
	) -- - sendToPlayer and sourcePlayer can be nil - iMessageType is one of OVERHEAD_ALERT_* ])
end

--------------------------------------------------------------------------------
-- Helper

-- Obtain unique integer for projectile identifier
medusa_mystic_snake_lua.unique = {}
medusa_mystic_snake_lua.i = 0
medusa_mystic_snake_lua.max = 65536
function medusa_mystic_snake_lua:GetUniqueInt()
	while self.unique[ self.i ] do
		self.i = self.i + 1
		if self.i==self.max then self.i = 0 end
	end

	self.unique[ self.i ] = true
	return self.i
end
function medusa_mystic_snake_lua:DelUniqueInt( i )
	self.unique[ i ] = nil
end

modifier_medusa_mystic_snake_lua_autocast = class({})

function modifier_medusa_mystic_snake_lua_autocast:IsHidden()
    return true
end
function modifier_medusa_mystic_snake_lua_autocast:IsPurgable()
    return false
end

function modifier_medusa_mystic_snake_lua_autocast:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_START
    }
end

function modifier_medusa_mystic_snake_lua_autocast:OnAttackStart(keys)
    if not IsServer() then return end

    local caster = self:GetCaster()
    local ability = self:GetAbility()
    local target = keys.target

    if keys.attacker == caster and ability:IsFullyCastable() and ability:GetAutoCastState() then
        caster:SetCursorCastTarget(target)
        ability:OnSpellStart()
        ability:UseResources(true, false,false, true)
    end
end

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------


modifier_medusa_stone_gaze_lua_petrified = class({})

function modifier_medusa_stone_gaze_lua_petrified:IsHidden()
	return false
end

function modifier_medusa_stone_gaze_lua_petrified:IsDebuff()
	return true
end

function modifier_medusa_stone_gaze_lua_petrified:IsStunDebuff()
	return true
end

function modifier_medusa_stone_gaze_lua_petrified:IsPurgable()
	return true
end

function modifier_medusa_stone_gaze_lua_petrified:OnCreated( kv )
	if not IsServer() then return end
	self.center_unit = EntIndexToHScript( kv.center_unit )

	self:PlayEffects()
end

function modifier_medusa_stone_gaze_lua_petrified:OnRefresh( kv )
	if not IsServer() then return end
	self.center_unit = EntIndexToHScript( kv.center_unit )

	self:PlayEffects()
end

function modifier_medusa_stone_gaze_lua_petrified:OnRemoved()
end

function modifier_medusa_stone_gaze_lua_petrified:OnDestroy()
end

function modifier_medusa_stone_gaze_lua_petrified:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
	}
	return state
end


function modifier_medusa_stone_gaze_lua_petrified:GetStatusEffectName()
	return "particles/status_fx/status_effect_medusa_stone_gaze.vpcf"
end
function modifier_medusa_stone_gaze_lua_petrified:StatusEffectPriority(  )
	return MODIFIER_PRIORITY_ULTRA
end

function modifier_medusa_stone_gaze_lua_petrified:PlayEffects()
	local particle_cast = "particles/units/heroes/hero_medusa/medusa_stone_gaze_debuff_stoned.vpcf"
	local sound_cast = "Hero_Medusa.StoneGaze.Stun"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self.center_unit,
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		Vector( 0,0,0 ), -- unknown
		true -- unknown, true
	)

	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
	EmitSoundOnClient( sound_cast, self:GetParent():GetPlayerOwner() )
end

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

modifier_agil_lua = class({})

--------------------------------------------------------------------------------
function modifier_agil_lua:IsHidden()
	return true
end

function modifier_agil_lua:IsPurgable()
	return false
end

function modifier_agil_lua:OnCreated( kv )
 self.agi = self:GetParent():GetAgility()*0.3
end

function modifier_agil_lua:OnRefresh( kv )
end

function modifier_agil_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
	return funcs
end

function modifier_agil_lua:GetModifierBonusStats_Agility()
	return self.agi
end