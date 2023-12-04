LinkLuaModifier("modifier_gyrocopter_flak_cannon_lua", "heroes/hero_gyrocopter/gyrocopter_flak_cannon_lua/gyrocopter_flak_cannon_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gyrocopter_flak_cannon_lua_resist", "heroes/hero_gyrocopter/gyrocopter_flak_cannon_lua/gyrocopter_flak_cannon_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gyrocopter_flak_cannon_lua_armor", "heroes/hero_gyrocopter/gyrocopter_flak_cannon_lua/gyrocopter_flak_cannon_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gyrocopter_flak_cannon_lua_side_gunner", "heroes/hero_gyrocopter/gyrocopter_flak_cannon_lua/gyrocopter_flak_cannon_lua", LUA_MODIFIER_MOTION_NONE)


modifier_gyrocopter_flak_cannon_lua_side_gunner	= modifier_gyrocopter_flak_cannon_lua_side_gunner or class({})

-------------------------------------------------------------------------------------------

gyrocopter_flak_cannon_lua = gyrocopter_flak_cannon_lua or class({})

function gyrocopter_flak_cannon_lua:GetManaCost(iLevel)
    -- local caster = self:GetCaster()
    -- if caster then
    --     return math.min(65000, caster:GetIntellect())
    -- end
	return 0
end


function gyrocopter_flak_cannon_lua:GetIntrinsicModifierName()
	return "modifier_gyrocopter_flak_cannon_lua_side_gunner"
end

function gyrocopter_flak_cannon_lua:OnSpellStart()
	self.max_attacks = self:GetSpecialValueFor("max_attacks")

	if self:GetCaster():FindAbilityByName("npc_dota_hero_gyrocopter_int9") ~= nil then 
		self.max_attacks = self:GetSpecialValueFor("max_attacks") + 12
	end	

	self:GetCaster():EmitSound("Hero_Gyrocopter.FlackCannon.Activate")
	self:GetCaster():RemoveModifierByName("modifier_gyrocopter_flak_cannon_lua")
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_gyrocopter_flak_cannon_lua", {duration = self:GetDuration()}):SetStackCount(self.max_attacks)
end

------------------------------------------

modifier_gyrocopter_flak_cannon_lua = modifier_gyrocopter_flak_cannon_lua or class({})

function modifier_gyrocopter_flak_cannon_lua:GetEffectName()
	return "particles/units/heroes/hero_gyrocopter/gyro_flak_cannon_overhead.vpcf"
end

function modifier_gyrocopter_flak_cannon_lua:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_gyrocopter_flak_cannon_lua:OnCreated()
	self.radius				= self:GetAbility():GetSpecialValueFor("radius")
	self.max_targets		= self:GetAbility():GetSpecialValueFor("max_targets")
	self.projectile_speed	= self:GetAbility():GetSpecialValueFor("projectile_speed")
	self.fresh_rounds		= 2

	if self:GetCaster():FindAbilityByName("npc_dota_hero_gyrocopter_agi6") ~= nil then 
		self.radius = self:GetAbility():GetSpecialValueFor("radius")+200
	end	
	
	if not IsServer() then return end
	self.weapons = {"attach_attack1", "attach_attack2"}
end

function modifier_gyrocopter_flak_cannon_lua:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK}
end

