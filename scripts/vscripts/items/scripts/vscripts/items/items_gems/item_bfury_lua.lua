item_bfury_lua1_gem1 = item_bfury_lua1_gem1 or class({})
item_bfury_lua2_gem1 = item_bfury_lua1_gem1 or class({})
item_bfury_lua3_gem1 = item_bfury_lua1_gem1 or class({})
item_bfury_lua4_gem1 = item_bfury_lua1_gem1 or class({})
item_bfury_lua5_gem1 = item_bfury_lua1_gem1 or class({})
item_bfury_lua6_gem1 = item_bfury_lua1_gem1 or class({})
item_bfury_lua7_gem1 = item_bfury_lua1_gem1 or class({})

item_bfury_lua1_gem2 = item_bfury_lua1_gem2 or class({})
item_bfury_lua2_gem2 = item_bfury_lua1_gem2 or class({})
item_bfury_lua3_gem2 = item_bfury_lua1_gem2 or class({})
item_bfury_lua4_gem2 = item_bfury_lua1_gem2 or class({})
item_bfury_lua5_gem2 = item_bfury_lua1_gem2 or class({})
item_bfury_lua6_gem2 = item_bfury_lua1_gem2 or class({})
item_bfury_lua7_gem2 = item_bfury_lua1_gem2 or class({})

item_bfury_lua1_gem3 = item_bfury_lua1_gem3 or class({})
item_bfury_lua2_gem3 = item_bfury_lua1_gem3 or class({})
item_bfury_lua3_gem3 = item_bfury_lua1_gem3 or class({})
item_bfury_lua4_gem3 = item_bfury_lua1_gem3 or class({})
item_bfury_lua5_gem3 = item_bfury_lua1_gem3 or class({})
item_bfury_lua6_gem3 = item_bfury_lua1_gem3 or class({})
item_bfury_lua7_gem3 = item_bfury_lua1_gem3 or class({})

item_bfury_lua1_gem4 = item_bfury_lua1_gem4 or class({})
item_bfury_lua2_gem4 = item_bfury_lua1_gem4 or class({})
item_bfury_lua3_gem4 = item_bfury_lua1_gem4 or class({})
item_bfury_lua4_gem4 = item_bfury_lua1_gem4 or class({})
item_bfury_lua5_gem4 = item_bfury_lua1_gem4 or class({})
item_bfury_lua6_gem4 = item_bfury_lua1_gem4 or class({})
item_bfury_lua7_gem4 = item_bfury_lua1_gem4 or class({})

item_bfury_lua1_gem5 = item_bfury_lua1_gem5 or class({})
item_bfury_lua2_gem5 = item_bfury_lua1_gem5 or class({})
item_bfury_lua3_gem5 = item_bfury_lua1_gem5 or class({})
item_bfury_lua4_gem5 = item_bfury_lua1_gem5 or class({})
item_bfury_lua5_gem5 = item_bfury_lua1_gem5 or class({})
item_bfury_lua6_gem5 = item_bfury_lua1_gem5 or class({})
item_bfury_lua7_gem5 = item_bfury_lua1_gem5 or class({})

LinkLuaModifier("modifier_gem1", 'items/items_gems/gem1', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem2", 'items/items_gems/gem2', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem3", 'items/items_gems/gem3', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem4", 'items/items_gems/gem4', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem5", 'items/items_gems/gem5', LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_item_bfury_lua1", 'items/items_gems/item_bfury_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_bfury_lua2", 'items/items_gems/item_bfury_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_bfury_lua3", 'items/items_gems/item_bfury_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_bfury_lua4", 'items/items_gems/item_bfury_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_bfury_lua5", 'items/items_gems/item_bfury_lua.lua', LUA_MODIFIER_MOTION_NONE)

function item_bfury_lua1_gem1:GetIntrinsicModifierName()
	return "modifier_item_bfury_lua1"
end

function item_bfury_lua1_gem2:GetIntrinsicModifierName()
	return "modifier_item_bfury_lua2"
end

function item_bfury_lua1_gem3:GetIntrinsicModifierName()
	return "modifier_item_bfury_lua3"
end

function item_bfury_lua1_gem4:GetIntrinsicModifierName()
	return "modifier_item_bfury_lua4"
end

function item_bfury_lua1_gem5:GetIntrinsicModifierName()
	return "modifier_item_bfury_lua5"
end

