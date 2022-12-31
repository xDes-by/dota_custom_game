LinkLuaModifier("modifier_creature_friendship_power", "creatures/abilities/regular/creature_friendship_power", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_friendship_power_attack_animation", "creatures/abilities/regular/creature_friendship_power", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_friendship_power_buff", "creatures/abilities/regular/creature_friendship_power", LUA_MODIFIER_MOTION_NONE)

creature_friendship_power = class({})

function creature_friendship_power:GetIntrinsicModifierName()
	return "modifier_creature_friendship_power"
end



modifier_creature_friendship_power = class({})

function modifier_creature_friendship_power:IsHidden() return true end
function modifier_creature_friendship_power:IsDebuff() return false end
function modifier_creature_friendship_power:IsPurgable() return false end
function modifier_creature_friendship_power:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creature_friendship_power:OnCreated(keys)
	if IsServer() then
		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		self.as_per_second = self:GetAbility():GetSpecialValueFor("as_per_second")
		self.duration = self:GetAbility():GetSpecialValueFor("duration")
		self.end_knockback = self:GetAbility():GetSpecialValueFor("end_knockback")

		self:StartIntervalThink(1.0)
	end
end

function modifier_creature_friendship_power:OnIntervalThink()
	local parent = self:GetParent()

	if parent then
		local allies = FindUnitsInRadius(parent:GetTeam(), parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, ally in pairs(allies) do
			if ally ~= parent then
				local buff_modifier = ally:FindModifierByName("modifier_creature_friendship_power_buff") or
				ally:AddNewModifier(parent, self:GetAbility(), "modifier_creature_friendship_power_buff", {duration = self.duration, end_knockback = self.end_knockback, radius = self.radius})

				if buff_modifier then
					buff_modifier:SetStackCount(buff_modifier:GetStackCount() + self.as_per_second)

					ally:EmitSound("Furryfish.Amp")

					local powerup_pfx = ParticleManager:CreateParticle("particles/econ/events/spring_2021/hero_levelup_spring_2021_flash_hit_magic.vpcf", PATTACH_ABSORIGIN_FOLLOW, ally)
					ParticleManager:SetParticleControl(powerup_pfx, 0, ally:GetAbsOrigin())
					ParticleManager:ReleaseParticleIndex(powerup_pfx)
				end
			end
		end
	end
end

function modifier_creature_friendship_power:DeclareFunctions()
	if IsServer() then return { MODIFIER_EVENT_ON_ATTACK_START } end
end

function modifier_creature_friendship_power:OnAttackStart(keys)
	if keys.attacker and keys.attacker == self:GetParent() then
		keys.attacker:AddNewModifier(keys.attacker, nil, "modifier_creature_friendship_power_attack_animation", {duration = 0.2})
	end
end



modifier_creature_friendship_power_buff = class({})

function modifier_creature_friendship_power_buff:IsHidden() return false end
function modifier_creature_friendship_power_buff:IsDebuff() return false end
function modifier_creature_friendship_power_buff:IsPurgable() return false end

function modifier_creature_friendship_power_buff:OnCreated(keys)
	self.end_knockback = keys.end_knockback
	self.radius = keys.radius

	local parent = self:GetParent()
	local caster = self:GetCaster()

	if parent and caster then
		self.power_pfx = ParticleManager:CreateParticle("particles/econ/items/puck/puck_alliance_set/puck_dreamcoil_tether_aproset.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
		ParticleManager:SetParticleControlEnt(self.power_pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 0), false)
		ParticleManager:SetParticleControlEnt(self.power_pfx, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 0), false)
	end

	if IsServer() then self:StartIntervalThink(0.5) end
end

function modifier_creature_friendship_power_buff:OnIntervalThink()
	local parent = self:GetParent()
	local caster = self:GetCaster()

	if (not caster) or (not parent) or (not self.radius) then self:Destroy() end
	
	if (caster:GetAbsOrigin() - parent:GetAbsOrigin()):Length2D() > self.radius then self:Destroy() end
end

function modifier_creature_friendship_power_buff:OnDestroy()
	local parent = self:GetParent()
	local caster = self:GetCaster()

	if self.power_pfx then
		ParticleManager:DestroyParticle(self.power_pfx, false)
		ParticleManager:ReleaseParticleIndex(self.power_pfx)
	end

	if self.end_knockback and parent and caster and parent:IsAlive() then
		local caster_loc = caster:GetAbsOrigin()

		if (caster_loc - parent:GetAbsOrigin()):Length2D() <= 0 then caster_loc = caster_loc + RandomVector(100) end

		local knockback_table = {
			center_x = caster_loc.x,
			center_y = caster_loc.y,
			center_z = caster_loc.z,
			knockback_duration = 0.3,
			knockback_distance = self.end_knockback,
			knockback_height = 0.3 * self.end_knockback,
			should_stun = 0,
			duration = 0.3
		}

		parent:RemoveModifierByName("modifier_knockback")
		parent:AddNewModifier(parent, nil, "modifier_knockback", knockback_table)

		parent:EmitSound("Furryfish.Break")
	end
end

function modifier_creature_friendship_power_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_creature_friendship_power_buff:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount()
end



modifier_creature_friendship_power_attack_animation = class({})

function modifier_creature_friendship_power_attack_animation:IsHidden() return true end
function modifier_creature_friendship_power_attack_animation:IsDebuff() return false end
function modifier_creature_friendship_power_attack_animation:IsPurgable() return false end
function modifier_creature_friendship_power_attack_animation:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creature_friendship_power_attack_animation:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE
	}
end

function modifier_creature_friendship_power_attack_animation:GetOverrideAnimation()
	return ACT_DOTA_DIE
end

function modifier_creature_friendship_power_attack_animation:GetOverrideAnimationRate()
	return 1.5
end
