LinkLuaModifier( "modifier_rda_pet_agi", "items/pets/pet_rda_agi", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_pet_RDA_agi", "items/pets/pet_rda_agi", LUA_MODIFIER_MOTION_NONE )
spell_item_pet_RDA_agi = class({})

function spell_item_pet_RDA_agi:OnSpellStart()
	if IsServer() then
		self.caster = self:GetCaster()
		
		self.caster:AddNewModifier(
		self.caster,
		self,
		"modifier_rda_pet_agi", 
		{})
		EmitSoundOn( "Hero_Lion.Voodoo", self:GetCaster() )
	end
end

function spell_item_pet_RDA_agi:GetIntrinsicModifierName()
	return "modifier_item_pet_RDA_agi"
end

modifier_item_pet_RDA_agi = class({})

function modifier_item_pet_RDA_agi:IsHidden()
	return true
end

function modifier_item_pet_RDA_agi:IsPurgable()
	return false
end

function modifier_item_pet_RDA_agi:OnCreated( kv )
	if IsServer() then
	local point = self:GetCaster():GetAbsOrigin()
		if not self:GetCaster():IsIllusion() then
			self.pet = CreateUnitByName("pet_rda_agi", point, true, nil, nil, DOTA_TEAM_GOODGUYS)
			self.pet:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
			self.pet:SetOwner(self:GetCaster())
		end
	end
end
function modifier_item_pet_RDA_agi:OnDestroy()
	UTIL_Remove(self.pet)
end
function modifier_item_pet_RDA_agi:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
	return funcs
end

function modifier_item_pet_RDA_agi:GetModifierBonusStats_Agility()
if IsServer() then 
	return self:GetAbility():GetSpecialValueFor( "agi" ) * self:GetCaster():GetLevel()
end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
modifier_rda_pet_agi = class({})

function modifier_rda_pet_agi:IsHidden()
	return true
end

function modifier_rda_pet_agi:IsDebuff()
	return false
end

function modifier_rda_pet_agi:IsPurgable()
	return false
end

function modifier_rda_pet_agi:OnCreated( kv )
	self.caster = self:GetCaster()
	
	self.speed = self:GetAbility():GetSpecialValueFor( "speed" )

end

function modifier_rda_pet_agi:OnRefresh( kv )
end

function modifier_rda_pet_agi:OnRemoved(kv)
end

function modifier_rda_pet_agi:OnDestroy()
end

function modifier_rda_pet_agi:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end

function modifier_rda_pet_agi:DeclareFunctions()
	local funcs = {
	MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_SPENT_MANA,
	}
	return funcs
end

function modifier_rda_pet_agi:GetModifierMoveSpeed_Absolute()
	return self.speed
end

function modifier_rda_pet_agi:GetModifierIncomingDamage_Percentage()
	return 300
end

function modifier_rda_pet_agi:GetModifierModelChange(params)
 return "models/items/courier/el_gato_hero/el_gato_hero.vmdl"
end

function modifier_rda_pet_agi:OnAttack( params )
	if IsServer() then
	if params.attacker~=self:GetParent() then return end
	--if params.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then return end

	local modifier = self:GetParent():FindModifierByNameAndCaster( "modifier_rda_pet_agi", self:GetParent() )
	if not modifier then return end
	
	modifier:Destroy()
end
end

function modifier_rda_pet_agi:OnSpentMana( params )
	if IsServer() then
	local ability = self:GetAbility()
	local parent = self:GetParent()

	local cost = params.cost
	local unit = params.unit
			
	if unit == parent then
	
	self.mana_loss = 0
	
    self.mana_loss = self.mana_loss + params.cost
	if self.mana_loss >= 10 then

	local modifier = self:GetParent():FindModifierByNameAndCaster( "modifier_rda_pet_agi", self:GetParent() )
	if not modifier then return end
	
	modifier:Destroy()
end
end
end
end