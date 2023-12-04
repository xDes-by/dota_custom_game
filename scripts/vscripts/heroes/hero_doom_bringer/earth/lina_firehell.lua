LinkLuaModifier( "modifier_lina_firehell_lua", "heroes/hero_doom_bringer/earth/modifier_lina_firehell_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_firehell_intrinsic_lua", "heroes/hero_doom_bringer/earth/modifier_lina_firehell_intrinsic_lua", LUA_MODIFIER_MOTION_NONE )
lina_firehell = class({})

function lina_firehell:GetIntrinsicModifierName()
	return "modifier_lina_firehell_intrinsic_lua"
end
function lina_firehell:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end
function lina_firehell:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	caster:AddNewModifier(caster, self, "modifier_lina_firehell_lua", {duration = self:GetSpecialValueFor("duration")})
end

function lina_firehell:GetBehavior()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_doom_bringer_int7") then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_TOGGLE
	end
end
function lina_firehell:GetCooldown()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_doom_bringer_int7") then
		return 0
	end
end

function lina_firehell:OnToggle(  )
	local caster = self:GetCaster()

	-- load data
	local toggle = self:GetToggleState()

	if toggle then
		self.modifier = caster:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_lina_firehell_lua", -- modifier name
			{  } -- kv
		)
	else
		if self.modifier and not self.modifier:IsNull() then
			self.modifier:Destroy()
		end
		self.modifier = nil
	end
end