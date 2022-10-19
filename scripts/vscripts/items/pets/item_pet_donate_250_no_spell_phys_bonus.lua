LinkLuaModifier( "modifier_pet_donate_250_no_spell_phys_bonus", "items/pets/item_pet_donate_250_no_spell_phys_bonus", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_pet_donate_250_no_spell_phys_bonus", "items/pets/item_pet_donate_250_no_spell_phys_bonus", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_take_drop_gem", "modifiers/modifier_take_drop_gem", LUA_MODIFIER_MOTION_NONE )

spell_item_pet_donate_250_no_spell_phys_bonus = class({})

function spell_item_pet_donate_250_no_spell_phys_bonus:OnSpellStart()
	if IsServer() then
		self.caster = self:GetCaster()
		
		self.caster:AddNewModifier(
		self.caster,
		self,
		"modifier_item_pet_donate_250_no_spell_phys_bonus", 
		{})
		EmitSoundOn( "Hero_Lion.Voodoo", self:GetCaster() )
	end
end

function spell_item_pet_donate_250_no_spell_phys_bonus:GetIntrinsicModifierName()
	return "modifier_pet_donate_250_no_spell_phys_bonus"
end

modifier_pet_donate_250_no_spell_phys_bonus = class({})

function modifier_pet_donate_250_no_spell_phys_bonus:IsHidden()
	return true
end

function modifier_pet_donate_250_no_spell_phys_bonus:IsPurgable()
	return false
end

function modifier_pet_donate_250_no_spell_phys_bonus:OnCreated( kv )
		if IsServer() then
	self.bonus = self:GetAbility():GetSpecialValueFor( "str" )
		local point = self:GetCaster():GetAbsOrigin()
		if not self:GetCaster():IsIllusion() then
	self.pet = CreateUnitByName("pet_donate_250_no_spell_phys_bonus", point + Vector(500,500,500), true, nil, nil, DOTA_TEAM_GOODGUYS)
	self.pet:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
		self.pet:AddNewModifier(self:GetParent(),nil,"modifier_take_drop_gem",{})
self.pet:SetOwner(self:GetCaster())
		end
end
end
function modifier_pet_donate_250_no_spell_phys_bonus:OnDestroy()
	UTIL_Remove(self.pet)
end
function modifier_pet_donate_250_no_spell_phys_bonus:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		MODIFIER_EVENT_ON_ATTACK,
	}
	return funcs
end

function modifier_pet_donate_250_no_spell_phys_bonus:OnAttack(keys)
	self.cast = 0
end

function modifier_pet_donate_250_no_spell_phys_bonus:OnAbilityFullyCast(keys)
	self.cast = 0
	if keys.ability:IsItem() then
		self.cast = 1
	end
end

function modifier_pet_donate_250_no_spell_phys_bonus:GetModifierTotalDamageOutgoing_Percentage(keys)
	if self.cast == 1 then
		return 0
	end
	if keys.damage_type == 4 then
		return 1
	end
	if keys.damage_category == DOTA_DAMAGE_CATEGORY_SPELL and keys.damage_type == 2 then
		return -100 or self.cast
	else
		return self:GetAbility():GetSpecialValueFor("phys_percent")
	end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
modifier_item_pet_donate_250_no_spell_phys_bonus = class({})

function modifier_item_pet_donate_250_no_spell_phys_bonus:IsHidden()
	return true
end

function modifier_item_pet_donate_250_no_spell_phys_bonus:IsDebuff()
	return false
end

function modifier_item_pet_donate_250_no_spell_phys_bonus:IsPurgable()
	return false
end

function modifier_item_pet_donate_250_no_spell_phys_bonus:OnCreated( kv ) 
	self.caster = self:GetCaster()
	
	self.speed = self:GetAbility():GetSpecialValueFor( "speed" )

end

function modifier_item_pet_donate_250_no_spell_phys_bonus:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end

function modifier_item_pet_donate_250_no_spell_phys_bonus:DeclareFunctions()
	local funcs = {
	MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_SPENT_MANA,
	}
	return funcs
end

function modifier_item_pet_donate_250_no_spell_phys_bonus:GetModifierModelChange(params)
 return "models/items/courier/lilnova/lilnova.vmdl"
end

function modifier_item_pet_donate_250_no_spell_phys_bonus:GetModifierMoveSpeed_Absolute()
	return self.speed
end

function modifier_item_pet_donate_250_no_spell_phys_bonus:GetModifierIncomingDamage_Percentage()
	return 300
end

function modifier_item_pet_donate_250_no_spell_phys_bonus:OnAttack( params )
	if IsServer() then
	if params.attacker~=self:GetParent() then return end
	--if params.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then return end

	local modifier = self:GetParent():FindModifierByNameAndCaster( "modifier_item_pet_donate_250_no_spell_phys_bonus", self:GetParent() )
	if not modifier then return end
	
	modifier:Destroy()
end
end

function modifier_item_pet_donate_250_no_spell_phys_bonus:OnSpentMana( params )
	if IsServer() then
	local ability = self:GetAbility()
	local parent = self:GetParent()

	local cost = params.cost
	local unit = params.unit
			
	if unit == parent then
	
	self.mana_loss = 0
	
    self.mana_loss = self.mana_loss + params.cost
	if self.mana_loss >= 10 then

	local modifier = self:GetParent():FindModifierByNameAndCaster( "modifier_item_pet_donate_250_no_spell_phys_bonus", self:GetParent() )
	if not modifier then return end
	
	modifier:Destroy()
end
end
end
end