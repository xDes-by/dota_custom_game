LinkLuaModifier( "modifier_power", "heroes/hero_skeleton/other/modifier_power", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_wraith_king_reincarnation_lua_buff", "heroes/hero_skeleton/wraith_king_reincarnation_lua/modifier_wraith_king_reincarnation_lua_buff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_special_bonus_unique_npc_dota_hero_skeleton_king_str50", "heroes/hero_skeleton/wraith_king_reincarnation_lua/modifier_wraith_king_reincarnation_lua", LUA_MODIFIER_MOTION_NONE )

modifier_wraith_king_reincarnation_lua = class({})

function modifier_wraith_king_reincarnation_lua:IsHidden()
	return true
end

function modifier_wraith_king_reincarnation_lua:OnCreated( kv )
	-- references
	self.reincarnate_time = self:GetAbility():GetSpecialValueFor( "reincarnate_time" ) -- special value
	self.slow_radius = self:GetAbility():GetSpecialValueFor( "slow_radius" ) -- special value
	self.slow_duration = self:GetAbility():GetSpecialValueFor( "slow_duration" ) -- special value

	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" ) -- special value
end

function modifier_wraith_king_reincarnation_lua:OnRefresh( kv )
	-- references
	self.reincarnate_time = self:GetAbility():GetSpecialValueFor( "reincarnate_time" ) -- special value
	self.slow_radius = self:GetAbility():GetSpecialValueFor( "slow_radius" ) -- special value
	self.slow_duration = self:GetAbility():GetSpecialValueFor( "slow_duration" ) -- special value
	
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" ) -- special value
end

function modifier_wraith_king_reincarnation_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_wraith_king_reincarnation_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_REINCARNATION,
		-- MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end

function modifier_wraith_king_reincarnation_lua:ReincarnateTime( params )
	if IsServer() then
		if self:GetAbility():IsFullyCastable() then
			self:Reincarnate()
			return self.reincarnate_time
		end
		return 0
	end
end

--------------------------------------------------------------------------------
-- Helper Function
function modifier_wraith_king_reincarnation_lua:Reincarnate()

	self:GetAbility():UseResources(true, false, false, true)

	-- find affected enemies
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.slow_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_skeleton_king_str7")
		if abil ~= nil then 

		Timers:CreateTimer(3.1,function() 
		self:GetParent():AddNewModifier(
				self:GetParent(),
				self:GetAbility(),
				"modifier_power",
				{ duration = 5 }
			)
		end)
	end
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_skeleton_king_str_last") ~= nil then
		Timers:CreateTimer(3.1,function() 
		self:GetParent():AddNewModifier(
				self:GetParent(),
				self:GetAbility(),
				"modifier_wraith_king_reincarnation_lua_buff",
				{ duration = 5 }
			)
		end)
	end
	
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_skeleton_king_str50") ~= nil then
		Timers:CreateTimer(3.1,function() 
		self:GetParent():AddNewModifier(
				self:GetParent(),
				self:GetAbility(),
				"modifier_special_bonus_unique_npc_dota_hero_skeleton_king_str50",
				{}
			)
		end)
	end

	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_skeleton_king_str10")
		if abil ~= nil then 
		local ability = self:GetCaster():FindAbilityByName( "wraith_king_sceleton")
				if ability~=nil and ability:GetLevel()>=1 then
					ability:OnSpellStart()
				end
	end
	
	for _,enemy in pairs(enemies) do
		enemy:AddNewModifier(
			self:GetParent(),
			self:GetAbility(),
			"modifier_wraith_king_reincarnation_lua_debuff",
			{ duration = self.slow_duration }
		)
		-- local abil = self:GetParent():FindAbilityByName("npc_dota_hero_skeleton_king_str9")
		-- if abil ~= nil then 
		-- damage = self:GetParent():GetMaxHealth() 
		-- ApplyDamage({attacker = self:GetParent(), victim = enemy, ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
		-- self:GetParent():EmitSound("Hero_SkeletonKing.Hellfire_Blast")
		-- end
	end

	-- play effects
	self:PlayEffects()
end
--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_wraith_king_reincarnation_lua:PlayEffects()
	-- get resources
	local particle_cast = "particles/units/heroes/hero_skeletonking/wraith_king_reincarnate.vpcf"
	local sound_cast = "Hero_SkeletonKing.Reincarnate"

	-- play particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.reincarnate_time, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- play sound
	EmitSoundOn( sound_cast, self:GetParent() )
end

modifier_special_bonus_unique_npc_dota_hero_skeleton_king_str50 = class({})
--Classifications template
function modifier_special_bonus_unique_npc_dota_hero_skeleton_king_str50:IsHidden()
	return false
end

function modifier_special_bonus_unique_npc_dota_hero_skeleton_king_str50:IsDebuff()
	return false
end

function modifier_special_bonus_unique_npc_dota_hero_skeleton_king_str50:IsPurgable()
	return false
end

function modifier_special_bonus_unique_npc_dota_hero_skeleton_king_str50:IsPurgeException()
	return false
end

-- Optional Classifications
function modifier_special_bonus_unique_npc_dota_hero_skeleton_king_str50:IsStunDebuff()
	return false
end

function modifier_special_bonus_unique_npc_dota_hero_skeleton_king_str50:RemoveOnDeath()
	return true
end

function modifier_special_bonus_unique_npc_dota_hero_skeleton_king_str50:DestroyOnExpire()
	return true
end

function modifier_special_bonus_unique_npc_dota_hero_skeleton_king_str50:OnCreated()
	if not IsServer() then
		return
	end
	self.agi = self:GetCaster():GetAgility() * 2
	self.str = self:GetCaster():GetStrength() * 2
	self.int = self:GetCaster():GetIntellect() * 2
end

function modifier_special_bonus_unique_npc_dota_hero_skeleton_king_str50:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
end

function modifier_special_bonus_unique_npc_dota_hero_skeleton_king_str50:GetModifierBonusStats_Strength()
	return self.str
end

function modifier_special_bonus_unique_npc_dota_hero_skeleton_king_str50:GetModifierBonusStats_Agility()
	return self.agi
end

function modifier_special_bonus_unique_npc_dota_hero_skeleton_king_str50:GetModifierBonusStats_Intellect()
	return self.int
end
