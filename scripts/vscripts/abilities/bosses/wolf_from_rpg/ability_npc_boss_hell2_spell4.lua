ability_npc_boss_hell2_spell4 = class({})

LinkLuaModifier( "modifier_ability_npc_boss_hell2_spell4","abilities/bosses/wolf_from_rpg/ability_npc_boss_hell2_spell4", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_simply_motion_controll","abilities/bosses/wolf_from_rpg/ability_npc_boss_hell2_spell4", LUA_MODIFIER_MOTION_BOTH )


function ability_npc_boss_hell2_spell4:OnSpellStart()
    self.pos =  self:GetCaster():GetAbsOrigin()
    local center = self.pos + self:GetCaster():GetForwardVector() * 200
    self.points = {}
    for i=1,5 do
        local penpos  = RotatePosition( Vector(0,0,0), QAngle( 0, 72 * i, 0 ), self:GetCaster():GetForwardVector() * 400) + self.pos
        table.insert( self.points, penpos )
    end
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_ability_npc_boss_hell2_spell4", {duration = 2.5})
    self:GetCaster():StartGesture(ACT_DOTA_RUN)
end

modifier_ability_npc_boss_hell2_spell4 = class({})
--Classifications template
function modifier_ability_npc_boss_hell2_spell4:IsHidden()
    return true
end

function modifier_ability_npc_boss_hell2_spell4:IsPurgable()
    return false
end

function modifier_ability_npc_boss_hell2_spell4:OnCreated()
    self.damage = self:GetAbility():GetSpecialValueFor("damage")
    self.points = self:GetAbility().points
    self.poryadok = {5,2,4,1,3,5}
    self.thinknum = 6
    if IsClient() then
        return
    end
    FindClearSpaceForUnit(self:GetCaster(), self.points[5], false)
    self:StartIntervalThink(0.51)
    self:OnIntervalThink()
end

function modifier_ability_npc_boss_hell2_spell4:OnRefresh()
    self:OnCreated()
end

function modifier_ability_npc_boss_hell2_spell4:OnDestroy()
    if IsClient() then
        return
    end
    local pfx = ParticleManager:CreateParticle("particles/ability_npc_boss_hell2_spell4.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
    ParticleManager:ReleaseParticleIndex(pfx)
    local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetAbility().pos, nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0,false)
    for _,unit in pairs(enemies) do
        ApplyDamage({victim = unit,
        damage = self.damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
        damage_flags = DOTA_DAMAGE_FLAG_NONE,
        attacker = self:GetCaster(),
        ability = self:GetAbility()})
    end
    self:GetCaster():RemoveGesture(ACT_DOTA_RUN)
    self:GetCaster():SetAbsOrigin(self:GetAbility().pos)
end

function modifier_ability_npc_boss_hell2_spell4:OnIntervalThink()
    self.thinknum = self.thinknum - 1
    local direction = self.points[self.poryadok[self.thinknum]] - self:GetCaster():GetAbsOrigin()
    self:GetCaster():FaceTowards(self.points[self.poryadok[self.thinknum]])
    local dis = direction:Length2D()
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_simply_motion_controll", {
    x = direction.x, y = direction.y, r = dis, s = dis*2})
end

function modifier_ability_npc_boss_hell2_spell4:CheckState()
    return {
        [MODIFIER_STATE_STUNNED] = true
    }
end

--x = direction.x,
--y = direction.y,
--r = distance,
--s = speed,


modifier_simply_motion_controll = class({})

function modifier_simply_motion_controll:IsHidden()
	return true
end

function modifier_simply_motion_controll:IsPurgable()
	return false
end

function modifier_simply_motion_controll:OnCreated( kv )
	if IsServer() then
		self.distance = kv.r
		self.direction = Vector(kv.x,kv.y,0):Normalized()
		self.speed = kv.s
		self.origin = self:GetParent():GetOrigin()
		if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
		end
	end
end

function modifier_simply_motion_controll:OnRefresh( kv )
	if IsServer() then
		-- references
		self.distance = kv.r
		self.direction = Vector(kv.x,kv.y,0):Normalized()
		self.speed = kv.s
		self.origin = self:GetParent():GetOrigin()
		if self:ApplyHorizontalMotionController() == false then 
			self:Destroy()
		end
	end	
end

function modifier_simply_motion_controll:OnDestroy( kv )
	if IsServer() then
		self:GetParent():InterruptMotionControllers( true )
	end
end

function modifier_simply_motion_controll:UpdateHorizontalMotion( me, dt )
	local pos = self:GetParent():GetOrigin()
	if (pos-self.origin):Length2D()>=self.distance then
		self:Destroy()
		return
	end
	local target = pos + self.direction * (self.speed*dt)
	self:GetParent():SetOrigin( target )
end

function modifier_simply_motion_controll:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

function modifier_simply_motion_controll:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end