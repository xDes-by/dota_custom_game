---@class vengeful_tempest_double:CDOTA_Ability_Lua
vengeful_tempest_double = class({})
LinkLuaModifier("modifier_tempest_double_illusion", "heroes/hero_vengeful_spirit/vengeful_tempest_double/modifier_tempest_double_illusion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tempest_double_illusion_permanent", "heroes/hero_vengeful_spirit/vengeful_tempest_double/modifier_tempest_double_illusion_permanent", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_vengeful_tempest_double_str30", "heroes/hero_vengeful_spirit/vengeful_tempest_double/modifier_vengeful_tempest_double_str30", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_npc_dota_hero_vengefulspirit_str11", "heroes/hero_vengeful_spirit/vengeful_tempest_double/modifier_npc_dota_hero_vengefulspirit_str11", LUA_MODIFIER_MOTION_NONE)


local TRANSFER_PLAIN = 1 -- just add modifier to clone
local TRANSFER_FULL = 2 -- add modifier and transfer stacks

function vengeful_tempest_double:GetManaCost(iLevel)
    return 150 + math.min(65000, self:GetCaster():GetIntellect() / 30)
end
vengeful_tempest_double.transferable_ability = {
    ["spell_item_pet_RDA_250_attribute_bonus"]           = TRANSFER_PLAIN,
    ["spell_item_pet_RDA_250_bkb"]                       = TRANSFER_PLAIN,
    ["spell_item_pet_RDA_250_dmg_reduction"]             = TRANSFER_PLAIN,
    ["spell_item_pet_RDA_250_gold_and_exp"]              = TRANSFER_PLAIN,
    ["spell_item_pet_RDA_250_minus_armor"]               = TRANSFER_PLAIN,
    ["spell_item_pet_RDA_250_no_phys_spell_bonus"]       = TRANSFER_PLAIN,
    ["spell_item_pet_RDA_250_no_spell_phys_bonus"]       = TRANSFER_PLAIN,
    ["spell_item_pet_RDA_250_phys_dmg_reducrion"]        = TRANSFER_PLAIN,
    ["spell_item_pet_RDA_250_pure_damage"]               = TRANSFER_PLAIN,
    ["spell_item_pet_RDA_250_regen"]                     = TRANSFER_PLAIN,
    ["spell_pet_ability"]                                = TRANSFER_PLAIN,
    ["spell_item_pet_RDA_agi"]                           = TRANSFER_PLAIN,
    ["spell_item_pet_RDA_all_dmg_amp"]                   = TRANSFER_PLAIN,
    ["spell_item_pet_RDA_block"]                         = TRANSFER_PLAIN,
    ["spell_item_pet_RDA_cleave"]                        = TRANSFER_PLAIN,
    ["spell_item_pet_RDA_dmg"]                           = TRANSFER_PLAIN,
    ["spell_item_pet_RDA_fast"]                          = TRANSFER_PLAIN,
    ["spell_item_pet_RDA_gold"]                          = TRANSFER_PLAIN,
    ["spell_item_pet_RDA_heal"]                          = TRANSFER_PLAIN,
    ["spell_item_pet_RDA_hp"]                            = TRANSFER_PLAIN,
    ["spell_item_pet_RDA_int"]                           = TRANSFER_PLAIN,
    ["spell_item_pet_RDA_mana_regen"]                    = TRANSFER_PLAIN,
    ["spell_item_pet_RDA_simple_1"]                      = TRANSFER_PLAIN,
    ["spell_item_pet_RDA_simple_2"]                      = TRANSFER_PLAIN,
    ["spell_item_pet_RDA_simple_3"]                      = TRANSFER_PLAIN,

	["hp_per_level"]	= 	TRANSFER_PLAIN,
	["hp_regen_level"]	= 	TRANSFER_PLAIN,
	["status"]	= 	TRANSFER_PLAIN,
	["armor_per_level"]	= 	TRANSFER_PLAIN,
	-- ["Increase_str"]	= 	TRANSFER_PLAIN,
	["movespeed"]	= 	TRANSFER_PLAIN,
	["dmg_per_level"]	= 	TRANSFER_PLAIN,
	["all_evasion"]	= 	TRANSFER_PLAIN,
	["base_attack_time"]	= 	TRANSFER_PLAIN,
	-- ["Increase_agi"]	= 	TRANSFER_PLAIN,
	["mp_per_level"]	= 	TRANSFER_PLAIN,
	["mp_regen_level"]	= 	TRANSFER_PLAIN,
	["m_resist"]	= 	TRANSFER_PLAIN,
	["magic_damage"]	= 	TRANSFER_PLAIN,
	-- ["Increase_int"]	= 	TRANSFER_PLAIN,

	["npc_dota_hero_vengefulspirit_str6"]	= 	TRANSFER_PLAIN,
	["npc_dota_hero_vengefulspirit_str8"]	= 	TRANSFER_PLAIN,
	["npc_dota_hero_vengefulspirit_str9"]	= 	TRANSFER_PLAIN,
	["npc_dota_hero_vengefulspirit_str10"]	= 	TRANSFER_PLAIN,
	["npc_dota_hero_vengefulspirit_str11"]	= 	TRANSFER_PLAIN,
	["npc_dota_hero_vengefulspirit_str_last"]	= 	TRANSFER_PLAIN,
	["npc_dota_hero_vengefulspirit_int6"]	= 	TRANSFER_PLAIN,
	["npc_dota_hero_vengefulspirit_int8"]	= 	TRANSFER_PLAIN,
	["npc_dota_hero_vengefulspirit_int9"]	= 	TRANSFER_PLAIN,
	["npc_dota_hero_vengefulspirit_int10"]	= 	TRANSFER_PLAIN,
	["npc_dota_hero_vengefulspirit_int11"]	= 	TRANSFER_PLAIN,
	["npc_dota_hero_vengefulspirit_int_last"]	= 	TRANSFER_PLAIN,
	["npc_dota_hero_vengefulspirit_agi6"]	= 	TRANSFER_PLAIN,
	["npc_dota_hero_vengefulspirit_agi8"]	= 	TRANSFER_PLAIN,
	["npc_dota_hero_vengefulspirit_agi9"]	= 	TRANSFER_PLAIN,
	["npc_dota_hero_vengefulspirit_agi10"]	= 	TRANSFER_PLAIN,
	["npc_dota_hero_vengefulspirit_agi11"]	= 	TRANSFER_PLAIN,
	["npc_dota_hero_vengefulspirit_agi_last"]	= 	TRANSFER_PLAIN,
}

