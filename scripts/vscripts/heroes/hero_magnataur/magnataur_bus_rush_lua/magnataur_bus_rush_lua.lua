-- magnataur_bus_rush_lua = class({})
LinkLuaModifier( "modifier_magnataur_bus_rush_lua", "heroes/hero_magnataur/magnataur_bus_rush_lua/modifier_magnataur_bus_rush_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
magnataur_bus_rush_lua = class({})
LinkLuaModifier( "modifier_generic_knockback_lua", "heroes/generic/modifier_generic_knockback_lua", LUA_MODIFIER_MOTION_BOTH )

function magnataur_bus_rush_lua:Precache( context )
	PrecacheResource( "soundfile", "soundevents/bus_rush_sound.vsndevts", context )
end

--------------------------------------------------------------------------------
-- Ability Phase Start
function magnataur_bus_rush_lua:OnAbilityPhaseStart()
	-- Vector targeting
	if not self:CheckVectorTargetPosition() then return false end
	return true -- if success
end

--------------------------------------------------------------------------------
-- Ability Start
function magnataur_bus_rush_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local targets = self:GetVectorTargetPosition()
	-- load data
	local direction = targets.direction
	local this_ability = self
	local maxrange = self:GetSpecialValueFor( "range" )
	
	local center = (targets.init_pos + targets.end_pos) / 2
	local cast_start = center + direction * (maxrange / -2)
	local cast_end = center + direction * (maxrange / 2)
	self.unit = CreateUnitByName("npc_magnataur_bus_rush_lua", cast_start, true, nil, nil, DOTA_TEAM_GOODGUYS)
	self.unit:SetForwardVector(direction)
	Timers:CreateTimer(0.1, function()
		local ability = self.unit:FindAbilityByName("magnataur_skewer_lua")
		local order = {
			UnitIndex = self.unit:entindex(),
			-- UnitIndex = unit:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			TargetIndex = nil,
			AbilityIndex = ability:entindex(),
			Position = cast_end,
			Queue = 0
			}
		
		-- Отдаем команду юниту
		ExecuteOrderFromTable(order)
		caster:AddNewModifier(
			caster, -- player source
			this_ability, -- ability source
			"modifier_magnataur_bus_rush_lua", -- modifier name
			{
				iStackCount = 1
			} -- kv
		)
	end)
	EmitSoundOn( "bus_rush_sound", caster )
end