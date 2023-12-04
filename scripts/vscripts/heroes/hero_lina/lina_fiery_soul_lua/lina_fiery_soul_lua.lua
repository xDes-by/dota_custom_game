lina_fiery_soul_lua = class({})
LinkLuaModifier( "modifier_lina_fiery_soul_lua", "heroes/hero_lina/lina_fiery_soul_lua/lina_fiery_soul_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_flame2", "heroes/hero_lina/lina_fiery_soul_lua/lina_fiery_soul_lua", LUA_MODIFIER_MOTION_NONE )

function lina_fiery_soul_lua:GetIntrinsicModifierName()
	return "modifier_lina_fiery_soul_lua"
end

----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------

modifier_lina_fiery_soul_lua = class({})

function modifier_lina_fiery_soul_lua:IsHidden()
	return self:GetStackCount()==0
end

function modifier_lina_fiery_soul_lua:IsDebuff()
	return false
end

function modifier_lina_fiery_soul_lua:IsPurgable()
	return false
end

function modifier_lina_fiery_soul_lua:DestroyOnExpire()
	return false
end

--------------------------------------------------------------------------------
function modifier_lina_fiery_soul_lua:OnCreated( kv )
	self.as_bonus = self:GetAbility():GetSpecialValueFor( "fiery_soul_attack_speed_bonus" )
	self.ms_bonus = self:GetAbility():GetSpecialValueFor( "fiery_soul_move_speed_bonus" )
	self.max_stacks = self:GetAbility():GetSpecialValueFor( "fiery_soul_max_stacks" )
	self.duration = self:GetAbility():GetSpecialValueFor( "fiery_soul_stack_duration" )
	if not IsServer() then return end
	self:PlayEffects()
end

function modifier_lina_fiery_soul_lua:OnRefresh( kv )
	self.as_bonus = self:GetAbility():GetSpecialValueFor( "fiery_soul_attack_speed_bonus" )
	self.ms_bonus = self:GetAbility():GetSpecialValueFor( "fiery_soul_move_speed_bonus" )
	self.max_stacks = self:GetAbility():GetSpecialValueFor( "fiery_soul_max_stacks" )
	self.duration = self:GetAbility():GetSpecialValueFor( "fiery_soul_stack_duration" )
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_lina_agi8")	
	if abil ~= nil then 
	self.as_bonus = self:GetAbility():GetSpecialValueFor( "fiery_soul_attack_speed_bonus" ) * 2
	self.ms_bonus = self:GetAbility():GetSpecialValueFor( "fiery_soul_move_speed_bonus" ) * 2
	self.max_stacks = self:GetAbility():GetSpecialValueFor( "fiery_soul_max_stacks" ) * 2
	self.duration = self:GetAbility():GetSpecialValueFor( "fiery_soul_stack_duration" ) * 2
	end
end

function modifier_lina_fiery_soul_lua:OnRemoved()
end

function modifier_lina_fiery_soul_lua:OnDestroy()
end

function modifier_lina_fiery_soul_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_lina_fiery_soul_lua:OnTakeDamage(keys)
local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_lina_str10")	
		if abil == nil then return end
		if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_lina_str50") then return end
		if IsServer() and self:GetAbility() then
			local caster = self:GetCaster()
			local parent = self:GetParent()
			local ability = self:GetAbility()
			local attacker = keys.attacker
			local target = keys.unit

			if not target:IsRealHero() then return end
			if parent:PassivesDisabled() then return end
			if keys.inflictor and keys.inflictor:GetName() == "pudge_dispersion" then return end
			
			if attacker:GetTeamNumber() ~= parent:GetTeamNumber() and parent == target and not attacker:IsOther() then
			attacker:AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_lina_flame2", -- modifier name
			{ duration = 2 } -- kv
		)
		end
	end
end


function modifier_lina_fiery_soul_lua:GetModifierMoveSpeedBonus_Constant( params )
	return self:GetStackCount() * self.ms_bonus
end

function modifier_lina_fiery_soul_lua:GetModifierAttackSpeedBonus_Constant( params )
	return self:GetStackCount() * self.as_bonus
end

function modifier_lina_fiery_soul_lua:GetModifierBaseAttack_BonusDamage( params )
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_lina_agi7")	
	if abil ~= nil then 
	return self:GetStackCount() * self.as_bonus * 2
	end
	return 0
end

function modifier_lina_fiery_soul_lua:GetModifierPhysicalArmorBonus( params )
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_lina_str6")	
	if abil ~= nil then 
	return self:GetStackCount() * self.ms_bonus / 3
	end
	return 0
