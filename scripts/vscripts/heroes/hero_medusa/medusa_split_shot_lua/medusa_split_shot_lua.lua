medusa_split_shot_lua = class({})
LinkLuaModifier( "modifier_medusa_split_shot_lua", "heroes/hero_medusa/medusa_split_shot_lua/medusa_split_shot_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_medusa_slow", "heroes/hero_medusa/medusa_split_shot_lua/medusa_split_shot_lua", LUA_MODIFIER_MOTION_NONE )


function medusa_split_shot_lua:OnOwnerSpawned()
	if self.toggle_state then
		self:ToggleAbility()
	end
end

function medusa_split_shot_lua:OnOwnerDied()
	self.toggle_state = self:GetToggleState()
end

function medusa_split_shot_lua:OnToggle()
	if not IsServer() then return end
	
	if self:GetToggleState() then
		-- self:GetCaster():EmitSound("Hero_Medusa.ManaShield.On")
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_medusa_split_shot_lua", {})
	else
		-- self:GetCaster():EmitSound("Hero_Medusa.ManaShield.Off")
		self:GetCaster():RemoveModifierByNameAndCaster("modifier_medusa_split_shot_lua", self:GetCaster())
	end
	
end

function medusa_split_shot_lua:OnProjectileHit( target, location )
	if not target then return end

	-- perform attack
	self.split_shot_attack = true
	self:GetCaster():PerformAttack(
		target, -- hTarget
		false, -- bUseCastAttackOrb
		false, -- bProcessProcs
		true, -- bSkipCooldown
		false, -- bIgnoreInvis
		false, -- bUseProjectile
		false, -- bFakeAttack
		false -- bNeverMiss
	)
	self.split_shot_attack = false
end


-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------

modifier_medusa_split_shot_lua = class({})

function modifier_medusa_split_shot_lua:IsHidden()
	return true
end

function modifier_medusa_split_shot_lua:IsPurgable()
	return false
end

function modifier_medusa_split_shot_lua:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

function modifier_medusa_split_shot_lua:OnCreated( kv )
	self.reduction = self:GetAbility():GetSpecialValueFor( "damage_modifier" )
	self.count = self:GetAbility():GetSpecialValueFor( "arrow_count" )
	self.bonus_range = self:GetAbility():GetSpecialValueFor( "split_shot_bonus_range" )

	
	self.use_modifier = false
	
	if not IsServer() then return end
	self.projectile_name = self:GetParent():GetRangedProjectileName()
	self.projectile_speed = self:GetParent():GetProjectileSpeed()
end

function modifier_medusa_split_shot_lua:OnRefresh( kv )
	-- references
	self.reduction = self:GetAbility():GetSpecialValueFor( "damage_modifier" )
	self.count = self:GetAbility():GetSpecialValueFor( "arrow_count" )
	self.bonus_range = self:GetAbility():GetSpecialValueFor( "split_shot_bonus_range" )
end

function modifier_medusa_split_shot_lua:OnRemoved()
end

function modifier_medusa_split_shot_lua:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_medusa_split_shot_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_medusa_split_shot_lua:OnAttack( params )
	if not IsServer() then return end
	if params.attacker~=self:GetParent() then return end

	-- not proc for instant attacks
	if params.no_attack_cooldown then return end

	-- not proc for attacking allies
	if params.target:GetTeamNumber()==params.attacker:GetTeamNumber() then return end

	-- not proc if break
	if self:GetParent():PassivesDisabled() then return end

	-- not proc if attack can't use attack modifiers
	if not params.process_procs then return end

	-- not proc on split shot attacks, even if it can use attack modifier, to avoid endless recursive call and crash
	if self.split_shot then return end
	
	self.use_modifier = false
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_medusa_agi11")
	if abil ~= nil then 
	self.use_modifier = true
	end
	
	
	if self.use_modifier then
		self:SplitShotModifier( params.target )
	else
		self:SplitShotNoModifier( params.target )
	end
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_medusa_str10")
	if abil ~= nil then 
			params.target:AddNewModifier(
					params.attacker, -- player source
					self, -- ability source
					"modifier_medusa_slow", -- modifier name
					{
						duration = 1
					}
				)
	end
