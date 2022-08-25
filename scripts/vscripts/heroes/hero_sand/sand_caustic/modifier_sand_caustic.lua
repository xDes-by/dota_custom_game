modifier_sand_caustic = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_sand_caustic:IsHidden()
	return true
end

function modifier_sand_caustic:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_sand_caustic:OnCreated( kv )
	-- references
	self.duration = self:GetAbility():GetSpecialValueFor( "caustic_finale_duration" ) -- special value
end

function modifier_sand_caustic:OnRefresh( kv )
	-- references
	self.duration = self:GetAbility():GetSpecialValueFor( "caustic_finale_duration" ) -- special value	
end

function modifier_sand_caustic:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_sand_caustic:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}

	return funcs
end

function modifier_sand_caustic:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		-- check break
		if self:GetParent():PassivesDisabled() then return end

		-- check allies
		if params.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then return end

		-- check spell immunity
		if params.target:IsMagicImmune() then return end

		-- add debuff if not present
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