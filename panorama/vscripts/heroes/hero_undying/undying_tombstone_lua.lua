undying_tombstone_lua = class({})
LinkLuaModifier( "modifier_undying_tombstone_intrinsic_lua", "heroes/hero_undying/modifier_undying_tombstone_intrinsic_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_undying_tombstone_debuff_lua", "heroes/hero_undying/modifier_undying_tombstone_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_undying_tombstone_lua", "heroes/hero_undying/modifier_undying_tombstone_lua", LUA_MODIFIER_MOTION_NONE )


function undying_tombstone_lua:ProcsMagicStick() return false end


function undying_tombstone_lua:GetCooldown(level)
	return self.BaseClass.GetCooldown(self, level) - self:GetCaster():FindTalentValue("special_bonus_unique_undying_7")
end

function undying_tombstone_lua:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end


-- handling talents
function undying_tombstone_lua:GetIntrinsicModifierName()
	return "modifier_undying_tombstone_intrinsic_lua"
end


function undying_tombstone_lua:OnSpellStart()
	if not IsServer() then return end

	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	local base_damage = self:GetSpecialValueFor("base_damage") + caster:FindTalentValue("special_bonus_unique_undying")
	local cast_position = self:GetCursorPosition()

	GridNav:DestroyTreesAroundPoint(cast_position, 400, false)

	self:SetRefCountsModifiers(true)

	local tombstone = CreateUnitByName(
		"npc_dota_unit_tombstone" .. self:GetLevel(), cast_position, true, caster, caster, caster:GetTeamNumber() 
	)
	if not tombstone then return end
	tombstone:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)

	tombstone:AddNewModifier(caster, self, "modifier_undying_tombstone_lua", { duration = duration } )
	tombstone:AddNewModifier(caster, self, "modifier_kill", { duration = duration } )

	local multicast_modifier = caster:FindModifierByName("modifier_multicast_lua")
	local multicast = 1

	if multicast_modifier then
		multicast = multicast_modifier:GetMulticastFactor(self)
		multicast_modifier:PlayMulticastFX(multicast)
	end

	if multicast > 1 and multicast_modifier then
		multicast_modifier:PlaySummonFX(tombstone, multicast)
	end

	local base_health = (tombstone:GetBaseMaxHealth() + caster:FindTalentValue("special_bonus_unique_undying_5") * 2) * multicast
	tombstone:SetBaseMaxHealth(base_health)
	tombstone:SetMaxHealth(base_health)
	tombstone:SetHealth(base_health)
	tombstone:SetBaseDamageMin(base_damage * multicast)
	tombstone:SetBaseDamageMax(base_damage * multicast)

	tombstone:AddAbility("summon_buff")

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_undying/undying_tombstone.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(particle, 0, self:GetCursorPosition())	
	ParticleManager:SetParticleControlEnt(particle, 1, caster, duration, "attach_attack1", caster:GetOrigin(), true)
	ParticleManager:SetParticleControl(particle, 2, Vector( duration, duration, duration ))
	ParticleManager:ReleaseParticleIndex(particle)

	tombstone:EmitSound("Hero_Undying.Tombstone")
	ResolveNPCPositions(tombstone:GetAbsOrigin(), 64)
end
