LinkLuaModifier( "modifier_zuus_thundergods_wrath_intrinsic", "heroes/hero_zuus/zuus_thunder/modifier_zuus_thundergods_wrath_intrinsic.lua", LUA_MODIFIER_MOTION_NONE )
zuus_thundergods_wrath_lua = class({})

function zuus_thundergods_wrath_lua:GetIntrinsicModifierName()
	return "modifier_zuus_thundergods_wrath_intrinsic"
end

function zuus_thundergods_wrath_lua:GetManaCost(iLevel)
    return 150 + math.min(65000, self:GetCaster():GetIntellect() / 30)
end

function zuus_thundergods_wrath_lua:GetBehavior()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_str10") then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end
end

function zuus_thundergods_wrath_lua:GetCastRange()
	return self:GetSpecialValueFor("radius")
end

function zuus_thundergods_wrath_lua:GetCooldown(iLevel)
	if not IsServer() then return end
	if self:GetAutoCastState() then
		return 15
	end
end

function zuus_thundergods_wrath_lua:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("Hero_Zuus.GodsWrath.PreCast")

	local attack_lock = self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_attack1"))

	self.thundergod_spell_cast = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(self.thundergod_spell_cast, 0, Vector(attack_lock.x, attack_lock.y, attack_lock.z))
	ParticleManager:SetParticleControl(self.thundergod_spell_cast, 1, Vector(attack_lock.x, attack_lock.y, attack_lock.z))
	ParticleManager:SetParticleControl(self.thundergod_spell_cast, 2, Vector(attack_lock.x, attack_lock.y, attack_lock.z))

	return true
end

function zuus_thundergods_wrath_lua:OnAbilityPhaseInterrupted()
	if self.thundergod_spell_cast then
		ParticleManager:DestroyParticle(self.thundergod_spell_cast, true)
		ParticleManager:ReleaseParticleIndex(self.thundergod_spell_cast)
	end
end


function zuus_thundergods_wrath_lua:GetManaCost(iLevel)
	if  self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_int10")	 ~= nil then 
        return 50 + math.min(65000, self:GetCaster():GetIntellect()/200)
	end
        return 100 + math.min(65000, self:GetCaster():GetIntellect()/100)
end

function zuus_thundergods_wrath_lua:ApplyDamage(tab, dmg_perc)
	tab = table.shuffle(tab)
	zuus_lightning_bolt_lua = self:GetCaster():FindAbilityByName("zuus_lightning_bolt_lua")
	local step = 0
	local caster = self:GetCaster()
	if zuus_lightning_bolt_lua and zuus_lightning_bolt_lua:GetLevel() > 0 then
		local damage = zuus_lightning_bolt_lua:GetSpecialValueFor("damage") + self:GetSpecialValueFor("damage") * dmg_perc
		Timers:CreateTimer(0, function()
			step = step + 1
			zuus_lightning_bolt_lua:CastLightningBolt(caster, zuus_lightning_bolt_lua, tab[step], tab[step]:GetAbsOrigin(), _, damage)
			if step < #tab then
				return 0.05
			end
		end)
	end
end

function zuus_thundergods_wrath_lua:GlobalCast(dmg_perc)
	local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local all_targets = {}
	local allies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
	for _, ally in pairs(allies) do
		local enemies = FindUnitsInRadius( ally:GetTeamNumber(), ally:GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
		for _, enemy in pairs(enemies) do 
			table.insert(all_targets, enemy)
		end
	end
	self:ApplyDamage(all_targets, dmg_perc)
end

function zuus_thundergods_wrath_lua:LocalCast(dmg_perc)
	local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local all_targets = {}
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
	for _, enemy in pairs(enemies) do 
		table.insert(all_targets, enemy)
	end
	self:ApplyDamage(all_targets, dmg_perc)
end

function zuus_thundergods_wrath_lua:OnSpellStart() 
	if not IsServer() then return end
	EmitSoundOnLocationForAllies(self:GetCaster():GetAbsOrigin(), "Hero_Zuus.GodsWrath", self:GetCaster())
	if self:GetAutoCastState() == true then
		self:LocalCast(0.5)
		-- self:StartCooldown(15.0*self:GetCaster():GetCooldownReduction())
	else
		self:GlobalCast(1.0)
	end
end