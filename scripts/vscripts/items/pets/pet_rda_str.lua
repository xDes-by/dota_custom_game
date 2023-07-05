LinkLuaModifier( "modifier_rda_pet_str", "items/pets/pet_rda_str", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_pet_RDA_str", "items/pets/pet_rda_str", LUA_MODIFIER_MOTION_NONE )

spell_item_pet_RDA_str = class({})

function spell_item_pet_RDA_str:OnSpellStart()
	if IsServer() then
		self.caster = self:GetCaster()
		
		self.caster:AddNewModifier(
		self.caster,
		self,
		"modifier_rda_pet_str", 
		{})
		EmitSoundOn( "Hero_Lion.Voodoo", self:GetCaster() )
	end
end

function spell_item_pet_RDA_str:GetIntrinsicModifierName()
	return "modifier_item_pet_RDA_str"
end

modifier_item_pet_RDA_str = class({})

function modifier_item_pet_RDA_str:IsHidden()
	return true
end

function modifier_item_pet_RDA_str:IsPurgable()
	return false
end

function modifier_item_pet_RDA_str:OnCreated( kv )
		if IsServer() then
		local point = self:GetCaster():GetAbsOrigin()
		if not self:GetCaster():IsIllusion() then
	self.pet = CreateUnitByName("pet_rda_str", point, true, nil, nil, DOTA_TEAM_GOODGUYS)
	self.pet:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
	self.pet:SetOwner(self:GetCaster())
		end
end
end
function modifier_item_pet_RDA_str:OnDestroy()
	UTIL_Remove(self.pet)
end
function modifier_item_pet_RDA_str:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
	return funcs
end

function modifier_item_pet_RDA_str:GetModifierBonusStats_Strength( params )
if IsServer() then 
	return self:GetAbility():GetSpecialValueFor( "str" ) * self:GetCaster():GetLevel()
end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
modifier_rda_pet_str = class({})

function modifier_rda_pet_str:IsHidden()
	return true
end

function modifier_rda_pet_str:IsDebuff()
	return false
end

function modifier_rda_pet_str:IsPurgable()
	return false
end

function modifier_rda_pet_str:OnCreated( kv ) 
	self.caster = self:GetCaster()
	
	self.speed = self:GetAbility():GetSpecialValueFor( "speed" )

end

function modifier_rda_pet_str:OnRefresh( kv )
end

function modifier_rda_pet_str:OnRemoved(kv)
end

function modifier_rda_pet_str:OnDestroy()
end

function modifier_rda_pet_str:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end

function modifier_rda_pet_str:DeclareFunctions()
	local funcs = {
	MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_SPENT_MANA,
	}
	return funcs
end

function modifier_rda_pet_str:GetModifierModelChange(params)
 return "models/items/courier/butch_pudge_dog/butch_pudge_dog.vmdl"
end

function modifier_rda_pet_str:GetModifierMoveSpeed_Absolute()
	return self.speed
end

function modifier_rda_pet_str:GetModifierIncomingDamage_Percentage()
	return 300
end

function modifier_rda_pet_str:OnAttack( params )
	if IsServer() then
	if params.attacker~=self:GetParent() then return end
	--if params.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then return end

	local modifier = self:GetParent():FindModifierByNameAndCaster( "modifier_rda_pet_str", self:GetParent() )
	if not modifier then return end
	
	modifier:Destroy()
end
end

function modifier_rda_pet_str:OnSpentMana( params )
	if IsServer() then
	local ability = self:GetAbility()
	local parent = self:GetParent()

	local cost = params.cost
	local unit = params.unit
			
	if unit == parent then
	
	self.mana_loss = 0
	
    self.mana_loss = self.mana_loss + params.cost
	if self.mana_loss >= 10 then

	local modifier = self:GetParent():FindModifierByNameAndCaster( "modifier_rda_pet_str", self:GetParent() )
	if not modifier then return end
	
	modifier:Destroy()
end
end
end
end