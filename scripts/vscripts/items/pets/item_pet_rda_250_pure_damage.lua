LinkLuaModifier( "modifier_pet_rda_250_pure_damage", "items/pets/item_pet_RDA_250_pure_damage", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_pet_RDA_250_pure_damage", "items/pets/item_pet_RDA_250_pure_damage", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_take_drop_gem", "modifiers/modifier_take_drop_gem", LUA_MODIFIER_MOTION_NONE )

spell_item_pet_RDA_250_pure_damage = class({})

function spell_item_pet_RDA_250_pure_damage:OnSpellStart()
	if IsServer() then
		self.caster = self:GetCaster()
		
		self.caster:AddNewModifier(
		self.caster,
		self,
		"modifier_item_pet_RDA_250_pure_damage", 
		{})
		EmitSoundOn( "Hero_Lion.Voodoo", self:GetCaster() )
	end
end

function spell_item_pet_RDA_250_pure_damage:GetIntrinsicModifierName()
	return "modifier_pet_rda_250_pure_damage"
end

modifier_pet_rda_250_pure_damage = class({})

function modifier_pet_rda_250_pure_damage:IsHidden()
	return true
end

function modifier_pet_rda_250_pure_damage:IsPurgable()
	return false
end

function modifier_pet_rda_250_pure_damage:OnCreated( kv )
		if IsServer() then
		local point = self:GetCaster():GetAbsOrigin()
		if not self:GetCaster():IsIllusion() then
	self.pet = CreateUnitByName("pet_rda_250_pure_damage", point + Vector(500,500,500), true, nil, nil, DOTA_TEAM_GOODGUYS)
		self.pet:AddNewModifier(self:GetParent(),nil,"modifier_take_drop_gem",{})
self.pet:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
	self.pet:SetOwner(self:GetCaster())
		end
end
end
function modifier_pet_rda_250_pure_damage:OnDestroy()
	UTIL_Remove(self.pet)
end
function modifier_pet_rda_250_pure_damage:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE 
	}
	return funcs
end

function modifier_pet_rda_250_pure_damage:GetModifierProcAttack_BonusDamage_Pure()
	return self:GetParent():GetAttackDamage() * self:GetAbility():GetSpecialValueFor("pure_percent") * 0.01
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
modifier_item_pet_RDA_250_pure_damage = class({})

function modifier_item_pet_RDA_250_pure_damage:IsHidden()
	return true
end

function modifier_item_pet_RDA_250_pure_damage:IsDebuff()
	return false
end

function modifier_item_pet_RDA_250_pure_damage:IsPurgable()
	return false
end

function modifier_item_pet_RDA_250_pure_damage:OnCreated( kv ) 
	self.caster = self:GetCaster()
	
	self.speed = self:GetAbility():GetSpecialValueFor( "speed" )

end

function modifier_item_pet_RDA_250_pure_damage:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end

function modifier_item_pet_RDA_250_pure_damage:DeclareFunctions()
	local funcs = {
	MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_SPENT_MANA,
	}
	return funcs
end

function modifier_item_pet_RDA_250_pure_damage:GetModifierModelChange(params)
 return "models/items/courier/nilbog/nilbog.vmdl"
end

function modifier_item_pet_RDA_250_pure_damage:GetModifierMoveSpeed_Absolute()
	return self.speed
end

function modifier_item_pet_RDA_250_pure_damage:GetModifierIncomingDamage_Percentage()
	return 300
end

function modifier_item_pet_RDA_250_pure_damage:OnAttack( params )
	if IsServer() then
	if params.attacker~=self:GetParent() then return end
	--if params.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then return end

	local modifier = self:GetParent():FindModifierByNameAndCaster( "modifier_item_pet_RDA_250_pure_damage", self:GetParent() )
	if not modifier then return end
	
	modifier:Destroy()
end
end

function modifier_item_pet_RDA_250_pure_damage:OnSpentMana( params )
	if IsServer() then
	local ability = self:GetAbility()
	local parent = self:GetParent()

	local cost = params.cost
	local unit = params.unit
			
	if unit == parent then
	
	self.mana_loss = 0
	
    self.mana_loss = self.mana_loss + params.cost
	if self.mana_loss >= 10 then

	local modifier = self:GetParent():FindModifierByNameAndCaster( "modifier_item_pet_RDA_250_pure_damage", self:GetParent() )
	if not modifier then return end
	
	modifier:Destroy()
end
end
end
end