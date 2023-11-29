terrorblade_conjure_image_lua = class({})
LinkLuaModifier( "modifier_terrorblade_conjure_image_lua", "heroes/hero_terror/terrorblade_conjure_image_lua/modifier_terrorblade_conjure_image_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_terrorblade_conjure_image_hit_lua", "heroes/hero_terror/terrorblade_conjure_image_lua/terrorblade_conjure_image_lua", LUA_MODIFIER_MOTION_NONE )

modifier_terrorblade_conjure_image_hit_lua = {}

function modifier_terrorblade_conjure_image_hit_lua:IsHidden()
	return false
end

function modifier_terrorblade_conjure_image_hit_lua:IsDebuff()
	return false
end

function modifier_terrorblade_conjure_image_hit_lua:IsPurgable()
	return false
end

function modifier_terrorblade_conjure_image_hit_lua:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_LANDED}
end

function modifier_terrorblade_conjure_image_hit_lua:OnAttackLanded(params)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_terrorblade_agi_last") ~= nil then
		if params.attacker:IsRealHero() and params.attacker == self:GetParent() and not params.attacker:IsIllusion() and RandomInt(1, 100) <= 5 then
		local abil = self:GetCaster():FindAbilityByName("terrorblade_conjure_image_lua") 
			if abil ~= nil and abil:GetLevel() >= 1 then
				abil:OnSpellStart(10)
			end
		end
	end
end

-------------------------------------------------------------------------------

function terrorblade_conjure_image_lua:Precache( context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_terrorblade.vsndevts", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_terrorblade/terrorblade_mirror_image.vpcf", context )
end

function terrorblade_conjure_image_lua:GetIntrinsicModifierName()
	return "modifier_terrorblade_conjure_image_hit_lua"
end

function terrorblade_conjure_image_lua:GetManaCost(iLevel)
	return 100 + math.min(65000, self:GetCaster():GetIntellect()/100)
end

function terrorblade_conjure_image_lua:OnSpellStart(duration)
	local caster = self:GetCaster()
	if not duration then
		duration = self:GetSpecialValueFor( "illusion_duration" )
	end
	local outgoing = self:GetSpecialValueFor( "illusion_outgoing_tooltip" ) - 100
	local incoming = self:GetSpecialValueFor( "illusion_incoming_damage" )
	local distance = 72
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_terrorblade_str8")
	if abil ~= nil then
	incoming = 50
	end

	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_terrorblade_agi6")
	if abil ~= nil then
		local outgoing = self:GetSpecialValueFor( "illusion_outgoing_tooltip" ) * 2 - 100
	end

	count = 1
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_terrorblade_agi9")
	if abil ~= nil then
	count = 2
	end
	for i = 1, count do
	
	-- create illusion

	local illusions = CreateIllusions(
		caster, -- hOwner
		caster, -- hHeroToCopy
		{
			outgoing_damage = outgoing,
			incoming_damage = incoming,
			duration = duration,
		}, -- hModiiferKeys
		1, -- nNumIllusions
		distance, -- nPadding
		false, -- bScramblePosition
		true -- bFindClearSpace
	)
	local illusion = illusions[1]
	for index = DOTA_ITEM_SLOT_1 , DOTA_ITEM_SLOT_9 do
		local caster_item = caster:GetItemInSlot(index)
		local illusion_item = illusion:GetItemInSlot(index)
		if caster_item and not caster_item:IsNull() and illusion_item and not illusion_item:IsNull() then
			illusion_item:SetLevel(caster_item:GetLevel())
		end
	end
	self:SetContextThink( DoUniqueString( "terrorblade_conjure_image_lua" ),function()
		illusion:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_terrorblade_conjure_image_lua", -- modifier name
			{ duration = duration } -- kv
		)

		-- Play effects
		local sound_cast = "Hero_Terrorblade.ConjureImage"
		EmitSoundOn( sound_cast, illusion )

	end, FrameTime()*2)
	end
		
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_terrorblade_int10")
	if abil ~= nil then
		
		local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetCaster():GetAbsOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		700,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_CREEP,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
		)
		for _,enemy in pairs(enemies) do
		
			ApplyDamage({victim = enemy, attacker = self:GetCaster(), ability = self, damage = self:GetCaster():GetIntellect(), damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
		
		end
			local wave_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_scepter.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
			ParticleManager:SetParticleControl(wave_particle, 0, self:GetCaster():GetAbsOrigin())
			ParticleManager:SetParticleControl(wave_particle, 1, Vector(self.speed, self.speed, self.speed))
			ParticleManager:SetParticleControl(wave_particle, 2, Vector(self.speed, self.speed, self.speed))
			ParticleManager:ReleaseParticleIndex(wave_particle)
		end
end