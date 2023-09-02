item_ethereal_blade_lua = class({})

item_ethereal_blade_lua1 = item_ethereal_blade_lua
item_ethereal_blade_lua2 = item_ethereal_blade_lua
item_ethereal_blade_lua3 = item_ethereal_blade_lua
item_ethereal_blade_lua4 = item_ethereal_blade_lua
item_ethereal_blade_lua5 = item_ethereal_blade_lua
item_ethereal_blade_lua6 = item_ethereal_blade_lua
item_ethereal_blade_lua7 = item_ethereal_blade_lua
item_ethereal_blade_lua8 = item_ethereal_blade_lua

item_ethereal_blade_lua1_gem1 = item_ethereal_blade_lua
item_ethereal_blade_lua2_gem1 = item_ethereal_blade_lua
item_ethereal_blade_lua3_gem1 = item_ethereal_blade_lua
item_ethereal_blade_lua4_gem1 = item_ethereal_blade_lua
item_ethereal_blade_lua5_gem1 = item_ethereal_blade_lua
item_ethereal_blade_lua6_gem1 = item_ethereal_blade_lua
item_ethereal_blade_lua7_gem1 = item_ethereal_blade_lua
item_ethereal_blade_lua8_gem1 = item_ethereal_blade_lua

item_ethereal_blade_lua1_gem2 = item_ethereal_blade_lua
item_ethereal_blade_lua2_gem2 = item_ethereal_blade_lua
item_ethereal_blade_lua3_gem2 = item_ethereal_blade_lua
item_ethereal_blade_lua4_gem2 = item_ethereal_blade_lua
item_ethereal_blade_lua5_gem2 = item_ethereal_blade_lua
item_ethereal_blade_lua6_gem2 = item_ethereal_blade_lua
item_ethereal_blade_lua7_gem2 = item_ethereal_blade_lua
item_ethereal_blade_lua8_gem2 = item_ethereal_blade_lua

item_ethereal_blade_lua1_gem3 = item_ethereal_blade_lua
item_ethereal_blade_lua2_gem3 = item_ethereal_blade_lua
item_ethereal_blade_lua3_gem3 = item_ethereal_blade_lua
item_ethereal_blade_lua4_gem3 = item_ethereal_blade_lua
item_ethereal_blade_lua5_gem3 = item_ethereal_blade_lua
item_ethereal_blade_lua6_gem3 = item_ethereal_blade_lua
item_ethereal_blade_lua7_gem3 = item_ethereal_blade_lua
item_ethereal_blade_lua8_gem3 = item_ethereal_blade_lua

item_ethereal_blade_lua1_gem4 = item_ethereal_blade_lua
item_ethereal_blade_lua2_gem4 = item_ethereal_blade_lua
item_ethereal_blade_lua3_gem4 = item_ethereal_blade_lua
item_ethereal_blade_lua4_gem4 = item_ethereal_blade_lua
item_ethereal_blade_lua5_gem4 = item_ethereal_blade_lua
item_ethereal_blade_lua6_gem4 = item_ethereal_blade_lua
item_ethereal_blade_lua7_gem4 = item_ethereal_blade_lua
item_ethereal_blade_lua8_gem4 = item_ethereal_blade_lua

item_ethereal_blade_lua1_gem5 = item_ethereal_blade_lua
item_ethereal_blade_lua2_gem5 = item_ethereal_blade_lua
item_ethereal_blade_lua3_gem5 = item_ethereal_blade_lua
item_ethereal_blade_lua4_gem5 = item_ethereal_blade_lua
item_ethereal_blade_lua5_gem5 = item_ethereal_blade_lua
item_ethereal_blade_lua6_gem5 = item_ethereal_blade_lua
item_ethereal_blade_lua7_gem5 = item_ethereal_blade_lua
item_ethereal_blade_lua8_gem5 = item_ethereal_blade_lua

