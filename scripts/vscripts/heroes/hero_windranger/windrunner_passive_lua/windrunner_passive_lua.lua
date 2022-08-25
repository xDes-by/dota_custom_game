windrunner_passive_lua = class({})
LinkLuaModifier( "modifier_windrunner_passive_lua", "heroes/hero_windranger/windrunner_passive_lua/windrunner_passive_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function windrunner_passive_lua:GetIntrinsicModifierName()
	return "modifier_windrunner_passive_lua"
end

--------------------------------------------------------------------------------

modifier_windrunner_passive_lua = class({})

function modifier_windrunner_passive_lua:IsHidden()
	if self:GetStackCount() >= 1 then 
		return false
	else
		return true
	end
end

function modifier_windrunner_passive_lua:IsDebuff( kv )
	return false
end

function modifier_windrunner_passive_lua:IsPurgable( kv )
	return false
end

--------------------------------------------------------------------------------

function modifier_windrunner_passive_lua:OnCreated( kv )
	self:SetStackCount(0)
	self.stack_multiplier = self:GetAbility():GetSpecialValueFor("attack_speed")
	self.max_stacks = self:GetAbility():GetSpecialValueFor("max_stacks")
	self.currentTarget = {}
end

function modifier_windrunner_passive_lua:OnRefresh( kv )
	self.stack_multiplier = self:GetAbility():GetSpecialValueFor("attack_speed")
	self.max_stacks = self:GetAbility():GetSpecialValueFor("max_stacks")
end

--------------------------------------------------------------------------------

function modifier_windrunner_passive_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_windrunner_passive_lua:OnAttackLanded( params )	
	self.triger = 0
local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_windrunner_agi10")             
	if abil ~= nil then
		self.triger = 25
		local ra = RandomInt(1,100)
			if self:GetCaster():FindAbilityByName("npc_dota_hero_windrunner_agi_last") ~= nil then
				self.triger  = self.triger + 35
			end
			if ra <= self.triger then		
			local attacker = params.attacker
			local target = params.target
			if params.attacker==self:GetParent() then

				local ability = attacker:FindAbilityByName("windrunner_powershot_lua")
				if ability:GetLevel() > 0 and not attacker:IsIllusion()  then
		 
					local mana = ability:GetManaCost()
					if attacker:GetMana() >= mana then
					--	ability:GiveMana(mana)
						local position  = target:GetAbsOrigin()
				   --   ability:SetCursorPosition(position)
						ability:OnSpellStart()
						ability:SetChanneling(true)
						ability:EndChannel(true)
						ability:UseResources(true, false, false)
					end
				end
			end
		end
	end
end

function modifier_windrunner_passive_lua:OnAttack( params )
	if IsServer() then
		-- filter
		pass = false
		if params.attacker==self:GetParent() then
			pass = true
		end

		-- logic
		if pass then
			if self.currentTarget==params.target then
				self:AddStack()
			else
				self:ResetStack()
				self.currentTarget = params.target
			end
		end
	end
	
---------------------------------------------------------------------------------------------------------------------------	
---------------------------------------------------------------------------------------------------------------------------
local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_windrunner_agi9")             
	if abil ~= nil then 
		if self:GetCaster():HasModifier("modifier_chek") then
			if keys.attacker == self:GetParent() and keys.target and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and not keys.no_attack_cooldown and not self:GetParent():PassivesDisabled() and self:GetAbility():IsTrained() then	
				local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetParent():Script_GetAttackRange() + 100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
				local target_number = 0
				for _, enemy in pairs(enemies) do
					if enemy ~= keys.target then
			
						self:GetParent():PerformAttack(enemy, false, true, true, true, true, false, false)

						target_number = target_number + 1
						
						if target_number >= 2 then
							break
						end
					end
				end
			end
		end
	end
end

function modifier_windrunner_passive_lua:GetModifierAttackSpeedBonus_Constant( params )
	local passive = 1
	if self:GetParent():PassivesDisabled() then
		passive = 0
	end
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_windrunner_agi6")             
	if abil ~= nil then 
	return self:GetStackCount() * self.stack_multiplier * passive * 2
	end
	return self:GetStackCount() * self.stack_multiplier * passive
end

function modifier_windrunner_passive_lua:AddStack()
	if not self:GetParent():PassivesDisabled() then
		if self:GetStackCount() < self.max_stacks then
			self:IncrementStackCount()
		end
	end
end

function modifier_windrunner_passive_lua:ResetStack()
	if not self:GetParent():PassivesDisabled() then
		self:SetStackCount(0)
	end
end