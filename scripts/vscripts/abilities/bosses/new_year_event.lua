magic_weakness = class({})

LinkLuaModifier( "magic_weakness_aura", "abilities/bosses/new_year_event.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "magic_weakness_aura_debuff", "abilities/bosses/new_year_event.lua", LUA_MODIFIER_MOTION_NONE )

function magic_weakness:GetIntrinsicModifierName()
    return "magic_weakness_aura"
end

magic_weakness_aura = class({})

function magic_weakness_aura:IsHidden()
	return true
end

function magic_weakness_aura:IsDebuff()
	return false
end

function magic_weakness_aura:IsPurgable()
	return false
end

function magic_weakness_aura:IsAura()
	return true
end

function magic_weakness_aura:GetModifierAura()
	return "magic_weakness_aura_debuff"
end

function magic_weakness_aura:GetAuraDuration()
	return 5
end

function magic_weakness_aura:GetAuraRadius()
	return 1500
end

function magic_weakness_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function magic_weakness_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

magic_weakness_aura_debuff = class({})

function magic_weakness_aura_debuff:IsHidden()
	return false
end

function magic_weakness_aura_debuff:IsDebuff()
	return true
end

function magic_weakness_aura_debuff:IsPurgable()
	return false
end

function magic_weakness_aura_debuff:OnCreated()
    self:StartIntervalThink(1)
end

function magic_weakness_aura_debuff:OnIntervalThink()
    if not IsServer() then return end
    if self:GetStackCount() >= 10 then
        local damage = self:GetParent():GetHealth() * (self:GetStackCount() - 10) * 0.01
	    ApplyDamage({victim = self:GetParent(), attacker = self:GetAbility():GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_PURE,damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
    end
    self:IncrementStackCount()
end

function magic_weakness_aura_debuff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
    }
end

function magic_weakness_aura_debuff:GetModifierHealthRegenPercentage()
    return self:GetStackCount() * -0.7
end

-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------

disruptor_krug = class({})

function disruptor_krug:GetIntrinsicModifierName()
    return "disruptor_kinetic_helper"
end

LinkLuaModifier( "disruptor_kinetic_helper", "abilities/bosses/new_year_event.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "disruptor_kinetic", "abilities/bosses/new_year_event.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "disruptor_thunder_strike", "abilities/bosses/new_year_event.lua", LUA_MODIFIER_MOTION_NONE )

disruptor_kinetic_helper = class({})
function disruptor_kinetic_helper:IsHidden()
    return true
end

function disruptor_kinetic_helper:OnCreated()
    self:StartIntervalThink(20)
end

function disruptor_kinetic_helper:OnIntervalThink()
    if not IsServer() then return end
	local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(),self:GetParent():GetOrigin(),nil,900,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,FIND_CLOSEST,false)
    if enemies[1] == nil then return end
    for i=1,#enemies do
        local target = enemies[i]
	    CreateModifierThinker(self:GetParent(),self:GetAbility(),"disruptor_kinetic",{}, target:GetOrigin(),self:GetParent():GetTeamNumber(),false)
    end
end

disruptor_kinetic = class({})

function disruptor_kinetic:IsHidden()
	return false
end

function disruptor_kinetic:IsDebuff()
	return true
end

function disruptor_kinetic:IsPurgable()
	return true
end

function disruptor_kinetic:OnCreated( kv )
	if not IsServer() then return end
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

	self.owner = kv.isProvidedByAura~=1

	if self.owner then
		self.delay = self:GetAbility():GetSpecialValueFor( "formation_time" )
		self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
		self:SetDuration( self.delay + self.duration, false )
		self.formed = false
		self:StartIntervalThink( self.delay )
		self:PlayEffects1()
		self.sound_loop = "Hero_Disruptor.KineticField"
		EmitSoundOn( self.sound_loop, self:GetParent() )
	else
		self.aura_origin = Vector( kv.aura_origin_x, kv.aura_origin_y, 0 )
		
		self.width = 100
		self.max_speed = 550
		self.min_speed = 0.1
		self.max_min = self.max_speed-self.min_speed
		self.inside = (self:GetParent():GetOrigin()-self.aura_origin):Length2D() < self.radius
	end
end

function disruptor_kinetic:OnDestroy()
	if not IsServer() then return end
	if self.owner then
		-- stop sound
		StopSoundOn( self.sound_loop, self:GetParent() )
		local sound_end = "Hero_Disruptor.KineticField.End"
		EmitSoundOn( sound_end, self:GetParent() )

		-- remove thinker
		UTIL_Remove( self:GetParent() )
	end
end

function disruptor_kinetic:OnIntervalThink()
	self:StartIntervalThink( -1 )
	local caster = self:GetCaster()
	local target = self:GetParent()	
	self.formed = true
	self:PlayEffects2()
end

function disruptor_kinetic:IsAura()
	return self.owner and self.formed
end

function disruptor_kinetic:GetModifierAura()
	return "disruptor_thunder_strike"
end

function disruptor_kinetic:GetAuraRadius()
	return self.radius
end

function disruptor_kinetic:GetAuraDuration()
	return 0.3
end

function disruptor_kinetic:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function disruptor_kinetic:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function disruptor_kinetic:GetAuraSearchFlags()
	return 0
end

function disruptor_kinetic:GetAuraEntityReject( hEntity )
	if IsServer() then end
	return false
end


function disruptor_kinetic:PlayEffects1()
	local particle_cast = "particles/units/heroes/hero_disruptor/disruptor_kineticfield_formation.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.delay, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function disruptor_kinetic:PlayEffects2()
	local particle_cast = "particles/units/heroes/hero_disruptor/disruptor_kineticfield.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.duration, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

disruptor_thunder_strike = class({})

function disruptor_thunder_strike:GetTexture()
	return "disruptor_thunder_strike"
end

function disruptor_thunder_strike:IsHidden()
	return false
end

function disruptor_thunder_strike:IsDebuff()
	return true
end

function disruptor_thunder_strike:IsPurgable()
	return false
end

function disruptor_thunder_strike:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_LIMIT
	}
