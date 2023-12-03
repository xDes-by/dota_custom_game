wisp_spirits_bh = class({})
LinkLuaModifier("modifier_wisp_spirits_bh", "heroes/hero_wisp/wisp_spirits/wisp_spirits_bh", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wisp_spirits_bh_wisp", "heroes/hero_wisp/wisp_spirits/wisp_spirits_bh", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wisp_spirits_bh_talent", "heroes/hero_wisp/wisp_spirits/wisp_spirits_bh", LUA_MODIFIER_MOTION_NONE)

--Valve fucked up and didnt sync up the spirit particles
--so the the actual spirit particles are the default ones regardless
--so i just made it a 50% of either the normal particles and immo particles

function wisp_spirits_bh:Spawn()
	if self:GetLevel() > 0 and IsServer() then
    	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_wisp_spirits_bh", {})
	end
end

function wisp_spirits_bh:OnUpgrade()
	if not self:GetCaster():HasModifier("modifier_wisp_spirits_bh") and self:GetCaster():IsAlive() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_wisp_spirits_bh", {})
	end
end

function wisp_spirits_bh:OnToggle()
	-- if self:GetCaster():HasModifier("modifier_wisp_spirit_inout") then
	-- 	self:GetCaster():RemoveModifierByName("modifier_wisp_spirit_inout")
	-- else
	-- 	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_wisp_spirit_inout", {})
	-- end
end

function wisp_spirits_bh:CreateSpiritWisp()
	local caster = self:GetCaster()

	local distance = self:GetCastRange(self:GetCaster():GetAbsOrigin(), self:GetCaster())
	local point = caster:GetAbsOrigin() + caster:GetForwardVector() * distance --+ Vector(0, 0, 100)

	local wisp = CreateUnitByName("npc_spitit_wisp", point, false, caster, caster, caster:GetTeam())
	wisp:AddNewModifier(caster, self, "modifier_wisp_spirits_bh_wisp", {})
	-- caster:SpendMana( self:GetSpecialValueFor("wisp_regen_cost"), self )
	table.insert(self.spirits, wisp)
end

modifier_wisp_spirits_bh = class({})

function modifier_wisp_spirits_bh:OnCreated(table)
	if IsServer() then
		EmitSoundOn("Hero_Wisp.Spirits.Loop", self:GetCaster())

		self.wispCount = self:GetAbility():GetSpecialValueFor("max_wisps")
		self.max_wisps = self:GetAbility():GetSpecialValueFor("max_wisps")
		self.speed = self:GetAbility():GetSpecialValueFor("spirit_movement_rate")
		self:GetAbility().spirits = {}
		-- if self:GetCaster():HasTalent("special_bonus_unique_wisp_spirits_bh_2") then
		-- 	self.talent = true
		-- end

		self.maxDistance = self:GetAbility():GetCastRange(self:GetCaster():GetAbsOrigin(), self:GetCaster())

		self.minDistance = self:GetAbility():GetSpecialValueFor("min_radius")

		self.currentDistance = self.minDistance

		self.distanceTick = self.speed/3 * FrameTime()

		self.time = (360/self.speed)/(self.max_wisps + 1)
		
		self.elaspedTime = 0
		self.cost = self:GetAbility():GetSpecialValueFor("wisp_regen_cost")
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_wisp_spirits_bh:OnIntervalThink()
	if not IsServer() then return end
	local caster = self:GetCaster()
	if self.elaspedTime < self.time then
		self.elaspedTime = self.elaspedTime + FrameTime()
	else
		if self.wispCount > 0 and caster:GetMana() >= self.cost then
			self:GetAbility():CreateSpiritWisp()
			self.wispCount = self.wispCount - 1
		else
			self.time = self:GetAbility():GetSpecialValueFor("wisp_regen_rate")
		end
		self.elaspedTime = 0
	end

	if self:GetAbility():GetToggleState() then
		if self.currentDistance > self.minDistance then
			self.currentDistance = self.currentDistance - self.distanceTick
		end
	else
		if self.currentDistance < self.maxDistance then
			self.currentDistance = self.currentDistance + self.distanceTick
		end
	end
end

function modifier_wisp_spirits_bh:OnRemoved()
	if IsServer() then
		StopSoundOn("Hero_Wisp.Spirits.Loop", self:GetCaster())
		self:GetCaster():RemoveModifierByName("modifier_wisp_spirits_bh_spirit")
	end
end

function modifier_wisp_spirits_bh:IsAura()
    return self.talent
end

function modifier_wisp_spirits_bh:GetAuraDuration()
    return 0.5
end

function modifier_wisp_spirits_bh:GetAuraRadius()
    return self.currentDistance
end

function modifier_wisp_spirits_bh:GetAuraEntityReject(hEntity)
	if hEntity == self:GetParent() then
		return true
	end
end

function modifier_wisp_spirits_bh:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_wisp_spirits_bh:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_wisp_spirits_bh:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_wisp_spirits_bh:GetModifierAura()
    return "modifier_wisp_spirits_bh_talent"
