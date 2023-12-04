modifier_dragon_form_lua = class({})

local level1 = {
	["projectile"] = "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_corrosive.vpcf",
	["attack_sound"] = "Hero_DragonKnight.ElderDragonShoot1.Attack",
	["transform"] = "particles/units/heroes/hero_dragon_knight/dragon_knight_transform_green.vpcf",
	["scale"] = 0,
}
local level2 = {
	["projectile"] = "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_corrosive.vpcf",
	["attack_sound"] = "Hero_DragonKnight.ElderDragonShoot1.Attack",
	["transform"] = "particles/units/heroes/hero_dragon_knight/dragon_knight_transform_green.vpcf",
	["scale"] = 0,
}
local level3 = {
	["projectile"] = "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_corrosive.vpcf",
	["attack_sound"] = "Hero_DragonKnight.ElderDragonShoot1.Attack",
	["transform"] = "particles/units/heroes/hero_dragon_knight/dragon_knight_transform_green.vpcf",
	["scale"] = 0,
}
local level4 = {
	["projectile"] = "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_fire.vpcf",
	["attack_sound"] = "Hero_DragonKnight.ElderDragonShoot2.Attack",
	["transform"] = "particles/units/heroes/hero_dragon_knight/dragon_knight_transform_red.vpcf",
	["scale"] = 10,
}
local level5 = {
	["projectile"] = "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_fire.vpcf",
	["attack_sound"] = "Hero_DragonKnight.ElderDragonShoot2.Attack",
	["transform"] = "particles/units/heroes/hero_dragon_knight/dragon_knight_transform_red.vpcf",
	["scale"] = 10,
}
local level6 = {
	["projectile"] = "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_fire.vpcf",
	["attack_sound"] = "Hero_DragonKnight.ElderDragonShoot2.Attack",
	["transform"] = "particles/units/heroes/hero_dragon_knight/dragon_knight_transform_red.vpcf",
	["scale"] = 10,
}
local level7 = {
	["projectile"] = "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_frost.vpcf",
	["attack_sound"] = "Hero_DragonKnight.ElderDragonShoot3.Attack",
	["transform"] = "particles/units/heroes/hero_dragon_knight/dragon_knight_transform_blue.vpcf",
	["scale"] = 20,
}
local level8 = {
	["projectile"] = "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_frost.vpcf",
	["attack_sound"] = "Hero_DragonKnight.ElderDragonShoot3.Attack",
	["transform"] = "particles/units/heroes/hero_dragon_knight/dragon_knight_transform_blue.vpcf",
	["scale"] = 20,
}
local level9 = {
	["projectile"] = "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_frost.vpcf",
	["attack_sound"] = "Hero_DragonKnight.ElderDragonShoot3.Attack",
	["transform"] = "particles/units/heroes/hero_dragon_knight/dragon_knight_transform_blue.vpcf",
	["scale"] = 20,
}
local level10 = {
	["projectile"] = "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_frost.vpcf",
	["attack_sound"] = "Hero_DragonKnight.ElderDragonShoot3.Attack",
	["transform"] = "particles/units/heroes/hero_dragon_knight/dragon_knight_transform_blue.vpcf",
	["scale"] = 40,
}


modifier_dragon_form_lua.effect_data = {
	[1] = level1,
	[2] = level2,
	[3] = level3,
	[4] = level4,
	[5] = level5,
	[6] = level6,
	[7] = level7,
	[8] = level8,
	[9] = level9,
	[10] = level10,
}

--------------------------------------------------------------------------------
-- Classifications
function modifier_dragon_form_lua:IsHidden()
	return false
end

function modifier_dragon_form_lua:IsDebuff()
	return false
end

function modifier_dragon_form_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_dragon_form_lua:OnCreated( kv )
	

	self.level = self:GetAbility():GetLevel()

	self.bonus_ms = self:GetAbility():GetSpecialValueFor( "bonus_movement_speed" )
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_attack_damage" )
	self.bonus_range = self:GetAbility():GetSpecialValueFor( "bonus_attack_range" )

	self.corrosive_duration = self:GetAbility():GetSpecialValueFor( "corrosive_breath_duration" )
	
	self.splash_radius = self:GetAbility():GetSpecialValueFor( "splash_radius" )
	self.splash_pct = self:GetAbility():GetSpecialValueFor( "splash_damage_percent" )/100
	
	self.frost_radius = self:GetAbility():GetSpecialValueFor( "frost_aoe" )
	self.frost_duration = self:GetAbility():GetSpecialValueFor( "frost_duration" )

	if not IsServer() then return end
	self:GetParent():SetAttackCapability( DOTA_UNIT_CAP_RANGED_ATTACK )

	self:StartIntervalThink( 0.03 ) -- set skin can only affect model after this frame
	self.projectile = self.effect_data[self.level].projectile
	self.attack_sound = self.effect_data[self.level].attack_sound
	self.scale = self.effect_data[self.level].scale

	self:PlayEffects()
	local sound_cast = "Hero_DragonKnight.ElderDragonForm"
	EmitSoundOn( sound_cast, self:GetParent() )
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_dragon_knight_str8") 
	if abil ~= nil then
	self.bonus_damage = self.bonus_damage + self:GetCaster():GetStrength()
	end
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_dragon_knight_agi9") 
	if abil ~= nil then
	self.bonus_damage = self.bonus_damage * 2
	end
	
	
