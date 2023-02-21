ability_npc_boss_plague_squirrel_spell1 = class({})

LinkLuaModifier( "modifier_ability_npc_boss_plague_squirrel_spell1", "abilities/bosses/plague_squirrel/ability_npc_boss_plague_squirrel_spell1", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_npc_boss_plague_squirrel_spell1_effect", "abilities/bosses/plague_squirrel/ability_npc_boss_plague_squirrel_spell1", LUA_MODIFIER_MOTION_BOTH )

function ability_npc_boss_plague_squirrel_spell1:OnSpellStart()
    local pos = self:GetCaster():GetAbsOrigin()
    local info = {
        Source = self:GetCaster(),
        Ability = self,	
        
        EffectName = "particles/units/heroes/hero_hoodwink/hoodwink_acorn_shot_tracking.vpcf",
        iMoveSpeed = 550,
        bDodgeable = false,                           -- Optional
        --Target = npc,
        vSourceLoc = self:GetCaster():GetOrigin(),                -- Optional (HOW)
        
        bDrawsOnMinimap = false,                          -- Optional
        bVisibleToEnemies = true,                         -- Optional
        bProvidesVision = true,                           -- Optional
        iVisionRadius = true,                              -- Optional
        iVisionTeamNumber = self:GetCaster():GetTeamNumber(),        -- Optional
        ExtraData = {type = "main_shot_bounds"}
    }
    local tree_count = 0
    local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,unit in pairs(enemies) do
			if tree_count < 4 then
				tree_count = tree_count + 1
				local npc = CreateModifierThinker(self:GetCaster(), self, "modifier_ability_npc_boss_plague_squirrel_spell1", {}, unit:GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
				info.Target = npc
				ProjectileManager:CreateTrackingProjectile(info)
			end
		end
	else	
		while tree_count < 4 do
			tree_count = tree_count + 1
			local angle = RandomInt(0, 360)
			local variance = RandomInt(-700, 700)
			local dy = math.sin(angle) * variance
			local dx = math.cos(angle) * variance
			local target_point = Vector(pos.x + dx, pos.y + dy, pos.z)
		
			local npc = CreateModifierThinker(self:GetCaster(), self, "modifier_ability_npc_boss_plague_squirrel_spell1", {}, target_point, self:GetCaster():GetTeamNumber(), false)
			info.Target = npc
			ProjectileManager:CreateTrackingProjectile(info)
		end
	end
end

function ability_npc_boss_plague_squirrel_spell1:CreateTree_OtherAbilities(position)
    local info = {
        Source = self:GetCaster(),
        Ability = self,	
        
        EffectName = "particles/units/heroes/hero_hoodwink/hoodwink_acorn_shot_tracking.vpcf",
        iMoveSpeed = 5500,
        bDodgeable = false,                           -- Optional
        --Target = npc,
        vSourceLoc = position,                -- Optional (HOW)
        
        bDrawsOnMinimap = false,                          -- Optional
        bVisibleToEnemies = true,                         -- Optional
        bProvidesVision = true,                           -- Optional
        iVisionRadius = true,                              -- Optional
        iVisionTeamNumber = self:GetCaster():GetTeamNumber(),        -- Optional
        ExtraData = {type = "main_shot"}
    }
    local npc = CreateModifierThinker(self:GetCaster(), self, "modifier_ability_npc_boss_plague_squirrel_spell1", {}, position, self:GetCaster():GetTeamNumber(), false)
    info.Target = npc
    ProjectileManager:CreateTrackingProjectile(info)
end

function ability_npc_boss_plague_squirrel_spell1:OnProjectileHit_ExtraData(hTarget, vLocation, table)
    if table.type == "bounds" and table.bounds_count < self:GetSpecialValueFor("max_bounds") then
        local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), vLocation, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
        for _,unit in pairs(enemies) do
            if unit ~= hTarget then
                local info = {
                    Source = hTarget,
                    Ability = self,	
                    
                    EffectName = "particles/units/heroes/hero_hoodwink/hoodwink_acorn_shot_tracking.vpcf",
                    iMoveSpeed = 550,
                    bDodgeable = false,                           -- Optional
                    Target = enemies[1],
                    vSourceLoc = vLocation,                -- Optional (HOW)
                    
                    bDrawsOnMinimap = false,                          -- Optional
                    bVisibleToEnemies = true,                         -- Optional
                    bProvidesVision = true,                           -- Optional
                    iVisionRadius = true,                              -- Optional
                    iVisionTeamNumber = self:GetCaster():GetTeamNumber(),        -- Optional
                    ExtraData = {type = "bounds", bounds_count = table.bounds_count + 1}
                }
				if hTarget then
					ApplyDamage({victim = hTarget,
					damage = hTarget:GetMaxHealth()/100*self:GetSpecialValueFor("damage"),
					damage_type = DAMAGE_TYPE_PHYSICAL,
					damage_flags = DOTA_DAMAGE_FLAG_NONE,
					attacker = self:GetCaster(),
					ability = self})
				end
                ProjectileManager:CreateTrackingProjectile(info)
                break
            end
        end
    end
    if table.type == "main_shot_bounds" then
        local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), vLocation, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
        if #enemies > 0 then
            local info = {
                Source = hTarget,
                Ability = self,	
                
                EffectName = "particles/units/heroes/hero_hoodwink/hoodwink_acorn_shot_tracking.vpcf",
                iMoveSpeed = 550,
                bDodgeable = false,                           -- Optional
                Target = enemies[1],
                vSourceLoc = vLocation,                -- Optional (HOW)
                
                bDrawsOnMinimap = false,                          -- Optional
                bVisibleToEnemies = true,                         -- Optional
                bProvidesVision = true,                           -- Optional
                iVisionRadius = true,                              -- Optional
                iVisionTeamNumber = self:GetCaster():GetTeamNumber(),        -- Optional
                ExtraData = {type = "bounds", bounds_count = 0}
            }
            ProjectileManager:CreateTrackingProjectile(info)
        end
        hTarget:FindModifierByName("modifier_ability_npc_boss_plague_squirrel_spell1"):Activate()
    end
    if table.type == "main_shot" then
        local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), vLocation, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
        for _,unit in pairs(enemies) do
            FindClearSpaceForUnit(unit, unit:GetOrigin(), true)
        end
        hTarget:FindModifierByName("modifier_ability_npc_boss_plague_squirrel_spell1"):Activate()
    end   
