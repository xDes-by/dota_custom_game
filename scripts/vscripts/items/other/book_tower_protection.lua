LinkLuaModifier( "modifier_item_tower_protection", "items/other/book_tower_protection", LUA_MODIFIER_MOTION_NONE )

item_tower_protection = class({})

function item_tower_protection:OnSpellStart()
	if IsServer() then
		self.caster = self:GetCaster()	
		self.duration = self:GetSpecialValueFor( "duration" )
		
		local tower = Entities:FindByName( nil, "npc_dota_custom_tower")
		if tower ~= nil then
		tower:AddNewModifier( tower, nil, "modifier_item_tower_protection", {duration = self.duration} )
		tower:AddAbility("creature_split_shot"):SetLevel(1)
		Timers:CreateTimer(self.duration, function()
		tower:RemoveAbility("creature_split_shot")
		end)
		end
		
		local tower2 = Entities:FindByName( nil, "npc_dota_custom_tower2")
		if tower2 ~= nil then
		tower2:AddNewModifier( tower2, nil, "modifier_item_tower_protection", {duration = self.duration} )
		tower2:AddAbility("creature_split_shot"):SetLevel(1)
		Timers:CreateTimer(self.duration, function()
		tower2:RemoveAbility("creature_split_shot")
		end)
		end
		
		local tower3 = Entities:FindByName( nil, "npc_dota_custom_tower3")
		if tower3 ~= nil then
		tower3:AddNewModifier( tower3, nil, "modifier_item_tower_protection", {duration = self.duration} )
		tower3:AddAbility("creature_split_shot"):SetLevel(1)
		Timers:CreateTimer(self.duration, function()
		tower3:RemoveAbility("creature_split_shot")
		end)
		end
		
		self.caster:EmitSound("DOTA_Item.RepairKit.Target")
	end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
modifier_item_tower_protection = class({})

function modifier_item_tower_protection:IsHidden()
	return false
end

function modifier_item_tower_protection:GetTexture()
	return "protection"
end

function modifier_item_tower_protection:IsDebuff()
	return false
end

function modifier_item_tower_protection:IsPurgable()
	return false
end

function modifier_item_tower_protection:OnCreated( kv )
end

function modifier_item_tower_protection:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE,
		}
	return funcs
end

function modifier_item_tower_protection:GetModifierIncomingPhysicalDamage_Percentage()
	return -100 
end
