LinkLuaModifier( "modifier_pet_rda_250_minus_armor_debuff", "items/pets/item_pet_RDA_250_minus_armor", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_pet_rda_250_minus_armor", "items/pets/item_pet_RDA_250_minus_armor", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_pet_RDA_250_minus_armor", "items/pets/item_pet_RDA_250_minus_armor", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_take_drop_gem", "modifiers/modifier_take_drop_gem", LUA_MODIFIER_MOTION_NONE )

spell_item_pet_RDA_250_minus_armor = class({})

function spell_item_pet_RDA_250_minus_armor:OnSpellStart()
	if IsServer() then
		self.caster = self:GetCaster()
		
		self.caster:AddNewModifier(
		self.caster,
		self,
		"modifier_item_pet_RDA_250_minus_armor", 
		{})
		EmitSoundOn( "Hero_Lion.Voodoo", self:GetCaster() )
	end
end

function spell_item_pet_RDA_250_minus_armor:GetIntrinsicModifierName()
	return "modifier_pet_rda_250_minus_armor"
end

modifier_pet_rda_250_minus_armor = class({})

function modifier_pet_rda_250_minus_armor:IsHidden()
	return true
end

function modifier_pet_rda_250_minus_armor:IsPurgable()
	return false
end

function modifier_pet_rda_250_minus_armor:OnCreated( kv )
	if IsServer() then
		local point = self:GetCaster():GetAbsOrigin()
		if not self:GetCaster():IsIllusion() then
			self.pet = CreateUnitByName("pet_rda_250_minus_armor", point + Vector(500,500,500), true, nil, nil, DOTA_TEAM_GOODGUYS)
			self.pet:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
			self.pet:AddNewModifier(self:GetParent(),nil,"modifier_take_drop_gem",{})
			self.pet:SetOwner(self:GetCaster())
		end
	end
end
function modifier_pet_rda_250_minus_armor:OnDestroy()
	UTIL_Remove(self.pet)
end
function modifier_pet_rda_250_minus_armor:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED 
	}
	return funcs
end

function modifier_pet_rda_250_minus_armor:OnAttackLanded(keys)
	if keys.attacker == self:GetParent() and self:GetParent():HasModifier("modifier_pet_rda_250_minus_armor") then
		keys.target:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_pet_rda_250_minus_armor_debuff", {duration = 5})	
	end
end

modifier_pet_rda_250_minus_armor_debuff = class({})

function modifier_pet_rda_250_minus_armor_debuff:IsHidden()
	return false
end

function modifier_pet_rda_250_minus_armor_debuff:IsDebuff()
	return true
end

function modifier_pet_rda_250_minus_armor_debuff:IsPurgable()
	return true
end

function modifier_pet_rda_250_minus_armor_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end

function modifier_pet_rda_250_minus_armor_debuff:GetModifierPhysicalArmorBonus()
	return (-1) * self:GetCaster():GetLevel() * self:GetAbility():GetSpecialValueFor("minus_armor")
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
modifier_item_pet_RDA_250_minus_armor = class({})

function modifier_item_pet_RDA_250_minus_armor:IsHidden()
	return true
end

function modifier_item_pet_RDA_250_minus_armor:IsDebuff()
	return false
end

function modifier_item_pet_RDA_250_minus_armor:IsPurgable()
	return false
end

function modifier_item_pet_RDA_250_minus_armor:OnCreated( kv ) 
	self.caster = self:GetCaster()
	self.speed = self:GetAbility():GetSpecialValueFor( "speed" )
end

function modifier_item_pet_RDA_250_minus_armor:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end

function modifier_item_pet_RDA_250_minus_armor:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_SPENT_MANA,
	}
	return funcs
end

function modifier_item_pet_RDA_250_minus_armor:GetModifierModelChange(params)
 return "models/items/courier/grim_wolf/grim_wolf.vmdl"
end

function modifier_item_pet_RDA_250_minus_armor:GetModifierMoveSpeed_Absolute()
	return self.speed
end

function modifier_item_pet_RDA_250_minus_armor:GetModifierIncomingDamage_Percentage()
	return 300
end

function modifier_item_pet_RDA_250_minus_armor:OnAttack( params )
	if IsServer() then
	if params.attacker~=self:GetParent() then return end
	--if params.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then return end

	local modifier = self:GetParent():FindModifierByNameAndCaster( "modifier_item_pet_RDA_250_minus_armor", self:GetParent() )
	if not modifier then return end
	
	modifier:Destroy()
end
end

function modifier_item_pet_RDA_250_minus_armor:OnSpentMana( params )
	if IsServer() then
	local ability = self:GetAbility()
	local parent = self:GetParent()

	local cost = params.cost
	local unit = params.unit
			
	if unit == parent then
	
	self.mana_loss = 0
	
    self.mana_loss = self.mana_loss + params.cost
	if self.mana_loss >= 10 then

	local modifier = self:GetParent():FindModifierByNameAndCaster( "modifier_item_pet_RDA_250_minus_armor", self:GetParent() )
	if not modifier then return end
	
	modifier:Destroy()
end
end
end
end