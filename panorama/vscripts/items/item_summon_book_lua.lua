item_summon_book_lua = class({})


function item_summon_book_lua:IsRefreshable()
	return false
end


function item_summon_book_lua:OnSpellStart()
	if not IsServer() then return end

	local caster = self:GetCaster()
	if not caster or caster:IsNull() then return end
	if not caster:IsMainHero() or caster:HasModifier("modifier_morphling_replicate") then return end

	local caster_entidx = caster:GetEntityIndex()

	local player = caster:GetPlayerOwner()
	if not player or player:IsNull() then return end
	-- Do nothing if there are pending ability swaps for this hero
	if SwapAbilities:IsPendingAbilitySwap(caster) then return end

	if not caster.state or caster.state ~= HERO_STATE_DEFAULT then print("wrong state", caster.state) return end
	if not caster.abilities or #caster.abilities == 0 then print("no abilities") return end
 
	caster.state = HERO_STATE_REMOVING_ABILITY_FOR_SUMMON

	CustomGameEventManager:Send_ServerToPlayer(player, "ability_selection:summon_relearn", {
		abilities = HeroBuilder:GetSortedAbilityList(caster),
	})

	SwapAbilities:SendAbilitySelectionState(player, caster, true)
	caster.summoner_scrolls_used_count = caster.summoner_scrolls_used_count and caster.summoner_scrolls_used_count + 1 or 1
	caster:EmitSound("Item.TomeOfKnowledge")
	self:StartCooldown(10)
	self:SpendCharge()
end

