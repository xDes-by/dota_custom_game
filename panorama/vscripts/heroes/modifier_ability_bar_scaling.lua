modifier_ability_bar_scaling = class({})

function modifier_ability_bar_scaling:IsHidden() return true end
function modifier_ability_bar_scaling:IsPurgable() return false end
function modifier_ability_bar_scaling:IsPurgeException() return false end
function modifier_ability_bar_scaling:DestroyOnExpire() return false end
function modifier_ability_bar_scaling:GetPriority() return MODIFIER_PRIORITY_SUPER_ULTRA end

function modifier_ability_bar_scaling:OnCreated(keys)
	self:SetHasCustomTransmitterData( true )
	if not IsServer() then return end
	-- print("passed ability count: ", keys.count)
	self.count = keys.count
	self:SendBuffRefreshToClients()
end


function modifier_ability_bar_scaling:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ABILITY_LAYOUT,
	}
end


function modifier_ability_bar_scaling:GetModifierAbilityLayout()
	return self.count
end


function modifier_ability_bar_scaling:AddCustomTransmitterData( )
	return
	{
		count = self.count,
	}
end

function modifier_ability_bar_scaling:HandleCustomTransmitterData( data )
	self.count = data.count
end
