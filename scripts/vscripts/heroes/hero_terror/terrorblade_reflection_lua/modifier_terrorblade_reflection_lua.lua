modifier_terrorblade_reflection_lua = class({})

function modifier_terrorblade_reflection_lua:IsHidden()
	return false
end

function modifier_terrorblade_reflection_lua:IsDebuff()
	return true
end

function modifier_terrorblade_reflection_lua:IsPurgable()
	return true
end

function modifier_terrorblade_reflection_lua:OnCreated( kv )
	local ability = self:GetCaster():FindAbilityByName( "terrorblade_reflection_lua" )
		if ability~=nil and ability:GetLevel()>=1 then
		
	self.slow = -ability:GetSpecialValueFor( "move_slow" )
	self.outgoing = ability:GetSpecialValueFor( "illusion_outgoing_tooltip" ) - 100
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_terrorblade_agi6")
	if abil ~= nil then
		self.outgoing = ability:GetSpecialValueFor( "illusion_outgoing_tooltip" ) * 2 - 100
	end

	if not IsServer() then return end

	self.distance = 300

	-- create illusion
	local illusions = CreateIllusions(
		self:GetCaster(), 
		self:GetCaster(), 
		{
			outgoing_damage = self.outgoing,
			duration = self:GetDuration(),
		}, -- hModiiferKeys
		1, -- nNumIllusions
		self.distance, -- nPadding
		false, -- bScramblePosition
		true -- bFindClearSpace
	)
	local illusion = illusions[1]

	-- add illusion buff
	illusion:AddNewModifier(
		self:GetCaster(), -- player source
		ability, -- ability source
		"modifier_terrorblade_reflection_lua_illusion", -- modifier name
		{ duration = self:GetDuration() } -- kv
	)
	
	if self:GetParent() ~= nil then
	
	ability:SetContextThink( ability:GetAbilityName(), function()
		local order = {
			UnitIndex = illusion:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = self:GetParent():entindex(),
		}
		ExecuteOrderFromTable( order )
	end, FrameTime())

	self.illusions = self.illusions or {}
	self.illusions[ illusion ] = true

	self:StartIntervalThink( 0.1 )
	end
end
end

function modifier_terrorblade_reflection_lua:OnRefresh( kv )
	self:OnCreated( kv )	
end

function modifier_terrorblade_reflection_lua:OnRemoved()
end

function modifier_terrorblade_reflection_lua:OnDestroy()
	if not IsServer() then return end
	for illusion,_ in pairs( self.illusions ) do
		if not illusion:IsNull() then
			illusion:ForceKill( false )
		end
	end
end

function modifier_terrorblade_reflection_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

function modifier_terrorblade_reflection_lua:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end

function modifier_terrorblade_reflection_lua:OnIntervalThink()
	local parent = self:GetParent()
	local origin = parent:GetOrigin()
	local seen = self:GetCaster():CanEntityBeSeenByMyTeam( parent )

	if not seen then
		for illusion,_ in pairs( self.illusions ) do
			if not illusion:IsNull() and (illusion:GetOrigin()-origin):Length2D()>self.distance/2 then
				-- move to position
				illusion:MoveToPosition( origin )
			end
		end
	else
		for illusion,_ in pairs( self.illusions ) do
			if not illusion:IsNull() and illusion:GetAggroTarget()~=parent then
				-- command to attack target
				local order = {
					UnitIndex = illusion:entindex(),
					OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
					TargetIndex = parent:entindex(),
				}
				ExecuteOrderFromTable( order )
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_terrorblade_reflection_lua:GetEffectName()
	return "particles/units/heroes/hero_terrorblade/terrorblade_reflection_slow.vpcf"
end

function modifier_terrorblade_reflection_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end