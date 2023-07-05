LinkLuaModifier( "modifier_pet_rda_250_bkb", "items/pets/item_pet_RDA_250_bkb", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_pet_RDA_250_bkb", "items/pets/item_pet_RDA_250_bkb", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_take_drop_gem", "modifiers/modifier_take_drop_gem", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_custompet_bkb", "items/pets/item_pet_RDA_250_bkb", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_custompet_delay", "items/pets/item_pet_RDA_250_bkb", LUA_MODIFIER_MOTION_NONE )

spell_item_pet_RDA_250_bkb = class({})

function spell_item_pet_RDA_250_bkb:OnSpellStart()
	if IsServer() then
		self.caster = self:GetCaster()
		
		self.caster:AddNewModifier(
		self.caster,
		self,
		"modifier_item_pet_RDA_250_bkb", 
		{})
		EmitSoundOn( "Hero_Lion.Voodoo", self:GetCaster() )
	end
end

function spell_item_pet_RDA_250_bkb:GetIntrinsicModifierName()
	return "modifier_pet_rda_250_bkb"
end

-------------------------------------------------------------------

modifier_pet_rda_250_bkb = class({})

function modifier_pet_rda_250_bkb:IsHidden()
	return true
end

function modifier_pet_rda_250_bkb:IsPurgable()
	return false
end

function modifier_pet_rda_250_bkb:OnCreated( kv )
	if IsServer() then
		local point = self:GetCaster():GetAbsOrigin()
		if not self:GetCaster():IsIllusion() then
		self.pet = CreateUnitByName("pet_rda_250_bkb", point + Vector(500,500,500), true, nil, nil, DOTA_TEAM_GOODGUYS)
		self.pet:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
		self.pet:AddNewModifier(self:GetParent(),nil,"modifier_take_drop_gem",{})
		self.pet:SetOwner(self:GetCaster())
		end
	end
end

function modifier_pet_rda_250_bkb:OnDestroy()
	UTIL_Remove(self.pet)
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
modifier_custompet_delay = class({})

function modifier_custompet_delay:IsHidden() return false end
function modifier_custompet_delay:IsPurgable() return false end
function modifier_custompet_delay:RemoveOnDeath() return false end

---------------------------------------------------------------------

modifier_custompet_bkb = class({})

function modifier_custompet_bkb:IsHidden() return true end
function modifier_custompet_bkb:IsPurgable() return false end
function modifier_custompet_bkb:IsDebuff() return false end

function modifier_custompet_bkb:GetEffectName()
    return "particles/items_fx/black_king_bar_avatar.vpcf"
end

function modifier_custompet_bkb:OnCreated()
end

function modifier_custompet_bkb:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_custompet_bkb:CheckState()
    local state = {[MODIFIER_STATE_MAGIC_IMMUNE] = true}
    return state
end

function modifier_custompet_bkb:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_MODEL_SCALE}
end

function modifier_custompet_bkb:GetModifierModelScale()
    return 30
end


----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
modifier_item_pet_RDA_250_bkb = class({})

function modifier_item_pet_RDA_250_bkb:IsHidden()
	return true
end

function modifier_item_pet_RDA_250_bkb:IsDebuff()
	return false
end

function modifier_item_pet_RDA_250_bkb:IsPurgable()
	return false
end

function modifier_item_pet_RDA_250_bkb:OnCreated( kv ) 
	self.caster = self:GetCaster()
	self.speed = self:GetAbility():GetSpecialValueFor( "speed" )
end

function modifier_item_pet_RDA_250_bkb:OnDestroy()
	if not IsServer() then return end
	if not self.caster:HasModifier("modifier_custompet_delay") then
		EmitSoundOn("DOTA_Item.BlackKingBar.Activate", self.caster)
		self.caster:AddNewModifier(self:GetParent(), nil, "modifier_custompet_bkb", {duration = self:GetAbility():GetSpecialValueFor("bkb")})
		self.caster:AddNewModifier(self:GetParent(), nil, "modifier_custompet_delay", {duration = 30})
	end
end

function modifier_item_pet_RDA_250_bkb:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end

function modifier_item_pet_RDA_250_bkb:DeclareFunctions()
	local funcs = {
	MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_SPENT_MANA,
	}
	return funcs
end

function modifier_item_pet_RDA_250_bkb:GetModifierModelChange(params)
 return "models/items/courier/pumpkin_courier/pumpkin_courier.vmdl"
end

function modifier_item_pet_RDA_250_bkb:GetModifierMoveSpeed_Absolute()
	return self.speed
end

function modifier_item_pet_RDA_250_bkb:GetModifierIncomingDamage_Percentage()
	return 300
end

function modifier_item_pet_RDA_250_bkb:OnAttack( params )
	if IsServer() then
	if params.attacker~=self:GetParent() then return end
	--if params.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then return end

	local modifier = self:GetParent():FindModifierByNameAndCaster( "modifier_item_pet_RDA_250_bkb", self:GetParent() )
	if not modifier then return end
	
	modifier:Destroy()
end
end

function modifier_item_pet_RDA_250_bkb:OnSpentMana( params )
	if IsServer() then
	local ability = self:GetAbility()
	local parent = self:GetParent()

	local cost = params.cost
	local unit = params.unit
			
	if unit == parent then
	
	self.mana_loss = 0
	
    self.mana_loss = self.mana_loss + params.cost
	if self.mana_loss >= 10 then

	local modifier = self:GetParent():FindModifierByNameAndCaster( "modifier_item_pet_RDA_250_bkb", self:GetParent() )
	if not modifier then return end
	
	modifier:Destroy()
end
end
end
end