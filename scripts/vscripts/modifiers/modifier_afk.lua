LinkLuaModifier( "modifier_afk_effect", "modifiers/modifier_afk", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_silent2", "modifiers/modifier_silent2", LUA_MODIFIER_MOTION_NONE )

modifier_afk = class({})

function modifier_afk:IsHidden()
	return true
end

function modifier_afk:IsPurgable()
	return false
end

function modifier_afk:RemoveOnDeath()
	return false
end

function modifier_afk:OnCreated( kv )
self:StartIntervalThink(1)
end

function modifier_afk:OnIntervalThink()
if not IsServer() then return end
	if not self:GetParent():HasModifier("modifier_afk_effect") then
	self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_afk_effect",{})
	end
end


function modifier_afk:OnRefresh( kv )
end

function modifier_afk:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_UNIT_MOVED,
		MODIFIER_EVENT_ON_ORDER,
	}
	return funcs
end

function modifier_afk:OnUnitMoved(keys)
if not IsServer() then return end
	if keys.unit == self:GetParent() then
		if self:GetParent():HasModifier("modifier_afk_effect") then
			self:GetParent():RemoveModifierByName("modifier_afk_effect")			
		end
	end
end

function modifier_afk:OnOrder(kv)
	if not IsServer() then return end
	local order = kv["order_type"]
		if order == DOTA_UNIT_ORDER_PATROL then
		Timers:CreateTimer(0.5, function()
		local patrol = {
						UnitIndex = kv.unit:entindex(), 
						OrderType = DOTA_UNIT_ORDER_STOP,
						Position = self:GetParent():GetAbsOrigin()
					}
			ExecuteOrderFromTable(patrol)
		end)
	end
end
----------------------------------------------------------------------------------------------

modifier_afk_effect = class({})

function modifier_afk_effect:IsHidden()
	return true
end

function modifier_afk_effect:IsPurgable()
	return false
end

function modifier_afk_effect:RemoveOnDeath()
	return false
end

function modifier_afk_effect:OnCreated( kv )
if not IsServer() then return end
	self.afk = 0
	self:StartIntervalThink(1)
end

function modifier_afk_effect:OnIntervalThink()
	if not IsServer() then return end
		if not GameRules:IsCheatMode() then
			if self:GetParent():GetHealthPercent() == 100 then
			self.afk = self.afk + 1
			if self.afk >= 600 and not self:GetParent():HasModifier("modifier_silent2") then
				if self:GetParent():GetUnitName() ~= "npc_dota_hero_treant" then
					self:GetParent():SetOrigin(Vector(2631,-11643,128))
					--PlayerResource:SetCameraTarget(self:GetParent():GetPlayerOwnerID(),self:GetParent())
					self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_silent2",  { })
					self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_invulnerable",  { })
					
					local tp = self:GetParent():FindItemInInventory("item_tpscroll")
					if tp ~= nil then
						self:GetParent():RemoveItem(tp)	
					end
				end
			end
		end
	end
end
