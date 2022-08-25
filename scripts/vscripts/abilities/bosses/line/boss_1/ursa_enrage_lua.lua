ursa_enrage_lua = class({})
LinkLuaModifier( "modifier_ursa_enrage_lua", "abilities/bosses/line/boss_1/ursa_enrage_lua.lua", LUA_MODIFIER_MOTION_NONE )

function ursa_enrage_lua:GetBehavior()
	local behavior = DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
 	if self:GetCaster():HasScepter() then
 		behavior = behavior + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE
 	end
 	return behavior
end

function ursa_enrage_lua:GetCooldown( level )
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor( "cooldown_scepter" )
	end

	return self.BaseClass.GetCooldown( self, level )
end

function ursa_enrage_lua:OnSpellStart()
	local bonus_duration = self:GetSpecialValueFor("duration")

	self:GetCaster():Purge(false, true, false, true, false)

	self:GetCaster():AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_ursa_enrage_lua",
		{ duration = bonus_duration }
	)

	self:PlayEffects()
end

function ursa_enrage_lua:PlayEffects()
	local sound_cast = "Hero_Ursa.Enrage"
	EmitSoundOn( sound_cast, self:GetCaster() )
end

----------------------------------------------------------------------------------------------------------------------------

modifier_ursa_enrage_lua = class({})

function modifier_ursa_enrage_lua:IsHidden()
	return false
end

function modifier_ursa_enrage_lua:IsDebuff()
	return false
end

function modifier_ursa_enrage_lua:IsPurgable()
	return false
end

function modifier_ursa_enrage_lua:OnCreated( kv )
	self.damage_reduction = self:GetAbility():GetSpecialValueFor("damage_reduction")
	self.stack_multiplier = self:GetAbility():GetSpecialValueFor("enrage_multiplier")
	if IsServer() then
		local modifier = self:GetParent():FindModifierByNameAndCaster("modifier_ursa_fury_swipes_lua", self:GetAbility():GetCaster())
		if modifier~=nil then
			modifier.damage_per_stack = modifier:GetAbility():GetSpecialValueFor("damage_per_stack") * self.stack_multiplier
		end
	end
end

function modifier_ursa_enrage_lua:OnRefresh( kv )
	self.damage_reduction = self:GetAbility():GetSpecialValueFor("damage_reduction")
	self.stack_multiplier = self:GetAbility():GetSpecialValueFor("enrage_multiplier")

	if IsServer() then
		local modifier = self:GetParent():FindModifierByNameAndCaster("modifier_ursa_fury_swipes_lua", self:GetAbility():GetCaster())
		if modifier~=nil then
			modifier.damage_per_stack = modifier:GetAbility():GetSpecialValueFor("damage_per_stack") * self.stack_multiplier
		end
	end
end

function modifier_ursa_enrage_lua:OnDestroy( kv )
	self.damage_reduction = self:GetAbility():GetSpecialValueFor("damage_reduction")
	self.stack_multiplier = self:GetAbility():GetSpecialValueFor("enrage_multiplier")
	if IsServer() then
		local modifier = self:GetParent():FindModifierByNameAndCaster("modifier_ursa_fury_swipes_lua", self:GetAbility():GetCaster())
		if modifier~=nil then
			modifier.damage_per_stack = modifier:GetAbility():GetSpecialValueFor("damage_per_stack")
		end
	end
end

function modifier_ursa_enrage_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,

		MODIFIER_PROPERTY_MODEL_SCALE,
	}

	return funcs
end

function modifier_ursa_enrage_lua:GetModifierIncomingDamage_Percentage( params )
	return -self.damage_reduction
end

function modifier_ursa_enrage_lua:GetModifierModelScale( params )
	return 30
end

function modifier_ursa_enrage_lua:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_enrage_buff.vpcf"
end

function modifier_ursa_enrage_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end