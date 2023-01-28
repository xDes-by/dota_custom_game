modifier_mars_lil_debuff = class({})

function modifier_mars_lil_debuff:IsHidden()
	return false
end

function modifier_mars_lil_debuff:IsDebuff()
	return true
end

function modifier_mars_lil_debuff:IsStunDebuff()
	return false
end

function modifier_mars_lil_debuff:IsPurgable()
	return true
end

function modifier_mars_lil_debuff:OnCreated( kv )
	self.loss = self:GetAbility():GetSpecialValueFor( "loss_armor" ) *(-1)
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_mars_agi7") ~= nil then 
		self.loss = self.loss - 1
	end

	if self:GetCaster():FindAbilityByName("npc_dota_hero_mars_agi_last") ~= nil then 
		self.loss = self.loss - 3
	end

	if not IsServer() then return end
	self:SetStackCount( 1 )
end

function modifier_mars_lil_debuff:OnRefresh( kv )
	if not IsServer() then return end
	self:IncrementStackCount()
end

function modifier_mars_lil_debuff:OnRemoved()
end

function modifier_mars_lil_debuff:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_mars_lil_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}

	return funcs
end

function modifier_mars_lil_debuff:GetModifierPhysicalArmorBonus()
	return self.loss * self:GetStackCount()
end


function modifier_mars_lil_debuff:GetModifierMagicalResistanceBonus()
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_mars_int6")
	if abil ~= nil then 
	return self.loss * self:GetStackCount()
	else
	return 0
	end
end
--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_mars_lil_debuff:GetEffectName()
	-- return "particles/units/heroes/hero_snapfire/hero_snapfire_slow_debuff.vpcf"
	return "particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf"
end

function modifier_mars_lil_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

