raid_clap = class({})
LinkLuaModifier( "modifier_raid_clap", "abilities/bosses/raid_boss3.lua"	, LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_arc_lua", "heroes/generic/modifier_generic_arc_lua", LUA_MODIFIER_MOTION_BOTH )
--------------------------------------------------------------------------------

function raid_clap:OnSpellStart()
	self.slow_radius = self:GetSpecialValueFor("shock_radius")
	local ability_damage = self:GetAbilityDamage()
	local shok = 0
	Timers:CreateTimer("raid_shok", {
        useGameTime = true,
        endTime = 0,
        callback = function()
		shok = shok + 1

		if shok == 4 then Timers:RemoveTimer("raid_shok") end
		self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, 0.3)
		self.slow_radius = self.slow_radius + 200
		local enemies = FindUnitsInRadius (
			self:GetCaster():GetTeamNumber(),
			self:GetCaster():GetOrigin(),
			nil,
			self.slow_radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false
		)
		
	if self:GetCaster():HasModifier("modifier_raid_enrage_1") then 
	try_damage_type = DAMAGE_TYPE_PHYSICAL
	elseif self:GetCaster():HasModifier("modifier_raid_enrage_3") then 
	try_damage_type = DAMAGE_TYPE_PURE
	else
	try_damage_type = DAMAGE_TYPE_MAGICAL
	end

	for _,enemy in pairs(enemies) do
		local damage = {
			victim = enemy,
			attacker = self:GetCaster(),
			damage = enemy:GetMaxHealth()*0.15,
			damage_type = try_damage_type,
			ability = self
		}
		ApplyDamage( damage )

		enemy:AddNewModifier(
			self:GetCaster(),
			self,
			"modifier_raid_clap",
			{ duration = 0.6 }
		)
	end
	self:PlayEffects(self.slow_radius)
	return 1
	end})	
end

function raid_clap:PlayEffects(slow_radius)
	local sound_cast = "Hero_Ursa.Earthshock"
	local particle_cast = "particles/units/heroes/hero_ursa/ursa_earthshock.vpcf"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 0, self:GetCaster():GetForwardVector() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector(slow_radius/2, slow_radius/2, slow_radius/2) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( sound_cast, self:GetCaster() )
end

-------------------------------------------------------------------------------------------------------------

modifier_raid_clap = class({})

function modifier_raid_clap:IsDebuff()
	return true
end

function modifier_raid_clap:OnCreated( kv )
	self.slow = self:GetAbility():GetSpecialValueFor("movement_slow")
	
	self.caster = self:GetCaster()
	if not IsServer() then return end
	self.arc = self:GetParent():AddNewModifier(self.caster,self:GetAbility(),"modifier_generic_arc_lua",
		{duration = 0.7,distance = 0,height = 200,fix_duration = false,isStun = true,activity = ACT_DOTA_FLAIL,})
end

function modifier_raid_clap:OnRefresh( kv )
	self.slow = self:GetAbility():GetSpecialValueFor("movement_slow")
end

function modifier_raid_clap:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_raid_clap:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end

function modifier_raid_clap:GetModifierAttackSpeedBonus_Constant()
	return self.slow * 5
end

function modifier_raid_clap:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_earthshock_modifier.vpcf"
end

function modifier_raid_clap:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------

raid_enrage = class({})
LinkLuaModifier( "modifier_raid_enrage_1", "abilities/bosses/raid_boss3.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_raid_enrage_2", "abilities/bosses/raid_boss3.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_raid_enrage_3", "abilities/bosses/raid_boss3.lua", LUA_MODIFIER_MOTION_NONE )

function raid_enrage:OnSpellStart()
	local duration = self:GetSpecialValueFor("duration")

	self:GetCaster():Purge(false, true, false, true, false)
	
	local int = RandomInt(1,3)

	self:GetCaster():AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_raid_enrage_" ..int,
		{ duration = duration }
	)
	self:PlayEffects()
end

function raid_enrage:PlayEffects()
	local sound_cast = "Hero_Ursa.Enrage"
	EmitSoundOn( sound_cast, self:GetCaster() )
end

---------------------------------------------------------------------------------------------------------------------

modifier_raid_enrage_1 = class({})  --only phys

function modifier_raid_enrage_1:IsHidden()
	return false
end

function modifier_raid_enrage_1:IsDebuff()
	return false
end

function modifier_raid_enrage_1:IsPurgable()
	return false
end

function modifier_raid_enrage_1:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_PROPERTY_MODEL_SCALE,
	}
	return funcs
end

function modifier_raid_enrage_1:GetAbsoluteNoDamageMagical( params )
	return 1
end

function modifier_raid_enrage_1:GetAbsoluteNoDamagePure( params )
	return 1
end

function modifier_raid_enrage_1:GetModifierModelScale( params )
	return 30
end

function modifier_raid_enrage_1:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_enrage_buff.vpcf"
end

function modifier_raid_enrage_1:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_raid_enrage_1:GetStatusEffectName()
	return "particles/raid_str.vpcf"
end

function modifier_raid_enrage_1:StatusEffectPriority()
	return 15 
end

---------------------------------------------------------------------------------------------------------------------

modifier_raid_enrage_2 = class({}) --only magic

function modifier_raid_enrage_2:IsHidden()
	return false
end

function modifier_raid_enrage_2:IsDebuff()
	return false
end

function modifier_raid_enrage_2:IsPurgable()
	return false
end

