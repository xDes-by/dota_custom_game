modifier_jakiro_liquid_ice_intrinsic_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_jakiro_liquid_ice_intrinsic_lua:IsHidden()
	return true
end

function modifier_jakiro_liquid_ice_intrinsic_lua:IsDebuff()
	return false
end

function modifier_jakiro_liquid_ice_intrinsic_lua:IsPurgable()
	return false
end

function modifier_jakiro_liquid_ice_intrinsic_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_jakiro_liquid_ice_intrinsic_lua:OnCreated( kv )
	-- generate data
	
	self.cast = false
	self.records = {}
	if not IsServer() then return end
	self:StartIntervalThink(0.2)
end

function modifier_jakiro_liquid_ice_intrinsic_lua:OnRefresh( kv )
end

function modifier_jakiro_liquid_ice_intrinsic_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_jakiro_liquid_ice_intrinsic_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_FAIL,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY,

		MODIFIER_EVENT_ON_ORDER,

		-- MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
	}

	return funcs
end

function modifier_jakiro_liquid_ice_intrinsic_lua:OnAttack( params )
	-- if not IsServer() then return end
	if params.attacker~=self:GetParent() then return end

	-- register attack if being cast and fully castable
	if self:ShouldLaunch( params.target ) then
		-- use mana and cd
		self:GetAbility():UseResources( true, false,false, true)

		-- record the attack
		self.records[params.record] = true

		-- run OrbFire script if available
		if self:GetAbility().OnOrbFire then self:GetAbility():OnOrbFire( params ) end
	end

	self.cast = false
end
function modifier_jakiro_liquid_ice_intrinsic_lua:GetModifierProcAttack_Feedback( params )
	if self.records[params.record] then
		-- apply the effect
		if self:GetAbility().OnOrbImpact then self:GetAbility():OnOrbImpact( params ) end
	end
end
function modifier_jakiro_liquid_ice_intrinsic_lua:OnAttackFail( params )
	if self.records[params.record] then
		-- apply the fail effect
		if self:GetAbility().OnOrbFail then self:GetAbility():OnOrbFail( params ) end
	end
end
function modifier_jakiro_liquid_ice_intrinsic_lua:OnAttackRecordDestroy( params )
	-- destroy attack record
	self.records[params.record] = nil
end

function modifier_jakiro_liquid_ice_intrinsic_lua:OnOrder( params )
	if params.unit~=self:GetParent() then return end

	if params.ability then
		-- if this ability, cast
		if params.ability==self:GetAbility() then
			self.cast = true
			return
		end

		-- if casting other ability that cancel channel while casting this ability, turn off
		local pass = false
		local behavior = params.ability:GetBehavior()
	--[[	if self:FlagExist( behavior, DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_CHANNEL ) or 
			self:FlagExist( behavior, DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_MOVEMENT ) or
			self:FlagExist( behavior, DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL )
		then
			local pass = true -- do nothing
		end ]]--

		if self.cast and (not pass) then
			self.cast = false
		end
	else
		-- if ordering something which cancel channel, turn off
		if self.cast then
			if self:FlagExist( params.order_type, DOTA_UNIT_ORDER_MOVE_TO_POSITION ) or
				self:FlagExist( params.order_type, DOTA_UNIT_ORDER_MOVE_TO_TARGET )	or
				self:FlagExist( params.order_type, DOTA_UNIT_ORDER_ATTACK_MOVE ) or
				self:FlagExist( params.order_type, DOTA_UNIT_ORDER_ATTACK_TARGET ) or
				self:FlagExist( params.order_type, DOTA_UNIT_ORDER_STOP ) or
				self:FlagExist( params.order_type, DOTA_UNIT_ORDER_HOLD_POSITION )
			then
				self.cast = false
			end
		end
	end
end

-- function modifier_jakiro_liquid_ice_intrinsic_lua:GetModifierProjectileName()
-- 	if not self:GetAbility().GetProjectileName then return end

-- 	if self:ShouldLaunch( self:GetCaster():GetAggroTarget() ) then
-- 		return self:GetAbility():GetProjectileName()
-- 	end
-- end

--------------------------------------------------------------------------------
-- Helper
function modifier_jakiro_liquid_ice_intrinsic_lua:ShouldLaunch( target )
	-- check autocast
	if self:GetAbility():GetAutoCastState() then
		-- filter whether target is valid
		if self:GetAbility().CastFilterResultTarget~=CDOTA_Ability_Lua.CastFilterResultTarget then
			-- check if ability has custom target cast filter
			if self:GetAbility():CastFilterResultTarget( target )==UF_SUCCESS then
				self.cast = true
			end
		else
			local nResult = UnitFilter(
				target,
				self:GetAbility():GetAbilityTargetTeam(),
				self:GetAbility():GetAbilityTargetType(),
				self:GetAbility():GetAbilityTargetFlags(),
				self:GetCaster():GetTeamNumber()
			)
			if nResult == UF_SUCCESS then
				self.cast = true
			end
		end
	end

	if self.cast and self:GetAbility():IsFullyCastable() and (not self:GetParent():IsSilenced()) then
		return true
	end

	return false
end

--------------------------------------------------------------------------------
-- Helper: Flags
function modifier_jakiro_liquid_ice_intrinsic_lua:FlagExist(a,b)--Bitwise Exist
	local p,c,d=1,0,b
	while a>0 and b>0 do
		local ra,rb=a%2,b%2
		if ra+rb>1 then c=c+p end
		a,b,p=(a-ra)/2,(b-rb)/2,p*2
	end
	return c==d
end

function modifier_jakiro_liquid_ice_intrinsic_lua:GetModifierOverrideAbilitySpecial(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "max_hp_damage" then
			return 1
		end
	end
	return 0
end

function modifier_jakiro_liquid_ice_intrinsic_lua:GetModifierOverrideAbilitySpecialValue(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "max_hp_damage" then
			local max_hp_damage = self:GetAbility():GetLevelSpecialValueNoOverride( "max_hp_damage", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_jakiro_str13") then
                max_hp_damage = 2.5
            end
            return max_hp_damage
		end
	end
	return 0
end

function modifier_jakiro_liquid_ice_intrinsic_lua:OnIntervalThink()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_jakiro_str12") then
		self:GetAbility():SetHidden( false )
	else
		self:GetAbility():SetHidden( true )
	end
end