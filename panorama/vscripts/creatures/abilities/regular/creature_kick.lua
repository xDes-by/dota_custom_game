LinkLuaModifier("modifier_creature_kick", "creatures/abilities/regular/creature_kick", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_kick_motion", "creatures/abilities/regular/creature_kick", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_modifier_creature_kick_attack_animation", "creatures/abilities/regular/creature_kick", LUA_MODIFIER_MOTION_NONE)

creature_kick = class({})

function creature_kick:GetIntrinsicModifierName()
	return "modifier_creature_kick"
end

modifier_creature_kick = class({})

function modifier_creature_kick:IsHidden() return true end
function modifier_creature_kick:IsDebuff() return false end
function modifier_creature_kick:IsPurgable() return false end
function modifier_creature_kick:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_creature_kick:RemoveOnDeath() return false end

function modifier_creature_kick:OnCreated(keys)
	self:OnRefresh(keys)
end

function modifier_creature_kick:OnRefresh(keys)
	self.ability = self:GetAbility()

	self.distance = self.ability:GetSpecialValueFor("distance")
	self.speed = self.ability:GetSpecialValueFor("speed")
	self.damage = self.ability:GetSpecialValueFor("damage")
end

function modifier_creature_kick:DeclareFunctions()
	if IsServer() then
		return {
			MODIFIER_EVENT_ON_ATTACK_START,
			MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
		}
	end
end

function modifier_creature_kick:OnAttackStart(keys)
	if keys.attacker and keys.attacker == self:GetParent() then
		keys.attacker:AddNewModifier(keys.attacker, nil, "modifier_modifier_creature_kick_attack_animation", {duration = 0.4})
		keys.attacker:SetAngles(25, 0, 0)
	end
end

function modifier_creature_kick:GetModifierProcAttack_Feedback(keys)
	keys.attacker:SetAngles(0, 0, 0)
	if keys.attacker and keys.target and self.ability and self.ability:IsCooldownReady() then
		self.ability:UseResources(true, true, true)

		keys.target:EmitSound("Donkey.Kick")

		ApplyDamage({victim = keys.target, attacker = keys.attacker, damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL})

		if keys.attacker.spawn_team  and GameMode.arena_centers[keys.attacker.spawn_team] then
			local arena_center = GameMode.arena_centers[keys.attacker.spawn_team]
			local knockback_origin = keys.attacker:GetAbsOrigin()
			local duration = self.distance / self.speed

			local knockback_table = {
				center_x = knockback_origin.x,
				center_y = knockback_origin.y,
				center_z = knockback_origin.z,
				knockback_duration = duration,
				knockback_distance = self.distance,
				knockback_height = 0,
				should_stun = 1,
				duration = duration
			}

			keys.target:RemoveModifierByName("modifier_knockback")
			keys.target:AddNewModifier(keys.attacker, nil, "modifier_knockback", knockback_table)

			local knockback_direction = (keys.target:GetAbsOrigin() - knockback_origin):Normalized()
			local bounce_table = {duration = duration, direction_x = knockback_direction.x, direction_y = knockback_direction.y, arena_x = arena_center.x, arena_y = arena_center.y}
			keys.target:AddNewModifier(keys.attacker, self.ability, "modifier_creature_kick_motion", bounce_table)

			if keys.attacker:FindAbilityByName("creature_charge") then
				keys.attacker:FindAbilityByName("creature_charge"):EndCooldown()
			end
		end
	end	
end



modifier_modifier_creature_kick_attack_animation = class({})

function modifier_modifier_creature_kick_attack_animation:IsHidden() return true end
function modifier_modifier_creature_kick_attack_animation:IsDebuff() return false end
function modifier_modifier_creature_kick_attack_animation:IsPurgable() return false end
function modifier_modifier_creature_kick_attack_animation:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_modifier_creature_kick_attack_animation:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE
	}
end

function modifier_modifier_creature_kick_attack_animation:GetOverrideAnimation()
	return ACT_DOTA_IDLE_RARE