end

modifier_ability_npc_boss_plague_squirrel_spell1 = class({})

function modifier_ability_npc_boss_plague_squirrel_spell1:Activate()
    if IsClient() then
        return
    end
    local duration = self:GetAbility():GetSpecialValueFor("duration")
    local tree = CreateTempTreeWithModel(self:GetParent():GetOrigin(), duration, "models/heroes/hoodwink/hoodwink_tree_model.vmdl")
    local tree = GridNav:GetAllTreesAroundPoint( self:GetParent():GetOrigin(), 150, false )[1]
    local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
    for _,unit in pairs(enemies) do
        unit:AddNewModifier(self:GetCaster(), self, "modifier_ability_npc_boss_plague_squirrel_spell1_effect", {duration = duration, ent = self:GetParent():entindex()})
    end

	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_hoodwink/hoodwink_bushwhack.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( 300, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( "Hero_Hoodwink.Bushwhack.Impact", self:GetCaster() )

	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(effect_cast,1,self:GetParent(),PATTACH_POINT_FOLLOW,"attach_hitloc",self:GetParent():GetOrigin(),true)
	self:AddParticle(effect_cast,false,false,-1,false,false)
	EmitSoundOn( "Hero_Hoodwink.Sharpshooter.Channel", self:GetParent() )

    local npc = CreateUnitByName("npc_boss_plague_squirrel_shoter", self:GetParent():GetOrigin() + RandomVector(600), true, nil, nil, self:GetParent():GetTeamNumber() )
    npc:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_invulnerable", {duration = 5})
    npc:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_kill", {duration = 5})
 
    Timers:CreateTimer(0.1,function()
        ExecuteOrderFromTable({
            UnitIndex = npc:entindex(),
            OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
            AbilityIndex = npc:FindAbilityByName("ability_npc_boss_plague_squirrel_shoter"):entindex(),
            Position = self:GetParent():GetOrigin(),
            Queue = false,
        })    
    end)
end

function modifier_ability_npc_boss_plague_squirrel_spell1:OnDestroy()
    if IsClient() then
        return
    end
    UTIL_Remove(self:GetParent())
end

modifier_ability_npc_boss_plague_squirrel_spell1_effect = class({})

function modifier_ability_npc_boss_plague_squirrel_spell1_effect:IsHidden()
	return false
end

function modifier_ability_npc_boss_plague_squirrel_spell1_effect:IsDebuff()
	return true
end

function modifier_ability_npc_boss_plague_squirrel_spell1_effect:IsStunDebuff()
	return true
end

function modifier_ability_npc_boss_plague_squirrel_spell1_effect:IsPurgable()
	return true
end

function modifier_ability_npc_boss_plague_squirrel_spell1_effect:OnCreated( kv )
	self.parent = self:GetParent()
	self.distance = 350
	self.speed = 50
	self.interval = 0.1
	if not IsServer() then return end
    self.ent = EntIndexToHScript( kv.ent )
    self.ent_pos = self.ent:GetOrigin()
	if not self:ApplyHorizontalMotionController() then
		return
	end
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_hoodwink/hoodwink_bushwhack_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 1, self:GetParent():GetAbsOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 15, self.ent_pos )
	self:AddParticle(effect_cast,false,false,-1,false,false)
	EmitSoundOn( "Hero_Hoodwink.Bushwhack.Target", self:GetParent() )
    self:StartIntervalThink(0.03)
