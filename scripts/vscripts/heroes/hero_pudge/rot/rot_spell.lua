pudge_rot_lua = class({})

LinkLuaModifier("pudge_rot_active_lua", "heroes/hero_pudge/rot/rot_spell.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rot_slow", "heroes/hero_pudge/rot/rot_spell.lua", LUA_MODIFIER_MOTION_NONE)

modifier_rot_slow = {}

function pudge_rot_lua:OnToggle()
	if self:GetToggleState() then
		EmitSoundOn("Hero_Pudge.Rot", self:GetCaster())
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "pudge_rot_active_lua", {})
	else
		StopSoundOn("Hero_Pudge.Rot", self:GetCaster())
		self:GetCaster():RemoveModifierByName("pudge_rot_active_lua")
	end
end

function pudge_rot_lua:GetCastRange(location, target)
	local rad = self:GetSpecialValueFor("base_radius")
	if self:GetCaster():FindAbilityByName("npc_dota_hero_pudge_str7") ~= nil then
		rad = rad + 100
	end
	return rad
end

pudge_rot_active_lua = class({})

function pudge_rot_active_lua:IsDebuff()			
	return false 
end

function pudge_rot_active_lua:IsHidden() 			
	return false 
end

function pudge_rot_active_lua:IsPurgable() 			
	return false 
end

function pudge_rot_active_lua:IsPurgeException() 	
	return false 
end

function pudge_rot_active_lua:IsAura() 
	return true 
end

function pudge_rot_active_lua:GetModifierAura() 
	return "modifier_rot_slow" 
end

function pudge_rot_active_lua:GetAuraRadius()
	local rad = self:GetAbility():GetSpecialValueFor("base_radius")
	if self:GetCaster():FindAbilityByName("npc_dota_hero_pudge_str7") ~= nil then
		rad = rad + 100
	end
	return rad
end

function pudge_rot_active_lua:GetAuraSearchFlags() 
	return DOTA_UNIT_TARGET_FLAG_NONE 
end

function pudge_rot_active_lua:GetAuraSearchTeam() 
	return DOTA_UNIT_TARGET_TEAM_ENEMY 
end

function pudge_rot_active_lua:GetAuraSearchType() 
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function pudge_rot_active_lua:OnCreated()
	if IsServer() then
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_pudge/pudge_rot.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(pfx, 1, Vector(self:GetAuraRadius(), 0, 0))
		self:AddParticle(pfx, false, false, 15, false, false)
		
	
	self.atribute = self:GetCaster():GetStrength()
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_pudge_int7") ~= nil then
		self.atribute = self:GetCaster():GetIntellect()
	end
	
	self.dmg = (self:GetAbility():GetSpecialValueFor("base_damage") + self.atribute * self:GetAbility():GetSpecialValueFor("damage_per_str"))/5

	if self:GetCaster():FindAbilityByName("npc_dota_hero_pudge_str8") ~= nil then
		self.dmg = (self:GetAbility():GetSpecialValueFor("base_damage") * 2 + self.atribute * self:GetAbility():GetSpecialValueFor("damage_per_str"))/5
	end
		if self:GetCaster():FindAbilityByName("npc_dota_hero_pudge_str10") ~= nil then
			self.dmg = (self:GetAbility():GetSpecialValueFor("base_damage") + self.atribute * (self:GetAbility():GetSpecialValueFor("damage_per_str")+0.2))/5
		end
	end
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_pudge_int9") == nil then
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("rot_tick"))
	end	
end

function pudge_rot_active_lua:OnIntervalThink()
	local damageTable = {
						victim = self:GetParent(),
						attacker = self:GetParent(),
						damage = self.dmg,
						damage_type = DAMAGE_TYPE_MAGICAL,
						-- damage_flags = DOTA_DAMAGE_FLAG_HPLOSS, 
						ability = self:GetAbility(), 
						}
	if IsServer() then
		ApplyDamage(damageTable)
	end	
end

function pudge_rot_active_lua:OnDestroy()
	if IsServer() then
		if self:GetAbility():GetToggleState() then
			self:GetAbility():ToggleAbility()
		end
	end
end

modifier_rot_slow = class({})

function modifier_rot_slow:IsDebuff()			
	return true 
end

function modifier_rot_slow:IsHidden() 			
	return false 
end

function modifier_rot_slow:IsPurgable() 		
	return false 
end

function modifier_rot_slow:IsPurgeException() 	
	return false 
end

function modifier_rot_slow:OnCreated()
	if IsServer() then
	
	self.atribute = self:GetCaster():GetStrength()
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_pudge_int7") ~= nil then
		self.atribute = self:GetCaster():GetIntellect()
	end
	
	self.dmg = (self:GetAbility():GetSpecialValueFor("base_damage") + self.atribute * self:GetAbility():GetSpecialValueFor("damage_per_str"))/5
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_pudge_str8") ~= nil then
		self.dmg = (self:GetAbility():GetSpecialValueFor("base_damage")*2 + self.atribute * self:GetAbility():GetSpecialValueFor("damage_per_str"))/5
	end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_pudge_str10") ~= nil then	
		self.dmg = (self:GetAbility():GetSpecialValueFor("base_damage") + self.atribute * (self:GetAbility():GetSpecialValueFor("damage_per_str")+0.2))/5
	end
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("rot_tick"))
	end
end

function modifier_rot_slow:OnIntervalThink()
	local damageTable = {
						victim = self:GetParent(),
						attacker = self:GetCaster(),
						damage = self.dmg,
						damage_type = self:GetAbility():GetAbilityDamageType(),
						damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
						ability = self:GetAbility(), --Optional.
						}
	ApplyDamage(damageTable)
end

function modifier_rot_slow:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    }
    return decFuncs
end

function modifier_rot_slow:GetModifierMagicalResistanceBonus()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_pudge_int8") ~= nil then
		return -15
	end
	return 0
end