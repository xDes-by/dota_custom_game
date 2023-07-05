item_sheepstick_lua1_gem1 = item_sheepstick_lua1_gem1 or class({})
item_sheepstick_lua2_gem1 = item_sheepstick_lua1_gem1 or class({})
item_sheepstick_lua3_gem1 = item_sheepstick_lua1_gem1 or class({})
item_sheepstick_lua4_gem1 = item_sheepstick_lua1_gem1 or class({})
item_sheepstick_lua5_gem1 = item_sheepstick_lua1_gem1 or class({})
item_sheepstick_lua6_gem1 = item_sheepstick_lua1_gem1 or class({})
item_sheepstick_lua7_gem1 = item_sheepstick_lua1_gem1 or class({})
item_sheepstick_lua8_gem1 = item_sheepstick_lua1_gem1 or class({})

item_sheepstick_lua1_gem2 = item_sheepstick_lua1_gem2 or class({})
item_sheepstick_lua2_gem2 = item_sheepstick_lua1_gem2 or class({})
item_sheepstick_lua3_gem2 = item_sheepstick_lua1_gem2 or class({})
item_sheepstick_lua4_gem2 = item_sheepstick_lua1_gem2 or class({})
item_sheepstick_lua5_gem2 = item_sheepstick_lua1_gem2 or class({})
item_sheepstick_lua6_gem2 = item_sheepstick_lua1_gem2 or class({})
item_sheepstick_lua7_gem2 = item_sheepstick_lua1_gem2 or class({})
item_sheepstick_lua8_gem2 = item_sheepstick_lua1_gem2 or class({})

item_sheepstick_lua1_gem3 = item_sheepstick_lua1_gem3 or class({})
item_sheepstick_lua2_gem3 = item_sheepstick_lua1_gem3 or class({})
item_sheepstick_lua3_gem3 = item_sheepstick_lua1_gem3 or class({})
item_sheepstick_lua4_gem3 = item_sheepstick_lua1_gem3 or class({})
item_sheepstick_lua5_gem3 = item_sheepstick_lua1_gem3 or class({})
item_sheepstick_lua6_gem3 = item_sheepstick_lua1_gem3 or class({})
item_sheepstick_lua7_gem3 = item_sheepstick_lua1_gem3 or class({})
item_sheepstick_lua8_gem3 = item_sheepstick_lua1_gem3 or class({})

item_sheepstick_lua1_gem4 = item_sheepstick_lua1_gem4 or class({})
item_sheepstick_lua2_gem4 = item_sheepstick_lua1_gem4 or class({})
item_sheepstick_lua3_gem4 = item_sheepstick_lua1_gem4 or class({})
item_sheepstick_lua4_gem4 = item_sheepstick_lua1_gem4 or class({})
item_sheepstick_lua5_gem4 = item_sheepstick_lua1_gem4 or class({})
item_sheepstick_lua6_gem4 = item_sheepstick_lua1_gem4 or class({})
item_sheepstick_lua7_gem4 = item_sheepstick_lua1_gem4 or class({})
item_sheepstick_lua8_gem4 = item_sheepstick_lua1_gem4 or class({})

item_sheepstick_lua1_gem5 = item_sheepstick_lua1_gem5 or class({})
item_sheepstick_lua2_gem5 = item_sheepstick_lua1_gem5 or class({})
item_sheepstick_lua3_gem5 = item_sheepstick_lua1_gem5 or class({})
item_sheepstick_lua4_gem5 = item_sheepstick_lua1_gem5 or class({})
item_sheepstick_lua5_gem5 = item_sheepstick_lua1_gem5 or class({})
item_sheepstick_lua6_gem5 = item_sheepstick_lua1_gem5 or class({})
item_sheepstick_lua7_gem5 = item_sheepstick_lua1_gem5 or class({})
item_sheepstick_lua8_gem5 = item_sheepstick_lua1_gem5 or class({})

