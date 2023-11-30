LinkLuaModifier( "modifier_ancient_apparition_ice_blast_lua", "heroes/hero_ancient_apparition/ancient_apparition_ice_blast_lua/ancient_apparition_ice_blast_lua.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ancient_apparition_ice_blast_lua_slow", "heroes/hero_ancient_apparition/ancient_apparition_ice_blast_lua/ancient_apparition_ice_blast_lua.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_special_bonus_unique_npc_dota_hero_ancient_apparition_agi50", "heroes/hero_ancient_apparition/ancient_apparition_ice_blast_lua/ancient_apparition_ice_blast_lua.lua", LUA_MODIFIER_MOTION_NONE )

ancient_apparition_ice_blast_lua = class({})

function ancient_apparition_ice_blast_lua:GetIntrinsicModifierName()
	return "modifier_ancient_apparition_ice_blast_lua"
end

-------------------------------------------------------------------------------

modifier_ancient_apparition_ice_blast_lua = class({})

function modifier_ancient_apparition_ice_blast_lua:IsHidden()
	return true
end

function modifier_ancient_apparition_ice_blast_lua:IsPurgable()
	return false
end

function modifier_ancient_apparition_ice_blast_lua:OnCreated()
	if not IsServer() then
		return
	end
	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_special_bonus_unique_npc_dota_hero_ancient_apparition_agi50", {})
end

function modifier_ancient_apparition_ice_blast_lua:OnRefresh()
	if not IsServer() then
		return
	end
	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_special_bonus_unique_npc_dota_hero_ancient_apparition_agi50", {})
end

function modifier_ancient_apparition_ice_blast_lua:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_ancient_apparition_ice_blast_lua:OnAttackLanded( params )
	local target = params.target
	if params.attacker ~= self:GetParent() then return end
	
	self.hp = self:GetAbility():GetSpecialValueFor( "hp" )
	if self:GetCaster():FindAbilityByName("npc_dota_hero_ancient_apparition_int_last") ~= nil then 
		self.hp = self.hp * 2
	end
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_ancient_apparition_str50") ~= nil then 
		self.hp = self.hp + 10
	end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_ancient_apparition_int9") ~= nil then
		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), target:GetOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
		for _,enemy in pairs(enemies) do
			self:AddDebuff(enemy)
		end
	else
		self:AddDebuff(target)
	end
end

function modifier_ancient_apparition_ice_blast_lua:AddDebuff(target)
	local caster = self:GetCaster()
	target:AddNewModifier(caster, self:GetAbility(), "modifier_ancient_apparition_ice_blast_lua_slow", {duration = self:GetAbility():GetSpecialValueFor( "duration" )})
	if not target:IsHero() and target:GetHealthPercent() <= self.hp and ancient(caster, target) then		
		
		if self:GetCaster():FindAbilityByName("npc_dota_hero_ancient_apparition_agi6") ~= nil then 
			local hp = target:GetHealth()
			params.attacker:Heal(hp, nil)
			SendOverheadEventMessage( params.attacker:GetPlayerOwner(), OVERHEAD_ALERT_HEAL , params.attacker, hp, nil )
		end

		target:Kill(nil, caster)
		-- self:GetParent():EmitSound("Hero_Ancient_Apparition.IceBlast.Target")
		local ice_blast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_death.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:ReleaseParticleIndex(ice_blast_particle)
	end
end

function IsBoss(name)
	bosses_names = {"npc_forest_boss","npc_village_boss","npc_mines_boss","npc_dust_boss","npc_swamp_boss","npc_snow_boss","npc_forest_boss_fake","npc_village_boss_fake","npc_mines_boss_fake","npc_dust_boss_fake","npc_swamp_boss_fake","npc_snow_boss_fake","boss_1","boss_2","boss_3","boss_4","boss_5","boss_6","boss_7","boss_8","boss_9","boss_10","boss_11","boss_12","boss_13","boss_14","boss_15","boss_16","boss_17","boss_18","boss_19","boss_20", "npc_boss_location8", "npc_boss_location8_fake"}
	local b = false
	for i = 1, #bosses_names do
		if name == bosses_names[i] then
			b = true
			break
		end
	end
	return b
end

function ancient(caster, target)
	if caster:FindAbilityByName("npc_dota_hero_ancient_apparition_int10") ~= nil then
		return true
	end
	if target:IsAncient() then
		return false
	end
	return true
end

-----------------------------------------------------------------------------------
modifier_ancient_apparition_ice_blast_lua_slow = class({})

function modifier_ancient_apparition_ice_blast_lua_slow:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost.vpcf"
end

function modifier_ancient_apparition_ice_blast_lua_slow:OnCreated()
	self.move_speed_slow = self:GetAbility():GetSpecialValueFor("slow") * (-1)
	self:StartIntervalThink(0.5)
	self:OnIntervalThink()
end

function modifier_ancient_apparition_ice_blast_lua_slow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end

function modifier_ancient_apparition_ice_blast_lua_slow:OnIntervalThink()
	if not IsServer() then return end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_ancient_apparition_int6") ~= nil then
		local damage = self:GetCaster():GetIntellect()/2
		if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_ancient_apparition_int50") ~= nil then
			damage = damage + self:GetCaster():GetIntellect() + self:GetCaster():GetStrength() + self:GetCaster():GetAgility()
		end
		ApplyDamage({ victim = self:GetParent(), attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
	end
	self.deal_dmg = self:GetParent():GetHealth()
end

function modifier_ancient_apparition_ice_blast_lua_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.move_speed_slow
end

modifier_special_bonus_unique_npc_dota_hero_ancient_apparition_agi50 = class({})
--Classifications template
function modifier_special_bonus_unique_npc_dota_hero_ancient_apparition_agi50:IsHidden()
	return true
end

function modifier_special_bonus_unique_npc_dota_hero_ancient_apparition_agi50:IsDebuff()
	return false
end

function modifier_special_bonus_unique_npc_dota_hero_ancient_apparition_agi50:IsPurgable()
	return false
end

function modifier_special_bonus_unique_npc_dota_hero_ancient_apparition_agi50:IsPurgeException()
	return false
end

-- Optional Classifications
function modifier_special_bonus_unique_npc_dota_hero_ancient_apparition_agi50:IsStunDebuff()
	return false
end

function modifier_special_bonus_unique_npc_dota_hero_ancient_apparition_agi50:RemoveOnDeath()
	return true
end

function modifier_special_bonus_unique_npc_dota_hero_ancient_apparition_agi50:DestroyOnExpire()
	return true
end

function modifier_special_bonus_unique_npc_dota_hero_ancient_apparition_agi50:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK
	}
end

function modifier_special_bonus_unique_npc_dota_hero_ancient_apparition_agi50:OnAttack( params )
	if params.attacker ~= self:GetParent() and params.no_attack_cooldown and self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_ancient_apparition_agi50") then
		return
	end

	local attack_range = params.attacker:Script_GetAttackRange() + 250
	local arrow_count = 1

	local units = FindUnitsInRadius(params.attacker:GetTeamNumber(),params.attacker:GetAbsOrigin(),nil,attack_range,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,FIND_CLOSEST, false) 
	
	for number,unit in pairs(units) do
		if number > arrow_count then
			break
		end
		if unit ~= params.target then
			params.attacker:PerformAttack(unit, false, true, true, false, true, false, false)
		else
			arrow_count = arrow_count - 1
		end
	end
end