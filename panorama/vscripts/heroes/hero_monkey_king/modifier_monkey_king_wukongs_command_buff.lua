modifier_monkey_king_wukongs_command_buff = class({})

function modifier_monkey_king_wukongs_command_buff:IsPurgable() return false end

function modifier_monkey_king_wukongs_command_buff:OnCreated()
	if not IsServer() then return end

	local ability = self:GetAbility()
	local caster = ability:GetCaster()

	self.armor_bonus = ability:GetSpecialValueFor("bonus_armor")

	local talent = caster:FindAbilityByName("special_bonus_unique_monkey_king_4")

	if talent and talent:GetLevel() > 1 then
		self.armor_bonus = self.armor_bonus + talent:GetSpecialValueFor("value")
	end
	
	self:SetStackCount(self.armor_bonus)
end


function modifier_monkey_king_wukongs_command_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, -- GetModifierPhysicalArmorBonus
	}
end

function modifier_monkey_king_wukongs_command_buff:GetModifierPhysicalArmorBonus()
	return self:GetStackCount()
end