end

function modifier_ability_npc_boss_plague_squirrel_spell1_effect:OnIntervalThink()
    if not (GridNav:GetAllTreesAroundPoint( self.ent_pos, 150, false )[1] ~= nil) then
        self:Destroy()
    end
end

function modifier_ability_npc_boss_plague_squirrel_spell1_effect:OnRemoved()
end

function modifier_ability_npc_boss_plague_squirrel_spell1_effect:OnDestroy()
	if not IsServer() then return end
	self:GetParent():RemoveHorizontalMotionController( self )
end

function modifier_ability_npc_boss_plague_squirrel_spell1_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
		MODIFIER_PROPERTY_VISUAL_Z_DELTA,
	}
end

function modifier_ability_npc_boss_plague_squirrel_spell1_effect:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

function modifier_ability_npc_boss_plague_squirrel_spell1_effect:GetOverrideAnimationRate()
	return 0.3
end

function modifier_ability_npc_boss_plague_squirrel_spell1_effect:GetVisualZDelta()
	return 50
end

function modifier_ability_npc_boss_plague_squirrel_spell1_effect:UpdateHorizontalMotion( me, dt )
	local origin = me:GetOrigin()
	local dir = self.ent_pos-origin
	local dist = dir:Length2D()
	dir.z = 0
	dir = dir:Normalized()
	if dist<self.distance then
		self:GetParent():RemoveHorizontalMotionController( self )
		return
	end
	local target = dir * self.speed*dt
	me:SetOrigin( origin + target )
end

function modifier_ability_npc_boss_plague_squirrel_spell1_effect:OnHorizontalMotionInterrupted()
	self:GetParent():RemoveHorizontalMotionController( self )
end

function modifier_ability_npc_boss_plague_squirrel_spell1_effect:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true
	}
end