end

function modifier_lina_fiery_soul_lua:GetModifierMagicalResistanceBonus( params )
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_lina_str9")	
	if abil ~= nil then 
	return self:GetStackCount() * self.ms_bonus / 3
	end
	return 0
end

function modifier_lina_fiery_soul_lua:OnAbilityExecuted( params )
	if not IsServer() then return end
	if params.unit~=self:GetParent() then return end
	if self:GetParent():PassivesDisabled() then return end
	if not params.ability then return end
	if params.ability:IsItem() or params.ability:IsToggle() then return end
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_lina_agi10")	
	if abil ~= nil then 
	self.max_stacks = self:GetAbility():GetSpecialValueFor( "fiery_soul_max_stacks" ) + 4
	end	

	if self:GetStackCount()<self.max_stacks then
		self:IncrementStackCount()
	end

	self:SetDuration( self.duration, true )
	self:StartIntervalThink( self.duration )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self:GetStackCount(), 0, 0 ) )
end

function modifier_lina_fiery_soul_lua:OnIntervalThink()
	-- Expire
	self:StartIntervalThink( -1 )
	self:SetStackCount( 0 )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self:GetStackCount(), 0, 0 ) )
end

function modifier_lina_fiery_soul_lua:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_lina/lina_fiery_soul.vpcf"

	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self:GetStackCount(), 0, 0 ) )

	-- buff particle
	self:AddParticle(
		self.effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
end

function modifier_lina_fiery_soul_lua:OnAttackLanded(params)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_lina_agi_last") ~= nil and RandomInt(1, 100) <= 5 and params.attacker:FindAbilityByName("lina_laguna_blade_lua") ~= nil and not params.attacker:IsMagicImmune() and not params.attacker:IsBuilding() then
		if params.attacker:FindAbilityByName("lina_laguna_blade_lua"):IsTrained() then
			_G.lagunatarget = params.target
			params.attacker:FindAbilityByName("lina_laguna_blade_lua"):OnSpellStart()
		end
	end
	if  params.attacker:FindAbilityByName("lina_dragon_slave_lua") ~= nil and self:GetCaster():FindAbilityByName("npc_dota_hero_lina_int_last") ~= nil and RandomInt(1, 4) == 1 then
		if params.attacker:FindAbilityByName("lina_dragon_slave_lua"):IsTrained() then
			_G.slavetarget = params.target
			params.attacker:FindAbilityByName("lina_dragon_slave_lua"):OnSpellStart()
		end
	end
end

function modifier_lina_fiery_soul_lua:IsAura()
	return self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_lina_str50") ~= nil
end

function modifier_lina_fiery_soul_lua:GetModifierAura() 
	return "modifier_lina_flame2" 
end

function modifier_lina_fiery_soul_lua:GetAuraRadius()
	return 800
end

function modifier_lina_fiery_soul_lua:GetAuraSearchFlags() 
	return DOTA_UNIT_TARGET_FLAG_NONE 
end

function modifier_lina_fiery_soul_lua:GetAuraSearchTeam() 
	return DOTA_UNIT_TARGET_TEAM_ENEMY 
end

function modifier_lina_fiery_soul_lua:GetAuraSearchType() 
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------


modifier_lina_flame2 = class({})


function modifier_lina_flame2:IsHidden()
	return false
end

function modifier_lina_flame2:IsDebuff()
	return true
end

function modifier_lina_flame2:IsStunDebuff()
	return false
end

function modifier_lina_flame2:IsPurgable()
	return true
end

function modifier_lina_flame2:GetAttributes()
	return MODIFIER_ATTRIBUTE_NONE
end

function modifier_lina_flame2:OnCreated( kv )
	damage = self:GetAbility():GetCaster():GetStrength()/2
	if self:GetCaster():FindAbilityByName("npc_dota_hero_lina_str_last") ~= nil then
		damage = damage + self:GetCaster():GetStrength() * 3.5
	end
	damage_type = DAMAGE_TYPE_MAGICAL
	damage = damage / 2
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = damage_type,
		ability = self, --Optional.
	}

	self:StartIntervalThink( 0.5 )
end

function modifier_lina_flame2:OnRefresh( kv )
end

function modifier_lina_flame2:OnRemoved()
end

function modifier_lina_flame2:OnDestroy()
end


function modifier_lina_flame2:OnIntervalThink()
	if not IsServer() then return end
	ApplyDamage( self.damageTable )
end


function modifier_lina_flame2:GetEffectName()
	return "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_debuff.vpcf"
end

function modifier_lina_flame2:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
