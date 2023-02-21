modifier_shadow_fiend_necromastery_lua = class({})

--------------------------------------------------------------------------------

function modifier_shadow_fiend_necromastery_lua:IsHidden()
	return false
end

function modifier_shadow_fiend_necromastery_lua:IsDebuff()
	return false
end

function modifier_shadow_fiend_necromastery_lua:IsPurgable()
	return false
end

function modifier_shadow_fiend_necromastery_lua:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_shadow_fiend_necromastery_lua:OnCreated( kv )
	self.soul_release = self:GetAbility():GetSpecialValueFor("soul_release")
	self.soul_damage = self:GetAbility():GetSpecialValueFor("soul_damage")

	if IsServer() then
		self:SetStackCount(0)
	end
end

function modifier_shadow_fiend_necromastery_lua:OnRefresh( kv )

	self.soul_release = self:GetAbility():GetSpecialValueFor("soul_release")
	self.soul_damage = self:GetAbility():GetSpecialValueFor("soul_damage")
end

--------------------------------------------------------------------------------

function modifier_shadow_fiend_necromastery_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS		
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_shadow_fiend_necromastery_lua:OnAttackLanded( params )
	local caster = self:GetCaster()
	local target = params.target
	if params.attacker~=self:GetParent() then return end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_nevermore_agi_last") ~= nil and RandomInt(1, 100) <= 2 and params.attacker:FindAbilityByName("shadow_fiend_requiem_of_souls_lua") ~= nil then
		if params.attacker:FindAbilityByName("shadow_fiend_requiem_of_souls_lua"):IsTrained() then
			params.attacker:FindAbilityByName("shadow_fiend_requiem_of_souls_lua"):OnSpellStart()
		end
	end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_nevermore_agi9") ~= nil then 
		if caster:HasAbility("shadow_fiend_shadowraze_a_lua") and not caster:IsIllusion() then

			local trigger_ability1 = caster:FindAbilityByName("shadow_fiend_shadowraze_a_lua")
			local trigger_ability2 = caster:FindAbilityByName("shadow_fiend_shadowraze_b_lua")
			local trigger_ability3 = caster:FindAbilityByName("shadow_fiend_shadowraze_c_lua")
			
			local distance = (caster:GetAbsOrigin() - target:GetAbsOrigin()):Length2D()
			if distance < 200 then
				if trigger_ability1:IsOwnersManaEnough() then
					--	caster:SetCursorTargetingNothing(true)
					if trigger_ability1:GetLevel() > 0  then
						trigger_ability1:OnSpellStart()
						trigger_ability1:UseResources(true, false, false)
					end
				end
			end
			
			if distance >= 200 and distance < 450 then
				if trigger_ability1:IsOwnersManaEnough() then
					--	caster:SetCursorTargetingNothing(true)
					if trigger_ability2:GetLevel() > 0  then
						trigger_ability2:OnSpellStart()
						trigger_ability2:UseResources(true, false, false)
					end
				end
			end
			
			if distance > 450 then
				if trigger_ability1:IsOwnersManaEnough() then
					--    caster:SetCursorTargetingNothing(true)
					if trigger_ability3:GetLevel() > 0  then
						trigger_ability3:OnSpellStart()
						trigger_ability3:UseResources(true, false, false)
					end	
				end
			end
		end
	end
end

function modifier_shadow_fiend_necromastery_lua:OnDeath( params )
	if IsServer() then
		self:DeathLogic( params )
		self:KillLogic( params )
	end
end

function modifier_shadow_fiend_necromastery_lua:GetModifierPreAttack_BonusDamage( params )
	if not self:GetParent():IsIllusion() then
		if self:GetCaster():FindAbilityByName("npc_dota_hero_nevermore_agi10") ~= nil then 
			return self:GetStackCount() * (self.soul_damage * 2)
		end
		return self:GetStackCount() * self.soul_damage
	end
end


function modifier_shadow_fiend_necromastery_lua:GetModifierConstantHealthRegen( params )
	if not self:GetParent():IsIllusion() then
		if self:GetCaster():FindAbilityByName("npc_dota_hero_nevermore_str9") ~= nil then 
		return self:GetStackCount() / 2
		end
		return 0
	end
end

function modifier_shadow_fiend_necromastery_lua:GetModifierPhysicalArmorBonus(params)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_nevermore_str7") ~= nil then 
		return math.floor(self:GetStackCount()/15)
	end
	return 0
end

function modifier_shadow_fiend_necromastery_lua:GetModifierHealthBonus(params)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_nevermore_str6") ~= nil then 
		return self:GetStackCount()*10
	end
	return 0
end

--------------------------------------------------------------------------------
function modifier_shadow_fiend_necromastery_lua:DeathLogic( params )
	local caster = self:GetCaster()
	local unit = params.unit
	local pass = false
	if unit==self:GetParent() and params.reincarnate==false then
		pass = true
	end

	-- logic
	if pass then
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_nevermore_agi11")             
	if abil ~= nil then 
	 
	self.soul_release = self.soul_release + 0.10001
		if self.soul_release > 1 then 
		self.soul_release = 1
		end
	 end
		local after_death = math.floor(self:GetStackCount() * self.soul_release)
		self:SetStackCount(math.max(after_death,1))
	end
end

function modifier_shadow_fiend_necromastery_lua:KillLogic( params )
	local target = params.unit
	local attacker = params.attacker
	local pass = false
	if attacker==self:GetParent() and target~=self:GetParent() and attacker:IsAlive() then
		if (not target:IsIllusion()) and (not target:IsBuilding()) then
			pass = true
		end
	end

	if pass and (not self:GetParent():PassivesDisabled()) then
		self:AddStack(1)
	end
end

function modifier_shadow_fiend_necromastery_lua:AddStack( value )
	local current = self:GetStackCount()
	local after = current + value

	self:SetStackCount( after )
end

function modifier_shadow_fiend_necromastery_lua:PlayEffects( target )
	-- Get Resources
	local projectile_name = "particles/units/heroes/hero_nevermore/nevermore_necro_souls.vpcf"

	-- CreateProjectile
	local info = {
		Target = self:GetParent(),
		Source = target,
		EffectName = projectile_name,
		iMoveSpeed = 400,
		vSourceLoc= target:GetAbsOrigin(),                -- Optional
		bDodgeable = false,                                -- Optional
		bReplaceExisting = false,                         -- Optional
		flExpireTime = GameRules:GetGameTime() + 5,      -- Optional but recommended
		bProvidesVision = false,                           -- Optional
	}
	ProjectileManager:CreateTrackingProjectile(info)
end