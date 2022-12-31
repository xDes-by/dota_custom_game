item_mastery_book = class({})

function item_mastery_book:OnSpellStart()
	if IsClient() then return end
	local caster = self:GetCaster()
	local playerId = caster:GetPlayerOwnerID()

	if TestMode:IsTestMode() then
		DisplayError(playerId,'dota_hud_error_not_available_in_demo')
		return;
	end
	
	local mastery_items_table = WearFunc[CHC_ITEM_TYPE_MASTERIES]
	
	if mastery_items_table and mastery_items_table[playerId] and #mastery_items_table[playerId] > 0 then
		caster:EmitSound("Item.TomeOfKnowledge")
		self:SpendCharge()
		WearFunc:TakeOffItemInCategory(playerId, CHC_ITEM_TYPE_MASTERIES)

		-- visual effects
		CustomGameEventManager:Send_ServerToAllClients("player_use_book", { playerId = playerId, bookType = "upgrade"})
		
		local particle = ParticleManager:CreateParticle("particles/custom/use_book.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster);
		ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true);
		ParticleManager:SetParticleControl(particle, 1, Vector(70, 236, 233))
		ParticleManager:SetParticleControl(particle, 2, Vector(30, 0, -30))
		ParticleManager:SetParticleControl(particle, 3, Vector(70, 236, 233))
		ParticleManager:SetParticleControl(particle, 4, Vector(20, 0, -25))
		ParticleManager:SetParticleControl(particle, 5, Vector(75, 15, 300))
		ParticleManager:ReleaseParticleIndex(particle)
	else
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerId), "display_custom_error", { message = "#mastery_not_equipped" })
	end
end
