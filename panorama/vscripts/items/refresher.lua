---@class item_refresher:CDOTA_Item_Lua
item_refresher = class({})
LinkLuaModifier("modifier_item_refresher_lua", "items/refresher.lua", LUA_MODIFIER_MOTION_NONE)

local exceptions = {
	item_refresher = true,
	item_refresher_shard = true,
	item_ex_machina = true,
}

local slots = {
	DOTA_ITEM_SLOT_1,
	DOTA_ITEM_SLOT_2,
	DOTA_ITEM_SLOT_3,
	DOTA_ITEM_SLOT_4,
	DOTA_ITEM_SLOT_5,
	DOTA_ITEM_SLOT_6,
	DOTA_ITEM_SLOT_7,
	DOTA_ITEM_SLOT_8,
	DOTA_ITEM_SLOT_9,
	DOTA_ITEM_TP_SCROLL,
	DOTA_ITEM_NEUTRAL_SLOT,
}

function item_refresher:IsRefreshable()
	return false
end

function item_refresher:GetIntrinsicModifierName()
	return "modifier_item_refresher_lua"
end

function item_refresher:OnSpellStart()
	local caster = self:GetCaster()

	for i = 0, DOTA_MAX_ABILITIES - 1 do
		local ability = caster:GetAbilityByIndex(i)
		if ability and (not exceptions[ability:GetAbilityName()]) and ability:IsRefreshable() then
			ability:RefreshCharges()
			if ability._RefreshCharges then
				ability:_RefreshCharges() -- also refresh custom charges
			end
			ability:EndCooldown()
		end
	end

	for _, i in ipairs(slots) do
		local item = caster:GetItemInSlot(i)
		if item and (not exceptions[item:GetAbilityName()]) and item:IsRefreshable() then
			local purchaser = item:GetPurchaser()
			if not purchaser or purchaser:GetPlayerOwnerID() == caster:GetPlayerOwnerID() then
				item:EndCooldown()
			end
		end
	end
	
	ParticleManager:CreateParticle("particles/items2_fx/refresher.vpcf", PATTACH_CENTER_FOLLOW, caster)
	EmitSoundOn("DOTA_Item.Refresher.Activate", caster)
end

---@class modifier_item_refresher_lua:CDOTA_Modifier_Lua
modifier_item_refresher_lua = class({})

function modifier_item_refresher_lua:IsHidden() return true end
function modifier_item_refresher_lua:IsPurgable() return false end
function modifier_item_refresher_lua:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_item_refresher_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}
end

function modifier_item_refresher_lua:OnCreated()
	self.ability = self:GetAbility()
	self.health_regen = self.ability:GetSpecialValueFor("bonus_health_regen")
	self.mana_regen = self.ability:GetSpecialValueFor("bonus_mana_regen")

	if IsClient() then return end

	self.ability:SetFrozenCooldown(false)
end

function modifier_item_refresher_lua:OnDestroy()
	if IsClient() then return end

	if IsValidEntity(self.ability) and self.ability:GetCooldownTimeRemaining() > 0 then
		self.ability:SetFrozenCooldown(true)
	end
end

function modifier_item_refresher_lua:GetModifierConstantHealthRegen()
	return self.health_regen
end

function modifier_item_refresher_lua:GetModifierConstantManaRegen()
	return self.mana_regen
end
