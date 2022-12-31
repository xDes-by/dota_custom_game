
dragon_knight_elder_dragon_form_lua = class({})

function dragon_knight_elder_dragon_form_lua:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")

	if not caster or caster:IsNull() then return end
	if not self or self:IsNull() then return end

	local elder_dragon_form_modifier = caster:AddNewModifier(caster, self, "modifier_dragon_knight_dragon_form", {duration = duration})
	if elder_dragon_form_modifier and not elder_dragon_form_modifier:IsNull() then
		
		local modifiers_remove = {
			"modifier_dragon_knight_corrosive_breath",
			"modifier_dragon_knight_splash_attack",
			"modifier_dragon_knight_frost_breath",
		}

		for _, modifier_name in pairs(modifiers_remove) do
			local modifier = caster:FindModifierByName(modifier_name)
			if modifier and not modifier:IsNull() then
				caster:RemoveModifierByName(modifier_name)
			end
		end
		
		caster:AddNewModifier(caster, self, "modifier_dragon_knight_combined_modifiers_lua", {duration = duration})

	end
end

LinkLuaModifier( "modifier_dragon_knight_combined_modifiers_lua", "heroes/hero_dragon_knight/dragon_knight_elder_dragon_form_lua", LUA_MODIFIER_MOTION_NONE )

modifier_dragon_knight_combined_modifiers_lua = class({})
function modifier_dragon_knight_combined_modifiers_lua:IsHidden() return false end
function modifier_dragon_knight_combined_modifiers_lua:IsPurgable() return false end
function modifier_dragon_knight_combined_modifiers_lua:IsDebuff() return false end
function modifier_dragon_knight_combined_modifiers_lua:IsBuff() return true end

function modifier_dragon_knight_combined_modifiers_lua:OnCreated()
	if not IsServer() then return end
	local parent = self:GetParent()
	local caster = self:GetCaster()
	local ability = self:GetAbility()

	if not caster or caster:IsNull() then return end
	if not parent or parent:IsNull() then return end
	if not ability or ability:IsNull() then return end

	self.ability_level = ability:GetLevel() - 1
	if caster:HasScepter() then
		self.ability_level = self.ability_level + 1
	end

	-- corrosive breath modifier precache
	self.corrosive_breath_duration = self:GetAbility():GetSpecialValueFor("corrosive_breath_duration")

	-- splash modifier precache
	self.splash_radius = ability:GetSpecialValueFor("splash_radius")
	self.splash_damage_percent = ability:GetLevelSpecialValueFor("splash_damage_percent", self.ability_level)
	self.splash_delay = ability:GetSpecialValueFor("splash_delay")
	self.damage_table = {
		attacker 		= caster,
		damage_type 	= DAMAGE_TYPE_PHYSICAL,
		damage_flags 	= DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
	}

	-- frost breath modifier precache
	self.frost_duration = ability:GetSpecialValueFor("frost_duration")
end

function modifier_dragon_knight_combined_modifiers_lua:OnRefresh()
	self:OnCreated()
end

function modifier_dragon_knight_combined_modifiers_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
	}
end

