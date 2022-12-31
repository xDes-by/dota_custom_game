item_relearn_book_lua = class({})

LinkLuaModifier("modifier_item_upgrade_book", "items/item_relearn_book_lua", LUA_MODIFIER_MOTION_NONE)

function item_relearn_book_lua:Spawn()
	self.purchase_time = GameRules:GetGameTime()
end

function item_relearn_book_lua:OnSpellStart()
	if not IsServer() then return end

	local caster = self:GetCaster()
	if not caster or not caster:IsMainHero() or caster:HasModifier("modifier_morphling_replicate") then return end  

	local player =  caster:GetPlayerOwner()
	if not player then return end

	local ability_number = caster.ability_count or 0
	if ability_number < 1 then 
		DisplayError(player:GetPlayerID(),'dota_hud_error_you_not_have_abilities')
		return
	end 
	 		
	--If selecting skills doesn't work
	if not caster.state or caster.state ~= HERO_STATE_DEFAULT then
		DisplayError(player:GetPlayerID(),'dota_hud_error_cant_relearn_when_selection_active')
		return
	end

	if caster.ability_selection_postponed then
		DisplayError(player:GetPlayerID(),'dota_hud_error_cant_relearn_when_selection_active')
		return
	end

	caster.relearn_book_metadata = {
		purchase_time = self.purchase_time,
		original_owner = self:GetPurchaser()
	}

	caster:EmitSound("Item.TomeOfKnowledge")
	self:SpendCharge()

	caster.state = HERO_STATE_REMOVING_ABILITY

	CustomGameEventManager:Send_ServerToPlayer(player, "ShowRelearnBookAbilitySelection", {
		abilities = HeroBuilder:GetSortedAbilityList(caster),
	})

	SwapAbilities:SendAbilitySelectionState(player, caster, true)
	caster.nRelearnedBooksUsed = caster.nRelearnedBooksUsed and caster.nRelearnedBooksUsed + 1 or 1
end

modifier_retraining_count = class({})
function modifier_retraining_count:IsHidden() return true end
function modifier_retraining_count:IsPurgable() return false end
function modifier_retraining_count:IsPurgeException() return false end
function modifier_retraining_count:RemoveOnDeath() return false end


item_upgrade_book = class({})

function item_upgrade_book:OnSpellStart()
	if not IsServer() then return end

	local caster = self:GetCaster()
	if not caster or not caster:IsMainHero() or caster:HasModifier("modifier_morphling_replicate") or (not caster:IsAlive()) then return end  

	local player = caster:GetPlayerOwner()
	if not player then return end

	local player_id = player:GetPlayerID()

	if TestMode:IsTestMode() then 
		DisplayError(player_id, "dota_hud_have_maximum_abilities")
		UTIL_Remove(self)
		return;
	end 

	-- If selecting skills, doesn't work
	if not caster.state or caster.state ~= HERO_STATE_DEFAULT then
		DisplayError(player_id, "dota_hud_error_nondefault_hero_state")
		return
	end
	
	if caster.used_paragon and not PartyMode.infinite_paragon then
		DisplayError(player_id, "dota_hud_error_paragons_exhausted")
		return
	end

	caster:EmitSound("Item.TomeOfKnowledge")
	caster:AddNewModifier(caster, nil, "modifier_item_upgrade_book", {})
	self:SpendCharge()

	HeroBuilder:ShowRandomAbilitySelection(player_id)
	caster.nParagonsBooksUsed = caster.nParagonsBooksUsed and caster.nParagonsBooksUsed + 1 or 1
	caster.used_paragon = true
end


modifier_item_upgrade_book = class({})

function modifier_item_upgrade_book:IsHidden() return true end
function modifier_item_upgrade_book:IsDebuff() return false end
function modifier_item_upgrade_book:IsPurgable() return false end
function modifier_item_upgrade_book:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_item_upgrade_book:GetModifierIncreaseMaxAbilityLimit()
	return 1
end


item_upgrade_book_2 = class({})

function item_upgrade_book_2:OnSpellStart()
	if not IsServer() then return end

	local caster = self:GetCaster()
	if not caster or not caster:IsMainHero() or caster:HasModifier("modifier_morphling_replicate") or (not caster:IsAlive()) then return end  

	local player = caster:GetPlayerOwner()
	if not player then return end

	local player_id = player:GetPlayerID()

	if TestMode:IsTestMode() then 
		DisplayError(player_id, "dota_hud_have_maximum_abilities")
		UTIL_Remove(self)
		return;
	end 

	-- If selecting skills, doesn't work
	if not caster.state or caster.state ~= HERO_STATE_DEFAULT then
		DisplayError(player_id, "dota_hud_error_nondefault_hero_state")
		return
	end

	caster:EmitSound("Item.TomeOfKnowledge")
	caster:AddNewModifier(caster, nil, "modifier_item_upgrade_book", {})
	self:SpendCharge()

	HeroBuilder:ShowRandomAbilitySelection(player_id)
	caster.nParagonsBooksUsed = caster.nParagonsBooksUsed and caster.nParagonsBooksUsed + 1 or 1
end
