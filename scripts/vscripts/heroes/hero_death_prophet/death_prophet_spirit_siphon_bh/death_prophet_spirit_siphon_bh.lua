death_prophet_spirit_siphon_bh = class({})

function death_prophet_spirit_siphon_bh:IsStealable()
	return true
end
function death_prophet_spirit_siphon_bh:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end
function death_prophet_spirit_siphon_bh:IsHiddenWhenStolen()
	return false
end

function death_prophet_spirit_siphon_bh:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end

function death_prophet_spirit_siphon_bh:AbilityCharges()
	return self:GetSpecialValueFor("max_charges")
end

-- function death_prophet_spirit_siphon_bh:GetIntrinsicModifierName()
-- 	return "modifier_death_prophet_spirit_siphon_bh_charges"
-- end

function death_prophet_spirit_siphon_bh:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local duration = self:GetSpecialValueFor("haunt_duration")
	caster:EmitSound("Hero_DeathProphet.SpiritSiphon.Cast")
	if target:TriggerSpellAbsorb(self) then return end
	target:AddNewModifier(caster, self, "modifier_death_prophet_spirit_siphon_bh_debuff", {duration = duration})
	if caster:FindAbilityByName("npc_dota_hero_death_prophet_str8") then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			if enemy ~= target and not enemy:HasModifier("modifier_death_prophet_spirit_siphon_bh_debuff") then
				enemy:AddNewModifier(caster, self, "modifier_death_prophet_spirit_siphon_bh_debuff", {duration = duration})
				break
			end
		end
	end
end

modifier_death_prophet_spirit_siphon_bh_debuff = class({})
LinkLuaModifier( "modifier_death_prophet_spirit_siphon_bh_debuff", "heroes/hero_death_prophet/death_prophet_spirit_siphon_bh/death_prophet_spirit_siphon_bh", LUA_MODIFIER_MOTION_NONE )

