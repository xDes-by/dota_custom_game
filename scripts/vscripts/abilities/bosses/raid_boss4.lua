LinkLuaModifier("modifier_raid_splinter_blast_colba", "abilities/bosses/raid_boss4.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_generic_silenced_lua", "heroes/generic/modifier_generic_silenced_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_raid_splinter_blast_splinter_charge", "abilities/bosses/raid_boss4.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_raid_touch", "abilities/bosses/raid_boss4.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_raid_mag_resist", "abilities/bosses/raid_boss4.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_raid_ice_skin", "abilities/bosses/raid_boss4.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_raid_ice_skin_effect", "abilities/bosses/raid_boss4.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fake", "abilities/bosses/raid_boss4.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fake_attack", "abilities/bosses/raid_boss4.lua", LUA_MODIFIER_MOTION_NONE)

raid_splinter_blast = class({});

function raid_splinter_blast:OnSpellStart() 
	if IsServer() then
		local caster 						= self:GetCaster();
		local target 						= self:GetCursorTarget();
		local secondary_projectile_speed 	= self:GetSpecialValueFor("secondary_projectile_speed");
		local split_radius 					= self:GetSpecialValueFor("split_radius");
		local slow_duration 				= self:GetSpecialValueFor("duration");
		local speed							= self:GetSpecialValueFor("projectile_speed")
		local damage						= self:GetSpecialValueFor("damage")

		caster:EmitSound("Hero_Winter_Wyvern.SplinterBlast.Cast");

		raid_splinter_blast:CreateTrackingProjectile(
		{
			target 						= target,
			caster 						= caster,
			ability 					= self,
			iMoveSpeed 					= speed,
			iSourceAttachment 			= self:GetCaster():ScriptLookupAttachment("attach_attack1"),
			EffectName 					= "particles/units/heroes/hero_winter_wyvern/wyvern_splinter.vpcf",
			secondary_projectile_speed 	= secondary_projectile_speed,
			split_radius 				= split_radius,
			slow_duration 				= slow_duration,
			slow						= slow,
			attack_slow 				= attack_slow,
			hero_cdr 					= hero_cdr,
			cdr_units 					= cdr_units,
			splinter_threshold 			= splinter_threshold,
			splinter_dmg_efficiency 	= splinter_dmg_efficiency,
			splinter_aoe_efficiency 	= splinter_aoe_efficiency,
			damage 						= damage,
			splinter_proc 				= 0
		});	
	end
end

function raid_splinter_blast:CreateTrackingProjectile(keys)
    local target = keys.target;
    local caster = keys.caster;
    local speed = keys.iMoveSpeed;
 
    keys.creation_time = GameRules:GetGameTime();

    local projectile = caster:GetAttachmentOrigin(keys.iSourceAttachment);
 
    local particle = ParticleManager:CreateParticle(keys.EffectName, PATTACH_POINT, caster);

    caster:EmitSound("Hero_Winter_Wyvern.SplinterBlast.Projectile");

    local arctic_flight_offset = Vector(0,0,0);
    if caster:HasModifier("modifier_winter_wyvern_arctic_burn_flight") then 
    	arctic_flight_offset = Vector(0,0, 150);
    end

    ParticleManager:SetParticleControl(particle, 0, caster:GetAttachmentOrigin(keys.iSourceAttachment) + arctic_flight_offset);
    ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true);
    ParticleManager:SetParticleControl(particle, 2, Vector(speed, 0, 0));
 
    Timers:CreateTimer(function()
        local target_location = target:GetAbsOrigin();
 
        projectile = projectile + (target_location - projectile):Normalized() * speed * FrameTime();
 
        if (target_location - projectile):Length2D() < speed * FrameTime() then
            raid_splinter_blast:OnTrackingProjectileHit(keys);
            caster:StopSound("Hero_Winter_Wyvern.SplinterBlast.Projectile");
            ParticleManager:DestroyParticle(particle, false);
            ParticleManager:ReleaseParticleIndex(particle);
 
            return nil
        else
        	speed = speed + 25;
			ParticleManager:SetParticleControl(particle, 2, Vector(speed, 0, 0));

            return 0
        end
    end)
end

