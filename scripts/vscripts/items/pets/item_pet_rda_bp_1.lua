LinkLuaModifier( "modifier_pet_rda_bp_1", "items/pets/item_pet_rda_bp_1", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_pet_rda_bp_1", "items/pets/item_pet_rda_bp_1", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_take_drop_gem", "modifiers/modifier_take_drop_gem", LUA_MODIFIER_MOTION_NONE )

spell_item_pet_rda_bp_1 = class({})

function spell_item_pet_rda_bp_1:OnSpellStart()
	if IsServer() then
		self.caster = self:GetCaster()
		
		self.caster:AddNewModifier(
		self.caster,
		self,
		"modifier_pet_rda_bp_1", 
		{})
		EmitSoundOn( "Hero_Lion.Voodoo", self:GetCaster() )
	end
end

function spell_item_pet_rda_bp_1:GetIntrinsicModifierName()
	return "modifier_item_pet_rda_bp_1"
end

modifier_item_pet_rda_bp_1 = class({})

function modifier_item_pet_rda_bp_1:IsHidden()
	return true
end

function modifier_item_pet_rda_bp_1:IsPurgable()
	return false
end

function modifier_item_pet_rda_bp_1:OnCreated( kv )
		if IsServer() then
		local point = self:GetCaster():GetAbsOrigin()
		if not self:GetCaster():IsIllusion() then
			self.pet = CreateUnitByName("pet_rda_bp_1", point + Vector(500,500,500), true, nil, nil, DOTA_TEAM_GOODGUYS)
			self.pet:AddNewModifier(self:GetParent(),nil,"modifier_take_drop_gem",{})
			self.pet:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
			self.pet:SetOwner(self:GetCaster())
		end
end
end
function modifier_item_pet_rda_bp_1:OnDestroy()
	UTIL_Remove(self.pet)
end

function modifier_item_pet_rda_bp_1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
end

function modifier_item_pet_rda_bp_1:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("stats_bonus") * self:GetParent():GetLevel()
end

function modifier_item_pet_rda_bp_1:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("stats_bonus") * self:GetParent():GetLevel()
end

function modifier_item_pet_rda_bp_1:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("stats_bonus") * self:GetParent():GetLevel()
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
modifier_pet_rda_bp_1 = class({})

function modifier_pet_rda_bp_1:IsHidden()
	return true
end

function modifier_pet_rda_bp_1:IsDebuff()
	return false
end

function modifier_pet_rda_bp_1:IsPurgable()
	return false
end

function modifier_pet_rda_bp_1:OnCreated( kv ) 
	self.caster = self:GetCaster()
	
	self.speed = self:GetAbility():GetSpecialValueFor( "speed" )

end

function modifier_pet_rda_bp_1:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end

function modifier_pet_rda_bp_1:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_SPENT_MANA,
	}
	return funcs
end



function modifier_pet_rda_bp_1:GetModifierModelChange(params)
--  return "models/courier/baby_rosh/babyroshan_ti10_flying.vmdl"
 return "models/courier/baby_winter_wyvern/baby_winter_wyvern.vmdl"
end

function modifier_pet_rda_bp_1:GetModifierMoveSpeed_Absolute()
	return self.speed
end

function modifier_pet_rda_bp_1:GetModifierIncomingDamage_Percentage()
	return 300
end

function modifier_pet_rda_bp_1:OnAttack( params )
	if IsServer() then
	if params.attacker~=self:GetParent() then return end
	--if params.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then return end

	local modifier = self:GetParent():FindModifierByNameAndCaster( "modifier_pet_rda_bp_1", self:GetParent() )
	if not modifier then return end
	
	modifier:Destroy()
end
end

function modifier_pet_rda_bp_1:OnSpentMana( params )
	if IsServer() then
	local ability = self:GetAbility()
	local parent = self:GetParent()

	local cost = params.cost
	local unit = params.unit
			
	if unit == parent then
	
	self.mana_loss = 0
	
    self.mana_loss = self.mana_loss + params.cost
	if self.mana_loss >= 10 then

	local modifier = self:GetParent():FindModifierByNameAndCaster( "modifier_pet_rda_bp_1", self:GetParent() )
	if not modifier then return end
	
	modifier:Destroy()
end
end
end
end