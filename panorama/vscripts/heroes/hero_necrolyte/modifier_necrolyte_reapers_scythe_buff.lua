modifier_necrolyte_reapers_scythe_buff_lua = class({})

function modifier_necrolyte_reapers_scythe_buff_lua:IsPurgable() return false end
function modifier_necrolyte_reapers_scythe_buff_lua:RemoveOnDeath() return false end

function modifier_necrolyte_reapers_scythe_buff_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
end

function modifier_necrolyte_reapers_scythe_buff_lua:OnCreated(kv)
	self:SetHasCustomTransmitterData(true)

	if IsClient() then return end

	self.hp_regen = 0
	self.mana_regen = 0

	self:IncrementStackCount()
	self:AddBonusRegen(kv)
end

function modifier_necrolyte_reapers_scythe_buff_lua:OnRefresh(kv)
	if IsClient() then return end

	self:IncrementStackCount()
	self:AddBonusRegen(kv)
end

function modifier_necrolyte_reapers_scythe_buff_lua:AddBonusRegen(kv)
	self.hp_regen = self.hp_regen + kv.hp_regen
	self.mana_regen = self.mana_regen + kv.mana_regen

	self:SendBuffRefreshToClients()
end

function modifier_necrolyte_reapers_scythe_buff_lua:AddCustomTransmitterData()
    return {
        hp_regen = self.hp_regen,
        mana_regen = self.mana_regen,
    }
end

function modifier_necrolyte_reapers_scythe_buff_lua:HandleCustomTransmitterData(kv)
    self.hp_regen = kv.hp_regen
    self.mana_regen = kv.mana_regen
end

function modifier_necrolyte_reapers_scythe_buff_lua:GetModifierConstantHealthRegen()
	return self.hp_regen
end

function modifier_necrolyte_reapers_scythe_buff_lua:GetModifierConstantManaRegen()
	return self.mana_regen
end
