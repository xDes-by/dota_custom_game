item_vladmir_lua = class({})

item_vladmir_lua1 = item_vladmir_lua
item_vladmir_lua2 = item_vladmir_lua
item_vladmir_lua3 = item_vladmir_lua
item_vladmir_lua4 = item_vladmir_lua
item_vladmir_lua5 = item_vladmir_lua
item_vladmir_lua6 = item_vladmir_lua
item_vladmir_lua7 = item_vladmir_lua
item_vladmir_lua8 = item_vladmir_lua

item_vladmir_lua1_gem1 = item_vladmir_lua
item_vladmir_lua2_gem1 = item_vladmir_lua
item_vladmir_lua3_gem1 = item_vladmir_lua
item_vladmir_lua4_gem1 = item_vladmir_lua
item_vladmir_lua5_gem1 = item_vladmir_lua
item_vladmir_lua6_gem1 = item_vladmir_lua
item_vladmir_lua7_gem1 = item_vladmir_lua
item_vladmir_lua8_gem1 = item_vladmir_lua

item_vladmir_lua1_gem2 = item_vladmir_lua
item_vladmir_lua2_gem2 = item_vladmir_lua
item_vladmir_lua3_gem2 = item_vladmir_lua
item_vladmir_lua4_gem2 = item_vladmir_lua
item_vladmir_lua5_gem2 = item_vladmir_lua
item_vladmir_lua6_gem2 = item_vladmir_lua
item_vladmir_lua7_gem2 = item_vladmir_lua
item_vladmir_lua8_gem2 = item_vladmir_lua

item_vladmir_lua1_gem3 = item_vladmir_lua
item_vladmir_lua2_gem3 = item_vladmir_lua
item_vladmir_lua3_gem3 = item_vladmir_lua
item_vladmir_lua4_gem3 = item_vladmir_lua
item_vladmir_lua5_gem3 = item_vladmir_lua
item_vladmir_lua6_gem3 = item_vladmir_lua
item_vladmir_lua7_gem3 = item_vladmir_lua
item_vladmir_lua8_gem3 = item_vladmir_lua

item_vladmir_lua1_gem4 = item_vladmir_lua
item_vladmir_lua2_gem4 = item_vladmir_lua
item_vladmir_lua3_gem4 = item_vladmir_lua
item_vladmir_lua4_gem4 = item_vladmir_lua
item_vladmir_lua5_gem4 = item_vladmir_lua
item_vladmir_lua6_gem4 = item_vladmir_lua
item_vladmir_lua7_gem4 = item_vladmir_lua
item_vladmir_lua8_gem4 = item_vladmir_lua

item_vladmir_lua1_gem5 = item_vladmir_lua
item_vladmir_lua2_gem5 = item_vladmir_lua
item_vladmir_lua3_gem5 = item_vladmir_lua
item_vladmir_lua4_gem5 = item_vladmir_lua
item_vladmir_lua5_gem5 = item_vladmir_lua
item_vladmir_lua6_gem5 = item_vladmir_lua
item_vladmir_lua7_gem5 = item_vladmir_lua
item_vladmir_lua8_gem5 = item_vladmir_lua

LinkLuaModifier("modifier_item_vladmir_lua", 'items/custom_items/item_vladmir_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_vladmir_aura_lua", 'items/custom_items/item_vladmir_lua.lua', LUA_MODIFIER_MOTION_NONE)

modifier_item_vladmir_lua = class({})

function item_vladmir_lua:GetIntrinsicModifierName()
	return "modifier_item_vladmir_lua"
end

function modifier_item_vladmir_lua:IsHidden() return true end
function modifier_item_vladmir_lua:IsPurgable() return false end
function modifier_item_vladmir_lua:RemoveOnDeath() return false end

function modifier_item_vladmir_lua:OnCreated()
	self.armor_aura = self:GetAbility():GetSpecialValueFor("armor_aura")
	self.mana_regen_aura = self:GetAbility():GetSpecialValueFor("mana_regen_aura")
	self.lifesteal_aura = self:GetAbility():GetSpecialValueFor("lifesteal_aura")
	self.damage_aura = self:GetAbility():GetSpecialValueFor("damage_aura")
	self.aura_radius = self:GetAbility():GetSpecialValueFor("aura_radius")
end

function modifier_item_vladmir_lua:GetAuraRadius()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("aura_radius")
	end
end

function modifier_item_vladmir_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_item_vladmir_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_item_vladmir_lua:GetModifierAura()
	return "modifier_item_vladmir_aura_lua"
end

function modifier_item_vladmir_lua:IsAura()
	return true
end

------------------------------------------------------------------------------------------------

modifier_item_vladmir_aura_lua = class({})

function modifier_item_vladmir_aura_lua:IsHidden() 
	return false 
end

function modifier_item_vladmir_aura_lua:IsPurgable() 
	return false 
end

function modifier_item_vladmir_aura_lua:RemoveOnDeath() 
	return false 
end

function modifier_item_vladmir_aura_lua:IsAuraActiveOnDeath() 
	return false 
end

function modifier_item_vladmir_aura_lua:OnCreated()
	self.parent = self:GetParent()
	self.armor_aura = self:GetAbility():GetSpecialValueFor("armor_aura")
	self.mana_regen_aura = self:GetAbility():GetSpecialValueFor("mana_regen_aura")
	self.lifesteal_aura = self:GetAbility():GetSpecialValueFor("lifesteal_aura")
	self.damage_aura = self:GetAbility():GetSpecialValueFor("damage_aura")
	self.aura_radius = self:GetAbility():GetSpecialValueFor("aura_radius")
	if not IsServer() then
		return
	end
	self.value = self:GetAbility():GetSpecialValueFor("bonus_gem")
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {value = self.value})
	end
end

function modifier_item_vladmir_aura_lua:OnDestroy()
	if not IsServer() then
		return
	end
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {value = self.value * -1})
	end
end

function modifier_item_vladmir_aura_lua:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_UNIQUE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
	}
end

function modifier_item_vladmir_aura_lua:GetModifierBaseDamageOutgoing_Percentage()
	return self.damage_aura
end

function modifier_item_vladmir_aura_lua:GetModifierPhysicalArmorBonusUnique()
	return self.armor_aura 
end

function modifier_item_vladmir_aura_lua:GetModifierConstantManaRegen()
	return self.mana_regen_aura
end

function modifier_item_vladmir_aura_lua:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		local pass = false
		if params.target:GetTeamNumber()~=self:GetParent():GetTeamNumber() then
			if (not params.target:IsBuilding()) and (not params.target:IsOther()) then
				local heal = params.damage * self.lifesteal_aura/100
				self:GetParent():Heal( heal, self:GetAbility() )
				self:PlayEffects( self:GetParent() )
			end
		end
	end
end

function modifier_item_vladmir_aura_lua:PlayEffects( target )
	local particle_cast = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

