LinkLuaModifier( "modifier_silencer_glaives_of_wisdom_lua", "heroes/hero_silencer/glaives_of_wisdom_lua/glaives_of_wisdom_lua.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_silencer_glaives_of_wisdom_lua_orb", "heroes/hero_silencer/glaives_of_wisdom_lua/glaives_of_wisdom_lua.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_silencer_glaives_of_wisdom_lua_melee", "heroes/hero_silencer/glaives_of_wisdom_lua/glaives_of_wisdom_lua.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_silencer_glaives_of_wisdom_shild", "heroes/hero_silencer/glaives_of_wisdom_lua/glaives_of_wisdom_lua.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_silencer_glaives_of_wisdom_talent", "heroes/hero_silencer/glaives_of_wisdom_lua/glaives_of_wisdom_lua.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_silencer_glaives_of_wisdom_silence", "heroes/hero_silencer/glaives_of_wisdom_lua/glaives_of_wisdom_lua.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_silencer_glaives_of_wisdom_silence_debuff", "heroes/hero_silencer/glaives_of_wisdom_lua/glaives_of_wisdom_lua.lua", LUA_MODIFIER_MOTION_NONE )

silencer_glaives_of_wisdom_lua = {}

function silencer_glaives_of_wisdom_lua:GetIntrinsicModifierName()
	return "modifier_silencer_glaives_of_wisdom_lua"
end

function silencer_glaives_of_wisdom_lua:GetManaCost(iLevel)
    local caster = self:GetCaster()
	if caster:FindAbilityByName("npc_dota_hero_silencer_str8") then 
		return 0 
	end
    return 30 + math.min(65000, caster:GetIntellect() / 250)
end

function silencer_glaives_of_wisdom_lua:CastFilterResultTarget( hTarget )
	local flag = 0
	if self:GetCaster():HasScepter() then
		flag = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES 
	end

	local nResult = UnitFilter(
		hTarget,
		DOTA_UNIT_TARGET_TEAM_BOTH,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		flag,
		self:GetCaster():GetTeamNumber()
	)
	if nResult ~= UF_SUCCESS then
		return nResult
	end

	return UF_SUCCESS
end

function silencer_glaives_of_wisdom_lua:GetProjectileName()
	return "particles/units/heroes/hero_silencer/silencer_glaives_of_wisdom.vpcf"
end

function silencer_glaives_of_wisdom_lua:OnOrbFire( params )
	EmitSoundOn( "Hero_Silencer.GlaivesOfWisdom", self:GetCaster() )
end

function silencer_glaives_of_wisdom_lua:OnOrbImpact( params )
	if params.target:IsBuilding() then return end
	self:ApplyDamage( params.target, self:GetDamage() )
	EmitSoundOn( "Hero_Silencer.GlaivesOfWisdom.Damage", params.target )
end

function silencer_glaives_of_wisdom_lua:GetDamage()
	local eblan = 2.0
	local damage = self:GetSpecialValueFor("damage")
	if self:GetCaster():FindAbilityByName("npc_dota_hero_silencer_int_last") then
		damage = damage + self:GetCaster():GetIntellect() * self:GetSpecialValueFor("intellect_damage_pct") / 100 * eblan * 2.5
	else
		damage = damage + self:GetCaster():GetIntellect() * self:GetSpecialValueFor("intellect_damage_pct") / 100 * eblan
	end
	return damage
end

function silencer_glaives_of_wisdom_lua:ApplyDamage( target, damage )
	local caster = self:GetCaster()
	if caster == target then return end
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		damage_flags = DOTA_DAMAGE_FLAG_MAGIC_AUTO_ATTACK,
		ability = self,
	}
	ApplyDamage(damageTable)

	SendOverheadEventMessage(
		nil,
		OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,
		target,
		damage,
		nil
	)
	if caster:FindAbilityByName("npc_dota_hero_silencer_str6") then
		target:AddNewModifier(caster, self, "modifier_silencer_glaives_of_wisdom_silence", {})
	end
	if caster:FindAbilityByName("npc_dota_hero_silencer_str11") then
		local modifier_shild = caster:FindModifierByName("modifier_silencer_glaives_of_wisdom_shild")
		modifier_shild:SetStackCount( modifier_shild:GetStackCount() + damage)
	end
	if caster:FindAbilityByName("npc_dota_hero_silencer_int6") then
		if caster:FindAbilityByName("npc_dota_hero_silencer_int9") and RollPseudoRandomPercentage(17, caster:entindex(), caster) then
			local modifier_silencer_glaives_of_wisdom_lua = caster:FindModifierByName("modifier_silencer_glaives_of_wisdom_lua")
			modifier_silencer_glaives_of_wisdom_lua:IncrementStackCount()
		else
			caster:AddNewModifier(
				caster,
				self,
				"modifier_silencer_glaives_of_wisdom_talent",
				{
					duration = 120, 
					damage = self:GetSpecialValueFor("intellect_per_stack"),
				}
			)
		end
	end