end

function modifier_modifier_creature_kick_attack_animation:GetOverrideAnimationRate()
	return 2.5
end



modifier_creature_kick_motion = class({})

function modifier_creature_kick_motion:IsHidden() return true end
function modifier_creature_kick_motion:IsDebuff() return true end
function modifier_creature_kick_motion:IsPurgable() return false end

function modifier_creature_kick_motion:OnCreated(keys)
	if IsClient() then return end

	self.ability = self:GetAbility()

	if (not self.ability) or self.ability:IsNull() then
		self:Destroy()
		return
	end
 
	self.distance = self.ability:GetSpecialValueFor("distance")
	self.duration = self.distance / self.ability:GetSpecialValueFor("speed")

	self.arena_center = Vector(keys.arena_x, keys.arena_y, 0)
	self.current_direction = Vector(keys.direction_x, keys.direction_y, 0)

	local arena_size = {}
	arena_size["ffa"] = Vector(680, 700, 0)
	arena_size["demo"] = Vector(680, 700, 0)
	arena_size["duos"] = Vector(1000, 740, 0)

	self.arena_lower = self.arena_center - arena_size[GetMapName()]
	self.arena_upper = self.arena_center + arena_size[GetMapName()]

	self:StartIntervalThink(0.03)
end

function modifier_creature_kick_motion:OnIntervalThink()
	local parent = self:GetParent()

	if (not parent) or parent:IsNull() or (not parent:IsAlive()) then
		self:Destroy()
		return
	end

	local current_loc = parent:GetAbsOrigin()
	local new_knockback = false

	GridNav:DestroyTreesAroundPoint(current_loc, 150, true)

	if current_loc.x < self.arena_lower.x and self.current_direction.x < 0 then
		new_knockback = true
		self.current_direction = Vector((-1) * self.current_direction.x, self.current_direction.y, 0)
		parent:SetAbsOrigin(Vector(self.arena_lower.x, parent:GetAbsOrigin().y, 0))
	elseif current_loc.x > self.arena_upper.x and self.current_direction.x > 0 then
		new_knockback = true
		self.current_direction = Vector((-1) * self.current_direction.x, self.current_direction.y, 0)
		parent:SetAbsOrigin(Vector(self.arena_upper.x, parent:GetAbsOrigin().y, 0))
	end

	if current_loc.y < self.arena_lower.y and self.current_direction.y < 0 then
		new_knockback = true
		self.current_direction = Vector(self.current_direction.x, (-1) * self.current_direction.y, 0)
		parent:SetAbsOrigin(Vector(parent:GetAbsOrigin().x, self.arena_lower.y, 0))
	elseif current_loc.y > self.arena_upper.y and self.current_direction.y > 0 then
		new_knockback = true
		self.current_direction = Vector(self.current_direction.x, (-1) * self.current_direction.y, 0)
		parent:SetAbsOrigin(Vector(parent:GetAbsOrigin().x, self.arena_upper.y, 0))
	end

	if new_knockback then
		local current_duration = self:GetRemainingTime()
		local current_distance = self.distance * current_duration / self.duration
		local origin = current_loc - 100 * self.current_direction

		local knockback_table = {
			center_x = origin.x,
			center_y = origin.y,
			center_z = origin.z,
			knockback_duration = current_duration,
			knockback_distance = current_distance,
			knockback_height = 0,
			should_stun = 1,
			duration = current_duration
		}

		parent:RemoveModifierByName("modifier_knockback")
		parent:AddNewModifier(parent, nil, "modifier_knockback", knockback_table)

		parent:EmitSound("Donkey.Bounce")
	end
end

function modifier_creature_kick_motion:OnDestroy()
	if IsClient() then return end

	local parent = self:GetParent()

	if (not parent) or parent:IsNull() or (not parent:IsAlive()) then
		self:Destroy()
		return
	end

	parent:RemoveModifierByName("modifier_knockback")
	ResolveNPCPositions(parent:GetAbsOrigin(), 128)
end
