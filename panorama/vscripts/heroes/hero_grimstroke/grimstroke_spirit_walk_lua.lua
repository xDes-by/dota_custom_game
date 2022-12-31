grimstroke_spirit_walk_lua = class({})
LinkLuaModifier( "modifier_grimstroke_spirit_walk_lua", "heroes/hero_grimstroke/grimstroke_spirit_walk_lua", LUA_MODIFIER_MOTION_NONE )

function grimstroke_spirit_walk_lua:GetCooldown(level)
	return self.BaseClass.GetCooldown(self, level) - self:GetCaster():FindTalentValue("special_bonus_unique_grimstroke_7")
end

function grimstroke_spirit_walk_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	if not caster or caster:IsNull() then return end
	if not target or target:IsNull() then return end

	-- load data
	local duration = self:GetSpecialValueFor("buff_duration")

	-- add modifier
	target:AddNewModifier( caster, self, "modifier_grimstroke_spirit_walk_lua", { duration = duration })

	-- effects
	local cast_pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_grimstroke/grimstroke_cast_ink_swell.vpcf" , PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:ReleaseParticleIndex( cast_pfx )
	EmitSoundOn( "Hero_Grimstroke.InkSwell.Cast", caster )
end



modifier_grimstroke_spirit_walk_lua = class({})

function modifier_grimstroke_spirit_walk_lua:IsHidden() return false end
function modifier_grimstroke_spirit_walk_lua:IsDebuff() return false end
function modifier_grimstroke_spirit_walk_lua:IsPurgable() return true end

function modifier_grimstroke_spirit_walk_lua:GetStatusEffectName()
	return "particles/status_fx/status_effect_grimstroke_ink_swell.vpcf"
end

function modifier_grimstroke_spirit_walk_lua:OnCreated()
	local parent = self:GetParent()
	local caster = self:GetCaster()
	local ability = self:GetAbility()

	if not caster or caster:IsNull() then return end
	if not parent or parent:IsNull() then return end
	if not ability or ability:IsNull() then return end

	self.movespeed_bonus_pct = ability:GetSpecialValueFor("movespeed_bonus_pct")
	self.radius = ability:GetSpecialValueFor("radius")
	self.max_damage = ability:GetSpecialValueFor("max_damage")
	self.max_stun = ability:GetSpecialValueFor("max_stun")
	local damage_per_tick = ability:GetSpecialValueFor("damage_per_tick")
	self.heal_per_tick = 0
	self.tick_rate = ability:GetSpecialValueFor("tick_rate")
	self.tick_dps_tooltip = ability:GetSpecialValueFor("tick_dps_tooltip")
	self.max_threshold_duration = ability:GetSpecialValueFor("max_threshold_duration")
	self.shard_amp_pct = ability:GetSpecialValueFor("shard_amp_pct")

	-- talents
	self.radius = self.radius + caster:FindTalentValue("special_bonus_unique_grimstroke_1")		-- +150 Ink Swell Radius
	self.movespeed_bonus_pct = self.movespeed_bonus_pct + caster:FindTalentValue("special_bonus_unique_grimstroke_6")		-- +16% Ink Swell MS

	if not IsServer() then return end

	-- tick counter
	self.tick_counter = 0

	-- shard 
	if caster:HasShard() then
		damage_per_tick = damage_per_tick * (1 + self.shard_amp_pct / 100 )
		self.heal_per_tick = damage_per_tick * self.shard_amp_pct / 100
	end

	-- precache damage tick
	self.damage_per_tick_table = {
		attacker = caster,
		damage = damage_per_tick,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = ability,
	}

	self:StartIntervalThink( self.tick_rate )

	-- particles
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_grimstroke/grimstroke_ink_swell_buff.vpcf", PATTACH_OVERHEAD_FOLLOW, parent )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.radius, self.radius, self.radius ) )
	ParticleManager:SetParticleControlEnt( effect_cast, 3, parent, PATTACH_ABSORIGIN_FOLLOW, nil, parent:GetOrigin(), true )

	-- buff particle
	self:AddParticle( effect_cast, false, false, -1, false, true )

	EmitSoundOn( "Hero_Grimstroke.InkSwell.Target", parent )
	
