modifier_mars_bulwark_lua = class({})
LinkLuaModifier( "modifier_hp_mars", "heroes/hero_mars/mars_bulwark_lua/modifier_mars_bulwark_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hp_mars_last_talent", "heroes/hero_mars/mars_bulwark_lua/modifier_mars_bulwark_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function modifier_mars_bulwark_lua:IsHidden()
	return false
end

function modifier_mars_bulwark_lua:IsDebuff()
	return false
end

function modifier_mars_bulwark_lua:IsStunDebuff()
	return false
end

function modifier_mars_bulwark_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_mars_bulwark_lua:OnCreated( kv )
	self.reduction_front = self:GetAbility():GetSpecialValueFor( "physical_damage_reduction" )
	self.reduction_side = self:GetAbility():GetSpecialValueFor( "physical_damage_reduction_side" )
	self.angle_front = self:GetAbility():GetSpecialValueFor( "forward_angle" )/2
	self.angle_side = self:GetAbility():GetSpecialValueFor( "side_angle" )/2
	if IsServer() then
		
	end
	self:StartIntervalThink(0.1)
end

function modifier_mars_bulwark_lua:OnIntervalThink()
self.caster = self:GetCaster()
	if IsServer() then
	if self:GetCaster():FindAbilityByName("npc_dota_hero_mars_str10") ~= nil then 
		if not self.caster:HasModifier("modifier_hp_mars") then
			self.caster:AddNewModifier( self.caster, nil, "modifier_hp_mars", { } )
			end
		end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_mars_str_last") ~= nil then 
		if not self.caster:HasModifier("modifier_hp_mars_last_talent") then
			self.caster:AddNewModifier( self.caster, nil, "modifier_hp_mars_last_talent", { } )
			end
		end
	self:OnRefresh()
	end
end

function modifier_mars_bulwark_lua:OnRefresh( kv )
	self.reduction_front = self:GetAbility():GetSpecialValueFor( "physical_damage_reduction" )
	self.reduction_side = self:GetAbility():GetSpecialValueFor( "physical_damage_reduction_side" )
	self.angle_front = self:GetAbility():GetSpecialValueFor( "forward_angle" )/2
	self.angle_side = self:GetAbility():GetSpecialValueFor( "side_angle" )/2
	
	local abil =  self:GetCaster():FindAbilityByName("npc_dota_hero_mars_str9")
	if abil ~= nil then 
	self.reduction_side = self.reduction_side + 28
	end
end

function modifier_mars_bulwark_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
end

--------------------------------------------------------------------------------

function modifier_mars_bulwark_lua:GetModifierPhysical_ConstantBlock( params )
	if params.inflictor then return 0 end

	if params.target:PassivesDisabled() then return 0 end

	local parent = params.target
	local attacker = params.attacker
	local reduction = 0

	local facing_direction = parent:GetAnglesAsVector().y
	local attacker_vector = (attacker:GetOrigin() - parent:GetOrigin())
	local attacker_direction = VectorToAngles( attacker_vector ).y
	local angle_diff = math.abs( AngleDiff( facing_direction, attacker_direction ) )

	if angle_diff < self.angle_front then
		reduction = self.reduction_front
		self:PlayEffects( true, attacker_vector )

	elseif angle_diff < self.angle_side then
		reduction = self.reduction_side
		self:PlayEffects( false, attacker_vector )
	end
	return reduction*params.damage/100
end

function modifier_mars_bulwark_lua:GetModifierHealthRegenPercentage()
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_mars_str50") then
		return 10
	end
end

function modifier_mars_bulwark_lua:GetModifierMagicalResistanceBonus()
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_mars_str50") then
		return 50
	end
end
--------------------------------------------------------------------------------

function modifier_mars_bulwark_lua:PlayEffects( front )
	local particle_cast = "particles/units/heroes/hero_mars/mars_shield_of_mars.vpcf"
	local sound_cast = "Hero_Mars.Shield.Block"

	if not front then
		particle_cast = "particles/units/heroes/hero_mars/mars_shield_of_mars_small.vpcf"
		sound_cast = "Hero_Mars.Shield.BlockSmall"
	end

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( sound_cast, self:GetParent() )
end

--------------------------------------------------------------------------------

modifier_hp_mars = class({})

function modifier_hp_mars:IsHidden()
	return true
end

function modifier_hp_mars:IsPurgable()
	return false
end

function modifier_hp_mars:OnCreated( kv )
end

function modifier_hp_mars:OnRefresh( kv )
end

function modifier_hp_mars:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	}
	return funcs
end

function modifier_hp_mars:GetModifierHealthRegenPercentage()
	return 3
end

modifier_hp_mars_last_talent = class({})

function modifier_hp_mars_last_talent:IsHidden()
	return true
end

function modifier_hp_mars_last_talent:IsPurgable()
	return false
end

function modifier_hp_mars_last_talent:OnCreated( kv )
end

function modifier_hp_mars_last_talent:OnRefresh( kv )
end

function modifier_hp_mars_last_talent:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	}
	return funcs
end

function modifier_hp_mars_last_talent:GetModifierHealthRegenPercentage()
	return 5
end