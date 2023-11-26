npc_dota_hero_viper_int7 = class({})

function npc_dota_hero_viper_int7:OnUpgrade()
    self.viper_nethertoxin_lua = self:GetCaster():FindAbilityByName("viper_nethertoxin_lua")
    self.viper_nethertoxin_lua:RefreshCharges()
end