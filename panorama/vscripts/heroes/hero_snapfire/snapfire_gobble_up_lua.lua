snapfire_gobble_up_lua = class({})
LinkLuaModifier("snapfire_gobble_up_lua_caster", "heroes/hero_snapfire/snapfire_gobble_up_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("snapfire_gobble_up_lua_target", "heroes/hero_snapfire/snapfire_gobble_up_lua", LUA_MODIFIER_MOTION_NONE)

function snapfire_gobble_up_lua:Spawn()
	if IsServer() then
		self:SetActivated(true)
		if not self:GetCaster():HasScepter() then
			self:SetHidden(true)
			self:SetActivated(false)
		end
    end
end

-- Aghs interactions
function snapfire_gobble_up_lua:OnInventoryContentsChanged()
	if self:GetCaster():HasScepter() then
		if self.currently_held == nil then
			self:SetActivated(true)
		end
		self:SetHidden(false)
	else
		self:SetActivated(false)
		self:SetHidden(true)
	end
end

-- Gobble Up Targeting:
-- Any friendly unit and hero
-- Enemy units (not heroes)
function snapfire_gobble_up_lua:CastFilterResultTarget(target)
	local caster = self:GetCaster()

	local is_enemy = caster:GetTeamNumber() ~= target:GetTeamNumber()
	if target:IsHero() and is_enemy then
		return UF_FAIL_HERO
	end

	if target:IsConsideredHero() and is_enemy then
		return UF_FAIL_CONSIDERED_HERO
	end

	if target == caster then return UF_FAIL_FRIENDLY end
	return UF_SUCCESS
end

-- These are the names of the enemy units that should not die after being gobbled or shot
-- Very Hard Exceptions
snapfire_gobble_up_lua.death_exception = {
	"npc_dota_lone_druid_bear1",
	"npc_dota_lone_druid_bear2",
	"npc_dota_lone_druid_bear3",
	"npc_dota_lone_druid_bear4" 
}

function snapfire_gobble_up_lua:IsDeathException(unit)
	-- If friendly hero, should not die
	if unit:GetTeam() == self:GetCaster():GetTeam() and unit:IsRealHero() then return true end

	-- Add more exceptions here
	if unit:IsAncient() then return true end

	for _,name in pairs(self.death_exception) do
		if unit:GetUnitName() == name then return true end
	end

	return false
end

function snapfire_gobble_up_lua:OnSpellStart()
	if not IsServer() then return end

	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local belly_duration = self:GetSpecialValueFor("max_time_in_belly")

	caster:EmitSound("Hero_Snapfire.GobbleUp.Cast")
	ProjectileManager:ProjectileDodge(target) -- Don't ask why

	local devour_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_bringer_devour.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(devour_pfx, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(devour_pfx, 1, caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(devour_pfx)

	caster:AddNewModifier(caster, self, "snapfire_gobble_up_lua_caster", {duration = belly_duration})
	target:AddNewModifier(caster, self, "snapfire_gobble_up_lua_target", {duration = belly_duration})

	-- Define the target inside the caster
	self.currently_held = target

	-- Ability Activation Logic
	self:SetActivated(false)
	if caster:HasAbility("snapfire_spit_creep_lua") then
		caster:FindAbilityByName("snapfire_spit_creep_lua"):SetActivated(true)
	end
end

-- Helper gobble functions
-- While target is inside
snapfire_gobble_up_lua_caster = class({})
snapfire_gobble_up_lua_target = class({})

function snapfire_gobble_up_lua_caster:OnCreated()
	if IsClient() then return end
	local infest_overhead_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infested_unit.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	self:AddParticle(infest_overhead_particle, false, false, -1, true, false)
end

function snapfire_gobble_up_lua_caster:OnRemoved()
	if IsClient() then return end

	local ability = self:GetAbility()
	local abilitySub = self:GetParent():FindAbilityByName("snapfire_spit_creep_lua")

	-- Makes ability usable again... If it still exists
	if ability then
		ability.currently_held = nil
		if self:GetCaster():HasScepter() then
			ability:SetActivated(true)
		end
	end
	if abilitySub then
		abilitySub:SetActivated(false)
	end
end

function snapfire_gobble_up_lua_target:OnCreated()
	if IsClient() then return end

	-- Define now to prevent some bug where caster removes Mortimer Kisses during gobble
	self.is_death_exception = self:GetAbility():IsDeathException(self:GetParent())

	self:GetParent():AddNoDraw()
	self:StartIntervalThink(0.1)
end

function snapfire_gobble_up_lua_target:OnRemoved()
	if IsClient() then return end
	self:GetParent():RemoveNoDraw()

	-- Unit should immediately die if it hasn't been shot yet
	if not self.is_death_exception and not self:GetParent():HasModifier("snapfire_spit_creep_lua_movement") then
		self:GetParent():Kill(self:GetAbility(), self:GetCaster())
	end
end

-- Unit moves with caster. Useful for aura interactions
function snapfire_gobble_up_lua_target:OnIntervalThink()
	self:GetParent():SetAbsOrigin(self:GetCaster():GetAbsOrigin())
end

function snapfire_gobble_up_lua_target:CheckState()
	return {[MODIFIER_STATE_ATTACK_IMMUNE] = true,
			[MODIFIER_STATE_MAGIC_IMMUNE] = true,
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			[MODIFIER_STATE_UNSELECTABLE] = true,
			[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
			[MODIFIER_STATE_OUT_OF_GAME] = true,
			[MODIFIER_STATE_DISARMED] = true,
			[MODIFIER_STATE_SILENCED] = true,
			[MODIFIER_STATE_MUTED] = true,}
end
