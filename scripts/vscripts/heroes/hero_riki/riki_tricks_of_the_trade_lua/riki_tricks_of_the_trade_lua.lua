LinkLuaModifier( "modifier_riki_tricks_of_the_trade_lua_primary", "heroes/hero_riki/riki_tricks_of_the_trade_lua/modifier_riki_tricks_of_the_trade_lua_primary", LUA_MODIFIER_MOTION_NONE )		-- Hides the caster and damages all enemies in the AoE
LinkLuaModifier( "modifier_riki_tricks_of_the_trade_lua_secondary", "heroes/hero_riki/riki_tricks_of_the_trade_lua/modifier_riki_tricks_of_the_trade_lua_secondary", LUA_MODIFIER_MOTION_NONE )		-- Hides the caster and damages all enemies in the AoE
LinkLuaModifier( "modifier_riki_tricks_of_the_trade_lua_secondary", "components/abilities/heroes/hero_riki.lua", LUA_MODIFIER_MOTION_NONE )	-- Attacks a single enemy based on attack speed
LinkLuaModifier( "modifier_imba_martyrs_mark", "heroes/hero_riki/riki_tricks_of_the_trade_lua/riki_tricks_of_the_trade_lua", LUA_MODIFIER_MOTION_NONE )
riki_tricks_of_the_trade_lua = riki_tricks_of_the_trade_lua or class({})

function riki_tricks_of_the_trade_lua:GetAbilityTextureName()
	return "riki_tricks_of_the_trade"
end

function riki_tricks_of_the_trade_lua:GetBehavior()
	if self:GetName() == "riki_tricks_of_the_trade_lua" then
		if self:GetCaster():HasScepter() then
			return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_MOVEMENT + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES
		else
			return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_MOVEMENT + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES
		end
	elseif self:GetName() == "riki_tricks_of_the_trade_lua_723" then
		if self:GetCaster():HasScepter() then
			return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES
		else
			if IsServer() then
				return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_OPTIONAL_POINT + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES
			else
				return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_OPTIONAL_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES
			end
		end
	end
end

function riki_tricks_of_the_trade_lua:IsNetherWardStealable()
	return false
end

function riki_tricks_of_the_trade_lua:GetChannelTime()
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor("scepter_duration")
	else
		return self:GetSpecialValueFor("channel_duration")
	end
end

function riki_tricks_of_the_trade_lua:GetCastRange()
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor("scepter_cast_range") end

	return self:GetSpecialValueFor("area_of_effect")
end

function riki_tricks_of_the_trade_lua:GetAOERadius()
	return self:GetSpecialValueFor("area_of_effect") end

function riki_tricks_of_the_trade_lua:OnAbilityPhaseStart()
	if self:GetCaster():HasScepter() and self:GetCursorTarget() and self:GetCursorTarget() ~= self:GetCaster() then
		self.target = self:GetCursorTarget()
		self:GetCaster():SetCursorCastTarget(self:GetCaster())
	elseif self:GetCursorTarget() and self:GetCursorTarget() == self:GetCaster() then
		self:GetCaster():SetCursorCastTarget(nil)
		self:GetCaster():CastAbilityOnPosition(self:GetCaster():GetAbsOrigin(), self, self:GetCaster():GetPlayerID())
	end

	return true
end

function riki_tricks_of_the_trade_lua:OnAbilityPhaseInterrupted()
	self.target = nil
end

