raid_aura = class({})

function raid_aura:GetIntrinsicModifierName()
	return "modifier_raid_aura"
end

LinkLuaModifier( "modifier_raid_aura", "abilities/bosses/raid_boss.lua", LUA_MODIFIER_MOTION_NONE )

modifier_raid_aura = class({})

--------------------------------------------------------------------------------
function modifier_raid_aura:IsHidden()
	return true
end

function modifier_raid_aura:IsPurgable()
	return false
end

function modifier_raid_aura:OnCreated( kv )
	self:StartIntervalThink(0.2)
end

function modifier_raid_aura:OnIntervalThink()
if IsServer() then
	
	if self:GetCaster():GetUnitName() == "npc_raid_earth" or
		self:GetCaster():GetUnitName() == "npc_raid_storm" or
		self:GetCaster():GetUnitName() == "npc_raid_fire" then 
		mag = 7.5
		phys = 175
	else
		mag = 5
		phys = 150
	end
	
	local heroes = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 1500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		self:GetCaster():SetBaseMagicalResistanceValue(100 - mag * #heroes)
		self:GetCaster():SetPhysicalArmorBaseValue(1300 - phys * #heroes)
	end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

fire_raze = class({})

function fire_raze:OnSpellStart()
	for i=1, RandomInt(15,30) do	
		local info = 
		{
			Ability = self,
			EffectName = "particles/lina_base_attack2.vpcf",
			vSpawnOrigin = self:GetCaster():GetAbsOrigin(),
			fDistance = 3000,
			fStartRadius = 64,
			fEndRadius = 64,
			Source = self:GetCaster(),
			bHasFrontalCone = false,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_ALL,
			fExpireTime = GameRules:GetGameTime() + 10.0,
			bDeleteOnHit = false,
			vVelocity = RandomVector(1) * 500,
			bProvidesVision = false,
			iVisionRadius = 1000,
			iVisionTeamNumber = self:GetCaster():GetTeamNumber()
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)
	end
	
	Timers:CreateTimer(1, function()
		for i=1, RandomInt(15,30) do	
		local info = 
		{
			Ability = self,
			EffectName = "particles/lina_base_attack2.vpcf",
			vSpawnOrigin = self:GetCaster():GetAbsOrigin(),
			fDistance = 3000,
			fStartRadius = 64,
			fEndRadius = 64,
			Source = self:GetCaster(),
			bHasFrontalCone = false,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_ALL,
			fExpireTime = GameRules:GetGameTime() + 10.0,
			bDeleteOnHit = false,
			vVelocity = RandomVector(1) * 500,
			bProvidesVision = false,
			iVisionRadius = 1000,
			iVisionTeamNumber = self:GetCaster():GetTeamNumber()
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)
	end
	end)
	
	EmitSoundOn( "Conquest.FireTrap.Generic", self:GetCaster() )
end

--------------------------------------------------------------------------------

function fire_raze:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then

		local damageSource = self:GetCaster()
		if self:GetCaster() ~= nil and self:GetCaster().KillerToCredit ~= nil then
			damageSource = self:GetCaster().KillerToCredit
		end

		local damage = {
			victim = hTarget,
			attacker = damageSource,
			damage = hTarget:GetMaxHealth()*0.25,
			damage_type = DAMAGE_TYPE_PURE,
			ability = self
		}
		ApplyDamage( damage )
	end
	return false
end

------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

fire_storm = class({})

function fire_storm:OnSpellStart()
	local hCaster = self:GetCaster()
	local point = self:GetCaster():GetOrigin()
	local i = 1
	for i=1, 9 do
		local spot = point + RandomVector( RandomInt( 150, 750 ))

		if debug_drawing == true then
			DebugDrawCircle(spot, Vector(255,100,0), 1, 215, true, 5)
		end
		local shadow_effect = ParticleManager:CreateParticle("particles/meteor_shadow.vpcf", PATTACH_ABSORIGIN, hCaster)
		ParticleManager:SetParticleControl(shadow_effect, 0, spot + Vector(0,0,200))

		local meteor_effect = ParticleManager:CreateParticle("particles/invoker_chaos_meteor_fly2.vpcf", PATTACH_ABSORIGIN, hCaster)
		ParticleManager:SetParticleControl(meteor_effect, 0, spot + Vector(0,0,2000))
		ParticleManager:SetParticleControl(meteor_effect, 1, spot)
		ParticleManager:SetParticleControl(meteor_effect, 2, Vector(4,0,0))

		Timers:CreateTimer(4, function()

			local crash_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_hit.vpcf", PATTACH_ABSORIGIN, hCaster)
			ParticleManager:SetParticleControl(crash_effect, 0, spot + Vector(0,0,200))

			local unitTable = FindUnitsInRadius(hCaster:GetTeamNumber(),spot, nil, 315, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				for k ,unit in pairs(unitTable) do
	   					local damageTable = {
						victim = unit,
						attacker = hCaster,
						damage = unit:GetMaxHealth()*0.3,
						damage_type = DAMAGE_TYPE_PURE,
						}				 
						ApplyDamage(damageTable)
				end
			return 
		end)
	end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

function OnNue04PhaseStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local ufoIndex = ParticleManager:CreateParticle("particles/heroes/nue/ability_nue_04_light_ufo.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl( ufoIndex , 0, caster:GetOrigin())
	ParticleManager:DestroyParticleSystemTime(ufoIndex,1.0)
	StartAnimation(caster, {duration = 2, activity = ACT_DOTA_CAST_ABILITY_1})
end

function ParticleManager:DestroyParticleSystemTime(effectIndex,time)
    Timers:CreateTimer(time,
        function()
            ParticleManager:DestroyParticle(effectIndex,true)
            ParticleManager:ReleaseParticleIndex(effectIndex) 
        end
    )
end

function ParticleManager:DestroyParticleSystem(effectIndex,bool)
    if(bool)then
        ParticleManager:DestroyParticle(effectIndex,true)
        ParticleManager:ReleaseParticleIndex(effectIndex) 
    else
         Timers:CreateTimer(1,
            function()
                ParticleManager:DestroyParticle(effectIndex,true)
                ParticleManager:ReleaseParticleIndex(effectIndex) 
            end
        )
    end
end

LinkLuaModifier( "modifier_generic_stunned_lua", "heroes/generic/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )

function OnNue04Start(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]
	

	local ufoMoveIndex = ParticleManager:CreateParticle("particles/meteor_shadow.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl( ufoMoveIndex , 0, targetPoint)
	AddFOWViewer( DOTA_TEAM_GOODGUYS, targetPoint, 700, 1.5, false)

	local time = 2.5
	caster:SetContextThink(DoUniqueString("OnNue04SpellThinkUfo"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			if time>0 then
				time = time - 0.05
			else
				ParticleManager:DestroyParticleSystem(ufoMoveIndex,true)
				return nil
			end
			ParticleManager:SetParticleControl( ufoMoveIndex , 0, targetPoint - Vector(550,0,0) + (caster:GetOrigin() - targetPoint):Normalized()*time*100 )
			return 0.05
		end,
	0.05)

	caster:AddNoDraw()
	caster:AddNewModifier( caster, nil, "modifier_disarmed", { duration = 2 } )
	caster:SetContextThink(DoUniqueString("OnNue04SpellThink"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			caster:RemoveNoDraw()
			local targets = FindUnitsInRadius(
			   caster:GetTeam(),		
			   targetPoint,	
			   nil,					
			   keys.Radius,		
			   DOTA_UNIT_TARGET_TEAM_ENEMY,
			   keys.ability:GetAbilityTargetType(),
			   0,
			   FIND_CLOSEST,
			   false
		    )
		    
			local effectIndex = ParticleManager:CreateParticle("particles/heroes/nue/ability_nue_04.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl( effectIndex , 0, targetPoint)
			ParticleManager:SetParticleControl( effectIndex , 2, Vector(147,112,219))
			if caster:GetName() == "npc_dota_hero_phantom_assassin" then
				caster:EmitSound("Voice_Thdots_Nue.AbilityNue04_2")
			end

		    for k,v in pairs(targets) do
		    	local damage_table = {
					ability = keys.ability,
				    victim = v,
				    attacker = caster,
				    damage = v:GetMaxHealth()*0.35,
				    damage_type = keys.ability:GetAbilityDamageType(), 
		    	    damage_flags = keys.ability:GetAbilityTargetFlags()
				}
				
				v:AddNewModifier( caster, nil, "modifier_generic_stunned_lua", { duration = 1.5 } )
				
		    	ApplyDamage(damage_table)
			end
			FindClearSpaceForUnit(caster, targetPoint, true)
			caster:StartGesture(ACT_DOTA_CAST_ABILITY_4_END)
			local ufoIndex2 = ParticleManager:CreateParticle("particles/heroes/nue/ability_nue_04_light_ufo.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl( ufoIndex2 , 0, caster:GetOrigin())
			ParticleManager:DestroyParticleSystemTime(ufoIndex2,1.0)

			caster:EmitSound("Nue.AbilityNue04_End")
			caster:EmitSound("Nue.AbilityNue04_End_stomp")

			return nil
		end,
	2.5)
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function custom_sustrike_delay(event)
	local caster = event.caster
	local caster_pos = caster:GetAbsOrigin()
	local ability = event.ability
	local ability_level = ability:GetLevel() -1
	local range = ability:GetLevelSpecialValueFor("range", ability_level)
	local delay = ability:GetLevelSpecialValueFor("delay", ability_level)
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local damage_radius = ability:GetLevelSpecialValueFor("damage_radius", ability_level)
	local particle_pre = "particles/econ/items/invoker/invoker_apex/invoker_sun_strike_team_immortal1.vpcf"
	local particle = "particles/econ/items/invoker/invoker_apex/invoker_sun_strike_immortal1.vpcf"
	
	local angle = RandomInt(0, 360)
	local variance = RandomInt(-range, range)
	local dy = math.sin(angle) * variance
	local dx = math.cos(angle) * variance
	local target_pos = Vector(caster_pos.x + dx, caster_pos.y + dy, caster_pos.z)
	local dummy = CreateUnitByName("npc_dummy_unit", target_pos, false, caster, caster, caster:GetTeamNumber())
	ability:ApplyDataDrivenModifier(caster, dummy, "modifier_dummy", {})
	local particleIndexPre = ParticleManager:CreateParticle(particle_pre, PATTACH_ABSORIGIN, dummy)

		Timers:CreateTimer(delay, function()
			EmitSoundOn("Hero_Invoker.SunStrike.Ignite", caster)
			ParticleManager:DestroyParticle( particleIndexPre, false )
			local particleIndex = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN, dummy)
			local units = FindUnitsInRadius(caster:GetTeam(), target_pos, nil, damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false)
			for k, unit in ipairs(units) do
				local damage_table = {
										attacker = caster,
										victim = unit,
										ability = ability,
										damage_type = event.ability:GetAbilityDamageType(),
										damage = unit:GetMaxHealth()*0.75
									}
				ApplyDamage(damage_table)
			end
		return nil
	end)
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

box_gems = {"item_gems_1","item_gems_2","item_gems_3","item_gems_4","item_gems_5"}

function gems1(event)
caster = event.caster
spawnPoint = caster:GetAbsOrigin()
caster:EmitSound("Item.DropGemWorld")
			
			local rp = "item_points_small"
			local newItem = CreateItem( rp, nil, nil )
			local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
			local dropRadius = RandomFloat( 150, 150 )
			newItem:LaunchLootInitialHeight( false, 0, 150, 0.5, spawnPoint + RandomVector( dropRadius ) )

		for i = 1, 10 do
			item_name = box_gems[RandomInt(1,#box_gems)]
			local newItem = CreateItem( item_name, nil, nil )
			local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
			local dropRadius = RandomFloat( 150, 150 )
			newItem:LaunchLootInitialHeight( false, 0, 150, 0.5, spawnPoint + RandomVector( dropRadius ) )
		end
	end
	
function gems2(event)
caster = event.caster
spawnPoint = caster:GetAbsOrigin()
caster:EmitSound("Item.DropGemWorld")

		for i =1, 2 do
			local rp = "item_points_small"
			local newItem = CreateItem( rp, nil, nil )
			local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
			local dropRadius = RandomFloat( 150, 150 )
			newItem:LaunchLootInitialHeight( false, 0, 150, 0.5, spawnPoint + RandomVector( dropRadius ) )
		end
		
		for i = 1, 20 do
			item_name = box_gems[RandomInt(1,#box_gems)]
			local newItem = CreateItem( item_name, nil, nil )
			local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
			local dropRadius = RandomFloat( 150, 150 )
			newItem:LaunchLootInitialHeight( false, 0, 150, 0.5, spawnPoint + RandomVector( dropRadius ) )
		end
end
	
function gems3(event)
caster = event.caster
spawnPoint = caster:GetAbsOrigin()
caster:EmitSound("Item.DropGemWorld")

		for i =1, 3 do
			local rp = "item_points_small"
			local newItem = CreateItem( rp, nil, nil )
			local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
			local dropRadius = RandomFloat( 150, 150 )
			newItem:LaunchLootInitialHeight( false, 0, 150, 0.5, spawnPoint + RandomVector( dropRadius ) )
		end
		
		for i = 1, 30 do
			item_name = box_gems[RandomInt(1,#box_gems)]
			local newItem = CreateItem( item_name, nil, nil )
			local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
			local dropRadius = RandomFloat( 150, 150 )
			newItem:LaunchLootInitialHeight( false, 0, 150, 0.5, spawnPoint + RandomVector( dropRadius ) )
		end
end			