end

function disruptor_thunder_strike:GetModifierMoveSpeed_Limit()
    return 100
end

function disruptor_thunder_strike:OnCreated( kv )
    if not IsServer() then return end
	self.count = self:GetAbility():GetSpecialValueFor( "strikes" )
	self.radius = self:GetAbility():GetSpecialValueFor( "damage_radius" )
	local interval = self:GetAbility():GetSpecialValueFor( "strike_interval" )
	local damage = self:GetParent():GetHealth() * 0.05

	if IsServer() then
		self.damageTable = {attacker = self:GetCaster(),damage = damage,damage_type = DAMAGE_TYPE_MAGICAL,ability = self:GetAbility()}
		local duration = (self.count-1) * interval
		self:StartIntervalThink( interval )
		self:OnIntervalThink()
		self.sound_loop = "Hero_Disruptor.ThunderStrike.Thunderator"
		EmitSoundOn( self.sound_loop, self:GetParent() )
	end
end

function disruptor_thunder_strike:OnRefresh( kv )
    if not IsServer() then return end
	local damage = self:GetParent():GetHealth() * 0.02
	self.count = self:GetAbility():GetSpecialValueFor( "strikes" )
	local interval = self:GetAbility():GetSpecialValueFor( "strike_interval" )

	if IsServer() then
		self.damageTable.damage = damage
		local duration = (self.count-1) * interval
		self:SetDuration( duration, true )
		self:StartIntervalThink( interval )
		self:OnIntervalThink()
	end
end

function disruptor_thunder_strike:OnRemoved()
end

function disruptor_thunder_strike:OnDestroy()
	if not IsServer() then return end
	StopSoundOn( self.sound_loop, self:GetParent() )
end

function disruptor_thunder_strike:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

function disruptor_thunder_strike:OnIntervalThink()
    local damage = self:GetParent():GetHealth() * 0.02
	self.damageTable.damage = damage
	local duration = self:GetAbility():GetSpecialValueFor("ministun")
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),self:GetParent():GetOrigin(),nil,self.radius,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,0,false)
	for _,enemy in pairs(enemies) do
		if not enemy:IsAncient() or not enemy:IsMagicImmune() then
			self.damageTable.victim = enemy
			ApplyDamage( self.damageTable )
			enemy:AddNewModifier(enemy,self:GetAbility(),"fissure_rooted",{ duration = duration })
		end
	end
	self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_stunned",{ duration = duration })
	self.damageTable.victim = self:GetParent()
	ApplyDamage( self.damageTable )
	self:PlayEffects()
	self.count = self.count-1
	if self.count<1 then
		self:Destroy()
	end
end

function disruptor_thunder_strike:GetEffectName()
	return "particles/units/heroes/hero_disruptor/disruptor_thunder_strike_buff.vpcf"
