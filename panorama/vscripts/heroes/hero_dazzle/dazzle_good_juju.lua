---@class dazzle_good_juju:CDOTA_Ability_Lua
dazzle_good_juju = class({}) 

LinkLuaModifier("modifier_dazzle_good_juju_lua", "heroes/hero_dazzle/modifier_dazzle_good_juju", LUA_MODIFIER_MOTION_NONE)

dazzle_good_juju.restricted_items = {
	item_refresher = true,
	item_ex_machina = true,
}

function dazzle_good_juju:GetIntrinsicModifierName()
	return "modifier_dazzle_good_juju_lua"
end

function dazzle_good_juju:GetBehavior()
	if self:GetCaster():HasScepter() then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
	else
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	end
end

function dazzle_good_juju:GetManaCost(level)
	if self:GetCaster():HasScepter() then
		return self:GetLevelSpecialValueFor("scepter_mana_cost", level)
	end
end

function dazzle_good_juju:GetCooldown(level)
	if self:GetCaster():HasScepter() then
		return self:GetLevelSpecialValueFor("scepter_cooldown", level)
	end
end

function dazzle_good_juju:OnSpellStart()
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()

	if not target then return end

	for i = 0, DOTA_ITEM_INVENTORY_SIZE - 1 do
		local item = target:GetItemInSlot(i)
		
		if item and item:GetPurchaser():GetPlayerOwnerID() == target:GetPlayerOwnerID() and not self.restricted_items[item:GetAbilityName()] then
			item:EndCooldown()
		end
	end

	ParticleManager:CreateParticle("particles/units/heroes/hero_dazzle/dazzle_lucky_charm.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	EmitSoundOn("DOTA_Item.Refresher.Activate", target)
end