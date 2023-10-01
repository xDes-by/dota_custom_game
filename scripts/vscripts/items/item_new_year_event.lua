item_new_year_event_summon = class({})

function item_new_year_event_summon:OnSpellStart()
	if GameRules:IsCheatMode() then 
		GameRules:SendCustomMessage("</font><font color='#0089ff'>Играй честно!</font>",0,0)
		GameRules:SendCustomMessage("</font><font color='#0089ff'>Dont use cheat mode</font>",0,0)
		self:StartCooldown(1000)
		return 
	end
	if GameRules:GetGameTime() < 4200 then 
		GameRules:SendCustomMessage("</font><font color='#0089ff'>The new year hasn't come yet</font>",0,0)
		GameRules:SendCustomMessage("</font><font color='#0089ff'>Новый год еще не наступил</font>",0,0)
		self:StartCooldown(1000)
		return 
	end
	DataBase:Event2021Boss(self:GetCaster():GetPlayerID())
	local boss = CreateUnitByName("raid_new_year", Entities:FindByName( nil, "line_spawner"):GetAbsOrigin() + Vector(0,-1000,0), true, nil, nil, DOTA_TEAM_BADGUYS)
	boss:AddItemByName("item_assault_lua")
	boss:AddItemByName("item_desolator_lua")
	boss:AddItemByName("item_greater_crit_lua")
	boss:AddItemByName("item_radiance_lua")
	boss:AddItemByName("item_kaya_lua")
	--boss:AddItemByName("item_tank_cuirass7")
	self:GetCaster():RemoveItem(self)
end

item_new_year_event = class({})

LinkLuaModifier("modifier_acogol", 'items/item_new_year_event', LUA_MODIFIER_MOTION_NONE)

function item_new_year_event:OnSpellStart()
	if GameRules:IsCheatMode() then 
		GameRules:SendCustomMessage("</font><font color='#0089ff'>Играй честно!</font>",0,0)
		GameRules:SendCustomMessage("</font><font color='#0089ff'>Dont use cheat mode</font>",0,0)
		self:StartCooldown(1000)
		return 
	end
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_acogol", {duration = 100})
	DataBase:Event2021(self:GetCaster():GetPlayerID())
end

modifier_acogol = class({})

function modifier_acogol:IsHidden()
	return false
end

function modifier_acogol:IsDebuff()
	return false
end

function modifier_acogol:IsPurgable()
	return true
end

function modifier_acogol:GetEffectName()
	return "particles/generic_gameplay/generic_sleep_b.vpcf"
end

function modifier_acogol:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_acogol:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_INVULNERABLE] = true
	}
end

function modifier_acogol:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
end

function modifier_acogol:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end