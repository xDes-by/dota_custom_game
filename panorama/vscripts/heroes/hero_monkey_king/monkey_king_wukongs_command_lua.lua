monkey_king_wukongs_command_lua = class({})
LinkLuaModifier("modifier_monkey_king_wukongs_command_lua", "heroes/hero_monkey_king/modifier_monkey_king_wukongs_command_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_wukongs_command_clone_lua", "heroes/hero_monkey_king/modifier_monkey_king_wukongs_command_clone_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_wukongs_command_circle_lua", "heroes/hero_monkey_king/modifier_monkey_king_wukongs_command_circle_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_wukongs_command_hidden_lua", "heroes/hero_monkey_king/modifier_monkey_king_wukongs_command_hidden_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_wukongs_command_buff", "heroes/hero_monkey_king/modifier_monkey_king_wukongs_command_buff", LUA_MODIFIER_MOTION_NONE)


monkey_king_wukongs_command_lua.scepter_attack_radius = 300


function monkey_king_wukongs_command_lua:GetIntrinsicModifierName()
	return "modifier_monkey_king_wukongs_command_lua"
end


function monkey_king_wukongs_command_lua:OnAbilityPhaseStart()
	local caster = self:GetCaster()
	-- Sound during casting
	caster:EmitSound("Hero_MonkeyKing.FurArmy.Channel")
	-- Particle during casting
	if IsServer() then
		self.cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_fur_army_cast.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControlForward(self.cast_particle, 0, caster:GetForwardVector())
	end
	return true
end

function monkey_king_wukongs_command_lua:GetAOERadius()
	return self:GetSpecialValueFor("circle_radius")
end


function monkey_king_wukongs_command_lua:OnAbilityPhaseInterrupted()
	self:GetCaster():StopSound("Hero_MonkeyKing.FurArmy.Channel")

	if not IsServer() then return end

	if self.cast_particle then
		ParticleManager:DestroyParticle(self.cast_particle, true)
		ParticleManager:ReleaseParticleIndex(self.cast_particle)
		self.cast_particle = nil
	end
end


function monkey_king_wukongs_command_lua:OnSpellStart()
	local position = self:GetCursorPosition()
	local caster = self:GetCaster()

	if self.cast_particle then
		ParticleManager:DestroyParticle(self.cast_particle, false)
		ParticleManager:ReleaseParticleIndex(self.cast_particle)
		self.cast_particle = nil
    end

	if not caster.mk_clone then return end

	self:MoveClone(caster.mk_clone, caster.mk_clone:GetAbsOrigin(), position)

	caster.mk_clone.ring_position = position
	local ring_duration = self:GetSpecialValueFor("duration")
	caster.mk_clone:AddNewModifier(caster.mk_clone, self, "modifier_monkey_king_wukongs_command_circle_lua", {duration=ring_duration})
end


function monkey_king_wukongs_command_lua:MoveClone(clone, from, to)
	local disappear_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_disguise.vpcf", PATTACH_ABSORIGIN, clone)
	ParticleManager:SetParticleControl(disappear_particle, 0, from)
	ParticleManager:ReleaseParticleIndex(disappear_particle)

	clone:SetAbsOrigin(to)
	FindClearSpaceForUnit(clone, to, false)

	local appear_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_fur_army_positions.vpcf", PATTACH_ABSORIGIN, clone)
    ParticleManager:SetParticleControl(appear_particle, 0, to)
    Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(appear_particle, false)
	end)

	if self:GetCaster():HasScepter() then
		self:MakeRingParticleAt(to)
	end
end


function monkey_king_wukongs_command_lua:GetRingRadius()
	local circle_radius = self:GetSpecialValueFor("circle_radius")

	local talent = self:GetCaster():FindAbilityByName("special_bonus_unique_monkey_king_6")
	if talent and talent:GetLevel() > 0 then
		circle_radius = circle_radius + talent:GetSpecialValueFor("value")
	end

	return circle_radius
end


function monkey_king_wukongs_command_lua:MakeRingParticleAt(position)
	local caster = self:GetCaster()

	if not caster.mk_clone or caster.mk_clone:IsNull() then return end
	if not position then position = caster.mk_clone:GetAbsOrigin() end
	
	local ring_radius = caster.mk_clone:HasModifier("modifier_monkey_king_wukongs_command_circle_lua") and self:GetRingRadius() or self.scepter_attack_radius
	
	self:RemoveParticle()

	caster.mk_clone.ring_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_furarmy_ring.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(caster.mk_clone.ring_particle, 0, position)
	ParticleManager:SetParticleControl(caster.mk_clone.ring_particle, 1, Vector(ring_radius, 0, 0))
end


function monkey_king_wukongs_command_lua:RemoveParticle()
	local caster = self:GetCaster()
	if not caster or caster:IsNull() then return end
	if not caster.mk_clone then return end
	if not caster.mk_clone.ring_particle then return end

	ParticleManager:DestroyParticle(caster.mk_clone.ring_particle, true)
	ParticleManager:ReleaseParticleIndex(caster.mk_clone.ring_particle)
end
