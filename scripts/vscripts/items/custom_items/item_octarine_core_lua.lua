item_octarine_core_lua = class({})

item_octarine_core_lua1 = item_octarine_core_lua
item_octarine_core_lua2 = item_octarine_core_lua
item_octarine_core_lua3 = item_octarine_core_lua
item_octarine_core_lua4 = item_octarine_core_lua
item_octarine_core_lua5 = item_octarine_core_lua
item_octarine_core_lua6 = item_octarine_core_lua
item_octarine_core_lua7 = item_octarine_core_lua
item_octarine_core_lua8 = item_octarine_core_lua

item_octarine_core_lua1_gem1 = item_octarine_core_lua
item_octarine_core_lua2_gem1 = item_octarine_core_lua
item_octarine_core_lua3_gem1 = item_octarine_core_lua
item_octarine_core_lua4_gem1 = item_octarine_core_lua
item_octarine_core_lua5_gem1 = item_octarine_core_lua
item_octarine_core_lua6_gem1 = item_octarine_core_lua
item_octarine_core_lua7_gem1 = item_octarine_core_lua
item_octarine_core_lua8_gem1 = item_octarine_core_lua

item_octarine_core_lua1_gem2 = item_octarine_core_lua
item_octarine_core_lua2_gem2 = item_octarine_core_lua
item_octarine_core_lua3_gem2 = item_octarine_core_lua
item_octarine_core_lua4_gem2 = item_octarine_core_lua
item_octarine_core_lua5_gem2 = item_octarine_core_lua
item_octarine_core_lua6_gem2 = item_octarine_core_lua
item_octarine_core_lua7_gem2 = item_octarine_core_lua
item_octarine_core_lua8_gem2 = item_octarine_core_lua

item_octarine_core_lua1_gem3 = item_octarine_core_lua
item_octarine_core_lua2_gem3 = item_octarine_core_lua
item_octarine_core_lua3_gem3 = item_octarine_core_lua
item_octarine_core_lua4_gem3 = item_octarine_core_lua
item_octarine_core_lua5_gem3 = item_octarine_core_lua
item_octarine_core_lua6_gem3 = item_octarine_core_lua
item_octarine_core_lua7_gem3 = item_octarine_core_lua
item_octarine_core_lua8_gem3 = item_octarine_core_lua

item_octarine_core_lua1_gem4 = item_octarine_core_lua
item_octarine_core_lua2_gem4 = item_octarine_core_lua
item_octarine_core_lua3_gem4 = item_octarine_core_lua
item_octarine_core_lua4_gem4 = item_octarine_core_lua
item_octarine_core_lua5_gem4 = item_octarine_core_lua
item_octarine_core_lua6_gem4 = item_octarine_core_lua
item_octarine_core_lua7_gem4 = item_octarine_core_lua
item_octarine_core_lua8_gem4 = item_octarine_core_lua

item_octarine_core_lua1_gem5 = item_octarine_core_lua
item_octarine_core_lua2_gem5 = item_octarine_core_lua
item_octarine_core_lua3_gem5 = item_octarine_core_lua
item_octarine_core_lua4_gem5 = item_octarine_core_lua
item_octarine_core_lua5_gem5 = item_octarine_core_lua
item_octarine_core_lua6_gem5 = item_octarine_core_lua
item_octarine_core_lua7_gem5 = item_octarine_core_lua
item_octarine_core_lua8_gem5 = item_octarine_core_lua

LinkLuaModifier("modifier_item_octarine_core_lua", 'items/custom_items/item_octarine_core_lua.lua', LUA_MODIFIER_MOTION_NONE)

function item_octarine_core_lua:GetManaCost(iLevel)
	return self:GetCaster():GetMaxMana()/2
end

function item_octarine_core_lua:OnSpellStart()
	local caster = self:GetCaster()
    local particle = ParticleManager:CreateParticle("particles/items2_fx/refresher.vpcf", PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetOrigin(), true)
    ParticleManager:ReleaseParticleIndex(particle)

    EmitSoundOnLocationWithCaster(caster:GetOrigin(), "DOTA_Item.Refresher.Activate", caster)
	for i = 0, 8 do 
		local current_item = caster:GetItemInSlot(i)
		local should_refresh = true
		
		if current_item and (string.find(current_item:GetName(), "octarine_core") or current_item:GetPurchaser() ~= caster) or string.find(current_item:GetName(), "item_ex_machina") then
			should_refresh = false
		end

		if current_item and should_refresh then
			current_item:EndCooldown()
		end
	end
end

function item_octarine_core_lua:GetIntrinsicModifierName()
	return "modifier_item_octarine_core_lua"
end

modifier_item_octarine_core_lua = class({})

function modifier_item_octarine_core_lua:IsHidden()
	return true
end

function modifier_item_octarine_core_lua:IsPurgable()
	return false
end

function modifier_item_octarine_core_lua:DestroyOnExpire()
	return false
end

function modifier_item_octarine_core_lua:RemoveOnDeath()	
	return false 
end

function modifier_item_octarine_core_lua:OnCreated()
	self.parent = self:GetParent()
	self.bonus_mana = self:GetAbility():GetSpecialValueFor("bonus_mana")
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
	self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
	self.bonus_cooldown = self:GetAbility():GetSpecialValueFor("bonus_cooldown")
	self.cast_range_bonus = self:GetAbility():GetSpecialValueFor("cast_range_bonus")
	if not IsServer() then
		return
	end
	self.value = self:GetAbility():GetSpecialValueFor("bonus_gem")
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {value = self.value})
	end
end

function modifier_item_octarine_core_lua:OnDestroy()
	if not IsServer() then
		return
	end
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {value = self.value * -1})
	end
end

function modifier_item_octarine_core_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS
	}
end

function modifier_item_octarine_core_lua:GetModifierHealthBonus()
	return self.bonus_health
end

function modifier_item_octarine_core_lua:GetModifierManaBonus()
	return self.bonus_mana
end

function modifier_item_octarine_core_lua:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end

function modifier_item_octarine_core_lua:GetModifierPercentageCooldown()
	return self.bonus_cooldown
end

function modifier_item_octarine_core_lua:GetModifierCastRangeBonus()
	return self.cast_range_bonus
end