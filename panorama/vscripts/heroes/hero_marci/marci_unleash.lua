marci_unleash_lua = class({})
LinkLuaModifier( "modifier_marci_unleash_lua_scepter", "heroes/hero_marci/marci_unleash", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_unleash_lua_scepter_cooldown", "heroes/hero_marci/marci_unleash", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_unleash_lua", "heroes/hero_marci/marci_unleash", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_unleash_lua_fury", "heroes/hero_marci/marci_unleash", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_unleash_lua_recovery", "heroes/hero_marci/marci_unleash", LUA_MODIFIER_MOTION_NONE )

function marci_unleash_lua:Precache( context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_marci.vsndevts", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_unleash_cast.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_unleash_buff.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_unleash_stack.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_unleash_attack.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_unleash_pulse.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_unleash_pulse_debuff.vpcf", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_snapfire_slow.vpcf", context )
end

function marci_unleash_lua:OnSpellStart()
	if not self or self:IsNull() then return end
	local caster = self:GetCaster()
	if not caster or caster:IsNull() then return end
	
	local duration = self:GetSpecialValueFor( "duration" )
	caster:AddNewModifier(caster, self, "modifier_marci_unleash_lua", {duration = duration})

	if not caster:HasScepter() then return end
	caster:Purge(false, true, false, false, false)	-- basic dispel
	caster:AddNewModifier(caster, self, "modifier_marci_unleash_lua_scepter", {duration = duration})	-- aghanim's scepter
end


------------------------------------------------------------------------------------------------------------------------------------------------


modifier_marci_unleash_lua_scepter = class({})

function modifier_marci_unleash_lua_scepter:IsHidden() return true end
function modifier_marci_unleash_lua_scepter:IsPurgable() return false end
function modifier_marci_unleash_lua_scepter:IsDebuff() return false end

function modifier_marci_unleash_lua_scepter:OnCreated( kv )
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	if not self.parent or self.parent:IsNull() then return end
	if not self.ability or self.ability:IsNull() then return end

	self.internal_cooldown = self.ability:GetSpecialValueFor("internal_cooldown")
end

function modifier_marci_unleash_lua_scepter:OnRefresh( kv )
	self:OnCreated(kv)
end

function modifier_marci_unleash_lua_scepter:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}
end

modifier_marci_unleash_lua_scepter.ability_exceptions = {
	-- there will be some :)
}

modifier_marci_unleash_lua_scepter.marci_abilities = {
	marci_grapple = true,					-- dispose
	marci_companion_run = true,				-- rebound
	marci_guardian = true,					-- sidekick
}

function modifier_marci_unleash_lua_scepter:OnAbilityFullyCast( params )
	if not IsServer() then return end
	if not self or self:IsNull() then return end
	if params.unit ~= self.parent then return end
	if not params.ability or params.ability:IsNull() or params.ability == self.ability then return end
	if self.ability_exceptions and self.ability_exceptions[params.ability:GetAbilityName()] then return end
	if params.ability:IsItem() or params.ability:IsToggle() then return end
	if not self.parent:HasScepter() then return end

	-- internal cooldown
	-- marci abilities ignore cooldown and do not trigger internal cooldown
	if not self.marci_abilities[params.ability:GetAbilityName()] then
		if self.parent:HasModifier("modifier_marci_unleash_lua_scepter_cooldown") then
			return
		else
			self.parent:AddNewModifier(self.parent, self.ability, "modifier_marci_unleash_lua_scepter_cooldown", {duration = self.internal_cooldown or 0})
		end
	end

	-- default values
	self.modifier_exception_names = nil
	self.pulse_emitter = self.parent

	-- dispose exception
	if params.target and not params.target:IsNull() then
		if params.ability:GetAbilityName() == "marci_grapple" and params.target:HasModifier("modifier_marci_grapple_victim_motion") then
			self.modifier_exception_names = {
				"modifier_marci_grapple_victim_motion",
			}
			self.pulse_emitter = params.target
		end
	end

	-- rebound exception
	if params.ability:GetAbilityName() == "marci_companion_run" then
		-- we have to check both the lunge and the arc to ensure the pulse hits at the end of the spell
		self.modifier_exception_names = {
			"modifier_marci_lunge_tracking_motion",
			"modifier_marci_lunge_arc",
		}

		if self.parent:HasShard() and params.ability:GetAutoCastState() then
			self.pulse_emitter = params.target
		else
			self.pulse_emitter = self.parent
		end
	end

	-- hit the pulse instantly
	if self.modifier_exception_names then
		self:StartIntervalThink(0.1)
	else
		local modifier = self.parent:FindModifierByName("modifier_marci_unleash_lua_fury")
		if modifier then
			modifier:Pulse( self.pulse_emitter:GetOrigin() )
		end
		self:StartIntervalThink( -1 )
	end
	
