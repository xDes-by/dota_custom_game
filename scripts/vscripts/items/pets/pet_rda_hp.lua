LinkLuaModifier( "modifier_rda_pet_hp", "items/pets/pet_rda_hp", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_pet_RDA_hp", "items/pets/pet_rda_hp", LUA_MODIFIER_MOTION_NONE )

spell_item_pet_RDA_hp = class({})

function spell_item_pet_RDA_hp:OnSpellStart()
	if IsServer() then
		self.caster = self:GetCaster()
		
		self.caster:AddNewModifier(
		self.caster,
		self,
		"modifier_rda_pet_hp", 
		{})
		EmitSoundOn( "Hero_Lion.Voodoo", self:GetCaster() )
	end
end

function spell_item_pet_RDA_hp:GetIntrinsicModifierName()
	return "modifier_item_pet_RDA_hp"
end

modifier_item_pet_RDA_hp = class({})

function modifier_item_pet_RDA_hp:IsHidden()
	return true
end

function modifier_item_pet_RDA_hp:IsPurgable()
	return false
end

function modifier_item_pet_RDA_hp:OnCreated( kv )
		if IsServer() then
		local point = self:GetCaster():GetAbsOrigin()
		if not self:GetCaster():IsIllusion() then
	self.pet = CreateUnitByName("pet_rda_hp", point, true, nil, nil, DOTA_TEAM_GOODGUYS)
	self.pet:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
	self.pet:SetOwner(self:GetCaster())
		end
end
end
function modifier_item_pet_RDA_hp:OnDestroy()
	UTIL_Remove(self.pet)
end
function modifier_item_pet_RDA_hp:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_HEALTH_BONUS,
	}
	return funcs
end

function modifier_item_pet_RDA_hp:GetModifierHealthBonus( params )
if IsServer() then 
	return self:GetAbility():GetSpecialValueFor( "hp" ) * self:GetCaster():GetLevel()
end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
modifier_rda_pet_hp = class({})

function modifier_rda_pet_hp:IsHidden()
	return true
end

function modifier_rda_pet_hp:IsDebuff()
	return false
end

function modifier_rda_pet_hp:IsPurgable()
	return false
end

function modifier_rda_pet_hp:OnCreated( kv )
	self.caster = self:GetCaster()
	
	self.speed = self:GetAbility():GetSpecialValueFor( "speed" )

end

function modifier_rda_pet_hp:OnRefresh( kv )
end

function modifier_rda_pet_hp:OnRemoved(kv)
end

function modifier_rda_pet_hp:OnDestroy()
end

function modifier_rda_pet_hp:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end

function modifier_rda_pet_hp:DeclareFunctions()
	local funcs = {
	MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_SPENT_MANA,
	}
	return funcs
end

function modifier_rda_pet_hp:GetModifierModelChange(params)
 return  "models/courier/minipudge/minipudge.vmdl"
end

function modifier_rda_pet_hp:GetModifierMoveSpeed_Absolute()
	return self.speed
end

function modifier_rda_pet_hp:GetModifierIncomingDamage_Percentage()
	return 300
end

function modifier_rda_pet_hp:OnAttack( params )
	if IsServer() then
	if params.attacker~=self:GetParent() then return end
	--if params.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then return end

	local modifier = self:GetParent():FindModifierByNameAndCaster( "modifier_rda_pet_hp", self:GetParent() )
	if not modifier then return end
	
	modifier:Destroy()
end
end

function modifier_rda_pet_hp:OnSpentMana( params )
	if IsServer() then
	local ability = self:GetAbility()
	local parent = self:GetParent()

	local cost = params.cost
	local unit = params.unit
			
	if unit == parent then
	
	self.mana_loss = 0
	
    self.mana_loss = self.mana_loss + params.cost
	if self.mana_loss >= 10 then

	local modifier = self:GetParent():FindModifierByNameAndCaster( "modifier_rda_pet_hp", self:GetParent() )
	if not modifier then return end
	
	modifier:Destroy()
end
end
end
end