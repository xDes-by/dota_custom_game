LinkLuaModifier("modifier_himars", "modifiers/modifier_himars.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_himars_attack", "heroes/hero_sniper/sniper_tank/call_tank.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_himars_attack_with_caster", "heroes/hero_sniper/sniper_tank/call_tank.lua", LUA_MODIFIER_MOTION_NONE)

function call_tank(params)
    local caster = params.caster
    local player = caster:GetOwner()
    local ability = params.ability
    local position = caster:GetAbsOrigin()
    base_damage = caster:GetStrength() * 5
	
	count = 5
	local modifier = caster:AddNewModifier(caster, ability,  "modifier_himars", nil)
	local currentStacks = caster:GetModifierStackCount( "modifier_himars", ability)
	
	if currentStacks < count then
	
	caster:SetModifierStackCount( "modifier_himars", caster,currentStacks + 1 )

    
	if not caster:IsMuted() then
		local unit = CreateUnitByName("sniper_tank", position, true, caster,player, DOTA_TEAM_GOODGUYS)
			unit:SetOwner( caster )
			unit:SetControllableByPlayer(player:GetPlayerID(), false)
			unit:AddAbility("himars_attack"):SetLevel(1)
			unit:AddAbility("boom_himars"):SetLevel(1)
			unit:AddNewModifier(caster,ability,"modifier_invulnerable",{})
			if caster:FindAbilityByName("special_bonus_unique_npc_dota_hero_sniper_str50") ~= nil then
				unit:AddNewModifier(caster,ability,"modifier_himars_attack_with_caster",{})
			end
		end
	end
end

function boom(data)
	local caster = data.caster
	caster:SetModel("models/development/invisiblebox.vmdl")
	local particle_explosion = "particles/units/heroes/hero_tinker/tinker_missle_explosion.vpcf"
	local particle_explosion_fx = ParticleManager:CreateParticle(particle_explosion, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(particle_explosion_fx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_explosion_fx, 1, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_explosion_fx, 2, Vector(100, 1, 1))
	ParticleManager:ReleaseParticleIndex(particle_explosion_fx)
	data.caster:EmitSound("Hero_Tinker.Heat-Seeking_Missile_Dud")
	data.caster:ForceKill(false)
end

function die(data)
	local caster = data.caster
	if caster:GetUnitName() == "sniper_tank" then
		local own = caster:GetOwner()
		local currentStacks = own:GetModifierStackCount( "modifier_himars", ability)
		own:SetModifierStackCount( "modifier_himars", own,currentStacks - 1 )
	end
end

---------------------------------------
himars_attack = class({})

function himars_attack:GetIntrinsicModifierName()
	return "modifier_himars_attack"
end

----------------------------

modifier_himars_attack = class({})

function modifier_himars_attack:IsHidden()
	return true
end

function modifier_himars_attack:IsPurgable()
	return false
end

function modifier_himars_attack:OnCreated(kv)
if not IsServer() then return end
	interval = 2
	if self:GetCaster():GetOwner():FindAbilityByName("npc_dota_hero_sniper_str11") ~= nil then
		interval = 1
	end

	self:StartIntervalThink(interval)
end

function modifier_himars_attack:OnIntervalThink()
	if not IsServer() then return end
	if self:GetParent():IsMoving() or not self:GetParent():IsAlive() then return end	
	if PlayerResource:GetConnectionState(self:GetCaster():GetPlayerOwnerID()) == DOTA_CONNECTION_STATE_ABANDONED then return end
	
	local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 3000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)
	if #enemies > 0 then
		enemy = enemies[1]
		if enemy:GetUnitName() == 'npc_dota_hero_target_dummy' then return end
		position = enemy:GetAbsOrigin()
		self:GetCaster():EmitSound("rattletrap_ratt_ability_flare_0"..RandomInt(1, 7))
		
		-- self:GetParent():SetForwardVector(Vector(position.x, position.y, 0))
		 self:GetParent():FaceTowards(position)
		
		local rocket =
			{
				Target 				= enemy,
				Source 				= self:GetParent(),
				Ability 			= self:GetAbility(),
				EffectName 			= "particles/units/heroes/hero_rattletrap/rattletrap_rocket_flare.vpcf",
				iMoveSpeed			= 800,
				vSourceLoc 			= self:GetParent():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_attack1")),
				bIsAttack 			= false,
				bVisibleToEnemies 	= true,
				bReplaceExisting 	= false,
				flExpireTime 		= GameRules:GetGameTime() + 20,
			}
		
		ProjectileManager:CreateTrackingProjectile(rocket)
	end
end


function himars_attack:OnProjectileHit(hTarget, vLocation)
	EmitSoundOnLocationWithCaster(vLocation, "Hero_Rattletrap.Rocket_Flare.Explode", self:GetCaster())
	
	damage = self:GetCaster():GetOwner():GetStrength() * 5

	if self:GetCaster():GetOwner():FindAbilityByName("npc_dota_hero_sniper_str_last") ~= nil then
		damage = damage * 3
	end

	local illumination_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_rattletrap/rattletrap_rocket_flare_illumination.vpcf", PATTACH_POINT, hTarget)
	ParticleManager:SetParticleControl(illumination_particle, 1, Vector(2, 0, 0))
	ParticleManager:ReleaseParticleIndex(illumination_particle)
	
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), vLocation, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	
	for _, enemy in pairs(enemies) do

		local damageTable = {
			victim 			= enemy,
			damage 			= damage,
			damage_type		= DAMAGE_TYPE_MAGICAL,
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster()
		}
		
		ApplyDamage(damageTable)
	end
	AddFOWViewer(self:GetCaster():GetTeamNumber(), vLocation, 300, 2, false)
end


function modifier_himars_attack:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,}
	return state
end


modifier_himars_attack_with_caster = class({})
--Classifications template
function modifier_himars_attack_with_caster:IsHidden()
	return true
end

function modifier_himars_attack_with_caster:IsDebuff()
	return false
end

function modifier_himars_attack_with_caster:IsPurgable()
	return false
end

function modifier_himars_attack_with_caster:IsPurgeException()
	return false
end

-- Optional Classifications
function modifier_himars_attack_with_caster:IsStunDebuff()
	return false
end

function modifier_himars_attack_with_caster:RemoveOnDeath()
	return true
end

function modifier_himars_attack_with_caster:DestroyOnExpire()
	return true
end

function modifier_himars_attack_with_caster:OnCreated()
	if not IsServer() then
		return
	end
	self.abi = self:GetParent():GetOwner():FindAbilityByName("himars_attack")
end

function modifier_himars_attack_with_caster:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK
	}
end

function modifier_himars_attack_with_caster:OnAttack(params)
	if params.attacker == self:GetParent():GetOwner() then
		local rocket =
		{
			Target 				= params.target,
			Source 				= self:GetParent(),
			Ability 			= self.abi,
			EffectName 			= "particles/units/heroes/hero_rattletrap/rattletrap_rocket_flare.vpcf",
			iMoveSpeed			= 800,
			vSourceLoc 			= self:GetParent():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_attack1")),
			bIsAttack 			= false,
			bVisibleToEnemies 	= true,
			bReplaceExisting 	= false,
			flExpireTime 		= GameRules:GetGameTime() + 20,
		}
	
	ProjectileManager:CreateTrackingProjectile(rocket)
	end
end