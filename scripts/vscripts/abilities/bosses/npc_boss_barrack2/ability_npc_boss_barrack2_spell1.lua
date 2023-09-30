ability_npc_boss_barrack2_spell1 = class({})

LinkLuaModifier( "modifier_ability_npc_boss_barrack1_spell1","abilities/bosses/npc_boss_barrack2/ability_npc_boss_barrack2_spell1", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_simply_motion","abilities/bosses/npc_boss_barrack2/ability_npc_boss_barrack2_spell1", LUA_MODIFIER_MOTION_BOTH )

function ability_npc_boss_barrack2_spell1:OnSpellStart()
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_ability_npc_boss_barrack1_spell1", {})
end

--------------------------------------------------------------------------------

modifier_ability_npc_boss_barrack1_spell1 = class({})

function modifier_ability_npc_boss_barrack1_spell1:IsHidden()
    return true
end

function modifier_ability_npc_boss_barrack1_spell1:IsPurgable()
    return false
end

function modifier_ability_npc_boss_barrack1_spell1:RemoveOnDeath()
    return true
end

function modifier_ability_npc_boss_barrack1_spell1:DestroyOnExpire()
    return true
end

function modifier_ability_npc_boss_barrack1_spell1:OnCreated()
    if IsClient() then
        return
    end
    self.mod = self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_invulnerable", {})
    self.pocs = 0
    self.max_pocs = self:GetAbility():GetSpecialValueFor("max_pocs")
    self:StartIntervalThink(1)
    self:OnIntervalThink()
end

function modifier_ability_npc_boss_barrack1_spell1:OnIntervalThink()
    if self.pfx then
        ParticleManager:DestroyParticle(self.pfx, false)
    end
    if self.pocs <= self.max_pocs then
        local origin = self:GetCaster():GetOrigin()
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), origin, nil, 650, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, 2, false)
        if enemies[1] == nil or enemies[1] == self.lasttarget then
            EmitSoundOn("Hero_Morphling.Waveform", self:GetCaster())
            self.lasttarget = nil
            self.pocs = self.pocs + 1
            local new_pos = origin + RandomVector(600)
            local distance = (origin - new_pos):Length2D()
            local direction = (origin - new_pos):Normalized()
            self.pfx = ParticleManager:CreateParticle("particles/econ/items/morphling/morphling_crown_of_tears/morphling_crown_waveform.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
            ParticleManager:SetParticleControl(self.pfx, 1, direction * 600)
            self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_simply_motion", {
                x = direction.x, y = direction.y, r = distance, s = distance + 30,})
        else
            EmitSoundOn("Hero_Morphling.Waveform", self:GetCaster())
            self.pocs = self.pocs + 1
            self.lasttarget = enemies[1]
            local new_pos = enemies[1]:GetOrigin()
            local distance = (new_pos - origin):Length2D()
            local direction = (new_pos - origin):Normalized()
            self.pfx = ParticleManager:CreateParticle("particles/econ/items/morphling/morphling_crown_of_tears/morphling_crown_waveform.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
            ParticleManager:SetParticleControl(self.pfx, 1, direction * distance )
            self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_simply_motion", {
                x = direction.x, y = direction.y, r = distance, s = distance + 30,})
        end
    else
        self:Destroy()
    end
end

function modifier_ability_npc_boss_barrack1_spell1:OnDestroy()
    if IsClient() then
        return
    end
    self.mod:Destroy()
end

function modifier_ability_npc_boss_barrack1_spell1:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MODEL_CHANGE
    }
end

function modifier_ability_npc_boss_barrack1_spell1:GetModifierModelChange()
    return "models/development/invisiblebox.vmdl"
end


modifier_simply_motion = class({})

function modifier_simply_motion:IsHidden()
	return true
end

function modifier_simply_motion:IsPurgable()
	return false
end

function modifier_simply_motion:OnCreated( kv )
	if IsServer() then
        self.units = {}
		self.distance = kv.r
		self.direction = Vector(kv.x,kv.y,0):Normalized()
		self.speed = kv.s
		self.origin = self:GetParent():GetOrigin()
		if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
		end
	end
end

function modifier_simply_motion:OnRefresh( kv )
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

function modifier_simply_motion:OnDestroy( kv )
	if IsServer() then
		self:GetParent():InterruptMotionControllers( true )
	end
end

function modifier_simply_motion:UpdateHorizontalMotion( me, dt )
	local pos = self:GetParent():GetOrigin()
	if (pos-self.origin):Length2D()>=self.distance then
		self:Destroy()
		return
	end
    local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), pos, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
	for _,unit in pairs(enemies) do
        if self.units[unit] == nil then
       --     self:GetCaster():PerformAttack(self:GetParent(), true, true, true, false, true, false, false)
	   
	        ApplyDamage({
			victim = unit,
			damage = unit:GetMaxHealth() * self:GetAbility():GetSpecialValueFor("damage")/100 * 3,
			damage_type = DAMAGE_TYPE_MAGICAL,
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
			attacker = self:GetCaster(),
			})
		
            self.units[unit] = true
            local pfx = ParticleManager:CreateParticle("particles/econ/items/morphling/morphling_crown_of_tears/morphling_crown_waveform_dmg.vpcf", PATTACH_POINT, unit)
            ParticleManager:ReleaseParticleIndex(pfx)
        end
    end
    local target = pos + self.direction * (self.speed*dt)
	self:GetParent():SetOrigin( target )
end

function modifier_simply_motion:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end