function riki_tricks_of_the_trade_lua:OnSpellStart()
	local caster = self:GetCaster()
	local origin = caster:GetAbsOrigin()
	
	if self:GetName() == "riki_tricks_of_the_trade_lua_723" then
		origin	= self:GetCursorPosition()
		self:GetCaster():SetAbsOrigin(origin)
	end
	
	local aoe = self:GetSpecialValueFor("area_of_effect")
	local target = self:GetCursorTarget()

	self.channel_start_time = GameRules:GetGameTime()

	if caster:HasScepter() and self.target and not self.target:IsNull() then
		origin = self.target:GetAbsOrigin()
	end

	caster:AddNewModifier(caster, self, "modifier_riki_tricks_of_the_trade_lua_primary", {})
	caster:AddNewModifier(caster, self, "modifier_riki_tricks_of_the_trade_lua_secondary", {})

	local cast_particle = "particles/units/heroes/hero_riki/riki_tricks_cast.vpcf"
	local tricks_particle = "particles/units/heroes/hero_riki/riki_tricks.vpcf"
	local cast_sound = "Hero_Riki.TricksOfTheTrade.Cast"
	local continous_sound = "Hero_Riki.TricksOfTheTrade"
	local buttsecks_sound = "Imba.RikiSurpriseButtsex"

	local heroes = FindUnitsInRadius(caster:GetTeamNumber(), origin, nil, aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
	
	if #heroes >= PlayerResource:GetPlayerCount() * 0.35 and self:GetName() == "riki_tricks_of_the_trade_lua" then
		-- caster:EmitSound(buttsecks_sound)
		EmitSoundOn(buttsecks_sound, caster)
	end

	EmitSoundOnLocationWithCaster(origin, cast_sound, caster)
	EmitSoundOn(continous_sound, caster)

	local caster_loc = caster:GetAbsOrigin()

	local cast_particle = ParticleManager:CreateParticle(cast_particle, PATTACH_WORLDORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(cast_particle, 0, caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(cast_particle)

	self.TricksParticle = ParticleManager:CreateParticle(tricks_particle, PATTACH_WORLDORIGIN, caster)

	ParticleManager:SetParticleControl(self.TricksParticle, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.TricksParticle, 1, Vector(aoe, 0, aoe))
	ParticleManager:SetParticleControl(self.TricksParticle, 2, Vector(aoe, 0, aoe))

	caster:AddNoDraw()
end

function riki_tricks_of_the_trade_lua:OnChannelThink()
	local caster = self:GetCaster()
	if caster:HasScepter() and self.target and not self.target:IsNull() then
		local origin = self.target:GetAbsOrigin()
		caster:SetAbsOrigin(origin)
		ParticleManager:SetParticleControl(self.TricksParticle, 0, origin)
		ParticleManager:SetParticleControl(self.TricksParticle, 3, origin)
	end
end

function riki_tricks_of_the_trade_lua:OnChannelFinish()
	if IsServer() then
		local caster = self:GetCaster()
		local backstab_ability = caster:FindAbilityByName("imba_riki_cloak_and_dagger")
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
		caster:RemoveModifierByName("modifier_riki_tricks_of_the_trade_lua_primary")
		caster:RemoveModifierByName("modifier_riki_tricks_of_the_trade_lua_secondary")
		if backstab_ability and backstab_ability:GetLevel() > 0 then backstab_ability:EndCooldown() end

		StopSoundEvent("Hero_Riki.TricksOfTheTrade", caster)
		
		if self:GetName() == "riki_tricks_of_the_trade_lua" then
			StopSoundEvent("Imba.RikiSurpriseButtsex", caster)
		end
		
		ParticleManager:DestroyParticle(self.TricksParticle, false)
		ParticleManager:ReleaseParticleIndex(self.TricksParticle)
		self.TricksParticle = nil

		local target = self:GetCursorTarget()
		caster:RemoveNoDraw()
		local end_particle = "particles/units/heroes/hero_riki/riki_tricks_end.vpcf"
		local particle = ParticleManager:CreateParticle(end_particle, PATTACH_ABSORIGIN, caster)
		ParticleManager:ReleaseParticleIndex(particle)

		-- #6 Talent: Tricks of the Trade refunds cooldown proportional to the channel duration remaining_duration
		if caster:HasTalent("special_bonus_imba_riki_6") then
			local channel_time = GameRules:GetGameTime() - self.channel_start_time
			local portion_refunded = channel_time/self:GetChannelTime()
			local new_cooldown = self:GetCooldownTimeRemaining() * (portion_refunded)
			if new_cooldown < caster:FindTalentValue("special_bonus_imba_riki_6") and new_cooldown ~= 0 then
				new_cooldown = caster:FindTalentValue("special_bonus_imba_riki_6")
			end
			self:EndCooldown()
			self:StartCooldown(new_cooldown)
		end
		
		self.target = nil
	end
end








if modifier_imba_martyrs_mark == nil then modifier_imba_martyrs_mark = class({}) end
function modifier_imba_martyrs_mark:IsPurgable() return false end
function modifier_imba_martyrs_mark:IsDebuff() return true end
function modifier_imba_martyrs_mark:IsHidden() return false end

function modifier_imba_martyrs_mark:OnCreated()
	if IsServer() then
		local parent = self:GetParent()

		self.particle_mark_fx = ParticleManager:CreateParticle("particles/hero/riki/riki_martyr_dagger_start_pos.vpcf", PATTACH_OVERHEAD_FOLLOW, parent)
		ParticleManager:SetParticleControlEnt(self.particle_mark_fx, 0, parent, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.particle_mark_fx, 1, parent, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
		self:AddParticle(self.particle_mark_fx, false, false, -1, false, true)

		self:SetStackCount(1)
	end
end

function modifier_imba_martyrs_mark:OnRefresh()
	if IsServer() then
		self:IncrementStackCount()
	end
end