end

function silencer_glaives_of_wisdom_lua:OnProjectileHit_ExtraData( target, location, data )
	if not target then return end
	-- perform attack
	self.split = true
	self.split_procs = data.procs==1
	self:GetCaster():PerformAttack( target, true, true, true, false, false, false, false )
	self.split = false
end

modifier_silencer_glaives_of_wisdom_lua = {}

function modifier_silencer_glaives_of_wisdom_lua:IsHidden()
	return false
end

function modifier_silencer_glaives_of_wisdom_lua:IsDebuff()
	return false
end

function modifier_silencer_glaives_of_wisdom_lua:IsPurgable()
	return false
end

function modifier_silencer_glaives_of_wisdom_lua:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "steal_range" )
	self.steal = 2
	if not IsServer() then return end

	self:GetParent():AddNewModifier(
		self:GetCaster(),
		self:GetAbility(),
		"modifier_silencer_glaives_of_wisdom_lua_orb",
		{}
	)
	self:GetParent():AddNewModifier(
		self:GetCaster(),
		self:GetAbility(),
		"modifier_silencer_glaives_of_wisdom_shild",
		{}
	)
	self:StartIntervalThink(0.1)
end

function modifier_silencer_glaives_of_wisdom_lua:OnRefresh( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "steal_range" )
	self.steal = 2
	if not IsServer() then return end
end

function modifier_silencer_glaives_of_wisdom_lua:ColculateIntellect()
	int = self:GetStackCount() * self:GetAbility():GetSpecialValueFor("intellect_per_stack")
	if self:GetCaster():FindAbilityByName("npc_dota_hero_silencer_int7") then
		int = int * 1.5
	end
	return int
end

function modifier_silencer_glaives_of_wisdom_lua:DeclareFunctions()
	return { 
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_silencer_glaives_of_wisdom_lua:OnTooltip()
    return self:ColculateIntellect()
end

function modifier_silencer_glaives_of_wisdom_lua:OnDeath(params)
	local caster = self:GetCaster()
	if IsMyKilledBadGuys(caster, params) then
		self:IncrementStackCount()
		if caster:FindAbilityByName("npc_dota_hero_silencer_int10") then
			local heroes = FindUnitsInRadius(
				caster:GetTeamNumber(),	-- int, your team number
				caster:GetOrigin(),	-- point, center point
				nil,	-- handle, cacheUnit. (not known)
				1000,	-- float, radius. or use FIND_UNITS_EVERYWHERE
				DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
				DOTA_UNIT_TARGET_HERO,	-- int, type filter
				DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
				0,	-- int, order filter
				false	-- bool, can grow cache
			)
			if #heroes == 1 and RollPseudoRandomPercentage(10, caster:entindex(), caster) then
				self:IncrementStackCount()
			end
		end
	elseif caster:FindAbilityByName("npc_dota_hero_silencer_int10") then
		local pos1 = self:GetCaster():GetAbsOrigin()
		local pos2 = params.unit:GetAbsOrigin()

		local distance = (pos1 - pos2):Length2D()
		if distance <= 800 then
			self:IncrementStackCount()
		end
	end
end

function modifier_silencer_glaives_of_wisdom_lua:OnTakeDamage(params)
	if params.attacker == self:GetParent() and bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_MAGIC_AUTO_ATTACK) ~= DOTA_DAMAGE_FLAG_MAGIC_AUTO_ATTACK and self:GetCaster():FindAbilityByName("npc_dota_hero_silencer_agi_last") and params.damage_category == DOTA_DAMAGE_CATEGORY_SPELL then
		self:GetAbility():ApplyDamage(params.unit, self:GetAbility():GetDamage() * 1.5)
	end
end

function modifier_silencer_glaives_of_wisdom_lua:GetModifierProjectileSpeedBonus(params)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_silencer_agi7") then
    	return 1000
	end
end

function modifier_silencer_glaives_of_wisdom_lua:GetModifierAttackSpeedBonus_Constant()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_silencer_agi9") then
        return self:GetCaster():GetIntellect() * 0.10
    end