LinkLuaModifier("modifier_gem1", 'items/items_gems/gem1', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem2", 'items/items_gems/gem2', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem3", 'items/items_gems/gem3', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem4", 'items/items_gems/gem4', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem5", 'items/items_gems/gem5', LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier( "modifier_sheepstick_lua_hex", "items/items_gems/item_sheepstick_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sheepstick_lua1", "items/items_gems/item_sheepstick_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sheepstick_lua2", "items/items_gems/item_sheepstick_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sheepstick_lua3", "items/items_gems/item_sheepstick_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sheepstick_lua4", "items/items_gems/item_sheepstick_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sheepstick_lua5", "items/items_gems/item_sheepstick_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sheepstick_lua_ignore", "items/items_gems/item_sheepstick_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_sheepstick_lua_flame","items/items_gems/item_sheepstick_lua", LUA_MODIFIER_MOTION_NONE)

function item_sheepstick_lua1_gem1:GetIntrinsicModifierName()
	return "modifier_sheepstick_lua1"
end
function item_sheepstick_lua1_gem2:GetIntrinsicModifierName()
	return "modifier_sheepstick_lua2"
end
function item_sheepstick_lua1_gem3:GetIntrinsicModifierName()
	return "modifier_sheepstick_lua3"
end
function item_sheepstick_lua1_gem4:GetIntrinsicModifierName()
	return "modifier_sheepstick_lua4"
end
function item_sheepstick_lua1_gem5:GetIntrinsicModifierName()
	return "modifier_sheepstick_lua5"
end
--------------------------------------------------------------------------------
-- Ability Start
function item_sheepstick_lua1_gem1:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end

	-- load data
	self.sheep_duration = self:GetSpecialValueFor("sheep_duration")
	if target:FindModifierByName("modifier_sheepstick_lua_ignore") ==  nil 
	then
		target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_sheepstick_lua_ignore", -- modifier name
		{ duration = 10 } -- kv
	)
	
	-- add modifier
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_sheepstick_lua_hex", -- modifier name
		{ duration = self.sheep_duration } -- kv
	)
	

	-- effects
	local sound_cast = "Hero_Lion.Voodoo"
	EmitSoundOn( sound_cast, caster )
	else
	return
end
end
function item_sheepstick_lua1_gem2:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end

	-- load data
	self.sheep_duration = self:GetSpecialValueFor("sheep_duration")
	if target:FindModifierByName("modifier_sheepstick_lua_ignore") ==  nil 
	then
		target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_sheepstick_lua_ignore", -- modifier name
		{ duration = 10 } -- kv
	)
	
	-- add modifier
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_sheepstick_lua_hex", -- modifier name
		{ duration = self.sheep_duration } -- kv
	)
	

	-- effects
	local sound_cast = "Hero_Lion.Voodoo"
	EmitSoundOn( sound_cast, caster )
	else
	return
end
end
function item_sheepstick_lua1_gem3:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end

	-- load data
	self.sheep_duration = self:GetSpecialValueFor("sheep_duration")
	if target:FindModifierByName("modifier_sheepstick_lua_ignore") ==  nil 
	then
		target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_sheepstick_lua_ignore", -- modifier name
		{ duration = 10 } -- kv
	)
	
	-- add modifier
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_sheepstick_lua_hex", -- modifier name
		{ duration = self.sheep_duration } -- kv
	)
	

	-- effects
	local sound_cast = "Hero_Lion.Voodoo"
	EmitSoundOn( sound_cast, caster )
	else
	return
end
end
function item_sheepstick_lua1_gem4:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end

	-- load data
	self.sheep_duration = self:GetSpecialValueFor("sheep_duration")
	if target:FindModifierByName("modifier_sheepstick_lua_ignore") ==  nil 
	then
		target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_sheepstick_lua_ignore", -- modifier name
		{ duration = 10 } -- kv
	)
	
	-- add modifier
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_sheepstick_lua_hex", -- modifier name
		{ duration = self.sheep_duration } -- kv
	)
	

	-- effects
	local sound_cast = "Hero_Lion.Voodoo"
	EmitSoundOn( sound_cast, caster )
	else
	return
end
end
function item_sheepstick_lua1_gem5:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end

	-- load data
	self.sheep_duration = self:GetSpecialValueFor("sheep_duration")
	if target:FindModifierByName("modifier_sheepstick_lua_ignore") ==  nil 
	then
		target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_sheepstick_lua_ignore", -- modifier name
		{ duration = 10 } -- kv
	)
	
	-- add modifier
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_sheepstick_lua_hex", -- modifier name
		{ duration = self.sheep_duration } -- kv
	)
	

	-- effects
	local sound_cast = "Hero_Lion.Voodoo"
	EmitSoundOn( sound_cast, caster )
	else
	return
end
end
modifier_sheepstick_lua_ignore = class ({})

function modifier_sheepstick_lua_ignore:IsHidden()
	return false
