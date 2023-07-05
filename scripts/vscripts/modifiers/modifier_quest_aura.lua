if modifier_quest_aura == nil then
	modifier_quest_aura = class({})
end

function modifier_quest_aura:IsHidden()
  	return true
end

function modifier_quest_aura:OnCreated(t)
	if IsServer() then
		self.pid = self:GetParent():GetPlayerOwnerID()
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.pid),"ActivateQuestAura",{name = self:GetCaster():GetUnitName(), index = self:GetCaster():entindex()})
	end
end

function modifier_quest_aura:OnDestroy(t)
	if IsServer() then
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.pid),"DeactivateQuestAura",{})
	end
end