item_comeback_gift = class({})
item_random_gift = item_comeback_gift

function item_comeback_gift:OnSpellStart()
	local caster = self:GetCaster()

	if caster and caster.GetPlayerID then
		RoundManager:GiveGoldToPlayer(caster:GetPlayerID(), self:GetSpecialValueFor("gold"), nil, ROUND_MANAGER_GOLD_SOURCE_GIFTS)

		self:SpendCharge()
	end
end
