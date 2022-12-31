LinkLuaModifier("modifier_demonic_conversion_lua", "heroes/hero_enigma/eidolons.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_multicast_grow", "heroes/hero_ogre_magi/modifier_multicast_grow.lua", LUA_MODIFIER_MOTION_NONE)

local spawn_unit_name = {
	"npc_dota_lesser_eidolon",
	"npc_dota_eidolon",
	"npc_dota_greater_eidolon",
	"npc_dota_dire_eidolon",
}

function SpawnEidolon(ability, caster, origin, duration, multicast_factor, spawn_count, can_produce_eidolon, can_refresh_duration)
	local unit_name = spawn_unit_name[ability:GetLevel()]
	local unit = CreateUnitByName(unit_name, origin, true, caster, caster, caster:GetTeam())
	unit:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)
	unit:AddNewModifier(caster, ability, "modifier_demonic_conversion_lua", {duration = duration})
	unit.can_produce_eidolon = can_produce_eidolon
	unit.can_refresh_duration = can_refresh_duration

	local talent_health = caster:FindTalentValue("special_bonus_unique_enigma_7")
	local talent_damage = caster:FindTalentValue("special_bonus_unique_enigma_3")

	unit:SetBaseMaxHealth(unit:GetBaseMaxHealth() + talent_health)
	unit:SetBaseDamageMin(unit:GetBaseDamageMin() + talent_damage)
	unit:SetBaseDamageMax(unit:GetBaseDamageMax() + talent_damage)

	unit:SetBaseMaxHealth(unit:GetBaseMaxHealth() * multicast_factor * spawn_count)
	unit:SetBaseDamageMin(unit:GetBaseDamageMin() * multicast_factor * spawn_count)
	unit:SetBaseDamageMax(unit:GetBaseDamageMax() * multicast_factor * spawn_count)

	unit.original_base_max_health = unit:GetBaseMaxHealth()
	unit.original_base_min_attack = unit:GetBaseDamageMin()
	unit.original_base_max_attack = unit:GetBaseDamageMax()

	unit:SetHealth(unit:GetMaxHealth())

	unit:AddAbility("summon_buff")

	unit.multicast_multiplier = multicast_factor
	unit.spawn_count = spawn_count

	local multicast_modifier = caster:FindModifierByName("modifier_multicast_lua")
	if multicast_factor > 1 and multicast_modifier then
		multicast_modifier:PlaySummonFX(unit, multicast_factor)
	end

	Timers:CreateTimer(0.5, function()
		if not IsValidEntity(unit) or not unit:IsAlive() then return end

		unit.original_damage_min = unit.original_damage_min or unit:GetBaseDamageMin()
		unit.original_damage_max = unit.original_damage_max or unit:GetBaseDamageMax()

		--Set unit damage according to their health
		local round_to = 100 / unit.spawn_count
		local x = math.ceil(unit:GetHealthPercent() / round_to) * round_to / 100
		unit:SetBaseDamageMin(unit.original_damage_min * x)
		unit:SetBaseDamageMax(unit.original_damage_max * x)

		return 0.5
	end)

	return unit
end



---@class modifier_demonic_conversion_lua:CDOTA_Modifier_Lua
modifier_demonic_conversion_lua = class({})

function modifier_demonic_conversion_lua:IsPurgable() return false end
function modifier_demonic_conversion_lua:IsDebuff() return true end


function modifier_demonic_conversion_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_LIFETIME_FRACTION,
		MODIFIER_EVENT_ON_ATTACK
	}
end

function modifier_demonic_conversion_lua:GetUnitLifetimeFraction( params )
    return (self:GetDieTime() - GameRules:GetGameTime()) / self:GetDuration()
end

function modifier_demonic_conversion_lua:OnCreated(kv)
	self.split_attack_count = self:GetAbility():GetSpecialValueFor("split_attack_count")
	self.life_extension = self:GetAbility():GetSpecialValueFor("life_extension")
	self.attack_counter = 0
end

function modifier_demonic_conversion_lua:OnDestroy()
    if IsServer() then
    	self:GetParent():ForceKill(false)
    end
end

function modifier_demonic_conversion_lua:OnAttack(event)
	local parent = self:GetParent()
	if event.attacker == parent and (parent.can_refresh_duration or parent.can_produce_eidolon) then
		if self.attack_counter >= self.split_attack_count then
			
			local caster = self:GetCaster()
			local ability = self:GetAbility()

			if not ability then return end

			local unit_name = parent:GetUnitName()
			local origin = parent:GetAbsOrigin()

			parent:SetHealth(parent:GetMaxHealth())

			local duration = self:GetRemainingTime() + self.life_extension

			if parent.can_refresh_duration then
				parent.can_refresh_duration = false
				self:SetDuration(self:GetDuration(), true)
			else	
				self:SetDuration(duration, true)
			end


			if parent.can_produce_eidolon then
				parent.can_produce_eidolon = false

				local multicast = parent.multicast_multiplier or 1
				local spawn_count = parent.spawn_count or 1
				SpawnEidolon(ability, caster, origin, duration, multicast, spawn_count, false, false)
				ResolveNPCPositions(origin, 128)
			end

			
		end

		if event.target:GetTeam() ~= parent:GetTeam() and not event.target:IsBuilding() then
			self.attack_counter = self.attack_counter + 1
		end
	end
end