end

function modifier_marci_unleash_lua_scepter:OnIntervalThink()
	if not self or self:IsNull() then return end
	if not self.pulse_emitter or self.pulse_emitter:IsNull() then return end
	if not self.parent or self.parent:IsNull() then return end

	local pulse_start = true
	for _, mod_name in pairs(self.modifier_exception_names) do
		if self.pulse_emitter:HasModifier(mod_name) or self.parent:HasModifier(mod_name) then	-- sometimes emitter and parent are not the same and have to check both
			pulse_start = false
			break
		end
	end

	if pulse_start then
		local modifier = self.parent:FindModifierByName("modifier_marci_unleash_lua_fury")
		if modifier then
			modifier:Pulse( self.pulse_emitter:GetOrigin() )
		end
		self:StartIntervalThink( -1 )
	end
end


modifier_marci_unleash_lua_scepter_cooldown = class({})

function modifier_marci_unleash_lua_scepter_cooldown:IsHidden() return true end
function modifier_marci_unleash_lua_scepter_cooldown:IsPurgable() return false end
function modifier_marci_unleash_lua_scepter_cooldown:IsDebuff() return false end


-------------------------------------------------------------------------------------------------------------------------------------------------------------


modifier_marci_unleash_lua = class({})

function modifier_marci_unleash_lua:IsHidden() return false end
function modifier_marci_unleash_lua:IsDebuff() return false end
function modifier_marci_unleash_lua:IsPurgable() return false end

function modifier_marci_unleash_lua:OnCreated( kv )
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	if not self.parent or self.parent:IsNull() then return end
	if not self.ability or self.ability:IsNull() then return end

	self.bonus_ms = self.ability:GetSpecialValueFor( "bonus_movespeed" )

	if not IsServer() then return end

	self.parent:AddNewModifier(self.parent, self.ability, "modifier_marci_unleash_lua_fury", {})

	-- particles
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_unleash_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( "Hero_Marci.Unleash.Cast", self:GetParent() )

end

function modifier_marci_unleash_lua:OnRefresh( kv )
	self:OnCreated(kv)
end

function modifier_marci_unleash_lua:OnDestroy()
	if not IsServer() then return end
	if not self or self:IsNull() then return end
	if not self.parent or self.parent:IsNull() then return end

	-- destroy fury or recovery modifiers
	local fury = self.parent:FindModifierByNameAndCaster( "modifier_marci_unleash_lua_fury", self.parent )
	if fury then
		fury:ForceDestroy()
	end

	local recovery = self.parent:FindModifierByNameAndCaster( "modifier_marci_unleash_lua_recovery", self.parent )
	if recovery then
		recovery:ForceDestroy()
	end

end

function modifier_marci_unleash_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end

function modifier_marci_unleash_lua:GetModifierMoveSpeedBonus_Percentage()
	return self.bonus_ms
end


---------------------------------------------------------------------------------------------------------------------------------------------------


modifier_marci_unleash_lua_fury = class({})