function item_bfury_lua1_gem1:OnSpellStart()
	local caster = self:GetCaster()
	local target_point = self:GetCursorPosition()
	GridNav:DestroyTreesAroundPoint(target_point, 1, false)
end

function item_bfury_lua1_gem2:OnSpellStart()
	local caster = self:GetCaster()
	local target_point = self:GetCursorPosition()
	GridNav:DestroyTreesAroundPoint(target_point, 1, false)
end

function item_bfury_lua1_gem3:OnSpellStart()
	local caster = self:GetCaster()
	local target_point = self:GetCursorPosition()
	GridNav:DestroyTreesAroundPoint(target_point, 1, false)
end

function item_bfury_lua1_gem4:OnSpellStart()
	local caster = self:GetCaster()
	local target_point = self:GetCursorPosition()
	GridNav:DestroyTreesAroundPoint(target_point, 1, false)
end

function item_bfury_lua1_gem5:OnSpellStart()
	local caster = self:GetCaster()
	local target_point = self:GetCursorPosition()
	GridNav:DestroyTreesAroundPoint(target_point, 1, false)
end

modifier_item_bfury_lua1 = class({})

function modifier_item_bfury_lua1:IsHidden()
	return true
end

function modifier_item_bfury_lua1:IsPurgable()
	return false
end

function modifier_item_bfury_lua1:DestroyOnExpire()
	return false
end

function modifier_item_bfury_lua1:RemoveOnDeath()	
	return false 
end

function modifier_item_bfury_lua1:OnCreated()
	
	

	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_health_regen = self:GetAbility():GetSpecialValueFor("bonus_health_regen")
	self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
	self.cleave_damage_percent = self:GetAbility():GetSpecialValueFor("cleave_damage_percent")
	self.cleave_ending_width = self:GetAbility():GetSpecialValueFor("cleave_ending_width")
	self.quelling_bonus = self:GetAbility():GetSpecialValueFor("quelling_bonus")
	self.quelling_bonus_ranged = self:GetAbility():GetSpecialValueFor("quelling_bonus_ranged")
	
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_bfury_lua1:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_bfury_lua1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_item_bfury_lua1:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end

function modifier_item_bfury_lua1:GetModifierConstantHealthRegen()
	return self.bonus_health_regen
end

function modifier_item_bfury_lua1:GetModifierPreAttack_BonusDamage(keys)
	if keys.target and not keys.target:IsHero() and not keys.target:IsOther() and not keys.target:IsBuilding() and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
		if not self:GetParent():IsRangedAttacker() then
			return self.bonus_damage + self.quelling_bonus
		else
			return self.bonus_damage + self.quelling_bonus_ranged
		end
	else
		return self.bonus_damage
	end
end

function modifier_item_bfury_lua1:OnAttackLanded(keys)
    if not (
        IsServer()
        and self:GetParent() == keys.attacker
        and keys.attacker:GetTeam() ~= keys.target:GetTeam()
        and not keys.attacker:IsRangedAttacker()
    ) then return end
    
    local ability = self:GetAbility()
    local damage = keys.original_damage
    local damageMod = ability:GetSpecialValueFor( "cleave_damage_percent" )
    local radius = ability:GetSpecialValueFor( "cleave_distance" )
    local particle_cast = 'particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf'
    
    damageMod = damageMod * 0.01
    damage = damage * damageMod
    
    DoCleaveAttack(
        self:GetParent(),
        keys.target,
        ability,
        damage,
        150,
        360,
        radius,
        particle_cast
    )
end

modifier_item_bfury_lua2 = class({})

function modifier_item_bfury_lua2:IsHidden()
	return true
end

function modifier_item_bfury_lua2:IsPurgable()
	return false
end

function modifier_item_bfury_lua2:DestroyOnExpire()
	return false
end

function modifier_item_bfury_lua2:RemoveOnDeath()	
	return false 
end

function modifier_item_bfury_lua2:OnCreated()
	
	

	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_health_regen = self:GetAbility():GetSpecialValueFor("bonus_health_regen")
	self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
	self.cleave_damage_percent = self:GetAbility():GetSpecialValueFor("cleave_damage_percent")
	self.cleave_ending_width = self:GetAbility():GetSpecialValueFor("cleave_ending_width")
	self.quelling_bonus = self:GetAbility():GetSpecialValueFor("quelling_bonus")
	self.quelling_bonus_ranged = self:GetAbility():GetSpecialValueFor("quelling_bonus_ranged")
	
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_bfury_lua2:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_bfury_lua2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_item_bfury_lua2:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end