end

function modifier_grimstroke_spirit_walk_lua:OnRefresh()
	self:OnCreated()
end

function modifier_grimstroke_spirit_walk_lua:OnDestroy()

	if not IsServer() then return end
	local parent = self:GetParent()
	local caster = self:GetCaster()
	local ability = self:GetAbility()

	if not caster or caster:IsNull() then return end
	if not parent or parent:IsNull() or not parent:IsAlive() then return end
	if not ability or ability:IsNull() then return end

	-- find enemies
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )

	-- damage and stun calculations
	local tmp = self.max_threshold_duration / self.tick_rate		-- at about 12.5 ticks you reach max damage and stun, this is a constant
	local stun_instance = self.max_stun / tmp
	local damage_instance = self.max_damage / tmp

	local stun_duration = math.min(self.max_stun, stun_instance * self.tick_counter)
	local stun_damage = math.min(self.max_damage, damage_instance * self.tick_counter)
	local stun_heal = 0

	-- shard 
	if caster:HasShard() then
		stun_damage = stun_damage * (1 + self.shard_amp_pct / 100 )
		stun_heal = stun_damage * self.shard_amp_pct / 100
	end

	local stun_damage_table = {
		attacker = caster,
		damage = stun_damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = ability,
	}

	for _, enemy in pairs(enemies) do
		if enemy and not enemy:IsNull() and not enemy:IsMagicImmune() then

			-- damage
			stun_damage_table.victim = enemy
			ApplyDamage( stun_damage_table )

			-- stun
			enemy:AddNewModifier( caster, ability, "modifier_stunned", { 
				duration = enemy:ApplyStatusResistance(stun_duration)
			})
			
			-- shard heal
			if caster:HasShard() then
				parent:Heal(stun_heal, caster)
			end
		end
	end

	-- shard strong dispel after damage and stun is applied to enemies
	if caster:HasShard() then
		parent:Purge(false, true, false, true, false)
	end

	-- effects
	local ink_swell_aoe_pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_grimstroke/grimstroke_ink_swell_aoe.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
	ParticleManager:SetParticleControl( ink_swell_aoe_pfx, 2, Vector( self.radius, self.radius, self.radius ) )
	ParticleManager:ReleaseParticleIndex( ink_swell_aoe_pfx )
	
	StopSoundOn( "Hero_Grimstroke.InkSwell.Target", parent )
	EmitSoundOn( "Hero_Grimstroke.InkSwell.Stun", parent )
	
end

function modifier_grimstroke_spirit_walk_lua:OnIntervalThink()
	
	if not IsServer() then return end
	local caster = self:GetCaster()
	local parent = self:GetParent()

	if not caster or caster:IsNull() then return end
	if not parent or parent:IsNull() then return end

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	for _,enemy in pairs(enemies) do
		if enemy and not enemy:IsNull() and not enemy:IsMagicImmune() then
			-- damage
			self.damage_per_tick_table.victim = enemy
			ApplyDamage(self.damage_per_tick_table)

			-- shard heal
			if caster:HasShard() then
				parent:Heal(self.heal_per_tick, caster)
			end

			-- add to tick_counter
			self.tick_counter = self.tick_counter + 1

			-- particles
			local tick_pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_grimstroke/grimstroke_ink_swell_tick_damage.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
			ParticleManager:SetParticleControlEnt( tick_pfx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
			ParticleManager:SetParticleControlEnt( tick_pfx, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
			ParticleManager:ReleaseParticleIndex( tick_pfx )

			EmitSoundOn( "Hero_Grimstroke.InkSwell.Damage", enemy )
		end
	end
end

function modifier_grimstroke_spirit_walk_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end

function modifier_grimstroke_spirit_walk_lua:GetModifierMoveSpeedBonus_Percentage()
	return self.movespeed_bonus_pct
end