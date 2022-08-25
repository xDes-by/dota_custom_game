warlock_shadow_word_lua = class({})
LinkLuaModifier("modifier_imba_shadow_word", "heroes/hero_warlock/warlock_shadow_word_lua/warlock_shadow_word_lua.lua", LUA_MODIFIER_MOTION_NONE)

function warlock_shadow_word_lua:IsHiddenWhenStolen()
	return false
end

function warlock_shadow_word_lua:GetAOERadius()
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_warlock_str11")
		if abil ~= nil	then 
		return self:GetSpecialValueFor("radius")
	end
	return 0
end

function warlock_shadow_word_lua:GetManaCost(iLevel)
    local caster = self:GetCaster()
    if caster then
        return caster:GetIntellect()
    end
end

function warlock_shadow_word_lua:GetBehavior()
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_warlock_str11")
		if abil ~= nil	then 
		return  DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
	end

	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end

function warlock_shadow_word_lua:OnSpellStart()
	local caster = self:GetCaster()
	local ability = self
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_warlock_str11")
		if abil ~= nil	then 
	
	local target_point = self:GetCursorPosition()
	local sound_target = "Hero_Warlock.ShadowWord"
	local sound_explosion = "Imba.WarlockShadowWordExplosion"
	local particle_aoe = "particles/hero/warlock/warlock_shadow_word_aoe_a.vpcf"
	local modifier_word = "modifier_imba_shadow_word"

	local radius = ability:GetSpecialValueFor("radius")
	local duration = ability:GetSpecialValueFor("duration")

	EmitSoundOn(sound_target, caster)

	EmitSoundOnLocationWithCaster(target_point, sound_explosion, caster)

	local particle_aoe_fx = ParticleManager:CreateParticle(particle_aoe, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(particle_aoe_fx, 0, target_point)
	ParticleManager:SetParticleControl(particle_aoe_fx, 1, Vector(radius, 0, 0))
	ParticleManager:SetParticleControl(particle_aoe_fx, 2, target_point)
	ParticleManager:ReleaseParticleIndex(particle_aoe_fx)

	AddFOWViewer(caster:GetTeamNumber(), target_point, radius, 2, true)

	local units = FindUnitsInRadius(caster:GetTeamNumber(),
		target_point,
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false)

	for _,unit in pairs(units) do
		unit:AddNewModifier(caster, ability, modifier_word, {duration = duration})
	end

	Timers:CreateTimer(duration, function()
		StopSoundOn(sound_target, caster)
	end)
	else
	local sound_target = "Hero_Warlock.ShadowWord"
	local sound_explosion = "Imba.WarlockShadowWordExplosion"
	local particle_aoe = "particles/hero/warlock/warlock_shadow_word_aoe_a.vpcf"
	local modifier_word = "modifier_imba_shadow_word"

	local radius = ability:GetSpecialValueFor("radius")
	local duration = ability:GetSpecialValueFor("duration")

	EmitSoundOn(sound_target, caster)
	
	local target = self:GetCursorTarget()
	target:AddNewModifier(caster, ability, modifier_word, {duration = duration})
		
		
	Timers:CreateTimer(duration, function()
		StopSoundOn(sound_target, caster)
	end)	
	end
end



modifier_imba_shadow_word = class({})

function modifier_imba_shadow_word:OnCreated()
	self.caster = self:GetCaster()
	
	
	self.sound_good = "Hero_Warlock.ShadowWordCastGood"
	self.sound_bad = "Hero_Warlock.ShadowWordCastBad"
	self.particle_good = "particles/units/heroes/hero_warlock/warlock_shadow_word_buff.vpcf"
	
	if not self:GetAbility() then return end

	self.tick_value = self:GetAbility():GetSpecialValueFor("tick_value")
	self.armor_value = self:GetAbility():GetSpecialValueFor("armor_value")
	self.tick_interval = self:GetAbility():GetSpecialValueFor("tick_interval")
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_warlock_str6")
		if abil ~= nil	then 
		self.tick_value = self.tick_value * 2
		end
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_warlock_str9")
		if abil ~= nil	then 
		self.armor_value = self.armor_value * 2
		end	

	if IsServer() then

			EmitSoundOn(self.sound_good, self:GetParent())

			self.particle_good_fx = ParticleManager:CreateParticle(self.particle_good, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			ParticleManager:SetParticleControl(self.particle_good_fx, 0, self:GetParent():GetAbsOrigin())
			ParticleManager:SetParticleControl(self.particle_good_fx, 2, self:GetParent():GetAbsOrigin())
			self:AddParticle(self.particle_good_fx, false, false, -1, false, false)
			
		self:StartIntervalThink(self.tick_interval)
	end
end

function modifier_imba_shadow_word:IsHidden() return false end
function modifier_imba_shadow_word:IsPurgable() return true end
function modifier_imba_shadow_word:IgnoreTenacity()	return true end

function modifier_imba_shadow_word:OnIntervalThink()
	local spell_power = self.caster:GetSpellAmplification(false)
	local heal = self.tick_value * (1 + spell_power)
	self:GetParent():Heal(heal, self.caster)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetParent(), heal, nil)
	local currentStacks = self:GetParent():GetModifierStackCount("modifier_imba_shadow_word", self:GetAbility())
	self:GetParent():SetModifierStackCount("modifier_imba_shadow_word", self.caster, currentStacks + 1 )
end

function modifier_imba_shadow_word:OnDestroy()
	StopSoundOn(self.sound_good, self:GetParent())
end

function modifier_imba_shadow_word:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}
	return decFuncs
end

function modifier_imba_shadow_word:GetModifierPhysicalArmorBonus()
	return self.armor_value * self:GetStackCount()
end
