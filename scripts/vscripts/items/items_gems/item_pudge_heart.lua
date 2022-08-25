item_pudge_heart_lua1_gem1 = item_pudge_heart_lua1_gem1 or class({})
item_pudge_heart_lua2_gem1 = item_pudge_heart_lua1_gem1 or class({})
item_pudge_heart_lua3_gem1 = item_pudge_heart_lua1_gem1 or class({})
item_pudge_heart_lua4_gem1 = item_pudge_heart_lua1_gem1 or class({})
item_pudge_heart_lua5_gem1 = item_pudge_heart_lua1_gem1 or class({})
item_pudge_heart_lua6_gem1 = item_pudge_heart_lua1_gem1 or class({})
item_pudge_heart_lua7_gem1 = item_pudge_heart_lua1_gem1 or class({})
item_pudge_heart_lua8_gem1 = item_pudge_heart_lua1_gem1 or class({})

item_pudge_heart_lua1_gem2 = item_pudge_heart_lua1_gem2 or class({})
item_pudge_heart_lua2_gem2 = item_pudge_heart_lua1_gem2 or class({})
item_pudge_heart_lua3_gem2 = item_pudge_heart_lua1_gem2 or class({})
item_pudge_heart_lua4_gem2 = item_pudge_heart_lua1_gem2 or class({})
item_pudge_heart_lua5_gem2 = item_pudge_heart_lua1_gem2 or class({})
item_pudge_heart_lua6_gem2 = item_pudge_heart_lua1_gem2 or class({})
item_pudge_heart_lua7_gem2 = item_pudge_heart_lua1_gem2 or class({})
item_pudge_heart_lua8_gem2 = item_pudge_heart_lua1_gem2 or class({})

item_pudge_heart_lua1_gem3 = item_pudge_heart_lua1_gem3 or class({})
item_pudge_heart_lua2_gem3 = item_pudge_heart_lua1_gem3 or class({})
item_pudge_heart_lua3_gem3 = item_pudge_heart_lua1_gem3 or class({})
item_pudge_heart_lua4_gem3 = item_pudge_heart_lua1_gem3 or class({})
item_pudge_heart_lua5_gem3 = item_pudge_heart_lua1_gem3 or class({})
item_pudge_heart_lua6_gem3 = item_pudge_heart_lua1_gem3 or class({})
item_pudge_heart_lua7_gem3 = item_pudge_heart_lua1_gem3 or class({})
item_pudge_heart_lua8_gem3 = item_pudge_heart_lua1_gem3 or class({})

item_pudge_heart_lua1_gem4 = item_pudge_heart_lua1_gem4 or class({})
item_pudge_heart_lua2_gem4 = item_pudge_heart_lua1_gem4 or class({})
item_pudge_heart_lua3_gem4 = item_pudge_heart_lua1_gem4 or class({})
item_pudge_heart_lua4_gem4 = item_pudge_heart_lua1_gem4 or class({})
item_pudge_heart_lua5_gem4 = item_pudge_heart_lua1_gem4 or class({})
item_pudge_heart_lua6_gem4 = item_pudge_heart_lua1_gem4 or class({})
item_pudge_heart_lua7_gem4 = item_pudge_heart_lua1_gem4 or class({})
item_pudge_heart_lua8_gem4 = item_pudge_heart_lua1_gem4 or class({})

item_pudge_heart_lua1_gem5 = item_pudge_heart_lua1_gem5 or class({})
item_pudge_heart_lua2_gem5 = item_pudge_heart_lua1_gem5 or class({})
item_pudge_heart_lua3_gem5 = item_pudge_heart_lua1_gem5 or class({})
item_pudge_heart_lua4_gem5 = item_pudge_heart_lua1_gem5 or class({})
item_pudge_heart_lua5_gem5 = item_pudge_heart_lua1_gem5 or class({})
item_pudge_heart_lua6_gem5 = item_pudge_heart_lua1_gem5 or class({})
item_pudge_heart_lua7_gem5 = item_pudge_heart_lua1_gem5 or class({})
item_pudge_heart_lua8_gem5 = item_pudge_heart_lua1_gem5 or class({})

