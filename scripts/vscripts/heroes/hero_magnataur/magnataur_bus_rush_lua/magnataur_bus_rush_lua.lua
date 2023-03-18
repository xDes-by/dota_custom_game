--------------------------------------------------------------------------------
magnataur_bus_rush_lua = class({})
LinkLuaModifier( "modifier_generic_knockback_lua", "heroes/generic/modifier_generic_knockback_lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_bus_rush_unit_lua", "heroes/hero_magnataur/magnataur_bus_rush_lua/modifier_bus_rush_unit_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_talent_int6", "heroes/hero_magnataur/magnataur_bus_rush_lua/modifier_talent_int6", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_talent_str10", "heroes/hero_magnataur/magnataur_bus_rush_lua/modifier_talent_str10", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_stunned_lua", "heroes/generic/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )

function magnataur_bus_rush_lua:Precache( context )
	PrecacheResource( "soundfile", "soundevents/bus_rush_sound.vsndevts", context )
end

--------------------------------------------------------------------------------
-- Ability Phase Start
function magnataur_bus_rush_lua:OnAbilityPhaseStart()
	-- Vector targeting
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_taunt_magnus", {})
	if not self:CheckVectorTargetPosition() then return false end
	return true -- if success
end

function magnataur_bus_rush_lua:OnAbilityPhaseInterrupted()
	local taunt = self:GetCaster():FindModifierByName("modifier_taunt_magnus")
	if taunt then
		taunt:Destroy()
	end
end
--------------------------------------------------------------------------------
-- Ability Start
function magnataur_bus_rush_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local targets = self:GetVectorTargetPosition()
	-- load data
	local direction = targets.direction
	local maxrange = self:GetSpecialValueFor( "range" )
	
	local center = (targets.init_pos + targets.end_pos) / 2
	local cast_start = center + direction * (maxrange / -2)
	local cast_end = center + direction * (maxrange / 2)
	local unit = CreateUnitByName("npc_magnataur_bus_rush_lua", cast_start, true, nil, nil, DOTA_TEAM_GOODGUYS)
	unit:SetForwardVector(direction)
	Timers:CreateTimer(0.1, function()
		unit:AddNewModifier(
			self:GetCaster(), -- player source
			self, -- ability source
			"modifier_bus_rush_unit_lua", -- modifier name
			{
				magic_damage_amplification = caster:GetSpellAmplification(false) * 100
			} -- kv
		)
		local ability = unit:FindAbilityByName("magnataur_skewer_lua")
		ability:SetLevel(self:GetLevel())
		local order = {
			UnitIndex = unit:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			TargetIndex = nil,
			AbilityIndex = ability:entindex(),
			Position = cast_end,
			Queue = 0
			}
		
		-- Отдаем команду юниту
		ExecuteOrderFromTable(order)
		local str10 = self:GetCaster():FindAbilityByName("npc_dota_hero_magnataur_str10")
		if str10 ~= nil then
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_talent_str10", {
				duration = str10:GetSpecialValueFor("duration"),
				armor_per_level = str10:GetSpecialValueFor("armor_per_level"),
			})
		end
	end)
	EmitSoundOn( "bus_rush_sound", caster )
    -- caster:StartGesture(ACT_DOTA_TAUNT)
end


LinkLuaModifier( "modifier_taunt_magnus", "heroes/hero_magnataur/magnataur_bus_rush_lua/magnataur_bus_rush_lua", LUA_MODIFIER_MOTION_NONE )
--Modifiers
if modifier_taunt_magnus == nil then
	modifier_taunt_magnus = class({}, nil, ModifierPositiveBuff)
end
function modifier_taunt_magnus:IsHidden()
	return true
end
function modifier_taunt_magnus:OnDestroy()
	if IsServer() then
		self:GetParent():FadeGesture(ACT_DOTA_TAUNT)
	end
end
function modifier_taunt_magnus:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
	}
end
function modifier_taunt_magnus:GetOverrideAnimation()
	return ACT_DOTA_TAUNT
end
function modifier_taunt_magnus:GetActivityTranslationModifiers()
	return "mag_power_gesture"
end
function modifier_taunt_magnus:CheckState()
	return {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_DISARMED] = true
	}
end