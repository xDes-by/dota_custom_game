builder_tower_repair = class({})
LinkLuaModifier( "modifier_builder_tower_repair", "heroes/hero_builder/builder_tower_repair/modifier_builder_tower_repair", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_builder_tower_aura", "heroes/hero_builder/builder_tower_repair/builder_tower_repair", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_builder_tower_aura_effect", "heroes/hero_builder/builder_tower_repair/builder_tower_repair", LUA_MODIFIER_MOTION_NONE )

function builder_tower_repair:GetIntrinsicModifierName()
	return "modifier_builder_tower_aura"
end

builder_tower_repair.modifiers = {}

function builder_tower_repair:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local duration = self:GetChannelTime()
	
	local target_name = target:GetUnitName()
	
	local owner = target:GetOwner()
	if owner == caster then
	end
	if target:IsBuilding() then
		local modifier = target:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_builder_tower_repair", -- modifier name
			{ duration = duration } -- kv
		)
		self.modifiers[modifier] = true

		-- play effects
		self.sound_cast = "DOTA_Item.RepairKit.Target"
		EmitSoundOn( self.sound_cast, caster )
	elseif target:IsCreep() and owner == caster then 
		local modifier = target:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_builder_tower_repair", -- modifier name
			{ duration = duration } -- kv
		)
		self.modifiers[modifier] = true

		self.sound_cast = "DOTA_Item.RepairKit.Target"
		EmitSoundOn( self.sound_cast, caster )
	else caster:Interrupt() return end	
end

function builder_tower_repair:OnChannelFinish( bInterrupted )
	-- destroy all modifier
	for modifier,_ in pairs(self.modifiers) do
		if not modifier:IsNull() then
			modifier.forceDestroy = bInterrupted
			modifier:Destroy()
		end
	end
	self.modifiers = {}

	-- end sound
	StopSoundOn( self.sound_cast, self:GetCaster() )
end

function builder_tower_repair:Unregister( modifier )
	-- unregister modifier
	self.modifiers[modifier] = nil

	-- check if there are no modifier left
	local counter = 0
	for modifier,_ in pairs(self.modifiers) do
		if not modifier:IsNull() then
			counter = counter+1
		end
	end

	-- stop channelling if no other target exist
	if counter==0 and self:IsChanneling() then
		self:EndChannel( false )
	end
end

---------------------------------------------------------------

modifier_builder_tower_aura = class({})

function modifier_builder_tower_aura:IsHidden()
	return true
end

function modifier_builder_tower_aura:IsPurgable()
	return false
end

function modifier_builder_tower_aura:IsAura()
	return true
end
function modifier_builder_tower_aura:GetModifierAura()
	return "modifier_builder_tower_aura_effect"
end

function modifier_builder_tower_aura:GetAuraRadius()
	return 800
end

function modifier_builder_tower_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_builder_tower_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC
end

----------------------------------------------------------------------

modifier_builder_tower_aura_effect = class({})

function modifier_builder_tower_aura_effect:IsHidden()
	return true
end

function modifier_builder_tower_aura_effect:IsDebuff()
	return true
end

function modifier_builder_tower_aura_effect:IsPurgable()
	return false
end

function modifier_builder_tower_aura_effect:OnCreated()
	self.aura = false
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_tinker_str_last")
	if abil ~= nil and (self:GetParent():GetUnitName() == "npc_turret" or self:GetParent():GetUnitName() == "npc_wall") then 
		self.aura = true
	end	
end

function modifier_builder_tower_aura_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
	}
	return funcs
end

function modifier_builder_tower_aura_effect:GetModifierBaseDamageOutgoing_Percentage(  )
	if self.aura == true then
		return 50
	end
	return 0
end

function modifier_builder_tower_aura_effect:GetModifierPhysicalArmorBonus( params )
	if self.aura == true then
		return self:GetParent():GetPhysicalArmorBaseValue()*0.5
	end
	return 0
end

function modifier_builder_tower_aura_effect:GetModifierHealthRegenPercentage()
	if self.aura == true then
		return 1
	end
	return 0
end