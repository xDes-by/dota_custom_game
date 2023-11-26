LinkLuaModifier( "modifier_pet_rda_roshan_2", "items/pets/item_pet_rda_roshan_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_pet_rda_roshan_2", "items/pets/item_pet_rda_roshan_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_take_drop_gem", "modifiers/modifier_take_drop_gem", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_custompet_bkb", "items/pets/item_pet_rda_roshan_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_custompet_delay", "items/pets/item_pet_rda_roshan_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_pet_rda_250_minus_armor_debuff", "items/pets/item_pet_RDA_250_minus_armor", LUA_MODIFIER_MOTION_NONE )

spell_item_pet_rda_roshan_2 = class({})

function spell_item_pet_rda_roshan_2:OnSpellStart()
	if IsServer() then
		self.caster = self:GetCaster()
		
		self.caster:AddNewModifier(
		self.caster,
		self,
		"modifier_pet_rda_roshan_2", 
		{})
		EmitSoundOn( "Hero_Lion.Voodoo", self:GetCaster() )
	end
end

function spell_item_pet_rda_roshan_2:GetIntrinsicModifierName()
	return "modifier_item_pet_rda_roshan_2"
end

modifier_item_pet_rda_roshan_2 = class({})

function modifier_item_pet_rda_roshan_2:IsHidden()
	return true
end

function modifier_item_pet_rda_roshan_2:IsPurgable()
	return false
end

function modifier_item_pet_rda_roshan_2:OnCreated( kv )
		if IsServer() then
		local point = self:GetCaster():GetAbsOrigin()
		if not self:GetCaster():IsIllusion() then
			self.pet = CreateUnitByName("pet_rda_roshan_2", point + Vector(500,500,500), true, nil, nil, DOTA_TEAM_GOODGUYS)
			self.pet:AddNewModifier(self:GetParent(),nil,"modifier_take_drop_gem",{})
			self.pet:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
			self.pet:SetOwner(self:GetCaster())
		end
end
end
function modifier_item_pet_rda_roshan_2:OnDestroy()
	UTIL_Remove(self.pet)
end

function modifier_item_pet_rda_roshan_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_PROPERTY_EXP_RATE_BOOST,
		MODIFIER_PROPERTY_GOLD_RATE_BOOST,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_VISUAL_Z_DELTA
	}
end

function modifier_item_pet_rda_roshan_2:GetModifierTotalPercentageManaRegen()
	return self:GetAbility():GetSpecialValueFor("regen")
end

function modifier_item_pet_rda_roshan_2:GetModifierHealthRegenPercentage()
	return self:GetAbility():GetSpecialValueFor("regen")
end

function modifier_item_pet_rda_roshan_2:GetModifierProcAttack_BonusDamage_Pure()
	return self:GetParent():GetAttackDamage() * self:GetAbility():GetSpecialValueFor("pure_percent") * 0.01
end

function modifier_item_pet_rda_roshan_2:OnAttack(keys)
	self.cast = 0
end

function modifier_item_pet_rda_roshan_2:OnAbilityFullyCast(keys)
	self.cast = 0
	if keys.ability:IsItem() then
		self.cast = 1
	end
end

function modifier_item_pet_rda_roshan_2:GetModifierTotalDamageOutgoing_Percentage(keys)
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

function modifier_item_pet_rda_roshan_2:OnAttackLanded(keys)
	if keys.attacker == self:GetParent() and self:GetParent():HasModifier("modifier_item_pet_rda_roshan_2") then
		keys.target:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_pet_rda_250_minus_armor_debuff", {duration = 5})	
	end
end

function modifier_item_pet_rda_roshan_2:GetModifierPercentageGoldRateBoost()
	return self:GetAbility():GetSpecialValueFor("goex")
end

function modifier_item_pet_rda_roshan_2:GetModifierPercentageExpRateBoost()
	return self:GetAbility():GetSpecialValueFor("goex")
end

function modifier_item_pet_rda_roshan_2:GetModifierIncomingDamage_Percentage()
	return self:GetAbility():GetSpecialValueFor("dur")
end

function modifier_item_pet_rda_roshan_2:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("stats_bonus") * self:GetParent():GetLevel()
end

function modifier_item_pet_rda_roshan_2:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("stats_bonus") * self:GetParent():GetLevel()
end

function modifier_item_pet_rda_roshan_2:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("stats_bonus") * self:GetParent():GetLevel()
end

function modifier_item_pet_rda_roshan_2:GetVisualZDelta()
	return 100
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
modifier_pet_rda_roshan_2 = class({})

function modifier_pet_rda_roshan_2:IsHidden()
	return true
end

function modifier_pet_rda_roshan_2:IsDebuff()
	return false
end

function modifier_pet_rda_roshan_2:IsPurgable()
	return false
end

function modifier_pet_rda_roshan_2:OnCreated( kv ) 
	self.caster = self:GetCaster()
	
	self.speed = self:GetAbility():GetSpecialValueFor( "speed" )

end

function modifier_pet_rda_roshan_2:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end

function modifier_pet_rda_roshan_2:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_SPENT_MANA,
	}
	return funcs
end



function modifier_pet_rda_roshan_2:GetModifierModelChange(params)
 return "models/courier/baby_rosh/babyroshan_ti10_dire_flying.vmdl"
end

function modifier_pet_rda_roshan_2:GetModifierMoveSpeed_Absolute()
	return self.speed
end

function modifier_pet_rda_roshan_2:GetModifierIncomingDamage_Percentage()
	return 300
end

function modifier_pet_rda_roshan_2:OnAttack( params )
	if IsServer() then
	if params.attacker~=self:GetParent() then return end
	--if params.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then return end
	EmitSoundOn("DOTA_Item.BlackKingBar.Activate", self.caster)
	self.caster:AddNewModifier(self:GetParent(), nil, "modifier_custompet_bkb", {duration = self:GetAbility():GetSpecialValueFor("bkb")})
	self.caster:AddNewModifier(self:GetParent(), nil, "modifier_custompet_delay", {duration = 30})
	local modifier = self:GetParent():FindModifierByNameAndCaster( "modifier_pet_rda_roshan_2", self:GetParent() )
	if not modifier then return end
	
	modifier:Destroy()
end
end

function modifier_pet_rda_roshan_2:OnSpentMana( params )
	if IsServer() then
	local ability = self:GetAbility()
	local parent = self:GetParent()

	local cost = params.cost
	local unit = params.unit
			
	if unit == parent then
	
	self.mana_loss = 0
	
    self.mana_loss = self.mana_loss + params.cost
	if self.mana_loss >= 10 then

	local modifier = self:GetParent():FindModifierByNameAndCaster( "modifier_pet_rda_roshan_2", self:GetParent() )
	if not modifier then return end
	
	modifier:Destroy()
end
end
end
end

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