end

function disruptor_thunder_strike:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function disruptor_thunder_strike:PlayEffects()
	local particle_cast = "particles/units/heroes/hero_disruptor/disruptor_thunder_strike_bolt.vpcf"
	local sound_cast = "Hero_Disruptor.ThunderStrike.Target"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(effect_cast,1,self:GetParent(),PATTACH_POINT_FOLLOW,"attach_hitloc",Vector(0,0,0), true)
	ParticleManager:SetParticleControl( effect_cast, 2, self:GetParent():GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end

-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------

cm_kolba = class({})

LinkLuaModifier( "colba_attack", "abilities/bosses/new_year_event.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_frostbite_lua", "abilities/bosses/new_year_event.lua", LUA_MODIFIER_MOTION_NONE )

function cm_kolba:GetIntrinsicModifierName()
    return "colba_attack"
end

colba_attack = class({})

function colba_attack:IsHidden()
	return true
end

function colba_attack:IsDebuff()
	return false
end

function colba_attack:IsPurgable()
	return false
end

function colba_attack:OnCreated()
	self.attack_do_zamorozki = 0
    self.max_attack_do_zamorozki = 20
end

function colba_attack:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end

function colba_attack:OnAttackLanded(keys)
	local target = keys.target
	local attacker = keys.attacker
    if attacker:HasModifier("colba_attack") then
		target:AddNewModifier(attacker,self:GetAbility(),"modifier_crystal_maiden_crystal_nova_lua",{ duration = 1 })
        self.attack_do_zamorozki = self.attack_do_zamorozki + 1
        if self.attack_do_zamorozki >= self.max_attack_do_zamorozki then
            self.attack_do_zamorozki = 0
            target:AddNewModifier(attacker,self:GetAbility(),"modifier_crystal_maiden_frostbite_lua",{ duration = 3 })
	        target:AddNewModifier(attacker,self:GetAbility(),"modifier_stunned",{ duration = 0.1 })
        end
    end
end

modifier_crystal_maiden_frostbite_lua = class({})

function modifier_crystal_maiden_frostbite_lua:IsHidden()
	return false
end

function modifier_crystal_maiden_frostbite_lua:IsDebuff()
	return true
end

function modifier_crystal_maiden_frostbite_lua:IsStunDebuff()
	return false
end

function modifier_crystal_maiden_frostbite_lua:IsPurgable()
	return true
end

function modifier_crystal_maiden_frostbite_lua:OnCreated( kv )
	local tick_damage = self:GetParent():GetHealth() * 0.01
	self.interval = 0.5

	if IsServer() then
		self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = tick_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}
		self:StartIntervalThink( self.interval )
		self:OnIntervalThink()
		self.sound_target = "hero_Crystal.frostbite"
		EmitSoundOn( self.sound_target, self:GetParent() )
	end
end

function modifier_crystal_maiden_frostbite_lua:OnRefresh( kv )
	local tick_damage = self:GetParent():GetHealth() * 0.01
	self.interval = 0.5

	if IsServer() then
		self.damageTable = {victim = self:GetParent(),attacker = self:GetCaster(),damage = tick_damage,damage_type = DAMAGE_TYPE_MAGICAL,damage_flags = DOTA_DAMAGE_FLAG_NONE,ability = self,}
		self:StartIntervalThink( self.interval )
		self:OnIntervalThink()
		self.sound_target = "hero_Crystal.frostbite"
		EmitSoundOn( self.sound_target, self:GetParent() )
	end
end

function modifier_crystal_maiden_frostbite_lua:OnDestroy()
	StopSoundOn( self.sound_target, self:GetParent() )
end

