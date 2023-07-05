LinkLuaModifier( "modifier_rda_simple_3", "items/pets/pet_rda_simple_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_pet_RDA_simple_3", "items/pets/pet_rda_simple_3", LUA_MODIFIER_MOTION_NONE )

spell_item_pet_RDA_simple_3 = class({})

function spell_item_pet_RDA_simple_3:OnSpellStart()
	if IsServer() then
		self.caster = self:GetCaster()
		
		self.caster:AddNewModifier(
		self.caster,
		self,
		"modifier_rda_simple_3", 
		{})
		EmitSoundOn( "Hero_Lion.Voodoo", self:GetCaster() )
	end
end

function spell_item_pet_RDA_simple_3:GetIntrinsicModifierName()
	return "modifier_item_pet_RDA_simple_3"
end

modifier_item_pet_RDA_simple_3 = class({})

function modifier_item_pet_RDA_simple_3:IsHidden()
	return true
end

function modifier_item_pet_RDA_simple_3:IsPurgable()
	return false
end

function modifier_item_pet_RDA_simple_3:OnCreated( kv )
	if IsServer() then
		local point = self:GetParent():GetAbsOrigin()
		if not self:GetCaster():IsIllusion() then
		self.pet = CreateUnitByName("pet_rda_simple_3", point + RandomVector( RandomFloat( 150, 150 )), true, nil, nil, DOTA_TEAM_GOODGUYS)
		self.pet:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
		self.pet:SetOwner(self:GetCaster())
		end
	end
end
function modifier_item_pet_RDA_simple_3:OnDestroy()
	UTIL_Remove(self.pet)
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
modifier_rda_simple_3 = class({})

function modifier_rda_simple_3:IsHidden()
	return true
end

function modifier_rda_simple_3:IsDebuff()
	return false
end

function modifier_rda_simple_3:IsPurgable()
	return false
end

function modifier_rda_simple_3:OnCreated( kv )
	self.caster = self:GetCaster()
	
	self.speed = self:GetAbility():GetSpecialValueFor( "speed" )

end

function modifier_rda_simple_3:OnRefresh( kv )
end

function modifier_rda_simple_3:OnRemoved(kv)
end

function modifier_rda_simple_3:OnDestroy()
end

function modifier_rda_simple_3:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end

function modifier_rda_simple_3:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end

function modifier_rda_simple_3:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_SPENT_MANA,
	}
	return funcs
end

function modifier_rda_simple_3:GetModifierModelChange(params)
 return "models/items/courier/mok/mok.vmdl"
end

function modifier_rda_simple_3:GetModifierMoveSpeed_Absolute()
	return self.speed
end

function modifier_rda_simple_3:GetModifierIncomingDamage_Percentage()
	return 300
end

function modifier_rda_simple_3:OnAttack( params )
	if IsServer() then
	if params.attacker~=self:GetParent() then return end
	--if params.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then return end

	local modifier = self:GetParent():FindModifierByNameAndCaster( "modifier_rda_simple_3", self:GetParent() )
	if not modifier then return end
	
	modifier:Destroy()
end
end

function modifier_rda_simple_3:OnSpentMana( params )
	if IsServer() then
	local ability = self:GetAbility()
	local parent = self:GetParent()

	local cost = params.cost
	local unit = params.unit
			
	if unit == parent then
	
	self.mana_loss = 0
	
    self.mana_loss = self.mana_loss + params.cost
	if self.mana_loss >= 10 then

	local modifier = self:GetParent():FindModifierByNameAndCaster( "modifier_rda_simple_3", self:GetParent() )
	if not modifier then return end
	
	modifier:Destroy()
end
end
end
end