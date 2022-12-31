axe_counter_helix_lua = class({})
LinkLuaModifier("modifier_axe_counter_helix_lua", "heroes/hero_axe/axe_counter_helix_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_axe_counter_helix_shard_effect_lua", "heroes/hero_axe/axe_counter_helix_lua", LUA_MODIFIER_MOTION_NONE)


function axe_counter_helix_lua:GetIntrinsicModifierName()
	return "modifier_axe_counter_helix_lua"
end



modifier_axe_counter_helix_lua = class({})

function modifier_axe_counter_helix_lua:IsHidden() return true end
function modifier_axe_counter_helix_lua:IsPurgable() return false end


function modifier_axe_counter_helix_lua:OnCreated()
	if not IsServer() then return end

	self:OnRefresh()
end


function modifier_axe_counter_helix_lua:OnRefresh()
	if not IsServer() then return end

	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	if not self.ability or self.ability:IsNull() then return end
	if not self.parent or self.parent:IsNull() then return end

	self.team 			= self.parent:GetTeamNumber()

	self.cooldown 		= self.ability:GetCooldown(-1)
	self.radius 		= self.ability:GetSpecialValueFor("radius")

	self.shard_max_stacks 		= self.ability:GetSpecialValueFor("shard_max_stacks")
	self.shard_debuff_duration 	= self.ability:GetSpecialValueFor("shard_debuff_duration")

	self.damage_table = {
		damage_type		= DAMAGE_TYPE_PURE,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self.parent,
		ability 		= self.ability,
	}
end


function modifier_axe_counter_helix_lua:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE,
	}
end

function modifier_axe_counter_helix_lua:OnAttackLanded(params)
	if not IsServer() then return end

	if params.target ~= self.parent then return end
	if params.attacker:GetTeam() == self.team then return end
	if not self.ability:IsCooldownReady() then return end
	if self.parent:PassivesDisabled() then return end

	local trigger_chance = self.ability:GetSpecialValueFor("trigger_chance")
	local has_shard = self.parent:HasShard()

	if not RollPercentage(trigger_chance) then return end

	self.damage_table.damage = self.ability:GetSpecialValueFor("damage")

	local enemies = FindUnitsInRadius(
		self.team,
		self.parent:GetAbsOrigin(),
		nil,
		self.radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_ANY_ORDER,
		false
	)

	for _, enemy in pairs(enemies) do
		if enemy and not enemy:IsNull() then
			self.damage_table.victim = enemy
			ApplyDamage(self.damage_table)

			if has_shard and enemy:IsAlive() then
				local modifier = enemy:AddNewModifier(self.parent, self.ability, "modifier_axe_counter_helix_shard_effect_lua", {
					duration = self.shard_debuff_duration
				})
				if modifier and not modifier:IsNull() and modifier:GetStackCount() < self.shard_max_stacks then 
					modifier:IncrementStackCount() 
				end
			end
		end
	end

	local proc_effect = ParticleManager:CreateParticle(
		"particles/units/heroes/hero_axe/axe_counterhelix_ad.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent
	)
	ParticleManager:ReleaseParticleIndex(proc_effect)

	self.parent:StartGesture(ACT_DOTA_CAST_ABILITY_3)

	self.parent:EmitSound("Hero_Axe.CounterHelix")

	self.ability:UseResources(false, false, true)
end

function modifier_axe_counter_helix_lua:GetModifierIncomingPhysicalDamage_Percentage(params)
	local attacker = params.attacker

	if attacker then
		local shard_modifier = attacker:FindModifierByName("modifier_axe_counter_helix_shard_effect_lua")

		if shard_modifier then
			return -shard_modifier.total_damage_reduction
		end
	end
end



modifier_axe_counter_helix_shard_effect_lua = class({})

function modifier_axe_counter_helix_shard_effect_lua:IsDebuff() return true end

function modifier_axe_counter_helix_shard_effect_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end


function modifier_axe_counter_helix_shard_effect_lua:OnCreated()
	self:OnRefresh()
end

function modifier_axe_counter_helix_shard_effect_lua:OnRefresh()
	self.ability = self:GetAbility()
	
	self.damage_reduction = self.ability:GetSpecialValueFor("shard_damage_reduction")
	self:OnStackCountChanged()
end

function modifier_axe_counter_helix_shard_effect_lua:OnStackCountChanged()
	self.total_damage_reduction = self.damage_reduction * self:GetStackCount()
end

function modifier_axe_counter_helix_shard_effect_lua:OnTooltip()
	return self.total_damage_reduction
end