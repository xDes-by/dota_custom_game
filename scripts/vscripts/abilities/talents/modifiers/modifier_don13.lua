modifier_don13 = class({})

function modifier_don13:IsHidden()
	return false
end

function modifier_don13:IsPurgable()
	return false
end

function modifier_don13:RemoveOnDeath()
	return false
end

function modifier_don13:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
end

function modifier_don13:GetTexture()
    return 'don13'
end

function modifier_don13:OnCreated()
    if IsServer() then
        self.stats = 0
        if diff_wave.wavedef == 'Ultra' then
            self.stats = 100
        end
        if diff_wave.wavedef == 'Insane' then
            self.stats = 200
        end
        if diff_wave.wavedef == 'Impossible' then
            self.stats = 300
        end
    end
    self:SetStackCount(0)
end
function modifier_don13:OnRefresh()
    self:SetStackCount(0)
end

function modifier_don13:GetModifierBonusStats_Strength()
	return self.stats
end

function modifier_don13:GetModifierBonusStats_Agility()
	return self.stats
end

function modifier_don13:GetModifierBonusStats_Intellect()
	return self.stats
end

function modifier_don13:GetModifierTotalDamageOutgoing_Percentage()
	return 100 + self:GetCaster():GetLevel() * 0.6
end

function modifier_don13:GetModifierIncomingDamage_Percentage()
	return self:GetCaster():GetLevel() * -0.05
end