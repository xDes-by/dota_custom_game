item_bfury_lua1_gem1 = item_bfury_lua1_gem1 or class({})
item_bfury_lua2_gem1 = item_bfury_lua1_gem1 or class({})
item_bfury_lua3_gem1 = item_bfury_lua1_gem1 or class({})
item_bfury_lua4_gem1 = item_bfury_lua1_gem1 or class({})
item_bfury_lua5_gem1 = item_bfury_lua1_gem1 or class({})
item_bfury_lua6_gem1 = item_bfury_lua1_gem1 or class({})
item_bfury_lua7_gem1 = item_bfury_lua1_gem1 or class({})
item_bfury_lua8_gem1 = item_bfury_lua1_gem1 or class({})

item_bfury_lua1_gem2 = item_bfury_lua1_gem2 or class({})
item_bfury_lua2_gem2 = item_bfury_lua1_gem2 or class({})
item_bfury_lua3_gem2 = item_bfury_lua1_gem2 or class({})
item_bfury_lua4_gem2 = item_bfury_lua1_gem2 or class({})
item_bfury_lua5_gem2 = item_bfury_lua1_gem2 or class({})
item_bfury_lua6_gem2 = item_bfury_lua1_gem2 or class({})
item_bfury_lua7_gem2 = item_bfury_lua1_gem2 or class({})
item_bfury_lua8_gem2 = item_bfury_lua1_gem2 or class({})

item_bfury_lua1_gem3 = item_bfury_lua1_gem3 or class({})
item_bfury_lua2_gem3 = item_bfury_lua1_gem3 or class({})
item_bfury_lua3_gem3 = item_bfury_lua1_gem3 or class({})
item_bfury_lua4_gem3 = item_bfury_lua1_gem3 or class({})
item_bfury_lua5_gem3 = item_bfury_lua1_gem3 or class({})
item_bfury_lua6_gem3 = item_bfury_lua1_gem3 or class({})
item_bfury_lua7_gem3 = item_bfury_lua1_gem3 or class({})
item_bfury_lua8_gem3 = item_bfury_lua1_gem3 or class({})

item_bfury_lua1_gem4 = item_bfury_lua1_gem4 or class({})
item_bfury_lua2_gem4 = item_bfury_lua1_gem4 or class({})
item_bfury_lua3_gem4 = item_bfury_lua1_gem4 or class({})
item_bfury_lua4_gem4 = item_bfury_lua1_gem4 or class({})
item_bfury_lua5_gem4 = item_bfury_lua1_gem4 or class({})
item_bfury_lua6_gem4 = item_bfury_lua1_gem4 or class({})
item_bfury_lua7_gem4 = item_bfury_lua1_gem4 or class({})
item_bfury_lua8_gem4 = item_bfury_lua1_gem4 or class({})

item_bfury_lua1_gem5 = item_bfury_lua1_gem5 or class({})
item_bfury_lua2_gem5 = item_bfury_lua1_gem5 or class({})
item_bfury_lua3_gem5 = item_bfury_lua1_gem5 or class({})
item_bfury_lua4_gem5 = item_bfury_lua1_gem5 or class({})
item_bfury_lua5_gem5 = item_bfury_lua1_gem5 or class({})
item_bfury_lua6_gem5 = item_bfury_lua1_gem5 or class({})
item_bfury_lua7_gem5 = item_bfury_lua1_gem5 or class({})
item_bfury_lua8_gem5 = item_bfury_lua1_gem5 or class({})

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

