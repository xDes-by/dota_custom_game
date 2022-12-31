item_enfos_exp_tome = class({})
item_enfos_exp_tome_2 = item_enfos_exp_tome



function item_enfos_exp_tome:OnSpellStart()
	local team = self:GetCaster():GetTeam()
	local experience = self:GetSpecialValueFor("bonus_exp")

	for _, hero in pairs(Enfos:GetAllMainHeroes()) do
		if hero:GetTeam() == team then
			hero:EmitSound("Item.TomeOfKnowledge")
			hero:AddExperience(experience, DOTA_ModifyXP_TomeOfKnowledge, false, true)
		end
	end

	if self:GetCurrentCharges() > 1 then
		self:SetCurrentCharges(self:GetCurrentCharges() - 1)
	else
		self:Destroy()
	end
end
