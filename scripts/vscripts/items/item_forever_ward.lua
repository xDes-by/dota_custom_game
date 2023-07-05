LinkLuaModifier( "modifier_unselect", "modifiers/modifier_unselect", LUA_MODIFIER_MOTION_NONE )

item_forever_ward = class({})

function item_forever_ward:OnSpellStart()
	-- self.caster = self:GetCaster()
	-- local trees = FindUnitsInRadius( self.caster:GetTeamNumber(), self.caster:GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false )
	-- 	for _, tree in pairs( trees ) do
	-- 		if tree ~= nil and tree:GetUnitName() == "forever_ward" and tree:GetOwner() == self.caster then
	-- 			return
	-- 		end
	-- 	end
		
	vTargetPosition = self:GetCursorPosition()
	
	local unit = CreateUnitByName("forever_ward", vTargetPosition, true, nil, nil, DOTA_TEAM_GOODGUYS)
	unit:SetOwner(self:GetCaster())
	unit:AddNewModifier( unit, nil, "modifier_invulnerable", { } )
	unit:AddNewModifier( unit, nil, "modifier_no_healthbar", { } )
	unit:AddNewModifier( unit, nil, "modifier_unselect", { } )
	
	EmitSoundOnLocationWithCaster( vTargetPosition, "DOTA_Item.ObserverWard.Activate", self:GetCaster() )
	
	if self:GetCurrentCharges() > 1 then
		self:SetCurrentCharges( self:GetCurrentCharges() -1 )
	else
		self:GetCaster():RemoveItem(self)
	end
end