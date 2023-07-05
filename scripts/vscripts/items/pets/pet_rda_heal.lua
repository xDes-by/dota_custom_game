LinkLuaModifier( "modifier_rda_pet_heal", "items/pets/pet_rda_heal", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_pet_RDA_heal", "items/pets/pet_rda_heal", LUA_MODIFIER_MOTION_NONE )

spell_item_pet_RDA_heal = class({})

function spell_item_pet_RDA_heal:OnSpellStart()
	if IsServer() then
		self.caster = self:GetCaster()
		
		self.caster:AddNewModifier(
		self.caster,
		self,
		"modifier_rda_pet_heal", 
		{})
		EmitSoundOn( "Hero_Lion.Voodoo", self:GetCaster() )
	end
end

function spell_item_pet_RDA_heal:GetIntrinsicModifierName()
	return "modifier_item_pet_RDA_heal"
end

modifier_item_pet_RDA_heal = class({})

function modifier_item_pet_RDA_heal:IsHidden()
	return true
end

function modifier_item_pet_RDA_heal:IsPurgable()
	return false
end

function modifier_item_pet_RDA_heal:OnCreated( kv )
		if IsServer() then
		local point = self:GetCaster():GetAbsOrigin()
		if not self:GetCaster():IsIllusion() then
	self.pet = CreateUnitByName("pet_rda_heal", point, true, nil, nil, DOTA_TEAM_GOODGUYS)
	self.pet:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
	self.pet:SetOwner(self:GetCaster())
		end
end
end
function modifier_item_pet_RDA_heal:OnDestroy()
	UTIL_Remove(self.pet)
end
function modifier_item_pet_RDA_heal:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE
	}
	return funcs
end

function modifier_item_pet_RDA_heal:GetModifierMPRegenAmplify_Percentage()
	return self:GetAbility():GetSpecialValueFor( "mana" )
end

function modifier_item_pet_RDA_heal:GetModifierHPRegenAmplify_Percentage()
	return self:GetAbility():GetSpecialValueFor( "heal" )
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
modifier_rda_pet_heal = class({})

function modifier_rda_pet_heal:IsHidden()
	return true
end

function modifier_rda_pet_heal:IsDebuff()
	return false
end

function modifier_rda_pet_heal:IsPurgable()
	return false
end

function modifier_rda_pet_heal:OnCreated( kv )
	self.caster = self:GetCaster()
	
	self.speed = self:GetAbility():GetSpecialValueFor( "speed" )

end

function modifier_rda_pet_heal:OnRefresh( kv )
end

function modifier_rda_pet_heal:OnRemoved(kv)
end

function modifier_rda_pet_heal:OnDestroy()
end

function modifier_rda_pet_heal:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end

function modifier_rda_pet_heal:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_SPENT_MANA,
	}
	return funcs
end

function modifier_rda_pet_heal:GetModifierModelChange(params)
 return "models/items/courier/livery_llama_courier/livery_llama_courier.vmdl"
end

function modifier_rda_pet_heal:GetModifierMoveSpeed_Absolute()
	return self.speed
end

function modifier_rda_pet_heal:GetModifierIncomingDamage_Percentage()
	return 300
end

function modifier_rda_pet_heal:OnAttack( params )
	if IsServer() then
	if params.attacker~=self:GetParent() then return end
	--if params.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then return end

	local modifier = self:GetParent():FindModifierByNameAndCaster( "modifier_rda_pet_heal", self:GetParent() )
	if not modifier then return end
	
	modifier:Destroy()
end
end

function modifier_rda_pet_heal:OnSpentMana( params )
	if IsServer() then
	local ability = self:GetAbility()
	local parent = self:GetParent()

	local cost = params.cost
	local unit = params.unit
			
	if unit == parent then
	
	self.mana_loss = 0
	
    self.mana_loss = self.mana_loss + params.cost
	if self.mana_loss >= 10 then

	local modifier = self:GetParent():FindModifierByNameAndCaster( "modifier_rda_pet_heal", self:GetParent() )
	if not modifier then return end
	
	modifier:Destroy()
end
end
end
end