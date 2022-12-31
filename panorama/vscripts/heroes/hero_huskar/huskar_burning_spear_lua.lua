huskar_burning_spear_lua = class({})
LinkLuaModifier( "modifier_huskar_burning_spear_lua", "heroes/hero_huskar/huskar_burning_spear_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_huskar_burning_spear_debuff_lua", "heroes/hero_huskar/huskar_burning_spear_lua", LUA_MODIFIER_MOTION_NONE )

function huskar_burning_spear_lua:GetIntrinsicModifierName()
	return "modifier_huskar_burning_spear_lua"
end

function huskar_burning_spear_lua:CastFilterResultTarget(target)
	local caster = self:GetCaster()

	if caster:GetTeamNumber() ~= target:GetTeamNumber() then
		if target:IsMagicImmune() and not caster:HasTalent("special_bonus_unique_huskar_5") then
			return UF_FAIL_MAGIC_IMMUNE_ENEMY
		end
	end

	return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, caster:GetTeamNumber())
end




modifier_huskar_burning_spear_lua = class({})

function modifier_huskar_burning_spear_lua:IsHidden() return true end
function modifier_huskar_burning_spear_lua:IsPurgable() return false end
function modifier_huskar_burning_spear_lua:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_huskar_burning_spear_lua:OnCreated()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	if not caster or caster:IsNull() then return end
	if not ability or ability:IsNull() then return end
	
	self.health_cost = ability:GetSpecialValueFor("health_cost")
	self.duration = ability:GetSpecialValueFor("duration")
	self.spear_aoe = ability:GetSpecialValueFor("spear_aoe")

end

function modifier_huskar_burning_spear_lua:OnRefresh()
	self:OnCreated()
end

function modifier_huskar_burning_spear_lua:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_FINISHED,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}
end

function modifier_huskar_burning_spear_lua:OnAttackStart(event)
	if not IsServer() then return end
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	if not caster or caster:IsNull() then return end
	if not ability or ability:IsNull() then return end
	if not event.attacker or event.attacker:IsNull() then return end
	if not event.target or event.target:IsNull() then return end
	if not event.target.IsMagicImmune then return end

	if not (event.attacker == caster) then return end

	self.cast_burning_spear = false
	local active_ability = caster:GetCurrentActiveAbility()
	if active_ability and active_ability == ability then
		self.cast_burning_spear = true
	end

	-- autocast needs its own check for magic immunity
	if ability:GetAutoCastState() and (not event.target:IsMagicImmune() or caster:HasTalent("special_bonus_unique_huskar_5")) then
		self.cast_burning_spear = true
	end

	if self.cast_burning_spear and caster:IsRangedAttacker() then
		self.original_projectile_name = caster:GetRangedProjectileName()
		caster:SetRangedProjectileName("particles/units/heroes/hero_huskar/huskar_burning_spear.vpcf")
	end
end

function modifier_huskar_burning_spear_lua:OnAttack(event)
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	if not caster or caster:IsNull() then return end
	if not ability or ability:IsNull() then return end

	if not (event.attacker == caster) then return end

	if not self.cast_burning_spear then return end

	-- self damage
	local damage_table = {
		victim = caster,
		attacker = caster,
		damage = self.health_cost,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self,
		damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL + DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS,
	}
	ApplyDamage(damage_table)
	
end
	
function modifier_huskar_burning_spear_lua:OnAttackFinished(keys)
	local caster = self:GetCaster()
	if not caster or caster:IsNull() then return end
	if keys.attacker == caster then
		if self.original_projectile_name then
			caster:SetRangedProjectileName(self.original_projectile_name)
		end
	end
end

function modifier_huskar_burning_spear_lua:GetModifierProcAttack_Feedback(params)
	local target = params.target
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	if not target or target:IsNull() then return end
	if not caster or caster:IsNull() then return end
	if not ability or ability:IsNull() then return end

	if not self.cast_burning_spear then return end

	-- burn enemies in an AoE
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), params.target:GetOrigin(), nil, self.spear_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	for _, enemy in pairs(enemies) do
		if enemy and not enemy:IsNull() then

			local modifier = enemy:AddNewModifier(caster, ability, "modifier_huskar_burning_spear_debuff_lua", {duration = self.duration})
			if modifier and not modifier:IsNull() then
				modifier:AddIndependentStack(self.duration, nil, true, {stacks = self.stacks})
			end

		end
	end

	-- effects
	EmitSoundOn( "Hero_Huskar.Burning_Spear.Cast", caster )
end




modifier_huskar_burning_spear_debuff_lua = class({})

function modifier_huskar_burning_spear_debuff_lua:IsHidden() return false end
function modifier_huskar_burning_spear_debuff_lua:IsDebuff() return true end
function modifier_huskar_burning_spear_debuff_lua:IsStunDebuff() return false end
function modifier_huskar_burning_spear_debuff_lua:IsPurgable() return false end

function modifier_huskar_burning_spear_debuff_lua:OnCreated()

	if not IsServer() then return end
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local ability = self:GetAbility()

	if not caster or caster:IsNull() then return end
	if not parent or parent:IsNull() then return end
	if not ability or ability:IsNull() then return end

	-- data
	self.burn_damage = ability:GetSpecialValueFor( "burn_damage" )
	self.duration = ability:GetSpecialValueFor( "duration" )

	-- talents
	self.burn_damage = self.burn_damage + caster:FindTalentValue("special_bonus_unique_huskar_2")

	-- precache damage
	self.damage_table = {
		victim = parent,
		attacker = caster,
		-- damage = 500,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = ability,
	}

	if caster:HasTalent("special_bonus_unique_huskar_5") then
		self.damage_table.damage_type = DAMAGE_TYPE_PURE
	end

	if self.refresh then return end

	-- start interval
	self:StartIntervalThink( 1 )
	
end

function modifier_huskar_burning_spear_debuff_lua:OnRefresh()
	self.refresh = true
	self:OnCreated()
	self.refresh = nil
end

function modifier_huskar_burning_spear_debuff_lua:OnDestroy()
	StopSoundOn( "Hero_Huskar.Burning_Spear", self:GetParent() )
end

function modifier_huskar_burning_spear_debuff_lua:OnIntervalThink()
	-- apply dot damage
	self.damage_table.damage = self:GetStackCount() * self.burn_damage
	ApplyDamage( self.damage_table )
end

function modifier_huskar_burning_spear_debuff_lua:GetEffectName()
	return "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf"
end

function modifier_huskar_burning_spear_debuff_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
