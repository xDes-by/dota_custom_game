modifier_gem2 = class ({})

function modifier_gem2:GetTexture()
	return "gem_icon/spell"
end

function modifier_gem2:IsHidden()
	return true
end

function modifier_gem2:RemoveOnDeath()
	return false
end

function modifier_gem2:OnCreated(data)
	self.parent = self:GetParent()
	self.lvlup = {10, 20, 40, 80, 160, 320, 640, 1280}
	if not IsServer() then
		return
	end
	self:SetHasCustomTransmitterData( true )
	self:StartIntervalThink(1)
end

function modifier_gem2:OnIntervalThink()
	self.stacks = 0 
	for i=0,5 do
		local item = self.parent:GetItemInSlot(i)
		if item then
			self.stacks = self.stacks + self.lvlup[item:GetLevel()]
		end
	end
	self:SendBuffRefreshToClients()
end

function modifier_gem2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
	}
end

function modifier_gem2:GetModifierSpellAmplify_Percentage()
	return self.stacks
end

function modifier_gem2:AddCustomTransmitterData()
	return {
		stacks = self.stacks,
	}
end

function modifier_gem2:HandleCustomTransmitterData( data )
	self.stacks = data.stacks
end
