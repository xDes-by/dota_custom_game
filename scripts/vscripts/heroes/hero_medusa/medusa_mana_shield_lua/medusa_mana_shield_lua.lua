medusa_mana_shield_lua							= class({})
modifier_medusa_mana_shield_lua					= class({})
LinkLuaModifier("modifier_medusa_mana_shield_lua", "heroes/hero_medusa/medusa_mana_shield_lua/medusa_mana_shield_lua", LUA_MODIFIER_MOTION_NONE)

function medusa_mana_shield_lua:GetIntrinsicModifierName()
	return "modifier_medusa_mana_shield_lua_meditate"
end

function medusa_mana_shield_lua:ProcsMagicStick() return false end

function medusa_mana_shield_lua:OnOwnerSpawned()
	if self.toggle_state then
		self:ToggleAbility()
	end
end

function medusa_mana_shield_lua:OnOwnerDied()
	self.toggle_state = self:GetToggleState()
end

function medusa_mana_shield_lua:OnToggle()
	if not IsServer() then return end
	
	if self:GetToggleState() then
		self:GetCaster():EmitSound("Hero_Medusa.ManaShield.On")
		
		if self:GetCaster():GetName() == "npc_dota_hero_medusa" and RollPercentage(20) then
			if not self.responses then
				self.responses = 
				{
					["medusa_medus_manashield_02"] = 0,
					["medusa_medus_manashield_03"] = 0,
					["medusa_medus_manashield_04"] = 0,
					["medusa_medus_manashield_06"] = 0
				}
			end
			
			for response, timer in pairs(self.responses) do
				if GameRules:GetDOTATime(true, true) - timer >= 20 then
					self:GetCaster():EmitSound(response)
					self.responses[response] = GameRules:GetDOTATime(true, true)
					break
				end
			end
		end
	
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_medusa_mana_shield_lua", {})
	else
		self:GetCaster():EmitSound("Hero_Medusa.ManaShield.Off")
	
		self:GetCaster():RemoveModifierByNameAndCaster("modifier_medusa_mana_shield_lua", self:GetCaster())
	end
	
end


function modifier_medusa_mana_shield_lua:GetEffectName()
	return "particles/units/heroes/hero_medusa/medusa_mana_shield.vpcf"
end

function modifier_medusa_mana_shield_lua:IsPurgable() 		return false end
function modifier_medusa_mana_shield_lua:RemoveOnDeath()	return false end

function modifier_medusa_mana_shield_lua:OnCreated()
	self.damage_per_mana					= self:GetAbility():GetSpecialValueFor("damage_per_mana")
	self.absorption_tooltip					= self:GetAbility():GetSpecialValueFor("absorption_tooltip")
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_medusa_str11")
	if abil ~= nil then 
	self.damage_per_mana = self.damage_per_mana * 2
	end	

	if not IsServer() then return end

	self.mana_raw = self:GetParent():GetMana()
	self.mana_pct = self:GetParent():GetManaPercent()
	self:StartIntervalThink(1)
end


function modifier_medusa_mana_shield_lua:OnRefresh( kv )
	self.damage_per_mana					= self:GetAbility():GetSpecialValueFor("damage_per_mana")
	self.absorption_tooltip					= self:GetAbility():GetSpecialValueFor("absorption_tooltip")
	
	if not IsServer() then return end

	self.mana_raw = self:GetParent():GetMana()
	self.mana_pct = self:GetParent():GetManaPercent()
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_medusa_str11")
	if abil ~= nil then 
	self.damage_per_mana = self.damage_per_mana * 2
	end	
	local abil = self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_medusa_str50")
	if abil ~= nil then 
	self.damage_per_mana = self.damage_per_mana * 5
	end	
end

function modifier_medusa_mana_shield_lua:OnIntervalThink()
self:OnRefresh()
end

function modifier_medusa_mana_shield_lua:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
    return decFuncs
end

function modifier_medusa_mana_shield_lua:GetModifierIncomingDamage_Percentage(keys)
    if not IsServer() then return end
    
    if not (keys.damage_type == DAMAGE_TYPE_MAGICAL and self:GetParent():IsMagicImmune()) then
    
        local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_medusa_str9")
        if abil ~= nil then 
            self.absorption_tooltip = 80
        end 
        local taken = keys.original_damage
		if self:GetCaster():FindAbilityByName("npc_dota_hero_medusa_str_last") ~= nil then
			local magic_resistance = self:GetCaster():GetBaseMagicalResistanceValue()
			local armor = self:GetCaster():GetPhysicalArmorValue(false)
			local damage_reduction = 1 - (1 / (1 + (0.06 * armor)))

			if keys.damage_type == DAMAGE_TYPE_PHYSICAL then
				taken = keys.original_damage * (1 - damage_reduction)
			elseif keys.damage_type == DAMAGE_TYPE_MAGICAL then
				taken = keys.original_damage * (1 - magic_resistance / 100)
			end
		end
        local mana_to_block = taken * self.absorption_tooltip * 0.01 / self.damage_per_mana
        self:GetParent():EmitSound("Hero_Medusa.ManaShield.Proc")    
        local shield_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_medusa/medusa_mana_shield_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:ReleaseParticleIndex(shield_particle)
        if mana_to_block <= self:GetParent():GetMana() then
            if self:GetCaster():FindAbilityByName("npc_dota_hero_medusa_str7") == nil or RandomInt(1, 100) > 25  then
                self:GetParent():Script_ReduceMana(mana_to_block, nil)
            end
            return self.absorption_tooltip * -1
        else
            return 0
        end
    end
end