function modifier_item_bfury_lua2:GetModifierConstantHealthRegen()
	return self.bonus_health_regen
end

function modifier_item_bfury_lua2:GetModifierPreAttack_BonusDamage(keys)
	if keys.target and not keys.target:IsHero() and not keys.target:IsOther() and not keys.target:IsBuilding() and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
		if not self:GetParent():IsRangedAttacker() then
			return self.bonus_damage + self.quelling_bonus
		else
			return self.bonus_damage + self.quelling_bonus_ranged
		end
	else
		return self.bonus_damage
	end
end

function modifier_item_bfury_lua2:OnAttackLanded(keys)
    if not (
        IsServer()
        and self:GetParent() == keys.attacker
        and keys.attacker:GetTeam() ~= keys.target:GetTeam()
        and not keys.attacker:IsRangedAttacker()
    ) then return end
    
    local ability = self:GetAbility()
    local damage = keys.original_damage
    local damageMod = ability:GetSpecialValueFor( "cleave_damage_percent" )
    local radius = ability:GetSpecialValueFor( "cleave_distance" )
    local particle_cast = 'particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf'
    
    damageMod = damageMod * 0.01
    damage = damage * damageMod
    
    DoCleaveAttack(
        self:GetParent(),
        keys.target,
        ability,
        damage,
        150,
        360,
        radius,
        particle_cast
    )
end

modifier_item_bfury_lua3 = class({})

function modifier_item_bfury_lua3:IsHidden()
	return true
end

function modifier_item_bfury_lua3:IsPurgable()
	return false
end

function modifier_item_bfury_lua3:DestroyOnExpire()
	return false
end

function modifier_item_bfury_lua3:RemoveOnDeath()	
	return false 
end

function modifier_item_bfury_lua3:OnCreated()
	
	

	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_health_regen = self:GetAbility():GetSpecialValueFor("bonus_health_regen")
	self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
	self.cleave_damage_percent = self:GetAbility():GetSpecialValueFor("cleave_damage_percent")
	self.cleave_ending_width = self:GetAbility():GetSpecialValueFor("cleave_ending_width")
	self.quelling_bonus = self:GetAbility():GetSpecialValueFor("quelling_bonus")
	self.quelling_bonus_ranged = self:GetAbility():GetSpecialValueFor("quelling_bonus_ranged")
	
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_bfury_lua3:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_bfury_lua3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_item_bfury_lua3:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end

function modifier_item_bfury_lua3:GetModifierConstantHealthRegen()
	return self.bonus_health_regen
end

function modifier_item_bfury_lua3:GetModifierPreAttack_BonusDamage(keys)
	if keys.target and not keys.target:IsHero() and not keys.target:IsOther() and not keys.target:IsBuilding() and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
		if not self:GetParent():IsRangedAttacker() then
			return self.bonus_damage + self.quelling_bonus
		else
			return self.bonus_damage + self.quelling_bonus_ranged
		end
	else
		return self.bonus_damage
	end
end

function modifier_item_bfury_lua3:OnAttackLanded(keys)
    if not (
        IsServer()
        and self:GetParent() == keys.attacker
        and keys.attacker:GetTeam() ~= keys.target:GetTeam()
        and not keys.attacker:IsRangedAttacker()
    ) then return end
    
    local ability = self:GetAbility()
    local damage = keys.original_damage
    local damageMod = ability:GetSpecialValueFor( "cleave_damage_percent" )
    local radius = ability:GetSpecialValueFor( "cleave_distance" )
    local particle_cast = 'particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf'
    
    damageMod = damageMod * 0.01
    damage = damage * damageMod
    
    DoCleaveAttack(
        self:GetParent(),
        keys.target,
        ability,
        damage,
        150,
        360,
        radius,
        particle_cast
    )
end

modifier_item_bfury_lua4 = class({})

function modifier_item_bfury_lua4:IsHidden()
	return true
end

function modifier_item_bfury_lua4:IsPurgable()
	return false
end

function modifier_item_bfury_lua4:DestroyOnExpire()
	return false
end

function modifier_item_bfury_lua4:RemoveOnDeath()	
	return false 
end

