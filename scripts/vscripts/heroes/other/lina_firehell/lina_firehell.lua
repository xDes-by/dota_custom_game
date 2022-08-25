LinkLuaModifier( "modifier_lina_firehell_lua", "heroes/hero_lina/lina_firehell/modifier_lina_firehell_lua", LUA_MODIFIER_MOTION_NONE )
lina_firehell = class({})
function lina_firehell:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
end

function lina_firehell:OnToggle(  )
	-- unit identifier
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