end

function modifier_sheepstick_lua_ignore:IsDebuff()
	return true
end

function modifier_sheepstick_lua_ignore:IsPurgable()
	return false
end

modifier_sheepstick_lua_hex = class({})


--------------------------------------------------------------------------------
-- Classifications
function modifier_sheepstick_lua_hex:IsHidden()
	return false
end

function modifier_sheepstick_lua_hex:IsDebuff()
	return true
end

function modifier_sheepstick_lua_hex:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_sheepstick_lua_hex:OnCreated( kv )
	-- references
	self.sheep_movement_speed = self:GetAbility():GetSpecialValueFor( "sheep_movement_speed" )
	self.model = "models/props_gameplay/frog.vmdl"

	if IsServer() then
		-- play effects
		self:PlayEffects( true )

	end
end

function modifier_sheepstick_lua_hex:OnRefresh( kv )
	-- references
	self.sheep_movement_speed = self:GetAbility():GetSpecialValueFor( "sheep_movement_speed" )
	if IsServer() then
		-- play effects
		self:PlayEffects( true )
	end
end

function modifier_sheepstick_lua_hex:OnDestroy( kv )
	if IsServer() then
		-- play effects
		self:PlayEffects( false )
	end
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_sheepstick_lua_hex:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
		MODIFIER_PROPERTY_MODEL_CHANGE,
	}

	
end

function modifier_sheepstick_lua_hex:GetModifierMoveSpeedOverride()
	return self.sheep_movement_speed
end
function modifier_sheepstick_lua_hex:GetModifierModelChange()
	return self.model
end

--------------------------------------------------------------------------------
-- Status Effects

function modifier_sheepstick_lua_hex:CheckState()
	return 
	{
	[MODIFIER_STATE_HEXED] = true,
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_SILENCED] = true,
	[MODIFIER_STATE_MUTED] = true,
	}

end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_sheepstick_lua_hex:PlayEffects( bStart )
	local sound_cast = "Hero_Lion.Hex.Target"
	local particle_cast = "particles/units/heroes/hero_lion/lion_spell_voodoo.vpcf"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	if bStart then
		EmitSoundOn( sound_cast, self:GetParent() )
	end
end

-----------------------------------------------------------------------------------------
--Stats

modifier_sheepstick_lua1 = class({})


function modifier_sheepstick_lua1:IsHidden()
    return true
end

function modifier_sheepstick_lua1:IsPurgable()
    return false
end

function modifier_sheepstick_lua1:RemoveOnDeath()
    return false 
end

function modifier_sheepstick_lua1:OnCreated()
	
	
    self.bonus_strength = self:GetAbility():GetSpecialValueFor("bonus_strength")
    self.bonus_agility = self:GetAbility():GetSpecialValueFor("bonus_agility")
    self.bonus_intellect = self:GetAbility():GetSpecialValueFor("bonus_intellect")
	self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
	self.projectile_speed = self:GetAbility():GetSpecialValueFor("projectile_speed")
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_sheepstick_lua1:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_sheepstick_lua1:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,

    }
end

function modifier_sheepstick_lua1:GetModifierBonusStats_Strength()
    return self.bonus_strength
end

function modifier_sheepstick_lua1:GetModifierBonusStats_Agility()
    return self.bonus_agility
end

function modifier_sheepstick_lua1:GetModifierBonusStats_Intellect()
    return self.bonus_intellect
end

function modifier_sheepstick_lua1:GetModifierConstantManaRegen()
    return self.bonus_mana_regen
end

function modifier_sheepstick_lua1:GetModifierProjectileSpeedBonus()
    return self.projectile_speed
end


function modifier_sheepstick_lua1:OnAttackLanded(params)
		local target = params.target 
		local attacker = self:GetParent()
        if attacker ~= params.attacker then
            return
        end
        if attacker:IsIllusion() then
            return
        end
			if target:FindModifierByName("modifier_sheepstick_lua_flame") ==  nil 
				then
			if not self:GetParent():PassivesDisabled() then
				target:AddNewModifier(
				self:GetAbility():GetCaster(),
				self:GetAbility(),
				"modifier_sheepstick_lua_flame",
					{ duration = 3.1 }
				)
		end
	end
end
-----------------------------------------------------------------------------------------
--Stats

modifier_sheepstick_lua2 = class({})


function modifier_sheepstick_lua2:IsHidden()
    return true
