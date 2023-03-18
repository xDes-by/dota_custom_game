modifier_mars_atrophy_aura_lua_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_mars_atrophy_aura_lua_debuff:IsHidden()
	return false
end

function modifier_mars_atrophy_aura_lua_debuff:IsDebuff()
	return true
end

function modifier_mars_atrophy_aura_lua_debuff:IsStunDebuff()
	return false
end

function modifier_mars_atrophy_aura_lua_debuff:IsPurgable()
	return true
end

function modifier_mars_atrophy_aura_lua_debuff:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE 
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_mars_atrophy_aura_lua_debuff:OnCreated( kv )
	self.reduction = self:GetAbility():GetSpecialValueFor( "damage_reduction_pct" )
self:StartIntervalThink(0.1)
	if not IsServer() then return end
end

function modifier_mars_atrophy_aura_lua_debuff:OnRefresh( kv )
	self.reduction = self:GetAbility():GetSpecialValueFor( "damage_reduction_pct" )	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_mars_str8")
		if abil ~= nil then 
		self.reduction = self.reduction + 10
		end
end

function modifier_mars_atrophy_aura_lua_debuff:OnIntervalThink()

	self:OnRefresh()
end


function modifier_mars_atrophy_aura_lua_debuff:OnRemoved()
end

function modifier_mars_atrophy_aura_lua_debuff:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_mars_atrophy_aura_lua_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
	return funcs
end

function modifier_mars_atrophy_aura_lua_debuff:GetModifierMagicalResistanceBonus()
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_mars_int7")
	if abil ~= nil then 
	return -20
	else
	return 0
	end
end

function modifier_mars_atrophy_aura_lua_debuff:GetModifierBaseDamageOutgoing_Percentage( params )
	return -self.reduction
end

function modifier_mars_atrophy_aura_lua_debuff:GetModifierPhysicalArmorBonus( params )
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_mars_str11")
		if abil ~= nil then 
		return -10
		else
		return 0
	end
end