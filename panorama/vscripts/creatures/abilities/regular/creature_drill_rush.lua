LinkLuaModifier("modifier_creature_drill_rush_cast", "creatures/abilities/regular/creature_drill_rush", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_drill_rush", "creatures/abilities/regular/creature_drill_rush", LUA_MODIFIER_MOTION_NONE)

creature_drill_rush = class({})

function creature_drill_rush:OnAbilityPhaseStart()
	if IsServer() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_creature_drill_rush_cast", {})

		self.dig_pfx = ParticleManager:CreateParticle("particles/creature/drill_rush_dig.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(self.dig_pfx, 0, self:GetCaster():GetAbsOrigin())

		self:GetCaster():EmitSound("CreatureDrillCharge.Cast")
	end

	return true
end

function creature_drill_rush:OnAbilityPhaseInterrupted()
	if IsServer() then
		self:GetCaster():RemoveModifierByName("modifier_creature_drill_rush_cast")

		ParticleManager:DestroyParticle(self.dig_pfx, true)
		ParticleManager:ReleaseParticleIndex(self.dig_pfx)

		self:GetCaster():StopSound("CreatureDrillCharge.Cast")
	end
end

function creature_drill_rush:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()

		self:GetCaster():RemoveModifierByName("modifier_creature_drill_rush_cast")

		ParticleManager:DestroyParticle(self.dig_pfx, false)
		ParticleManager:ReleaseParticleIndex(self.dig_pfx)

		caster:EmitSound("CreatureDrillCharge.Start")

		caster:AddNewModifier(caster, self, "modifier_creature_drill_rush", {duration = self:GetSpecialValueFor("rush_duration")})
	end
end



modifier_creature_drill_rush_cast = class({})

function modifier_creature_drill_rush_cast:IsHidden() return false end
function modifier_creature_drill_rush_cast:IsDebuff() return false end
function modifier_creature_drill_rush_cast:IsPurgable() return true end

function modifier_creature_drill_rush_cast:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(0.03)
	end
end

function modifier_creature_drill_rush_cast:OnIntervalThink()
	if IsServer() then
		local caster_angles = self:GetCaster():GetAngles()
		local caster_origin = self:GetCaster():GetAbsOrigin()
		self:GetCaster():SetAbsOrigin(Vector(caster_origin.x, caster_origin.y, caster_origin.z - 6))

		self:GetCaster():SetAngles(caster_angles.x + 2.5, caster_angles.y, caster_angles.z)
	end
end

function modifier_creature_drill_rush_cast:OnDestroy()
	if IsServer() then
		local caster_angles = self:GetCaster():GetAngles()
		self:GetCaster():SetAngles(0, caster_angles.y, caster_angles.z)
		FindClearSpaceForUnit(self:GetCaster(), self:GetCaster():GetAbsOrigin(), true)
	end
end




modifier_creature_drill_rush = class({})

function modifier_creature_drill_rush:IsHidden() return false end
function modifier_creature_drill_rush:IsDebuff() return false end
function modifier_creature_drill_rush:IsPurgable() return true end

function modifier_creature_drill_rush:OnCreated(keys)
	if IsClient() then return end
	self.ability = self:GetAbility()

	self.stun_duration = self.ability:GetSpecialValueFor("stun_duration")
	self.damage = self.ability:GetSpecialValueFor("damage")
	
	self:SetStackCount(1)
	self:StartIntervalThink(0.1)
end

function modifier_creature_drill_rush:OnIntervalThink()
	if IsServer() then
		self:IncrementStackCount()

		local dirt_pfx = ParticleManager:CreateParticle("particles/creature/drill_rush_dig.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(dirt_pfx, 0, self:GetCaster():GetAbsOrigin())
		Timers:CreateTimer(0.2, function()
			ParticleManager:DestroyParticle(dirt_pfx, false)
			ParticleManager:ReleaseParticleIndex(dirt_pfx)
		end)
	end
end

function modifier_creature_drill_rush:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end

function modifier_creature_drill_rush:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT
	}
	return funcs
end

if IsServer() then
	function modifier_creature_drill_rush:GetModifierProcAttack_Feedback(keys)
		if not keys.attacker.spawn_team or not GameMode.arena_centers[keys.attacker.spawn_team] then return end
		
		local target = keys.target

		local unit_loc = target:GetAbsOrigin()

		local target_loc = GameMode.arena_centers[keys.attacker.spawn_team]
		local knockback_origin = unit_loc - (target_loc - unit_loc):Normalized() * 300
		local knockback_distance = (target_loc - unit_loc):Length2D()

		local knockback_table = {
			center_x = knockback_origin.x,
			center_y = knockback_origin.y,
			center_z = knockback_origin.z,
			knockback_duration = 0.4,
			knockback_distance = knockback_distance,
			knockback_height = 275,
			should_stun = 1,
			duration = 0.4
		}

		target:RemoveModifierByName("modifier_knockback")
		target:AddNewModifier(keys.attacker, nil, "modifier_knockback", knockback_table)


		target:EmitSound("CreatureDrillCharge.Hit")
		ApplyDamage({victim = target, attacker = keys.attacker, damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL})

		target:AddNewModifier(keys.attacker, self.ability, "modifier_stunned", {
			duration = 0.4 + self.stun_duration * (1 - target:GetStatusResistance()) 
		})

		self:Destroy()
	end
end

function modifier_creature_drill_rush:GetModifierMoveSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("acceleration") * self:GetStackCount()
end

function modifier_creature_drill_rush:GetModifierIgnoreMovespeedLimit()
	return 1
end

function modifier_creature_drill_rush:GetModifierModelChange()
	return "models/heroes/nerubian_assassin/mound.vmdl"
end

function modifier_creature_drill_rush:GetModifierModelScale()
	return 20
end
