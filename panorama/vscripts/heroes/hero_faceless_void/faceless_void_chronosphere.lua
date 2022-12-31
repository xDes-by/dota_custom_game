faceless_void_chronosphere = class({})

function faceless_void_chronosphere:Spawn()
	if IsClient() then return end
	
	self.use_count = 0
	EventDriver:Listen("Round:round_ended", faceless_void_chronosphere.OnRoundEnded, self)
	EventDriver:Listen("PvpManager:pvp_countdown_ended", faceless_void_chronosphere.OnPvpStart, self)
end

function faceless_void_chronosphere:GetAOERadius()
	return self:GetSpecialValueFor("radius") + self:GetCaster():FindTalentValue("special_bonus_unique_faceless_void_2")
end

function faceless_void_chronosphere:IsRefreshable()
	if Enfos:IsEnfosMode() then
		if EnfosPVP:IsPlayerDueling(self:GetTeam(), self:GetCaster():GetPlayerOwnerID()) then

			return self.use_count <= 1
		end
	else
		return self.use_count <= 1
	end

	return true
end

function faceless_void_chronosphere:IsRefreshableByUnstableArcana()
	if Enfos:IsEnfosMode() then
		if EnfosPVP:IsPlayerDueling(self:GetTeam(), self:GetCaster():GetPlayerOwnerID()) then
			return self.use_count <= 1
		end
	else
		return self.use_count <= 1
	end

	return true
end

function faceless_void_chronosphere:OnSpellStart()
	local caster = self:GetCaster()
	local position = self:GetCursorPosition()
	local duration = self:GetSpecialValueFor("duration")

	CreateModifierThinker(caster, self, "modifier_faceless_void_chronosphere", {duration = duration}, position, self:GetTeam(), false)
	CreateModifierThinker(caster, self, "modifier_faceless_void_chronosphere_selfbuff", {duration = duration}, position, self:GetTeam(), false)

	self.use_count = self.use_count + 1
end

function faceless_void_chronosphere:OnRoundEnded()
	if Enfos:IsEnfosMode() then return end

	self.use_count = 0
end

function faceless_void_chronosphere:OnPvpStart()
	if not Enfos:IsEnfosMode() then return end
	if not EnfosPVP:IsPlayerDueling(self:GetTeam(), self:GetCaster():GetPlayerOwnerID()) then return end

	self.use_count = 0
end
