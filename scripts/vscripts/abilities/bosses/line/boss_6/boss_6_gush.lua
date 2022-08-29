LinkLuaModifier("modifier_boss_6_gush_surf", "abilities/bosses/line/boss_6/boss_6_gush", LUA_MODIFIER_MOTION_NONE)

boss_6_gush = class({})

function boss_6_gush:OnSpellStart()
	self:GetCaster():EmitSound("Ability.GushCast")
	
	local gush_dummy = CreateModifierThinker(self:GetCaster(), self, nil, {}, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
	gush_dummy:EmitSound("Hero_Tidehunter.Gush.AghsProjectile")
	
	local caster_pos = self:GetCaster():GetAbsOrigin()
	local line_pos = caster_pos + self:GetCaster():GetForwardVector() * 300
	
	local rotation_rate = 360 / 6
	for i = 1, 6 do
		line_pos = RotatePosition(caster_pos, QAngle(0, rotation_rate, 0), line_pos)
		local direction	= (line_pos - self:GetCaster():GetAbsOrigin()):Normalized()
		self:creategush(direction, gush_dummy)	
	end
end

function boss_6_gush:creategush(direction, gush_dummy)
		local linear_projectile = {
			Ability				= self,
			EffectName			= "particles/units/heroes/hero_tidehunter/tidehunter_gush_upgrade.vpcf", -- Might not do anything
			vSpawnOrigin		= self:GetCaster():GetAbsOrigin(),
			fDistance			= 600,
			fStartRadius		= 200,
			fEndRadius			= 200,
			Source				= self:GetCaster(),
			bHasFrontalCone		= false,
			bReplaceExisting	= false,
			iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_BOTH, -- IMBAfication: Surf's Up!
			iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime 		= GameRules:GetGameTime() + 10.0,
			bDeleteOnHit		= true,
			vVelocity			= direction * 500,
			bProvidesVision		= false,
			
			ExtraData			= 
			{
				bScepter 	= true, 
				bTargeted	= false,
				speed		= 1500,
				x			= direction.x,
				y			= direction.y,
				z			= direction.z,
				bFiltrate	= filtration_wave,
				gush_dummy	= gush_dummy:entindex(),
			}
		}
		
		self.projectile = ProjectileManager:CreateLinearProjectile(linear_projectile)
end

function boss_6_gush:OnProjectileThink_ExtraData(location, data)
	if not IsServer() then return end
	
	if data.gush_dummy then
		EntIndexToHScript(data.gush_dummy):SetAbsOrigin(location)
	end
end

function boss_6_gush:OnProjectileHit_ExtraData(target, location, data)
	if not IsServer() then return end

	if target then
		if target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
			if data.bTargeted == 1 and target:TriggerSpellAbsorb(self) then
				target:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = 2})
				return nil
			end

			target:EmitSound("Ability.GushImpact")

			if data.bFiltrate == 1 then
				target:Purge(true, false, false, false, false)
			end

			if not (data.bScepter == 1 and data.bTargeted == 1) then
				local damageTable = {
					victim 			= target,
					damage 			= 10000,
					damage_type		= self:GetAbilityDamageType(),
					damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
					attacker 		= self:GetCaster(),
					ability 		= self
				}

				ApplyDamage(damageTable)
				
				local surf_modifier = target:AddNewModifier(self:GetCaster(), self, "modifier_boss_6_gush_surf", 
				{
					duration	= 2,
					speed		= data.speed,
					x			= data.x,
					y			= data.y,
					z			= data.z,
				})
				

				if self:GetCaster():GetName() == "npc_dota_hero_tidehunter" and target:IsRealHero() and not target:IsAlive() and RollPercentage(25) then
					self:GetCaster():EmitSound("tidehunter_tide_ability_gush_0"..RandomInt(1, 2))
				end
			end
		end
	end
end

---------------------------

modifier_boss_6_gush_surf = class({})

function modifier_boss_6_gush_surf:OnCreated(params)
	if not IsServer() then return end
	
	if self:GetAbility() then
		self.speed			= params.speed
		self.direction		= Vector(params.x, params.y, params.z)
		self.surf_speed_pct	= 15
		
		self:StartIntervalThink(FrameTime())
	else
		self:Destroy()
	end
end

function modifier_boss_6_gush_surf:OnRefresh(params)
	if not IsServer() then return end
	
	self:OnCreated(params)
end

function modifier_boss_6_gush_surf:OnIntervalThink()
	if not IsServer() then return end
	
	FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin() + (self.direction * self.speed * self.surf_speed_pct * 0.01 * FrameTime()), false)
end
