item_crimson_guard_lua = class({})

LinkLuaModifier("modifier_item_crimson_guard_lua", 'items/custom_items/item_crimson_guard_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_crimson_guard_active_lua", 'items/custom_items/item_crimson_guard_lua.lua', LUA_MODIFIER_MOTION_NONE)

function item_crimson_guard_lua:GetAbilityTextureName()
	local level = self:GetLevel()
	if self:GetSecondaryCharges() == 0 then
		return "all/crimson_" .. level
	else
		return "gem" .. self:GetSecondaryCharges() .. "/item_crimson_guard_lua" .. level
	end
end

function item_crimson_guard_lua:GetIntrinsicModifierName()
	if (self:GetItemSlot() > 5 or self:GetItemSlot() == -1) then
		return
	end
	return "modifier_item_crimson_guard_lua"
end

function item_crimson_guard_lua:OnSpellStart()
	self:GetParent():EmitSound("Item.CrimsonGuard.Cast")
		local allys = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,units in pairs(allys) do
		units:AddNewModifier(self:GetCaster(), self, "modifier_item_crimson_guard_active_lua", {duration = 12})
	end
end

-------------------------------------------------------------------------------------

modifier_item_crimson_guard_active_lua = class({})

function modifier_item_crimson_guard_active_lua:OnCreated()
	EmitSoundOn("sounds/items/crimson_guard.vsnd", caster)

	self.particle = ParticleManager:CreateParticle("particles/items2_fx/vanguard_active.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControlEnt(self.particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_origin", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(self.particle, 2, Vector(self:GetParent():GetModelRadius() * 1.2, 0, 0))
	self:AddParticle(self.particle, false, false, -1, false, false)

	if self:GetParent():IsRangedAttacker() then
		self.block_damage_active = self:GetAbility():GetSpecialValueFor("block_damablock_damage_ranged_activege_ranged")
	else
		self.block_damage_active = self:GetAbility():GetSpecialValueFor("block_damage_melee_active")
	end
end

function modifier_item_crimson_guard_active_lua:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK
	}
end

function modifier_item_crimson_guard_active_lua:GetModifierPhysical_ConstantBlock()
	return self.block_damage_active
end

--------------------------------------------------------------------------

modifier_item_crimson_guard_lua = class({})

function modifier_item_crimson_guard_lua:IsHidden()		
	return true 
end
function modifier_item_crimson_guard_lua:IsPurgable()		
	return false 
end

function modifier_item_crimson_guard_lua:RemoveOnDeath()	
	return false 
end

function modifier_item_crimson_guard_lua:OnCreated()
	self.parent = self:GetParent()
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
	self.bonus_health_regen = self:GetAbility():GetSpecialValueFor("bonus_health_regen")
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")

	if self:GetParent():IsRangedAttacker() then
		self.block_damage = self:GetAbility():GetSpecialValueFor("block_damage_ranged")
	else
		self.block_damage = self:GetAbility():GetSpecialValueFor("block_damage_melee")
	end
end

function modifier_item_crimson_guard_lua:OnRefresh()
	self.parent = self:GetParent()
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
	self.bonus_health_regen = self:GetAbility():GetSpecialValueFor("bonus_health_regen")
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")

	if self:GetParent():IsRangedAttacker() then
		self.block_damage = self:GetAbility():GetSpecialValueFor("block_damage_ranged")
	else
		self.block_damage = self:GetAbility():GetSpecialValueFor("block_damage_melee")
	end
end

function modifier_item_crimson_guard_lua:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK
	}
end

function modifier_item_crimson_guard_lua:GetModifierConstantHealthRegen()
	return self.bonus_health_regen
end

function modifier_item_crimson_guard_lua:GetModifierHealthBonus()
	return self.bonus_health
end

function modifier_item_crimson_guard_lua:GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end

function modifier_item_crimson_guard_lua:GetModifierPhysical_ConstantBlock(data)
	if RandomInt(1, 2) == 1 then
		return self.block_damage + data.damage * 0.01 * self:GetAbility():GetLevel()
	else
		return 0
	end
end 