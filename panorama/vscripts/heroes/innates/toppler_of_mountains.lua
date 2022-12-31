innate_toppler_of_mountains = class({})

LinkLuaModifier("modifier_innate_toppler_of_mountains", "heroes/innates/toppler_of_mountains", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_innate_toppler_of_mountains_cooldown", "heroes/innates/toppler_of_mountains", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_big_game_hunter_target", "heroes/innates/toppler_of_mountains", LUA_MODIFIER_MOTION_NONE)

function innate_toppler_of_mountains:GetIntrinsicModifierName()
	return "modifier_innate_toppler_of_mountains"
end





modifier_innate_toppler_of_mountains = class({})

function modifier_innate_toppler_of_mountains:IsHidden() return true end
function modifier_innate_toppler_of_mountains:IsDebuff() return false end
function modifier_innate_toppler_of_mountains:IsPurgable() return false end
function modifier_innate_toppler_of_mountains:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end


function modifier_innate_toppler_of_mountains:OnCreated(keys)
	self:OnRefresh(keys)
	self:SeekTarget()
end


function modifier_innate_toppler_of_mountains:OnRefresh(keys)
	if IsClient() then return end

	local ability = self:GetAbility()
	if (not ability) or ability:IsNull() then return end

	self.max_health_as_damage = 0.01 * ability:GetSpecialValueFor("max_health_as_damage") or 0
	self.damage_cooldown = ability:GetSpecialValueFor("damage_cooldown") or 0
end


function modifier_innate_toppler_of_mountains:OnRoundStart(keys)
	local caster = self:GetCaster()

	-- we can't apply modifiers to invulnerable units
	-- so we have to wait until respective preparation modifiers are removed completely
	Timers:CreateTimer(0.5, function()
		self:SeekTarget()
	end)
end


function modifier_innate_toppler_of_mountains:OnPvpStart(keys)
	local parent = self:GetParent()
	if not parent or parent:IsNull() then return end
	if not PvpManager:IsPvpTeamThisRound(parent:GetTeam()) then return end

	Timers:CreateTimer(0.5, function()
		self:SeekPvpTarget()
	end)
end


function modifier_innate_toppler_of_mountains:SeekPvpTarget()
	local parent = self:GetParent()
	if not parent or parent:IsNull() then return end

	local enemies = FindUnitsInRadius(
		parent:GetTeamNumber(),
		parent:GetAbsOrigin(),
		nil,
		2000,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		0,
		false
	)

	enemies = table.filter_array(enemies, DummyFilterFunc)

	if #enemies == 0 then return end
	local target = enemies[1]

	target:AddNewModifier(parent, nil, "modifier_big_game_hunter_target", {})
end


function modifier_innate_toppler_of_mountains:SeekTarget()
	if not IsServer() then return end

	local caster = self:GetCaster()
	if not IsValidEntity(caster) then return end

	if caster:IsIllusion() then return end
	if not caster:IsRealHero() then return end
	
	local spawner = RoundManager:GetCurrentRound():GetSpawner(caster:GetTeamNumber())
	if not spawner then return end
	if not spawner.max_health_unit or spawner.max_health_unit:IsNull() then return end

	local max_health = spawner.max_health_unit:GetMaxHealth()

	for i, creep in pairs(spawner.current_creeps or {}) do
		if IsValidEntity(creep) and creep:GetMaxHealth() >= max_health then
			local modifier = creep:AddNewModifier(caster, nil, "modifier_big_game_hunter_target", {duration = -1})
		end
	end
end


function modifier_innate_toppler_of_mountains:DeclareFunctions()
	if IsServer() then return { MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE } end
end


function modifier_innate_toppler_of_mountains:GetModifierTotalDamageOutgoing_Percentage(keys)
	if (not keys.target) or (not keys.attacker) or keys.target:IsNull() or keys.attacker:IsNull() then return end
	if not keys.target:HasModifier("modifier_big_game_hunter_target") then return end
	if keys.attacker:GetTeam() == keys.target:GetTeam() then return end

	if keys.target:HasModifier("modifier_innate_toppler_of_mountains_cooldown") then return end

	keys.target:AddNewModifier(keys.attacker, nil, "modifier_innate_toppler_of_mountains_cooldown", {duration = self.damage_cooldown})

	local actual_damage = ApplyDamage({
		victim = keys.target,
		attacker = keys.attacker,
		damage = keys.target:GetMaxHealth() * self.max_health_as_damage,
		damage_type = DAMAGE_TYPE_PURE,
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
	})

	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, keys.target, actual_damage, nil)

	local ground_loc = GetGroundPosition(keys.target:GetAbsOrigin(), keys.target)

	local proc_pfx = ParticleManager:CreateParticle("particles/custom/innates/toppler.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target)
	ParticleManager:SetParticleControlEnt(proc_pfx, 0, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc", ground_loc, false)
	ParticleManager:ReleaseParticleIndex(proc_pfx)
end



modifier_innate_toppler_of_mountains_cooldown = class({})

function modifier_innate_toppler_of_mountains_cooldown:IsHidden() return true end
function modifier_innate_toppler_of_mountains_cooldown:IsDebuff() return true end
function modifier_innate_toppler_of_mountains_cooldown:IsPurgable() return false end
function modifier_innate_toppler_of_mountains_cooldown:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end




modifier_big_game_hunter_target = class({})

function modifier_big_game_hunter_target:IsPurgable() return false end
function modifier_big_game_hunter_target:RemoveOnDeath() return true end
function modifier_big_game_hunter_target:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_big_game_hunter_target:OnCreated()
	if not IsServer() then return end

	local parent = self:GetParent()
	if not IsValidEntity(parent) then return end

	local particle = ParticleManager:CreateParticleForPlayer(
		"particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_shield.vpcf",
		PATTACH_OVERHEAD_FOLLOW,
		parent,
		self:GetCaster():GetPlayerOwner()
	)

	ParticleManager:SetParticleControl(particle, 0, parent:GetAbsOrigin())

	self:AddParticle(particle, true, false, 3, false, true)
end