function modifier_crystal_maiden_frostbite_lua:CheckState()
	local state = {
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_ROOTED] = true,
	[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

function modifier_crystal_maiden_frostbite_lua:OnIntervalThink()
	ApplyDamage( self.damageTable )
end

function modifier_crystal_maiden_frostbite_lua:GetEffectName()
	return "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf"
end

function modifier_crystal_maiden_frostbite_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------

crystal_maiden_crystal_nova_lua = class({})

LinkLuaModifier( "modifier_crystal_maiden_crystal_nova_lua_helper", "abilities/bosses/new_year_event.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_crystal_nova_lua", "abilities/bosses/new_year_event.lua", LUA_MODIFIER_MOTION_NONE )

function crystal_maiden_crystal_nova_lua:GetIntrinsicModifierName()
    return "modifier_crystal_maiden_crystal_nova_lua_helper"
end

modifier_crystal_maiden_crystal_nova_lua_helper = class({})

function modifier_crystal_maiden_crystal_nova_lua_helper:IsHidden()
    return true
end

function modifier_crystal_maiden_crystal_nova_lua_helper:OnCreated()
    self:StartIntervalThink(7)
end

function modifier_crystal_maiden_crystal_nova_lua_helper:OnIntervalThink()
    local caster = self:GetCaster()
	local point = self:GetCaster():GetOrigin() + RandomVector(RandomInt(1,700))
	local radius = 1000
	local debuffDuration = 3	
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),point,nil,radius,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,0,false)
	if enemies[1] == nil then return end
	for _,enemy in pairs(enemies) do
		enemy:AddNewModifier(caster,self,"modifier_crystal_maiden_crystal_nova_lua",{ duration = debuffDuration })
	end
	self:PlayEffects( point, radius, debuffDuration )
end

modifier_crystal_maiden_crystal_nova_lua = class({})

function modifier_crystal_maiden_crystal_nova_lua:IsHidden()
	return false
end

function modifier_crystal_maiden_crystal_nova_lua:IsDebuff()
	return true
end

function modifier_crystal_maiden_crystal_nova_lua:IsStunDebuff()
	return false
end

function modifier_crystal_maiden_crystal_nova_lua:IsPurgable()
	return true
end

function modifier_crystal_maiden_crystal_nova_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_crystal_maiden_crystal_nova_lua:GetModifierMoveSpeed_Limit()
	return 550
end

function modifier_crystal_maiden_crystal_nova_lua:GetModifierAttackSpeedBonus_Constant()
	return -1000
end

function modifier_crystal_maiden_crystal_nova_lua:GetEffectName()
	return "particles/generic_gameplay/generic_slowed_cold.vpcf"
end

function modifier_crystal_maiden_crystal_nova_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_crystal_maiden_crystal_nova_lua_helper:PlayEffects( point, radius, duration )
	local particle_cast = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
	local sound_cast = "Hero_Crystal.CrystalNova"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
end

-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------

npc_dota_hero_enigma_permanent_ability = class({})

LinkLuaModifier( "modifier_npc_dota_hero_enigma_permanent_ability_thinker", "abilities/bosses/new_year_event.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_npc_dota_hero_enigma_permanent_ability_helper", "abilities/bosses/new_year_event.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_npc_dota_hero_enigma_permanent_ability_black_hole", "abilities/bosses/new_year_event.lua", LUA_MODIFIER_MOTION_HORIZONTAL )

function npc_dota_hero_enigma_permanent_ability:GetIntrinsicModifierName()
    return "modifier_npc_dota_hero_enigma_permanent_ability_helper"
end

modifier_npc_dota_hero_enigma_permanent_ability_helper = class({})

function modifier_npc_dota_hero_enigma_permanent_ability_helper:IsHidden()
    return false
end

function modifier_npc_dota_hero_enigma_permanent_ability_helper:OnCreated()
	self:StartIntervalThink(24)
end

function modifier_npc_dota_hero_enigma_permanent_ability_helper:OnIntervalThink()
	if not IsServer() then return end
	local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(),self:GetParent():GetOrigin(),nil,900,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,FIND_CLOSEST,false)
    if enemies[1] == nil then return end
	local caster = self:GetParent()
	local point = self:GetParent():GetAbsOrigin()
	local duration = self:GetAbility():GetSpecialValueFor("duration")

	self.thinker = CreateModifierThinker(caster,self:GetAbility(),"modifier_npc_dota_hero_enigma_permanent_ability_thinker",{ duration = duration },point,caster:GetTeamNumber(),false)
	self.thinker = self.thinker:FindModifierByName("modifier_npc_dota_hero_enigma_permanent_ability_thinker")
end

modifier_npc_dota_hero_enigma_permanent_ability_thinker = class({})

function modifier_npc_dota_hero_enigma_permanent_ability_thinker:IsHidden()
	return false
end

function modifier_npc_dota_hero_enigma_permanent_ability_thinker:IsPurgable()
	return false
end

