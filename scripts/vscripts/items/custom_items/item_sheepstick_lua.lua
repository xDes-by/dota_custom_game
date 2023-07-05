item_sheepstick_lua1 = item_sheepstick_lua1 or class({})
item_sheepstick_lua2 = item_sheepstick_lua1 or class({})
item_sheepstick_lua3 = item_sheepstick_lua1 or class({})
item_sheepstick_lua4 = item_sheepstick_lua1 or class({})
item_sheepstick_lua5 = item_sheepstick_lua1 or class({})
item_sheepstick_lua6 = item_sheepstick_lua1 or class({})
item_sheepstick_lua7 = item_sheepstick_lua1 or class({})
item_sheepstick_lua8 = item_sheepstick_lua1 or class({})

LinkLuaModifier( "modifier_sheepstick_lua_hex", "items/custom_items/item_sheepstick_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sheepstick_lua", "items/custom_items/item_sheepstick_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sheepstick_lua_ignore", "items/custom_items/item_sheepstick_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_sheepstick_lua_flame","items/custom_items/item_sheepstick_lua", LUA_MODIFIER_MOTION_NONE)

function item_sheepstick_lua1:GetIntrinsicModifierName()
	return "modifier_sheepstick_lua"
end

--------------------------------------------------------------------------------
-- Ability Start
function item_sheepstick_lua1:OnSpellStart()
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

modifier_sheepstick_lua = class({})


function modifier_sheepstick_lua:IsHidden()
    return true
end

function modifier_sheepstick_lua:IsPurgable()
    return false
end

function modifier_sheepstick_lua:RemoveOnDeath()
    return false 
end

function modifier_sheepstick_lua:OnCreated()
	
    self.bonus_strength = self:GetAbility():GetSpecialValueFor("bonus_strength")
    self.bonus_agility = self:GetAbility():GetSpecialValueFor("bonus_agility")
    self.bonus_intellect = self:GetAbility():GetSpecialValueFor("bonus_intellect")
	self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
	self.projectile_speed = self:GetAbility():GetSpecialValueFor("projectile_speed")

	
	
	
	

end

function modifier_sheepstick_lua:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,

    }
end

function modifier_sheepstick_lua:GetModifierBonusStats_Strength()
    return self.bonus_strength
end

function modifier_sheepstick_lua:GetModifierBonusStats_Agility()
    return self.bonus_agility
end

function modifier_sheepstick_lua:GetModifierBonusStats_Intellect()
    return self.bonus_intellect
end

function modifier_sheepstick_lua:GetModifierConstantManaRegen()
    return self.bonus_mana_regen
end

function modifier_sheepstick_lua:GetModifierProjectileSpeedBonus()
    return self.projectile_speed
end


function modifier_sheepstick_lua:OnAttackLanded(params)
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