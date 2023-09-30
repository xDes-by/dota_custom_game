npc_byorrocktar_spell5 = class({})

LinkLuaModifier( "modifier_npc_byorrocktar_spell5_movetotarget","abilities/bosses/byrocktar/npc_byorrocktar_spell5", LUA_MODIFIER_MOTION_BOTH )

function npc_byorrocktar_spell5:OnSpellStart()
    local pos = self:GetCaster():GetAbsOrigin()
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), pos, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0,false)
    for _,unit in pairs(enemies) do
        local npc = CreateUnitByName("npc_byorrocktar_bomb", pos, true, nil, nil, self:GetCaster():GetTeamNumber())
        npc:AddNewModifier(self:GetCaster(), self, "modifier_kill", {duration = 4})
        npc:AddNewModifier(self:GetCaster(), self, "modifier_invulnerable", {})
        npc:AddNewModifier(self:GetCaster(), self, "modifier_npc_byorrocktar_spell5_movetotarget", {target = unit:entindex(), duration = 4})
        local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_remote_cart.vpcf", PATTACH_POINT_FOLLOW, npc)
		ParticleManager:SetParticleControlEnt(pfx, 1, npc, PATTACH_POINT_FOLLOW, "attach_hitloc", pos, true)
		ParticleManager:SetParticleControlEnt(pfx, 2, npc, PATTACH_POINT_FOLLOW, "attach_hitloc", pos, true)
		ParticleManager:SetParticleControlEnt(pfx, 3, npc, PATTACH_POINT_FOLLOW, "attach_hitloc", pos, true)
		ParticleManager:SetParticleControlForward(pfx, 5, npc:GetForwardVector())
        ParticleManager:ReleaseParticleIndex(pfx)
    end
    EmitSoundOn("Hero_Techies.StickyBomb.Cast", self:GetCaster())
end

modifier_npc_byorrocktar_spell5_movetotarget = class({})

function modifier_npc_byorrocktar_spell5_movetotarget:IsHidden()
	return true
end

function modifier_npc_byorrocktar_spell5_movetotarget:IsPurgable()
	return false
end

function modifier_npc_byorrocktar_spell5_movetotarget:OnCreated( kv )
	if IsServer() then
		self.origin = EntIndexToHScript(kv.target):GetOrigin()
		self.target = EntIndexToHScript(kv.target)
		self.direction = (self.origin - self:GetParent():GetAbsOrigin()):Normalized()
        self.distance = (self.origin - self:GetParent():GetAbsOrigin()):Length2D()
		self.speed = self.distance * 3
		if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
		end
	end
end

function modifier_npc_byorrocktar_spell5_movetotarget:UpdatePosition()
    self.direction = (self.origin - self:GetParent():GetAbsOrigin()):Normalized()
	self.origin = self.target:GetOrigin()
    self:GetParent():FaceTowards(self.origin)
end

function modifier_npc_byorrocktar_spell5_movetotarget:OnDestroy( kv )
	if IsServer() then
		self:GetParent():InterruptMotionControllers( true )
        local radius = self:GetAbility():GetSpecialValueFor("radius")
	    local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0,false)
        for _,unit in pairs(enemies) do
            ApplyDamage({victim = unit,
            damage =  self:GetAbility():GetSpecialValueFor("damage") * 3,
            damage_type = DAMAGE_TYPE_MAGICAL,
            damage_flags = DOTA_DAMAGE_FLAG_NONE,
            attacker = self:GetCaster(),
            ability = self:GetAbility()})
        end
        local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_remote_cart_explode.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControl(pfx, 1, Vector(radius,radius,radius))
        ParticleManager:ReleaseParticleIndex(pfx)
        EmitSoundOn("Hero_Techies.StickyBomb.Detonate", self:GetParent())
	end
end

function modifier_npc_byorrocktar_spell5_movetotarget:UpdateHorizontalMotion( me, dt )
    local pos = self:GetParent():GetOrigin()
    if (pos - self.origin):Length2D() < 150 then
        self.speed = 30
    else
        self.speed = self.distance * 3
    end
        local target = pos + self.direction * (self.speed*dt)
        self:GetParent():SetOrigin( target )
        self:UpdatePosition()
end

function modifier_npc_byorrocktar_spell5_movetotarget:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end