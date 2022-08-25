item_ethereal_blade_lua1_gem1 = item_ethereal_blade_lua1_gem1 or class({})
item_ethereal_blade_lua2_gem1 = item_ethereal_blade_lua1_gem1 or class({})
item_ethereal_blade_lua3_gem1 = item_ethereal_blade_lua1_gem1 or class({})
item_ethereal_blade_lua4_gem1 = item_ethereal_blade_lua1_gem1 or class({})
item_ethereal_blade_lua5_gem1 = item_ethereal_blade_lua1_gem1 or class({})
item_ethereal_blade_lua6_gem1 = item_ethereal_blade_lua1_gem1 or class({})
item_ethereal_blade_lua7_gem1 = item_ethereal_blade_lua1_gem1 or class({})

item_ethereal_blade_lua1_gem2 = item_ethereal_blade_lua1_gem2 or class({})
item_ethereal_blade_lua2_gem2 = item_ethereal_blade_lua1_gem2 or class({})
item_ethereal_blade_lua3_gem2 = item_ethereal_blade_lua1_gem2 or class({})
item_ethereal_blade_lua4_gem2 = item_ethereal_blade_lua1_gem2 or class({})
item_ethereal_blade_lua5_gem2 = item_ethereal_blade_lua1_gem2 or class({})
item_ethereal_blade_lua6_gem2 = item_ethereal_blade_lua1_gem2 or class({})
item_ethereal_blade_lua7_gem2 = item_ethereal_blade_lua1_gem2 or class({})

item_ethereal_blade_lua1_gem3 = item_ethereal_blade_lua1_gem3 or class({})
item_ethereal_blade_lua2_gem3 = item_ethereal_blade_lua1_gem3 or class({})
item_ethereal_blade_lua3_gem3 = item_ethereal_blade_lua1_gem3 or class({})
item_ethereal_blade_lua4_gem3 = item_ethereal_blade_lua1_gem3 or class({})
item_ethereal_blade_lua5_gem3 = item_ethereal_blade_lua1_gem3 or class({})
item_ethereal_blade_lua6_gem3 = item_ethereal_blade_lua1_gem3 or class({})
item_ethereal_blade_lua7_gem3 = item_ethereal_blade_lua1_gem3 or class({})

item_ethereal_blade_lua1_gem4 = item_ethereal_blade_lua1_gem4 or class({})
item_ethereal_blade_lua2_gem4 = item_ethereal_blade_lua1_gem4 or class({})
item_ethereal_blade_lua3_gem4 = item_ethereal_blade_lua1_gem4 or class({})
item_ethereal_blade_lua4_gem4 = item_ethereal_blade_lua1_gem4 or class({})
item_ethereal_blade_lua5_gem4 = item_ethereal_blade_lua1_gem4 or class({})
item_ethereal_blade_lua6_gem4 = item_ethereal_blade_lua1_gem4 or class({})
item_ethereal_blade_lua7_gem4 = item_ethereal_blade_lua1_gem4 or class({})

item_ethereal_blade_lua1_gem5 = item_ethereal_blade_lua1_gem5 or class({})
item_ethereal_blade_lua2_gem5 = item_ethereal_blade_lua1_gem5 or class({})
item_ethereal_blade_lua3_gem5 = item_ethereal_blade_lua1_gem5 or class({})
item_ethereal_blade_lua4_gem5 = item_ethereal_blade_lua1_gem5 or class({})
item_ethereal_blade_lua5_gem5 = item_ethereal_blade_lua1_gem5 or class({})
item_ethereal_blade_lua6_gem5 = item_ethereal_blade_lua1_gem5 or class({})
item_ethereal_blade_lua7_gem5 = item_ethereal_blade_lua1_gem5 or class({})

