modifier_riki_tricks_of_the_trade_lua_charges = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_riki_tricks_of_the_trade_lua_charges:IsHidden()
	return false
end

function modifier_riki_tricks_of_the_trade_lua_charges:IsDebuff()
	return false
end

function modifier_riki_tricks_of_the_trade_lua_charges:IsPurgable()
	return false
end

function modifier_riki_tricks_of_the_trade_lua_charges:DestroyOnExpire()
	return false
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_riki_tricks_of_the_trade_lua_charges:OnCreated( kv )
	self.max_charges = 2
	if IsServer() then
		self:SetStackCount( self.max_charges )
		self:CalculateCharge()
	end
end

function modifier_riki_tricks_of_the_trade_lua_charges:OnRefresh( kv )
	if IsServer() then
		self:CalculateCharge()
	end
end

function modifier_riki_tricks_of_the_trade_lua_charges:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_riki_tricks_of_the_trade_lua_charges:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end

function modifier_riki_tricks_of_the_trade_lua_charges:OnAbilityFullyCast( params )
	if IsServer() then
		if params.unit~=self:GetParent() or params.ability~=self:GetAbility() then
			return
		end

		self:DecrementStackCount()
		self:CalculateCharge()
	end
end
--------------------------------------------------------------------------------
-- Interval Effects
function modifier_riki_tricks_of_the_trade_lua_charges:OnIntervalThink()
	self:IncrementStackCount()
	self:StartIntervalThink(-1)
	self:CalculateCharge()
end

function modifier_riki_tricks_of_the_trade_lua_charges:CalculateCharge()
	self:GetAbility():EndCooldown()
	if self:GetStackCount()>=self.max_charges then
		-- stop charging
		self:SetDuration( -1, false )
		self:StartIntervalThink( -1 )
	else
		-- if not charging
		if self:GetRemainingTime() <= 0.05 then
			-- start charging
			local charge_time = self:GetAbility():GetCooldown( -1 )
			if self:GetCaster():FindAbilityByName("npc_dota_hero_riki_int6") then
				charge_time = charge_time / 2
			end
			self:StartIntervalThink( charge_time )
			self:SetDuration( charge_time, true )
		end

		-- set on cooldown if no charges
		if self:GetStackCount()==0 then
			self:GetAbility():StartCooldown( self:GetRemainingTime() )
		end
	end
end