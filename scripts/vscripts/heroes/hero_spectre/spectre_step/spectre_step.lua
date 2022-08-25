spectre_step = spectre_step or class({})
LinkLuaModifier("modifier_step", "heroes/hero_spectre/spectre_step/spectre_step.lua", LUA_MODIFIER_MOTION_NONE)


function spectre_step:GetIntrinsicModifierName()
	return "modifier_step"
end

-----------------------------------------------------------------------------
modifier_step = class({})

function modifier_step:IsHidden()
	return false
end

function modifier_step:IsPurgable()
	return false
end

function modifier_step:OnCreated( kv )
	self.caster = self:GetCaster()
	
	
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.dmg = self:GetAbility():GetSpecialValueFor("dmg")
	self.speed = self:GetAbility():GetSpecialValueFor("speed")

	self.interval = 0.5

	if IsServer() then 

		self:StartIntervalThink( self.interval )
	end
end

function modifier_step:OnRefresh( kv )
	self.caster = self:GetCaster()
	
	
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.dmg = self:GetAbility():GetSpecialValueFor("dmg")
	self.speed = self:GetAbility():GetSpecialValueFor("speed")
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_spectre_agi9")
	if abil ~= nil then 
	self.dmg = self.dmg * 2
	end
end

function modifier_step:OnDestroy( kv )
end

function modifier_step:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_step:GetModifierMoveSpeedBonus_Constant()
	return self.speed
end

function modifier_step:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end


function modifier_step:OnIntervalThink()
	self:OnRefresh()
		local enemies = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(),	-- int, your team number
			self:GetCaster():GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			self.radius + 100,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)	
				
				damage_type = DAMAGE_TYPE_PURE
				damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
				
				local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_spectre_int6")
				if abil ~= nil then 
				damage_type = DAMAGE_TYPE_MAGICAL
				damage_flags = DOTA_DAMAGE_FLAG_NONE
				end

		
		for _,enemy in pairs(enemies) do
				self.damageTable = {
				victim = enemy,
				attacker = self:GetCaster(),
				damage = self.dmg,
				damage_type = damage_type,
				damage_flags = damage_flags
			}
			ApplyDamage( self.damageTable )
		end
end