legion_press_the_attack = class({})
LinkLuaModifier("modifier_legion_press_the_attack", "heroes/hero_legion/legion_press_the_attack/legion_press_the_attack", LUA_MODIFIER_MOTION_NONE)

function legion_press_the_attack:GetAOERadius()
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_legion_commander_str10")
		if abil ~= nil	then 
			return self:GetSpecialValueFor("radius")
		end
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_legion_commander_int6")
		if abil ~= nil	then 
			return 35000
		end	
	return 0
end

function legion_press_the_attack:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end

function legion_press_the_attack:GetBehavior()
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_legion_commander_str10")
		if abil ~= nil	then 
		return  DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
	end
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_legion_commander_int6") ~= nil	then 
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET
	end	

	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end

function legion_press_the_attack:OnSpellStart()
	local caster = self:GetCaster()
	local ability = self

	if self:GetCaster():FindAbilityByName("npc_dota_hero_legion_commander_str10")~= nil	or self:GetCaster():FindAbilityByName("npc_dota_hero_legion_commander_int6") ~= nil then 
	
	local target_point = self:GetCursorPosition()
	local sound_target = "Hero_LegionCommander.PressTheAttack"
	--local sound_explosion = "Imba.WarlockShadowWordExplosion"
	local particle_aoe = "particles/econ/items/legion/legion_fallen/legion_fallen_press.vpcf"
	local modifier_word = "modifier_legion_press_the_attack"

	local radius = ability:GetSpecialValueFor("radius")
	local duration = ability:GetSpecialValueFor("duration")
	
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_legion_commander_int6") ~= nil	then 
		target_point = self:GetCaster():GetAbsOrigin()
		radius = 35000
	end

	EmitSoundOn(sound_target, caster)

	local particle_aoe_fx = ParticleManager:CreateParticle(particle_aoe, PATTACH_WORLDORIGIN, caster)

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
		
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_legion_commander_str11")
		if abil ~= nil	then 	
			unit:AddNewModifier(caster, ability, "modifier_magic_immune", {duration = duration})
		end
		
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_legion_commander_agi8")
		if abil ~= nil	then 	
			unit:AddNewModifier(caster, ability, "modifier_lega_cleave", {duration = duration})
		end	
		
	end
	
	

	Timers:CreateTimer(duration, function()
		StopSoundOn(sound_target, caster)
	end)
	else
	local sound_target = "Hero_LegionCommander.PressTheAttack"
	--local sound_explosion = "Imba.WarlockShadowWordExplosion"
	local particle_aoe = "particles/econ/items/legion/legion_fallen/legion_fallen_press.vpcf"
	local modifier_word = "modifier_legion_press_the_attack"

	local radius = ability:GetSpecialValueFor("radius")
	local duration = ability:GetSpecialValueFor("duration")

	EmitSoundOn(sound_target, caster)
	
	local target = self:GetCursorTarget()
	target:AddNewModifier(caster, ability, modifier_word, {duration = duration})
		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_legion_commander_str11")
		if abil ~= nil	then 	
			target:AddNewModifier(caster, ability, "modifier_magic_immune", {duration = duration})
		end
		
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_legion_commander_agi8")
		if abil ~= nil	then 	
			target:AddNewModifier(caster, ability, "modifier_lega_cleave", {duration = duration})
		end		
		
	Timers:CreateTimer(duration, function()
		StopSoundOn(sound_target, caster)
	end)	
	end
end

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
LinkLuaModifier( "modifier_lega_cleave", "heroes/hero_legion/legion_press_the_attack/legion_press_the_attack", LUA_MODIFIER_MOTION_NONE )

modifier_lega_cleave = class({})

function modifier_lega_cleave:IsHidden()
	return true
end

function modifier_lega_cleave:IsPurgable()
	return false
end

function modifier_lega_cleave:OnCreated( kv )
end

function modifier_lega_cleave:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		
	}
	return funcs
end

function modifier_lega_cleave:OnAttackLanded(keys)
	if not (
		IsServer()
		and self:GetParent() == keys.attacker
		and keys.attacker:GetTeam() ~= keys.target:GetTeam()
		and not keys.attacker:IsRangedAttacker()
	) then return end
	
	local ability = self:GetAbility()
	local damage = keys.original_damage
	local damageMod = 100
	local radius = 300
	local particle_cast = 'particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf'
	
	damageMod = damageMod * 0.01
	damage = damage * damageMod
	
	DoCleaveAttack(
		self:GetParent(),
		keys.target,
		ability,
		damage,
		150,
		360,
		radius,
		particle_cast
	)
end

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

modifier_legion_press_the_attack = class({})

function modifier_legion_press_the_attack:OnCreated()
	self.caster = self:GetCaster()
	
	
	self.sound_good = "Hero_LegionCommander.PressTheAttack"
	self.particle_good = "particles/econ/items/legion/legion_fallen/legion_fallen_press.vpcf"
	
	if not self:GetAbility() then return end

	self.regen = self:GetAbility():GetSpecialValueFor("regen")
	self.attack_speed = self:GetAbility():GetSpecialValueFor("attack_speed")
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_legion_commander_str7")
	if abil ~= nil	then 
		self.regen = self.regen * 2
		self.attack_speed = self.attack_speed * 2
	end	

	if IsServer() then
		self:GetParent():Purge(false, true, false, false, false)
		EmitSoundOn(self.sound_good, self:GetParent())
		self.particle_good_fx = ParticleManager:CreateParticle(self.particle_good, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.particle_good_fx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle_good_fx, 2, self:GetParent():GetAbsOrigin())
		self:AddParticle(self.particle_good_fx, false, false, -1, false, false)			
	end
end

function modifier_legion_press_the_attack:IsHidden() return false end
function modifier_legion_press_the_attack:IsPurgable() return true end
function modifier_legion_press_the_attack:IgnoreTenacity()	return true end


function modifier_legion_press_the_attack:OnDestroy()
	StopSoundOn(self.sound_good, self:GetParent())
end

function modifier_legion_press_the_attack:DeclareFunctions()
	local decFuncs = {
	MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
	return decFuncs
end

function modifier_legion_press_the_attack:GetModifierConstantHealthRegen()
	return self.regen
end

function modifier_legion_press_the_attack:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed
end

function modifier_legion_press_the_attack:GetModifierPhysicalArmorBonus()
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_legion_commander_str8")
	if abil ~= nil	then 
		return self:GetAbility():GetSpecialValueFor("regen")
	end
	return 0
end