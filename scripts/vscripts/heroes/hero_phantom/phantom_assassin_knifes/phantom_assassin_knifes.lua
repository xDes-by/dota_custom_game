LinkLuaModifier( "modifier_phantom_assassin_knifes_attack", "heroes/hero_phantom/phantom_assassin_knifes/phantom_assassin_knifes", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bleeding", "heroes/hero_phantom/modifier_bleeding", LUA_MODIFIER_MOTION_NONE )

phantom_assassin_knifes = class({})

function phantom_assassin_knifes:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end

--function phantom_assassin_knifes:GetCastRange(location, target)
--    return self.BaseClass.GetCastRange(self, location, target)
--end

function phantom_assassin_knifes:OnAbilityPhaseStart()
    self:GetCaster():StartGesture( ACT_DOTA_CAST_ABILITY_4 )
    return true
end

function phantom_assassin_knifes:OnAbilityPhaseInterrupted()
    self:GetCaster():RemoveGesture( ACT_DOTA_CAST_ABILITY_4 )
end

function phantom_assassin_knifes:OnSpellStart()
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()
	
	if point:Length2D() == 0 then
		point_caster = self:GetCaster():GetForwardVector():Normalized()
		point = self:GetCaster():GetOrigin() + point_caster * 10
	end
	
    local caster_loc = caster:GetAttachmentOrigin(DOTA_PROJECTILE_ATTACHMENT_ATTACK_1)
    local cast_direction = (point - caster_loc):Normalized()+1
	count = self:GetSpecialValueFor("count")

	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_phantom_assassin_int6")
	if abil ~= nil then
	count = count + 2
	end
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_phantom_assassin_int11")
	if abil ~= nil then
	local r2 = RandomInt(1,4)
		if r2 == 1 then 
		self:EndCooldown()
		end
	end

    local info = {
        Source = caster,
        Ability = self,
        vSpawnOrigin = caster:GetOrigin(),
        bDeleteOnHit = true,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        EffectName = "particles/dzin/ultimate_knife.vpcf",
        fDistance = 800,
        fStartRadius = 115,
        fEndRadius =115,
        vVelocity = cast_direction * 900,
        bHasFrontalCone = false,
        bReplaceExisting = false,
        fExpireTime = GameRules:GetGameTime() + 10.0,
        bProvidesVision = false,
    }
	
	caster:EmitSound("Hero_PhantomAssassin.Dagger.Cast")
	
	local left_QAngle = QAngle(0, 30, 0)
	local right_QAngle = QAngle(0, -30, 0)
	
	local left_spawn_point = RotatePosition(caster:GetAbsOrigin(), left_QAngle, point)
	local left_direction = (left_spawn_point - caster:GetAbsOrigin()):Normalized()

	local right_spawn_point = RotatePosition(caster:GetAbsOrigin(), right_QAngle, point)
	local right_direction = (right_spawn_point - caster:GetAbsOrigin()):Normalized()
	
	--------------------------------------------------------
	arrow_direction = left_direction
	
	info.vVelocity = Vector(arrow_direction.x, arrow_direction.y, 0) * 900
    ProjectileManager:CreateLinearProjectile(info)
	
	--------------------------------------------------------
	
	arrow_direction = right_direction
	
	info.vVelocity = Vector(arrow_direction.x, arrow_direction.y, 0) * 900
    ProjectileManager:CreateLinearProjectile(info)
	
	--------------------------------------------------------
	if count == 5 then 
	local left_QAngle2 = QAngle(0, 60, 0)
	local right_QAngle2 = QAngle(0, -60, 0)
	
	local left_spawn_point = RotatePosition(caster:GetAbsOrigin(), left_QAngle2, point)
	local left_direction = (left_spawn_point - caster:GetAbsOrigin()):Normalized()

	local right_spawn_point = RotatePosition(caster:GetAbsOrigin(), right_QAngle2, point)
	local right_direction = (right_spawn_point - caster:GetAbsOrigin()):Normalized()
	
	--------------------------------------------------------
	arrow_direction = left_direction
	
	info.vVelocity = Vector(arrow_direction.x, arrow_direction.y, 0) * 900
    ProjectileManager:CreateLinearProjectile(info)
	
	--------------------------------------------------------
	
	arrow_direction = right_direction
	
	info.vVelocity = Vector(arrow_direction.x, arrow_direction.y, 0) * 900
    ProjectileManager:CreateLinearProjectile(info)
	end
	--------------------------------------------------------
	
	local front = self:GetCaster():GetForwardVector():Normalized()+0.1
	
	local direction = point-caster:GetOrigin()
	direction.z = 0
	arrow_direction = direction:Normalized() + front
	
	info.vVelocity = Vector(arrow_direction.x, arrow_direction.y, 0) * 500
	ProjectileManager:CreateLinearProjectile(info)
end

function phantom_assassin_knifes:OnProjectileHit( target, vLocation )
    if not IsServer() then return end
    if target ~= nil then
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_phantom_assassin_int_last")
	if abil ~= nil then
		
	end  
		if self:GetCaster():HasModifier("modifier_phantom_assassin_knifes_attack") then
			self:GetCaster():PerformAttack( target, true, false, true, false, false, false, true )
		else
			self:GetCaster():PerformAttack( target, true, true, true, false, false, false, true )
		end
        target:EmitSound("Hero_PhantomAssassin.Dagger.Target")
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_phantom_assassin_knifes_attack", {duration = 0.2} )
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_phantom_assassin_str8")
		if abil ~= nil then
		target:AddNewModifier( self:GetCaster(), self, "modifier_bleeding", {duration = 2} )
		end	
    end
    return true
end

modifier_phantom_assassin_knifes_attack = class({})

function modifier_phantom_assassin_knifes_attack:IsHidden()
    return true
end

function modifier_phantom_assassin_knifes_attack:IsPurgable()
    return false
end

function modifier_phantom_assassin_knifes_attack:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
    return funcs
end

function modifier_phantom_assassin_knifes_attack:GetModifierPreAttack_BonusDamage( params )
	dmg = self:GetAbility():GetSpecialValueFor( "damage" )
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_phantom_assassin_int8")
	if abil ~= nil then
		dmg = dmg + self:GetCaster():GetIntellect()
	end
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_phantom_assassin_agi6")
	if abil ~= nil then
		dmg = dmg + self:GetCaster():GetAgility()
	end
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_phantom_assassin_int_last")
	if abil ~= nil then
		dmg = dmg + dmg
	end
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_phantom_assassin_int_last")
	if abil ~= nil then
		dmg = dmg + dmg
	end
	local abil = self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_phantom_assassin_int50")
	if abil ~= nil then
		dmg = dmg * (1 + self:GetCaster():GetSpellAmplification(false) * 0.05)
	end
	return dmg 
end