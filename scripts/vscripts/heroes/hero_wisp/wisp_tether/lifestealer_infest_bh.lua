LinkLuaModifier("modifier_lifestealer_infest_bh_talent", "heroes/hero_wisp/wisp_tether/lifestealer_infest_bh", LUA_MODIFIER_MOTION_NONE)
lifestealer_infest_bh = class({})

function lifestealer_infest_bh:Spawn()
	if IsServer() then
		self:SetLevel(1)
	end
end

modifier_lifestealer_infest_bh_talent = class({})
function modifier_lifestealer_infest_bh_talent:IsHidden() return true end
function modifier_lifestealer_infest_bh_talent:IsPurgable() return false end
function modifier_lifestealer_infest_bh_talent:RemoveOnDeath() return false end
function modifier_lifestealer_infest_bh_talent:OnCreated( kv )
    if not IsServer() then return end
    self:StartIntervalThink(0.2)
    self:OnIntervalThink()
end

function modifier_lifestealer_infest_bh_talent:OnIntervalThink()
    if self:GetCaster():FindAbilityByName("npc_dota_hero_wisp_str_last") then
        self:GetAbility():SetHidden(false)
    else
        self:GetAbility():SetHidden(true)
    end
end

function lifestealer_infest_bh:GetIntrinsicModifierName()
    return "modifier_lifestealer_infest_bh_talent"
end

function lifestealer_infest_bh:GetCastPoint()
    if self:GetCaster():HasModifier("modifier_lifestealer_infest_bh") then
        return 0
    else
        return 0.2
    end
end

function lifestealer_infest_bh:GetCustomCastErrorTarget(target)
	if target == self:GetCaster() then
		return "dota_hud_error_cant_cast_on_self"
	end
end

function lifestealer_infest_bh:CastFilterResultTarget(target)
	if IsServer() then
		local caster = self:GetCaster()

		if target == caster then
			return UF_FAIL_CUSTOM
		end
		
		local nResult = UnitFilter(target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), caster:GetTeamNumber())
		return nResult
	end
end

function lifestealer_infest_bh:GetManaCost(iLvl)
    if self:GetCaster():HasModifier("modifier_lifestealer_infest_bh") then
        return 0
    else
        return self.BaseClass.GetManaCost( self, iLvl )
    end
end

function lifestealer_infest_bh:GetCooldown(iLvl)
    if self:GetCaster():HasModifier("modifier_lifestealer_infest_bh") or IsClient() then
        return self.BaseClass.GetCooldown( self, iLvl )
    else
        return 0
    end
end

function lifestealer_infest_bh:GetCastAnimation()
    if self:GetCaster():HasModifier("modifier_lifestealer_infest_bh") then
        return ACT_DOTA_LIFESTEALER_INFEST
    else
        return ACT_DOTA_LIFESTEALER_INFEST_END
    end
end


function lifestealer_infest_bh:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_lifestealer_infest_bh") then
        return "life_stealer_consume"
    else
        return "life_stealer_infest"
    end
end



function lifestealer_infest_bh:GetBehavior()
    if self:GetCaster():HasModifier("modifier_lifestealer_infest_bh") then
        return DOTA_ABILITY_BEHAVIOR_NO_TARGET
    end
    return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
end

function lifestealer_infest_bh:OnOwnerDied()
    if self.target then
        self.target:RemoveModifierByName("modifier_lifestealer_infest_bh_ally")
    end
end

function lifestealer_infest_bh:OnSpellStart()
    local caster = self:GetCaster()

    if caster:HasModifier("modifier_lifestealer_infest_bh") then
		caster:RemoveModifierByName("modifier_lifestealer_infest_bh")
    else
        self.target = self:GetCursorTarget()
		local duration = -1
        if not self.target:HasModifier("modifier_lifestealer_assimilate_bh_ally") then
            ParticleManager:FireParticle("particles/units/heroes/hero_life_stealer/life_stealer_loadout.vpcf", PATTACH_POINT, self.target, {[0]=caster:GetAbsOrigin(), [1]=self.target:GetAbsOrigin()})
			if self.target:IsSameTeam( caster ) then
				self.target:AddNewModifier(caster, self, "modifier_lifestealer_infest_bh_ally", {})
			elseif not self.target:IsMinion() then
				duration = self:GetSpecialValueFor("duration")
			end
			caster:AddNewModifier(caster, self, "modifier_lifestealer_infest_bh", {})--duration = duration + 0.1
        end
    end
