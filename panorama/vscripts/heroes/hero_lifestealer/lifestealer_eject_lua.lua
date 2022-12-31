lifestealer_eject_lua = class({})

function lifestealer_eject_lua:OnSpellStart()
	if not IsServer() then return end

	local caster = self:GetCaster()
	if not caster or caster:IsNull() then return end
	local mod = caster:FindModifierByName("modifier_lifestealer_infest_caster")
	if mod then
		mod:Destroy()
	end
end