function modifier_item_bfury_lua4:OnCreated()
	
	

	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_health_regen = self:GetAbility():GetSpecialValueFor("bonus_health_regen")
	self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
	self.cleave_damage_percent = self:GetAbility():GetSpecialValueFor("cleave_damage_percent")
	self.cleave_ending_width = self:GetAbility():GetSpecialValueFor("cleave_ending_width")
	self.quelling_bonus = self:GetAbility():GetSpecialValueFor("quelling_bonus")
	self.quelling_bonus_ranged = self:GetAbility():GetSpecialValueFor("quelling_bonus_ranged")
	
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_bfury_lua4:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_bfury_lua4:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_item_bfury_lua4:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end

function modifier_item_bfury_lua4:GetModifierConstantHealthRegen()
	return self.bonus_health_regen
end

function modifier_item_bfury_lua4:GetModifierPreAttack_BonusDamage(keys)
	if keys.target and not keys.target:IsHero() and not keys.target:IsOther() and not keys.target:IsBuilding() and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
		if not self:GetParent():IsRangedAttacker() then
			return self.bonus_damage + self.quelling_bonus
		else
			return self.bonus_damage + self.quelling_bonus_ranged
		end
	else
		return self.bonus_damage
	end
end

function modifier_item_bfury_lua4:OnAttackLanded(keys)
    if not (
        IsServer()
        and self:GetParent() == keys.attacker
        and keys.attacker:GetTeam() ~= keys.target:GetTeam()
        and not keys.attacker:IsRangedAttacker()
    ) then return end
    
    local ability = self:GetAbility()
    local damage = keys.original_damage
    local damageMod = ability:GetSpecialValueFor( "cleave_damage_percent" )
    local radius = ability:GetSpecialValueFor( "cleave_distance" )
    local particle_cast = 'particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf'
    
    damageMod = damageMod * 0.01
    damage = damage * damageMod
    
    DoCleaveAttack(
        self:GetParent(),
        keys.target,
        ability,
        damage,
        150,
        360,
        radius,
        particle_cast
    )
end

modifier_item_bfury_lua5 = class({})

function modifier_item_bfury_lua5:IsHidden()
	return true
end

function modifier_item_bfury_lua5:IsPurgable()
	return false
end

function modifier_item_bfury_lua5:DestroyOnExpire()
	return false
end

function modifier_item_bfury_lua5:RemoveOnDeath()	
	return false 
end

function modifier_item_bfury_lua5:OnCreated()
	
	

	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_health_regen = self:GetAbility():GetSpecialValueFor("bonus_health_regen")
	self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
	self.cleave_damage_percent = self:GetAbility():GetSpecialValueFor("cleave_damage_percent")
	self.cleave_ending_width = self:GetAbility():GetSpecialValueFor("cleave_ending_width")
	self.quelling_bonus = self:GetAbility():GetSpecialValueFor("quelling_bonus")
	self.quelling_bonus_ranged = self:GetAbility():GetSpecialValueFor("quelling_bonus_ranged")
	
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_bfury_lua5:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_bfury_lua5:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_item_bfury_lua5:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end

function modifier_item_bfury_lua5:GetModifierConstantHealthRegen()
	return self.bonus_health_regen
end

function modifier_item_bfury_lua5:GetModifierPreAttack_BonusDamage(keys)
	if keys.target and not keys.target:IsHero() and not keys.target:IsOther() and not keys.target:IsBuilding() and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
		if not self:GetParent():IsRangedAttacker() then
			return self.bonus_damage + self.quelling_bonus
		else
			return self.bonus_damage + self.quelling_bonus_ranged
		end
	else
		return self.bonus_damage
	end
end

function modifier_item_bfury_lua5:OnAttackLanded(keys)
    if not (
        IsServer()
        and self:GetParent() == keys.attacker
        and keys.attacker:GetTeam() ~= keys.target:GetTeam()
        and not keys.attacker:IsRangedAttacker()
    ) then return end
    
    local ability = self:GetAbility()
    local damage = keys.original_damage
    local damageMod = ability:GetSpecialValueFor( "cleave_damage_percent" )
    local radius = ability:GetSpecialValueFor( "cleave_distance" )
    local particle_cast = 'particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf'
    
    damageMod = damageMod * 0.01
    damage = damage * damageMod
    
    DoCleaveAttack(
        self:GetParent(),
        keys.target,
        ability,
        damage,
        150,
        360,
        radius,
        particle_cast
    )
end