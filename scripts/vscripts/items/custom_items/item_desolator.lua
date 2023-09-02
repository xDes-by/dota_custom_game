if item_blight_stone_lua == nil then item_blight_stone_lua = class({}) end
LinkLuaModifier( "modifier_item_blight_stone_lua", "items/custom_items/item_desolator.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_curruption_armor_debuff", "items/custom_items/item_desolator.lua", LUA_MODIFIER_MOTION_NONE )

function item_blight_stone_lua:GetIntrinsicModifierName()
	return "modifier_item_blight_stone_lua"
end

if modifier_item_blight_stone_lua == nil then modifier_item_blight_stone_lua = class({}) end

function modifier_item_blight_stone_lua:IsHidden()		
	return true 
end

function modifier_item_blight_stone_lua:IsPurgable()		
	return false 
end

function modifier_item_blight_stone_lua:RemoveOnDeath()	
	return false 
end

function modifier_item_blight_stone_lua:GetAttributes()	
	return MODIFIER_ATTRIBUTE_MULTIPLE 
end

function modifier_item_blight_stone_lua:OnCreated()	
	self.armor_reduction = self:GetAbility():GetSpecialValueFor("armor_reduction")
end

function modifier_item_blight_stone_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
	}
end

function modifier_item_blight_stone_lua:GetModifierProcAttack_Feedback( data )
	data.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_curruption_armor_debuff", {duration = 5, armor_reduction = self.armor_reduction})
end
----------------------------------------------------------------------
--Оптимизированный код дезоляторов
----------------------------------------------------------------------
item_desolator_lua = class({})

item_desolator_lua1 = item_desolator_lua
item_desolator_lua2 = item_desolator_lua
item_desolator_lua3 = item_desolator_lua
item_desolator_lua4 = item_desolator_lua
item_desolator_lua5 = item_desolator_lua
item_desolator_lua6 = item_desolator_lua
item_desolator_lua7 = item_desolator_lua
item_desolator_lua8 = item_desolator_lua

item_desolator_lua1_gem1 = item_desolator_lua
item_desolator_lua2_gem1 = item_desolator_lua
item_desolator_lua3_gem1 = item_desolator_lua
item_desolator_lua4_gem1 = item_desolator_lua
item_desolator_lua5_gem1 = item_desolator_lua
item_desolator_lua6_gem1 = item_desolator_lua
item_desolator_lua7_gem1 = item_desolator_lua
item_desolator_lua8_gem1 = item_desolator_lua

item_desolator_lua1_gem2 = item_desolator_lua
item_desolator_lua2_gem2 = item_desolator_lua
item_desolator_lua3_gem2 = item_desolator_lua
item_desolator_lua4_gem2 = item_desolator_lua
item_desolator_lua5_gem2 = item_desolator_lua
item_desolator_lua6_gem2 = item_desolator_lua
item_desolator_lua7_gem2 = item_desolator_lua
item_desolator_lua8_gem2 = item_desolator_lua

item_desolator_lua1_gem3 = item_desolator_lua
item_desolator_lua2_gem3 = item_desolator_lua
item_desolator_lua3_gem3 = item_desolator_lua
item_desolator_lua4_gem3 = item_desolator_lua
item_desolator_lua5_gem3 = item_desolator_lua
item_desolator_lua6_gem3 = item_desolator_lua
item_desolator_lua7_gem3 = item_desolator_lua
item_desolator_lua8_gem3 = item_desolator_lua

item_desolator_lua1_gem4 = item_desolator_lua
item_desolator_lua2_gem4 = item_desolator_lua
item_desolator_lua3_gem4 = item_desolator_lua
item_desolator_lua4_gem4 = item_desolator_lua
item_desolator_lua5_gem4 = item_desolator_lua
item_desolator_lua6_gem4 = item_desolator_lua
item_desolator_lua7_gem4 = item_desolator_lua
item_desolator_lua8_gem4 = item_desolator_lua

item_desolator_lua1_gem5 = item_desolator_lua
item_desolator_lua2_gem5 = item_desolator_lua
item_desolator_lua3_gem5 = item_desolator_lua
item_desolator_lua4_gem5 = item_desolator_lua
item_desolator_lua5_gem5 = item_desolator_lua
item_desolator_lua6_gem5 = item_desolator_lua
item_desolator_lua7_gem5 = item_desolator_lua
item_desolator_lua8_gem5 = item_desolator_lua

LinkLuaModifier( "modifier_item_desolator_lua", "items/custom_items/item_desolator.lua", LUA_MODIFIER_MOTION_NONE )

function item_desolator_lua:GetIntrinsicModifierName()
	return "modifier_item_desolator_lua" 
end

modifier_item_desolator_lua = class({})

function modifier_item_desolator_lua:IsHidden()		
	return true 
end

function modifier_item_desolator_lua:IsPurgable()		
	return false 
end

function modifier_item_desolator_lua:RemoveOnDeath()	
	return false 
end

function modifier_item_desolator_lua:GetAttributes()	
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_desolator_lua:OnCreated()
	self.parent = self:GetParent()
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.corruption_armor = self:GetAbility():GetSpecialValueFor("corruption_armor")
	if not IsServer() then
		return
	end
	self.value = self:GetAbility():GetSpecialValueFor("bonus_gem")
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {value = self.value})
	end
end

function modifier_item_desolator_lua:OnDestroy()
	if not IsServer() then
		return
	end
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {value = self.value * -1})
	end
end

function modifier_item_desolator_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
	}
end

function modifier_item_desolator_lua:GetModifierProjectileName()
	return "particles/items_fx/desolator_projectile.vpcf"
end


function modifier_item_desolator_lua:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage 
end

function modifier_item_desolator_lua:GetModifierProcAttack_Feedback(data)
	data.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_curruption_armor_debuff", {duration = 5, armor_reduction = self.corruption_armor})
end

modifier_curruption_armor_debuff = class({})

function modifier_curruption_armor_debuff:IsHidden() 
	return false 
end

function modifier_curruption_armor_debuff:IsDebuff() 
	return true 
end

function modifier_curruption_armor_debuff:IsPurgable() 
	return true 
end

function modifier_curruption_armor_debuff:OnCreated(data)
	if not IsServer() then
		return
	end
	self.interval = false
	self.armor_reduction = 0
	if data.armor_reduction then
		self.armor_reduction = data.armor_reduction
	end
	self:SetHasCustomTransmitterData( true )
end

function modifier_curruption_armor_debuff:OnRefresh(data)
	if not IsServer() then
		return
	end
	if self.armor_reduction < data.armor_reduction then
		self.armor_reduction = data.armor_reduction
		self.caster = self:GetCaster()
	end
	if self.interval and self.armor_reduction == data.armor_reduction then
		self:StartIntervalThink(5)
	end
	if self.armor_reduction > data.armor_reduction and self.caster ~= self:GetCaster() and not self.interval then
		self.interval = true
		self:StartIntervalThink(5)
	end
	self:SendBuffRefreshToClients()
end

function modifier_curruption_armor_debuff:OnIntervalThink()
	self:Destroy()
end

function modifier_curruption_armor_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end

function modifier_curruption_armor_debuff:GetModifierPhysicalArmorBonus()
	return self.armor_reduction * -1
end

function modifier_curruption_armor_debuff:AddCustomTransmitterData()
	return {
		armor_reduction = self.armor_reduction,
	}
end

function modifier_curruption_armor_debuff:HandleCustomTransmitterData( data )
	self.armor_reduction = data.armor_reduction
end
