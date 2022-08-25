LinkLuaModifier("modifier_boss_8_chrono", "abilities/bosses/line/boss_8/boss_8_chrono", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_boss_8_chrono_debuff", "abilities/bosses/line/boss_8/boss_8_chrono", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_boss_8_chrono_move", "abilities/bosses/line/boss_8/boss_8_chrono", LUA_MODIFIER_MOTION_NONE)

boss_8_chrono = class({})

function boss_8_chrono:OnSpellStart()
if not IsServer() then return end
	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
	if #enemies > 0 then
		for _, enemy in pairs( enemies ) do
			local point = enemy:GetAbsOrigin()
			CreateModifierThinker(self:GetCaster(), self, "modifier_boss_8_chrono", {duration = self:GetSpecialValueFor("duration")}, point, self:GetCaster():GetTeamNumber(), false)
			EmitSoundOn("Hero_FacelessVoid.Chronosphere", self:GetCaster())
			position = enemies[RandomInt(1,#enemies)]:GetAbsOrigin()
		end	
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_boss_8_chrono_move", {
			duration	= math.min((position - self:GetCaster():GetAbsOrigin()):Length2D(), 1500) / 2800,
			x			= position.x,
			y 			= position.y,
			z			= position.z
		})	
	end	
end

-----------------------------------
modifier_boss_8_chrono = class({})

function modifier_boss_8_chrono:IsHidden() return true end
function modifier_boss_8_chrono:IsDebuff() return false end
function modifier_boss_8_chrono:IsPurgable() return false end
function modifier_boss_8_chrono:IsAura() return true end
function modifier_boss_8_chrono:IsAuraActiveOnDeath() return false end

function modifier_boss_8_chrono:GetAuraEntityReject(hEntity)
    if IsServer() then
    end
end
function modifier_boss_8_chrono:GetAuraRadius()
    return 300
end
function modifier_boss_8_chrono:GetAuraSearchFlags()
    return self:GetAbility():GetAbilityTargetFlags()
end
function modifier_boss_8_chrono:GetAuraSearchTeam()
    return self:GetAbility():GetAbilityTargetTeam()
end
function modifier_boss_8_chrono:GetAuraSearchType()
    return self:GetAbility():GetAbilityTargetType()
end
function modifier_boss_8_chrono:GetModifierAura()
    return "modifier_boss_8_chrono_debuff"
end
function modifier_boss_8_chrono:OnCreated()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	self.radius = 300
    
    if IsServer() then
        self.particle_time =    ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_chronosphere.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                ParticleManager:SetParticleControl(self.particle_time, 0, self.parent:GetAbsOrigin())
                                ParticleManager:SetParticleControl(self.particle_time, 1, Vector(self.radius, self.radius, self.radius))

        self:AddParticle(self.particle_time, false, false, -1, false, false)
    end
end

function modifier_boss_8_chrono:OnRefresh(table)
	self:OnCreated(table)
end

---------------------------------------------------------------------------------------------------------------------
modifier_boss_8_chrono_debuff = class({})
function modifier_boss_8_chrono_debuff:IsHidden() return true end
function modifier_boss_8_chrono_debuff:IsDebuff() return true end
function modifier_boss_8_chrono_debuff:IsPurgable() return true end
function modifier_boss_8_chrono_debuff:IsPurgeException() return true end
function modifier_boss_8_chrono_debuff:RemoveOnDeath() return true end
function modifier_boss_8_chrono_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
	}
	return state
end


-----------------------------------------------------------------------------------------------------

if modifier_boss_8_chrono_move == nil then modifier_boss_8_chrono_move = class({}) end
function modifier_boss_8_chrono_move:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_boss_8_chrono_move:IsPurgable() return	false end
function modifier_boss_8_chrono_move:IsDebuff() return	false end
function modifier_boss_8_chrono_move:IsHidden() return	true end
function modifier_boss_8_chrono_move:IgnoreTenacity() return true end
function modifier_boss_8_chrono_move:IsMotionController() return true end
function modifier_boss_8_chrono_move:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_boss_8_chrono_move:GetEffectName()
	return "particles/units/heroes/hero_faceless_void/faceless_void_time_walk.vpcf" end

function modifier_boss_8_chrono_move:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW end

function modifier_boss_8_chrono_move:CheckState()
	return {
		[MODIFIER_STATE_STUNNED]			= true,
		[MODIFIER_STATE_INVULNERABLE]		= true,
		[MODIFIER_STATE_NO_UNIT_COLLISION]	= true
	}
end

function modifier_boss_8_chrono_move:OnCreated(params)
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()

		local position = GetGroundPosition(Vector(params.x, params.y, params.z), nil)
		local max_distance = 1500

		local distance = math.min((caster:GetAbsOrigin() - position):Length2D(), max_distance)

		self.velocity = 2800
		self.direction = (position - self:GetParent():GetAbsOrigin()):Normalized()
		self.distance_traveled = 0
		self.distance = distance
		
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_time_walk_preimage.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(particle, 1, self:GetParent():GetAbsOrigin() + self.direction * distance)
		ParticleManager:SetParticleControlEnt(particle, 2, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetForwardVector(), true)
		ParticleManager:ReleaseParticleIndex(particle)

		self.as_stolen = 0
		self.ms_stolen = 0
		
		self.frametime = FrameTime()
		self:OnIntervalThink()
		self:StartIntervalThink(self.frametime)
		
	end
end

function modifier_boss_8_chrono_move:OnIntervalThink()
	self:HorizontalMotion(self:GetParent(), self.frametime)
end	

function modifier_boss_8_chrono_move:HorizontalMotion( me, dt )
	if self.distance_traveled < self.distance then
		self:GetCaster():SetAbsOrigin(self:GetCaster():GetAbsOrigin() + (self.direction * math.min(self.velocity * dt, self.distance - self.distance_traveled)))
		self.distance_traveled = self.distance_traveled + math.min(self.velocity * dt, self.distance - self.distance_traveled)
	else
		self:Destroy()
	end
end