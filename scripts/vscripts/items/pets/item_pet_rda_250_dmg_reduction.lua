LinkLuaModifier( "modifier_pet_rda_250_dmg_reduction", "items/pets/item_pet_RDA_250_dmg_reduction", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_pet_RDA_250_dmg_reduction", "items/pets/item_pet_RDA_250_dmg_reduction", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_take_drop_gem", "modifiers/modifier_take_drop_gem", LUA_MODIFIER_MOTION_NONE )

spell_item_pet_RDA_250_dmg_reduction = class({})

function spell_item_pet_RDA_250_dmg_reduction:OnSpellStart()
	if IsServer() then
		self.caster = self:GetCaster()
		
		self.caster:AddNewModifier(
		self.caster,
		self,
		"modifier_item_pet_RDA_250_dmg_reduction", 
		{})
		EmitSoundOn( "Hero_Lion.Voodoo", self:GetCaster() )
	end
end

function spell_item_pet_RDA_250_dmg_reduction:GetIntrinsicModifierName()
	return "modifier_pet_rda_250_dmg_reduction"
end

modifier_pet_rda_250_dmg_reduction = class({})

function modifier_pet_rda_250_dmg_reduction:IsHidden()
	return true
end

function modifier_pet_rda_250_dmg_reduction:IsPurgable()
	return false
end

function modifier_pet_rda_250_dmg_reduction:OnCreated( kv )
		if IsServer() then
		local point = self:GetCaster():GetAbsOrigin()
		if not self:GetCaster():IsIllusion() then
	self.pet = CreateUnitByName("pet_rda_250_dmg_reduction", point + Vector(500,500,500), true, nil, nil, DOTA_TEAM_GOODGUYS)
	self.pet:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
		self.pet:AddNewModifier(self:GetParent(),nil,"modifier_take_drop_gem",{})
self.pet:SetOwner(self:GetCaster())
		end
end
end
function modifier_pet_rda_250_dmg_reduction:OnDestroy()
	UTIL_Remove(self.pet)
end
function modifier_pet_rda_250_dmg_reduction:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE 
	}
	return funcs
end

function modifier_pet_rda_250_dmg_reduction:GetModifierIncomingDamage_Percentage()
	return self:GetAbility():GetSpecialValueFor("dur")
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
modifier_item_pet_RDA_250_dmg_reduction = class({})

function modifier_item_pet_RDA_250_dmg_reduction:IsHidden()
	return true
end

function modifier_item_pet_RDA_250_dmg_reduction:IsDebuff()
	return false
end

function modifier_item_pet_RDA_250_dmg_reduction:IsPurgable()
	return false
end

function modifier_item_pet_RDA_250_dmg_reduction:OnCreated( kv ) 
	self.caster = self:GetCaster()
	
	self.speed = self:GetAbility():GetSpecialValueFor( "speed" )

end

function modifier_item_pet_RDA_250_dmg_reduction:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end

function modifier_item_pet_RDA_250_dmg_reduction:DeclareFunctions()
	local funcs = {
	MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_SPENT_MANA,
	}
	return funcs
end

function modifier_item_pet_RDA_250_dmg_reduction:GetModifierModelChange(params)
 return "models/items/courier/ol_dirty_boot_courier_courier/ol_dirty_boot_courier_courier.vmdl"
end

function modifier_item_pet_RDA_250_dmg_reduction:GetModifierMoveSpeed_Absolute()
	return self.speed
end

function modifier_item_pet_RDA_250_dmg_reduction:GetModifierIncomingDamage_Percentage()
	return 300
end

function modifier_item_pet_RDA_250_dmg_reduction:OnAttack( params )
	if IsServer() then
	if params.attacker~=self:GetParent() then return end
	--if params.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then return end

	local modifier = self:GetParent():FindModifierByNameAndCaster( "modifier_item_pet_RDA_250_dmg_reduction", self:GetParent() )
	if not modifier then return end
	
	modifier:Destroy()
end
end

function modifier_item_pet_RDA_250_dmg_reduction:OnSpentMana( params )
	if IsServer() then
	local ability = self:GetAbility()
	local parent = self:GetParent()

	local cost = params.cost
	local unit = params.unit
			
	if unit == parent then
	
	self.mana_loss = 0
	
    self.mana_loss = self.mana_loss + params.cost
	if self.mana_loss >= 10 then

	local modifier = self:GetParent():FindModifierByNameAndCaster( "modifier_item_pet_RDA_250_dmg_reduction", self:GetParent() )
	if not modifier then return end
	
	modifier:Destroy()
end
end
end
end