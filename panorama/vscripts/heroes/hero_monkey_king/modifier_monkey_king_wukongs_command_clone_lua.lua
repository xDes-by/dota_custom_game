modifier_monkey_king_wukongs_command_clone_lua = class({})

function modifier_monkey_king_wukongs_command_clone_lua:IsPurgable() return false end

function modifier_monkey_king_wukongs_command_clone_lua:GetStatusEffectName()
	return "particles/status_fx/status_effect_monkey_king_fur_army.vpcf"
end

function modifier_monkey_king_wukongs_command_clone_lua:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end


function modifier_monkey_king_wukongs_command_clone_lua:OnCreated()
	if not IsServer() then return end

	local ability = self:GetAbility()
	if not ability or ability:IsNull() then return end

	local parent = self:GetParent()
	if not parent or parent:IsNull() then return end

	self.ability = ability
	self.caster = ability:GetCaster()
	self.attack_rate = ability:GetSpecialValueFor("attack_speed")

	local movement_interval = ability:GetSpecialValueFor("movement_interval")

	self:StartIntervalThink(movement_interval)
end


function modifier_monkey_king_wukongs_command_clone_lua:OnIntervalThink()
	local parent = self:GetParent()

	if not parent or parent:IsNull() then return end
	if not self.ability or self.ability:IsNull() then return end

	if parent:HasModifier("modifier_monkey_king_wukongs_command_circle_lua") then return end

	if not self.caster or self.caster:IsNull() then 
		return 
	end

	if not self.caster:IsAlive() then
		if not parent:HasModifier("modifier_monkey_king_wukongs_command_hidden_lua") then
			parent:AddNewModifier(parent, self.ability, "modifier_monkey_king_wukongs_command_hidden_lua", {})
			self.ability:RemoveParticle()
		end
		return
	else
		if self.caster:HasScepter() and parent:HasModifier("modifier_monkey_king_wukongs_command_hidden_lua") then
			parent:RemoveModifierByName("modifier_monkey_king_wukongs_command_hidden_lua")
			self.ability:MakeRingParticleAt()
		end
	end

	local old_position = parent:GetAbsOrigin()
	local new_position = self.caster:GetAbsOrigin() + RandomVector(RandomInt(50, 300))

	self.ability:MoveClone(parent, old_position, new_position)
end


function modifier_monkey_king_wukongs_command_clone_lua:CheckState()
	return {
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNTARGETABLE] = true,
		[MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
		[MODIFIER_STATE_FROZEN] = false,
		[MODIFIER_STATE_STUNNED] = false,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
	}
end


function modifier_monkey_king_wukongs_command_clone_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_FIXED_ATTACK_RATE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
	}
end


function modifier_monkey_king_wukongs_command_clone_lua:GetModifierFixedAttackRate()
	return self.attack_rate
end


function modifier_monkey_king_wukongs_command_clone_lua:GetModifierProcAttack_Feedback(params)
	local target = params.target
	if not target or target:IsNull() then return end
	if not self.caster or self.caster:IsNull() then return end

	self.caster:PerformAttack(target, true, true, true, true, false, false, true)
	
	if not target or target:IsNull() then return end
	target:EmitSound("Hero_MonkeyKing.Attack.Ring")
end