LinkLuaModifier("modifier_item_ethereal_blade_lua", 'items/custom_items/item_ethereal_blade_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_ethereal_blade_ally", 'items/custom_items/item_ethereal_blade_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_ethereal_blade_enemy", 'items/custom_items/item_ethereal_blade_lua.lua', LUA_MODIFIER_MOTION_NONE)

function item_ethereal_blade_lua:GetIntrinsicModifierName()
	return "modifier_item_ethereal_blade_lua"
end

function item_ethereal_blade_lua:OnSpellStart()
	self.caster		= self:GetCaster()
	
	-- AbilitySpecials
	self.blast_movement_slow		=	self:GetSpecialValueFor("blast_movement_slow")
	self.duration					=	self:GetSpecialValueFor("duration")
	self.blast_agility_multiplier	=	self:GetSpecialValueFor("blast_agility_multiplier")

	self.blast_damage_base			=	self:GetSpecialValueFor("blast_damage_base")
	self.duration_ally				=	self:GetSpecialValueFor("duration_ally")
	self.ethereal_damage_bonus		=	self:GetSpecialValueFor("ethereal_damage_bonus")
	self.projectile_speed			=	self:GetSpecialValueFor("projectile_speed")
	self.tooltip_range				=	800
	
	if not IsServer() then return end
	
	local target			= self:GetCursorTarget()
	
	-- Play the cast sound
	self.caster:EmitSound("DOTA_Item.EtherealBlade.Activate")

	-- Fire the projectile
	local projectile = {
		Target 				= target,
		Source 				= self.caster,
		Ability 			= self,
		EffectName 			= "particles/items_fx/ethereal_blade.vpcf",
		iMoveSpeed			= self.projectile_speed,
		vSourceLoc 			= caster_location,
		bDrawsOnMinimap 	= false,
		bDodgeable 			= true,
		bIsAttack 			= false,
		bVisibleToEnemies 	= true,
		bReplaceExisting 	= false,
		flExpireTime 		= GameRules:GetGameTime() + 20,
		bProvidesVision 	= false,
	}	
	ProjectileManager:CreateTrackingProjectile(projectile)
end

function item_ethereal_blade_lua1:OnProjectileHit(target, location)
	if not IsServer() then return end
	if target and not target:IsMagicImmune() then
		if target:TriggerSpellAbsorb(self) then return nil end
		target:EmitSound("DOTA_Item.EtherealBlade.Target")

		if target:GetTeam() == self.caster:GetTeam() then
			target:AddNewModifier(self.caster, self, "modifier_item_ethereal_blade_ally", {duration = self.duration_ally})
		else
			target:AddNewModifier(self.caster, self, "modifier_item_ethereal_blade_enemy", {duration = self.duration * (1 - target:GetStatusResistance())})
			
			attr = 10000
			if self.caster:IsRealHero() then 
				attr = self.caster:GetPrimaryStatValue()
			end
			
			local damageTable = {
				victim 			= target,
				damage 			= attr * self.blast_agility_multiplier + self.blast_damage_base,
				damage_type		= DAMAGE_TYPE_MAGICAL,
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= self.caster,
				ability 		= self
			}
									
			ApplyDamage(damageTable)		
		end
	end
end	

----------------------------------------------------------------------------------

modifier_item_ethereal_blade_enemy = class({})

function modifier_item_ethereal_blade_enemy:GetStatusEffectName()
	return "particles/status_fx/status_effect_ghost.vpcf"
end

function modifier_item_ethereal_blade_enemy:OnCreated()
	self.ethereal_damage_bonus		= self:GetAbility():GetSpecialValueFor("ethereal_damage_bonus")
end

function modifier_item_ethereal_blade_enemy:CheckState()
	local state = {
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_DISARMED] = true
	}
	
	return state
end

function modifier_item_ethereal_blade_enemy:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DECREPIFY_UNIQUE,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		
		-- IMBAfication: Extrasensory
		MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
	}
end

function modifier_item_ethereal_blade_enemy:GetModifierMagicalResistanceDecrepifyUnique()
    return self.ethereal_damage_bonus
end

function modifier_item_ethereal_blade_enemy:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_item_ethereal_blade_enemy:GetModifierIgnoreCastAngle()
	if self:GetParent():GetTeam() == self:GetCaster():GetTeam() then
		return 1
	end
end

function modifier_item_ethereal_blade_enemy:GetModifierMoveSpeed_Absolute()
	return 100
end
----------------------------------------------------------------------------------
modifier_item_ethereal_blade_ally = class({})

function modifier_item_ethereal_blade_ally:GetStatusEffectName()
	return "particles/status_fx/status_effect_ghost.vpcf"
end

function modifier_item_ethereal_blade_ally:OnCreated()
	self.ethereal_damage_bonus		= self:GetAbility():GetSpecialValueFor("ethereal_damage_bonus")
end

function modifier_item_ethereal_blade_ally:CheckState()
	local state = {
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_DISARMED] = true
	}
	
	return state
end

function modifier_item_ethereal_blade_ally:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DECREPIFY_UNIQUE,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		
		-- IMBAfication: Extrasensory
		MODIFIER_PROPERTY_IGNORE_CAST_ANGLE
	}
end

function modifier_item_ethereal_blade_ally:GetModifierMagicalResistanceDecrepifyUnique()
    return self.ethereal_damage_bonus
end

function modifier_item_ethereal_blade_ally:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_item_ethereal_blade_ally:GetModifierIgnoreCastAngle()
	if self:GetParent():GetTeam() == self:GetCaster():GetTeam() then
		return 1
	end
end
----------------------------------------------------------------------------------

modifier_item_ethereal_blade_lua = class({})

function modifier_item_ethereal_blade_lua:IsHidden()
	return true
end

function modifier_item_ethereal_blade_lua:IsPurgable()
	return false
end

function modifier_item_ethereal_blade_lua:RemoveOnDeath()	
	return false 
end

function modifier_item_ethereal_blade_lua:OnCreated()
	self.parent = self:GetParent()
	self.bonus_strength = self:GetAbility():GetSpecialValueFor("bonus_strength")
	self.bonus_agility = self:GetAbility():GetSpecialValueFor("bonus_agility")
	self.bonus_intellect = self:GetAbility():GetSpecialValueFor("bonus_intellect")
	if not IsServer() then
		return
	end
	self.value = self:GetAbility():GetSpecialValueFor("bonus_gem")
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {value = self.value})
	end
end

function modifier_item_ethereal_blade_lua:OnDestroy()
	if not IsServer() then
		return
	end
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {value = self.value * -1})
	end
end

function modifier_item_ethereal_blade_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
		
		
	}
end

function modifier_item_ethereal_blade_lua:GetModifierBonusStats_Strength()
	return self.bonus_strength
end

function modifier_item_ethereal_blade_lua:GetModifierBonusStats_Agility()
	return self.bonus_agility
end

function modifier_item_ethereal_blade_lua:GetModifierBonusStats_Intellect()
	return self.bonus_intellect
end