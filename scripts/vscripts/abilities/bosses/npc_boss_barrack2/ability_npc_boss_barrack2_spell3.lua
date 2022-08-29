ability_npc_boss_barrack2_spell3 = class({})

LinkLuaModifier( "modifier_ability_npc_boss_barrack1_spell3","abilities/bosses/npc_boss_barrack2/ability_npc_boss_barrack2_spell3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_npc_boss_barrack1_spell3_effect","abilities/bosses/npc_boss_barrack2/ability_npc_boss_barrack2_spell3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_simply_motion","abilities/bosses/npc_boss_barrack2/ability_npc_boss_barrack2_spell3", LUA_MODIFIER_MOTION_BOTH )

function ability_npc_boss_barrack2_spell3:OnSpellStart()
    self.hit_table = {}
    self.range = self:GetSpecialValueFor("range")
    self.position = self:GetCaster():GetOrigin()
    local table = {}
    table[self:GetCaster():GetForwardVector() * -self.range + self.position] = true 
    table[self:GetCaster():GetForwardVector() * self.range + self.position] = true
    table[self:GetCaster():GetRightVector() * -self.range + self.position] = true
    table[self:GetCaster():GetRightVector() * self.range + self.position] = true
    for start_position,_ in pairs(table) do
        local npc = CreateModifierThinker(self:GetCaster(), self, "modifier_ability_npc_boss_barrack1_spell3", {duration = 2}, start_position, self:GetCaster():GetTeamNumber(), false)
        local info = {
            Source = npc,
            Ability = self,
            vSpawnOrigin = start_position,
            
            iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
            iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
            iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,

            EffectName = "particles/units/heroes/hero_tidehunter/tidehunter_gush_upgrade.vpcf",
            fDistance = self.range,
            fStartRadius = 250,
            fEndRadius = 250,
            vVelocity = (self.position - start_position),
            ExtraData = {start_position_x = start_position.x, start_position_y = start_position.y}
        }
        ProjectileManager:CreateLinearProjectile( info )
    end
end

function ability_npc_boss_barrack2_spell3:OnProjectileHit_ExtraData(hTarget, vLocation, table)
    if hTarget and not self.hit_table[hTarget] then
        self.hit_table[hTarget] = true
        hTarget:AddNewModifier(self:GetCaster(), self, "modifier_simply_motion", {
            x = (self.position.x - table.start_position_x) * 0.7, y = (self.position.y - table.start_position_y) * 0.7, r = self.range, s = self.range * 1.4,})
        hTarget:AddNewModifier(self:GetCaster(), self, "modifier_ability_npc_boss_barrack1_spell3_effect", {duration = 10})
    end
end

modifier_ability_npc_boss_barrack1_spell3 = class({})

function modifier_ability_npc_boss_barrack1_spell3:OnDestroy()
    if IsClient() then
        return
    end
    UTIL_Remove(self:GetParent())
end

--------------------------------------------------------------------------------------

modifier_ability_npc_boss_barrack1_spell3_effect = class({})

function modifier_ability_npc_boss_barrack1_spell3_effect:IsHidden()
    return false
end

function modifier_ability_npc_boss_barrack1_spell3_effect:IsDebuff()
    return true
end

function modifier_ability_npc_boss_barrack1_spell3_effect:IsPurgable()
    return true
end

function modifier_ability_npc_boss_barrack1_spell3_effect:RemoveOnDeath()
    return true
end

function modifier_ability_npc_boss_barrack1_spell3_effect:DestroyOnExpire()
    return true
end

function modifier_ability_npc_boss_barrack1_spell3_effect:OnCreated()
    self.armor = self:GetAbility():GetSpecialValueFor("armor_persent") * -1 * 0.01 * self:GetParent():GetPhysicalArmorValue(false)
end

function modifier_ability_npc_boss_barrack1_spell3_effect:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
end

function modifier_ability_npc_boss_barrack1_spell3_effect:GetModifierPhysicalArmorBonus()
    return self.armor
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
    local target = pos + self.direction * (self.speed*dt)
	self:GetParent():SetOrigin( target )
end

function modifier_simply_motion:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