end

function modifier_sheepstick_lua2:IsPurgable()
    return false
end

function modifier_sheepstick_lua2:RemoveOnDeath()
    return false 
end

function modifier_sheepstick_lua2:OnCreated()
	
	
    self.bonus_strength = self:GetAbility():GetSpecialValueFor("bonus_strength")
    self.bonus_agility = self:GetAbility():GetSpecialValueFor("bonus_agility")
    self.bonus_intellect = self:GetAbility():GetSpecialValueFor("bonus_intellect")
	self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
	self.projectile_speed = self:GetAbility():GetSpecialValueFor("projectile_speed")

if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_sheepstick_lua2:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_sheepstick_lua2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,

    }
end

function modifier_sheepstick_lua2:GetModifierBonusStats_Strength()
    return self.bonus_strength
end

function modifier_sheepstick_lua2:GetModifierBonusStats_Agility()
    return self.bonus_agility
end

function modifier_sheepstick_lua2:GetModifierBonusStats_Intellect()
    return self.bonus_intellect
end

function modifier_sheepstick_lua2:GetModifierConstantManaRegen()
    return self.bonus_mana_regen
end

function modifier_sheepstick_lua2:GetModifierProjectileSpeedBonus()
    return self.projectile_speed
end


function modifier_sheepstick_lua2:OnAttackLanded(params)
		local target = params.target 
		local attacker = self:GetParent()
        if attacker ~= params.attacker then
            return
        end
        if attacker:IsIllusion() then
            return
        end
			if target:FindModifierByName("modifier_sheepstick_lua_flame") ==  nil 
				then
			if not self:GetParent():PassivesDisabled() then
				target:AddNewModifier(
				self:GetAbility():GetCaster(),
				self:GetAbility(),
				"modifier_sheepstick_lua_flame",
					{ duration = 3.1 }
				)
		end
	end
end
-----------------------------------------------------------------------------------------
--Stats

modifier_sheepstick_lua3 = class({})


function modifier_sheepstick_lua3:IsHidden()
    return true
end

function modifier_sheepstick_lua3:IsPurgable()
    return false
end

function modifier_sheepstick_lua3:RemoveOnDeath()
    return false 
end

function modifier_sheepstick_lua3:OnCreated()
	
	
    self.bonus_strength = self:GetAbility():GetSpecialValueFor("bonus_strength")
    self.bonus_agility = self:GetAbility():GetSpecialValueFor("bonus_agility")
    self.bonus_intellect = self:GetAbility():GetSpecialValueFor("bonus_intellect")
	self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
	self.projectile_speed = self:GetAbility():GetSpecialValueFor("projectile_speed")

if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_sheepstick_lua3:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_sheepstick_lua3:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,

    }
end

function modifier_sheepstick_lua3:GetModifierBonusStats_Strength()
    return self.bonus_strength
end

function modifier_sheepstick_lua3:GetModifierBonusStats_Agility()
    return self.bonus_agility
end

function modifier_sheepstick_lua3:GetModifierBonusStats_Intellect()
    return self.bonus_intellect
end

function modifier_sheepstick_lua3:GetModifierConstantManaRegen()
    return self.bonus_mana_regen
end

function modifier_sheepstick_lua3:GetModifierProjectileSpeedBonus()
    return self.projectile_speed
end


function modifier_sheepstick_lua3:OnAttackLanded(params)
		local target = params.target 
		local attacker = self:GetParent()
        if attacker ~= params.attacker then
            return
        end
        if attacker:IsIllusion() then
            return
        end
			if target:FindModifierByName("modifier_sheepstick_lua_flame") ==  nil 
				then
			if not self:GetParent():PassivesDisabled() then
				target:AddNewModifier(
				self:GetAbility():GetCaster(),
				self:GetAbility(),
				"modifier_sheepstick_lua_flame",
					{ duration = 3.1 }
				)
		end
	end
end
-----------------------------------------------------------------------------------------
--Stats

modifier_sheepstick_lua4 = class({})


function modifier_sheepstick_lua4:IsHidden()
    return true
end

function modifier_sheepstick_lua4:IsPurgable()
    return false
end

function modifier_sheepstick_lua4:RemoveOnDeath()
    return false 
end

