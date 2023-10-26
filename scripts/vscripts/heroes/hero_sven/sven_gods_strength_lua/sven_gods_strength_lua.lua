sven_gods_strength_lua = class({})
LinkLuaModifier( "modifier_sven_gods_strength_lua", "heroes/hero_sven/sven_gods_strength_lua/modifier_sven_gods_strength_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sven_gods_magic_debuff", "heroes/hero_sven/sven_gods_strength_lua/modifier_sven_gods_magic_debuff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sven_gods_magic_buff", "heroes/hero_sven/sven_gods_strength_lua/modifier_sven_gods_magic_buff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sven_gods_strength_child_lua", "heroes/hero_sven/sven_gods_strength_lua/modifier_sven_gods_strength_child_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sven_gods_strength_int50", "heroes/hero_svevn/sven_gods_strength_lua/sven_gods_strength_lua", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
function sven_gods_strength_lua:GetIntrinsicModifierName()
    return "modifier_sven_gods_strength_int50"
end

function sven_gods_strength_lua:GetManaCost(iLevel)
    return 150 + math.min(65000, self:GetCaster():GetIntellect()/30)
end

function sven_gods_strength_lua:OnSpellStart()
	local gods_strength_duration = self:GetSpecialValueFor( "gods_strength_duration" )
	local radius = self:GetSpecialValueFor( "scepter_aoe" )
	self.caster = self:GetCaster()
	
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_sven_gods_strength_lua", { duration = gods_strength_duration }  )
	
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_sven_int6")
	if abil ~= nil then 
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_sven_gods_magic_debuff", { duration = gods_strength_duration }  )
	end	
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_sven_int9")
	if abil ~= nil then 
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_sven_gods_magic_buff", { duration = gods_strength_duration }  )
	end	
		
	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_spell_gods_strength.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	EmitSoundOn( "Hero_Sven.GodsStrength", self:GetCaster() )

	self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_4 );
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_sven_int11")
		if abil ~= nil then 
	
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetCaster():GetAbsOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	for _,enemy in pairs(enemies) do
		ApplyDamage({
			attacker = self:GetCaster(), 
			victim = enemy, 
			ability = self, 
			damage = self:GetCaster():GetIntellect()*5, 
			damage_type = DAMAGE_TYPE_MAGICAL 
		})
	end
	end
end

modifier_sven_gods_strength_int50 = class({})
--Classifications template
function modifier_sven_gods_strength_int50:IsHidden()
	return true
end

function modifier_sven_gods_strength_int50:IsDebuff()
	return false
end

function modifier_sven_gods_strength_int50:IsPurgable()
	return false
end

function modifier_sven_gods_strength_int50:IsPurgeException()
	return false
end

-- Optional Classifications
function modifier_sven_gods_strength_int50:IsStunDebuff()
	return false
end

function modifier_sven_gods_strength_int50:RemoveOnDeath()
	return false
end

function modifier_sven_gods_strength_int50:DestroyOnExpire()
	return false
end

function modifier_sven_gods_strength_int50:OnCreated()
	if not IsServer() then
		return
	end
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_sven_str50") then
		self.mod = self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_sven_gods_strength_lua", {})
	end
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_sven_int11")
	if abil ~= nil then 
		self:StartIntervalThink(1)
	end
end

function modifier_sven_gods_strength_int50:OnRefresh()
	if not IsServer() then
		return
	end
	self.mod:ForceRefresh()
end

function modifier_sven_gods_strength_int50:OnIntervalThink()
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),self:GetCaster():GetAbsOrigin(),nil,700,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,0,false)
	for _,enemy in pairs(enemies) do
		ApplyDamage({
			attacker = self:GetCaster(), 
			victim = enemy, 
			ability = self, 
			damage = self:GetCaster():GetIntellect()*5, 
			damage_type = DAMAGE_TYPE_MAGICAL 
		})
	end
end