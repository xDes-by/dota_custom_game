LinkLuaModifier( "modifier_boss_no_ancient_attack", "bosses/EARTHSHAKER/modifier_boss_no_ancient_attack", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_invoker_active", "bosses/EARTHSHAKER/modifier_boss_no_ancient_attack", LUA_MODIFIER_MOTION_NONE )
item_shaker_boss_summon = class({})

function item_shaker_boss_summon:OnSpellStart()
    local boss = CreateUnitByName("boss_earthshaker", self:GetCaster():GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
    boss:AddNewModifier(self:GetCaster(), self, "modifier_boss_no_ancient_attack", {})
    boss.summoner = self:GetCaster()
    self.rp = 0
    if diff_wave.rating_scale == 0 then 
        boss:AddNewModifier(self:GetCaster(), nil, "modifier_easy", {}) 
        self.rp = 50 * 0.50
    end
    if diff_wave.rating_scale == 1 then 
        boss:AddNewModifier(self:GetCaster(), nil, "modifier_normal", {}) 
        self.rp = 50 * 1.00
    end
    if diff_wave.rating_scale == 2 then 
        boss:AddNewModifier(self:GetCaster(), nil, "modifier_hard", {}) 
        self.rp = 50 * 1.25
    end
    if diff_wave.rating_scale == 3 then 
        boss:AddNewModifier(self:GetCaster(), nil, "modifier_ultra", {}) 
        self.rp = 50 * 1.50
    end
    if diff_wave.rating_scale == 4 then 
        boss:AddNewModifier(self:GetCaster(), nil, "modifier_insane", {}) 
        self.rp = 50 * 1.75
    end
    
    self:GetCaster():RemoveItem(self)
end