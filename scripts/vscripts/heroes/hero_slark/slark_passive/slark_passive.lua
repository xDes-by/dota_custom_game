slark_passive = class({})
LinkLuaModifier( "modifier_slark_passive", "heroes/hero_slark/slark_passive/slark_passive", LUA_MODIFIER_MOTION_NONE )

function slark_passive:GetIntrinsicModifierName()
	return "modifier_slark_passive"
end

modifier_slark_passive = class({})

--------------------------------------------------------------------------------

function modifier_slark_passive:IsHidden()
	return false
end

function modifier_slark_passive:IsDebuff()
	return false
end

function modifier_slark_passive:IsPurgable()
	return false
end

function modifier_slark_passive:RemoveOnDeath()
	return true
end

--------------------------------------------------------------------------------

function modifier_slark_passive:OnCreated( kv )
	self.bonus_agi = self:GetAbility():GetSpecialValueFor("bonus_agi")
	self.chance = self:GetAbility():GetSpecialValueFor("chance")
	self.lose = self:GetAbility():GetSpecialValueFor("lose")
	if not IsServer() then
		return
	end
	self.special_bonus_unique_npc_dota_hero_slark_agi50 = self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_slark_agi50")
	self:SetStackCount(0)
end

function modifier_slark_passive:OnRefresh( kv )
	self.bonus_agi = self:GetAbility():GetSpecialValueFor("bonus_agi")
	self.chance = self:GetAbility():GetSpecialValueFor("chance")
	self.lose = self:GetAbility():GetSpecialValueFor("lose")
	if not IsServer() then
		return
	end
	self.special_bonus_unique_npc_dota_hero_slark_agi50 = self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_slark_agi50")
end

--------------------------------------------------------------------------------

function modifier_slark_passive:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
end


function modifier_slark_passive:OnDeath( params )
	if IsServer() then
		local caster = self:GetCaster()
		local unit = params.unit
		local pass = false
		if unit==self:GetParent() and params.reincarnate==false then
			pass = true
		end
		if pass then
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_slark_agi10")
		if abil ~= nil	then 
		self.lose = 1
		end
			local after_death = math.floor(self:GetStackCount()*self.lose)
			self:SetStackCount(math.max(after_death,1))
		end
	end
end

--------------------------------------------------------------------------------

function modifier_slark_passive:OnAttackLanded( params )
	if params.attacker~=self:GetParent() then return end
	if self:GetParent():PassivesDisabled() then return end
	if params.target:IsBuilding() or params.target:GetUnitName() == "npc_dota_hero_target_dummy" then return end
	
	self.chance = self:GetAbility():GetSpecialValueFor("chance")

	if self:GetCaster():FindAbilityByName("npc_dota_hero_slark_agi6") ~= nil then 
		self.chance = 25
	end
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_slark_agi_last") ~= nil then
		self.chance = self.chance + 30
	end

	if self:GetCaster() == params.attacker and self:GetCaster():FindAbilityByName("npc_dota_hero_slark_int_last") ~= nil and RandomInt(1, 100) <= 10 and self:GetCaster():FindAbilityByName("slark_dark_pact_lua"):IsTrained() then
		_G.slarkdelay = 0
		self:GetCaster():FindAbilityByName("slark_dark_pact_lua"):OnSpellStart()
	end

	if RandomInt(1,100) < self.chance then
		local pass = false
			if params.attacker == self:GetParent() and params.target ~= self:GetParent() and params.attacker:IsAlive() then		
			self:AddStack(1)
		end
	end
end


function modifier_slark_passive:GetModifierBonusStats_Agility( params )
	bonus =  1
	if self:GetCaster():FindAbilityByName("npc_dota_hero_slark_str_last") ~= nil then
		bonus =  2
	end
	if not self:GetParent():IsIllusion() then
		return self:GetStackCount() * self.bonus_agi * bonus
	end
end


function modifier_slark_passive:GetModifierBonusStats_Intellect( params )
	bonus = 0
	if not self:GetParent():IsIllusion() then
		if self:GetCaster():FindAbilityByName("npc_dota_hero_slark_str_last") ~= nil then
			bonus =  self:GetStackCount() * self.bonus_agi
		end
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_slark_int11")
		if abil ~= nil	then 
			bonus = bonus + self:GetStackCount() * self.bonus_agi / 2
		end
	end
	return bonus 
end

function modifier_slark_passive:GetModifierBonusStats_Strength( params )
	if self:GetCaster():FindAbilityByName("npc_dota_hero_slark_str_last") ~= nil then
		bonus =  self:GetStackCount() * self.bonus_agi
	end
		if not self:GetParent():IsIllusion() then
			local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_slark_str9")
			if abil ~= nil	then 
				bonus = bonus + self:GetStackCount() * self.bonus_agi / 2
			end
		end
	return bonus 
end

function modifier_slark_passive:GetModifierConstantHealthRegen( params )
	if not self:GetParent():IsIllusion() then
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_slark_str8")
		if abil ~= nil	then 
		return self:GetStackCount() /2
		end
		return 0 
	end
end

function modifier_slark_passive:GetModifierConstantManaRegen( params )
	if not self:GetParent():IsIllusion() then
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_slark_int7")
		if abil ~= nil	then 
		return self:GetStackCount() /2
		end
		return 0 
	end
end

function modifier_slark_passive:GetModifierPhysicalArmorBonus( params )
	if not self:GetParent():IsIllusion() then
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_slark_str11")
		if abil ~= nil	then 
		return self:GetStackCount() /15
		end
		return 0 
	end
end

function modifier_slark_passive:GetModifierPreAttack_BonusDamage()
	if self.special_bonus_unique_npc_dota_hero_slark_agi50 then
		return self:GetStackCount() * 3
	end
end

function modifier_slark_passive:AddStack( value )
	local current = self:GetStackCount()
	local after = current + value

	self:SetStackCount( after )
end