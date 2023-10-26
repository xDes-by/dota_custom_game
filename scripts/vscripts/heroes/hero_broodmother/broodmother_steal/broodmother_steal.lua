LinkLuaModifier('modifier_broodmother_steal_debuff', "heroes/hero_broodmother/broodmother_steal/broodmother_steal", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_broodmother_steal_buff', "heroes/hero_broodmother/broodmother_steal/broodmother_steal", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_broodmother_steal', "heroes/hero_broodmother/broodmother_steal/broodmother_steal", LUA_MODIFIER_MOTION_NONE)

broodmother_steal = class({})

function broodmother_steal:GetIntrinsicModifierName() 
    return 'modifier_broodmother_steal'
end

--------------------------------------------------------

modifier_broodmother_steal = class({})

function modifier_broodmother_steal:IsHidden() return true end
function modifier_broodmother_steal:IsPurgable() return false end

function modifier_broodmother_steal:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}
	return funcs
end

function modifier_broodmother_steal:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		if params.attacker==self:GetParent() and not params.target:IsHero() then
			self.chance = self:GetAbility():GetSpecialValueFor("chance")
			-- if self:GetCaster():FindAbilityByName("npc_dota_hero_broodmother_agi10") then
			-- 	self.chance = self.chance + 50 
			-- end
			
			if RandomInt(1,100) <= self.chance then
				self:DebuffEnemy(params.target)
				self:BuffCaster()    
				self:GetCaster():EmitSound("Hero_Bane.BrainSap")
			end
		end
	end
end

function modifier_broodmother_steal:BuffCaster()
	local modifier_buff = "modifier_broodmother_steal_buff"
	local duration = self:GetAbility():GetSpecialValueFor("duration")
	if self:GetCaster():FindAbilityByName("npc_dota_hero_broodmother_int8") then
		duration = duration + 10
	end

	if not self:GetCaster():HasModifier(modifier_buff) then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), modifier_buff, {duration = duration})
	end
	
	local buff_modifier_handle = self:GetCaster():FindModifierByName(modifier_buff)
	if buff_modifier_handle then
		buff_modifier_handle:IncrementStackCount()
		buff_modifier_handle:ForceRefresh()
	end
end

function modifier_broodmother_steal:DebuffEnemy(enemy)
	if not enemy then return end
	local modifier_debuff = "modifier_broodmother_steal_debuff"
	local duration = self:GetAbility():GetSpecialValueFor("duration")
	if self:GetCaster():FindAbilityByName("npc_dota_hero_broodmother_int8") then
		duration = duration + 10
	end

	if not enemy:HasModifier(modifier_debuff) then
		enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), modifier_debuff , {duration = duration})
	end

	local debuff_modifier_handle = enemy:FindModifierByName(modifier_debuff)
	if debuff_modifier_handle then
		debuff_modifier_handle:IncrementStackCount()
		debuff_modifier_handle:ForceRefresh()
	end
end

---------------------------------------------------------------------------

modifier_broodmother_steal_debuff = class({})

function modifier_broodmother_steal_debuff:IsHidden() return false end
function modifier_broodmother_steal_debuff:IsPurgable() return false end
function modifier_broodmother_steal_debuff:IsDebuff() return true end

function modifier_broodmother_steal_debuff:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end
	self.hp_steal = self:GetAbility():GetSpecialValueFor("hp_steal")
	if self:GetCaster():FindAbilityByName("npc_dota_hero_broodmother_str8") then
		self.hp_steal = self.hp_steal + self:GetCaster():GetMaxHealth()*0.03
	end
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_broodmother_int50") then
		self.hp_steal = self.hp_steal + self:GetCaster():GetIntellect()
	end	
	
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
	if self:GetCaster():FindAbilityByName("npc_dota_hero_broodmother_int8") then
		self.duration = self.duration + 10
	end
	self.stack_table = {}

	if IsServer() then
		self:StartIntervalThink(1)
	end    
end

function modifier_broodmother_steal_debuff:OnIntervalThink()
	local repeat_needed = true
	while repeat_needed do
		local item_time = self.stack_table[1]
		if GameRules:GetGameTime() - item_time >= self.duration then
			if self:GetStackCount() == 1 then
				self:Destroy()
				break
			else
				table.remove(self.stack_table, 1)
				self:DecrementStackCount()
				SendOverheadEventMessage( self:GetCaster(), OVERHEAD_ALERT_HEAL , self:GetCaster(), self.hp_steal, nil )
				self:GetParent():Heal(self.hp_steal, self:GetParent())
			end
		else
			repeat_needed = false
		end
	end
