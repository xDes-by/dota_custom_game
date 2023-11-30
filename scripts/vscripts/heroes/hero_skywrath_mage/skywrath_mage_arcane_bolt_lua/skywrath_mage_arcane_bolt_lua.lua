skywrath_mage_arcane_bolt_lua = class({})
LinkLuaModifier( "modifier_skywrath_mage_arcane_bolt_lua", "heroes/hero_skywrath_mage/skywrath_mage_arcane_bolt_lua/modifier_skywrath_mage_arcane_bolt_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skywrath_mage_arcane_bolt_hit", "heroes/hero_skywrath_mage/skywrath_mage_arcane_bolt_lua/skywrath_mage_arcane_bolt_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_special_bonus_unique_npc_dota_hero_skywrath_mage_agi50", "heroes/hero_skywrath_mage/skywrath_mage_arcane_bolt_lua/skywrath_mage_arcane_bolt_lua", LUA_MODIFIER_MOTION_NONE )

modifier_skywrath_mage_arcane_bolt_hit = {}

function modifier_skywrath_mage_arcane_bolt_hit:IsHidden()
	return true
end

function modifier_skywrath_mage_arcane_bolt_hit:IsDebuff()
	return false
end

function modifier_skywrath_mage_arcane_bolt_hit:IsPurgable()
	return false
end

function modifier_skywrath_mage_arcane_bolt_hit:RemoveOnDeath()
	return false
end

function modifier_skywrath_mage_arcane_bolt_hit:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_LANDED}
end

function modifier_skywrath_mage_arcane_bolt_hit:OnAttackLanded(params)
	if self:GetAbility():GetCaster():HasModifier("modifier_skywrath_mage_arcane_bolt_hit") ~= nil and RandomInt(1, 4) == 1 and params.attacker:FindAbilityByName("skywrath_mage_arcane_bolt_lua") ~= nil then
		if params.attacker:FindAbilityByName("skywrath_mage_arcane_bolt_lua"):IsTrained() then
			_G.bolttarget = params.target
			if not params.target:IsBuilding() then
				params.attacker:FindAbilityByName("skywrath_mage_arcane_bolt_lua"):OnSpellStart()
			end
		end
	end
end

function skywrath_mage_arcane_bolt_lua:OnUpgrade()
	if not IsServer() then return end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_skywrath_mage_agi_last") ~= nil then
	self:GetCaster():AddNewModifier(self:GetCaster(), self,"modifier_skywrath_mage_arcane_bolt_hit", {})
	end
end

function skywrath_mage_arcane_bolt_lua:GetManaCost(iLevel)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_skywrath_mage_int10") ~= nil then 
		return 50 + math.min(65000, self:GetCaster():GetIntellect()/200)
	end
	return 100 + math.min(65000, self:GetCaster():GetIntellect()/100)
end