function raid_splinter_blast:OnTrackingProjectileHit(keys)

	keys.target:AddNewModifier(keys.caster, keys.self, "modifier_generic_silenced_lua", {duration = keys.slow_duration * (1 - keys.target:GetStatusResistance())});

	local nearby_enemy_units = FindUnitsInRadius(
		keys.caster:GetTeam(),
		keys.target:GetAbsOrigin(), 
		nil, 
		keys.split_radius, 
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		DOTA_UNIT_TARGET_FLAG_NONE, 
		FIND_ANY_ORDER, 
		false
	);

	keys.caster:EmitSound("Hero_Winter_Wyvern.SplinterBlast.Target");

	for _,enemy in pairs(nearby_enemy_units) do 
		if enemy ~= keys.target and enemy:IsAlive() then
			local extra_data = {
				damage 						= keys.damage, 
				slow_duration 				= keys.slow_duration, 
				slow 						= keys.slow, 
				attack_slow 				= keys.attack_slow, 
				hero_cdr 					= keys.hero_cdr, 
				cdr_units 					= keys.cdr_units, 
				split_radius 				= keys.split_radius, 
				splinter_threshold 			= keys.splinter_threshold, 
				secondary_projectile_speed 	= keys.secondary_projectile_speed,
				splinter_dmg_efficiency 	= keys.splinter_dmg_efficiency,
				splinter_aoe_efficiency 	= keys.splinter_aoe_efficiency,
				splinter_proc 			   	= keys.splinter_proc
			}

			local projectile =
			{
				Target 				= enemy,
				Source 				= keys.target,
				Ability 			= keys.ability,
				EffectName 			= "particles/units/heroes/hero_winter_wyvern/wyvern_splinter_blast.vpcf",
				iMoveSpeed			= keys.secondary_projectile_speed,
				vSourceLoc 			= keys.target:GetAbsOrigin(),
				bDrawsOnMinimap 	= false,
				bDodgeable 			= true,
				bIsAttack 			= false,
				bVisibleToEnemies 	= true,
				bReplaceExisting 	= false,
				flExpireTime 		= GameRules:GetGameTime() + 10,
				bProvidesVision 	= true,
				iVisionRadius 		= 400,
				iVisionTeamNumber 	= keys.caster:GetTeamNumber(),
				ExtraData = extra_data
			}

			ProjectileManager:CreateTrackingProjectile(projectile);
		end
		
	end
end

function raid_splinter_blast:OnProjectileHit_ExtraData(target, location, ExtraData)
	if target and target:IsAlive() and not target:HasModifier("modifier_generic_silenced_lua") then 
		local caster = self:GetCaster();
		if ExtraData.splinter_proc == 0 then 
			local splinter_proj = {
				caster 						= caster,
				target 						= target,
				ability 					= self,
				damage 						= ExtraData.damage, 
				slow_duration 				= ExtraData.slow_duration, 
				slow 						= ExtraData.slow, 
				attack_slow 				= ExtraData.attack_slow, 
				hero_cdr 					= ExtraData.hero_cdr, 
				cdr_units 					= ExtraData.cdr_units, 
				split_radius 				= ExtraData.split_radius, 
				splinter_threshold 			= ExtraData.splinter_threshold, 
				secondary_projectile_speed 	= ExtraData.secondary_projectile_speed,
				splinter_dmg_efficiency  	= ExtraData.splinter_dmg_efficiency,
				splinter_aoe_efficiency 	= ExtraData.splinter_aoe_efficiency,
				splinter_proc 			   	= ExtraData.splinter_proc + 1
			}
			
			raid_splinter_blast:OnTrackingProjectileHit(splinter_proj);
		end

		target:AddNewModifier(caster, self, "modifier_raid_splinter_blast_colba", {duration = ExtraData.slow_duration * (1 - target:GetStatusResistance())});
		
		caster:EmitSound("Hero_Winter_Wyvern.SplinterBlast.Splinter");

		local damage_table 			= {};
		damage_table.attacker 		= caster;
		damage_table.ability 		= self;
		damage_table.damage_type 	= self:GetAbilityDamageType();
		damage_table.damage	 		= ExtraData.damage;
		damage_table.victim  		= target;
		ApplyDamage(damage_table)
	end
end

--------------------------------------------------------------

modifier_raid_splinter_blast_colba = class({})

function modifier_raid_splinter_blast_colba:CheckState()
	local state = {
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_ROOTED] = true,
	[MODIFIER_STATE_INVISIBLE] = false,
	[MODIFIER_STATE_ATTACK_IMMUNE] = true,
	}
	return state
end