end

function modifier_medusa_split_shot_lua:GetModifierDamageOutgoing_Percentage()
	local val = self.reduction
	if self:GetCaster():FindAbilityByName("npc_dota_hero_medusa_agi10") then
		val = 100
	end
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_medusa_agi50")then
		val = val + 100
	end
	if self:GetAbility():GetToggleState() then
		return val
	end
	return 0
end

--------------------------------------------------------------------------------
function modifier_medusa_split_shot_lua:SplitShotModifier( target )
	-- get radius
	local radius = self:GetParent():Script_GetAttackRange() + self.bonus_range

	-- find other target units
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_COURIER,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_medusa_agi9")                   
	if abil ~= nil then 
		self.count = 4
	end

	local abil = self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_medusa_agi50")                   
	if abil ~= nil then 
		self.count = self.count + 2
	end

	local count = 0
	for _,enemy in pairs(enemies) do
		-- not target itself
		if enemy~=target then
		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_medusa_str10")
		if abil ~= nil then 
				enemy:AddNewModifier(
						self:GetCaster(), -- player source
						self, -- ability source
						"modifier_medusa_slow", -- modifier name
						{
							duration = 1
						}
					)
		end

			-- perform attack
			self.split_shot = true
			self:GetParent():PerformAttack(
				enemy, -- hTarget
				false, -- bUseCastAttackOrb
				self.use_modifier, -- bProcessProcs
				true, -- bSkipCooldown
				false, -- bIgnoreInvis
				true, -- bUseProjectile
				false, -- bFakeAttack
				false -- bNeverMiss
			)
			self.split_shot = false

			count = count + 1
			if count>=self.count then break end
		end
	end

	-- play effects if splitshot
	if count>0 then
		local sound_cast = "Hero_Medusa.AttackSplit"
		EmitSoundOn( sound_cast, self:GetParent() )
	end
end

function modifier_medusa_split_shot_lua:SplitShotNoModifier( target )
	-- get radius
	local radius = self:GetParent():Script_GetAttackRange() + self.bonus_range

	-- find other target units
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_COURIER,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_medusa_agi9")                   
	if abil ~= nil then 
		self.count = 5
	end

	local abil = self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_medusa_agi50")                   
	if abil ~= nil then 
		self.count = self.count + 2
	end

	local count = 0
	for _,enemy in pairs(enemies) do
		-- not target itself
		if enemy~=target then
			-- launch projectile
			
			local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_medusa_str10")
			if abil ~= nil then 
					enemy:AddNewModifier(
							self:GetCaster(), -- player source
							self, -- ability source
							"modifier_medusa_slow", -- modifier name
							{
								duration = 1
							}
						)
			end
		
			local info = {
				Target = enemy,
				Source = self:GetParent(),
				Ability = self:GetAbility(),	
				
				EffectName = self.projectile_name, --"particles/econ/items/medusa/medusa_ti10_immortal_tail/medusa_ti10_projectile.vpcf",
				iMoveSpeed = self.projectile_speed,
				bDodgeable = true,                           -- Optional
				-- bIsAttack = true,                                -- Optional
			}
			ProjectileManager:CreateTrackingProjectile(info)

			count = count + 1
			if count>=self.count then break end
		end
	end

	-- play effects if splitshot
	if count>0 then
		local sound_cast = "Hero_Medusa.AttackSplit"
		EmitSoundOn( sound_cast, self:GetParent() )
	end
end


----------------------------------------------------------------------
modifier_medusa_slow = class({})

--------------------------------------------------------------------------------
function modifier_medusa_slow:IsHidden()
	return true
end

function modifier_medusa_slow:IsPurgable()
	return false
end

function modifier_medusa_slow:OnCreated( kv )
end

function modifier_medusa_slow:OnRefresh( kv )
end

function modifier_medusa_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

function modifier_medusa_slow:GetModifierMoveSpeedBonus_Percentage()
	return -300
end