LinkLuaModifier("modifier_broodmother_web", "heroes/hero_broodmother/broodmother_web/broodmother_web", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_broodmother_web_talent", "heroes/hero_broodmother/broodmother_web/broodmother_web", LUA_MODIFIER_MOTION_NONE)

broodmother_web = class({})

function broodmother_web:GetIntrinsicModifierName() 
    return 'modifier_broodmother_web_talent'
end

function broodmother_web:GetCastRange( location , target)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_broodmother_int10") then
		return self:GetSpecialValueFor("radius") + 150
	end
	return self:GetSpecialValueFor("radius")
end

function broodmother_web:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end

function broodmother_web:GetCooldown(level)
    if self:GetCaster():FindAbilityByName("npc_dota_hero_broodmother_int10") then 
        return self.BaseClass.GetCooldown( self, level ) * 0.25
    end
    return self.BaseClass.GetCooldown( self, level )
end

function broodmother_web:GetBehavior(level)
    if self:GetCaster():FindAbilityByName("npc_dota_hero_broodmother_int10") then 
        return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST
    end
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end



function broodmother_web:OnSpellStart(scream_damage_pct, source_unit, is_talent)
	if IsServer() then
		local caster = self:GetCaster()
		local position = caster:GetAbsOrigin()
		local duration = self:GetSpecialValueFor("duration")
		local radius = self:GetSpecialValueFor("radius")
		if self:GetCaster():FindAbilityByName("npc_dota_hero_broodmother_int10") then 
			radius = radius + 150
		end
		self.stun = false
		
		if caster:FindAbilityByName("npc_dota_hero_broodmother_int8") then
			duration = duration + 10
		end
		
		damage = damage_tlents(self, caster) 
		
		self:GetCaster():EmitSound("Hero_Broodmother.SpawnSpiderlingsCast")

		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			local projectile =
				{
					Target 				= enemy,
					Source 				= caster,
					Ability 			= self,
					EffectName 			= "particles/units/heroes/hero_broodmother/broodmother_silken_bola_projectile.vpcf",
					iMoveSpeed			= 800,
					vSourceLoc 			= position,
					bDrawsOnMinimap 	= false,
					bDodgeable 			= true,
					bIsAttack 			= false,
					bVisibleToEnemies 	= true,
					bReplaceExisting 	= false,
					flExpireTime 		= GameRules:GetGameTime() + 20,
					bProvidesVision 	= false,
					iSourceAttachment 	= DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
					ExtraData			= {damage = damage, duration = duration}
				}
			ProjectileManager:CreateTrackingProjectile(projectile)
		end
	end
end

function broodmother_web:OnProjectileHit_ExtraData(target, location, ExtraData)
	if IsServer() then
		if target then
			local caster = self:GetCaster()
			target:EmitSound("Hero_Broodmother.SpawnSpiderlingsImpact")
			ApplyDamage({victim = target, attacker = caster, ability = self, damage = ExtraData.damage, damage_type = self:GetAbilityDamageType()})
			target:AddNewModifier(caster, self, "modifier_broodmother_web", {duration = ExtraData.duration})
			if self.stun then
				target:AddNewModifier(caster, self, "modifier_stunned", {duration = 2})
			end
		end
	end
end

function damage_tlents(ability, caster) 
	local damage = ability:GetSpecialValueFor("damage")
	if caster:FindAbilityByName("npc_dota_hero_broodmother_str7") then
		damage = damage + caster:GetStrength()
		ability.stun = true
	end
	
	if caster:FindAbilityByName("npc_dota_hero_broodmother_agi6") then
		damage = damage + caster:GetAgility()
	end
	
	if caster:FindAbilityByName("npc_dota_hero_broodmother_int7") then
		damage = damage + caster:GetIntellect()
	end

	if caster:FindAbilityByName("special_bonus_unique_npc_dota_hero_broodmother_int50") then
		damage = damage + caster:GetIntellect()
	end
	return damage
end

--------------------------------------------------------------------------------------------------------

modifier_broodmother_web_talent = class({})

function modifier_broodmother_web_talent:IsDebuff() return false end
function modifier_broodmother_web_talent:IsHidden() return true end
function modifier_broodmother_web_talent:IsPurgable() return false end

function modifier_broodmother_web_talent:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_EVENT_ON_ATTACK_START,
	}
end

function modifier_broodmother_web_talent:OnTakeDamage(keys)
	if IsServer() and self:GetAbility() then	
		if keys.attacker and keys.attacker:GetTeamNumber() ~= keys.unit:GetTeamNumber() and self:GetParent() == keys.unit and not keys.attacker:IsOther() and not keys.attacker:IsBuilding() then
			if self:GetCaster():FindAbilityByName("npc_dota_hero_broodmother_str6") then
				trigger_ability = self:GetCaster():FindAbilityByName("broodmother_web")
				if trigger_ability:GetLevel() > 0  and RandomInt(1,100) <= 15 then
					trigger_ability:OnSpellStart()
				end	
			end
		end
		if keys.attacker == self:GetParent() and keys.attacker:GetTeamNumber() ~= keys.unit:GetTeamNumber() and not keys.unit:IsOther() and not keys.unit:IsBuilding() then
			-- if self:GetCaster():FindAbilityByName("npc_dota_hero_broodmother_str10") then
			-- 	local heal = keys.damage * 0.5
			-- 	self:GetParent():Heal( heal, self:GetAbility() )
			-- 	self:PlayEffects( self:GetParent() )
			-- end
		end	
	end
end

function modifier_broodmother_web_talent:PlayEffects( target )
	local particle_cast = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function modifier_broodmother_web_talent:GetModifierPreAttack_CriticalStrike( params )
	if IsServer() and (not self:GetParent():PassivesDisabled()) then
		if params.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then
			return
		end
		if self:GetCaster():FindAbilityByName("npc_dota_hero_broodmother_agi9") and params.target:HasModifier("modifier_broodmother_web") then
			self.record = params.record
			return 200
		end
	end
end

function modifier_broodmother_web_talent:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		if self.record and self.record == params.record then
			self.record = nil
			EmitSoundOn( "Hero_Juggernaut.BladeDance", params.target )
		end
	end
end

function modifier_broodmother_web_talent:OnAttackStart(keys)
    if not IsServer() then return end

    local caster = self:GetCaster()
    local ability = self:GetAbility()
    local target = keys.target

    if keys.attacker == caster and ability:IsFullyCastable() and ability:GetAutoCastState() then
        ability:OnSpellStart()
        ability:UseResources(true, false,false, true)
    end
end

--------------------------------------------------------------------------------------------------------

modifier_broodmother_web = class({})

function modifier_broodmother_web:IsDebuff() return true end
function modifier_broodmother_web:IsHidden() return false end
function modifier_broodmother_web:IsPurgable() return false end

function modifier_broodmother_web:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end

function modifier_broodmother_web:OnCreated()
	if IsServer() and self:GetCaster():FindAbilityByName("npc_dota_hero_broodmother_str10") then
		self:StartIntervalThink(0.5)
	end
end

function modifier_broodmother_web:OnIntervalThink()
	if not IsServer() then return end
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage_tlents(self:GetAbility(), self:GetCaster()) * 0.05 ,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	ApplyDamage( self.damageTable )
end

function modifier_broodmother_web:GetModifierMoveSpeedBonus_Percentage( params )
	return self:GetAbility():GetSpecialValueFor("slow") * (-1)
end

function modifier_broodmother_web:GetEffectName()
	return "particles/units/heroes/hero_broodmother/broodmother_silken_bola_root_b.vpcf"
end

function modifier_broodmother_web:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end