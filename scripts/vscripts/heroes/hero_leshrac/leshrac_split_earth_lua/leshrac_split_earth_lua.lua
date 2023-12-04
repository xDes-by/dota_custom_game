LinkLuaModifier( "modifier_generic_stunned_lua", "heroes/generic/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_split_earth_intrinsic_lua", "heroes/hero_leshrac/leshrac_split_earth_lua/modifier_leshrac_split_earth_intrinsic_lua", LUA_MODIFIER_MOTION_NONE )

leshrac_split_earth_lua = class({})

function leshrac_split_earth_lua:GetAOERadius()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_leshrac_agi7") then
		return 700
	end
	return self:GetSpecialValueFor("radius")
end
function leshrac_split_earth_lua:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end
function leshrac_split_earth_lua:GetIntrinsicModifierName()
	return "modifier_leshrac_split_earth_intrinsic_lua"
end

function leshrac_split_earth_lua:IsNetherWardStealable()
	return true
end

function leshrac_split_earth_lua:IsHiddenWhenStolen()
	return false
end

function leshrac_split_earth_lua:GetBehavior()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_leshrac_agi7") then
		return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end
end

function leshrac_split_earth_lua:ApplyAbilityOnPoint(point, radius, autoCastState)
	local caster = self:GetCaster()
	local damage = self:GetSpecialValueFor("damage")
	local duration =  self:GetSpecialValueFor("duration")
	local damageTable = {
		victim = nil,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		attacker = caster,
		ability = self
	}
	local npc_dota_hero_leshrac_agi10 = caster:FindAbilityByName("npc_dota_hero_leshrac_agi10")
	local npc_dota_hero_leshrac_str8 = caster:FindAbilityByName("npc_dota_hero_leshrac_str8")
	local leshrac_lightning_storm_lua = caster:FindAbilityByName("leshrac_lightning_storm_lua")
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do
		damageTable.victim = enemy
		if npc_dota_hero_leshrac_agi10 and autoCastState then
			if not self.strokes[enemy] then
				self.strokes[enemy] = 1
			else
				self.strokes[enemy] = self.strokes[enemy] + 1
			end
			damageTable.damage = damage * 2 ^ self.strokes[enemy]
		end
		ApplyDamage(damageTable)
		enemy:AddNewModifier( caster, self, "modifier_generic_stunned_lua", { duration = duration } )
		if npc_dota_hero_leshrac_str8 and leshrac_lightning_storm_lua and leshrac_lightning_storm_lua:GetLevel() > 0 then
			caster:SetCursorCastTarget(enemy)
			leshrac_lightning_storm_lua:OnSpellStart()
		end
	end
	

	self:PlayEffect(point, radius)
end

function leshrac_split_earth_lua:PlayEffect(point, radius)
	local caster = self:GetCaster()
	local sound_cast = "Hero_Leshrac.Split_Earth"
	EmitSoundOn(sound_cast, caster)
	local particle_blast = "particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf"
	local particle_blast_fx = ParticleManager:CreateParticle(particle_blast, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle_blast_fx, 0, point)
	ParticleManager:SetParticleControl(particle_blast_fx, 1, Vector(radius, 0, 0))
	ParticleManager:ReleaseParticleIndex(particle_blast_fx)
end

function leshrac_split_earth_lua:OnSpellStart()
	local caster = self:GetCaster()
	local target_point = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor("radius")

	if caster:FindAbilityByName("npc_dota_hero_leshrac_agi7") and self:GetAutoCastState() then
		local number_of_strokes = 0
		self.strokes = {}
		Timers:CreateTimer(0, function()
			number_of_strokes = number_of_strokes + 1
			local randomAngle = RandomFloat(0, 2 * math.pi)
			local randomRadius = RandomFloat(0, 700)
			local targetPoint = target_point + Vector(math.cos(randomAngle), math.sin(randomAngle), 0) * randomRadius
			self:ApplyAbilityOnPoint(targetPoint, radius, true)
			if number_of_strokes < 10 then
				return 0.5
			end
			return nil
		end)
	elseif caster:FindAbilityByName("npc_dota_hero_leshrac_str6") then
		local number_of_strokes = 0
		Timers:CreateTimer(0, function()
			number_of_strokes = number_of_strokes + 1
			for i = 1, 3 do
				local angle_gaps = 360 / 3
				local qangle = QAngle(0, (i-1)*angle_gaps, 0)
				local direction = (target_point - caster:GetAbsOrigin()):Normalized()
				local spawn_point = target_point + direction * 200
				local mini_blast_center = RotatePosition(target_point, qangle, spawn_point)
				self:ApplyAbilityOnPoint(mini_blast_center, radius + (number_of_strokes-1) * 55, false)
			end
			if caster:FindAbilityByName("npc_dota_hero_leshrac_str9") and number_of_strokes < 3 then
				return 5
			end
			return nil
		end)
	else
		self:ApplyAbilityOnPoint(target_point, radius, false)
	end
end