function modifier_npc_dota_hero_enigma_permanent_ability_thinker:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "far_radius" )
	self.interval = 1
	self.ticks = math.floor(self:GetDuration()/self.interval+0.5) -- round
	self.tick = 0

	if IsServer() then
		-- precache damage
		local damage = self:GetAbility():GetSpecialValueFor( "near_damage" )
		self.damageTable = {
			-- victim = target,
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = DAMAGE_TYPE_PURE,
			ability = self:GetAbility(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
		}
		self:StartIntervalThink( self.interval )
		self:PlayEffects()
	end
end

function modifier_npc_dota_hero_enigma_permanent_ability_thinker:OnRemoved()
	if IsServer() then
		if self:GetRemainingTime()<0.01 and self.tick<self.ticks then
			self:OnIntervalThink()
		end

		UTIL_Remove( self:GetParent() )
	end
end

function modifier_npc_dota_hero_enigma_permanent_ability_thinker:OnDestroy()
	if IsServer() then
		StopSoundOn( self.sound_cast, self:GetCaster() )
	end
end

function modifier_npc_dota_hero_enigma_permanent_ability_thinker:OnIntervalThink()
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),self:GetParent():GetOrigin(),nil,self.radius,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,0,false)

	for _,enemy in pairs(enemies) do
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
	end

	self.tick = self.tick+1
end

function modifier_npc_dota_hero_enigma_permanent_ability_thinker:IsAura()
	return true
end

function modifier_npc_dota_hero_enigma_permanent_ability_thinker:GetModifierAura()
	return "modifier_npc_dota_hero_enigma_permanent_ability_black_hole"
end

function modifier_npc_dota_hero_enigma_permanent_ability_thinker:GetAuraRadius()
	return self.radius 
end

function modifier_npc_dota_hero_enigma_permanent_ability_thinker:GetAuraDuration()
	return 0.1
end

function modifier_npc_dota_hero_enigma_permanent_ability_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_npc_dota_hero_enigma_permanent_ability_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_npc_dota_hero_enigma_permanent_ability_thinker:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_npc_dota_hero_enigma_permanent_ability_thinker:PlayEffects()
	local particle_cast = "particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_snow.vpcf"
	self.sound_cast = "hero_Crystal.freezingField.wind"

	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius , self.radius , 1 ) )
	self:AddParticle(self.effect_cast,false,false,-1,false,false)
	EmitSoundOn( self.sound_cast, self:GetCaster() )
end

modifier_npc_dota_hero_enigma_permanent_ability_black_hole = class({})

function modifier_npc_dota_hero_enigma_permanent_ability_black_hole:IsHidden()
	return false
end

function modifier_npc_dota_hero_enigma_permanent_ability_black_hole:IsDebuff()
	return true
end

function modifier_npc_dota_hero_enigma_permanent_ability_black_hole:IsStunDebuff()
	return true
end

function modifier_npc_dota_hero_enigma_permanent_ability_black_hole:IsPurgable()
	return true
end

function modifier_npc_dota_hero_enigma_permanent_ability_black_hole:OnCreated( kv )
	self.rate = self:GetAbility():GetSpecialValueFor( "animation_rate" )
	self.pull_speed = self:GetAbility():GetSpecialValueFor( "pull_speed" )
	self.rotate_speed = self:GetAbility():GetSpecialValueFor( "pull_rotate_speed" )

	if IsServer() then
		self.center = Vector( kv.aura_origin_x, kv.aura_origin_y, 0 )

		if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
		end
	end
end

function modifier_npc_dota_hero_enigma_permanent_ability_black_hole:OnDestroy()
	if IsServer() then
		self:GetParent():InterruptMotionControllers( true )
	end
end

function modifier_npc_dota_hero_enigma_permanent_ability_black_hole:DeclareFunctions()
	return {

	}
end

function modifier_npc_dota_hero_enigma_permanent_ability_black_hole:CheckState()
	return {
		--[MODIFIER_STATE_STUNNED] = true,
	}
end

function modifier_npc_dota_hero_enigma_permanent_ability_black_hole:UpdateHorizontalMotion( me, dt )
	local target = self:GetParent():GetOrigin()-self.center
	target.z = 0

	local targetL = target:Length2D()-self.pull_speed*dt

	local targetN = target:Normalized()
	local deg = math.atan2( targetN.y, targetN.x )
	local targetN = Vector( math.cos(deg+self.rotate_speed*dt), math.sin(deg+self.rotate_speed*dt), 0 );

	self:GetParent():SetOrigin( self.center + targetN * targetL )


end

function modifier_npc_dota_hero_enigma_permanent_ability_black_hole:OnHorizontalMotionInterrupted()
	self:Destroy()
end