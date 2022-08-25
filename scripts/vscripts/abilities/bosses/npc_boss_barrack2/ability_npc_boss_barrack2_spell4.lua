ability_npc_boss_barrack2_spell4 = class({})

LinkLuaModifier( "modifier_ability_npc_boss_barrack2_spell4","abilities/bosses/npc_boss_barrack2/ability_npc_boss_barrack2_spell4", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_npc_boss_barrack2_spell4_aura_effect","abilities/bosses/npc_boss_barrack2/ability_npc_boss_barrack2_spell4", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_npc_boss_barrack2_spell4_thinker","abilities/bosses/npc_boss_barrack2/ability_npc_boss_barrack2_spell4", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_arc_lua","abilities/bosses/npc_boss_barrack2/ability_npc_boss_barrack2_spell4", LUA_MODIFIER_MOTION_NONE )

function ability_npc_boss_barrack2_spell4:GetIntrinsicModifierName()
    return "modifier_ability_npc_boss_barrack2_spell4"
end

modifier_ability_npc_boss_barrack2_spell4 = class({})

--Classifications template
function modifier_ability_npc_boss_barrack2_spell4:IsHidden()
    return true
end

function modifier_ability_npc_boss_barrack2_spell4:IsPurgable()
    return false
end

function modifier_ability_npc_boss_barrack2_spell4:RemoveOnDeath()
    return true
end

function modifier_ability_npc_boss_barrack2_spell4:OnCreated()
    if IsClient() then
        return
    end
    self:StartIntervalThink(1)
end

function modifier_ability_npc_boss_barrack2_spell4:OnIntervalThink()
    CreateModifierThinker(self:GetCaster(), self:GetAbility(), "modifier_ability_npc_boss_barrack2_spell4_thinker", {duration = 1.6}, self:GetCaster():GetOrigin() + RandomVector(RandomInt(150, 500)), self:GetCaster():GetTeamNumber(), false)
end

-- Aura template
function modifier_ability_npc_boss_barrack2_spell4:IsAura()
    return true
end

function modifier_ability_npc_boss_barrack2_spell4:GetModifierAura()
    return "modifier_ability_npc_boss_barrack2_spell4_aura_effect"
end

function modifier_ability_npc_boss_barrack2_spell4:GetAuraRadius()
    return 1000
end

function modifier_ability_npc_boss_barrack2_spell4:GetAuraDuration()
    return 0.5
end

function modifier_ability_npc_boss_barrack2_spell4:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_ability_npc_boss_barrack2_spell4:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_ability_npc_boss_barrack2_spell4:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

modifier_ability_npc_boss_barrack2_spell4_thinker = class({})

function modifier_ability_npc_boss_barrack2_spell4_thinker:OnCreated()
    local pfx = ParticleManager:CreateParticle("particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_bubbles_fxset.vpcf", PATTACH_POINT, self:GetParent())
    ParticleManager:ReleaseParticleIndex(pfx)
end

function modifier_ability_npc_boss_barrack2_spell4_thinker:OnDestroy()
    local pfx = ParticleManager:CreateParticle("particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_splash_fxset.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
    ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(pfx)
    if IsClient() then
        return
    end
    local enemies = FindUnitsInRadius(DOTA_TEAM_BADGUYS, self:GetParent():GetAbsOrigin(), nil, 225, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, 0,false)
    for _,unit in pairs(enemies) do
        unit:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_generic_arc_lua", {
        height = 500, duration = 1.6, isStun = true, activity = ACT_DOTA_FLAIL})
    end
    UTIL_Remove(self:GetParent())
end

modifier_ability_npc_boss_barrack2_spell4_aura_effect = class({})
--Classifications template
function modifier_ability_npc_boss_barrack2_spell4_aura_effect:IsHidden()
    return false
end

function modifier_ability_npc_boss_barrack2_spell4_aura_effect:IsDebuff()
    return true
end

function modifier_ability_npc_boss_barrack2_spell4_aura_effect:IsPurgable()
    return true
end

function modifier_ability_npc_boss_barrack2_spell4_aura_effect:RemoveOnDeath()
    return true
end

