item_mastery_scroll = class({})

function item_mastery_scroll:OnSpellStart()
	local caster = self:GetCaster()
	local playerId = caster:GetPlayerOwnerID()
	local oldMasteriesCount = BP_Masteries.players_masteries_count[playerId]
	if oldMasteriesCount >= MAX_MASTERIES then
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerId), "display_custom_error", { message = "#masteries_max_count" })
	else
		caster:EmitSound("Item.TomeOfKnowledge")
		self:SpendCharge()
		BP_Masteries:ChangeMaxCount(playerId, 1)
		
		-- visual effects
		CustomGameEventManager:Send_ServerToAllClients("player_use_book", { playerId = playerId, bookType = "mastery"})
		local particle = ParticleManager:CreateParticle("particles/custom/use_book.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster);
		ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true);
		ParticleManager:SetParticleControl(particle, 1, Vector(244, 169, 241))
		ParticleManager:SetParticleControl(particle, 2, Vector(0, 0, -30))
		ParticleManager:SetParticleControl(particle, 3, Vector(163, 135, 250))
		ParticleManager:SetParticleControl(particle, 4, Vector(30, 0, -5))
		ParticleManager:SetParticleControl(particle, 5, Vector(75, 15, 300))
		ParticleManager:ReleaseParticleIndex(particle)

		caster.mastery_scroll_used_count = (caster.mastery_scroll_used_count or 0) + 1
	end
end
