item_bfury_lua = class({})

LinkLuaModifier("modifier_item_bfury_lua", 'items/custom_items/item_bfury_lua.lua', LUA_MODIFIER_MOTION_NONE)

modifier_item_bfury_lua = class({})

function item_bfury_lua:GetIntrinsicModifierName()
	return "modifier_item_bfury_lua"
end

function modifier_item_bfury_lua:IsHidden()
	return true
end

function modifier_item_bfury_lua:IsPurgable()
	return false
end

function modifier_item_bfury_lua:DestroyOnExpire()
	return false
end

function modifier_item_bfury_lua:RemoveOnDeath()	
	return false 
end

function modifier_item_bfury_lua:OnCreated()
	self.parent = self:GetParent()
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_health_regen = self:GetAbility():GetSpecialValueFor("bonus_health_regen")
	self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
	self.cleave_damage_percent = self:GetAbility():GetSpecialValueFor("cleave_damage_percent")
	self.cleave_ending_width = self:GetAbility():GetSpecialValueFor("cleave_ending_width")
	self.quelling_bonus = self:GetAbility():GetSpecialValueFor("quelling_bonus")
	self.quelling_bonus_ranged = self:GetAbility():GetSpecialValueFor("quelling_bonus_ranged")
	if not IsServer() then
		return
	end
	self.value = self:GetAbility():GetSpecialValueFor("bonus_gem")
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {value = self.value})
	end
end

function modifier_item_bfury_lua:OnDestroy()
	if not IsServer() then
		return
	end
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {value = self.value * -1})
	end
end

function modifier_item_bfury_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_item_bfury_lua:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end

function modifier_item_bfury_lua:GetModifierConstantHealthRegen()
	return self.bonus_health_regen
end

function modifier_item_bfury_lua:GetModifierPreAttack_BonusDamage(keys)
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

function modifier_item_bfury_lua:OnAttackLanded(keys)
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
				if not enemy:HasModifier("modifier_item_bfury_lua_debuff") then
					enemy:AddNewModifier(self:GetParent(), item, "modifier_item_bfury_lua_debuff", {duration = 5})
				end
			end
			ApplyDamage({victim = enemy, attacker = self:GetParent(), damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
		end
	end
	self:PlayEffects1(direction )
end

function modifier_item_bfury_lua:PlayEffects1(direction )
	local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

--------------------дерево

function item_bfury_lua:OnSpellStart()
	local caster = self:GetCaster()
	local target_point = self:GetCursorPosition()
	GridNav:DestroyTreesAroundPoint(target_point, 1, false)
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function check_desolator(target)
local desolator_dict = { 
	["modifier_item_desolator_lua"] = 7,
	["modifier_item_desolator_lua_2"] = 15,
	["modifier_item_desolator_lua_3"] = 20,
	["modifier_item_desolator_lua_4"] = 40,
	["modifier_item_desolator_lua_5"] = 80,
	["modifier_item_desolator_lua_6"] = 120,
	["modifier_item_desolator_lua_7"] = 200,
	["modifier_item_desolator_lua_8"] = 300,
	}
	
	for key,val in pairs(desolator_dict) do
		local modifier = target:FindModifierByName(key)
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

LinkLuaModifier("modifier_item_bfury_lua_debuff", 'items/custom_items/item_bfury_lua.lua', LUA_MODIFIER_MOTION_NONE)

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