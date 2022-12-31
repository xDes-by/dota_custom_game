modifier_monkey_king_wukongs_command_circle_lua = class({})

function modifier_monkey_king_wukongs_command_circle_lua:IsAura() return true end
function modifier_monkey_king_wukongs_command_circle_lua:GetAuraRadius() return self.circle_radius or 600 end
function modifier_monkey_king_wukongs_command_circle_lua:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_monkey_king_wukongs_command_circle_lua:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_monkey_king_wukongs_command_circle_lua:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_monkey_king_wukongs_command_circle_lua:GetModifierAura() 
	return "modifier_monkey_king_wukongs_command_buff"
end


function modifier_monkey_king_wukongs_command_circle_lua:OnCreated()
	if not IsServer() then return end
	local parent = self:GetParent()
	local ability = self:GetAbility()

	self.caster = ability:GetCaster()
	self.circle_radius = ability:GetSpecialValueFor("circle_radius")

	local talent = self.caster:FindAbilityByName("special_bonus_unique_monkey_king_6")
	if talent and talent:GetLevel() > 0 then
		self.circle_radius = self.circle_radius + talent:GetSpecialValueFor("value")
	end

	parent:RemoveModifierByName("modifier_monkey_king_wukongs_command_hidden_lua")

	ability:MakeRingParticleAt(parent.ring_position)

	self.caster:EmitSound("Hero_MonkeyKing.FurArmy")

	self:StartIntervalThink(0.5)
end


function modifier_monkey_king_wukongs_command_circle_lua:OnDestroy()
	if not IsServer() then return end

	local parent = self:GetParent()
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then return end

	-- remove prev old circle particle and make a new one
	ability:RemoveParticle()
	if self.caster:HasScepter() then
		ability:MakeRingParticleAt()
	else
		parent:AddNewModifier(parent, self:GetAbility(), "modifier_monkey_king_wukongs_command_hidden_lua", {})
	end

	self.caster:StopSound("Hero_MonkeyKing.FurArmy")
  	self.caster:EmitSound("Hero_MonkeyKing.FurArmy.End")
end


function modifier_monkey_king_wukongs_command_circle_lua:OnIntervalThink()
	local parent = self:GetParent()

	if not self.caster:IsAlive() then self:Destroy() return end

	if (parent.ring_position - self.caster:GetAbsOrigin()):Length() > self.circle_radius then
		self:Destroy()
	end
end


function modifier_monkey_king_wukongs_command_circle_lua:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_PROPERTY_ATTACK_RANGE_BASE_OVERRIDE,
	}
end


function modifier_monkey_king_wukongs_command_circle_lua:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true,
	}
end


function modifier_monkey_king_wukongs_command_circle_lua:OnAttack(params)
	if not IsServer() then return end
	
	local target = params.target
	local attacker = params.attacker
	local parent = self:GetParent()
	local search_point = parent:GetAbsOrigin()
	
	if parent.mk_lock then return end

	if parent ~= attacker then return end

	local targets = FindUnitsInRadius(
		parent:GetTeam(), 
		search_point,
		nil,
		self.circle_radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_ALL - DOTA_UNIT_TARGET_OTHER,
		DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE,
		FIND_CLOSEST,
		false
	)

	for i, m_target in pairs(targets) do
		if m_target ~= target then
			Timers:CreateTimer(0.07 * i, function()
				if parent and not parent:IsNull() and m_target and not m_target:IsNull() then
					parent.mk_lock = true
					parent:PerformAttack(m_target, true, true, true, true, true, false, true)
					parent.mk_lock = false
				end
			end)
		end
	end

	local attack_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_fur_army_attack.vpcf", PATTACH_ABSORIGIN, parent)
	ParticleManager:SetParticleControl(attack_particle, 0, search_point)
	ParticleManager:ReleaseParticleIndex(attack_particle)
end


function modifier_monkey_king_wukongs_command_circle_lua:GetModifierAttackRangeOverride()
	return self.circle_radius
end
