modifier_don3 = class({})

function modifier_don3:IsHidden()
	return true
end

function modifier_don3:IsPurgable()
	return false
end

function modifier_don3:RemoveOnDeath()
	return false
end

function modifier_don3:OnCreated( kv )
	if not IsServer() then return end
	souls =  {"item_forest_soul","item_village_soul","item_mines_soul","item_dust_soul","item_swamp_soul","item_snow_soul"}
name_soul = souls[RandomInt(1,#souls)]
self:GetCaster():AddItemByName(name_soul)
end

function modifier_don3:OnRefresh( kv )
end