function modifier_gyrocopter_flak_cannon_lua:OnAttack(keys)
	count = 0
	if keys.attacker == self:GetParent() and not self:GetParent():PassivesDisabled() and not keys.no_attack_cooldown then
		self:GetParent():EmitSound("Hero_Gyrocopter.FlackCannon")
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
		local count = 0
		for _,enemy in pairs(enemies) do
			if self:GetCaster():FindAbilityByName("npc_dota_hero_gyrocopter_int6") ~= nil then 
				enemy:AddNewModifier( self:GetCaster(), self, "modifier_gyrocopter_flak_cannon_lua_resist", { duration = 5 } )
			end
			if self:GetCaster():FindAbilityByName("npc_dota_hero_gyrocopter_agi9") ~= nil then 
				enemy:AddNewModifier( self:GetCaster(), self, "modifier_gyrocopter_flak_cannon_lua_armor", { duration = 5 } )
			end
			if enemy~=keys.target then
				self:GetParent():PerformAttack( enemy, true, true, true, false, true, false, false)

				if self:GetCaster():FindAbilityByName("npc_dota_hero_gyrocopter_int_last") ~= nil and not enemy:IsMagicImmune() and not enemy:IsBuilding() then 
					ApplyDamage({
						victim 			= enemy,
						damage 			= self:GetCaster():GetIntellect(),
						damage_type		= DAMAGE_TYPE_MAGICAL,
						damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
						attacker 		= self:GetCaster(),
					})
				end
				
				-- count = count + 1
				-- if count>=7 then break end
			end
		end

		if self:GetCaster():FindAbilityByName("npc_dota_hero_gyrocopter_int_last") ~= nil and not enemy:IsMagicImmune() and not enemy:IsBuilding() then 
			ApplyDamage({
				victim 			= keys.target,
				damage 			= self:GetCaster():GetIntellect(),
				damage_type		= DAMAGE_TYPE_MAGICAL,
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= self:GetCaster(),
			})
		end
		
		self:DecrementStackCount()
		
		if self:GetStackCount() <= 0 then
			self:Destroy()
		end
	end
end

--------------------------------------------------------

modifier_gyrocopter_flak_cannon_lua_armor	= modifier_gyrocopter_flak_cannon_lua_armor or class({})

function modifier_gyrocopter_flak_cannon_lua_armor:IsHidden()			return false end
function modifier_gyrocopter_flak_cannon_lua_armor:IsPurgable()		return false end
function modifier_gyrocopter_flak_cannon_lua_armor:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_gyrocopter_flak_cannon_lua_armor:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_gyrocopter_flak_cannon_lua_armor:GetModifierPhysicalArmorBonus(keys)
	return -3
end

--------------------------------------------------------

modifier_gyrocopter_flak_cannon_lua_resist	= modifier_gyrocopter_flak_cannon_lua_resist or class({})

function modifier_gyrocopter_flak_cannon_lua_resist:IsHidden()			return false end
function modifier_gyrocopter_flak_cannon_lua_resist:IsPurgable()		return false end
function modifier_gyrocopter_flak_cannon_lua_resist:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_gyrocopter_flak_cannon_lua_resist:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
end

function modifier_gyrocopter_flak_cannon_lua_resist:GetModifierMagicalResistanceBonus(keys)
	return -5
end

--------------------------------------------------------

function modifier_gyrocopter_flak_cannon_lua_side_gunner:IsHidden()		return true end
function modifier_gyrocopter_flak_cannon_lua_side_gunner:IsPurgable()		return false end
function modifier_gyrocopter_flak_cannon_lua_side_gunner:RemoveOnDeath()	return false end
function modifier_gyrocopter_flak_cannon_lua_side_gunner:OnCreated()
	self:StartIntervalThink(1)
end


function modifier_gyrocopter_flak_cannon_lua_side_gunner:OnIntervalThink()
	if not IsServer() then return end
	count = 0
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_gyrocopter_agi50") then
		self.special_bonus_unique_npc_dota_hero_gyrocopter_agi50 = true
		count = -1
	end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_gyrocopter_agi_last") ~= nil and self:GetCaster():GetModelName() == "models/heroes/gyro/gyro.vmdl" then 
		if not self:GetParent():IsOutOfGame() and not self:GetParent():IsInvisible() and not self:GetParent():PassivesDisabled() and self:GetParent():IsAlive() then
			local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_FARTHEST, false)
			if #enemies == 1 then
				self:GetParent():PerformAttack(enemies[1], true, true, true, false, true, false, false)
				self:GetParent():PerformAttack(enemies[1], true, true, true, false, true, false, false)
				if self.special_bonus_unique_npc_dota_hero_gyrocopter_agi50 then
					self:GetParent():PerformAttack(enemies[1], true, true, true, false, true, false, false)
				end
			else
				for _,enemy in pairs(enemies) do
					self:GetParent():PerformAttack(enemy, true, true, true, false, true, false, false)
					count = count + 1
					if count >=2 then break end
				end
			end
		end
	end
end

function modifier_gyrocopter_flak_cannon_lua_side_gunner:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	}
end

function modifier_gyrocopter_flak_cannon_lua_side_gunner:GetModifierAttackRangeBonus()
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_gyrocopter_agi50") then
		return 300
	end
end