function modifier_sheepstick_lua4:OnCreated()
	
	
    self.bonus_strength = self:GetAbility():GetSpecialValueFor("bonus_strength")
    self.bonus_agility = self:GetAbility():GetSpecialValueFor("bonus_agility")
    self.bonus_intellect = self:GetAbility():GetSpecialValueFor("bonus_intellect")
	self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
	self.projectile_speed = self:GetAbility():GetSpecialValueFor("projectile_speed")

if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_sheepstick_lua4:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_sheepstick_lua4:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,

    }
end

function modifier_sheepstick_lua4:GetModifierBonusStats_Strength()
    return self.bonus_strength
end

function modifier_sheepstick_lua4:GetModifierBonusStats_Agility()
    return self.bonus_agility
end

function modifier_sheepstick_lua4:GetModifierBonusStats_Intellect()
    return self.bonus_intellect
end

function modifier_sheepstick_lua4:GetModifierConstantManaRegen()
    return self.bonus_mana_regen
end

function modifier_sheepstick_lua4:GetModifierProjectileSpeedBonus()
    return self.projectile_speed
end

function modifier_sheepstick_lua4:OnAttackLanded(params)
		local target = params.target 
		local attacker = self:GetParent()
        if attacker ~= params.attacker then
            return
        end
        if attacker:IsIllusion() then
            return
        end
			if target:FindModifierByName("modifier_sheepstick_lua_flame") ==  nil 
				then
			if not self:GetParent():PassivesDisabled() then
				target:AddNewModifier(
				self:GetAbility():GetCaster(),
				self:GetAbility(),
				"modifier_sheepstick_lua_flame",
					{ duration = 3.1 }
				)
		end
	end
end
-----------------------------------------------------------------------------------------
--Stats

modifier_sheepstick_lua5 = class({})


function modifier_sheepstick_lua5:IsHidden()
    return true
end

function modifier_sheepstick_lua5:IsPurgable()
    return false
end

function modifier_sheepstick_lua5:RemoveOnDeath()
    return false 
end

function modifier_sheepstick_lua5:OnCreated()
	
	
    self.bonus_strength = self:GetAbility():GetSpecialValueFor("bonus_strength")
    self.bonus_agility = self:GetAbility():GetSpecialValueFor("bonus_agility")
    self.bonus_intellect = self:GetAbility():GetSpecialValueFor("bonus_intellect")
	self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
	self.projectile_speed = self:GetAbility():GetSpecialValueFor("projectile_speed")

if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_sheepstick_lua5:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_sheepstick_lua5:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,

    }
end

function modifier_sheepstick_lua5:GetModifierBonusStats_Strength()
    return self.bonus_strength
end

function modifier_sheepstick_lua5:GetModifierBonusStats_Agility()
    return self.bonus_agility
end

function modifier_sheepstick_lua5:GetModifierBonusStats_Intellect()
    return self.bonus_intellect
end

function modifier_sheepstick_lua5:GetModifierConstantManaRegen()
    return self.bonus_mana_regen
end

function modifier_sheepstick_lua5:GetModifierProjectileSpeedBonus()
    return self.projectile_speed
end

function modifier_sheepstick_lua5:OnAttackLanded(params)
		local target = params.target 
		local attacker = self:GetParent()
        if attacker ~= params.attacker then
            return
        end
        if attacker:IsIllusion() then
            return
        end
			if target:FindModifierByName("modifier_sheepstick_lua_flame") ==  nil 
				then
			if not self:GetParent():PassivesDisabled() then
				target:AddNewModifier(
				self:GetAbility():GetCaster(),
				self:GetAbility(),
				"modifier_sheepstick_lua_flame",
					{ duration = 3.1 }
				)
		end
	end
end

modifier_sheepstick_lua_flame = class({})

function modifier_sheepstick_lua_flame:IsHidden()
	return false
end

function modifier_sheepstick_lua_flame:IsDebuff()
	return true
end

function modifier_sheepstick_lua_flame:IsPurgable()
	return true
end

function modifier_sheepstick_lua_flame:OnCreated()
	self:StartIntervalThink(1)
end

function modifier_sheepstick_lua_flame:OnIntervalThink()
	self.intellect_dmg = self:GetAbility():GetSpecialValueFor("intellect_dmg")
	local damage = (self.intellect_dmg * self:GetCaster():GetIntellect())
	ApplyDamage({attacker = self:GetCaster(), victim = self:GetParent(), damage = damage, ability = self:GetAbility(), damage_type = DAMAGE_TYPE_MAGICAL, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
end