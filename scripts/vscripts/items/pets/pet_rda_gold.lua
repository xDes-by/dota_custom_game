LinkLuaModifier( "modifier_rda_pet_gold", "items/pets/pet_rda_gold", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_pet_RDA_gold", "items/pets/pet_rda_gold", LUA_MODIFIER_MOTION_NONE )

spell_item_pet_RDA_gold = class({})

function spell_item_pet_RDA_gold:OnSpellStart()
	if IsServer() then
		self.caster = self:GetCaster()
		
		self.caster:AddNewModifier(
		self.caster,
		self,
		"modifier_rda_pet_gold", 
		{})
		EmitSoundOn( "Hero_Lion.Voodoo", self:GetCaster() )
	end
end

function spell_item_pet_RDA_gold:GetIntrinsicModifierName()
	return "modifier_item_pet_RDA_gold"
end

-------------------------------------------------------------

modifier_item_pet_RDA_gold = class({})

function modifier_item_pet_RDA_gold:IsHidden()
	return true
end

function modifier_item_pet_RDA_gold:IsPurgable()
	return false
end

function modifier_item_pet_RDA_gold:OnCreated( kv )
	if IsServer() then
	local point = self:GetCaster():GetAbsOrigin()
	if not self:GetCaster():IsIllusion() then
		self.pet = CreateUnitByName("pet_rda_gold", point, true, nil, nil, DOTA_TEAM_GOODGUYS)
		self.pet:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
		self.pet:SetOwner(self:GetCaster())
		self:StartIntervalThink(1)
		end
	end
end

function modifier_item_pet_RDA_gold:OnDestroy()
	UTIL_Remove(self.pet)
end

function modifier_item_pet_RDA_gold:OnIntervalThink()
	if IsServer() then
		local parent = self:GetParent()
		local ability = self:GetAbility()
		local gold = ability:GetSpecialValueFor("gold")
		parent:ModifyGoldFiltered(gold, true, 0)
	end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
modifier_rda_pet_gold = class({})

function modifier_rda_pet_gold:IsHidden()
	return true
end

function modifier_rda_pet_gold:IsDebuff()
	return false
end

function modifier_rda_pet_gold:IsPurgable()
	return false
end

function modifier_rda_pet_gold:OnCreated( kv )
	self.speed = self:GetAbility():GetSpecialValueFor( "speed" )
end

function modifier_rda_pet_gold:OnRefresh( kv )
end

function modifier_rda_pet_gold:OnRemoved(kv)
end

function modifier_rda_pet_gold:OnDestroy()
end

function modifier_rda_pet_gold:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end

function modifier_rda_pet_gold:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_SPENT_MANA,
	}
	return funcs
end

function modifier_rda_pet_gold:GetModifierModelChange(params)
 return "models/courier/greevil/gold_greevil.vmdl"
end

function modifier_rda_pet_gold:GetModifierMoveSpeed_Absolute()
	return self.speed
end

function modifier_rda_pet_gold:GetModifierIncomingDamage_Percentage()
	return 300
end

function modifier_rda_pet_gold:OnAttack( params )
	if IsServer() then
	if params.attacker~=self:GetParent() then return end
	--if params.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then return end

	local modifier = self:GetParent():FindModifierByNameAndCaster( "modifier_rda_pet_gold", self:GetParent() )
	if not modifier then return end
	
	modifier:Destroy()
end
end

function modifier_rda_pet_gold:OnSpentMana( params )
	if IsServer() then
	local ability = self:GetAbility()
	local parent = self:GetParent()

	local cost = params.cost
	local unit = params.unit
			
	if unit == parent then
	
	self.mana_loss = 0
	
    self.mana_loss = self.mana_loss + params.cost
	if self.mana_loss >= 10 then

	local modifier = self:GetParent():FindModifierByNameAndCaster( "modifier_rda_pet_gold", self:GetParent() )
	if not modifier then return end
	
	modifier:Destroy()
end
end
end
end