end

function modifier_dragon_form_lua:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_dragon_form_lua:OnRemoved()
end

function modifier_dragon_form_lua:OnDestroy()
	if not IsServer() then return end

	self:GetParent():SetAttackCapability( DOTA_UNIT_CAP_MELEE_ATTACK )

	self:PlayEffects()
	local sound_cast = "Hero_DragonKnight.ElderDragonForm.Revert"
	EmitSoundOn( sound_cast, self:GetParent() )
end

function modifier_dragon_form_lua:OnIntervalThink()
if self.level <= 3 then
	self:GetParent():SetSkin(0)
end
if self.level > 3 and self.level <= 6 then
	self:GetParent():SetSkin(1)
end	
if self.level > 6 and self.level <= 9 then
	self:GetParent():SetSkin(2)
end	
if self.level > 9 then
	self:GetParent():SetSkin(3)
end		
end

--------------------------------------------------------------------------------
function modifier_dragon_form_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,

		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
		MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,

		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,

		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	}

	return funcs
end

function modifier_dragon_form_lua:GetModifierTotalDamageOutgoing_Percentage()
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_dragon_knight_agi50") then
		return 200
	end
end

function modifier_dragon_form_lua:GetModifierBaseAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_dragon_form_lua:GetModifierMoveSpeedBonus_Constant()
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_dragon_knight_agi9") 
	if abil ~= nil then
	return self.bonus_ms * 2
	end
	return self.bonus_ms
end

function modifier_dragon_form_lua:GetModifierAttackRangeBonus()
	return self.bonus_range
end

--------------------------------------------------------------------------------
function modifier_dragon_form_lua:GetModifierModelChange()
	return "models/heroes/dragon_knight/dragon_knight_dragon.vmdl"
end

function modifier_dragon_form_lua:GetModifierModelScale()
	return self.scale
end

function modifier_dragon_form_lua:GetAttackSound()
	return self.attack_sound
end

function modifier_dragon_form_lua:GetModifierProjectileName()
	return self.projectile
end

function modifier_dragon_form_lua:GetModifierProjectileSpeedBonus()
	return 900
end

--------------------------------------------------------------------------------
function modifier_dragon_form_lua:GetModifierProcAttack_Feedback( params )
	if params.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then return end

		self:Corrosive( params.target )
		self:Splash( params.target, params.damage )
		self:Frost( params.target )

	local sound_cast = "Hero_DragonKnight.ProjectileImpact"
	EmitSoundOn( sound_cast, params.target )
end

--------------------------------------------------------------------------------
-- Helper
function modifier_dragon_form_lua:Corrosive( target )
	-- add modifier
	target:AddNewModifier(
		self:GetParent(), -- player source
		self:GetAbility(), -- ability source
		"modifier_dragon_form_lua_corrosive", -- modifier name
		{ duration = self.corrosive_duration } -- kv
	)
end

function modifier_dragon_form_lua:Splash( target, damage )
	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		target:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.splash_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		if enemy~=target then
			-- -- perform attack
			-- self:GetParent():PerformAttack(
			-- 	enemy, -- hTarget,
			-- 	false, -- bUseCastAttackOrb,
			-- 	false, -- bProcessProcs,
			-- 	true, -- bSkipCooldown,
			-- 	true, -- bIgnoreInvis,
			-- 	false, -- bUseProjectile,
			-- 	false, -- bFakeAttack,
			-- 	true -- bNeverMiss
			-- )

			-- apply damage
			local damageTable = {
				victim = enemy,
				attacker = self:GetParent(),
				damage = damage * self.splash_pct,
				damage_type = DAMAGE_TYPE_PHYSICAL,
				ability = self:GetAbility(), --Optional.
				-- damage_category = DOTA_DAMAGE_CATEGORY_ATTACK, --Optional.
			}
			ApplyDamage(damageTable)

			-- corrosive
			self:Corrosive( enemy )
		end
	end
end

function modifier_dragon_form_lua:Frost( target )
	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		target:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.frost_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- add frost
		enemy:AddNewModifier(
			self:GetParent(), -- player source
			self:GetAbility(), -- ability source
			"modifier_dragon_form_lua_frost", -- modifier name
			{ duration = self.frost_duration } -- kv
		)
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_dragon_form_lua:PlayEffects()
	-- Get Resources
	local particle_cast = self.effect_data[self.level].transform

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end