function modifier_raid_splinter_blast_colba:GetEffectName()
	return "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf"
end

function modifier_raid_splinter_blast_colba:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

raid_touch = class({})
modifier_raid_touch = class({})

function raid_touch:GetIntrinsicModifierName()
	return "modifier_raid_touch"
end

function modifier_raid_touch:DeclareFunctions()
	return {
      	MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_raid_touch:OnAttackLanded( keys )
	if keys.attacker == self:GetParent() then
	if keys.target:IsMagicImmune() then return end

	keys.target:EmitSound("Hero_Ancient_Apparition.ChillingTouch.Target")
	
	ApplyDamage({
		victim 			= keys.target,
		damage 			= self:GetAbility():GetSpecialValueFor("damage"),
		damage_type		= DAMAGE_TYPE_PURE,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self:GetCaster(),
		ability 		= self
	})
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, keys.target, self:GetAbility():GetSpecialValueFor("damage"), nil)
	end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function arctic_field(keys)
	local caster = keys.caster
	local ability = keys.ability
	local delay = ability:GetLevelSpecialValueFor("delay", (ability:GetLevel() - 1))
	local interval = 0.4
		
	Timers:CreateTimer( function()
		explode(keys, (delay + 3.0))
			if delay > 0 then
				delay = delay - interval
			return interval
				else
			return nil
		end
	end)
end

function explode(keys, delay)
	local caster = keys.caster
	local caster_pos = caster:GetAbsOrigin()
	local ability = keys.ability
	local damage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() - 1))
	local range = ability:GetLevelSpecialValueFor("range", (ability:GetLevel() - 1))
	local particle = "particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf"
	local particle_pre = "particles/units/heroes/hero_ancient_apparition/ancient_ice_vortex.vpcf"
	local damage_radius = ability:GetLevelSpecialValueFor("damage_radius", (ability:GetLevel() - 1))
	local target_pos = caster_pos
	local units = FindUnitsInRadius(caster:GetTeam(), caster_pos, nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
	if units[0] == nil then
		target_pos = caster_pos + RandomVector(RandomInt(0, range))
	else
		for k, unit in pairs(units) do
			target_pos = unit:GetAbsOrigin()
			break
		end
	end
	local pre_dummy = CreateUnitByName("npc_dummy_unit", target_pos, false, caster, caster, caster:GetTeamNumber())
	ability:ApplyDataDrivenModifier(caster, pre_dummy, "modifier_dummy", {})
	local preFX = ParticleManager:CreateParticle(particle_pre, PATTACH_ABSORIGIN, pre_dummy)
	ParticleManager:SetParticleControl(preFX, 1, Vector(damage_radius, 0, 0))
	ParticleManager:SetParticleControl(preFX, 5, Vector(damage_radius, 0, 0))
	EmitSoundOn("Hero_Ancient_Apparition.IceVortexCast", pre_dummy)
	
	Timers:CreateTimer(delay, function()
			ParticleManager:DestroyParticle(preFX, false)
			local dummy = CreateUnitByName("npc_dummy_unit", target_pos, false, caster, caster, caster:GetTeamNumber())
			ability:ApplyDataDrivenModifier(caster, dummy, "modifier_dummy", {})
			EmitSoundOn("Hero_Crystal.CrystalNova", dummy)
			EmitSoundOn("Hero_Crystal.CrystalNovaCast", dummy)
			local particleFX = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN, dummy)
			ParticleManager:SetParticleControl(particleFX, 3, Vector(damage_radius, 0, 0))
			ParticleManager:ReleaseParticleIndex(particleFX)
			local targets = FindUnitsInRadius(caster:GetTeam(), target_pos, nil, damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
			local damage_table = {}
			damage_table.attacker = caster
			damage_table.damage = damage
			damage_table.ability = ability
			damage_table.damage_type = ability:GetAbilityDamageType()
			for k, u in ipairs(targets) do
				damage_table.victim = u
				ApplyDamage(damage_table)
				u:AddNewModifier(caster, ability, "modifier_raid_mag_resist", {duration = 2 * (1 - u:GetStatusResistance())});
			end
	end)
end

--------------------------------------------------

modifier_raid_mag_resist = class({})

function modifier_raid_mag_resist:DeclareFunctions()
	return {
      	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    }
end

function modifier_raid_mag_resist:GetModifierMagicalResistanceBonus( keys )
return -25
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

raid_ice_skin = class({})
modifier_raid_ice_skin = class({})
modifier_raid_ice_skin_effect = class({})

function raid_ice_skin:GetIntrinsicModifierName()
	return "modifier_raid_ice_skin"
end

function modifier_raid_ice_skin:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end

function modifier_raid_ice_skin:OnTakeDamage(params)
	if IsServer() and self:GetAbility() then
	if params.unit~=self:GetParent() then return end
	if self:GetParent():PassivesDisabled() then return end
	if params.attacker:GetTeamNumber()==self:GetParent():GetTeamNumber() then return end
	
		params.attacker:AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_raid_ice_skin_effect",{duration = 3 * (1 - params.attacker:GetStatusResistance())} )
	end
end

----------------------------------------------------------------------------------------------

function modifier_raid_ice_skin_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE ,
		MODIFIER_PROPERTY_SPELL_LIFESTEAL_AMPLIFY_PERCENTAGE ,
	}
