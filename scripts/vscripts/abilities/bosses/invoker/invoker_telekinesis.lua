LinkLuaModifier("modifier_invoker_telekinesis", "abilities/bosses/invoker/invoker_telekinesis", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_invoker_telekinesis_stun", "abilities/bosses/invoker/invoker_telekinesis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invoker_telekinesis_root", "abilities/bosses/invoker/invoker_telekinesis", LUA_MODIFIER_MOTION_NONE)

invoker_telekinesis = class({})
function invoker_telekinesis:IsHiddenWhenStolen() return false end
function invoker_telekinesis:IsRefreshable() return true end
function invoker_telekinesis:IsStealable() return true end
function invoker_telekinesis:IsNetherWardStealable() return true end
-------------------------------------------

function invoker_telekinesis:OnSpellStart( params )
	local caster = self:GetCaster()

	self.target = self:GetCursorTarget()
	self.target_origin = self.target:GetAbsOrigin()
	
	if self.target:TriggerSpellAbsorb(self) then
		return nil
	end

	local duration = self:GetSpecialValueFor("duration")

	self.target:AddNewModifier(caster, self, "modifier_invoker_telekinesis_root", { duration = 3})
	self.target_modifier = self.target:AddNewModifier(caster, self, "modifier_invoker_telekinesis", { duration = 3 })

	self.target_modifier.tele_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_rubick/rubick_telekinesis.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(self.target_modifier.tele_pfx, 0, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(self.target_modifier.tele_pfx, 1, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(self.target_modifier.tele_pfx, 2, Vector(3,0,0))
	self.target_modifier:AddParticle(self.target_modifier.tele_pfx, false, false, 1, false, false)
	caster:EmitSound("Hero_Rubick.Telekinesis.Cast")
	self.target:EmitSound("Hero_Rubick.Telekinesis.Target")

	self.target_modifier.final_loc = self.target_origin
	self.target_modifier.changed_target = false
end

-------------------------------------------

modifier_invoker_telekinesis = class({})
function modifier_invoker_telekinesis:IsHidden() return false end
function modifier_invoker_telekinesis:IsPurgable() return false end
function modifier_invoker_telekinesis:IsPurgeException() return false end
function modifier_invoker_telekinesis:IsStunDebuff() return false end
function modifier_invoker_telekinesis:IgnoreTenacity() return true end
function modifier_invoker_telekinesis:IsMotionController() return true end
function modifier_invoker_telekinesis:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_invoker_telekinesis:OnCreated( params )
	if IsServer() then
		if self:GetParent():GetUnitName() == 'npc_invoker_boss' then self:Destroy() return nil end
	
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		self.parent = self:GetParent()
		self.z_height = 0
		self.duration = params.duration
		self.lift_animation = ability:GetSpecialValueFor("lift_animation")
		self.fall_animation = ability:GetSpecialValueFor("fall_animation")
		self.current_time = 0

		self.frametime = FrameTime()
		self:StartIntervalThink(FrameTime())
		
		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_sunray.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(self.pfx, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		StartSoundEvent( "Hero_Phoenix.SunRay.Beam", caster )
	end	
end

function modifier_invoker_telekinesis:OnIntervalThink()
	if IsServer() then
		-- if not self:CheckMotionControllers() then
			-- self:Destroy()
			-- return nil
		-- end

		self:VerticalMotion(self.parent, self.frametime)
		self:HorizontalMotion(self.parent, self.frametime)
	end
end

function SetUnitOnClearGround(self)
	Timers:CreateTimer(FrameTime(), function()
		self:SetAbsOrigin(Vector(self:GetAbsOrigin().x, self:GetAbsOrigin().y, GetGroundPosition(self:GetAbsOrigin(), self).z))		
		FindClearSpaceForUnit(self, self:GetAbsOrigin(), true)
		ResolveNPCPositions(self:GetAbsOrigin(), 64)
	end)
end



function modifier_invoker_telekinesis:EndTransition()
	if IsServer() then
		if self.transition_end_commenced then
			return nil
		end

		self.transition_end_commenced = true

		local caster = self:GetCaster()
		local parent = self:GetParent()
		local ability = self:GetAbility()

		SetUnitOnClearGround(parent)

		parent:RemoveModifierByName("modifier_invoker_telekinesis_stun")
		parent:RemoveModifierByName("modifier_invoker_telekinesis_root")

		local parent_pos = parent:GetAbsOrigin()

		local ability = self:GetAbility()


		parent:StopSound("Hero_Rubick.Telekinesis.Target")
		parent:EmitSound("Hero_Rubick.Telekinesis.Target.Land")
		ParticleManager:ReleaseParticleIndex(self.tele_pfx)

		local landing_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_rubick/rubick_telekinesis_land.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl(landing_pfx, 0, parent_pos)
		ParticleManager:SetParticleControl(landing_pfx, 1, parent_pos)
		ParticleManager:ReleaseParticleIndex(landing_pfx)


		parent:EmitSound("Hero_Rubick.Telekinesis.Target.Stun")

	end
end

function modifier_invoker_telekinesis:VerticalMotion(unit, dt)
	if IsServer() then
		self.current_time = self.current_time + dt

		local max_height = self:GetAbility():GetSpecialValueFor("max_height")
		if self.current_time <= self.lift_animation  then
			self.z_height = self.z_height + ((dt / self.lift_animation) * max_height)
			unit:SetAbsOrigin(GetGroundPosition(unit:GetAbsOrigin(), unit) + Vector(0,0,self.z_height))
		elseif self.current_time > (self.duration - self.fall_animation) then
			self.z_height = self.z_height - ((dt / self.fall_animation) * max_height)
			if self.z_height < 0 then self.z_height = 0 end
			unit:SetAbsOrigin(GetGroundPosition(unit:GetAbsOrigin(), unit) + Vector(0,0,self.z_height))
		else
			max_height = self.z_height
		end

		if self.current_time >= self.duration then
			self:EndTransition()
			self:Destroy()
		end
	end
end

function modifier_invoker_telekinesis:HorizontalMotion(unit, dt)
	if IsServer() then
		self.distance = self.distance or 0
		if (self.current_time > (self.duration - self.fall_animation)) then
			if self.changed_target then
				local frames_to_end = math.ceil((self.duration - self.current_time) / dt)
				self.distance = (unit:GetAbsOrigin() - self.final_loc):Length2D() / frames_to_end
				self.changed_target = false
			end
			if (self.current_time + dt) >= self.duration then
				unit:SetAbsOrigin(self.final_loc)
				self:EndTransition()
			else
				unit:SetAbsOrigin( unit:GetAbsOrigin() + ((self.final_loc - unit:GetAbsOrigin()):Normalized() * self.distance))
			end
		end
	end
end

function modifier_invoker_telekinesis:GetTexture()
	return "rubick_telekinesis"
end

function modifier_invoker_telekinesis:OnDestroy()
	if IsServer() then
		if self.parent and not self.parent:IsAlive() then
			SetUnitOnClearGround(self.parent)
		end
	end
	if self.pfx then
	ParticleManager:DestroyParticle( self.pfx, false )
	end
	StopSoundEvent( "Hero_Phoenix.SunRay.Beam", self:GetCaster() )
end

-------------------------------------------
modifier_invoker_telekinesis_stun = class({})
function modifier_invoker_telekinesis_stun:IsDebuff() return true end
function modifier_invoker_telekinesis_stun:IsHidden() return true end
function modifier_invoker_telekinesis_stun:IsPurgable() return false end
function modifier_invoker_telekinesis_stun:IsPurgeException() return false end
function modifier_invoker_telekinesis_stun:IsStunDebuff() return true end
function modifier_invoker_telekinesis_stun:OnCreated()
	if self:GetParent():GetUnitName() == 'npc_invoker_boss' then self:Destroy() return nil end
end

function modifier_invoker_telekinesis_stun:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		}
	return decFuns
end

function modifier_invoker_telekinesis_stun:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

function modifier_invoker_telekinesis_stun:CheckState()
	local state =
		{
			[MODIFIER_STATE_STUNNED] = true
		}
	return state
end


modifier_invoker_telekinesis_root = class({})
function modifier_invoker_telekinesis_root:IsDebuff() return false end
function modifier_invoker_telekinesis_root:IsHidden() return true end
function modifier_invoker_telekinesis_root:IsPurgable() return false end
function modifier_invoker_telekinesis_root:IsPurgeException() return false end
function modifier_invoker_telekinesis_root:OnCreated()
	if self:GetParent():GetUnitName() == 'npc_invoker_boss' then self:Destroy() return nil end
	self:StartIntervalThink(0.2)
end

function modifier_invoker_telekinesis_root:OnIntervalThink()
if IsServer() then
	ApplyDamage( {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self:GetParent():GetMaxHealth()/100*self:GetAbility():GetSpecialValueFor("damage"),
		damage_type	= DAMAGE_TYPE_PURE,
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
	} )
	end
end

function modifier_invoker_telekinesis_root:CheckState()
	local state =
		{
			[MODIFIER_STATE_ROOTED] = true,
			[MODIFIER_STATE_STUNNED] = true
		}
	return state
end