--------------------------------------------------------------------------------------------------------

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
    
	local direction = keys.target:GetOrigin()-self:GetParent():GetOrigin()
	direction.z = 0
	direction = direction:Normalized()
	local range = self:GetParent():GetOrigin() + direction*radius/2
	
	local reduse, item = check_desolator(self:GetParent())
					
	local enemies = FindUnitsInCone( self:GetParent():GetTeamNumber(), keys.target:GetOrigin(), self:GetParent():GetOrigin(), range, 150, 360, nil, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
	for _,enemy in pairs(enemies) do
		if enemy ~= keys.target then
			if reduse ~= nil then 
				enemy:AddNewModifier(self:GetParent(), item, "modifier_item_bfury_lua_debuff", {duration = 5})
			end
			ApplyDamage({victim = enemy, attacker = self:GetParent(), damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
		end
	end
	self:PlayEffects1(direction )
end

function modifier_item_bfury_lua1:PlayEffects1(direction )
	local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end
--------------------------------------------------------------------------

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
    
	local direction = keys.target:GetOrigin()-self:GetParent():GetOrigin()
	direction.z = 0
	direction = direction:Normalized()
	local range = self:GetParent():GetOrigin() + direction*radius/2
	
	local reduse, item = check_desolator(self:GetParent())
					
	local enemies = FindUnitsInCone( self:GetParent():GetTeamNumber(), keys.target:GetOrigin(), self:GetParent():GetOrigin(), range, 150, 360, nil, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
	for _,enemy in pairs(enemies) do
		if enemy ~= keys.target then
			if reduse ~= nil then 
				enemy:AddNewModifier(self:GetParent(), item, "modifier_item_bfury_lua_debuff", {duration = 5})
			end
			ApplyDamage({victim = enemy, attacker = self:GetParent(), damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
		end
	end
	self:PlayEffects1(direction )
end

function modifier_item_bfury_lua2:PlayEffects1(direction )
	local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

------------------------------------------------------------------

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
    
	local direction = keys.target:GetOrigin()-self:GetParent():GetOrigin()
	direction.z = 0
	direction = direction:Normalized()
	local range = self:GetParent():GetOrigin() + direction*radius/2
	
	local reduse, item = check_desolator(self:GetParent())
					
	local enemies = FindUnitsInCone( self:GetParent():GetTeamNumber(), keys.target:GetOrigin(), self:GetParent():GetOrigin(), range, 150, 360, nil, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
	for _,enemy in pairs(enemies) do
		if enemy ~= keys.target then
			if reduse ~= nil then 
				enemy:AddNewModifier(self:GetParent(), item, "modifier_item_bfury_lua_debuff", {duration = 5})
			end
			ApplyDamage({victim = enemy, attacker = self:GetParent(), damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
		end
	end
	self:PlayEffects1(direction )
end

function modifier_item_bfury_lua3:PlayEffects1(direction )
	local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

---------------------------------------------------------------

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
    
	local direction = keys.target:GetOrigin()-self:GetParent():GetOrigin()
	direction.z = 0
	direction = direction:Normalized()
	local range = self:GetParent():GetOrigin() + direction*radius/2
	
	local reduse, item = check_desolator(self:GetParent())
					
	local enemies = FindUnitsInCone( self:GetParent():GetTeamNumber(), keys.target:GetOrigin(), self:GetParent():GetOrigin(), range, 150, 360, nil, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
	for _,enemy in pairs(enemies) do
		if enemy ~= keys.target then
			if reduse ~= nil then 
				enemy:AddNewModifier(self:GetParent(), item, "modifier_item_bfury_lua_debuff", {duration = 5})
			end
			ApplyDamage({victim = enemy, attacker = self:GetParent(), damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
		end
	end
	self:PlayEffects1(direction )
end

function modifier_item_bfury_lua4:PlayEffects1(direction )
	local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

-----------------------------------------------------------------------

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
    
	local direction = keys.target:GetOrigin()-self:GetParent():GetOrigin()
	direction.z = 0
	direction = direction:Normalized()
	local range = self:GetParent():GetOrigin() + direction*radius/2
	
	local reduse, item = check_desolator(self:GetParent())
					
	local enemies = FindUnitsInCone( self:GetParent():GetTeamNumber(), keys.target:GetOrigin(), self:GetParent():GetOrigin(), range, 150, 360, nil, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
	for _,enemy in pairs(enemies) do
		if enemy ~= keys.target then
			if reduse ~= nil then 
				enemy:AddNewModifier(self:GetParent(), item, "modifier_item_bfury_lua_debuff", {duration = 5})
			end
			ApplyDamage({victim = enemy, attacker = self:GetParent(), damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
		end
	end
	self:PlayEffects1(direction )
end


function modifier_item_bfury_lua5:PlayEffects1(direction )
	local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------

function check_desolator(target)
local desolator_dict = { 
	modifier_item_desolator_lua = 7,
	modifier_item_desolator_lua_2 = 15,
	modifier_item_desolator_lua_3 = 20,
	modifier_item_desolator_lua_4 = 40,
	modifier_item_desolator_lua_5 = 80,
	modifier_item_desolator_lua_6 = 120,
	modifier_item_desolator_lua_7 = 200,
	modifier_item_desolator_lua_8 = 300,
	}
	
	for key,val in pairs(desolator_dict) do
		local modifier = target:FindModifierByName(tostring(key))
		if modifier then
			local item = modifier:GetAbility()
			return val, item
		end
	end
end

function FindUnitsInCone( nTeamNumber, vCenterPos, vStartPos, vEndPos, fStartRadius, fEndRadius, hCacheUnit, nTeamFilter, nTypeFilter, nFlagFilter, nOrderFilter, bCanGrowCache )
	local direction = vEndPos-vStartPos
	direction.z = 0

	local distance = direction:Length2D()
	direction = direction:Normalized()

	local big_radius = distance + math.max(fStartRadius, fEndRadius)

	local units = FindUnitsInRadius(
		nTeamNumber,	-- int, your team number
		vCenterPos,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		big_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		nTeamFilter,	-- int, team filter
		nTypeFilter,	-- int, type filter
		nFlagFilter,	-- int, flag filter
		nOrderFilter,	-- int, order filter
		bCanGrowCache	-- bool, can grow cache
	)

	local targets = {}
	for _,unit in pairs(units) do
		local vUnitPos = unit:GetOrigin()-vStartPos
		local fProjection = vUnitPos.x*direction.x + vUnitPos.y*direction.y + vUnitPos.z*direction.z
		fProjection = math.max(math.min(fProjection,distance),0)
		local vProjection = direction*fProjection
		local fUnitRadius = (vUnitPos - vProjection):Length2D()
		local fInterpRadius = (fProjection/distance)*(fEndRadius-fStartRadius) + fStartRadius
		if fUnitRadius<=fInterpRadius then
			table.insert( targets, unit )
		end
	end
	return targets
end

--------------------------------------

LinkLuaModifier("modifier_item_bfury_lua_debuff", 'items/items_gems/item_bfury_lua.lua', LUA_MODIFIER_MOTION_NONE)

modifier_item_bfury_lua_debuff = class({})

function modifier_item_bfury_lua_debuff:IsHidden() return false end
function modifier_item_bfury_lua_debuff:IsDebuff() return true end
function modifier_item_bfury_lua_debuff:IsPurgable() return true end

function modifier_item_bfury_lua_debuff:OnCreated(kv)
	self.count = (self:GetAbility():GetSpecialValueFor("corruption_armor") * (-1)) / 2
end

function modifier_item_bfury_lua_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_item_bfury_lua_debuff:GetModifierPhysicalArmorBonus()
	return self.count
end