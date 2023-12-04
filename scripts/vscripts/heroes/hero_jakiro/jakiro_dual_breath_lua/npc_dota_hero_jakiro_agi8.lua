npc_dota_hero_jakiro_agi8 = class({})

function npc_dota_hero_jakiro_agi8:OnUpgrade()
    self.jakiro_dual_breath_lua = self:GetCaster():FindAbilityByName("jakiro_dual_breath_lua")
    self.jakiro_dual_breath_lua:RefreshCharges()
end