function modifier_ability_npc_boss_barrack2_spell4_aura_effect:OnCreated()
    if IsClient() then
        return
    end
    self.persent = self:GetAbility():GetSpecialValueFor("persent") * 0.01
    self:SetStackCount(0)
    self:StartIntervalThink(1)
end

function modifier_ability_npc_boss_barrack2_spell4_aura_effect:OnIntervalThink()
    self:IncrementStackCount()
    if self:GetStackCount() >= 4 then
        ApplyDamage({victim = self:GetParent(),
        damage = self:GetParent():GetHealth() * self.persent,
        damage_type = DAMAGE_TYPE_MAGICAL,
        damage_flags = DOTA_DAMAGE_FLAG_NONE,
        attacker = self:GetCaster(),
        ability = self:GetAbility()})
    end
end

















modifier_generic_arc_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_generic_arc_lua:IsHidden()
	return true
end

function modifier_generic_arc_lua:IsDebuff()
	return false
end

function modifier_generic_arc_lua:IsStunDebuff()
	return false
end

function modifier_generic_arc_lua:IsPurgable()
	return true
end

function modifier_generic_arc_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_generic_arc_lua:OnCreated( kv )
	if not IsServer() then return end
    self.damage = self:GetAbility():GetSpecialValueFor("damage")
	self.interrupted = false
	self:SetJumpParameters( kv )
	self:Jump()
end

function modifier_generic_arc_lua:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_generic_arc_lua:OnRemoved()
end

function modifier_generic_arc_lua:OnDestroy()
	if not IsServer() then return end

	-- preserve height
	local pos = self:GetParent():GetAbsOrigin()

	self:GetParent():RemoveHorizontalMotionController( self )
	self:GetParent():RemoveVerticalMotionController( self )

	-- preserve height if has end offset
	if self.end_offset~=0 then
		self:GetParent():SetOrigin( pos )
	end

	if self.endCallback then
		self.endCallback( self.interrupted )
	end
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_generic_arc_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DISABLE_TURNING,
	}
	if self:GetStackCount()>0 then
		table.insert( funcs, MODIFIER_PROPERTY_OVERRIDE_ANIMATION )
	end

	return funcs
end

function modifier_generic_arc_lua:GetModifierDisableTurning()
	if not self.isForward then return end
	return 1
end
function modifier_generic_arc_lua:GetOverrideAnimation()
	return self:GetStackCount()
end
--------------------------------------------------------------------------------
-- Status Effects
function modifier_generic_arc_lua:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = self.isStun or false,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = self.isRestricted or false,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Motion Effects
function modifier_generic_arc_lua:UpdateHorizontalMotion( me, dt )
	if self.fix_duration and self:GetElapsedTime()>=self.duration then return end
    ApplyDamage({victim = self:GetParent(),
    damage = self.damage * dt,
    damage_type = DAMAGE_TYPE_MAGICAL,
    damage_flags = DOTA_DAMAGE_FLAG_NONE,
    attacker = self:GetCaster(),
    ability = self:GetAbility()})
	local pos = me:GetAbsOrigin() + self.direction * self.speed * dt
	me:SetOrigin( pos )
end

function modifier_generic_arc_lua:UpdateVerticalMotion( me, dt )
	if self.fix_duration and self:GetElapsedTime()>=self.duration then return end

	local pos = me:GetAbsOrigin()
	local time = self:GetElapsedTime()

	-- set relative position
	local height = pos.z
	local speed = self:GetVerticalSpeed( time )
	pos.z = height + speed * dt
	me:SetOrigin( pos )

	if not self.fix_duration then
		local ground = GetGroundHeight( pos, me ) + self.end_offset
		if pos.z <= ground then

			-- below ground, set height as ground then destroy
			pos.z = ground
			me:SetOrigin( pos )
			self:Destroy()
		end
	end
end

function modifier_generic_arc_lua:OnHorizontalMotionInterrupted()
	self.interrupted = true
	self:Destroy()
end

function modifier_generic_arc_lua:OnVerticalMotionInterrupted()
	self.interrupted = true
	self:Destroy()
end

