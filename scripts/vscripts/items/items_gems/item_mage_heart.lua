item_mage_heart_lua1_gem1 = item_mage_heart_lua1_gem1 or class({})
item_mage_heart_lua2_gem1 = item_mage_heart_lua1_gem1 or class({})
item_mage_heart_lua3_gem1 = item_mage_heart_lua1_gem1 or class({})
item_mage_heart_lua4_gem1 = item_mage_heart_lua1_gem1 or class({})
item_mage_heart_lua5_gem1 = item_mage_heart_lua1_gem1 or class({})
item_mage_heart_lua6_gem1 = item_mage_heart_lua1_gem1 or class({})
item_mage_heart_lua7_gem1 = item_mage_heart_lua1_gem1 or class({})
item_mage_heart_lua8_gem1 = item_mage_heart_lua1_gem1 or class({})

item_mage_heart_lua1_gem2 = item_mage_heart_lua1_gem2 or class({})
item_mage_heart_lua2_gem2 = item_mage_heart_lua1_gem2 or class({})
item_mage_heart_lua3_gem2 = item_mage_heart_lua1_gem2 or class({})
item_mage_heart_lua4_gem2 = item_mage_heart_lua1_gem2 or class({})
item_mage_heart_lua5_gem2 = item_mage_heart_lua1_gem2 or class({})
item_mage_heart_lua6_gem2 = item_mage_heart_lua1_gem2 or class({})
item_mage_heart_lua7_gem2 = item_mage_heart_lua1_gem2 or class({})
item_mage_heart_lua8_gem2 = item_mage_heart_lua1_gem2 or class({})

item_mage_heart_lua1_gem3 = item_mage_heart_lua1_gem3 or class({})
item_mage_heart_lua2_gem3 = item_mage_heart_lua1_gem3 or class({})
item_mage_heart_lua3_gem3 = item_mage_heart_lua1_gem3 or class({})
item_mage_heart_lua4_gem3 = item_mage_heart_lua1_gem3 or class({})
item_mage_heart_lua5_gem3 = item_mage_heart_lua1_gem3 or class({})
item_mage_heart_lua6_gem3 = item_mage_heart_lua1_gem3 or class({})
item_mage_heart_lua7_gem3 = item_mage_heart_lua1_gem3 or class({})
item_mage_heart_lua8_gem3 = item_mage_heart_lua1_gem3 or class({})

item_mage_heart_lua1_gem4 = item_mage_heart_lua1_gem4 or class({})
item_mage_heart_lua2_gem4 = item_mage_heart_lua1_gem4 or class({})
item_mage_heart_lua3_gem4 = item_mage_heart_lua1_gem4 or class({})
item_mage_heart_lua4_gem4 = item_mage_heart_lua1_gem4 or class({})
item_mage_heart_lua5_gem4 = item_mage_heart_lua1_gem4 or class({})
item_mage_heart_lua6_gem4 = item_mage_heart_lua1_gem4 or class({})
item_mage_heart_lua7_gem4 = item_mage_heart_lua1_gem4 or class({})
item_mage_heart_lua8_gem4 = item_mage_heart_lua1_gem4 or class({})

item_mage_heart_lua1_gem5 = item_mage_heart_lua1_gem5 or class({})
item_mage_heart_lua2_gem5 = item_mage_heart_lua1_gem5 or class({})
item_mage_heart_lua3_gem5 = item_mage_heart_lua1_gem5 or class({})
item_mage_heart_lua4_gem5 = item_mage_heart_lua1_gem5 or class({})
item_mage_heart_lua5_gem5 = item_mage_heart_lua1_gem5 or class({})
item_mage_heart_lua6_gem5 = item_mage_heart_lua1_gem5 or class({})
item_mage_heart_lua7_gem5 = item_mage_heart_lua1_gem5 or class({})
item_mage_heart_lua8_gem5 = item_mage_heart_lua1_gem5 or class({})

LinkLuaModifier("modifier_gem1", 'items/items_gems/gem1', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem2", 'items/items_gems/gem2', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem3", 'items/items_gems/gem3', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem4", 'items/items_gems/gem4', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem5", 'items/items_gems/gem5', LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_item_mage_heart_lua_passive1", 'items/items_gems/item_mage_heart.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_mage_heart_lua_passive2", 'items/items_gems/item_mage_heart.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_mage_heart_lua_passive3", 'items/items_gems/item_mage_heart.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_mage_heart_lua_passive4", 'items/items_gems/item_mage_heart.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_mage_heart_lua_passive5", 'items/items_gems/item_mage_heart.lua', LUA_MODIFIER_MOTION_NONE)