LinkLuaModifier("modifier_item_ethereal_blade_lua1", 'items/items_gems/item_ethereal_blade_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_ethereal_blade_lua2", 'items/items_gems/item_ethereal_blade_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_ethereal_blade_lua3", 'items/items_gems/item_ethereal_blade_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_ethereal_blade_lua4", 'items/items_gems/item_ethereal_blade_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_ethereal_blade_lua5", 'items/items_gems/item_ethereal_blade_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_ethereal_blade_ally", 'items/items_gems/item_ethereal_blade_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_ethereal_blade_enemy", 'items/items_gems/item_ethereal_blade_lua.lua', LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_gem1", 'items/items_gems/gem1', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem2", 'items/items_gems/gem2', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem3", 'items/items_gems/gem3', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem4", 'items/items_gems/gem4', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem5", 'items/items_gems/gem5', LUA_MODIFIER_MOTION_NONE)

function item_ethereal_blade_lua1_gem1:GetIntrinsicModifierName()
	return "modifier_item_ethereal_blade_lua1"
end

function item_ethereal_blade_lua1_gem2:GetIntrinsicModifierName()
	return "modifier_item_ethereal_blade_lua2"
end

function item_ethereal_blade_lua1_gem3:GetIntrinsicModifierName()
	return "modifier_item_ethereal_blade_lua3"
end

function item_ethereal_blade_lua1_gem4:GetIntrinsicModifierName()
	return "modifier_item_ethereal_blade_lua4"
end

function item_ethereal_blade_lua1_gem5:GetIntrinsicModifierName()
	return "modifier_item_ethereal_blade_lua5"
end

function item_ethereal_blade_lua1_gem1:OnSpellStart()
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
	local projectile =
			{
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

function item_ethereal_blade_lua1_gem1:OnProjectileHit(target, location)
	
	-- Check if a valid target has been hit
	if target and not target:IsMagicImmune() then

		-- Check for Linken's / Lotus Orb
		if target:TriggerSpellAbsorb(self) then return nil end
		
		-- Otherwise, play the sound...
		target:EmitSound("DOTA_Item.EtherealBlade.Target")
		
		-- ...apply the Ethereal modifier...
		if target:GetTeam() == self.caster:GetTeam() then
			target:AddNewModifier(self.caster, self, "modifier_item_ethereal_blade_ally", {duration = self.duration_ally})
		else
			target:AddNewModifier(self.caster, self, "modifier_item_ethereal_blade_enemy", {duration = self.duration * (1 - target:GetStatusResistance())})
						
			-- ...apply the damage if it's an enemy...
			local damageTable = {
				victim 			= target,
				damage 			= self.caster:GetPrimaryStatValue() * self.blast_agility_multiplier + self.blast_damage_base,
				damage_type		= DAMAGE_TYPE_MAGICAL,
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= self.caster,
				ability 		= self
			}
									
			ApplyDamage(damageTable)		
		end
	end
end	

function item_ethereal_blade_lua1_gem2:OnSpellStart()
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
	local projectile =
			{
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

function item_ethereal_blade_lua1_gem2:OnProjectileHit(target, location)
	
	-- Check if a valid target has been hit
	if target and not target:IsMagicImmune() then

		-- Check for Linken's / Lotus Orb
		if target:TriggerSpellAbsorb(self) then return nil end
		
		-- Otherwise, play the sound...
		target:EmitSound("DOTA_Item.EtherealBlade.Target")
		
		-- ...apply the Ethereal modifier...
		if target:GetTeam() == self.caster:GetTeam() then
			target:AddNewModifier(self.caster, self, "modifier_item_ethereal_blade_ally", {duration = self.duration_ally})
		else
			target:AddNewModifier(self.caster, self, "modifier_item_ethereal_blade_enemy", {duration = self.duration * (1 - target:GetStatusResistance())})
						
			-- ...apply the damage if it's an enemy...
			local damageTable = {
				victim 			= target,
				damage 			= self.caster:GetPrimaryStatValue() * self.blast_agility_multiplier + self.blast_damage_base,
				damage_type		= DAMAGE_TYPE_MAGICAL,
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= self.caster,
				ability 		= self
			}
									
			ApplyDamage(damageTable)		
		end
	end
end	

function item_ethereal_blade_lua1_gem3:OnSpellStart()
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
	local projectile =
			{
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

function item_ethereal_blade_lua1_gem3:OnProjectileHit(target, location)
	
	-- Check if a valid target has been hit
	if target and not target:IsMagicImmune() then

		-- Check for Linken's / Lotus Orb
		if target:TriggerSpellAbsorb(self) then return nil end
		
		-- Otherwise, play the sound...
		target:EmitSound("DOTA_Item.EtherealBlade.Target")
		
		-- ...apply the Ethereal modifier...
		if target:GetTeam() == self.caster:GetTeam() then
			target:AddNewModifier(self.caster, self, "modifier_item_ethereal_blade_ally", {duration = self.duration_ally})
		else
			target:AddNewModifier(self.caster, self, "modifier_item_ethereal_blade_enemy", {duration = self.duration * (1 - target:GetStatusResistance())})
						
			-- ...apply the damage if it's an enemy...
			local damageTable = {
				victim 			= target,
				damage 			= self.caster:GetPrimaryStatValue() * self.blast_agility_multiplier + self.blast_damage_base,
				damage_type		= DAMAGE_TYPE_MAGICAL,
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= self.caster,
				ability 		= self
			}
									
			ApplyDamage(damageTable)		
		end
	end
end	

function item_ethereal_blade_lua1_gem4:OnSpellStart()
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
	local projectile =
			{
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

function item_ethereal_blade_lua1_gem4:OnProjectileHit(target, location)
	
	-- Check if a valid target has been hit
	if target and not target:IsMagicImmune() then

		-- Check for Linken's / Lotus Orb
		if target:TriggerSpellAbsorb(self) then return nil end
		
		-- Otherwise, play the sound...
		target:EmitSound("DOTA_Item.EtherealBlade.Target")
		
		-- ...apply the Ethereal modifier...
		if target:GetTeam() == self.caster:GetTeam() then
			target:AddNewModifier(self.caster, self, "modifier_item_ethereal_blade_ally", {duration = self.duration_ally})
		else
			target:AddNewModifier(self.caster, self, "modifier_item_ethereal_blade_enemy", {duration = self.duration * (1 - target:GetStatusResistance())})
						
			-- ...apply the damage if it's an enemy...
			local damageTable = {
				victim 			= target,
				damage 			= self.caster:GetPrimaryStatValue() * self.blast_agility_multiplier + self.blast_damage_base,
				damage_type		= DAMAGE_TYPE_MAGICAL,
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= self.caster,
				ability 		= self
			}
									
			ApplyDamage(damageTable)		
		end
	end
end	

function item_ethereal_blade_lua1_gem5:OnSpellStart()
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
	local projectile =
			{
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

function item_ethereal_blade_lua1_gem5:OnProjectileHit(target, location)
	
	-- Check if a valid target has been hit
	if target and not target:IsMagicImmune() then

		-- Check for Linken's / Lotus Orb
		if target:TriggerSpellAbsorb(self) then return nil end
		
		-- Otherwise, play the sound...
		target:EmitSound("DOTA_Item.EtherealBlade.Target")
		
		-- ...apply the Ethereal modifier...
		if target:GetTeam() == self.caster:GetTeam() then
			target:AddNewModifier(self.caster, self, "modifier_item_ethereal_blade_ally", {duration = self.duration_ally})
		else
			target:AddNewModifier(self.caster, self, "modifier_item_ethereal_blade_enemy", {duration = self.duration * (1 - target:GetStatusResistance())})
						
			-- ...apply the damage if it's an enemy...
			local damageTable = {
				victim 			= target,
				damage 			= self.caster:GetPrimaryStatValue() * self.blast_agility_multiplier + self.blast_damage_base,
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

modifier_item_ethereal_blade_lua1 = class({})

function modifier_item_ethereal_blade_lua1:IsHidden()
	return true
end

function modifier_item_ethereal_blade_lua1:IsPurgable()
	return false
end

function modifier_item_ethereal_blade_lua1:RemoveOnDeath()	
	return false 
end

function modifier_item_ethereal_blade_lua1:OnCreated()
	
	
	self.bonus_strength = self:GetAbility():GetSpecialValueFor("bonus_strength")
	self.bonus_agility = self:GetAbility():GetSpecialValueFor("bonus_agility")
	self.bonus_intellect = self:GetAbility():GetSpecialValueFor("bonus_intellect")
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 

end
function modifier_item_ethereal_blade_lua1:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_ethereal_blade_lua1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
		
		
	}
end

function modifier_item_ethereal_blade_lua1:GetModifierBonusStats_Strength()
	return self.bonus_strength
end

function modifier_item_ethereal_blade_lua1:GetModifierBonusStats_Agility()
	return self.bonus_agility
end

function modifier_item_ethereal_blade_lua1:GetModifierBonusStats_Intellect()
	return self.bonus_intellect
end

----------------------------------------------------------------------------------

modifier_item_ethereal_blade_lua2 = class({})

function modifier_item_ethereal_blade_lua2:IsHidden()
	return true
end

function modifier_item_ethereal_blade_lua2:IsPurgable()
	return false
end

function modifier_item_ethereal_blade_lua2:RemoveOnDeath()	
	return false 
end

function modifier_item_ethereal_blade_lua2:OnCreated()
	
	
	self.bonus_strength = self:GetAbility():GetSpecialValueFor("bonus_strength")
	self.bonus_agility = self:GetAbility():GetSpecialValueFor("bonus_agility")
	self.bonus_intellect = self:GetAbility():GetSpecialValueFor("bonus_intellect")
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 

end
function modifier_item_ethereal_blade_lua2:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_ethereal_blade_lua2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
		
		
	}
end

function modifier_item_ethereal_blade_lua2:GetModifierBonusStats_Strength()
	return self.bonus_strength
end

function modifier_item_ethereal_blade_lua2:GetModifierBonusStats_Agility()
	return self.bonus_agility
end

function modifier_item_ethereal_blade_lua2:GetModifierBonusStats_Intellect()
	return self.bonus_intellect
end

----------------------------------------------------------------------------------

modifier_item_ethereal_blade_lua3 = class({})

function modifier_item_ethereal_blade_lua3:IsHidden()
	return true
end

function modifier_item_ethereal_blade_lua3:IsPurgable()
	return false
end

function modifier_item_ethereal_blade_lua3:RemoveOnDeath()	
	return false 
end

function modifier_item_ethereal_blade_lua3:OnCreated()
	
	
	self.bonus_strength = self:GetAbility():GetSpecialValueFor("bonus_strength")
	self.bonus_agility = self:GetAbility():GetSpecialValueFor("bonus_agility")
	self.bonus_intellect = self:GetAbility():GetSpecialValueFor("bonus_intellect")
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 

end
function modifier_item_ethereal_blade_lua3:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_ethereal_blade_lua3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
		
		
	}
end

function modifier_item_ethereal_blade_lua3:GetModifierBonusStats_Strength()
	return self.bonus_strength
end

function modifier_item_ethereal_blade_lua3:GetModifierBonusStats_Agility()
	return self.bonus_agility
end

function modifier_item_ethereal_blade_lua3:GetModifierBonusStats_Intellect()
	return self.bonus_intellect
end

----------------------------------------------------------------------------------

modifier_item_ethereal_blade_lua4 = class({})

function modifier_item_ethereal_blade_lua4:IsHidden()
	return true
end

function modifier_item_ethereal_blade_lua4:IsPurgable()
	return false
end

function modifier_item_ethereal_blade_lua4:RemoveOnDeath()	
	return false 
end

function modifier_item_ethereal_blade_lua4:OnCreated()
	
	
	self.bonus_strength = self:GetAbility():GetSpecialValueFor("bonus_strength")
	self.bonus_agility = self:GetAbility():GetSpecialValueFor("bonus_agility")
	self.bonus_intellect = self:GetAbility():GetSpecialValueFor("bonus_intellect")
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 

end
function modifier_item_ethereal_blade_lua4:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_ethereal_blade_lua4:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
		
		
	}
end

function modifier_item_ethereal_blade_lua4:GetModifierBonusStats_Strength()
	return self.bonus_strength
end

function modifier_item_ethereal_blade_lua4:GetModifierBonusStats_Agility()
	return self.bonus_agility
end

function modifier_item_ethereal_blade_lua4:GetModifierBonusStats_Intellect()
	return self.bonus_intellect
end

----------------------------------------------------------------------------------

modifier_item_ethereal_blade_lua5 = class({})

function modifier_item_ethereal_blade_lua5:IsHidden()
	return true
end

function modifier_item_ethereal_blade_lua5:IsPurgable()
	return false
end

function modifier_item_ethereal_blade_lua5:RemoveOnDeath()	
	return false 
end

function modifier_item_ethereal_blade_lua5:OnCreated()
	
	
	self.bonus_strength = self:GetAbility():GetSpecialValueFor("bonus_strength")
	self.bonus_agility = self:GetAbility():GetSpecialValueFor("bonus_agility")
	self.bonus_intellect = self:GetAbility():GetSpecialValueFor("bonus_intellect")
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 

end
function modifier_item_ethereal_blade_lua5:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_ethereal_blade_lua5:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
		
		
	}
end

function modifier_item_ethereal_blade_lua5:GetModifierBonusStats_Strength()
	return self.bonus_strength
end

function modifier_item_ethereal_blade_lua5:GetModifierBonusStats_Agility()
	return self.bonus_agility
end

function modifier_item_ethereal_blade_lua5:GetModifierBonusStats_Intellect()
	return self.bonus_intellect
end