--------------------------------------------------------------------------------
-- Motion Helper
function modifier_generic_arc_lua:SetJumpParameters( kv )
	self.parent = self:GetParent()

	-- load types
	self.fix_end = true
	self.fix_duration = true
	self.fix_height = true
	if kv.fix_end then
		self.fix_end = kv.fix_end==1
	end
	if kv.fix_duration then
		self.fix_duration = kv.fix_duration==1
	end
	if kv.fix_height then
		self.fix_height = kv.fix_height==1
	end

	-- load other types
	self.isStun = kv.isStun==1
	self.isRestricted = kv.isRestricted==1
	self.isForward = kv.isForward==1
	self.activity = kv.activity or 0
	self:SetStackCount( self.activity )

	-- load direction
	if kv.target_x and kv.target_y then
		local origin = self.parent:GetAbsOrigin()
		local dir = Vector( kv.target_x, kv.target_y, 0 ) - origin
		dir.z = 0
		dir = dir:Normalized()
		self.direction = dir
	end
	if kv.dir_x and kv.dir_y then
		self.direction = Vector( kv.dir_x, kv.dir_y, 0 ):Normalized()
	end
	if not self.direction then
		self.direction = self.parent:GetForwardVector()
	end

	-- load horizontal data
	self.duration = kv.duration
	self.distance = kv.distance
	self.speed = kv.speed
	if not self.duration then
		self.duration = self.distance/self.speed
	end
	if not self.distance then
		self.speed = self.speed or 0
		self.distance = self.speed*self.duration
	end
	if not self.speed then
		self.distance = self.distance or 0
		self.speed = self.distance/self.duration
	end

	-- load vertical data
	self.height = kv.height or 0
	self.start_offset = kv.start_offset or 0
	self.end_offset = kv.end_offset or 0

	-- calculate height positions
	local pos_start = self.parent:GetAbsOrigin()
	local pos_end = pos_start + self.direction * self.distance
	local height_start = GetGroundHeight( pos_start, self.parent ) + self.start_offset
	local height_end = GetGroundHeight( pos_end, self.parent ) + self.end_offset
	local height_max

	-- determine jumping height if not fixed
	if not self.fix_height then
	
		-- ideal height is proportional to max distance
		self.height = math.min( self.height, self.distance/4 )
	end

	-- determine height max
	if self.fix_end then
		height_end = height_start
		height_max = height_start + self.height
	else
		-- calculate height
		local tempmin, tempmax = height_start, height_end
		if tempmin>tempmax then
			tempmin,tempmax = tempmax, tempmin
		end
		local delta = (tempmax-tempmin)*2/3

		height_max = tempmin + delta + self.height
	end

	-- set duration
	if not self.fix_duration then
		self:SetDuration( -1, false )
	else
		self:SetDuration( self.duration, true )
	end

	-- calculate arc
	self:InitVerticalArc( height_start, height_max, height_end, self.duration )
end

function modifier_generic_arc_lua:Jump()
	-- apply horizontal motion
	if self.distance>0 then
		if not self:ApplyHorizontalMotionController() then
			self.interrupted = true
			self:Destroy()
		end
	end

	-- apply vertical motion
	if self.height>0 then
		if not self:ApplyVerticalMotionController() then
			self.interrupted = true
			self:Destroy()
		end
	end
end

function modifier_generic_arc_lua:InitVerticalArc( height_start, height_max, height_end, duration )
	local height_end = height_end - height_start
	local height_max = height_max - height_start

	-- fail-safe1: height_max cannot be smaller than height delta
	if height_max<height_end then
		height_max = height_end+0.01
	end

	-- fail-safe2: height-max must be positive
	if height_max<=0 then
		height_max = 0.01
	end

	-- math magic
	local duration_end = ( 1 + math.sqrt( 1 - height_end/height_max ) )/2
	self.const1 = 4*height_max*duration_end/duration
	self.const2 = 4*height_max*duration_end*duration_end/(duration*duration)
end

function modifier_generic_arc_lua:GetVerticalPos( time )
	return self.const1*time - self.const2*time*time
end

function modifier_generic_arc_lua:GetVerticalSpeed( time )
	return self.const1 - 2*self.const2*time
end

--------------------------------------------------------------------------------
-- Helper
function modifier_generic_arc_lua:SetEndCallback( func )
	self.endCallback = func
end