function skywrath_mage_arcane_bolt_lua:OnSpellStart()
	local caster = self:GetCaster()
	if _G.bolttarget ~= nil then
		target = _G.bolttarget
	else
	 	target = self:GetCursorTarget()
	end
	_G.bolttarget = nil

	-- load data
	local projectile_name = "particles/units/heroes/hero_skywrath_mage/skywrath_mage_arcane_bolt.vpcf"
	local projectile_speed = self:GetSpecialValueFor( "bolt_speed" )
	local projectile_vision = self:GetSpecialValueFor( "bolt_vision" )
	local base_damage = self:GetSpecialValueFor( "bolt_damage" )
	local multiplier = self:GetSpecialValueFor( "int_multiplier" )
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_skywrath_mage_int6")	
	if abil ~= nil then 
		multiplier = multiplier * 2
	end

	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_skywrath_mage_str9")	
	if abil ~= nil then 
		base_damage = caster:GetStrength()
	end

	local abil = self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_skywrath_mage_str50")	
	if abil ~= nil then 
		base_damage = base_damage * 3
	end

	local damage = base_damage
	if caster:IsHero() then
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_skywrath_mage_agi8")	
		if abil ~= nil then 
			damage = damage + multiplier*caster:GetAgility()
		else
			damage = damage + multiplier*caster:GetIntellect()
		end
	end

	-- create projectile
	local info = {
		Target = target,
		Source = caster,
		Ability = self,	
		
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bDodgeable = false,                           -- Optional
	
		bVisibleToEnemies = true,                         -- Optional

		bProvidesVision = true,                           -- Optional
		iVisionRadius = projectile_vision,                              -- Optional
		iVisionTeamNumber = caster:GetTeamNumber(),        -- Optional

		ExtraData = {
			damage = damage,
		}
	}
	ProjectileManager:CreateTrackingProjectile(info)


	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_skywrath_mage_int9")	
	if abil ~= nil then 
		local scepter_radius = self:GetSpecialValueFor( "scepter_radius" )
		
		-- find nearby enemies
		local enemies = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			target:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			scepter_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)

		local target_2 = nil
		-- prioritize hero
		for _,enemy in pairs(enemies) do
			if enemy~=target and enemy:IsHero() then
				target_2 = enemy
				break
			end
		end

		-- no secondary hero found, find creep
		if not target_2 then
			-- 'enemies' will only have at max 1 hero (others are creeps), which would be 'target'
			target_2 = enemies[1]		-- could be nil
			if target_2==target then
				target_2 = enemies[2]	-- could be nil
			end
		end

		if target_2 then
			-- launch projectile
			info.Target = target_2
			ProjectileManager:CreateTrackingProjectile(info)
		end
	end

	-- play effects
	local sound_cast = "Hero_SkywrathMage.ArcaneBolt.Cast"
	EmitSoundOn( sound_cast, caster )
	
end
--------------------------------------------------------------------------------
-- Projectile
function skywrath_mage_arcane_bolt_lua:OnProjectileHit_ExtraData( target, location, extraData )
	if not target then return end	

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end

	self.mult = 1
	local m = target:FindModifierByName("modifier_special_bonus_unique_npc_dota_hero_skywrath_mage_agi50")
	if m then
		self.mult = m:GetStackCount() / 10 + self.mult
	end
	-- apply damage
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = extraData.damage * self.mult,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	-- vision
	local vision = self:GetSpecialValueFor( "bolt_vision" )
	local duration = self:GetSpecialValueFor( "vision_duration" )
	AddFOWViewer(
		self:GetCaster():GetTeamNumber(), --nTeamID
		target:GetOrigin(), --vLocation
		vision, --flRadius
		duration, --flDuration
		false --bObstructedVision
	)
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_skywrath_mage_agi50") then
		local m = target:FindModifierByName("modifier_special_bonus_unique_npc_dota_hero_skywrath_mage_agi50")
		if m then
			m:IncrementStackCount()
		else
			target:AddNewModifier(self:GetCaster(), self, "modifier_special_bonus_unique_npc_dota_hero_skywrath_mage_agi50", {duration = 60})
		end
	end
	-- play effects
	local sound_cast = "Hero_SkywrathMage.ArcaneBolt.Impact"
	EmitSoundOn( sound_cast, target )

	local sound_cast = "Hero_SkywrathMage.ArcaneBolt.Cast"
	StopSoundOn( sound_cast, self:GetCaster() )
end

modifier_special_bonus_unique_npc_dota_hero_skywrath_mage_agi50 = class({})
--Classifications template
function modifier_special_bonus_unique_npc_dota_hero_skywrath_mage_agi50:IsHidden()
	return true
end

function modifier_special_bonus_unique_npc_dota_hero_skywrath_mage_agi50:IsDebuff()
	return true
end

function modifier_special_bonus_unique_npc_dota_hero_skywrath_mage_agi50:IsPurgable()
	return false
end

function modifier_special_bonus_unique_npc_dota_hero_skywrath_mage_agi50:IsPurgeException()
	return false
end

-- Optional Classifications
function modifier_special_bonus_unique_npc_dota_hero_skywrath_mage_agi50:IsStunDebuff()
	return false
end

function modifier_special_bonus_unique_npc_dota_hero_skywrath_mage_agi50:RemoveOnDeath()
	return true
end

function modifier_special_bonus_unique_npc_dota_hero_skywrath_mage_agi50:DestroyOnExpire()
	return true
end

function modifier_special_bonus_unique_npc_dota_hero_skywrath_mage_agi50:OnCreated()
	if not IsServer() then
		return
	end
	self:SetStackCount(1)
end