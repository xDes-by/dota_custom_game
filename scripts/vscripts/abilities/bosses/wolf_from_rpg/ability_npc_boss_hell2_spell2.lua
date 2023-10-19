ability_npc_boss_hell2_spell2 = class({})

LinkLuaModifier( "modifier_ability_npc_boss_hell2_spell2","abilities/bosses/wolf_from_rpg/ability_npc_boss_hell2_spell2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_npc_boss_hell2_spell2_sheeld","abilities/bosses/wolf_from_rpg/ability_npc_boss_hell2_spell2", LUA_MODIFIER_MOTION_NONE )


function ability_npc_boss_hell2_spell2:GetIntrinsicModifierName()
    return "modifier_ability_npc_boss_hell2_spell2"
end

modifier_ability_npc_boss_hell2_spell2 = class({})

--Classifications template
function modifier_ability_npc_boss_hell2_spell2:IsHidden()
    return true
end

function modifier_ability_npc_boss_hell2_spell2:IsPurgable()
    return false
end

function modifier_ability_npc_boss_hell2_spell2:OnCreated()
    self.start_radius = self:GetAbility():GetSpecialValueFor("start")
    self.end_radius = self:GetAbility():GetSpecialValueFor("end")
    self.interval = self:GetAbility():GetSpecialValueFor("interval")
    self.ready = true
    if IsClient() then
        return
    end
    self:SetStackCount(self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster()) * self:GetAbility():GetSpecialValueFor("damage_persent") * 0.01)
end

function modifier_ability_npc_boss_hell2_spell2:OnRefresh()
    self:OnCreated()
end

function modifier_ability_npc_boss_hell2_spell2:OnIntervalThink()
    self.ready = true
    self:StartIntervalThink(-1)
end

function modifier_ability_npc_boss_hell2_spell2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
    }
end

function modifier_ability_npc_boss_hell2_spell2:GetModifierProcAttack_Feedback()
    if self.ready then
        self.ready = false
        self:StartIntervalThink(self.interval)
        local pfx = ParticleManager:CreateParticle("particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength_crit.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControlEnt(pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "follow_hitloc", self:GetParent():GetAbsOrigin(), true)
        ParticleManager:SetParticleControlForward(pfx, 3, self:GetCaster():GetForwardVector()*10)
        ParticleManager:ReleaseParticleIndex(pfx)
        local forvard = self:GetCaster():GetForwardVector()
        
        local enemies = FindUnitsInCone(DOTA_TEAM_BADGUYS,
            self:GetCaster():GetAbsOrigin() + (forvard * 200):Length2D(),
            self:GetCaster():GetAbsOrigin(),
            self:GetCaster():GetAbsOrigin() + forvard*self.end_radius,
            self.start_radius,self.end_radius,
            nil,DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, 0,FIND_CLOSEST,false)
        for _,unit in pairs(enemies) do
            ApplyDamage({victim = unit,
            damage = self:GetStackCount(),
            damage_type = DAMAGE_TYPE_PHYSICAL,
            damage_flags = DOTA_DAMAGE_FLAG_NONE,
            attacker = self:GetCaster(),
            ability = self:GetAbility()})
        end
        self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_ability_npc_boss_hell2_spell2_sheeld", {}):SetStackCount(4)
    end
end

modifier_ability_npc_boss_hell2_spell2_sheeld = class({})
--Classifications template
function modifier_ability_npc_boss_hell2_spell2_sheeld:IsHidden()
    return false
end

function modifier_ability_npc_boss_hell2_spell2_sheeld:IsDebuff()
    return false
end

function modifier_ability_npc_boss_hell2_spell2_sheeld:IsPurgable()
    return false
end

function modifier_ability_npc_boss_hell2_spell2_sheeld:RemoveOnDeath()
    return true
end

function modifier_ability_npc_boss_hell2_spell2_sheeld:OnCreated()
    self.particle = ParticleManager:CreateParticle("particles/econ/items/abaddon/abaddon_alliance/abaddon_aphotic_shield_alliance.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControl(self.particle, 1, Vector(300,0,300))
    ParticleManager:SetParticleControl(self.particle, 2, Vector(300,0,300))
    ParticleManager:SetParticleControl(self.particle, 4, Vector(300,0,300))
    ParticleManager:SetParticleControl(self.particle, 5, Vector(300,0,0))
end

function modifier_ability_npc_boss_hell2_spell2_sheeld:OnDestroy()
    ParticleManager:DestroyParticle(self.particle, true)
    ParticleManager:ReleaseParticleIndex(self.particle)
end

function modifier_ability_npc_boss_hell2_spell2_sheeld:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK
    }
end

function modifier_ability_npc_boss_hell2_spell2_sheeld:GetModifierTotal_ConstantBlock(data)
    local particle = ParticleManager:CreateParticle("particles/econ/items/abaddon/abaddon_alliance/abaddon_aphotic_shield_alliance_explosion.vpcf", PATTACH_ABSORIGIN, self:GetParent())
    ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(particle)
    local stacks = self:GetStackCount() 
    local pstacks = stacks * 50
    self:DecrementStackCount()
    ParticleManager:DestroyParticle(self.particle, true)
    ParticleManager:ReleaseParticleIndex(self.particle)
    self.particle = ParticleManager:CreateParticle("particles/econ/items/abaddon/abaddon_alliance/abaddon_aphotic_shield_alliance.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControl(self.particle, 1, Vector(pstacks,0,pstacks))
    ParticleManager:SetParticleControl(self.particle, 2, Vector(pstacks,0,pstacks))
    ParticleManager:SetParticleControl(self.particle, 4, Vector(pstacks,0,pstacks))
    ParticleManager:SetParticleControl(self.particle, 5, Vector(pstacks,0,0))
    if stacks == 0 then
        self:Destroy()
    end
    return data.damage * 0.4
end


function FindUnitsInCone( nTeamNumber, vCenterPos, vStartPos, vEndPos, fStartRadius, fEndRadius, hCacheUnit, nTeamFilter, nTypeFilter, nFlagFilter, nOrderFilter, bCanGrowCache )
	local direction = vEndPos-vStartPos
	direction.z = 0

	local distance = direction:Length2D()
	direction = direction:Normalized()

	local big_radius = distance + math.max(fStartRadius, fEndRadius)

	local units = FindUnitsInRadius(
		nTeamNumber,	-- int, your team number
		vCenterPos,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		big_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		nTeamFilter,	-- int, team filter
		nTypeFilter,	-- int, type filter
		nFlagFilter,	-- int, flag filter
		nOrderFilter,	-- int, order filter
		bCanGrowCache	-- bool, can grow cache
	)

	local targets = {}
	for _,unit in pairs(units) do
		local vUnitPos = unit:GetOrigin()-vStartPos
		local fProjection = vUnitPos.x*direction.x + vUnitPos.y*direction.y + vUnitPos.z*direction.z
		fProjection = math.max(math.min(fProjection,distance),0)
		local vProjection = direction*fProjection
		local fUnitRadius = (vUnitPos - vProjection):Length2D()
		local fInterpRadius = (fProjection/distance)*(fEndRadius-fStartRadius) + fStartRadius
		if fUnitRadius<=fInterpRadius then
			table.insert( targets, unit )
		end
	end
	return targets
end