end

function modifier_wisp_spirits_bh:IsPurgable()
    return false
end

function modifier_wisp_spirits_bh:RemoveOnDeath()
    return false
end

function modifier_wisp_spirits_bh:IsPurgeException()
    return false
end

modifier_wisp_spirits_bh_wisp = class({})
function modifier_wisp_spirits_bh_wisp:OnCreated(table)
	if IsServer() then
		local caster = self:GetCaster()
		local parent = self:GetParent()

		local particle = "particles/units/heroes/hero_wisp/wisp_guardian_.vpcf"
		if RollPercentage(50) then
			particle = "particles/econ/items/wisp/wisp_guardian_ti7.vpcf"
		end

		local nfx = ParticleManager:CreateParticle(particle, PATTACH_POINT, caster)
					ParticleManager:SetParticleControlEnt(nfx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
		self:AttachEffect(nfx)

		self.maxDistance = self:GetAbility():GetTrueCastRange()

		self.minDistance = self:GetAbility():GetSpecialValueFor("min_radius")

		self.currentDistance = self.minDistance

		self.direction = caster:GetForwardVector()
		
		self.speed = self:GetAbility():GetSpecialValueFor("spirit_movement_rate")

		self.angle = 360 / self:GetAbility():GetSpecialValueFor("max_wisps")

		self.point = caster:GetAbsOrigin() + self.direction * self.currentDistance --+ Vector(0, 0, 100)

		self.time = 360/self.speed/self:GetAbility():GetSpecialValueFor("max_wisps")

		self.distanceTick = self.speed/3 * FrameTime()

		self.hitUnits = {}

		self.elaspedTime = 0

		self.collisionDamage = self:GetAbility():GetSpecialValueFor("damage_collide")

		self.endDamage = self:GetAbility():GetSpecialValueFor("damage_end")

		self.collisionRadius = self:GetAbility():GetSpecialValueFor("hit_radius")

		self.endRadius = self:GetAbility():GetSpecialValueFor("explode_radius")

		-- if caster:HasTalent("special_bonus_unique_wisp_spirits_bh_1") then
		-- 	self.talentTime = caster:FindTalentValue("special_bonus_unique_wisp_spirits_bh_1", "tick_rate")
		-- 	self.talentElaspedTime = 0

		-- 	self.talentWidth = caster:FindTalentValue("special_bonus_unique_wisp_spirits_bh_1", "width")
		-- 	self.talentDamage = self.endDamage * caster:FindTalentValue("special_bonus_unique_wisp_spirits_bh_1", "damage")/100
		-- end

		self:StartIntervalThink(FrameTime())
	end
end

function modifier_wisp_spirits_bh_wisp:OnIntervalThink()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local parent = self:GetParent()

	local qAngle = QAngle(0, self.angle, 0)
	local casterPos = caster:GetAbsOrigin()

	local newSpawn = RotatePosition(casterPos, qAngle, self.point)

	parent:SetAbsOrigin(newSpawn)

	if self:GetAbility():GetToggleState() then
		if self.currentDistance > self.minDistance then
			self.currentDistance = self.currentDistance - self.distanceTick
		end
	else
		if self.currentDistance < self.maxDistance then
			self.currentDistance = self.currentDistance + self.distanceTick
		end
	end

	self.point = casterPos + self.direction * self.currentDistance

	self.angle = self.angle - self.speed * FrameTime()

	local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(),self:GetParent():GetOrigin(),nil,self.collisionRadius,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_NONE,0,false)
	for _,enemy in pairs(enemies) do
		if not self.hitUnits[enemy:entindex()] and enemy:IsMinion() then

			EmitSoundOn("Hero_Wisp.Spirits.TargetCreep", parent)
			if not enemy:TriggerSpellAbsorb( self:GetAbility() ) then
				if RollPercentage(50) then
					local nfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_guardian_explosion_small.vpcf", PATTACH_POINT_FOLLOW, parent)
								 ParticleManager:SetParticleControlEnt(nfx2, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
								 ParticleManager:ReleaseParticleIndex(nfx2)
				else
					local nfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_guardian_explosion_small.vpcf", PATTACH_POINT, caster)
								 ParticleManager:SetParticleControlEnt(nfx2, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
								 ParticleManager:ReleaseParticleIndex(nfx2)
				end

				damage_type = DAMAGE_TYPE_PHYSICAL
				damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
				if self:GetCaster():FindAbilityByName("npc_dota_hero_wisp_int11") then
					damage_type = DAMAGE_TYPE_MAGICAL
        			damage_flags = DOTA_DAMAGE_FLAG_NONE
				end
				damage = self.collisionDamage
				if self:GetCaster():FindAbilityByName("npc_dota_hero_wisp_int_last") then
					damage = damage + self:GetCaster():GetIntellect() * 0.5
				end
				if self:GetCaster():FindAbilityByName("npc_dota_hero_wisp_agi6") then
					damage = damage + self:GetCaster():GetBaseDamageMax()
				end
				if enemy:IsAlive() and not enemy:IsBuilding() then
					ApplyDamage({
						victim = enemy,
						attacker = caster,
						damage = damage,
						damage_type = damage_type,
						damage_flags = damage_flags,
						ability = self:GetAbility(),
					})
				end
			end
			self.hitUnits[enemy:entindex()] = true
		else
			parent:ForceKill(false)
			return
		end
	end

	if self.elaspedTime < self.time then
		self.elaspedTime = self.elaspedTime + FrameTime()
	else
		self.hitUnits = {}
		self.elaspedTime = 0
	end

	if self.talentTime then
		if self.talentElaspedTime < self.talentTime then
			self.talentElaspedTime = self.talentElaspedTime + FrameTime()
		else
			local nfx = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_POINT, caster)
						ParticleManager:SetParticleControlEnt(nfx, 0, caster, PATTACH_POINT, "attach_hitloc", caster:GetAbsOrigin(), true)
						ParticleManager:SetParticleControlEnt(nfx, 1, parent, PATTACH_POINT, "attach_hitloc", parent:GetAbsOrigin(), true)
						ParticleManager:ReleaseParticleIndex(nfx)

			local enemies = caster:FindEnemyUnitsInLine(parent:GetAbsOrigin(), caster:GetAbsOrigin(), self.talentWidth, {})
			for _,enemy in pairs(enemies) do
				self:GetAbility():DealDamage(caster, enemy, self.talentDamage, {}, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE)
			end

			self.talentElaspedTime = 0
		end
	end
end

function modifier_wisp_spirits_bh_wisp:OnRemoved()
	if IsServer() then
		local caster = self:GetCaster()
		local parent = self:GetParent()

		EmitSoundOn("Hero_Wisp.Spirits.Target", parent)

		if RollPercentage(50) then
			local nfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_guardian_explosion.vpcf", PATTACH_POINT_FOLLOW, parent)
						 ParticleManager:SetParticleControlEnt(nfx2, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
						 ParticleManager:ReleaseParticleIndex(nfx2)
		else
			local nfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_guardian_explosion.vpcf", PATTACH_POINT, caster)
					 	 ParticleManager:SetParticleControlEnt(nfx2, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
					 	 ParticleManager:ReleaseParticleIndex(nfx2)
		end

		local slow = self:GetAbility():GetSpecialValueFor("slow_duration")
        local enemies = FindUnitsInRadius( caster:GetTeam(), parent:GetAbsOrigin(), nil, self.endRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,enemy in pairs(enemies) do
			if not enemy:TriggerSpellAbsorb( self:GetAbility() ) then
				if enemy:IsAlive() then
					enemy:Paralyze(self:GetAbility(), caster, slow)
					damage_type = DAMAGE_TYPE_PHYSICAL
					damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
					if self:GetCaster():FindAbilityByName("npc_dota_hero_wisp_int11") then
						damage_type = DAMAGE_TYPE_MAGICAL
						damage_flags = DOTA_DAMAGE_FLAG_NONE
					end
					damage = self.endDamage 
					if self:GetCaster():FindAbilityByName("npc_dota_hero_wisp_int_last") then
						damage = damage + self:GetCaster():GetIntellect() * 0.5
					end
					if self:GetCaster():FindAbilityByName("npc_dota_hero_wisp_agi6") then
						damage = damage + self:GetCaster():GetBaseDamageMax()
					end
					if not enemy:IsBuilding() then
						ApplyDamage({
							victim = enemy,
							attacker = caster,
							damage = damage,
							damage_type = damage_type,
							damage_flags = damage_flags,
							ability = self:GetAbility()
						})
					end
				end
			end
		end
		if caster:HasModifier("modifier_wisp_spirits_bh") then
			local modifier = caster:FindModifierByName("modifier_wisp_spirits_bh")
			modifier.wispCount = modifier.wispCount + 1
		end
	end
end

function modifier_wisp_spirits_bh_wisp:CheckState()
	return {[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
			[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
			[MODIFIER_STATE_UNSELECTABLE] = true,
			[MODIFIER_STATE_UNTARGETABLE] = true,
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
			[MODIFIER_STATE_INVULNERABLE] = true}
end

modifier_wisp_spirits_bh_talent = class({})
function modifier_wisp_spirits_bh_talent:OnCreated(table)
	-- self.bonus_sr = self:GetCaster():FindTalentValue("special_bonus_unique_wisp_spirits_bh_2")
end

-- function modifier_wisp_spirits_bh_talent:DeclareFunctions()
-- 	local funcs = {MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING}
-- 	return funcs
-- end

-- function modifier_wisp_spirits_bh_talent:GetModifierStatusResistanceStacking()
-- 	return self.bonus_sr
-- end

-- function modifier_wisp_spirits_bh_talent:GetEffectName()
-- 	return "particles/econ/items/wisp/wisp_ambient_ti7_trace.vpcf"
-- end

-- function modifier_wisp_spirits_bh_talent:IsDebuff()
-- 	return false
-- end