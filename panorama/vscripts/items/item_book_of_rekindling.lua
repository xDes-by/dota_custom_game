item_book_of_rekindling = class({})


function item_book_of_rekindling:OnSpellStart()
	if not IsServer() then return end

	local caster = self:GetCaster()
	local player_id = caster:GetPlayerOwnerID()
	
	if not HeroBuilder:CheckHeroState(caster, HERO_STATE_DEFAULT) then
		DisplayError(player_id, "dota_hud_error_cant_relearn_when_selection_active") 
		return 
	end
	
	local caster_abilities = table.deepcopy(caster.abilities or {})
	for _, ability_name in pairs(caster_abilities) do
		local ability = caster:FindAbilityByName(ability_name)
		if ability and not ability:IsNull() then
			HeroBuilder:RemoveAbility(caster, ability, ability_name, true)
		end
	end

	HeroBuilder:ShowRandomAbilitySelection(player_id, true)
	HeroBuilder:RefreshAbilityOrder(player_id)

	self:SpendCharge()
end