end

function modifier_raid_ice_skin_effect:GetModifierAttackSpeedBonus_Constant( keys )
return -250
end

function modifier_raid_ice_skin_effect:GetModifierMoveSpeedBonus_Percentage( keys )
return -25
end

function modifier_raid_ice_skin_effect:GetModifierHPRegenAmplify_Percentage( keys )
return -25
end

function modifier_raid_ice_skin_effect:GetModifierLifestealRegenAmplify_Percentage( keys )
return -25
end

function modifier_raid_ice_skin_effect:GetModifierSpellLifestealRegenAmplify_Percentage( keys )
return -25
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

raid_curse = class({})

function raid_curse:OnSpellStart()
	if IsServer() then 
		local caster 	= self:GetCaster();
		local target 	= self:GetCursorTarget();
		local ability 	= self;
		local duration  = self:GetSpecialValueFor("duration");

		if target:TriggerSpellAbsorb(ability) then return end
		
		caster:EmitSound("Hero_Winter_Wyvern.WintersCurse.Cast");
		target:EmitSound("Hero_Winter_Wyvern.WintersCurse.Target");
		
		if RandomInt(1,100) > 80 then 
			local random_sound = RandomInt(1, 14);
			if random_sound < 10 then 
				caster:EmitSound("winter_wyvern_winwyv_winterscurse_0"..random_sound);
			else
				caster:EmitSound("winter_wyvern_winwyv_winterscurse_"..random_sound);
			end
		end

		caster:AddNewModifier(caster, ability, "winter_wyvern_winters_curse_kill_credit", {});
		target:AddNewModifier(caster, ability, "modifier_winter_wyvern_winters_curse_aura", {duration = duration})
		local enemies = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
		 for _,unit in pairs(enemies) do
			if unit then
				target:AddNewModifier(caster, ability, "modifier_fake", {duration = duration});
				unit:AddNewModifier(target, ability, "modifier_fake_attack", {duration = duration});
			end
		 end
	end
end

-------------------------------------------------------------------------------

modifier_fake = class({})

function modifier_fake:IsHidden()
	return false
end

function modifier_fake:IsDebuff()
	return true
end

function modifier_fake:IsStunDebuff()
	return false
end

function modifier_fake:IsPurgable()
	return false
end

function modifier_fake:OnCreated( kv )
	if IsServer() then
	end
end

function modifier_fake:CheckState()
	local state = {
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_FAKE_ALLY ] = true,
		[MODIFIER_STATE_SPECIALLY_DENIABLE] = true,
	}
	return state
end

-----------------------------------------------------------------------

modifier_fake_attack = class({})

function modifier_fake_attack:IsHidden()
	return false
end

function modifier_fake_attack:IsDebuff()
	return true
end

function modifier_fake_attack:IsStunDebuff()
	return false
end

function modifier_fake_attack:IsPurgable()
	return false
end

function modifier_fake_attack:OnCreated( kv )
	if IsServer() then
		self:GetParent():SetForceAttackTarget( self:GetCaster() ) -- for creeps
		self:GetParent():MoveToTargetToAttack( self:GetCaster() ) -- for heroes
	end
end

function modifier_fake_attack:OnRefresh( kv )
end

function modifier_fake_attack:OnRemoved()
	if IsServer() then
		self:GetParent():SetForceAttackTarget( nil )
	end
end

function modifier_fake_attack:OnDestroy()
end

function modifier_fake_attack:CheckState()
	local state = {
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}
	return state
end