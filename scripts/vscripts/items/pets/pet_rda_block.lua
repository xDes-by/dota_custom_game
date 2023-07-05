LinkLuaModifier( "modifier_rda_all_damage_block", "items/pets/pet_rda_block", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_pet_RDA_block", "items/pets/pet_rda_block", LUA_MODIFIER_MOTION_NONE )

spell_item_pet_RDA_block = class({})

function spell_item_pet_RDA_block:OnSpellStart()
	if IsServer() then
		self.caster = self:GetCaster()
		
		self.caster:AddNewModifier(
		self.caster,
		self,
		"modifier_rda_all_damage_block", 
		{})
		EmitSoundOn( "Hero_Lion.Voodoo", self:GetCaster() )
	end
end

function spell_item_pet_RDA_block:GetIntrinsicModifierName()
	return "modifier_item_pet_RDA_block"
end

modifier_item_pet_RDA_block = class({})

function modifier_item_pet_RDA_block:IsHidden()
	return true
end

function modifier_item_pet_RDA_block:IsPurgable()
	return false
end

function modifier_item_pet_RDA_block:OnCreated( kv )
		if IsServer() then
	local point = self:GetCaster():GetAbsOrigin()
	if not self:GetCaster():IsIllusion() then
	pet = CreateUnitByName("pet_rda_block", point, true, nil, nil, DOTA_TEAM_GOODGUYS)
	self.pet:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
	self.pet:SetOwner(self:GetCaster())
	end
end
end
function modifier_item_pet_RDA_block:OnDestroy()
	UTIL_Remove(self.pet)
end
function modifier_item_pet_RDA_block:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
	return funcs
end

function modifier_item_pet_RDA_block:GetModifierIncomingDamage_Percentage()
	return - self:GetAbility():GetSpecialValueFor( "block" )
end


----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
modifier_rda_all_damage_block = class({})

function modifier_rda_all_damage_block:IsHidden()
	return true
end

function modifier_rda_all_damage_block:IsDebuff()
	return false
end

function modifier_rda_all_damage_block:IsPurgable()
	return false
end

function modifier_rda_all_damage_block:OnCreated( kv )
	self.caster = self:GetCaster()
	
	self.speed = self:GetAbility():GetSpecialValueFor( "speed" )

end

function modifier_rda_all_damage_block:OnRefresh( kv )
end

function modifier_rda_all_damage_block:OnRemoved(kv)
end

function modifier_rda_all_damage_block:OnDestroy()
end

function modifier_rda_all_damage_block:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end

function modifier_rda_all_damage_block:DeclareFunctions()
	local funcs = {
	MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_SPENT_MANA,
	}
	return funcs
end

function modifier_rda_all_damage_block:GetModifierModelChange(params)
 return "models/items/courier/deathripper/deathripper.vmdl"
end

function modifier_rda_all_damage_block:GetModifierMoveSpeed_Absolute()
	return self.speed
end

function modifier_rda_all_damage_block:GetModifierIncomingDamage_Percentage()
	return 300
end

function modifier_rda_all_damage_block:OnAttack( params )
	if IsServer() then
	if params.attacker~=self:GetParent() then return end
	--if params.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then return end

	local modifier = self:GetParent():FindModifierByNameAndCaster( "modifier_rda_all_damage_block", self:GetParent() )
	if not modifier then return end
	
	modifier:Destroy()
end
end

function modifier_rda_all_damage_block:OnSpentMana( params )
	if IsServer() then
	local ability = self:GetAbility()
	local parent = self:GetParent()

	local cost = params.cost
	local unit = params.unit
			
	if unit == parent then
	
	self.mana_loss = 0
	
    self.mana_loss = self.mana_loss + params.cost
	if self.mana_loss >= 10 then

	local modifier = self:GetParent():FindModifierByNameAndCaster( "modifier_rda_all_damage_block", self:GetParent() )
	if not modifier then return end
	
	modifier:Destroy()
end
end
end
end