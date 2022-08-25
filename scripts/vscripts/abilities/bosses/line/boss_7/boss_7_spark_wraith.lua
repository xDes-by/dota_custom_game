LinkLuaModifier("modifier_boss_7_spark_wraith_thinker", "abilities/bosses/line/boss_7/boss_7_spark_wraith", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_boss_7_spark_wraith_purge", "abilities/bosses/line/boss_7/boss_7_spark_wraith", LUA_MODIFIER_MOTION_NONE)

boss_7_spark_wraith = class({})

function boss_7_spark_wraith:OnSpellStart()
	self:GetCaster():EmitSound("Hero_ArcWarden.SparkWraith.Cast")
	for i = 1, self:GetSpecialValueFor("count") do
		local point = self:GetCaster():GetAbsOrigin() + RandomVector(RandomInt(RandomInt(500, 500), RandomInt(500, 500)))
		EmitSoundOnLocationWithCaster(point, "Hero_ArcWarden.SparkWraith.Appear", self:GetCaster())
			
		CreateModifierThinker(self:GetCaster(), self, "modifier_boss_7_spark_wraith_thinker", {
			duration = self:GetSpecialValueFor("duration")}, 
			point, self:GetCaster():GetTeamNumber(), false)	
	end
end

function boss_7_spark_wraith:OnProjectileHit_ExtraData(target, location, ExtraData)
	if target then
		if not target:IsMagicImmune() then
			target:EmitSound("Hero_ArcWarden.SparkWraith.Damage")
			
			if ExtraData.auto_cast == 1 then
				local burst_particle = ParticleManager:CreateParticle("particles/econ/items/arc_warden/arc_warden_ti9_immortal/arc_warden_ti9_wraith_prj_burst.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
				ParticleManager:ReleaseParticleIndex(burst_particle)
			end
			
			ApplyDamage({
				victim 			= target,
				damage 			= ExtraData.spark_damage,
				damage_type		= self:GetAbilityDamageType(),
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= self:GetCaster(),
				ability 		= self
			})
			
			target:AddNewModifier(self:GetCaster(), self, "modifier_boss_7_spark_wraith_purge", {duration = self:GetSpecialValueFor("tick") * (1 - target:GetStatusResistance())})
		end
		return true
	end
end

---------------------------------------------------

modifier_boss_7_spark_wraith_thinker = class({})

function modifier_boss_7_spark_wraith_thinker:OnCreated()
	if not self:GetAbility() then self:Destroy() return end
	
	self.radius				= self:GetAbility():GetSpecialValueFor("radius")
	self.activation_delay	= self:GetAbility():GetSpecialValueFor("activation_delay")
	self.wraith_speed		= self:GetAbility():GetSpecialValueFor("wraith_speed")
	self.spark_damage		= self:GetAbility():GetSpecialValueFor("spark_damage")
	self.think_interval			= self:GetAbility():GetSpecialValueFor("tick")

	if not IsServer() then return end
	
	self:GetParent():EmitSound("Hero_ArcWarden.SparkWraith.Loop")
	
	self.wraith_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_wraith.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.wraith_particle, 1, Vector(self.radius, 1, 1))
	self:AddParticle(self.wraith_particle, false, false, -1, false, false)
	
	self:GetCaster():SetContextThink(DoUniqueString(self:GetName()), function()
		self:StartIntervalThink(self.think_interval)
		return nil
	end, self.activation_delay - self.think_interval)
end

function modifier_boss_7_spark_wraith_thinker:OnIntervalThink()
	for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)) do
		self:GetParent():EmitSound("Hero_ArcWarden.SparkWraith.Activate")
		
		ProjectileManager:CreateTrackingProjectile({
			EffectName			= "particles/units/heroes/hero_arc_warden/arc_warden_wraith_prj.vpcf",
			Ability				= self:GetAbility(),
			Source				= self:GetParent(),
			vSourceLoc			= self:GetParent():GetAbsOrigin(),
			Target				= enemy,
			iMoveSpeed			= self.wraith_speed,
			flExpireTime		= nil,
			bDodgeable			= false,
			bIsAttack			= false,
			bReplaceExisting	= false,
			iSourceAttachment	= nil,
			bDrawsOnMinimap		= nil,
			ExtraData			= {
				spark_damage		= self.spark_damage,
				thinker_time		= self:GetElapsedTime(),
				thinker_duration	= self:GetDuration()
			}
		})
		
		self:Destroy()
		break
	end
end

function modifier_boss_7_spark_wraith_thinker:OnDestroy()
	if not IsServer() then return end
	
	self:GetParent():StopSound("Hero_ArcWarden.SparkWraith.Loop")
end

-------------------------------------------------

modifier_boss_7_spark_wraith_purge = class({})

function modifier_boss_7_spark_wraith_purge:OnCreated()
	if not self:GetAbility() then self:Destroy() return end
	
	self.move_speed_slow_pct	= self:GetAbility():GetSpecialValueFor("move_speed_slow_pct") * (-1)
end

function modifier_boss_7_spark_wraith_purge:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end

function modifier_boss_7_spark_wraith_purge:GetModifierMoveSpeedBonus_Percentage()
	return self.move_speed_slow_pct
end