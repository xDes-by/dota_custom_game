item_skull_basher_lua = item_skull_basher_lua or class({})
LinkLuaModifier("modifier_item_skull_basher_lua", "items/skull_basher", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_skull_basher_lua_unique", "items/skull_basher", LUA_MODIFIER_MOTION_NONE)

function item_skull_basher_lua:GetIntrinsicModifierName()
	return "modifier_item_skull_basher_lua"
end

modifier_item_skull_basher_lua = modifier_item_skull_basher_lua or class({})

function modifier_item_skull_basher_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_skull_basher_lua:IsHidden() return true end
function modifier_item_skull_basher_lua:IsDebuff() return false end
function modifier_item_skull_basher_lua:IsPurgable() return false end
function modifier_item_skull_basher_lua:RemoveOnDeath() return false end
function modifier_item_skull_basher_lua:IsPermanent() return true end

function modifier_item_skull_basher_lua:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()	
	
	-- Ability specials
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_strength = self:GetAbility():GetSpecialValueFor("bonus_strength")	

	-- Add the unique bash modifier if it doesn't exist yet
	if IsServer() then
		if not self.caster:HasModifier("modifier_item_skull_basher_lua_unique") then
			self.caster:AddNewModifier(self.caster, self.ability, "modifier_item_skull_basher_lua_unique", {})
		end
	end
end

function modifier_item_skull_basher_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
	return funcs
end

function modifier_item_skull_basher_lua:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_item_skull_basher_lua:GetModifierBonusStats_Strength()
	return self.bonus_strength
end

function modifier_item_skull_basher_lua:OnDestroy()
	if IsServer() then
		Timers:CreateTimer(0, function()
			if not self.caster or self.caster:IsNull() then return end
			
			-- If that's the last stackable Skull Basher modifier, remove the unique modifier
			self.caster:RemoveAllModifiersOfName("modifier_item_skull_basher_lua_unique")
			
			local basher = self.caster:FindItem("item_skull_basher_lua", true)

			if basher then
				self.caster:AddNewModifier(self.caster, basher, "modifier_item_skull_basher_lua_unique", nil)
			end
		end)
	end
end

modifier_item_skull_basher_lua_unique = modifier_item_skull_basher_lua_unique or class({})

function modifier_item_skull_basher_lua_unique:IsHidden() return true end
function modifier_item_skull_basher_lua_unique:IsDebuff() return false end
function modifier_item_skull_basher_lua_unique:IsPurgable() return false end
function modifier_item_skull_basher_lua_unique:RemoveOnDeath() return false end
function modifier_item_skull_basher_lua_unique:IsPermanent() return true end

function modifier_item_skull_basher_lua_unique:OnCreated()
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


function modifier_item_skull_basher_lua_unique:DeclareFunctions()
	local funcs = {MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL}
	return funcs
end

function modifier_item_skull_basher_lua_unique:GetModifierProcAttack_BonusDamage_Physical(keys)
	if not IsServer() then return end
	if not self.ability or self.ability:IsNull() then return end
	
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

	-- if the wielder also has Abyssal blade, do nothing
	if self.caster:HasModifier("modifier_item_abyssal_blade_lua_unique") then return end	

	-- If the target is a building or a ward, do nothing	
	if target:IsBuilding() or target:IsOther() then return end

	-- If ability is on cooldown, do nothing
	if not self.ability:IsCooldownReady() then return end

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
		
		-- Put ability on cooldown
		self.ability:UseResources(false, false, true)

		-- Stun target
		target:AddNewModifier(self.caster, self.ability, "modifier_bashed", {duration = self.bash_duration * (1 - target:GetStatusResistance())})

		-- Deal bonus damage
		return self.bonus_chance_damage
	end
end
