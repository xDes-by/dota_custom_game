LinkLuaModifier( "modifier_pet_rda_250_phys_dmg_reducrion_buff", "items/pets/item_pet_RDA_250_phys_dmg_reducrion", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_pet_rda_250_phys_dmg_reducrion", "items/pets/item_pet_RDA_250_phys_dmg_reducrion", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_pet_RDA_250_phys_dmg_reducrion", "items/pets/item_pet_RDA_250_phys_dmg_reducrion", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_take_drop_gem", "modifiers/modifier_take_drop_gem", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_custompet_delay", "items/pets/item_pet_RDA_250_bkb", LUA_MODIFIER_MOTION_NONE )

spell_item_pet_RDA_250_phys_dmg_reducrion = class({})

function spell_item_pet_RDA_250_phys_dmg_reducrion:OnSpellStart()
	if IsServer() then
		self.caster = self:GetCaster()
		
		self.caster:AddNewModifier(
		self.caster,
		self,
		"modifier_item_pet_RDA_250_phys_dmg_reducrion", 
		{})
		EmitSoundOn( "Hero_Lion.Voodoo", self:GetCaster() )
	end
end

function spell_item_pet_RDA_250_phys_dmg_reducrion:GetIntrinsicModifierName()
	return "modifier_pet_rda_250_phys_dmg_reducrion"
end

------------------------------------------------------------------

modifier_pet_rda_250_phys_dmg_reducrion = class({})

function modifier_pet_rda_250_phys_dmg_reducrion:IsHidden()
	return true
end

function modifier_pet_rda_250_phys_dmg_reducrion:IsPurgable()
	return false
end

function modifier_pet_rda_250_phys_dmg_reducrion:OnCreated( kv )
		if IsServer() then
		local point = self:GetCaster():GetAbsOrigin()
		if not self:GetCaster():IsIllusion() then
		self.pet = CreateUnitByName("pet_rda_250_phys_dmg_reducrion", point + Vector(500,500,500), true, nil, nil, DOTA_TEAM_GOODGUYS)
		self.pet:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
		self.pet:AddNewModifier(self:GetParent(),nil,"modifier_take_drop_gem",{})
		self.pet:SetOwner(self:GetCaster())
		end
	end
end

function modifier_pet_rda_250_phys_dmg_reducrion:OnDestroy()
	UTIL_Remove(self.pet)
end

------------------------------------------------------------------

modifier_pet_rda_250_phys_dmg_reducrion_buff = class({})

function modifier_pet_rda_250_phys_dmg_reducrion_buff:IsHidden()
	return true
end

function modifier_pet_rda_250_phys_dmg_reducrion_buff:OnCreated()
	self.particle = ParticleManager:CreateParticle("particles/items2_fx/vanguard_active.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControlEnt(self.particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_origin", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(self.particle, 2, Vector(self:GetParent():GetModelRadius() * 1.2, 0, 0))
	self:AddParticle(self.particle, false, false, -1, false, false)
end

function modifier_pet_rda_250_phys_dmg_reducrion_buff:IsPurgable()
	return false
end

function modifier_pet_rda_250_phys_dmg_reducrion_buff:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL 
	}
	return funcs
end

function modifier_pet_rda_250_phys_dmg_reducrion_buff:GetAbsoluteNoDamagePhysical()
	return 1
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
modifier_item_pet_RDA_250_phys_dmg_reducrion = class({})

function modifier_item_pet_RDA_250_phys_dmg_reducrion:IsHidden()
	return true
end

function modifier_item_pet_RDA_250_phys_dmg_reducrion:IsDebuff()
	return false
end

function modifier_item_pet_RDA_250_phys_dmg_reducrion:IsPurgable()
	return false
end

function modifier_item_pet_RDA_250_phys_dmg_reducrion:OnCreated( kv ) 
	self.caster = self:GetCaster()
	self.speed = self:GetAbility():GetSpecialValueFor( "speed" )
end

function modifier_item_pet_RDA_250_phys_dmg_reducrion:OnDestroy()
	if not IsServer() then return end
	if not self.caster:HasModifier("modifier_custompet_delay") then
		EmitSoundOn("sounds/items/crimson_guard.vsnd", self.caster)
		self.caster:AddNewModifier(self:GetParent(), nil, "modifier_pet_rda_250_phys_dmg_reducrion_buff", {duration = self:GetAbility():GetSpecialValueFor("dur")})
		self.caster:AddNewModifier(self:GetParent(), nil, "modifier_custompet_delay", {duration = 30})
	end
end

function modifier_item_pet_RDA_250_phys_dmg_reducrion:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end

function modifier_item_pet_RDA_250_phys_dmg_reducrion:DeclareFunctions()
	local funcs = {
	MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_SPENT_MANA,
	}
	return funcs
end

function modifier_item_pet_RDA_250_phys_dmg_reducrion:GetModifierModelChange(params)
 return "models/items/courier/premier_league_wyrmeleon/premier_league_wyrmeleon.vmdl"
end

function modifier_item_pet_RDA_250_phys_dmg_reducrion:GetModifierMoveSpeed_Absolute()
	return self.speed
end

function modifier_item_pet_RDA_250_phys_dmg_reducrion:GetModifierIncomingDamage_Percentage()
	return 300
end

function modifier_item_pet_RDA_250_phys_dmg_reducrion:OnAttack( params )
	if IsServer() then
	if params.attacker~=self:GetParent() then return end
	--if params.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then return end

	local modifier = self:GetParent():FindModifierByNameAndCaster( "modifier_item_pet_RDA_250_phys_dmg_reducrion", self:GetParent() )
	if not modifier then return end
	
	modifier:Destroy()
end
end

function modifier_item_pet_RDA_250_phys_dmg_reducrion:OnSpentMana( params )
	if IsServer() then
	local ability = self:GetAbility()
	local parent = self:GetParent()

	local cost = params.cost
	local unit = params.unit
			
	if unit == parent then
	
	self.mana_loss = 0
	
    self.mana_loss = self.mana_loss + params.cost
	if self.mana_loss >= 10 then

	local modifier = self:GetParent():FindModifierByNameAndCaster( "modifier_item_pet_RDA_250_phys_dmg_reducrion", self:GetParent() )
	if not modifier then return end
	
	modifier:Destroy()
end
end
end
end