end

function modifier_broodmother_steal_debuff:OnStackCountChanged(prev_stacks)
	if not IsServer() then return end
	local stacks = self:GetStackCount()
	if stacks > prev_stacks then
		table.insert(self.stack_table, GameRules:GetGameTime())
		
		local damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = self.hp_steal,
			damage_type = DAMAGE_TYPE_PURE,
			damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NON_LETHAL,
			ability = self:GetAbility()}

		ApplyDamage(damageTable)
		self:ForceRefresh()
	end
end

function modifier_broodmother_steal_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_DISABLE_HEALING,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
end

function modifier_broodmother_steal_debuff:GetModifierAttackSpeedBonus_Constant()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_broodmother_agi10") then
		speed = 20 + (60 / 15) * self:GetAbility():GetLevel()
		return -speed * self:GetStackCount()
	end
end

function modifier_broodmother_steal_debuff:OnTooltip()
    return self:GetStackCount() * self.hp_steal
end

function modifier_broodmother_steal_debuff:GetDisableHealing()
	-- if self:GetCaster():FindAbilityByName("npc_dota_hero_broodmother_agi7") then
	-- 	return 1
	-- end
end

---------------------------------------------------------------------------

modifier_broodmother_steal_buff = class({})

function modifier_broodmother_steal_buff:IsHidden() return false end
function modifier_broodmother_steal_buff:IsPurgable() return false end
function modifier_broodmother_steal_buff:IsDebuff() return false end

function modifier_broodmother_steal_buff:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end
	
	self.hp_steal = self:GetAbility():GetSpecialValueFor("hp_steal")
	if self:GetCaster():FindAbilityByName("npc_dota_hero_broodmother_str8") then
		self.hp_steal = self.hp_steal + self:GetCaster():GetMaxHealth()*0.03
	end
	
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
	if self:GetCaster():FindAbilityByName("npc_dota_hero_broodmother_int8") then
		self.duration = self.duration + 10
	end

	self.stack_table = {}

	if IsServer() then
		self:StartIntervalThink(1)
	end    
end

function modifier_broodmother_steal_buff:OnIntervalThink()
	local repeat_needed = true
	while repeat_needed do
		local item_time = self.stack_table[1]
		if GameRules:GetGameTime() - item_time >= self.duration then
			if self:GetStackCount() == 1 then
				self:Destroy()
				break
			else
				table.remove(self.stack_table, 1)
				self:DecrementStackCount()
				self:GetParent():CalculateStatBonus(true)
				self:GetParent():Heal(-self.hp_steal, nil)
			end
		else
			repeat_needed = false
		end
	end
end

function modifier_broodmother_steal_buff:OnStackCountChanged(prev_stacks)
	if not IsServer() then return end
	local stacks = self:GetStackCount()
	if stacks > prev_stacks then
		table.insert(self.stack_table, GameRules:GetGameTime()) 
		self:GetCaster():Heal(self.hp_steal, self:GetCaster())
		SendOverheadEventMessage( self:GetCaster(), OVERHEAD_ALERT_HEAL , self:GetCaster(), self.hp_steal, nil )
		self:ForceRefresh()
		self:GetParent():CalculateStatBonus(true)
	end
end

function modifier_broodmother_steal_buff:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		
    }
end

function modifier_broodmother_steal_buff:GetModifierAttackSpeedBonus_Constant()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_broodmother_agi10") then
		speed = 20 + (60 / 15) * self:GetAbility():GetLevel()
		return speed * self:GetStackCount()
	end
end

function modifier_broodmother_steal_buff:OnTooltip()
    return self:GetStackCount() * self.hp_steal
end

function modifier_broodmother_steal_buff:GetModifierExtraHealthBonus(params)
    return self:GetStackCount() * self.hp_steal
end

       
function modifier_broodmother_steal_buff:GetModifierPhysicalArmorBonus(params)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_broodmother_str11") then
		return self:GetStackCount()
	end
	return 0	
end

function modifier_broodmother_steal_buff:GetModifierMagicalResistanceBonus(params)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_broodmother_str11") then
		return self:GetStackCount()
	end
	return 0	
end