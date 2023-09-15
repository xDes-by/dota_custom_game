--------------------------------------------------------------------------------
magnataur_bus_rush_lua = class({})
LinkLuaModifier( "modifier_generic_knockback_lua", "heroes/generic/modifier_generic_knockback_lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_bus_rush_unit_lua", "heroes/hero_magnataur/magnataur_bus_rush_lua/modifier_bus_rush_unit_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_magnataur_talent_int6", "heroes/hero_magnataur/magnataur_bus_rush_lua/modifier_magnataur_talent_int6", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_magnataur_talent_str6", "heroes/hero_magnataur/magnataur_bus_rush_lua/modifier_magnataur_talent_str6", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_magnataur_talent_str10", "heroes/hero_magnataur/magnataur_bus_rush_lua/modifier_magnataur_talent_str10", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_stunned_lua", "heroes/generic/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )


function magnataur_bus_rush_lua:Precache( context )
	PrecacheResource( "soundfile", "soundevents/bus_rush_sound.vsndevts", context )
end

--------------------------------------------------------------------------------
-- Ability Phase Start
function magnataur_bus_rush_lua:OnAbilityPhaseStart()
	-- Vector targeting
	if not self:CheckVectorTargetPosition() then return false end
	StartAnimation(self:GetCaster(), {duration=2.0, activity=ACT_DOTA_TAUNT, rate=0.8, translate="mag_power_gesture"})
	return true -- if success
end

function magnataur_bus_rush_lua:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
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
		local str10 = caster:FindAbilityByName("npc_dota_hero_magnataur_str10")
		if str10 ~= nil then
			caster:AddNewModifier(caster, self, "modifier_magnataur_talent_str10", {
				duration = 7,
				armor_per_level = 2,
			})
		end
		local str6 = caster:FindAbilityByName("npc_dota_hero_magnataur_str6")
		if str6 ~= nil then
			caster:AddNewModifier(caster, self, "modifier_magnataur_talent_str6", { duration = 5 })
		end
	end)
	EmitSoundOn( "bus_rush_sound", caster )
end