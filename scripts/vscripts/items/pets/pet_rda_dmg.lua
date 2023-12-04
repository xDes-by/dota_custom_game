LinkLuaModifier( "modifier_rda_pet_dmg", "items/pets/pet_rda_dmg", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_pet_RDA_dmg", "items/pets/pet_rda_dmg", LUA_MODIFIER_MOTION_NONE )

spell_item_pet_RDA_dmg = class({})

function spell_item_pet_RDA_dmg:OnSpellStart()
	if IsServer() then
		self.caster = self:GetCaster()
		
		self.caster:AddNewModifier(
		self.caster,
		self,
		"modifier_rda_pet_dmg", 
		{})
		EmitSoundOn( "Hero_Lion.Voodoo", self:GetCaster() )
	end
end

function spell_item_pet_RDA_dmg:GetIntrinsicModifierName()
	return "modifier_item_pet_RDA_dmg"
end

modifier_item_pet_RDA_dmg = class({})

function modifier_item_pet_RDA_dmg:IsHidden()
	return true
end

function modifier_item_pet_RDA_dmg:IsPurgable()
	return false
end

function modifier_item_pet_RDA_dmg:OnCreated( kv )
	if IsServer() then
		local point = self:GetCaster():GetAbsOrigin()
		if not self:GetCaster():IsIllusion() then
			self.pet = CreateUnitByName("pet_rda_dmg", point, true, nil, nil, DOTA_TEAM_GOODGUYS)
			self.pet:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
			self.pet:SetOwner(self:GetCaster())
		end
	end
end

function modifier_item_pet_RDA_dmg:OnDestroy()
	UTIL_Remove(self.pet)
end
function modifier_item_pet_RDA_dmg:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
	}
	return funcs
end

function modifier_item_pet_RDA_dmg:GetModifierBaseAttack_BonusDamage( params )
	return self:GetAbility():GetSpecialValueFor( "dmg" ) * self:GetCaster():GetLevel()
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
modifier_rda_pet_dmg = class({})

function modifier_rda_pet_dmg:IsHidden()
	return true
end

function modifier_rda_pet_dmg:IsDebuff()
	return false
end

function modifier_rda_pet_dmg:IsPurgable()
	return false
end

function modifier_rda_pet_dmg:OnCreated( kv )
	self.caster = self:GetCaster()
	
	self.speed = self:GetAbility():GetSpecialValueFor( "speed" )

end

function modifier_rda_pet_dmg:OnRefresh( kv )
end

function modifier_rda_pet_dmg:OnRemoved(kv)
end

function modifier_rda_pet_dmg:OnDestroy()
end

function modifier_rda_pet_dmg:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end

function modifier_rda_pet_dmg:DeclareFunctions()
	local funcs = {
	MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_SPENT_MANA,
	}
	return funcs
end

function modifier_rda_pet_dmg:GetModifierModelChange(params)
 return "models/courier/seekling/seekling.vmdl"
end

function modifier_rda_pet_dmg:GetModifierMoveSpeed_Absolute()
	return self.speed
end

function modifier_rda_pet_dmg:GetModifierIncomingDamage_Percentage()
	return 300
end

function modifier_rda_pet_dmg:OnAttack( params )
	if IsServer() then
	if params.attacker~=self:GetParent() then return end
	--if params.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then return end

	local modifier = self:GetParent():FindModifierByNameAndCaster( "modifier_rda_pet_dmg", self:GetParent() )
	if not modifier then return end
	
	modifier:Destroy()
end
end

function modifier_rda_pet_dmg:OnSpentMana( params )
	if IsServer() then
	local ability = self:GetAbility()
	local parent = self:GetParent()

	local cost = params.cost
	local unit = params.unit
			
	if unit == parent then
	
	self.mana_loss = 0
	
    self.mana_loss = self.mana_loss + params.cost
	if self.mana_loss >= 10 then

	local modifier = self:GetParent():FindModifierByNameAndCaster( "modifier_rda_pet_dmg", self:GetParent() )
	if not modifier then return end
	
	modifier:Destroy()
end
end
end
end