function modifier_death_prophet_spirit_siphon_bh_debuff:OnCreated()
	self.ability = self:GetAbility()
	self.slow = math.abs( self.ability:GetSpecialValueFor("movement_slow") ) * (-1)
	if IsServer() then
		self.damage = self.ability:GetSpecialValueFor("base_damage")
		local caster = self:GetCaster()
		local parent = self:GetParent()
		local ability = self:GetAbility()
		if caster:FindAbilityByName("npc_dota_hero_death_prophet_str11") then
			self.damage = self.damage + caster:GetMaxHealth() * 0.03
		end
		if caster:FindAbilityByName("npc_dota_hero_death_prophet_int7") then
			self.damage = self.damage + caster:GetIntellect() * 0.5
		end
		self.range = self:GetAbility():GetTrueCastRange() + self.ability:GetSpecialValueFor("siphon_buffer")
		self.nFX = ParticleManager:CreateParticle("particles/units/heroes/hero_death_prophet/death_prophet_spiritsiphon.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControlEnt(self.nFX, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.nFX, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.nFX, 5, Vector(self:GetRemainingTime(), 0,0 ) )
		self:GetParent():EmitSound("Hero_DeathProphet.SpiritSiphon.Target")
		self:StartIntervalThink( 0.2 )
	end
end

function modifier_death_prophet_spirit_siphon_bh_debuff:OnRefresh()
	self.slow = math.abs( self.ability:GetSpecialValueFor("movement_slow") ) * (-1)
	if IsServer() then
		self.damage = self.ability:GetSpecialValueFor("base_damage")
		local caster = self:GetCaster()
		local parent = self:GetParent()
		local ability = self:GetAbility()
		if caster:FindAbilityByName("npc_dota_hero_death_prophet_str11") then
			self.damage = self.damage + caster:GetMaxHealth() * 0.03
		end
		self.range = self:GetAbility():GetTrueCastRange() + self.ability:GetSpecialValueFor("siphon_buffer")
		self:StartIntervalThink( 0.2 )
	end
end


function modifier_death_prophet_spirit_siphon_bh_debuff:OnIntervalThink()
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local ability = self:GetAbility()
	local heal = ability:DealDamage( caster, parent, self.damage * 0.2, {} )
	-- caster:HealEvent( heal, ability, caster)
	if CalculateDistance( caster, parent ) > self.range then
		self:Destroy()
	end
end

function modifier_death_prophet_spirit_siphon_bh_debuff:OnDestroy()
	if IsServer() then
		self:GetParent():StopSound("Hero_DeathProphet.SpiritSiphon.Target")
		ParticleManager:ClearParticle(self.nFX)
	end
end

function modifier_death_prophet_spirit_siphon_bh_debuff:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end

function modifier_death_prophet_spirit_siphon_bh_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end

modifier_death_prophet_spirit_siphon_bh_charges = class({})
LinkLuaModifier( "modifier_death_prophet_spirit_siphon_bh_charges", "heroes/hero_death_prophet/death_prophet_spirit_siphon_bh/death_prophet_spirit_siphon_bh", LUA_MODIFIER_MOTION_NONE )

if IsServer() then
	function modifier_death_prophet_spirit_siphon_bh_charges:OnCreated()
		self.ability = self:GetAbility()
		kv = {
			max_count = math.floor( self.ability:GetSpecialValueFor("max_charges") ),
			replenish_time = self.ability:GetSpecialValueFor("charge_restore_time"),
			start_count = math.floor( self.ability:GetSpecialValueFor("max_charges") )
		}
        self:SetStackCount(kv.start_count or kv.max_count)
        self.kv = kv
	
        if kv.start_count and kv.start_count ~= kv.max_count then
            self:Update()
		else
			self:SetDuration(-1, true)
        end
    end

    function modifier_death_prophet_spirit_siphon_bh_charges:Update()
		local caster = self:GetCaster()
		self.kv.replenish_time = self.ability:GetSpecialValueFor("charge_restore_time")
		self.kv.max_count = math.floor( self.ability:GetSpecialValueFor("max_charges") )
		if self:GetStackCount() == self.kv.max_count then
			self:SetDuration(-1, true)
		elseif self:GetStackCount() > self.kv.max_count then
			self:SetDuration(-1, true)
			self:SetStackCount(self.kv.max_count)
		elseif self:GetStackCount() < self.kv.max_count then
			if self:GetRemainingTime() <= -1 then
				local duration = self.kv.replenish_time * caster:GetCooldownReduction() 
				self:SetDuration(duration, true)
			end
			self:StartIntervalThink(self:GetRemainingTime())
			if self:GetStackCount() == 0 then
				self:GetAbility():StartCooldown(self:GetRemainingTime())
			end
		end
    end
	
	function modifier_death_prophet_spirit_siphon_bh_charges:OnRefresh()
		self.kv.max_count = math.floor( self.ability:GetSpecialValueFor("max_charges") )
		self.kv.replenish_time = self.ability:GetSpecialValueFor("charge_restore_time")
        if self:GetStackCount() ~= self.kv.max_count then
			self:IncrementStackCount()
            self:Update()
        end
    end
	
    function modifier_death_prophet_spirit_siphon_bh_charges:DeclareFunctions()
        local funcs = {
            MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
        }

        return funcs
    end

    function modifier_death_prophet_spirit_siphon_bh_charges:OnAbilityFullyCast(params)
        if params.unit == self:GetParent() then
			self.kv.replenish_time = self.ability:GetSpecialValueFor("charge_restore_time")
			self.kv.max_count = math.floor( self.ability:GetSpecialValueFor("max_charges") )
			
            local ability = params.ability
            if params.ability == self:GetAbility() then
                self:DecrementStackCount()
				ability:EndCooldown()
                self:Update()
			elseif string.find( params.ability:GetName(), "orb_of_renewal" ) and self:GetStackCount() < self.kv.max_count then
                self:IncrementStackCount()
                self:Update()
            end
        end

        return 0
    end

    function modifier_death_prophet_spirit_siphon_bh_charges:OnIntervalThink()
        local stacks = self:GetStackCount()
		local caster = self:GetCaster()
		
		self:StartIntervalThink(-1)
		
		local duration = self.kv.replenish_time * caster:GetCooldownReduction() 
		self:SetDuration(duration, true)
        if stacks < self.kv.max_count then
            self:IncrementStackCount()
			self:Update()
		elseif stacks == self.kv.max_count then
			self:SetDuration( -1, true )
        end
    end
end

function modifier_death_prophet_spirit_siphon_bh_charges:DestroyOnExpire()
    return false
end

function modifier_death_prophet_spirit_siphon_bh_charges:IsPurgable()
    return false
end

function modifier_death_prophet_spirit_siphon_bh_charges:RemoveOnDeath()
    return false
end