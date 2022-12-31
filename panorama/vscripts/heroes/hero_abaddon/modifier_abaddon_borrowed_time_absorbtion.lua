modifier_abaddon_borrowed_time_absorbtion = class({})

function modifier_abaddon_borrowed_time_absorbtion:IsPurgable() return false end


function modifier_abaddon_borrowed_time_absorbtion:GetEffectName()
	return "particles/units/heroes/hero_abaddon/abaddon_borrowed_time.vpcf"
end

function modifier_abaddon_borrowed_time_absorbtion:OnCreated()
	if not IsServer() then return end
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then return end
	self.scepter_heal_threshold = ability:GetSpecialValueFor("ally_threshold_scepter")
	self.scepter_heal_radius	= ability:GetSpecialValueFor("redirect_range_scepter")

	self.parent = self:GetParent()
	self.team_number = self.parent:GetTeamNumber()
	self.parent:Purge(false, true, false, true, true)

	self.ally_heroes_table = {}

	self.parent:EmitSound("Hero_Abaddon.BorrowedTime")
end

function modifier_abaddon_borrowed_time_absorbtion:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE, -- OnTakeDamage
		--MODIFIER_PROPERTY_MIN_HEALTH,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
	}
end

function modifier_abaddon_borrowed_time_absorbtion:GetAbsoluteNoDamageMagical(params)
	if params.damage_type ~= DAMAGE_TYPE_MAGICAL then return end

	self:ProcessSelfDamage(params)
	return 1
end

function modifier_abaddon_borrowed_time_absorbtion:GetAbsoluteNoDamagePhysical(params)
	if params.damage_type ~= DAMAGE_TYPE_PHYSICAL then return end

	self:ProcessSelfDamage(params)
	return 1
end

function modifier_abaddon_borrowed_time_absorbtion:GetAbsoluteNoDamagePure(params)
	if params.damage_type ~= DAMAGE_TYPE_PURE then return end

	self:ProcessSelfDamage(params)
	return 1
end

function modifier_abaddon_borrowed_time_absorbtion:OnTakeDamage(params)
	if not IsServer() then return end
	if params.unit == self.parent then
		--self:ProcessSelfDamage(params)
	elseif params.unit:GetTeamNumber() == self.team_number and params.unit:IsMainHero() then
		self:ProcessOtherDamage(params)
	end
end

function modifier_abaddon_borrowed_time_absorbtion:ProcessSelfDamage(params)
	if not params.damage then return end
	-- clamp damage cause overflow
	local damage = params.damage
	if damage > 900000 then damage = 900000 end
	self.parent:Heal(damage, self.parent)
end

-- scepter ally healing mechanic
-- accumulates recieved damage in radius, fires projectiles
function modifier_abaddon_borrowed_time_absorbtion:ProcessOtherDamage(params)
	if not self.parent:HasScepter() then return end
	if not params.damage then return end

	local distance = (params.unit:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D()

	if distance > self.scepter_heal_radius then return end

	local target_idx = params.unit:GetEntityIndex()

	if not self.ally_heroes_table[target_idx] then
		self.ally_heroes_table[target_idx] = 0
	end

	self.ally_heroes_table[target_idx] = self.ally_heroes_table[target_idx] + params.damage

	if self.ally_heroes_table[target_idx] >= self.scepter_heal_threshold then
		local ability = self:GetAbility()
		if ability and not ability:IsNull() then
			ability:FireHealingProjectile(params.unit)
		end
		self.ally_heroes_table[target_idx] = 0
	end
end
