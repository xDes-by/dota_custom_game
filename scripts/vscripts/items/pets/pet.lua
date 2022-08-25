LinkLuaModifier( "modifier_pet_simp", "items/pets/pet", LUA_MODIFIER_MOTION_NONE )

spell_item_pet = class({})

function spell_item_pet:OnSpellStart()
	if IsServer() then
		self.caster = self:GetCaster()
		
		self.caster:AddNewModifier(
		self.caster,
		self,
		"modifier_pet_simp", 
		{})
			EmitSoundOn( "Hero_Lion.Voodoo", self:GetCaster() )
	end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
modifier_pet_simp = class({})

function modifier_pet_simp:IsHidden()
	return true
end

function modifier_pet_simp:IsDebuff()
	return false
end

function modifier_pet_simp:IsPurgable()
	return false
end

function modifier_pet_simp:OnCreated( kv )
	self.caster = self:GetCaster()
	
	self.speed = self:GetAbility():GetSpecialValueFor( "speed" )
end

function modifier_pet_simp:OnRefresh( kv )
end

function modifier_pet_simp:OnRemoved(kv)
end

function modifier_pet_simp:OnDestroy()
end

function modifier_pet_simp:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end

function modifier_pet_simp:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_SPENT_MANA,
	}
	return funcs
end

function modifier_pet_simp:GetModifierModelChange(params)
 return "models/courier/mech_donkey/mech_donkey.vmdl"
end

function modifier_pet_simp:GetModifierMoveSpeed_Absolute()
	return self.speed
end

function modifier_pet_simp:GetModifierIncomingDamage_Percentage()
	return 300
end

function modifier_pet_simp:OnAttack( params )
	if IsServer() then
	if params.attacker~=self:GetParent() then return end
	--if params.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then return end

	local modifier = self:GetParent():FindModifierByNameAndCaster( "modifier_pet_simp", self:GetParent() )
	if not modifier then return end
	
	modifier:Destroy()
end
end

function modifier_pet_simp:OnSpentMana( params )
	if IsServer() then
	local ability = self:GetAbility()
	local parent = self:GetParent()

	local cost = params.cost
	local unit = params.unit
			
	if unit == parent then
	
	self.mana_loss = 0
	
    self.mana_loss = self.mana_loss + params.cost
	if self.mana_loss >= 10 then

	local modifier = self:GetParent():FindModifierByNameAndCaster( "modifier_pet_simp", self:GetParent() )
	if not modifier then return end
	
	modifier:Destroy()
end
end
end
end