end

function modifier_silencer_glaives_of_wisdom_lua:GetModifierBonusStats_Intellect()
	return self:ColculateIntellect()
end

function modifier_silencer_glaives_of_wisdom_lua:OnIntervalThink()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_silencer_agi6") and self:GetAbility():GetAutoCastState() and not self:GetCaster():HasModifier("modifier_silencer_glaives_of_wisdom_lua_melee") then
		self:GetParent():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_silencer_glaives_of_wisdom_lua_melee", {} )
	elseif ( not self:GetCaster():FindAbilityByName("npc_dota_hero_silencer_agi6") or not self:GetAbility():GetAutoCastState() ) and self:GetCaster():HasModifier("modifier_silencer_glaives_of_wisdom_lua_melee") then
		self:GetParent():RemoveModifierByName("modifier_silencer_glaives_of_wisdom_lua_melee")
	end
end

function modifier_silencer_glaives_of_wisdom_lua:GetModifierProcAttack_Feedback( params )
	if not IsServer() then return end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_silencer_agi8") == nil then return end
	if self:GetAbility():GetAutoCastState() == false then return end

	if self:GetAbility().split then return end

	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		params.target:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		200,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
		FIND_CLOSEST,	-- int, order filter
		false	-- bool, can grow cache
	)

	local count = 0
	for _,enemy in pairs(enemies) do
		if enemy~=params.target and count<2 then

			-- roll pierce armor chance
			local procs = false
			if self.active and self.proc then
				procs = true
			end
			self.info = {
				Ability = self:GetAbility(),	
				
				EffectName = self:GetParent():GetRangedProjectileName(),
				iMoveSpeed = self:GetParent():GetProjectileSpeed(),
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,		
			
				bDodgeable = true,                           -- Optional
				bIsAttack = true,                                -- Optional
		
				ExtraData = {},
			}
			self.info.Target = enemy
			self.info.Source = params.target
			self.info.EffectName = self:GetParent():GetRangedProjectileName()
			self.info.ExtraData = {
				procs = false,
			}
			ProjectileManager:CreateTrackingProjectile( self.info )

			count = count+1
		end
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

modifier_silencer_glaives_of_wisdom_lua_orb = {}

function modifier_silencer_glaives_of_wisdom_lua_orb:IsHidden()
	return true
end

function modifier_silencer_glaives_of_wisdom_lua_orb:IsDebuff()
	return false
end

function modifier_silencer_glaives_of_wisdom_lua_orb:IsPurgable()
	return false
end

function modifier_silencer_glaives_of_wisdom_lua_orb:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_silencer_glaives_of_wisdom_lua_orb:OnCreated( kv )
	self.ability = self:GetAbility()
	self.cast = false
	self.records = {}
end

function modifier_silencer_glaives_of_wisdom_lua_orb:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_FAIL,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY,
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_PROJECTILE_NAME
	}
end

function modifier_silencer_glaives_of_wisdom_lua_orb:OnAttack( params )
	if params.attacker~=self:GetParent() then return end

	if self:ShouldLaunch( params.target ) then
		self.ability:UseResources( true, false, false, true )

		self.records[params.record] = true

		if self.ability.OnOrbFire then
			self.ability:OnOrbFire( params )
		end
	end

	self.cast = false
end
function modifier_silencer_glaives_of_wisdom_lua_orb:GetModifierProcAttack_Feedback( params )
	if self.records[params.record] then
		if self.ability.OnOrbImpact then self.ability:OnOrbImpact( params ) end
	end
end
function modifier_silencer_glaives_of_wisdom_lua_orb:OnAttackFail( params )
	if self.records[params.record] then
		if self.ability.OnOrbFail then self.ability:OnOrbFail( params ) end
	end
end
function modifier_silencer_glaives_of_wisdom_lua_orb:OnAttackRecordDestroy( params )
	self.records[params.record] = nil
end