vengeful_tempest_double.transferable_modifiers = {
	["modifier_don1"]				=	TRANSFER_PLAIN,
	["modifier_don2"]				=	TRANSFER_PLAIN,
	["modifier_don3"]				=	TRANSFER_PLAIN,
	["modifier_don4"]				=	TRANSFER_PLAIN,
	["modifier_don5"]				=	TRANSFER_PLAIN,
	["modifier_don6"]				=	TRANSFER_PLAIN,
	["modifier_don7"]				=	TRANSFER_PLAIN,
	["modifier_don8"]				=	TRANSFER_PLAIN,
	["modifier_don9"]				=	TRANSFER_PLAIN,
	["modifier_don10"]				=	TRANSFER_PLAIN,
	["modifier_don11"]				=	TRANSFER_PLAIN,
	["modifier_don_last"]				=	TRANSFER_PLAIN,
	["modifier_Increase_str"]		=	TRANSFER_FULL,
	["modifier_Increase_agi"]		=	TRANSFER_FULL,
	["modifier_Increase_int"]		=	TRANSFER_FULL,

	-- ["modifier_item_moon_shard_consumed"] 		= TRANSFER_PLAIN,
	-- ["modifier_item_ultimate_scepter_consumed"] = TRANSFER_PLAIN,
	-- ['modifier_channel_listener']				= TRANSFER_PLAIN,
	-- ['modifier_hero_refreshing']				= TRANSFER_PLAIN,
	-- ["modifier_item_aghanims_shard"] 			= TRANSFER_PLAIN,
	-- ["custom_modifier_book_stat_strength"] 		= TRANSFER_FULL,
	-- ["custom_modifier_book_stat_intelligence"] 	= TRANSFER_FULL,
	-- ["custom_modifier_book_stat_agility"] 		= TRANSFER_FULL,
	-- ["modifier_tiny_grab_lua"] 					= TRANSFER_FULL,
	-- ["modifier_loser_curse"]					= TRANSFER_FULL,
}


