---@class invoker_forge_spirit_ad_lua:CDOTA_Ability_Lua
invoker_forge_spirit_ad_lua = class({})
LinkLuaModifier("modifier_forged_spirit_stats_lua", "heroes/hero_invoker/invoker_forge_spirit_ad.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_melting_strike_debuff_lua", "heroes/hero_invoker/invoker_forge_spirit_ad.lua", LUA_MODIFIER_MOTION_NONE)

function invoker_forge_spirit_ad_lua:OnSpellStart()
	local caster = self:GetCaster()
	local origin = caster:GetAbsOrigin() + RandomVector(100)

	self.spirits = self.spirits or {}

	-- Kill off previous spirits on new cast
	for _, spirit in pairs(self.spirits) do
		if spirit and IsValidEntity(spirit) and spirit:IsAlive() then
			spirit:ForceKill(false)
		end
	end

	count = self:GetSpecialValueFor("spirit_count")

	for _ = 1, count do
		local unit = CreateUnitByName("npc_dota_invoker_forged_spirit", origin, true, caster, caster, caster:GetTeam())
		unit:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)
		unit:AddNewModifier(caster, self, "modifier_kill", {duration = self:GetSpecialValueFor("spirit_duration")})

		unit:SetBaseMaxHealth(self:GetSpecialValueFor("spirit_hp"))
		unit:SetBaseDamageMin(self:GetSpecialValueFor("spirit_damage"))
		unit:SetBaseDamageMax(self:GetSpecialValueFor("spirit_damage"))
		unit:SetPhysicalArmorBaseValue(self:GetSpecialValueFor("spirit_armor"))

		unit:AddNewModifier(caster, self, "modifier_forged_spirit_stats_lua", nil)
		unit:SetMana(unit:GetMaxMana())

		unit:FindAbilityByName("forged_spirit_melting_strike"):SetLevel(self:GetLevel())		-- modifier_melting_strike is switched with modifier_melting_strike_lua in declarations.lua

		unit:AddAbility("summon_buff")

		ResolveNPCPositions(unit:GetAbsOrigin(), 64)

		table.insert(self.spirits, unit)
	end
end

---@class modifier_forged_spirit_stats_lua:CDOTA_Modifier_Lua
modifier_forged_spirit_stats_lua = class({})

function modifier_forged_spirit_stats_lua:IsHidden() 
	return true
end

function modifier_forged_spirit_stats_lua:IsPurgable()
	return false
end

function modifier_forged_spirit_stats_lua:IsPermanent()
	return true
end

function modifier_forged_spirit_stats_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACK_RANGE_BASE_OVERRIDE,
		MODIFIER_PROPERTY_EXTRA_MANA_BONUS
	}
end

function modifier_forged_spirit_stats_lua:OnCreated()
	self.attack_range = self:GetAbility():GetSpecialValueFor("spirit_attack_range")
	self.mana = self:GetAbility():GetSpecialValueFor("spirit_mana")
end

function modifier_forged_spirit_stats_lua:GetModifierAttackRangeOverride()
	return self.attack_range
end

function modifier_forged_spirit_stats_lua:GetModifierExtraManaBonus()
	return self.mana-5
end



-- modifier_melting_strike is switched with modifier_melting_strike_lua in declarations.lua

---@class modifier_melting_strike_lua:CDOTA_Modifier_Lua
modifier_melting_strike_lua = class({})

function modifier_melting_strike_lua:IsHidden() return true end
function modifier_melting_strike_lua:IsPurgable() return false end
function modifier_melting_strike_lua:IsPermanent() return true end

function modifier_melting_strike_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}
end

function modifier_melting_strike_lua:OnCreated()
	if not IsServer() then return end

	local ability = self:GetAbility()
	if not ability or ability:IsNull() then return end
	self.duration = ability:GetSpecialValueFor("duration")
end

function modifier_melting_strike_lua:GetModifierProcAttack_Feedback(keys)
	if not IsServer() then return end

	local ability = self:GetAbility()
	if (not keys.attacker) or (not keys.target) or (not ability) or keys.attacker:IsNull() or keys.target:IsNull() or ability:IsNull() then return end

	-- Does not work on friendly targets, buildings, dead or magic immune units
	if keys.attacker:GetTeam() == keys.target:GetTeam() or keys.target:IsBuilding() or (not keys.target:IsAlive()) or keys.target:IsMagicImmune() then return end

	-- Apply the debuff
	keys.target:AddNewModifier(keys.attacker, ability, "modifier_melting_strike_debuff_lua", {duration = self.duration})
end

---@class modifier_melting_strike_debuff_lua:CDOTA_Modifier_Lua
modifier_melting_strike_debuff_lua = class({})

function modifier_melting_strike_debuff_lua:OnCreated()
	self.armor_reduction = self:GetAbility():GetSpecialValueFor("armor_removed")
	self.max_armor_reduction = self:GetAbility():GetSpecialValueFor("max_armor_removed")

	if IsClient() then return end

	self:SetStackCount(1)
end

function modifier_melting_strike_debuff_lua:OnRefresh()
	if IsClient() then return end

	if self.armor_reduction * self:GetStackCount() < self.max_armor_reduction then
		self:IncrementStackCount()
	end
end

function modifier_melting_strike_debuff_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_melting_strike_debuff_lua:GetModifierPhysicalArmorBonus()
	return -math.min(self.armor_reduction * self:GetStackCount(), self.max_armor_reduction)
end