function modifier_silencer_glaives_of_wisdom_lua_orb:OnOrder( params )
	if not IsServer() then return end
	if params.unit~=self:GetParent() then return end

	if params.ability then
		if params.ability==self:GetAbility() then
			self.cast = true
			return
		end

		local pass = false
		local behavior = tonumber( tostring( params.ability:GetBehavior() ) )
		if self:FlagExist( behavior, DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_CHANNEL ) or 
			self:FlagExist( behavior, DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_MOVEMENT ) or
			self:FlagExist( behavior, DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL )
		then
			local pass = true
		end

		if self.cast and (not pass) then
			self.cast = false
		end
	else
		if self.cast then
			if self:FlagExist( params.order_type, DOTA_UNIT_ORDER_MOVE_TO_POSITION ) or
				self:FlagExist( params.order_type, DOTA_UNIT_ORDER_MOVE_TO_TARGET )	or
				self:FlagExist( params.order_type, DOTA_UNIT_ORDER_ATTACK_MOVE ) or
				self:FlagExist( params.order_type, DOTA_UNIT_ORDER_ATTACK_TARGET ) or
				self:FlagExist( params.order_type, DOTA_UNIT_ORDER_STOP ) or
				self:FlagExist( params.order_type, DOTA_UNIT_ORDER_HOLD_POSITION )
			then
				self.cast = false
			end
		end
	end
end

function modifier_silencer_glaives_of_wisdom_lua_orb:GetModifierProjectileName()
	if not self.ability.GetProjectileName then return end

	if self:ShouldLaunch( self:GetCaster():GetAggroTarget() ) then
		return self.ability:GetProjectileName()
	end
end

function modifier_silencer_glaives_of_wisdom_lua_orb:ShouldLaunch( target )
	if self.ability:GetAutoCastState() then
		if self.ability.CastFilterResultTarget~=CDOTA_Ability_Lua.CastFilterResultTarget then
			if self.ability:CastFilterResultTarget( target )==UF_SUCCESS then
				self.cast = true
			end
		else
			local nResult = UnitFilter(
				target,
				self.ability:GetAbilityTargetTeam(),
				self.ability:GetAbilityTargetType(),
				self.ability:GetAbilityTargetFlags(),
				self:GetCaster():GetTeamNumber()
			)
			if nResult == UF_SUCCESS then
				self.cast = true
			end
		end
	end

	if self.cast and self.ability:IsFullyCastable() and (not self:GetParent():IsSilenced()) then
		return true
	end

	return false
end

function modifier_silencer_glaives_of_wisdom_lua_orb:FlagExist(a,b)
	local p,c,d=1,0,b
	while a>0 and b>0 do
		local ra,rb=a%2,b%2
		if ra+rb>1 then c=c+p end
		a,b,p=(a-ra)/2,(b-rb)/2,p*2
	end
	return c==d
end

modifier_silencer_glaives_of_wisdom_lua_melee = class({})
function modifier_silencer_glaives_of_wisdom_lua_melee:AllowIllusionDuplicate() return true end
function modifier_silencer_glaives_of_wisdom_lua_melee:IsDebuff() return false end
function modifier_silencer_glaives_of_wisdom_lua_melee:IsHidden() return true end
function modifier_silencer_glaives_of_wisdom_lua_melee:IsPurgable() return false end
function modifier_silencer_glaives_of_wisdom_lua_melee:IsPurgeException() return false end
function modifier_silencer_glaives_of_wisdom_lua_melee:IsStunDebuff() return false end
function modifier_silencer_glaives_of_wisdom_lua_melee:RemoveOnDeath() return false end

function modifier_silencer_glaives_of_wisdom_lua_melee:OnCreated()
	if IsServer() then
		self:GetCaster():SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
	end
end

function modifier_silencer_glaives_of_wisdom_lua_melee:OnDestroy()
	if IsServer() then
		self:GetCaster():SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
	end
end

function modifier_silencer_glaives_of_wisdom_lua_melee:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
			MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
		}
	return decFuns
end

function modifier_silencer_glaives_of_wisdom_lua_melee:GetAttackSound()
	return "Hero_TrollWarlord.ProjectileImpact"
end

function modifier_silencer_glaives_of_wisdom_lua_melee:GetModifierAttackRangeBonus()
	return -350
end

modifier_silencer_glaives_of_wisdom_talent = class({})
-- local tempTable = require("util/tempTable")

--------------------------------------------------------------------------------
-- Classifications
function modifier_silencer_glaives_of_wisdom_talent:IsHidden()
	return false
end

function modifier_silencer_glaives_of_wisdom_talent:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
-- function modifier_silencer_glaives_of_wisdom_talent:OnCreated( kv )
-- 	if IsServer() then
-- 		self.duration = kv.duration
-- 		self.damage = kv.damage
-- 		self:AddStack()
-- 		self:IncrementStackCount()
-- 	end
-- end