end

function lifestealer_infest_bh:GetCastRange(location, target)
    return self:GetCaster():Script_GetAttackRange()
end


modifier_lifestealer_infest_bh = class({})
LinkLuaModifier("modifier_lifestealer_infest_bh", "heroes/hero_wisp/wisp_tether/lifestealer_infest_bh", LUA_MODIFIER_MOTION_NONE)

function modifier_lifestealer_infest_bh:OnCreated()
    if IsServer() then
        GameRules:GetGameModeEntity():SetModifyGoldFilter(Dynamic_Wrap(self, "GoldFilter"), self)
		self.target = self:GetAbility():GetCursorTarget()
        self:GetParent():AddNoDraw()
        self:StartIntervalThink(FrameTime())
    end
end
function modifier_lifestealer_infest_bh:GoldFilter(data)
    if data.player_id_const == self:GetCaster():GetPlayerID() and data.reason_const == DOTA_ModifyGold_CreepKill then
        self.target:ModifyGoldFiltered( data.gold, true, DOTA_ModifyGold_CreepKill )
        return false 
    end
    if data.player_id_const == self.target:GetPlayerID() then
        self:GetCaster():ModifyGoldFiltered( data.gold * 0.3, true, DOTA_ModifyGold_Unspecified )
    end
    return true
end
function modifier_lifestealer_infest_bh:OnRemoved()
    if IsServer() then
		local ability = self:GetAbility()
		local parent = self:GetParent()
		local parentPos = parent:GetAbsOrigin()
        parent:RemoveNoDraw()
        ParticleManager:FireParticle("particles/units/heroes/hero_life_stealer/life_stealer_infest_emerge_bloody.vpcf", PATTACH_POINT, ability.target, {[0]=ability.target:GetAbsOrigin()})
        FindClearSpaceForUnit(parent, parentPos, false)
        local enemies = parent:FindEnemyUnitsInRadius(parentPos, self:GetAbility():GetSpecialValueFor("radius"))
        for _,enemy in pairs(enemies) do
            ability:DealDamage(parent, enemy, self.damage)
        end
        ability.target:RemoveModifierByName("modifier_lifestealer_infest_bh_ally")
    end
end



function modifier_lifestealer_infest_bh:OnIntervalThink()
    self:GetCaster():SetAbsOrigin(self:GetAbility().target:GetAbsOrigin())
end

function modifier_lifestealer_infest_bh:CheckState()
    local state = { 
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_INVULNERABLE] = true
    }
    return state
end

function modifier_lifestealer_infest_bh:IsDebuff()
    return false
end

modifier_lifestealer_infest_bh_ally = class({})
LinkLuaModifier("modifier_lifestealer_infest_bh_ally", "heroes/hero_wisp/wisp_tether/lifestealer_infest_bh", LUA_MODIFIER_MOTION_NONE)

function modifier_lifestealer_infest_bh_ally:OnCreated()
	if IsServer() then
        self.caster = self:GetCaster()
	end
end

function modifier_lifestealer_infest_bh_ally:OnRemoved()
    if IsServer() then 
        self:GetCaster():RemoveModifierByName("modifier_lifestealer_infest_bh")
    end
end

function modifier_lifestealer_infest_bh_ally:DeclareFunctions()
	return { 
        MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
        MODIFIER_EVENT_ON_DEATH,
    }
end

function modifier_lifestealer_infest_bh_ally:GetModifierExtraHealthBonus()
    if self.caster:FindAbilityByName("special_bonus_unique_npc_dota_hero_wisp_str50") then
        return self.caster:GetMaxHealth() * 0.85
    end
end

function modifier_lifestealer_infest_bh_ally:IsDebuff()
    return false
end

function modifier_lifestealer_infest_bh_ally:GetEffectName()
    return "particles/units/heroes/hero_life_stealer/life_stealer_infested_unit.vpcf"
end

function modifier_lifestealer_infest_bh_ally:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

function modifier_lifestealer_infest_bh_ally:OnDeath(params)
    if params.unit:GetTeamNumber() == DOTA_TEAM_GOODGUYS and params.unit == self:GetParent() then
        self:GetCaster():ForceKill(true)
    end
end