function modifier_dragon_knight_combined_modifiers_lua:GetModifierProcAttack_Feedback(keys)
	if not IsServer() then return end
	if (not keys.target) or (not keys.attacker) or (keys.target:IsNull() or keys.attacker:IsNull()) then return end
	if not keys.attacker:IsRealHero() or not keys.attacker:IsRangedAttacker() then return end
	if keys.attacker:GetTeam() == keys.target:GetTeam() then return end

	local ability = self:GetAbility()
	if not ability or ability:IsNull() then return end
	local target_loc = keys.target:GetAbsOrigin()
	local fury_swipes_damage = 0

	-- corrosive breath modifier
	keys.target:AddNewModifier(keys.attacker, ability, "modifier_dragon_knight_corrosive_breath_dot_lua", {duration = self.corrosive_breath_duration})
	
	if self.ability_level <= 0 then return end

	if keys.attacker:HasAbility("ursa_fury_swipes") and keys.target:HasModifier("modifier_ursa_fury_swipes_damage_increase") then
		local ursa_swipes = keys.attacker:FindAbilityByName("ursa_fury_swipes")
		if ursa_swipes and not ursa_swipes:IsNull() then
			local stacks = keys.target:GetModifierStackCount("modifier_ursa_fury_swipes_damage_increase", keys.attacker)
			fury_swipes_damage = stacks * ursa_swipes:GetSpecialValueFor("damage_per_stack")
		end
	end

	self.damage_table.damage = (keys.original_damage + fury_swipes_damage) * self.splash_damage_percent * 0.01
	
	local enemies = FindUnitsInRadius(keys.attacker:GetTeamNumber(), target_loc, nil, self.splash_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for i, enemy in pairs(enemies) do
		if enemy and not enemy:IsNull() and not enemy:IsAttackImmune() and not enemy:IsInvulnerable() and enemy:IsAlive() then
			
			-- splash modifier
			if enemy ~= keys.target then
				self.damage_table.victim = enemy
				ApplyDamage(self.damage_table)
			end

			-- frost modifier, we use the same aoe as splash damage because performance
			if self.ability_level >= 2 then
				enemy:AddNewModifier(keys.attacker, ability, "modifier_dragon_knight_frost_breath_slow_lua", {duration = self.frost_duration})
			end

		end
	end

end


-- rewritten to not use particles
LinkLuaModifier( "modifier_dragon_knight_corrosive_breath_dot_lua", "heroes/hero_dragon_knight/dragon_knight_elder_dragon_form_lua", LUA_MODIFIER_MOTION_NONE )

modifier_dragon_knight_corrosive_breath_dot_lua = class({})
function modifier_dragon_knight_corrosive_breath_dot_lua:IsHidden() return false end
function modifier_dragon_knight_corrosive_breath_dot_lua:IsPurgable() return true end
function modifier_dragon_knight_corrosive_breath_dot_lua:IsDebuff() return true end

function modifier_dragon_knight_corrosive_breath_dot_lua:OnCreated()
	if not IsServer() then return end
	local parent = self:GetParent()
	local caster = self:GetCaster()
	local ability = self:GetAbility()

	if not caster or caster:IsNull() then return end
	if not parent or parent:IsNull() then return end
	if not ability or ability:IsNull() then return end

	local ability_level = ability:GetLevel() - 1
	if caster:HasScepter() then
		ability_level = ability_level + 1
	end

	self.corrosive_breath_damage = ability:GetLevelSpecialValueFor("corrosive_breath_damage", ability_level)

	--self:OnIntervalThink()
	self:StartIntervalThink(1.0)
end

function modifier_dragon_knight_corrosive_breath_dot_lua:OnIntervalThink()
	if not IsServer() then return end
	local parent = self:GetParent()
	local caster = self:GetCaster()
	local ability = self:GetAbility()

	if not caster or caster:IsNull() then return end
	if not parent or parent:IsNull() then return end
	if not ability or ability:IsNull() then return end

	ApplyDamage({victim = parent, attacker = caster, damage = self.corrosive_breath_damage, damage_type = DAMAGE_TYPE_MAGICAL})
end


-- rewritten to not use particles
LinkLuaModifier( "modifier_dragon_knight_frost_breath_slow_lua", "heroes/hero_dragon_knight/dragon_knight_elder_dragon_form_lua", LUA_MODIFIER_MOTION_NONE )

modifier_dragon_knight_frost_breath_slow_lua = class({})
function modifier_dragon_knight_frost_breath_slow_lua:IsHidden() return false end
function modifier_dragon_knight_frost_breath_slow_lua:IsPurgable() return false end
function modifier_dragon_knight_frost_breath_slow_lua:IsDebuff() return true end
function modifier_dragon_knight_frost_breath_slow_lua:IsBuff() return false end

function modifier_dragon_knight_frost_breath_slow_lua:OnCreated()
	if not IsServer() then return end
	local parent = self:GetParent()
	local caster = self:GetCaster()
	local ability = self:GetAbility()

	if not caster or caster:IsNull() then return end
	if not parent or parent:IsNull() then return end
	if not ability or ability:IsNull() then return end

	local ability_level = ability:GetLevel() - 1
	if caster:HasScepter() then
		ability_level = ability_level + 1
	end

	self.frost_bonus_movement_speed = ability:GetLevelSpecialValueFor("frost_bonus_movement_speed", ability_level)
	self.frost_bonus_attack_speed = ability:GetLevelSpecialValueFor("frost_bonus_attack_speed", ability_level)
end

function modifier_dragon_knight_frost_breath_slow_lua:OnRefresh()
	self:OnCreated()
end

function modifier_dragon_knight_frost_breath_slow_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end

function modifier_dragon_knight_frost_breath_slow_lua:GetModifierAttackSpeedBonus_Constant()
	return self.frost_bonus_attack_speed
end

function modifier_dragon_knight_frost_breath_slow_lua:GetModifierMoveSpeedBonus_Percentage()
	return self.frost_bonus_movement_speed
end