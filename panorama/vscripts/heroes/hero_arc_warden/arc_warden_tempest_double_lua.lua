---@class arc_warden_tempest_double_lua:CDOTA_Ability_Lua
arc_warden_tempest_double_lua = class({})
LinkLuaModifier("modifier_tempest_double_illusion", "heroes/hero_arc_warden/modifier_tempest_double_illusion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tempest_double_illusion_permanent", "heroes/hero_arc_warden/modifier_tempest_double_illusion_permanent", LUA_MODIFIER_MOTION_NONE)


local TRANSFER_PLAIN = 1 -- just add modifier to clone
local TRANSFER_FULL = 2 -- add modifier and transfer stacks


arc_warden_tempest_double_lua.transferable_modifiers = {
	["modifier_item_moon_shard_consumed"] 		= TRANSFER_PLAIN,
	["modifier_item_ultimate_scepter_consumed"] = TRANSFER_PLAIN,
	['modifier_channel_listener']				= TRANSFER_PLAIN,
	['modifier_hero_refreshing']				= TRANSFER_PLAIN,
	["modifier_item_aghanims_shard"] 			= TRANSFER_PLAIN,
	["custom_modifier_book_stat_strength"] 		= TRANSFER_FULL,
	["custom_modifier_book_stat_intelligence"] 	= TRANSFER_FULL,
	["custom_modifier_book_stat_agility"] 		= TRANSFER_FULL,
	["modifier_tiny_grab_lua"] 					= TRANSFER_FULL,
	["modifier_loser_curse"]					= TRANSFER_FULL,
}


function arc_warden_tempest_double_lua:TransferModifiers(caster, clone)
	for name, transfer_type in pairs(self.transferable_modifiers) do
		local caster_modifier = caster:FindModifierByName(name)
		if caster_modifier and not caster_modifier:IsNull() then
			local clone_modifier = clone:AddNewModifier(clone, nil, name, {duration = caster_modifier:GetDuration()})
			if transfer_type == TRANSFER_FULL then
				clone_modifier:SetStackCount(caster_modifier:GetStackCount())
			end
		end
	end
end


function arc_warden_tempest_double_lua:GetHeroClone()
	local caster = self:GetCaster()
	if not caster or caster:IsNull() then return end
	local caster_name = caster:GetUnitName()
	if not self.clone then
		if caster.tempest_double_clone then
			self.clone = caster.tempest_double_clone
		else
			local clone = CreateUnitByName(
				caster_name, 
				caster:GetAbsOrigin(), 
				true, 
				caster, 
				caster,
				caster:GetTeamNumber()
			)

			clone.IsRealHero = function() return false end
			clone.IsMainHero = function() return false end
			clone.IsTempestDouble = function() return true end

			clone:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)
			clone:SetRenderColor(0, 0, 190)

			clone:AddNewModifier(clone, nil, "modifier_tempest_double_illusion_permanent", nil)
			clone:AddNewModifier(clone, nil, "modifier_spell_amplify_controller", nil)

			self.clone = clone
		end
	end

	if not self.clone:IsAlive() then
		self.clone:RespawnHero(false, false)
	end

	while self.clone:GetLevel() < caster:GetLevel() do
		self.clone:HeroLevelUp( false )
	end

	for index = DOTA_ITEM_SLOT_1 , DOTA_ITEM_SLOT_9 do
		local caster_item = caster:GetItemInSlot(index)
		local clone_item = self.clone:GetItemInSlot(index)
		if clone_item then
			self.clone:RemoveItem(clone_item)
		end
		if caster_item and not caster_item:IsNull() then
			local clonable = caster_item:GetKeyValue("IsTempestDoubleClonable") ~= 0
			if clonable then
				self.clone:AddItemByName(caster_item:GetAbilityName())
			end
		end
	end

	local neutralItem = caster:GetItemInSlot(DOTA_ITEM_NEUTRAL_SLOT)

	local cloneItem = self.clone:GetItemInSlot(DOTA_ITEM_NEUTRAL_SLOT)
	if (cloneItem) then 
		self.clone:RemoveItem(cloneItem)
	end

	if (neutralItem) then 
		self.clone:AddItemByName(neutralItem:GetAbilityName())
	end

	self.clone:SetBaseAgility(caster:GetBaseAgility())
	self.clone:SetBaseStrength(caster:GetBaseStrength())
	self.clone:SetBaseIntellect(caster:GetBaseIntellect())
	self.clone:Purge(true, true, false, true, true)
	self.clone:SetAbilityPoints(0)

	Illusions:HandleSuperIllusion(self.clone, caster)

	self:TransferModifiers(caster, self.clone)

	return self.clone
end


function arc_warden_tempest_double_lua:OnUpgrade()
	if not IsServer() then return end
	local clone = self:GetHeroClone()
	clone:ForceKill(false)
	clone:AddEffects(EF_NODRAW)
	clone:SetAbsOrigin(Vector(-8000, -8000, -8000))
end


function arc_warden_tempest_double_lua:OnSpellStart()
	if not IsServer() then return end

	local caster = self:GetCaster()
	if not caster or caster:IsNull() then return end

	local clone = self:GetHeroClone()
	if caster:HasModifier('modifier_hero_refreshing') then 
		clone:AddNewModifier(clone, nil, "modifier_hero_refreshing", {})
	else 
		clone:RemoveModifierByName('modifier_hero_refreshing')
	end

	clone:RemoveEffects(EF_NODRAW)

	-- Clone state is fixed throughout its entire duration for this cast
	local clone_team = clone:GetTeam()

	if clone_team then
		if Enfos:IsEnfosMode() then
			clone.unit_state = GameMode:GetPlayerState(clone:GetPlayerID())
		else
			clone.unit_state = GameMode:GetTeamState(clone_team)
		end
	end

	-- Duration dependent on having the corresponding talent levelled
	local duration = self:GetSpecialValueFor("duration") + caster:FindTalentValue("special_bonus_unique_arc_warden_6")

	caster.tempest_double_clone = clone

	Timers:RemoveTimer("arc_dying_sequence_" .. tostring(clone:GetEntityIndex()))

	FindClearRandomPositionAroundUnit(clone, caster, 100)
	clone:AddNewModifier(caster, self, "modifier_tempest_double_illusion", { duration = duration })

	local innate_trickster = clone:FindAbilityByName('innate_trickster')
	if innate_trickster then
		clone:RemoveModifierByName('modifier_innate_trickster')
		clone:AddNewModifier(clone, innate_trickster, 'modifier_innate_trickster', {})
	end

	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_arc_warden/arc_warden_tempest_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	Timers:CreateTimer(1, function()
		ParticleManager:DestroyParticle(particle, true)
		ParticleManager:ReleaseParticleIndex(particle)
	end)

	caster:EmitSound("Hero_ArcWarden.TempestDouble")
end
