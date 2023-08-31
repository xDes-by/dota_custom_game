item_kaya_lua = class({})

item_kaya_lua1 = item_kaya_lua
item_kaya_lua2 = item_kaya_lua
item_kaya_lua3 = item_kaya_lua
item_kaya_lua4 = item_kaya_lua
item_kaya_lua5 = item_kaya_lua
item_kaya_lua6 = item_kaya_lua
item_kaya_lua7 = item_kaya_lua
item_kaya_lua8 = item_kaya_lua

item_kaya_lua1_gem1 = item_kaya_lua
item_kaya_lua2_gem1 = item_kaya_lua
item_kaya_lua3_gem1 = item_kaya_lua
item_kaya_lua4_gem1 = item_kaya_lua
item_kaya_lua5_gem1 = item_kaya_lua
item_kaya_lua6_gem1 = item_kaya_lua
item_kaya_lua7_gem1 = item_kaya_lua
item_kaya_lua8_gem1 = item_kaya_lua

item_kaya_lua1_gem2 = item_kaya_lua
item_kaya_lua2_gem2 = item_kaya_lua
item_kaya_lua3_gem2 = item_kaya_lua
item_kaya_lua4_gem2 = item_kaya_lua
item_kaya_lua5_gem2 = item_kaya_lua
item_kaya_lua6_gem2 = item_kaya_lua
item_kaya_lua7_gem2 = item_kaya_lua
item_kaya_lua8_gem2 = item_kaya_lua

item_kaya_lua1_gem3 = item_kaya_lua
item_kaya_lua2_gem3 = item_kaya_lua
item_kaya_lua3_gem3 = item_kaya_lua
item_kaya_lua4_gem3 = item_kaya_lua
item_kaya_lua5_gem3 = item_kaya_lua
item_kaya_lua6_gem3 = item_kaya_lua
item_kaya_lua7_gem3 = item_kaya_lua
item_kaya_lua8_gem3 = item_kaya_lua

item_kaya_lua1_gem4 = item_kaya_lua
item_kaya_lua2_gem4 = item_kaya_lua
item_kaya_lua3_gem4 = item_kaya_lua
item_kaya_lua4_gem4 = item_kaya_lua
item_kaya_lua5_gem4 = item_kaya_lua
item_kaya_lua6_gem4 = item_kaya_lua
item_kaya_lua7_gem4 = item_kaya_lua
item_kaya_lua8_gem4 = item_kaya_lua

item_kaya_lua1_gem5 = item_kaya_lua
item_kaya_lua2_gem5 = item_kaya_lua
item_kaya_lua3_gem5 = item_kaya_lua
item_kaya_lua4_gem5 = item_kaya_lua
item_kaya_lua5_gem5 = item_kaya_lua
item_kaya_lua6_gem5 = item_kaya_lua
item_kaya_lua7_gem5 = item_kaya_lua
item_kaya_lua8_gem5 = item_kaya_lua

LinkLuaModifier( "modifier_item_kaya_lua", "items/custom_items/item_kaya_lua", LUA_MODIFIER_MOTION_NONE )

function item_kaya_lua:GetIntrinsicModifierName()
	return "modifier_item_kaya_lua"
end

-----------------------------------------------------------------------------

modifier_item_kaya_lua = class({})


function modifier_item_kaya_lua:IsHidden()
	return true
end

function modifier_item_kaya_lua:IsPurgable()
	return false
end

function modifier_item_kaya_lua:OnCreated( kv )
	self.parent = self:GetParent()
	self.bonus_dmg = self:GetAbility():GetSpecialValueFor( "spell_amp" )
	self.spell_lifesteal_amp = self:GetAbility():GetSpecialValueFor( "spell_lifesteal_amp" )
	self.bonus_int = self:GetAbility():GetSpecialValueFor( "bonus_intellect" )
	self.mana_regen_multiplier = self:GetAbility():GetSpecialValueFor( "mana_regen_multiplier" )
	self.particle_name = "particles/items3_fx/octarine_core_lifesteal.vpcf"
	if not IsServer() then
		return
	end
	self.value = self:GetAbility():GetSpecialValueFor("bonus_gem")
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {ability = self:GetAbility():entindex(), value = self.value})
	end
end

function modifier_item_kaya_lua:OnDestroy()
	if not IsServer() then
		return
	end
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {ability = self:GetAbility():entindex(), value = self.value * -1})
	end
end

--------------------------------------------------------------------------------

function modifier_item_kaya_lua:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_SPELL_LIFESTEAL_AMPLIFY_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_kaya_lua:GetModifierSpellAmplify_Percentage( params )
	return self.bonus_dmg
end

function modifier_item_kaya_lua:GetModifierBonusStats_Intellect( params )
	return self.bonus_int
end

function modifier_item_kaya_lua:GetModifierSpellLifestealRegenAmplify_Percentage( params )
	return self.spell_lifesteal_amp
end

function modifier_item_kaya_lua:GetModifierMPRegenAmplify_Percentage( params )
	return self.mana_regen_multiplier
end