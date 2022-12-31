innate_winner = class({})

LinkLuaModifier("modifier_innate_winner", "heroes/innates/winner", LUA_MODIFIER_MOTION_NONE)

function innate_winner:GetIntrinsicModifierName()
	return "modifier_innate_winner"
end



modifier_innate_winner = class({})

function modifier_innate_winner:IsHidden() return false end
function modifier_innate_winner:IsDebuff() return false end
function modifier_innate_winner:IsPurgable() return false end
function modifier_innate_winner:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_winner:OnCreated(keys)
	if IsServer() then
		local player_id = self:GetParent():GetPlayerOwnerID()
		local duel_wins = 0
		if player_id then
			local pvp_record = CustomNetTables:GetTableValue("pvp_record", tostring(player_id))
			if pvp_record and pvp_record.win then
				duel_wins = pvp_record.win
			end
		end
		self:SetStackCount(duel_wins)
	end

	self:OnRefresh(keys)
end

function modifier_innate_winner:OnRefresh(keys)
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_innate_winner:OnPvpEndedForDuelists(keys)
	if IsServer() and keys.winner_team == self:GetParent():GetTeam() then
		self:IncrementStackCount()
	end
end

function modifier_innate_winner:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	}
end

function modifier_innate_winner:GetModifierTotalDamageOutgoing_Percentage()
	return self:GetStackCount() * (self.bonus_damage or 0)
end
