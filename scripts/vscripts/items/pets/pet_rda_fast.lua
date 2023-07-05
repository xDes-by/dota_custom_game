LinkLuaModifier( "modifier_rda_pet_fast", "items/pets/pet_rda_fast", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_pet_RDA_fast", "items/pets/pet_rda_fast", LUA_MODIFIER_MOTION_NONE )

spell_item_pet_RDA_fast = class({})

function spell_item_pet_RDA_fast:OnSpellStart()
	if IsServer() then
		self.caster = self:GetCaster()
		
		self.caster:AddNewModifier(
		self.caster,
		self,
		"modifier_rda_pet_fast", 
		{})
		EmitSoundOn( "Hero_Lion.Voodoo", self:GetCaster() )
	end
end

function spell_item_pet_RDA_fast:GetIntrinsicModifierName()
	return "modifier_item_pet_RDA_fast"
end

modifier_item_pet_RDA_fast = class({})

function modifier_item_pet_RDA_fast:IsHidden()
	return true
end

function modifier_item_pet_RDA_fast:IsPurgable()
	return false
end

function modifier_item_pet_RDA_fast:OnCreated( kv )
		if IsServer() then
	local point = self:GetCaster():GetAbsOrigin()
	if not self:GetCaster():IsIllusion() then
	self.pet = CreateUnitByName("pet_rda_fast", point, true, nil, nil, DOTA_TEAM_GOODGUYS)
	self.pet:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
	self.pet:SetOwner(self:GetCaster())
	end
	end
end
function modifier_item_pet_RDA_fast:OnDestroy()
	UTIL_Remove(self.pet)
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
modifier_rda_pet_fast = class({})

function modifier_rda_pet_fast:IsHidden()
	return true
end

function modifier_rda_pet_fast:IsDebuff()
	return false
end

function modifier_rda_pet_fast:IsPurgable()
	return false
end

function modifier_rda_pet_fast:OnRefresh( kv )
end

function modifier_rda_pet_fast:OnRemoved(kv)
end

function modifier_rda_pet_fast:OnDestroy()
end

function modifier_rda_pet_fast:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end

function modifier_rda_pet_fast:DeclareFunctions()
	local funcs = {
	MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_SPENT_MANA,
	}
	return funcs
end

function modifier_rda_pet_fast:GetModifierModelChange(params)
 return "models/items/courier/arneyb_rabbit/arneyb_rabbit.vmdl"
end

function modifier_rda_pet_fast:GetModifierMoveSpeed_Absolute()
	return self:GetAbility():GetSpecialValueFor( "speed" )
end

function modifier_rda_pet_fast:GetModifierIncomingDamage_Percentage()
	return 300
end

function modifier_rda_pet_fast:OnAttack( params )
	if IsServer() then
	if params.attacker~=self:GetParent() then return end
	--if params.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then return end

	local modifier = self:GetParent():FindModifierByNameAndCaster( "modifier_rda_pet_fast", self:GetParent() )
	if not modifier then return end
	
	modifier:Destroy()
end
end

function modifier_rda_pet_fast:OnSpentMana( params )
	if IsServer() then
	local ability = self:GetAbility()
	local parent = self:GetParent()

	local cost = params.cost
	local unit = params.unit
			
	if unit == parent then
	
	self.mana_loss = 0
	
    self.mana_loss = self.mana_loss + params.cost
	if self.mana_loss >= 10 then

	local modifier = self:GetParent():FindModifierByNameAndCaster( "modifier_rda_pet_fast", self:GetParent() )
	if not modifier then return end
	
	modifier:Destroy()
end
end
end
end