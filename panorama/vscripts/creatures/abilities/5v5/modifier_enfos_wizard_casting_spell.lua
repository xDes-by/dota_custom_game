modifier_enfos_wizard_casting_spell = class({})

function modifier_enfos_wizard_casting_spell:IsHidden() return true end
function modifier_enfos_wizard_casting_spell:IsDebuff() return false end
function modifier_enfos_wizard_casting_spell:IsPurgable() return false end
function modifier_enfos_wizard_casting_spell:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_enfos_wizard_casting_spell:DeclareFunctions()
	if IsServer() then
		return {
			MODIFIER_EVENT_ON_ORDER,
			MODIFIER_EVENT_ON_ABILITY_START
		}
	end
end

function modifier_enfos_wizard_casting_spell:OnAbilityStart(keys)
	if keys.unit == self:GetParent() and keys.ability ~= self:GetAbility()then
		self:Destroy()
	end
end

function modifier_enfos_wizard_casting_spell:OnOrder(keys)
	if keys.unit == self:GetParent() and (keys.order_type ~= DOTA_UNIT_ORDER_CAST_POSITION and keys.order_type ~= DOTA_UNIT_ORDER_CAST_TARGET and keys.order_type ~= DOTA_UNIT_ORDER_CAST_NO_TARGET) then
		self:Destroy()
	end
end

function modifier_enfos_wizard_casting_spell:OnDestroy()
	if (not IsServer()) then return end

	self:GetParent():RemoveAbility(self:GetAbility():GetAbilityName())
	EnfosWizard:SetIsBusyState(self:GetParent():GetTeam(), false)
end