function modifier_marci_unleash_lua_fury:IsHidden() return false end
function modifier_marci_unleash_lua_fury:IsDebuff() return false end
function modifier_marci_unleash_lua_fury:IsPurgable() return false end

function modifier_marci_unleash_lua_fury:OnCreated( kv )
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	if not self.parent or self.parent:IsNull() then return end
	if not self.ability or self.ability:IsNull() then return end

	self.bonus_as = self.ability:GetSpecialValueFor( "flurry_bonus_attack_speed" )
	self.recovery = self.ability:GetSpecialValueFor( "time_between_flurries" )
	self.charges = self.ability:GetSpecialValueFor( "charges_per_flurry" )
	self.timer = self.ability:GetSpecialValueFor( "max_time_window_per_hit" )
	self.radius = self.ability:GetSpecialValueFor( "pulse_radius" )
	self.damage = self.ability:GetSpecialValueFor( "pulse_damage" )
	self.duration = self.ability:GetSpecialValueFor( "pulse_debuff_duration" )

	self.counter = self.charges
	self:SetStackCount( self.counter )

	local buff_effect = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_unleash_buff.vpcf", PATTACH_POINT_FOLLOW, self.parent )
	ParticleManager:SetParticleControlEnt(buff_effect, 1, self.parent, PATTACH_POINT_FOLLOW, "eye_l", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(buff_effect, 2, self.parent, PATTACH_POINT_FOLLOW, "eye_r", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(buff_effect, 3, self.parent, PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(buff_effect, 4, self.parent, PATTACH_POINT_FOLLOW, "attach_attack2", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(buff_effect, 5, self.parent, PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(buff_effect, 6, self.parent, PATTACH_POINT_FOLLOW, "attach_attack2", Vector(0,0,0), true)
	self:AddParticle(buff_effect, false, false, -1, false, false)
	
	EmitSoundOn( "Hero_Marci.Unleash.Charged", self.parent )
	
	if IsServer() then
		self.parent:AddActivityModifier("unleash")
	else
		self.stack_effect = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_unleash_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent )
		ParticleManager:SetParticleControl( self.stack_effect, 1, Vector( 0, self.counter, 0 ) )
		-- ParticleManager:ReleaseParticleIndex( self.stack_effect )
		self:AddParticle(self.stack_effect, false, false, 1, false, true)
		self:StartIntervalThink(0.1)
	end
end

function modifier_marci_unleash_lua_fury:UpdateStackParticle()
	local count = self:GetStackCount()
	local offset = 8
	if not self.stack_effect then return end
	ParticleManager:SetParticleControl(self.stack_effect, 1, Vector(0, count, 0))
	ParticleManager:SetParticleControl(self.stack_effect, 9, Vector(offset, 0, 0))
end

function modifier_marci_unleash_lua_fury:ForceDestroy()
	self.forced = true
	self:Destroy()
end

function modifier_marci_unleash_lua_fury:OnDestroy()
	if not IsServer() then return end
	if not self or self:IsNull() then return end
	if not self.parent or self.parent:IsNull() then return end

	self.parent:ClearActivityModifiers()

	local main = self.parent:FindModifierByName("modifier_marci_unleash_lua")
	if not main then
		if self.stack_effect then
			ParticleManager:DestroyParticle(self.stack_effect, true)
			ParticleManager:ReleaseParticleIndex(self.stack_effect)
		end
		return
	end	
	if self.forced then return end	-- check if forced destroy by main modifier

	-- create recovery modifier
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_marci_unleash_lua_recovery", {duration = self.recovery, })

end

function modifier_marci_unleash_lua_fury:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_IGNORE_ATTACKSPEED_LIMIT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}
end

function modifier_marci_unleash_lua_fury:GetModifierAttackSpeed_Limit()
	return 1
end

function modifier_marci_unleash_lua_fury:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_as
end

function modifier_marci_unleash_lua_fury:OnAttack( params )
	if params.attacker ~= self.parent then return end

	-- start combo timer
	self:StartIntervalThink( self.timer )

	-- reduce counter
	self.counter = self.counter - 1
	self:SetStackCount( self.counter )

	local attack_effect = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_unleash_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:SetParticleControlEnt(attack_effect, 1, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
	ParticleManager:ReleaseParticleIndex( attack_effect )

	params.target:AddNewModifier(self.parent, self.ability, "modifier_marci_unleash_flurry_pulse_debuff", { duration = self.duration })

	if self.counter <= 0 then
		self:Pulse( params.target:GetOrigin() )
		self:Destroy()
	end

end

function modifier_marci_unleash_lua_fury:GetActivityTranslationModifiers()
	if self:GetStackCount() == 1 then
		return "flurry_pulse_attack"
	end

	if self:GetStackCount()%2 == 0 then
		return "flurry_attack_b"
	end

	return "flurry_attack_a"
end

function modifier_marci_unleash_lua_fury:OnIntervalThink()
	if IsClient() then
		self:UpdateStackParticle()
	else
		-- Combo timer expires
		self:Destroy()
	end
end

function modifier_marci_unleash_lua_fury:Pulse( center )
	-- Hit that pulse, origin of pulse is the parent when casting spells and the target when autoattacking
	-- dispose has to cast pulse around the target
	local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(), center, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)

	local damage_table = {
		-- victim = target,
		attacker = self.parent,
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self.ability,
	}

	for _,enemy in pairs(enemies) do
		damage_table.victim = enemy
		ApplyDamage(damage_table)

		-- 1.5s silence talent
		if self.parent:HasTalent("special_bonus_unique_marci_unleash_silence") then
			enemy:AddNewModifier(self.parent, self.ability, "modifier_marci_unleash_pulse_silence", { duration = self.parent:GetTalentValue("special_bonus_unique_marci_unleash_silence") })
		end
	end

	-- particles
	local pulse_effect = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_unleash_pulse.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( pulse_effect, 0, center )
	ParticleManager:SetParticleControl( pulse_effect, 1, Vector(self.radius, self.radius, self.radius) )
	ParticleManager:ReleaseParticleIndex( pulse_effect )

	EmitSoundOnLocationWithCaster( center, "Hero_Marci.Unleash.Pulse", self.parent )
end

function modifier_marci_unleash_lua_fury:ShouldUseOverheadOffset() return true end


-----------------------------------------------------------------------------------------------------------------------------------------------------------


modifier_marci_unleash_lua_recovery = class({})

function modifier_marci_unleash_lua_recovery:IsHidden() return false end
function modifier_marci_unleash_lua_recovery:IsDebuff() return true end
function modifier_marci_unleash_lua_recovery:IsPurgable() return false end

function modifier_marci_unleash_lua_recovery:OnCreated( kv )
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	if not self.parent or self.parent:IsNull() then return end
	if not self.ability or self.ability:IsNull() then return end

	self.rate = self.ability:GetSpecialValueFor( "recovery_fixed_attack_rate" )

end

function modifier_marci_unleash_lua_recovery:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_marci_unleash_lua_recovery:ForceDestroy()
	self.forced = true
	self:Destroy()
end

function modifier_marci_unleash_lua_recovery:OnDestroy()
	if not IsServer() then return end
	if not self or self:IsNull() then return end
	if not self.parent or self.parent:IsNull() then return end

	local main = self.parent:FindModifierByName("modifier_marci_unleash_lua")
	if not main then return end
	if self.forced then return end	-- check if forced destroy by main modifier

	-- readd fury charge
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_marci_unleash_lua_fury", {})
end

function modifier_marci_unleash_lua_recovery:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_FIXED_ATTACK_RATE,
	}
end

function modifier_marci_unleash_lua_recovery:GetModifierFixedAttackRate( params )
	return self.rate
end