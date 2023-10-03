item_monkey_king_bar_lua = class({})

LinkLuaModifier("modifier_item_monkey_king_bar_passive", 'items/custom_items/item_monkey_king_bar_lua.lua', LUA_MODIFIER_MOTION_NONE)

function item_monkey_king_bar_lua:GetIntrinsicModifierName()
	return "modifier_item_monkey_king_bar_passive"
end

--------------------------------------------------------------------------------

modifier_item_monkey_king_bar_passive = class({})

function modifier_item_monkey_king_bar_passive:IsHidden()
	return true
end

function modifier_item_monkey_king_bar_passive:IsPurgable()
	return false
end

function modifier_item_monkey_king_bar_passive:DestroyOnExpire()
	return false
end

function modifier_item_monkey_king_bar_passive:RemoveOnDeath()	
	return false 
end

function modifier_item_monkey_king_bar_passive:GetAttributes()	
	return MODIFIER_ATTRIBUTE_MULTIPLE 
end


function modifier_item_monkey_king_bar_passive:OnCreated()
	self.pierce_proc 			= false
	self.pierce_records			= {}
	self.parent = self:GetParent()
	if not IsServer() then
		return
	end
	self.value = self:GetAbility():GetSpecialValueFor("bonus_gem")
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {value = self.value})
	end
end

function modifier_item_monkey_king_bar_passive:OnDestroy()
	if not IsServer() then
		return
	end
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {value = self.value * -1})
	end
end

function modifier_item_monkey_king_bar_passive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
		MODIFIER_EVENT_ON_ATTACK_RECORD
	}
end

function modifier_item_monkey_king_bar_passive:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_item_monkey_king_bar_passive:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

function modifier_item_monkey_king_bar_passive:GetModifierProcAttack_BonusDamage_Magical(keys)
	for _, record in pairs(self.pierce_records) do	
		if record == keys.record then
			table.remove(self.pierce_records, _)

			if not self:GetParent():IsIllusion() and not keys.target:IsBuilding() then
				self:GetParent():EmitSound("DOTA_Item.MKB.proc")
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, keys.target, self:GetAbility():GetSpecialValueFor("bonus_chance_damage"), nil)
				
				return self:GetAbility():GetSpecialValueFor("bonus_chance_damage")
			end
		end
	end
end

function modifier_item_monkey_king_bar_passive:OnAttackRecord(keys)
	if keys.attacker == self:GetParent() then
		if self.pierce_proc then
			table.insert(self.pierce_records, keys.record)
			self.pierce_proc = false
		end
	
		if (not keys.target:IsMagicImmune() or self:GetName() == "modifier_item_monkey_king_bar_passive") and RollPseudoRandom(self:GetAbility():GetSpecialValueFor("bonus_chance"), self) then
			self.pierce_proc = true
		end
	end
end


function modifier_item_monkey_king_bar_passive:CheckState()
	local state = {}
	
	if self.pierce_proc then
		state = {[MODIFIER_STATE_CANNOT_MISS] = true}
	end

	return state
end


 function RollPseudoRandom(base_chance, entity)
 local ran = RandomInt(1,100)
 if base_chance >= ran then return true
 else return false
 end
 end