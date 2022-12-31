item_abyssal_blade_lua = item_abyssal_blade_lua or class({})
LinkLuaModifier("modifier_item_abyssal_blade_lua", "items/abyssal_blade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_abyssal_blade_lua_unique", "items/abyssal_blade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_abyssal_blade_lua_bash_cooldown", "items/abyssal_blade", LUA_MODIFIER_MOTION_NONE)

function item_abyssal_blade_lua:GetIntrinsicModifierName()
	return "modifier_item_abyssal_blade_lua"
end

function item_abyssal_blade_lua:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()	
	local target = self:GetCursorTarget()
	local sound_blink = "Item.AbyssalBlade.Blink"
	local sound_cast = "DOTA_Item.AbyssalBlade.Activate"
	local particle_cast = "particles/items_fx/abyssal_blade.vpcf"

	local distance = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D()
	local direction = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()	
	local hull_radius = target:GetHullRadius()

	-- Ability specials
	local bash_cooldown = self:GetSpecialValueFor("bash_cooldown")
	local stun_duration = self:GetSpecialValueFor("stun_duration")

	-- Check for Linken's Sphere
	if target:GetTeamNumber() ~= caster:GetTeamNumber() then
		if target:TriggerSpellAbsorb(self) then return end
	end

	-- Play blink sound
	caster:EmitSound(sound_blink)

	-- Move the caster towards the target
	local blink_point = caster:GetAbsOrigin() + direction * (distance - hull_radius - 75)
	
	-- Order caster to attack the target
	ExecuteOrderFromTable({
			UnitIndex = caster:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = target:entindex()
		})

	-- Clean positions to make sure unit doesn't get stuck when teleporting
	FindClearSpaceForUnit(caster, blink_point, true)
	ResolveNPCPositions(blink_point, caster:GetHullRadius())

	-- Play cast sound
	caster:EmitSound(sound_cast)

	-- Create particle
	local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(particle_cast_fx, 0, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_cast_fx)

	-- Stun target
	target:AddNewModifier(caster, self, "modifier_bashed", {
		duration = stun_duration * (1 - target:GetStatusResistance())
	})

	-- Trigger bash cooldown to the caster
	caster:AddNewModifier(caster, self, "modifier_item_abyssal_blade_lua_bash_cooldown", {duration = bash_cooldown})
end

-----------------------
-- STACKING MODIFIER --
-----------------------

modifier_item_abyssal_blade_lua = modifier_item_abyssal_blade_lua or class({})

function modifier_item_abyssal_blade_lua:IsHidden() return true end
function modifier_item_abyssal_blade_lua:IsDebuff() return false end
function modifier_item_abyssal_blade_lua:IsPurgable() return false end
function modifier_item_abyssal_blade_lua:RemoveOnDeath() return false end
function modifier_item_abyssal_blade_lua:IsPermanent() return true end
function modifier_item_abyssal_blade_lua:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_abyssal_blade_lua:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()	

	-- Ability specials
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	self.bonus_health = self.ability:GetSpecialValueFor("bonus_health")
	self.bonus_health_regen = self.ability:GetSpecialValueFor("bonus_health_regen")
	self.block_damage_melee = self.ability:GetSpecialValueFor("block_damage_melee")
	self.block_damage_ranged = self.ability:GetSpecialValueFor("block_damage_ranged")
	self.block_chance = self.ability:GetSpecialValueFor("block_chance")
	self.bonus_strength = self.ability:GetSpecialValueFor("bonus_strength")

	-- Unique modifier
	if IsServer() then
		if not self.caster:HasModifier("modifier_item_abyssal_blade_lua_unique") then
			self.caster:AddNewModifier(self.caster, self.ability, "modifier_item_abyssal_blade_lua_unique", {})
		end
	end
end

function modifier_item_abyssal_blade_lua:DeclareFunctions()
	local funcs = {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
				   MODIFIER_PROPERTY_HEALTH_BONUS,
				   MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
				   MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
				   MODIFIER_PROPERTY_STATS_STRENGTH_BONUS}
	return funcs
end

function modifier_item_abyssal_blade_lua:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_item_abyssal_blade_lua:GetModifierHealthBonus()
	return self.bonus_health
end

function modifier_item_abyssal_blade_lua:GetModifierConstantHealthRegen()
	return self.bonus_health_regen
end