function item_mage_heart_lua1_gem1:GetIntrinsicModifierName()
	return "modifier_item_mage_heart_lua_passive1"
end
function item_mage_heart_lua1_gem2:GetIntrinsicModifierName()
	return "modifier_item_mage_heart_lua_passive2"
end
function item_mage_heart_lua1_gem3:GetIntrinsicModifierName()
	return "modifier_item_mage_heart_lua_passive3"
end
function item_mage_heart_lua1_gem4:GetIntrinsicModifierName()
	return "modifier_item_mage_heart_lua_passive4"
end
function item_mage_heart_lua1_gem5:GetIntrinsicModifierName()
	return "modifier_item_mage_heart_lua_passive5"
end
-----------------------------------------------------------------------------------------------

modifier_item_mage_heart_lua_passive1 = class({})

function modifier_item_mage_heart_lua_passive1:IsHidden()
	return true
end

function modifier_item_mage_heart_lua_passive1:IsPurgable()
	return false
end

function modifier_item_mage_heart_lua_passive1:DestroyOnExpire()
	return false
end

function modifier_item_mage_heart_lua_passive1:OnCreated( kv )
	
	
	local caster = self:GetCaster()
    self.bonus_int = self:GetAbility():GetSpecialValueFor("bonus_int")
    self.tick = self:GetAbility():GetSpecialValueFor("tick")
	self:StartIntervalThink(self.tick)
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end
function modifier_item_mage_heart_lua_passive1:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end
--------------------------
function modifier_item_mage_heart_lua_passive1:OnIntervalThink()		
		local parent = self:GetParent()
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		
		local maxcount = ability:GetSpecialValueFor('count')
		local radius = ability:GetSpecialValueFor('radius')
		local damage = caster:GetIntellect() /2

		local enemy_list = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)		
		
		local count = 0
		for _,enemy in pairs(enemy_list) do
			if count < maxcount then
				count = count + 1
				self:_FireEffect(enemy)
				self:_ApplyDamage(enemy)
			end
		end
	end

	function modifier_item_mage_heart_lua_passive1:_OnAttacked(attacker)
		local parent = self:GetParent()
		local ability = self:GetAbility()
	
		if parent.attack_counter > 1 then
			parent.attack_counter = parent.attack_counter - 1
			parent:SetHealth(parent.attack_counter)
			parent:ModifyHealth(parent.attack_counter, ability, false, 0)
		end
	end

	function modifier_item_mage_heart_lua_passive1:_FireEffect(target)
		local parent = self:GetParent()
		local caster = self:GetCaster()
		local ability = self:GetAbility()

		local ward = parent
		-- There are some light/medium/heavy unused versions
		local p_list = {
			"particles/units/heroes/hero_pugna/pugna_ward_attack.vpcf",
			"particles/units/heroes/hero_pugna/pugna_ward_attack_light.vpcf",
			"particles/units/heroes/hero_pugna/pugna_ward_attack_medium.vpcf",
			"particles/units/heroes/hero_pugna/pugna_ward_attack_heavy.vpcf",
		}
		local p_id = RandomInt(1, #p_list)
		local p_name = p_list[p_id]
		local p_attack = ParticleManager:CreateParticle(p_name, PATTACH_ABSORIGIN_FOLLOW, ward)
		ParticleManager:SetParticleControl(p_attack, 1, target:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(p_attack)

		--target:EmitSound("Hero_Pugna.NetherWard.Target")
		-- caster:EmitSound("Hero_Pugna.NetherWard.Attack")
		ward:EmitSound("Hero_Pugna.NetherWard.Attack")
	end

	function modifier_item_mage_heart_lua_passive1:_ApplyDamage(target)
		local parent = self:GetParent()
		local caster = self:GetCaster()
		local ability = self:GetAbility()

		local damage = caster:GetIntellect() /2

		ApplyDamage({
			attacker = caster,
			victim = target,
			ability = ability,
			damage_type = ability:GetAbilityDamageType(),
			damage = damage
		})
end

function modifier_item_mage_heart_lua_passive1:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
	return funcs
end

function modifier_item_mage_heart_lua_passive1:GetModifierBonusStats_Intellect( params )
	return self.bonus_int
end

-----------------------------------------------------------------------------------------------

modifier_item_mage_heart_lua_passive2 = class({})

function modifier_item_mage_heart_lua_passive2:IsHidden()
	return true
end

function modifier_item_mage_heart_lua_passive2:IsPurgable()
	return false
end

function modifier_item_mage_heart_lua_passive2:DestroyOnExpire()
	return false
end

function modifier_item_mage_heart_lua_passive2:OnCreated( kv )
	
	
	local caster = self:GetCaster()
    self.bonus_int = self:GetAbility():GetSpecialValueFor("bonus_int")
    self.tick = self:GetAbility():GetSpecialValueFor("tick")
	self:StartIntervalThink(self.tick)
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end
function modifier_item_mage_heart_lua_passive2:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end
--------------------------
function modifier_item_mage_heart_lua_passive2:OnIntervalThink()		
		local parent = self:GetParent()
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		
		local maxcount = ability:GetSpecialValueFor('count')
		local radius = ability:GetSpecialValueFor('radius')
		local damage = caster:GetIntellect() /2

		local enemy_list = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)		
		
		local count = 0
		for _,enemy in pairs(enemy_list) do
			if count < maxcount then
				count = count + 1
				self:_FireEffect(enemy)
				self:_ApplyDamage(enemy)
			end
		end
	end

	function modifier_item_mage_heart_lua_passive2:_OnAttacked(attacker)
		local parent = self:GetParent()
		local ability = self:GetAbility()
	
		if parent.attack_counter > 1 then
			parent.attack_counter = parent.attack_counter - 1
			parent:SetHealth(parent.attack_counter)
			parent:ModifyHealth(parent.attack_counter, ability, false, 0)
		end
	end

	function modifier_item_mage_heart_lua_passive2:_FireEffect(target)
		local parent = self:GetParent()
		local caster = self:GetCaster()
		local ability = self:GetAbility()

		local ward = parent
		-- There are some light/medium/heavy unused versions
		local p_list = {
			"particles/units/heroes/hero_pugna/pugna_ward_attack.vpcf",
			"particles/units/heroes/hero_pugna/pugna_ward_attack_light.vpcf",
			"particles/units/heroes/hero_pugna/pugna_ward_attack_medium.vpcf",
			"particles/units/heroes/hero_pugna/pugna_ward_attack_heavy.vpcf",
		}
		local p_id = RandomInt(1, #p_list)
		local p_name = p_list[p_id]
		local p_attack = ParticleManager:CreateParticle(p_name, PATTACH_ABSORIGIN_FOLLOW, ward)
		ParticleManager:SetParticleControl(p_attack, 1, target:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(p_attack)

		--target:EmitSound("Hero_Pugna.NetherWard.Target")
		-- caster:EmitSound("Hero_Pugna.NetherWard.Attack")
		ward:EmitSound("Hero_Pugna.NetherWard.Attack")
	end

	function modifier_item_mage_heart_lua_passive2:_ApplyDamage(target)
		local parent = self:GetParent()
		local caster = self:GetCaster()
		local ability = self:GetAbility()

		local damage = caster:GetIntellect() /2

		ApplyDamage({
			attacker = caster,
			victim = target,
			ability = ability,
			damage_type = ability:GetAbilityDamageType(),
			damage = damage
		})
	end

-----------------------


function modifier_item_mage_heart_lua_passive2:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
	return funcs
end

function modifier_item_mage_heart_lua_passive2:GetModifierBonusStats_Intellect( params )
	return self.bonus_int
end

-----------------------------------------------------------------------------------------------

modifier_item_mage_heart_lua_passive3 = class({})

function modifier_item_mage_heart_lua_passive3:IsHidden()
	return true
end

function modifier_item_mage_heart_lua_passive3:IsPurgable()
	return false
end

function modifier_item_mage_heart_lua_passive3:DestroyOnExpire()
	return false
end

function modifier_item_mage_heart_lua_passive3:OnCreated( kv )
	
	
	local caster = self:GetCaster()
    self.bonus_int = self:GetAbility():GetSpecialValueFor("bonus_int")
    self.tick = self:GetAbility():GetSpecialValueFor("tick")
	self:StartIntervalThink(self.tick)
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end
function modifier_item_mage_heart_lua_passive3:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end
--------------------------
function modifier_item_mage_heart_lua_passive3:OnIntervalThink()		
		local parent = self:GetParent()
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		
		local maxcount = ability:GetSpecialValueFor('count')
		local radius = ability:GetSpecialValueFor('radius')
		local damage = caster:GetIntellect() /2

		local enemy_list = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)		
		
		local count = 0
		for _,enemy in pairs(enemy_list) do
			if count < maxcount then
				count = count + 1
				self:_FireEffect(enemy)
				self:_ApplyDamage(enemy)
			end
		end
	end

	function modifier_item_mage_heart_lua_passive3:_OnAttacked(attacker)
		local parent = self:GetParent()
		local ability = self:GetAbility()
	
		if parent.attack_counter > 1 then
			parent.attack_counter = parent.attack_counter - 1
			parent:SetHealth(parent.attack_counter)
			parent:ModifyHealth(parent.attack_counter, ability, false, 0)
		end
	end

	function modifier_item_mage_heart_lua_passive3:_FireEffect(target)
		local parent = self:GetParent()
		local caster = self:GetCaster()
		local ability = self:GetAbility()

		local ward = parent
		-- There are some light/medium/heavy unused versions
		local p_list = {
			"particles/units/heroes/hero_pugna/pugna_ward_attack.vpcf",
			"particles/units/heroes/hero_pugna/pugna_ward_attack_light.vpcf",
			"particles/units/heroes/hero_pugna/pugna_ward_attack_medium.vpcf",
			"particles/units/heroes/hero_pugna/pugna_ward_attack_heavy.vpcf",
		}
		local p_id = RandomInt(1, #p_list)
		local p_name = p_list[p_id]
		local p_attack = ParticleManager:CreateParticle(p_name, PATTACH_ABSORIGIN_FOLLOW, ward)
		ParticleManager:SetParticleControl(p_attack, 1, target:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(p_attack)

		--target:EmitSound("Hero_Pugna.NetherWard.Target")
		-- caster:EmitSound("Hero_Pugna.NetherWard.Attack")
		ward:EmitSound("Hero_Pugna.NetherWard.Attack")
	end

	function modifier_item_mage_heart_lua_passive3:_ApplyDamage(target)
		local parent = self:GetParent()
		local caster = self:GetCaster()
		local ability = self:GetAbility()

		local damage = caster:GetIntellect() /2

		ApplyDamage({
			attacker = caster,
			victim = target,
			ability = ability,
			damage_type = ability:GetAbilityDamageType(),
			damage = damage
		})
	end


-----------------------

function modifier_item_mage_heart_lua_passive3:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
	return funcs
end

function modifier_item_mage_heart_lua_passive3:GetModifierBonusStats_Intellect( params )
	return self.bonus_int
end

-----------------------------------------------------------------------------------------------

modifier_item_mage_heart_lua_passive4 = class({})

function modifier_item_mage_heart_lua_passive4:IsHidden()
	return true
end

function modifier_item_mage_heart_lua_passive4:IsPurgable()
	return false
end

function modifier_item_mage_heart_lua_passive4:DestroyOnExpire()
	return false
end

function modifier_item_mage_heart_lua_passive4:OnCreated( kv )
	
	
	local caster = self:GetCaster()
    self.bonus_int = self:GetAbility():GetSpecialValueFor("bonus_int")
    self.tick = self:GetAbility():GetSpecialValueFor("tick")
	self:StartIntervalThink(self.tick)
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end
function modifier_item_mage_heart_lua_passive4:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end
--------------------------
function modifier_item_mage_heart_lua_passive4:OnIntervalThink()		
		local parent = self:GetParent()
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		
		local maxcount = ability:GetSpecialValueFor('count')
		local radius = ability:GetSpecialValueFor('radius')
		local damage = caster:GetIntellect() /2

		local enemy_list = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)		
		
		local count = 0
		for _,enemy in pairs(enemy_list) do
			if count < maxcount then
				count = count + 1
				self:_FireEffect(enemy)
				self:_ApplyDamage(enemy)
			end
		end
	end

	function modifier_item_mage_heart_lua_passive4:_OnAttacked(attacker)
		local parent = self:GetParent()
		local ability = self:GetAbility()
	
		if parent.attack_counter > 1 then
			parent.attack_counter = parent.attack_counter - 1
			parent:SetHealth(parent.attack_counter)
			parent:ModifyHealth(parent.attack_counter, ability, false, 0)
		end
	end

	function modifier_item_mage_heart_lua_passive4:_FireEffect(target)
		local parent = self:GetParent()
		local caster = self:GetCaster()
		local ability = self:GetAbility()

		local ward = parent
		-- There are some light/medium/heavy unused versions
		local p_list = {
			"particles/units/heroes/hero_pugna/pugna_ward_attack.vpcf",
			"particles/units/heroes/hero_pugna/pugna_ward_attack_light.vpcf",
			"particles/units/heroes/hero_pugna/pugna_ward_attack_medium.vpcf",
			"particles/units/heroes/hero_pugna/pugna_ward_attack_heavy.vpcf",
		}
		local p_id = RandomInt(1, #p_list)
		local p_name = p_list[p_id]
		local p_attack = ParticleManager:CreateParticle(p_name, PATTACH_ABSORIGIN_FOLLOW, ward)
		ParticleManager:SetParticleControl(p_attack, 1, target:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(p_attack)

		--target:EmitSound("Hero_Pugna.NetherWard.Target")
		-- caster:EmitSound("Hero_Pugna.NetherWard.Attack")
		ward:EmitSound("Hero_Pugna.NetherWard.Attack")
	end

	function modifier_item_mage_heart_lua_passive4:_ApplyDamage(target)
		local parent = self:GetParent()
		local caster = self:GetCaster()
		local ability = self:GetAbility()

		local damage = caster:GetIntellect() /2

		ApplyDamage({
			attacker = caster,
			victim = target,
			ability = ability,
			damage_type = ability:GetAbilityDamageType(),
			damage = damage
		})
	end



-----------------------

function modifier_item_mage_heart_lua_passive4:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
	return funcs
end

function modifier_item_mage_heart_lua_passive4:GetModifierBonusStats_Intellect( params )
	return self.bonus_int
end

-----------------------------------------------------------------------------------------------

modifier_item_mage_heart_lua_passive5 = class({})

function modifier_item_mage_heart_lua_passive5:IsHidden()
	return true
end

function modifier_item_mage_heart_lua_passive5:IsPurgable()
	return false
end

function modifier_item_mage_heart_lua_passive5:DestroyOnExpire()
	return false
end

function modifier_item_mage_heart_lua_passive5:OnCreated( kv )
	
	
	local caster = self:GetCaster()
    self.bonus_int = self:GetAbility():GetSpecialValueFor("bonus_int")
    self.tick = self:GetAbility():GetSpecialValueFor("tick")
	self:StartIntervalThink(self.tick)
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end
function modifier_item_mage_heart_lua_passive5:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end
--------------------------
function modifier_item_mage_heart_lua_passive5:OnIntervalThink()		
		local parent = self:GetParent()
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		
		local maxcount = ability:GetSpecialValueFor('count')
		local radius = ability:GetSpecialValueFor('radius')
		local damage = caster:GetIntellect() /2

		local enemy_list = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)		
		
		local count = 0
		for _,enemy in pairs(enemy_list) do
			if count < maxcount then
				count = count + 1
				self:_FireEffect(enemy)
				self:_ApplyDamage(enemy)
			end
		end
	end

	function modifier_item_mage_heart_lua_passive5:_OnAttacked(attacker)
		local parent = self:GetParent()
		local ability = self:GetAbility()
	
		if parent.attack_counter > 1 then
			parent.attack_counter = parent.attack_counter - 1
			parent:SetHealth(parent.attack_counter)
			parent:ModifyHealth(parent.attack_counter, ability, false, 0)
		end
	end

	function modifier_item_mage_heart_lua_passive5:_FireEffect(target)
		local parent = self:GetParent()
		local caster = self:GetCaster()
		local ability = self:GetAbility()

		local ward = parent
		-- There are some light/medium/heavy unused versions
		local p_list = {
			"particles/units/heroes/hero_pugna/pugna_ward_attack.vpcf",
			"particles/units/heroes/hero_pugna/pugna_ward_attack_light.vpcf",
			"particles/units/heroes/hero_pugna/pugna_ward_attack_medium.vpcf",
			"particles/units/heroes/hero_pugna/pugna_ward_attack_heavy.vpcf",
		}
		local p_id = RandomInt(1, #p_list)
		local p_name = p_list[p_id]
		local p_attack = ParticleManager:CreateParticle(p_name, PATTACH_ABSORIGIN_FOLLOW, ward)
		ParticleManager:SetParticleControl(p_attack, 1, target:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(p_attack)

		--target:EmitSound("Hero_Pugna.NetherWard.Target")
		-- caster:EmitSound("Hero_Pugna.NetherWard.Attack")
		ward:EmitSound("Hero_Pugna.NetherWard.Attack")
	end

	function modifier_item_mage_heart_lua_passive5:_ApplyDamage(target)
		local parent = self:GetParent()
		local caster = self:GetCaster()
		local ability = self:GetAbility()

		local damage = caster:GetIntellect() /2

		ApplyDamage({
			attacker = caster,
			victim = target,
			ability = ability,
			damage_type = ability:GetAbilityDamageType(),
			damage = damage
		})
	end

function modifier_item_mage_heart_lua_passive5:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
	return funcs
end

function modifier_item_mage_heart_lua_passive5:GetModifierBonusStats_Intellect( params )
	return self.bonus_int
end