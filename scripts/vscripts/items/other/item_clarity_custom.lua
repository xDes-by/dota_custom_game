LinkLuaModifier("modifier_item_clarity_custom", "items/other/item_clarity_custom", LUA_MODIFIER_MOTION_NONE )
item_clarity_custom1 = class({})

function item_clarity_custom1:OnSpellStart()
    local images = {"clarity_png","greater_clarity_png","greater_clarity2_png"}
    local duration = self:GetSpecialValueFor("buff_duration")
    self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_item_clarity_custom", {duration = duration, image = images[self:GetLevel()]})
    self:GetCaster():EmitSound("DOTA_Item.ClarityPotion.Activate")
    if self:GetCurrentCharges() > 1 then
        self:SetCurrentCharges(self:GetCurrentCharges() - 1)
    else
        self:GetCaster():RemoveItem(self)
    end
end

item_clarity_custom2 = item_clarity_custom1
item_clarity_custom3 = item_clarity_custom1

modifier_item_clarity_custom = class({})
function modifier_item_clarity_custom:GetTexture()
    local images = {"clarity_png","greater_clarity_png","greater_clarity2_png"}
    return images[self.level]
end
function modifier_item_clarity_custom:IsHidden()
    return false
end

function modifier_item_clarity_custom:IsDebuff()
    return false
end

function modifier_item_clarity_custom:IsPurgable()
    return false
end

function modifier_item_clarity_custom:RemoveOnDeath()
    return true
end

function modifier_item_clarity_custom:OnCreated( kv )
    self.level = self:GetAbility():GetLevel()
    self.mana_regen = self:GetAbility():GetSpecialValueFor('mana_regen')
end
modifier_item_clarity_custom.OnRefresh = modifier_item_clarity_custom.OnCreated

function modifier_item_clarity_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT ,
		}
	return funcs
end

function modifier_item_clarity_custom:GetModifierConstantManaRegen()
	return self.mana_regen
end