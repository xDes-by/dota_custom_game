LinkLuaModifier("modifier_bristleback_warpath_lua", "heroes/hero_bristleback/bristleback_warpath/bristleback_warpath.lua", LUA_MODIFIER_MOTION_NONE)

bristleback_warpath_lua = class({})
modifier_bristleback_warpath_lua = class({})

function bristleback_warpath_lua:GetIntrinsicModifierName()
	return "modifier_bristleback_warpath_lua"
end

function modifier_bristleback_warpath_lua:IsHidden()
	if self:GetStackCount() >= 1 then 
		return false
	else
		return true
	end
end

function modifier_bristleback_warpath_lua:DestroyOnExpire() return false end

function modifier_bristleback_warpath_lua:GetEffectName()
	if self:GetStackCount() >= 1 then 
		return "particles/units/heroes/hero_bristleback/bristleback_warpath_dust.vpcf"
	end
end

function modifier_bristleback_warpath_lua:OnCreated()
	self.caster = self:GetCaster()
	self.damage_per_stack = self:GetAbility():GetSpecialValueFor("damage_per_stack")
	self.move_speed_per_stack = self:GetAbility():GetSpecialValueFor("move_speed_per_stack")
	self.stack_duration = self:GetAbility():GetSpecialValueFor("stack_duration")
	self.max_stacks = self:GetAbility():GetSpecialValueFor("max_stacks")
	
	self.counter = self.counter or 0
	self.particle_table = self.particle_table or {}

	if self:GetCaster():FindAbilityByName("npc_dota_hero_bristleback_agi_last") ~= nil then
		self.damage_per_stack = self.damage_per_stack * 10
		self.move_speed_per_stack = self.move_speed_per_stack * 10
	end

	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_bristleback_agi50") ~= nil then
		self.max_stacks = self.max_stacks + 10
		self.stack_duration = self.stack_duration * 2
	end

	if not IsServer() then return end
	
	-- Give the current Warpath charges to illusions (also pretty bootleg cause GetOwner() isn't working at all
	if self:GetParent():IsIllusion() then
		local owners = Entities:FindAllByNameWithin("npc_dota_hero_bristleback", self:GetParent():GetAbsOrigin(), 100)
		
		for _, owner in pairs(owners) do
			if not owner:IsIllusion() and owner:HasModifier("modifier_bristleback_warpath_lua") and owner:GetTeam() == self:GetParent():GetTeam() then
				self:SetStackCount(owner:FindModifierByName("modifier_bristleback_warpath_lua"):GetStackCount())
				self:SetDuration(self.stack_duration, true)
				
				Timers:CreateTimer(self.stack_duration, function()
					if self ~= nil and not self:IsNull() and not self:GetAbility():IsNull() and not self:GetParent():IsNull() and not self.caster:IsNull() and self:GetStackCount() > 0 then
						self:SetStackCount(0)
					end
				end)
				
				break
			end
		end
	end
end

function modifier_bristleback_warpath_lua:OnRefresh()
	self:OnCreated()
end

function modifier_bristleback_warpath_lua:DeclareFunctions()
    return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end


function modifier_bristleback_warpath_lua:OnAttackLanded( params )
	if IsServer() then
		if params.attacker == self:GetParent() and ( not self:GetParent():IsIllusion() ) then
			if self:GetParent():PassivesDisabled() then
				return 0
			end
			
			local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_bristleback_agi9")
			if abil ~= nil then 
			great_cleave_damage = self:GetStackCount()*10
				local target = params.target
				if target ~= nil and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
					local cleaveDamage = ( great_cleave_damage * params.damage ) / 100.0
						local particle_cast = 'particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf'
						
					DoCleaveAttack( self:GetParent(), target, self:GetAbility(), cleaveDamage, 150,360,300,"particles/units/heroes/hero_sven/sven_spell_great_cleave.vpcf" )
				end
			end
		end
	end
	return 0
end


function modifier_bristleback_warpath_lua:GetModifierPreAttack_BonusDamage(keys)
	if not self:GetParent():IsIllusion() then
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_bristleback_agi11")
	if abil ~= nil then 
	return self.damage_per_stack * self:GetStackCount() * 2
	end
	return self.damage_per_stack * self:GetStackCount()	
	end
end

function modifier_bristleback_warpath_lua:GetModifierMoveSpeedBonus_Constant(keys)
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_bristleback_agi11")
	if abil ~= nil then
	return self.move_speed_per_stack * self:GetStackCount() * 2
	end
	return self.move_speed_per_stack * self:GetStackCount()
end


function modifier_bristleback_warpath_lua:GetModifierPhysicalArmorBonus(keys)
local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_bristleback_str11")
	if abil ~= nil then 
	return self.move_speed_per_stack * self:GetStackCount()
	end
	return 0
end

-- Gonna ignore the mechanic that updates stacks for illusions too for now
function modifier_bristleback_warpath_lua:OnAbilityFullyCast(keys)
	if keys.ability and keys.unit == self:GetParent() and not self:GetParent():PassivesDisabled() and not keys.ability:IsItem() and keys.ability:GetName() ~= "ability_capture" then
		
		-- Keep a separate variable for "virtual" stacks so as to proper handle refreshing and decrementing when going past standard max stacks
		self.counter = self.counter + 1
		
		self:SetStackCount(math.min(self.counter, self.max_stacks))
		
		if self:GetStackCount() < self.max_stacks then
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_warpath.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
			ParticleManager:SetParticleControlEnt(particle, 3, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(particle, 4, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetAbsOrigin(), true)
			table.insert(self.particle_table, particle)
		end
		
		self:SetDuration(self.stack_duration, true)
		
		-- Stacks don't get refreshed with subsequent stacks
		Timers:CreateTimer(self.stack_duration, function()
			if self ~= nil and not self:IsNull() and not self:GetAbility():IsNull() and not self:GetParent():IsNull() and not self.caster:IsNull() and self:GetStackCount() > 0 then
				self.counter = self.counter - 1
				
				self:SetStackCount(math.min(self.counter, self.max_stacks))

				if #self.particle_table > 0 then
					ParticleManager:DestroyParticle(self.particle_table[1], false)
					ParticleManager:ReleaseParticleIndex(self.particle_table[1])
					table.remove(self.particle_table, 1)
				end
			end
		end)
	end
end

function modifier_bristleback_warpath_lua:GetModifierModelScale()
	return self:GetStackCount() * 5
end