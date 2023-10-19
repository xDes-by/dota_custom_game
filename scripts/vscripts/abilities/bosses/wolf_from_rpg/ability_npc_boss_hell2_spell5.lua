ability_npc_boss_hell2_spell5 = class({})

LinkLuaModifier( "modifier_ability_npc_boss_hell2_spell5","abilities/bosses/wolf_from_rpg/ability_npc_boss_hell2_spell5", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_ability_npc_boss_hell2_spell5_tornado","abilities/bosses/wolf_from_rpg/ability_npc_boss_hell2_spell5", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_npc_boss_hell2_spell5_thinker","abilities/bosses/wolf_from_rpg/ability_npc_boss_hell2_spell5", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_npc_boss_hell2_spell5_effect","abilities/bosses/wolf_from_rpg/ability_npc_boss_hell2_spell5", LUA_MODIFIER_MOTION_NONE )

function ability_npc_boss_hell2_spell5:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_ability_npc_boss_hell2_spell5_tornado",{ duration = 10 })
	self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_ability_npc_boss_hell2_spell5",{ duration = 2.5 })
end

modifier_ability_npc_boss_hell2_spell5_tornado = class({})

function modifier_ability_npc_boss_hell2_spell5_tornado:IsHidden()	
	return false
end

function modifier_ability_npc_boss_hell2_spell5_tornado:IsPurgable()
	return false
end

function modifier_ability_npc_boss_hell2_spell5_tornado:OnCreated()	
	self.spirits_numSpirits		= 0
	self.spirits_spiritsSpawned	= {}
	self.spirits_radius = 500
	self.duration = 10
	self.spirits_movementFactor	= 0
	if not IsServer() then
		return
	end
	self.spirits_startTime		= GameRules:GetGameTime()
	self:StartIntervalThink(0.03)
end

function modifier_ability_npc_boss_hell2_spell5_tornado:OnDestroy()	
	if not IsServer() then
		return
	end
    for _,unit in pairs(self.spirits_spiritsSpawned) do
        UTIL_Remove(unit)
    end
end

function modifier_ability_npc_boss_hell2_spell5_tornado:OnIntervalThink()
	local numSpiritsMax	= 5
	local elapsedTime	= GameRules:GetGameTime() - self.spirits_startTime

	local idealNumSpiritsSpawned = elapsedTime / 0.1
	idealNumSpiritsSpawned = math.min( idealNumSpiritsSpawned, numSpiritsMax )

	if self.spirits_numSpirits < idealNumSpiritsSpawned then

		local newSpirit = CreateModifierThinker(self:GetCaster(), self, "modifier_ability_npc_boss_hell2_spell5_thinker", {}, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
		--local newSpirit = CreateUnitByName("npc_boss_gaveyard2_spell4_ghost", self:GetCaster():GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS )
		local spiritIndex = self.spirits_numSpirits + 1
		newSpirit.spirit_index = spiritIndex
		self.spirits_numSpirits = spiritIndex
		self.spirits_spiritsSpawned[spiritIndex] = newSpirit
	end

	local currentRadius	= 500
	local deltaRadius = self.spirits_movementFactor * 150 * 0.03
	currentRadius = currentRadius + deltaRadius
	currentRadius = math.min( math.max( currentRadius, 450 ), 650 )

	local currentRotationAngle	= elapsedTime * 100
	local rotationAngleOffset	= 360 / 5

	local numSpiritsAlive = 0

	for k,v in pairs( self.spirits_spiritsSpawned ) do

		numSpiritsAlive = numSpiritsAlive + 1

		local rotationAngle = currentRotationAngle - rotationAngleOffset * ( k - 1 )
		local relPos = Vector( 0, currentRadius, 0 )
		relPos = RotatePosition( Vector(0,0,0), QAngle( 0, -rotationAngle, 0 ), relPos )

		local absPos = GetGroundPosition( relPos + self:GetCaster():GetAbsOrigin(), v )

		v:SetAbsOrigin( absPos )
	end

	if self.spirits_numSpirits == numSpiritsMax and numSpiritsAlive == 0 then
		return
	end
end

modifier_ability_npc_boss_hell2_spell5 = class({})

function modifier_ability_npc_boss_hell2_spell5:IsDebuff() 
	return false 
end

function modifier_ability_npc_boss_hell2_spell5:IsHidden() 
	return false 
end

function modifier_ability_npc_boss_hell2_spell5:IsPurgable() 
	return true 
end

function modifier_ability_npc_boss_hell2_spell5:IsStunDebuff() 
	return true 
end

function modifier_ability_npc_boss_hell2_spell5:IsMotionController()  
	return true 
end

function modifier_ability_npc_boss_hell2_spell5:GetMotionControllerPriority()  
	return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH
end

function modifier_ability_npc_boss_hell2_spell5:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	self:StartIntervalThink(FrameTime())
	EmitSoundOn("DOTA_Item.Cyclone.Activate", self:GetParent())
	if IsServer() then
		self:GetParent():StartGesture(ACT_DOTA_FLAIL)
		self.angle = self:GetParent():GetAngles()
		self.abs = self:GetParent():GetAbsOrigin()
		self.cyc_pos = self:GetParent():GetAbsOrigin()

		self.pfx_name = "particles/econ/events/ti6/cyclone_ti6.vpcf"
		self.pfx = ParticleManager:CreateParticle(self.pfx_name, PATTACH_CUSTOMORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(self.pfx, 0, self.abs)
	end
end

function modifier_ability_npc_boss_hell2_spell5:OnIntervalThink()
    if IsClient() then
        return
    end
	if not self:ApplyHorizontalMotionController() then
		self:Destroy()
		return
	end
	self:HorizontalMotion(self:GetParent(), FrameTime())
end

function modifier_ability_npc_boss_hell2_spell5:HorizontalMotion(unit, time)
	if not IsServer() then return end
	-- Change the Face Angle
	local angle = self:GetParent():GetAngles()
	local new_angle = RotateOrientation(angle, QAngle(0,20,0))
	self:GetParent():SetAngles(new_angle[1], new_angle[2], new_angle[3])
	-- Change the height at the first and last 0.3 sec
	if self:GetElapsedTime() <= 0.3 then
		self.cyc_pos.z = self.cyc_pos.z + 50
		self:GetParent():SetAbsOrigin(self.cyc_pos)
	elseif self:GetDuration() - self:GetElapsedTime() < 0.3 then
		self.step = self.step or (self.cyc_pos.z - self.abs.z) / ((self:GetDuration() - self:GetElapsedTime()) / FrameTime())
		self.cyc_pos.z = self.cyc_pos.z - self.step
		self:GetParent():SetAbsOrigin(self.cyc_pos)
	else -- Random move
		local pos = GetRandomPosition2D(self:GetParent():GetAbsOrigin(),5)
		while ((pos - self.abs):Length2D() > 50) do
			pos = GetRandomPosition2D(self:GetParent():GetAbsOrigin(),5)
		end
		self:GetParent():SetAbsOrigin(pos)
	end
end

function modifier_ability_npc_boss_hell2_spell5:OnDestroy()
	StopSoundOn("DOTA_Item.Cyclone.Activate", self:GetParent())
	if not IsServer() then return end
	ParticleManager:DestroyParticle(self.pfx, false)
	ParticleManager:ReleaseParticleIndex(self.pfx)

	self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
	self:GetParent():SetAbsOrigin(self.abs)
	ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
	self:GetParent():SetAngles(self.angle[1], self.angle[2], self.angle[3])
end 

function modifier_ability_npc_boss_hell2_spell5:CheckState()
	return {
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}
end

modifier_ability_npc_boss_hell2_spell5_thinker = class({})
--Classifications template
function modifier_ability_npc_boss_hell2_spell5_thinker:IsHidden()
    return true
end

function modifier_ability_npc_boss_hell2_spell5_thinker:OnCreated()
    ParticleManager:CreateParticle("particles/ability_npc_boss_hell2_spell5.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
end

-- Aura template
function modifier_ability_npc_boss_hell2_spell5_thinker:IsAura()
    return true
end

function modifier_ability_npc_boss_hell2_spell5_thinker:GetModifierAura()
    return "modifier_ability_npc_boss_hell2_spell5_effect"
end

function modifier_ability_npc_boss_hell2_spell5_thinker:GetAuraRadius()
    return 250
end

function modifier_ability_npc_boss_hell2_spell5_thinker:GetAuraDuration()
    return 0.1
end

function modifier_ability_npc_boss_hell2_spell5_thinker:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_ability_npc_boss_hell2_spell5_thinker:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_ability_npc_boss_hell2_spell5_thinker:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

modifier_ability_npc_boss_hell2_spell5_effect = class({})
--Classifications template
function modifier_ability_npc_boss_hell2_spell5_effect:IsHidden()
    return false
end

function modifier_ability_npc_boss_hell2_spell5_effect:IsDebuff()
    return true
end

function modifier_ability_npc_boss_hell2_spell5_effect:IsPurgable()
    return false
end

function modifier_ability_npc_boss_hell2_spell5_effect:RemoveOnDeath()
    return true
end

function modifier_ability_npc_boss_hell2_spell5_effect:DestroyOnExpire()
    return true
end

function modifier_ability_npc_boss_hell2_spell5_effect:OnCreated()
    if IsClient() then
        return
    end
    ApplyDamage({
		victim = self:GetParent(),
		damage =  180,
		damage_type = DAMAGE_TYPE_MAGICAL,
		damage_flags = DOTA_DAMAGE_FLAG_NONE,
		attacker = self:GetCaster(),
		ability = self:GetAbility()
	})
end

function modifier_ability_npc_boss_hell2_spell5_effect:OnRefresh()
    self:OnCreated()
end

function GetRandomPosition2D(vPosition, fRadius)
	local newPos = vPosition + Vector(1,0,0) * math.random(0-fRadius, fRadius)
	return RotatePosition(vPosition, QAngle(0,math.random(-360,360),0), newPos)
end