function modifier_silencer_glaives_of_wisdom_talent:OnCreated( kv )
	if IsServer() then
		self.duration = kv.duration
		self.damage = kv.damage
		self.stack_table = {}
		self:IncrementStackCount()
		self:StartIntervalThink(1)
	end    
end

function modifier_silencer_glaives_of_wisdom_talent:OnRefresh()
	if IsServer() then
		self:IncrementStackCount()
	end    
end

function modifier_silencer_glaives_of_wisdom_talent:OnIntervalThink()
	local repeat_needed = true
	while repeat_needed do
		local item_time = self.stack_table[1]
		if GameRules:GetGameTime() - item_time >= self.duration then
			if self:GetStackCount() == 0 then
				self:Destroy()
				break
			else
				table.remove(self.stack_table, 1)
				self:DecrementStackCount()
			end
		else
			repeat_needed = false
		end
	end
end

function modifier_silencer_glaives_of_wisdom_talent:OnStackCountChanged(prev_stacks)
	if not IsServer() then return end
	if self:GetStackCount() > prev_stacks then
		table.insert(self.stack_table, GameRules:GetGameTime()) 
	end
end

function modifier_silencer_glaives_of_wisdom_talent:OnRefresh( kv )
	if IsServer() then 
		self:IncrementStackCount()
	end
end
function modifier_silencer_glaives_of_wisdom_talent:DeclareFunctions()
	return { 
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_silencer_glaives_of_wisdom_talent:OnTooltip()
    return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("intellect_per_stack")
end

function modifier_silencer_glaives_of_wisdom_talent:GetModifierBonusStats_Intellect()
	if IsServer() then
		return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("intellect_per_stack")
	end
end

modifier_silencer_glaives_of_wisdom_shild = class({})
-- local tempTable = require("util/tempTable")

--------------------------------------------------------------------------------
-- Classifications
function modifier_silencer_glaives_of_wisdom_shild:IsHidden()
	return true
end

function modifier_silencer_glaives_of_wisdom_shild:IsPurgable()
	return false
end

function modifier_silencer_glaives_of_wisdom_shild:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_silencer_glaives_of_wisdom_shild:OnCreated( kv )
end

function modifier_silencer_glaives_of_wisdom_shild:DeclareFunctions()
	return { 
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
	}
end

function modifier_silencer_glaives_of_wisdom_shild:GetModifierIncomingDamageConstant( event )
	if not IsServer() then return self:GetStackCount() end
	local stackCount = self:GetStackCount()
    if self:GetParent():IsRealHero() then
        if stackCount >= event.damage then
            self:SetStackCount(stackCount - event.damage)
			return -event.damage
		elseif stackCount > 0 then
			self:SetStackCount(0)
			return -stackCount
		end
    end
end

function modifier_silencer_glaives_of_wisdom_shild:GetModifierProcAttack_Feedback( kv )
	
end

modifier_silencer_glaives_of_wisdom_silence = class({})
-- local tempTable = require("util/tempTable")

--------------------------------------------------------------------------------
-- Classifications
function modifier_silencer_glaives_of_wisdom_silence:IsHidden()
	return false
end

function modifier_silencer_glaives_of_wisdom_silence:IsPurgable()
	return false
end

function modifier_silencer_glaives_of_wisdom_silence:IsDebuff()
	return true
end

function modifier_silencer_glaives_of_wisdom_silence:OnCreated()
	if IsServer() then
		self:IncrementStackCount()
	end
end

function modifier_silencer_glaives_of_wisdom_silence:OnRefresh()
	if IsServer() then
		self:IncrementStackCount()
	end
end

function modifier_silencer_glaives_of_wisdom_silence:OnStackCountChanged(prev_stacks)
	if not IsServer() then return end
	if self:GetStackCount() == 3 then
		self:SetStackCount(1)
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_silencer_glaives_of_wisdom_silence_debuff", {duration = 0.1})
	end
end

modifier_silencer_glaives_of_wisdom_silence_debuff = class({})
-- local tempTable = require("util/tempTable")

--------------------------------------------------------------------------------
-- Classifications
function modifier_silencer_glaives_of_wisdom_silence_debuff:IsHidden()
	return false
end

function modifier_silencer_glaives_of_wisdom_silence_debuff:IsPurgable()
	return true
end

function modifier_silencer_glaives_of_wisdom_silence_debuff:IsDebuff()
	return true
end

function modifier_silencer_glaives_of_wisdom_silence_debuff:CheckState()
	return { [MODIFIER_STATE_SILENCED] = true }
end