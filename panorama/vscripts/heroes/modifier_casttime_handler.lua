modifier_casttime_handler = class({})

function modifier_casttime_handler:IsHidden() return true end
function modifier_casttime_handler:IsPurgable() return false end
function modifier_casttime_handler:IsDebuff() return false end
function modifier_casttime_handler:IsPermanent() return true end

function modifier_casttime_handler:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
	}
	return funcs
end

modifier_casttime_handler.casttime_modifiers = {
	"modifier_item_arcane_blink_buff_lua",
	"modifier_chc_mastery_speed_of_thought_1",
	"modifier_chc_mastery_speed_of_thought_2",
	"modifier_chc_mastery_speed_of_thought_3",
}

function modifier_casttime_handler:GetModifierPercentageCasttime()
	
	if not IsServer() then return end
	local parent = self:GetParent()
	if not parent then return end
	
	local cast_time_total = 0
	for _, modifier_name in pairs(self.casttime_modifiers) do
		local modifier = parent:FindModifierByName(modifier_name)
		if modifier and not modifier:IsNull() then
			local cast_time = modifier:_GetModifierPercentageCasttime()
			if cast_time then
				cast_time_total = cast_time_total + (1 - cast_time_total / 100) * cast_time
			end
		end
	end

	return cast_time_total
end
