npc_dota_hero_viper_agi9 = class({})

function npc_dota_hero_viper_agi9:OnUpgrade()
    self.viper_viper_strike_lua = self:GetCaster():FindAbilityByName("viper_viper_strike_lua")
    self.viper_viper_strike_lua:RefreshCharges()
end