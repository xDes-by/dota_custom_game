LinkLuaModifier( "modifier_unselect", "modifiers/modifier_unselect", LUA_MODIFIER_MOTION_NONE )
item_tree_gold = class({})
--------------------------------------------------------------------------------
function item_tree_gold:OnSpellStart()
	self.caster = self:GetCaster()
	local trees = FindUnitsInRadius( self.caster:GetTeamNumber(), self.caster:GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false )
		for _, tree in pairs( trees ) do
			if tree ~= nil and tree:GetUnitName() == "gold_tree" and tree:GetOwner() == self.caster then 
			return
		end
	end
	
	vTargetPosition = self:GetCursorPosition()
	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_furion/furion_sprout.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( nFXIndex, 0, vTargetPosition )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 0.0, r, 0.0 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )		
	
	
	local unit = CreateUnitByName("gold_tree", vTargetPosition, true, nil, nil, DOTA_TEAM_GOODGUYS)
	unit:SetOwner(self.caster)
	unit:AddNewModifier( unit, nil, "modifier_invulnerable", { } )
	unit:AddNewModifier( unit, nil, "modifier_no_healthbar", { } )
	unit:AddNewModifier( unit, nil, "modifier_unselect", { } )
	
	EmitSoundOnLocationWithCaster( vTargetPosition, "Hero_Furion.Sprout", self:GetCaster() )
	
	self.caster:RemoveItem(self)
end

function aaaa(keys)
local unit = keys.caster
spawnPoint = unit:GetAbsOrigin()	
local newItem = CreateItem( "item_bag_of_gold_big", nil, nil )
local drop = CreateItemOnPositionForLaunch( spawnPoint + RandomVector( RandomFloat( 200, 200 )), newItem )
	if 60 then
		newItem:SetContextThink( "KillLoot", function() return KillLoot( newItem, drop ) end, 60 )
	end
end

function KillLoot( item, drop )
	if drop:IsNull() then
		return
	end
	local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/veil_of_discord.vpcf", PATTACH_CUSTOMORIGIN, drop )
	ParticleManager:SetParticleControl( nFXIndex, 0, drop:GetOrigin() )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 35, 35, 25 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
	UTIL_Remove( item )
	UTIL_Remove( drop )
end