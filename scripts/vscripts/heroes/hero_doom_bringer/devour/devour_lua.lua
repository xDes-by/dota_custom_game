doom_devour_lua = {}

LinkLuaModifier( "modifier_ability_devour", 'heroes/hero_doom_bringer/devour/devour_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_devour_intrinsic_lua", 'heroes/hero_doom_bringer/devour/modifier_devour_intrinsic_lua.lua', LUA_MODIFIER_MOTION_NONE)

modifier_ability_devour_souls = {}

function doom_devour_lua:GetIntrinsicModifierName()
	return "modifier_devour_intrinsic_lua"
end

function doom_devour_lua:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end

function doom_devour_lua:GetCooldown(level)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_doom_bringer_agi11") then
		return self.BaseClass.GetCooldown( self, level ) - 20
	end
    return self.BaseClass.GetCooldown( self, level )
end

function doom_devour_lua:GetBehavior()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_doom_bringer_str12") or self:GetCaster():FindAbilityByName("npc_dota_hero_doom_bringer_str13") then
		return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
	end
end

function doom_devour_lua:GetAOERadius()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_doom_bringer_str13") then
		return 400
	elseif self:GetCaster():FindAbilityByName("npc_dota_hero_doom_bringer_str12") then
		return 800
	end
end

function doom_devour_lua:CastFilterResultTarget( hTarget )
	local nResult = UnitFilter(
		hTarget,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO,
		self:GetCaster():GetTeamNumber()
	)
	if nResult ~= UF_SUCCESS then
		return nResult
	end
	return UF_SUCCESS
end

function doom_devour_lua:UseAbility(target)
	local caster = self:GetCaster()
	target:AddNoDraw()
	target:Kill(self, caster)

	local particleName = "particles/units/heroes/hero_doom_bringer/doom_bringer_devour.vpcf"
	caster.ManaDrainParticle = ParticleManager:CreateParticle(particleName, PATTACH_POINT_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(caster.ManaDrainParticle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(caster.ManaDrainParticle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)

	EmitSoundOn( "Hero_DoomBringer.Devour", self:GetCaster() )
end

function doom_devour_lua:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local position = self:GetCursorPosition()
	local duration = self:GetSpecialValueFor("devour_time")
	local radius = 0
	local modifier_devour_intrinsic_lua = caster:FindModifierByName("modifier_devour_intrinsic_lua")

	if caster:FindAbilityByName("npc_dota_hero_doom_bringer_str13") then
		radius = 800
	elseif caster:FindAbilityByName("npc_dota_hero_doom_bringer_str12") then
		radius = 400
	end
	if radius > 0 then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, caster, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO, 0, false )
		for _, enemy in pairs(enemies) do
			self:UseAbility(enemy)
		end
		if caster:FindAbilityByName("npc_dota_hero_doom_bringer_str13") then
			if #enemies >= 3 then
				modifier_devour_intrinsic_lua:IncrementStackCount()
				modifier_devour_intrinsic_lua:IncrementStackCount()
				modifier_devour_intrinsic_lua:IncrementStackCount()
				caster:AddNewModifier(caster, self, "modifier_ability_devour", { duration = duration })
				caster:AddNewModifier(caster, self, "modifier_ability_devour", { duration = duration })
				caster:AddNewModifier(caster, self, "modifier_ability_devour", { duration = duration })
			elseif #enemies >= 2 then
				modifier_devour_intrinsic_lua:IncrementStackCount()
				modifier_devour_intrinsic_lua:IncrementStackCount()
				caster:AddNewModifier(caster, self, "modifier_ability_devour", { duration = duration })
				caster:AddNewModifier(caster, self, "modifier_ability_devour", { duration = duration })
			elseif #enemies >= 1 then
				modifier_devour_intrinsic_lua:IncrementStackCount()
				caster:AddNewModifier(caster, self, "modifier_ability_devour", { duration = duration })
			end
		elseif caster:FindAbilityByName("npc_dota_hero_doom_bringer_str12") then
			if #enemies >= 2 then
				modifier_devour_intrinsic_lua:IncrementStackCount()
				modifier_devour_intrinsic_lua:IncrementStackCount()
				caster:AddNewModifier(caster, self, "modifier_ability_devour", { duration = duration })
				caster:AddNewModifier(caster, self, "modifier_ability_devour", { duration = duration })
			elseif #enemies >= 1 then
				modifier_devour_intrinsic_lua:IncrementStackCount()
				caster:AddNewModifier(caster, self, "modifier_ability_devour", { duration = duration })
			end
		end
	else
		self:UseAbility(target)
		modifier_devour_intrinsic_lua:IncrementStackCount()
		caster:AddNewModifier(caster, self, "modifier_ability_devour", { duration = duration })
	end
	EmitSoundOn( "Hero_DoomBringer.DevourCast", target )
end

--------------------------------

modifier_ability_devour = {}

function modifier_ability_devour:IsHidden()
	return false
end

function modifier_ability_devour:IsDebuff()
	return false
end

function modifier_ability_devour:IsPurgable()
	return false
end

function modifier_ability_devour:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_ability_devour:RemoveOnDeath()
	return false
end

function modifier_ability_devour:OnCreated( kv )
	self.caster = self:GetCaster()
	self.bonus_gold = self:GetAbility():GetSpecialValueFor( "bonus_gold" )
	self.bonus_regen = self:GetAbility():GetSpecialValueFor( "regen" )
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "devour_damage" )
end

function modifier_ability_devour:OnDestroy()
	if IsServer() then
		self.caster:ModifyGoldFiltered(self.bonus_gold, true, 0)
		SendOverheadEventMessage(self.caster, OVERHEAD_ALERT_GOLD, self.caster, self.bonus_gold, nil)
    end
end

function modifier_ability_devour:GetSoulsStackCount()
	local stacks = self.caster:GetModifierStackCount("modifier_devour_intrinsic_lua", self.caster)
	if self.caster:FindAbilityByName("npc_dota_hero_doom_bringer_int6") and stacks % 3 == 0 then
		stacks = stacks * 1.5
	end
	return stacks
end

function modifier_ability_devour:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
end

function modifier_ability_devour:GetModifierConstantHealthRegen()
	return self.bonus_regen * self:GetSoulsStackCount()
end

function modifier_ability_devour:GetModifierPreAttack_BonusDamage()
    return self.bonus_damage * self:GetSoulsStackCount()
end

function modifier_ability_devour:GetModifierBonusStats_Strength()
	if self.caster:FindAbilityByName("npc_dota_hero_doom_bringer_str10") then
    	return self:GetAbility():GetLevelSpecialValueNoOverride( "devour_damage", self:GetAbility():GetLevel() ) * self:GetSoulsStackCount()
	end
	return 0
end