function modifier_raid_enrage_2:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_PROPERTY_MODEL_SCALE,
	}
	return funcs
end

function modifier_raid_enrage_2:GetAbsoluteNoDamagePhysical( params )
	return 1
end

function modifier_raid_enrage_2:GetAbsoluteNoDamagePure( params )
	return 1
end

function modifier_raid_enrage_2:GetModifierModelScale( params )
	return 30
end

function modifier_raid_enrage_2:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_enrage_buff.vpcf"
end

function modifier_raid_enrage_2:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_raid_enrage_2:GetStatusEffectName()
	return "particles/raid_mag.vpcf"
end

function modifier_raid_enrage_2:StatusEffectPriority()
	return 15 
end
 
---------------------------------------------------------------------------------------------------------------------

modifier_raid_enrage_3 = class({})  --only pure

function modifier_raid_enrage_3:IsHidden()
	return false
end

function modifier_raid_enrage_3:IsDebuff()
	return false
end

function modifier_raid_enrage_3:IsPurgable()
	return false
end

function modifier_raid_enrage_3:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_MODEL_SCALE,
	}
	return funcs
end

function modifier_raid_enrage_3:GetAbsoluteNoDamagePhysical( params )
	return 1
end

function modifier_raid_enrage_3:GetAbsoluteNoDamageMagical( params )
	return 1
end

function modifier_raid_enrage_3:GetModifierModelScale( params )
	return 30
end

function modifier_raid_enrage_3:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_enrage_buff.vpcf"
end

function modifier_raid_enrage_3:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_raid_enrage_3:GetStatusEffectName()
	return "particles/raid_pure.vpcf"
end

function modifier_raid_enrage_3:StatusEffectPriority()
	return 15 
end

---------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------

raid_berserk = class({})
LinkLuaModifier( "modifier_raid_berserk", "abilities/bosses/raid_boss3.lua"	, LUA_MODIFIER_MOTION_NONE )

function raid_berserk:GetIntrinsicModifierName()
	return "modifier_raid_berserk"
end

modifier_raid_berserk = class({})

function modifier_raid_berserk:IsHidden()
	return true
end

function modifier_raid_berserk:IsDebuff()
	return false
end

function modifier_raid_berserk:IsPurgable()
	return false
end

function modifier_raid_berserk:OnCreated( kv )	
		self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
		self.max_threshold = self:GetAbility():GetSpecialValueFor( "hp_threshold_max" )
		self.max_size = 35
		self:PlayEffects()
		self:StartIntervalThink(1)
end

function modifier_raid_berserk:OnRefresh( kv )
	raid_damage = 1-(self:GetParent():GetHealthPercent()-100)*self.damage
end

function modifier_raid_berserk:OnIntervalThink()
self:OnRefresh()
end

function modifier_raid_berserk:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_MODEL_SCALE,
	}
	return funcs
end

function modifier_raid_berserk:GetModifierBaseAttack_BonusDamage()
	return raid_damage
end

function modifier_raid_berserk:GetModifierModelScale()
	if IsServer() then
		local pct = math.max((self:GetParent():GetHealthPercent()-self.max_threshold)/90,0)
		ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( (1-pct)*100,0,0 ) )
		return (1-pct)*self.max_size
	end
end

function modifier_raid_berserk:PlayEffects()
	local particle_cast = "particles/units/heroes/hero_huskar/huskar_berserkers_blood_glow.vpcf"

	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )

	self:AddParticle(
		self.effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
end


-------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------

raid_shadow = class({})
LinkLuaModifier("modifier_raid_shadow_invis", "abilities/bosses/raid_boss3.lua", LUA_MODIFIER_MOTION_NONE)

function raid_shadow:OnSpellStart()
	local caster    =   self:GetCaster()
	local particle_invis_start = "particles/generic_hero_status/status_invisibility_start.vpcf"

	EmitSoundOn("DOTA_Item.InvisibilitySword.Activate", caster)
	Timers:CreateTimer(0.5, function()
		local particle_invis_start_fx = ParticleManager:CreateParticle(particle_invis_start, PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(particle_invis_start_fx, 0, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle_invis_start_fx)
		caster:AddNewModifier(caster, self, "modifier_raid_shadow_invis", {duration = 5})
	end)
end

modifier_raid_shadow_invis = class({})

function modifier_raid_shadow_invis:IsDebuff() return false end
function modifier_raid_shadow_invis:IsHidden() return false end
function modifier_raid_shadow_invis:IsPurgable() return false end

function modifier_raid_shadow_invis:OnCreated()
	if not self:GetAbility() then self:Destroy() return end
end	

function modifier_raid_shadow_invis:CheckState() 
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVISIBLE] = true,
	}
end

function modifier_raid_shadow_invis:GetPriority()
	return MODIFIER_PRIORITY_NORMAL
end

function modifier_raid_shadow_invis:DeclareFunctions() 
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT,
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
		MODIFIER_EVENT_ON_ATTACK
	}
end

function modifier_raid_shadow_invis:GetModifierPreAttack_BonusDamagePostCrit(params)
	if IsClient() or (not params.target:IsOther() and not params.target:IsBuilding()) then
		return 500000
	end
end

function modifier_raid_shadow_invis:GetModifierInvisibilityLevel()
	return 1
end

function modifier_raid_shadow_invis:OnAttack(params)
	if IsServer() then
		if params.attacker == self:GetParent() then
			self:Destroy()
		end
	end
end