LinkLuaModifier( "modifier_pet_rda_250_gold_and_exp", "items/pets/item_pet_RDA_250_gold_and_exp", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_pet_RDA_250_gold_and_exp", "items/pets/item_pet_RDA_250_gold_and_exp", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_take_drop_gem", "modifiers/modifier_take_drop_gem", LUA_MODIFIER_MOTION_NONE )

spell_item_pet_RDA_250_gold_and_exp = class({})

function spell_item_pet_RDA_250_gold_and_exp:OnSpellStart()
	if IsServer() then
		self.caster = self:GetCaster()
		
		self.caster:AddNewModifier(
		self.caster,
		self,
		"modifier_pet_rda_250_gold_and_exp", 
		{})
		EmitSoundOn( "Hero_Lion.Voodoo", self:GetCaster() )
	end
end

function spell_item_pet_RDA_250_gold_and_exp:GetIntrinsicModifierName()
	return "modifier_item_pet_RDA_250_gold_and_exp"
end

modifier_item_pet_RDA_250_gold_and_exp = class({})

function modifier_item_pet_RDA_250_gold_and_exp:IsHidden()
	return true
end

function modifier_item_pet_RDA_250_gold_and_exp:IsPurgable()
	return false
end

function modifier_item_pet_RDA_250_gold_and_exp:OnCreated( kv )
		if IsServer() then
		local point = self:GetCaster():GetAbsOrigin()
		if not self:GetCaster():IsIllusion() then
	self.pet = CreateUnitByName("pet_rda_250_gold_and_exp", point + Vector(500,500,500), true, nil, nil, DOTA_TEAM_GOODGUYS)
	self.pet:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
		self.pet:AddNewModifier(self:GetParent(),nil,"modifier_take_drop_gem",{})
self.pet:SetOwner(self:GetCaster())
		end
end
end
function modifier_item_pet_RDA_250_gold_and_exp:OnDestroy()
	UTIL_Remove(self.pet)
end
function modifier_item_pet_RDA_250_gold_and_exp:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_EXP_RATE_BOOST,
		MODIFIER_PROPERTY_GOLD_RATE_BOOST 
	}
	return funcs
end

function modifier_item_pet_RDA_250_gold_and_exp:GetModifierPercentageGoldRateBoost()
	return self:GetAbility():GetSpecialValueFor("goex")
end

function modifier_item_pet_RDA_250_gold_and_exp:GetModifierPercentageExpRateBoost()
	return self:GetAbility():GetSpecialValueFor("goex")
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
modifier_pet_rda_250_gold_and_exp = class({})

function modifier_pet_rda_250_gold_and_exp:IsHidden()
	return true
end

function modifier_pet_rda_250_gold_and_exp:IsDebuff()
	return false
end

function modifier_pet_rda_250_gold_and_exp:IsPurgable()
	return false
end

function modifier_pet_rda_250_gold_and_exp:OnCreated( kv ) 
	self.caster = self:GetCaster()
	
	self.speed = self:GetAbility():GetSpecialValueFor( "speed" )

end

function modifier_pet_rda_250_gold_and_exp:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end

function modifier_pet_rda_250_gold_and_exp:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_SPENT_MANA,
	}
	return funcs
end

function modifier_pet_rda_250_gold_and_exp:GetModifierModelChange(params)
 return "models/items/courier/loco_the_crocodile_courier/loco_the_crocodile_courier.vmdl"
end

function modifier_pet_rda_250_gold_and_exp:GetModifierMoveSpeed_Absolute()
	return self.speed
end

function modifier_pet_rda_250_gold_and_exp:GetModifierIncomingDamage_Percentage()
	return 300
end

function modifier_pet_rda_250_gold_and_exp:OnAttack( params )
	if IsServer() then
	if params.attacker~=self:GetParent() then return end
	--if params.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then return end

	local modifier = self:GetParent():FindModifierByNameAndCaster( "modifier_pet_rda_250_gold_and_exp", self:GetParent() )
	if not modifier then return end
	
	modifier:Destroy()
end
end

function modifier_pet_rda_250_gold_and_exp:OnSpentMana( params )
	if IsServer() then
	local ability = self:GetAbility()
	local parent = self:GetParent()

	local cost = params.cost
	local unit = params.unit
			
	if unit == parent then
	
	self.mana_loss = 0
	
    self.mana_loss = self.mana_loss + params.cost
	if self.mana_loss >= 10 then

	local modifier = self:GetParent():FindModifierByNameAndCaster( "modifier_pet_rda_250_gold_and_exp", self:GetParent() )
	if not modifier then return end
	
	modifier:Destroy()
end
end
end
end