function vengeful_tempest_double:TransferModifiers(caster, clone)
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

function vengeful_tempest_double:TransferAbility(caster, clone)
	for name, transfer_type in pairs(self.transferable_ability) do
		local caster_ability = caster:FindAbilityByName(name)
		if caster_ability and caster_ability:GetLevel() > 0 then
			local clone_ability = clone:AddAbility(name):SetLevel(caster_ability:GetLevel())
		end
	end
end


function vengeful_tempest_double:GetHeroClone()
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

	-- if self.clone:FindAbilityByName("vengeful_tempest_double") then 
	-- 	self.clone:RemoveAbility("vengeful_tempest_double")
	-- end
	clone_magic_missile = self.clone:FindAbilityByName("vengeful_spirit_magic_missile")
	caster_magic_missile = caster:FindAbilityByName("vengeful_spirit_magic_missile")
	if clone_magic_missile then
		clone_magic_missile:SetLevel(caster_magic_missile:GetLevel())
	end
	clone_wave_of_terror = self.clone:FindAbilityByName("vengeful_spirit_wave_of_terror")
	caster_wave_of_terror = caster:FindAbilityByName("vengeful_spirit_wave_of_terror")
	if clone_wave_of_terror then
		clone_wave_of_terror:SetLevel(caster_wave_of_terror:GetLevel())
	end
	clone_command_aura = self.clone:FindAbilityByName("vengeful_spirit_command_aura")
	caster_command_aura = caster:FindAbilityByName("vengeful_spirit_command_aura")
	if clone_command_aura then
		clone_command_aura:SetLevel(caster_command_aura:GetLevel())
	end

	for index = DOTA_ITEM_SLOT_1 , DOTA_ITEM_SLOT_9 do
		local caster_item = caster:GetItemInSlot(index)
		local clone_item = self.clone:GetItemInSlot(index)
		if clone_item then
			self.clone:RemoveItem(clone_item)
		end
		if caster_item and not caster_item:IsNull() then
			-- local clonable = caster_item:GetKeyValue("IsTempestDoubleClonable") ~= 0
			-- if clonable then
			-- 	self.clone:AddItemByName(caster_item:GetAbilityName())
			-- end
            self.clone:AddItemByName(caster_item:GetAbilityName())
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

	-- Illusions:HandleSuperIllusion(self.clone, caster)

	self:TransferModifiers(caster, self.clone)
	self:TransferAbility(caster, self.clone)
    
	return self.clone
end


function vengeful_tempest_double:OnUpgrade()
	if not IsServer() then return end
	local clone = self:GetHeroClone()
	clone:ForceKill(false)
	clone:AddEffects(EF_NODRAW)
	clone:SetAbsOrigin(Vector(-8000, -8000, -8000))
end

function vengeful_tempest_double:GetCooldown(level)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_vengefulspirit_agi9") then
		return self.BaseClass.GetCooldown( self, level ) - 10
	end
	return self.BaseClass.GetCooldown( self, level )
end


function vengeful_tempest_double:OnSpellStart()
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

	-- Duration dependent on having the corresponding talent levelled
	local duration = self:GetSpecialValueFor("duration")

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

	if caster:FindAbilityByName("npc_dota_hero_vengefulspirit_str_last") then
		caster:AddNewModifier(caster, self, "modifier_vengeful_tempest_double_str30", {}):SetStackCount( caster:GetMaxHealth() * 5 )
		clone:AddNewModifier(caster, self, "modifier_vengeful_tempest_double_str30", {}):SetStackCount( clone:GetMaxHealth() * 5 )
	end
	if caster:FindAbilityByName("npc_dota_hero_vengefulspirit_str11") then
		caster:AddNewModifier(caster, self, "modifier_npc_dota_hero_vengefulspirit_str11", {clone = clone:entindex()})
		clone:AddNewModifier(caster, self, "modifier_npc_dota_hero_vengefulspirit_str11", {clone = clone:entindex()})
	end
end
