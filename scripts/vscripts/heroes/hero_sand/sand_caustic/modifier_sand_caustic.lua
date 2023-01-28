modifier_sand_caustic = class({})

function modifier_sand_caustic:IsHidden()
	return true
end

function modifier_sand_caustic:IsPurgable()
	return false
end

function modifier_sand_caustic:OnCreated( kv )
	self.duration = self:GetAbility():GetSpecialValueFor( "caustic_finale_duration" ) -- special value
end

function modifier_sand_caustic:OnRefresh( kv )
	self.duration = self:GetAbility():GetSpecialValueFor( "caustic_finale_duration" ) -- special value	
end

function modifier_sand_caustic:OnDestroy( kv )

end

function modifier_sand_caustic:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}
	return funcs
end

function modifier_sand_caustic:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		if self:GetParent():PassivesDisabled() then return end
		if params.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then return end
		if params.target:IsMagicImmune() then return end
		local modifier = params.target:FindModifierByNameAndCaster( "modifier_sand_caustic_debuff", self:GetParent() )
		if not modifier then
			params.target:AddNewModifier(
				self:GetParent(), -- player source
				self:GetAbility(), -- ability source
				"modifier_sand_caustic_debuff", -- modifier name
				{ duration = self.duration } -- kv
			)
		end
	end
end