LinkLuaModifier("modifier_gem1", 'items/items_gems/gem1', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem2", 'items/items_gems/gem2', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem3", 'items/items_gems/gem3', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem4", 'items/items_gems/gem4', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem5", 'items/items_gems/gem5', LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_item_pudge_heart_passive1", 'items/items_gems/item_pudge_heart.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_pudge_heart_passive2", 'items/items_gems/item_pudge_heart.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_pudge_heart_passive3", 'items/items_gems/item_pudge_heart.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_pudge_heart_passive4", 'items/items_gems/item_pudge_heart.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_pudge_heart_passive5", 'items/items_gems/item_pudge_heart.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_pudge_heart", 'items/items_gems/item_pudge_heart.lua', LUA_MODIFIER_MOTION_NONE)

function item_pudge_heart_lua1_gem1:GetIntrinsicModifierName()
	return "modifier_item_pudge_heart_passive1"
end
function item_pudge_heart_lua1_gem2:GetIntrinsicModifierName()
	return "modifier_item_pudge_heart_passive2"
end
function item_pudge_heart_lua1_gem3:GetIntrinsicModifierName()
	return "modifier_item_pudge_heart_passive3"
end
function item_pudge_heart_lua1_gem4:GetIntrinsicModifierName()
	return "modifier_item_pudge_heart_passive4"
end
function item_pudge_heart_lua1_gem5:GetIntrinsicModifierName()
	return "modifier_item_pudge_heart_passive5"
end

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

function item_pudge_heart_lua1_gem1:OnSpellStart()
if not IsServer() then return end

	local radius = self:GetSpecialValueFor("radius")
	
	EmitSoundOn( "Hero_Pudge.Eject", self:GetCaster() )
	
	self.damageTable = {
		attacker = self:GetCaster(),
		damage_type = DAMAGE_TYPE_MAGICAL,
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_HPLOSS,
		ability = self
	}
	
	local particle_blast = "particles/units/heroes/hero_pugna/pugna_netherblast.vpcf"

	local particle_blast_fx = ParticleManager:CreateParticle(particle_blast, PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(particle_blast_fx, 0, self:GetCaster():GetOrigin())
	ParticleManager:SetParticleControl(particle_blast_fx, 1, Vector(400, 0, 0))
	ParticleManager:ReleaseParticleIndex(particle_blast_fx)
	
	self.damageTable.victim = self:GetCaster()
	self.damageTable.damage = self:GetCaster():GetMaxHealth()/2
	ApplyDamage( self.damageTable )
	
	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	for _,enemy in pairs(enemies) do
		self.damageTable.victim = enemy
		self.damageTable.damage = self:GetCaster():GetStrength()
		self.damageTable.damage_flags = DOTA_DAMAGE_FLAG_NONE
		ApplyDamage( self.damageTable )
	end
end

-----------------------------------------------------------------------------------------------

function item_pudge_heart_lua1_gem2:OnSpellStart()
if not IsServer() then return end

	local radius = self:GetSpecialValueFor("radius")
	
	EmitSoundOn( "Hero_Pudge.Eject", self:GetCaster() )
	
	self.damageTable = {
		attacker = self:GetCaster(),
		damage_type = DAMAGE_TYPE_MAGICAL,
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_HPLOSS,
		ability = self
	}
	
	local particle_blast = "particles/units/heroes/hero_pugna/pugna_netherblast.vpcf"

	local particle_blast_fx = ParticleManager:CreateParticle(particle_blast, PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(particle_blast_fx, 0, self:GetCaster():GetOrigin())
	ParticleManager:SetParticleControl(particle_blast_fx, 1, Vector(400, 0, 0))
	ParticleManager:ReleaseParticleIndex(particle_blast_fx)
	
	self.damageTable.victim = self:GetCaster()
	self.damageTable.damage = self:GetCaster():GetMaxHealth()/2
	ApplyDamage( self.damageTable )
	
	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	for _,enemy in pairs(enemies) do
		self.damageTable.victim = enemy
		self.damageTable.damage = self:GetCaster():GetStrength()
		self.damageTable.damage_flags = DOTA_DAMAGE_FLAG_NONE
		ApplyDamage( self.damageTable )
	end
end

-----------------------------------------------------------------------------------------------

function item_pudge_heart_lua1_gem3:OnSpellStart()
if not IsServer() then return end

	local radius = self:GetSpecialValueFor("radius")
	
	EmitSoundOn( "Hero_Pudge.Eject", self:GetCaster() )
	
	self.damageTable = {
		attacker = self:GetCaster(),
		damage_type = DAMAGE_TYPE_MAGICAL,
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_HPLOSS,
		ability = self
	}
	
	local particle_blast = "particles/units/heroes/hero_pugna/pugna_netherblast.vpcf"

	local particle_blast_fx = ParticleManager:CreateParticle(particle_blast, PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(particle_blast_fx, 0, self:GetCaster():GetOrigin())
	ParticleManager:SetParticleControl(particle_blast_fx, 1, Vector(400, 0, 0))
	ParticleManager:ReleaseParticleIndex(particle_blast_fx)
	
	self.damageTable.victim = self:GetCaster()
	self.damageTable.damage = self:GetCaster():GetMaxHealth()/2
	ApplyDamage( self.damageTable )
	
	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	for _,enemy in pairs(enemies) do
		self.damageTable.victim = enemy
		self.damageTable.damage = self:GetCaster():GetStrength()
		self.damageTable.damage_flags = DOTA_DAMAGE_FLAG_NONE
		ApplyDamage( self.damageTable )
	end
end



-----------------------------------------------------------------------------------------------

function item_pudge_heart_lua1_gem4:OnSpellStart()
if not IsServer() then return end

	local radius = self:GetSpecialValueFor("radius")
	
	EmitSoundOn( "Hero_Pudge.Eject", self:GetCaster() )
	
	self.damageTable = {
		attacker = self:GetCaster(),
		damage_type = DAMAGE_TYPE_MAGICAL,
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_HPLOSS,
		ability = self
	}
	
	local particle_blast = "particles/units/heroes/hero_pugna/pugna_netherblast.vpcf"

	local particle_blast_fx = ParticleManager:CreateParticle(particle_blast, PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(particle_blast_fx, 0, self:GetCaster():GetOrigin())
	ParticleManager:SetParticleControl(particle_blast_fx, 1, Vector(400, 0, 0))
	ParticleManager:ReleaseParticleIndex(particle_blast_fx)
	
	self.damageTable.victim = self:GetCaster()
	self.damageTable.damage = self:GetCaster():GetMaxHealth()/2
	ApplyDamage( self.damageTable )
	
	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	for _,enemy in pairs(enemies) do
		self.damageTable.victim = enemy
		self.damageTable.damage = self:GetCaster():GetStrength()
		self.damageTable.damage_flags = DOTA_DAMAGE_FLAG_NONE
		ApplyDamage( self.damageTable )
	end
end

-----------------------------------------------------------------------------------------------

function item_pudge_heart_lua1_gem5:OnSpellStart()
if not IsServer() then return end

	local radius = self:GetSpecialValueFor("radius")
	
	EmitSoundOn( "Hero_Pudge.Eject", self:GetCaster() )
	
	self.damageTable = {
		attacker = self:GetCaster(),
		damage_type = DAMAGE_TYPE_MAGICAL,
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_HPLOSS,
		ability = self
	}
	
	local particle_blast = "particles/units/heroes/hero_pugna/pugna_netherblast.vpcf"

	local particle_blast_fx = ParticleManager:CreateParticle(particle_blast, PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(particle_blast_fx, 0, self:GetCaster():GetOrigin())
	ParticleManager:SetParticleControl(particle_blast_fx, 1, Vector(400, 0, 0))
	ParticleManager:ReleaseParticleIndex(particle_blast_fx)
	
	self.damageTable.victim = self:GetCaster()
	self.damageTable.damage = self:GetCaster():GetMaxHealth()/2
	ApplyDamage( self.damageTable )
	
	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	for _,enemy in pairs(enemies) do
		self.damageTable.victim = enemy
		self.damageTable.damage = self:GetCaster():GetStrength()
		self.damageTable.damage_flags = DOTA_DAMAGE_FLAG_NONE
		ApplyDamage( self.damageTable )
	end
end

-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

modifier_item_pudge_heart = class({})

function modifier_item_pudge_heart:IsDebuff()
	return true
end

function modifier_item_pudge_heart:IsStunDebuff()
	return true
end

function modifier_item_pudge_heart:OnCreated( kv )
	self.dismember_damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.tick_rate = self:GetAbility():GetSpecialValueFor( "tick_rate" )
	if IsServer() then
		self:GetParent():InterruptChannel()
		self:OnIntervalThink()
		self:StartIntervalThink( self.tick_rate )
	end
end

function modifier_item_pudge_heart:OnIntervalThink()
	if IsServer() then
	
		local flDamage = self.dismember_damage * self:GetCaster():GetStrength()
			self:GetCaster():Heal( flDamage, self:GetAbility() )
		
		local damage = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = flDamage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility()
		}

		ApplyDamage( damage )
		EmitSoundOn( "Hero_Pudge.Dismember", self:GetParent() )
	end
end

function modifier_item_pudge_heart:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

function modifier_item_pudge_heart:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_item_pudge_heart:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

-----------------------------------------------------------------------------------------------

modifier_item_pudge_heart_passive1 = class({})

function modifier_item_pudge_heart_passive1:IsHidden()
	return true
end

function modifier_item_pudge_heart_passive1:IsPurgable()
	return false
end

function modifier_item_pudge_heart_passive1:DestroyOnExpire()
	return false
end

function modifier_item_pudge_heart_passive1:OnCreated( kv )
    self.bonus_str = self:GetAbility():GetSpecialValueFor("bonus_str")
	if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_pudge_heart_passive1:OnDestroy()
	if IsServer() then
		self:GetCaster():InterruptChannel()
	end
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_pudge_heart_passive1:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
	}
	return funcs
end

function modifier_item_pudge_heart_passive1:GetModifierBonusStats_Strength( params )
	return self.bonus_str
end

-----------------------------------------------------------------------------------------------

modifier_item_pudge_heart_passive2 = class({})

function modifier_item_pudge_heart_passive2:IsHidden()
	return true
end

function modifier_item_pudge_heart_passive2:IsPurgable()
	return false
end

function modifier_item_pudge_heart_passive2:DestroyOnExpire()
	return false
end

function modifier_item_pudge_heart_passive2:OnCreated( kv )
    self.bonus_str = self:GetAbility():GetSpecialValueFor("bonus_str")
	if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_pudge_heart_passive2:OnDestroy()
	if IsServer() then
		self:GetCaster():InterruptChannel()
	end
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_pudge_heart_passive2:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
	}
	return funcs
end

function modifier_item_pudge_heart_passive2:GetModifierBonusStats_Strength( params )
	return self.bonus_str
end

-----------------------------------------------------------------------------------------------

modifier_item_pudge_heart_passive3 = class({})

function modifier_item_pudge_heart_passive3:IsHidden()
	return true
end

function modifier_item_pudge_heart_passive3:IsPurgable()
	return false
end

function modifier_item_pudge_heart_passive3:DestroyOnExpire()
	return false
end

function modifier_item_pudge_heart_passive3:OnCreated( kv )
    self.bonus_str = self:GetAbility():GetSpecialValueFor("bonus_str")
	if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_pudge_heart_passive3:OnDestroy()
	if IsServer() then
		self:GetCaster():InterruptChannel()
	end
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_pudge_heart_passive3:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
	}
	return funcs
end

function modifier_item_pudge_heart_passive3:GetModifierBonusStats_Strength( params )
	return self.bonus_str
end

-----------------------------------------------------------------------------------------------

modifier_item_pudge_heart_passive4 = class({})

function modifier_item_pudge_heart_passive4:IsHidden()
	return true
end

function modifier_item_pudge_heart_passive4:IsPurgable()
	return false
end

function modifier_item_pudge_heart_passive4:DestroyOnExpire()
	return false
end

function modifier_item_pudge_heart_passive4:OnCreated( kv )
    self.bonus_str = self:GetAbility():GetSpecialValueFor("bonus_str")
	if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_pudge_heart_passive4:OnDestroy()
	if IsServer() then
		self:GetCaster():InterruptChannel()
	end
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_pudge_heart_passive4:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
	}
	return funcs
end

function modifier_item_pudge_heart_passive4:GetModifierBonusStats_Strength( params )
	return self.bonus_str
end

-----------------------------------------------------------------------------------------------

modifier_item_pudge_heart_passive5 = class({})

function modifier_item_pudge_heart_passive5:IsHidden()
	return true
end

function modifier_item_pudge_heart_passive5:IsPurgable()
	return false
end

function modifier_item_pudge_heart_passive5:DestroyOnExpire()
	return false
end

function modifier_item_pudge_heart_passive5:OnCreated( kv )
    self.bonus_str = self:GetAbility():GetSpecialValueFor("bonus_str")
	if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_pudge_heart_passive5:OnDestroy()
	if IsServer() then
		self:GetCaster():InterruptChannel()
	end
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_pudge_heart_passive5:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
	}
	return funcs
end

function modifier_item_pudge_heart_passive5:GetModifierBonusStats_Strength( params )
	return self.bonus_str
end
