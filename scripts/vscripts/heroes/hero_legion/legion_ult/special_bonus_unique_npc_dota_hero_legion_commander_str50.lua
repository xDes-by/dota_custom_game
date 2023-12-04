special_bonus_unique_npc_dota_hero_legion_commander_str50 = class({})

function special_bonus_unique_npc_dota_hero_legion_commander_str50:OnUpgrade()
    if self:GetCaster():GetLevel() == 1 then
        local ability = self:GetCaster():FindAbilityByName("legion_ult")
        local ability2 = self:GetCaster():FindAbilityByName("legion_ult2")
        ability.added_stacks = 10
        ability2.added_stacks = 10
        ability:SetLevel(1)
        ability2:SetLevel(1)
        local modifier = self:GetCaster():FindModifierByName("modifier_legion_ult")
        modifier:SetStackCount(10)
    end
end