function modifier_item_abyssal_blade_lua:GetModifierPhysical_ConstantBlock()
	if RollPseudoRandomPercentage(self.block_chance, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_1, self.caster) then
		local block_damage
		if self.caster:IsRangedAttacker() then
			block_damage = self.block_damage_ranged
		else
			block_damage = self.block_damage_melee
		end
		
		return block_damage
	end	
end

function modifier_item_abyssal_blade_lua:GetModifierBonusStats_Strength()
	return self.bonus_strength
end

function modifier_item_abyssal_blade_lua:OnDestroy()
	if IsServer() then
		if not self.caster or self.caster:IsNull() then return end
		-- If that's the last stackable Abyssal Blade modifier, remove the unique modifier
		if not self.caster:HasModifier("modifier_item_abyssal_blade_lua") then
			self.caster:RemoveModifierByName("modifier_item_abyssal_blade_lua_unique")
		end
	end
end


modifier_item_abyssal_blade_lua_unique = modifier_item_abyssal_blade_lua_unique or class({})

function modifier_item_abyssal_blade_lua_unique:IsHidden() return true end
function modifier_item_abyssal_blade_lua_unique:IsDebuff() return false end
function modifier_item_abyssal_blade_lua_unique:IsPurgable() return false end
function modifier_item_abyssal_blade_lua_unique:RemoveOnDeath() return false end
function modifier_item_abyssal_blade_lua_unique:IsPermanent() return true end

function modifier_item_abyssal_blade_lua_unique:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()	

	-- Doesn't work on illusions
	if self.caster and self.caster:IsIllusion() then self:Destroy() end

	-- Ability specials
	self.bash_chance_melee = self.ability:GetSpecialValueFor("bash_chance_melee")
	self.bash_chance_ranged = self.ability:GetSpecialValueFor("bash_chance_ranged")
	self.bash_duration = self.ability:GetSpecialValueFor("bash_duration")
	self.bash_cooldown = self.ability:GetSpecialValueFor("bash_cooldown")
	self.bonus_chance_damage = self.ability:GetSpecialValueFor("bonus_chance_damage")
end

function modifier_item_abyssal_blade_lua_unique:DeclareFunctions()
	local funcs = {MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL}
	return funcs
end

function modifier_item_abyssal_blade_lua_unique:GetModifierProcAttack_BonusDamage_Physical(keys)
	if not IsServer() then return end
	local target = keys.target
	local forbidden_abilities = 
	{
		"slardar_bash",
		"faceless_void_time_lock_lua",
		"spirit_breaker_greater_bash"
	}

	-- If the caster has any of the forbidden abilities, do nothing
	for _, forbidden_ability in pairs(forbidden_abilities) do
		if self.caster:HasAbility(forbidden_ability) then
			if self.caster:FindAbilityByName(forbidden_ability):IsTrained() then return end
		end
	end	

	-- If the target isn't a unit (e.g. item container), do nothing
	if not target:IsBaseNPC() then return end		

	-- If the target is a building or a ward, do nothing	
	if target:IsBuilding() or target:IsOther() then return end

	-- If cooldown modifier exists, do nothing
	if self.caster:HasModifier("modifier_item_abyssal_blade_lua_bash_cooldown") then return end

	-- Determine proc chance based on melee or ranged
	local chance
	if self.caster:IsRangedAttacker() then
		chance = self.bash_chance_ranged
	else
		chance = self.bash_chance_melee
	end		
	
	-- Roll psuedo random chance for bash
	if RollPseudoRandomPercentage(chance, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_1, self.caster) then

		-- Play impact sound
		target:EmitSound("DOTA_Item.SkullBasher")
		
		-- Add cooldown modifier
		self.caster:AddNewModifier(self.caster, self.ability, "modifier_item_abyssal_blade_lua_bash_cooldown", {duration = self.bash_cooldown})

		-- Stun target
		target:AddNewModifier(self.caster, self.ability, "modifier_bashed", {
			duration = self.bash_duration * (1 - target:GetStatusResistance())
		})

		-- Deal bonus damage
		return self.bonus_chance_damage
	end
end

modifier_item_abyssal_blade_lua_bash_cooldown = modifier_item_abyssal_blade_lua_bash_cooldown or class({})

function modifier_item_abyssal_blade_lua_bash_cooldown:IsHidden() return true end
function modifier_item_abyssal_blade_lua_bash_cooldown:IsPurgable() return false end
function modifier_item_abyssal_blade_lua_bash_cooldown:IsDebuff() return false end
function modifier_item_abyssal_blade_lua_bash_cooldown:RemoveOnDeath() return false end
