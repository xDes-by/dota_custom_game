modifier_faceless_void_time_lock_lua = class({})
function modifier_faceless_void_time_lock_lua:IsHidden() return true end
function modifier_faceless_void_time_lock_lua:IsPurgable() return false end


function modifier_faceless_void_time_lock_lua:OnCreated()
	local ability = self:GetAbility()
	ability.effect_last_proc_time = 0
end


function modifier_faceless_void_time_lock_lua:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
	}
end


function modifier_faceless_void_time_lock_lua:GetModifierProcAttack_BonusDamage_Magical( keys )
	if not IsServer() then return end

	-- Ability properties
	local caster = self:GetParent()
	local ability = self:GetAbility()
	local attacker = keys.attacker
	local target = keys.target

	-- If the target is a building, do nothing
	if target:IsBuilding() then return nil end
	-- If passives are disabled, do nothing
	if attacker:PassivesDisabled() then return nil end

	if RollPercentage(ability:GetSpecialValueFor("chance_pct")) then
		self:MakeBash(target)
	end

	if caster.bIsMakingTimeLock then
		return ability:GetSpecialValueFor("bonus_damage") + caster:FindTalentValue("special_bonus_unique_faceless_void_3")
	end
end

function modifier_faceless_void_time_lock_lua:MakeBash(target)
	local ability = self:GetAbility()
	local modifier_timelock = target:FindModifierByNameAndCaster("modifier_faceless_void_time_lock_lua_stun", caster)
	
	if modifier_timelock then
		modifier_timelock:ForceRefresh()
	else
		target:AddNewModifier(self:GetParent(), ability, "modifier_faceless_void_time_lock_lua_stun", {
			duration = ability:GetSpecialValueFor("duration") * (1 - target:GetStatusResistance())
		})
	end
end

-- Bash stun modifier
LinkLuaModifier("modifier_faceless_void_time_lock_lua_stun", "heroes/hero_faceless_void/modifier_faceless_void_time_lock_lua", LUA_MODIFIER_MOTION_NONE)
modifier_faceless_void_time_lock_lua_stun = class({})

function modifier_faceless_void_time_lock_lua_stun:GetTexture() return "faceless_void_time_lock" end
function modifier_faceless_void_time_lock_lua_stun:IsDebuff() return true end
function modifier_faceless_void_time_lock_lua_stun:IsPurgable() return false end
function modifier_faceless_void_time_lock_lua_stun:IsPurgeException() return true end
function modifier_faceless_void_time_lock_lua_stun:IsStunDebuff() return true end
function modifier_faceless_void_time_lock_lua_stun:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_faceless_void_time_lock_lua_stun:CheckState()
	return {
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_FROZEN] = true
    }
end

function modifier_faceless_void_time_lock_lua_stun:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_faceless_void_time_lock_lua_stun:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_faceless_void_time_lock_lua_stun:OnCreated()
    if IsClient() then return end
	self:GetParent():SetRenderColor(128,128,255)
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_faceless_void_time_lock_lua_attack", {duration = 0.33})
end

function modifier_faceless_void_time_lock_lua_stun:OnRefresh()
	self:OnCreated()
end

function modifier_faceless_void_time_lock_lua_stun:OnDestroy()
    if IsServer() then self:GetParent():SetRenderColor(255,255,255) end 
end


-- Bash stun attack
LinkLuaModifier("modifier_faceless_void_time_lock_lua_attack", "heroes/hero_faceless_void/modifier_faceless_void_time_lock_lua", LUA_MODIFIER_MOTION_NONE)
modifier_faceless_void_time_lock_lua_attack = class({})
function modifier_faceless_void_time_lock_lua_attack:IsHidden() return true end
function modifier_faceless_void_time_lock_lua_attack:IsDebuff() return true end
function modifier_faceless_void_time_lock_lua_attack:IsPurgable() return false end
function modifier_faceless_void_time_lock_lua_attack:IsPurgeException() return false end
function modifier_faceless_void_time_lock_lua_attack:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end


function modifier_faceless_void_time_lock_lua_attack:OnCreated()
	if IsClient() then return end

	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	local origin = self.parent:GetAbsOrigin()

	local current_time = GetSystemTimeMS()
	if current_time - self.ability.effect_last_proc_time > 200 then
		self.ability.effect_last_proc_time = current_time

		self.parent:EmitSound("Hero_FacelessVoid.TimeLockImpact")

		local bash_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_time_lock_bash.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(bash_particle, 0, origin)
		ParticleManager:SetParticleControl(bash_particle, 1, origin)
		ParticleManager:SetParticleControlEnt(bash_particle, 2, self:GetCaster(), PATTACH_CUSTOMORIGIN, "attach_hitloc", origin, true)
		
		ParticleManager:ReleaseParticleIndex(bash_particle)

		local backtrack_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_backtrack02.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
		ParticleManager:ReleaseParticleIndex(backtrack_particle)
	end
end


function modifier_faceless_void_time_lock_lua_attack:OnRemoved()
	if IsClient() then return end
	local caster = self:GetCaster()
	local parent = self:GetParent()

	if not IsValidEntity(caster) or not IsValidEntity(parent) or not parent:IsAlive() then return end

	caster.bIsMakingTimeLock = true
	caster:PerformAttack(parent, false, true, true, true, false, false, true)
	caster.bIsMakingTimeLock = false
end
