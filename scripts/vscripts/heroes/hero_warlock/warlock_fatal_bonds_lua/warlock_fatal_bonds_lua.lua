warlock_fatal_bonds_lua = class({})
LinkLuaModifier("modifier_warlock_fatal_bonds_lua", "heroes/hero_warlock/warlock_fatal_bonds_lua/warlock_fatal_bonds_lua.lua", LUA_MODIFIER_MOTION_NONE)

function warlock_fatal_bonds_lua:IsHiddenWhenStolen()
	return false
end

function warlock_fatal_bonds_lua:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end

function warlock_fatal_bonds_lua:OnSpellStart()
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCursorTarget()
	local particle_base = "particles/units/heroes/hero_warlock/warlock_fatal_bonds_base.vpcf"
	local particle_hit = "particles/units/heroes/hero_warlock/warlock_fatal_bonds_hit.vpcf"
	local modifier_bonds = "modifier_warlock_fatal_bonds_lua"

	local max_targets = ability:GetSpecialValueFor("max_targets")
	local duration = ability:GetSpecialValueFor("duration")
	local link_search_radius = ability:GetSpecialValueFor("link_search_radius")

	EmitSoundOn("Hero_Warlock.FatalBonds", caster)
	
	local targets_linked = 0
	local linked_units = {}
	local bond_table = {}

	local modifier_table = {}

	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end

	local bond_target = target
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_warlock_int9")
		if abil ~= nil	then 
		max_targets = max_targets + 4 
	end

	for link = 1, max_targets do
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
			bond_target:GetAbsOrigin(),
			nil,
			link_search_radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NO_INVIS,
			FIND_CLOSEST,
			false)
			
		for _,enemy in pairs(enemies) do
			if not linked_units[enemy:GetEntityIndex()] then
				local bond_modifier = enemy:AddNewModifier(caster, ability, modifier_bonds, {duration = duration * (1 - enemy:GetStatusResistance())})
				table.insert(modifier_table, bond_modifier)
				
				table.insert(bond_table, enemy)
				linked_units[enemy:GetEntityIndex()] = true

				if enemy == target then
					local particle_hit_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_warlock/warlock_fatal_bonds_hit_parent.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, caster)
					ParticleManager:SetParticleControlEnt(particle_hit_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(particle_hit_fx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
					ParticleManager:ReleaseParticleIndex(particle_hit_fx)
				else
					local particle_hit_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_warlock/warlock_fatal_bonds_hit_parent.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, caster)
					ParticleManager:SetParticleControlEnt(particle_hit_fx, 0, bond_target, PATTACH_POINT_FOLLOW, "attach_hitloc", bond_target:GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(particle_hit_fx, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
					ParticleManager:ReleaseParticleIndex(particle_hit_fx)
				end
				
				bond_target	= enemy
				
				break
			end
		end
		
		if link > #modifier_table then
			break
		end
	end

	for _, modifiers in pairs(modifier_table) do
		modifiers.bond_table = bond_table
	end
end

modifier_warlock_fatal_bonds_lua = class({})

function modifier_warlock_fatal_bonds_lua:IsHidden() return false end
function modifier_warlock_fatal_bonds_lua:IsPurgable() return true end
function modifier_warlock_fatal_bonds_lua:IsDebuff() return true end
function modifier_warlock_fatal_bonds_lua:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_warlock_fatal_bonds_lua:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	
	self.sound_damage = "Hero_Warlock.FatalBondsDamage"
	self.modifier_bonds = "modifier_warlock_fatal_bonds_lua"
	self.modifier_word = "modifier_imba_shadow_word"
	self.ability_word = "imba_warlock_shadow_word"
	if self:GetCaster():FindAbilityByName("npc_dota_hero_warlock_int_last") ~= nil then
		self.link_damage_share_pct = self.ability:GetSpecialValueFor("link_damage_share_pct") * 2
	else
        self.link_damage_share_pct = self.ability:GetSpecialValueFor("link_damage_share_pct")
	end
	
	
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_warlock_int11")
		if abil ~= nil	then 
		self.link_damage_share_pct = self.link_damage_share_pct + 6
		end


	if IsServer() then
		if self.caster:HasAbility(self.ability_word) then
			self.ability_word_handler = self.caster:FindAbilityByName(self.ability_word)
		end

		self.pfx_overhead = ParticleManager:CreateParticle("particles/units/heroes/hero_warlock/warlock_fatal_bonds_icon.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
	--	ParticleManager:SetParticleControlEnt(self.pfx_overhead, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_attack1", self.caster:GetAbsOrigin(), true)
	--	ParticleManager:SetParticleControlEnt(self.pfx_overhead, 1, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), true)
	end
end

function modifier_warlock_fatal_bonds_lua:OnDestroy()
	if self.pfx_overhead then
		ParticleManager:DestroyParticle(self.pfx_overhead, false)
		ParticleManager:ReleaseParticleIndex(self.pfx_overhead)
	end

	if not IsServer() or self:GetParent():IsAlive() then return end

	for _, enemy in pairs(self.bond_table) do
		if enemy ~= self:GetParent() then
		
			local bond_modifiers = enemy:FindAllModifiersByName("modifier_warlock_fatal_bonds_lua")

			for _, modifier in pairs(bond_modifiers) do

				for num = #(modifier.bond_table), 1, -1 do
					
					if (modifier.bond_table)[num] == self:GetParent() then
						table.remove(modifier.bond_table, num)
						break
					end
				end
			end
		end
	end
end

function modifier_warlock_fatal_bonds_lua:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_PROPERTY_MOVESPEED_LIMIT,
	}

	return decFuncs
end

function modifier_warlock_fatal_bonds_lua:GetModifierMoveSpeed_Limit(keys)
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_warlock_int6")
		if abil ~= nil	then 
		return 150
		else 
		return 550
	end
end

function modifier_warlock_fatal_bonds_lua:OnTakeDamage(keys)
	if IsServer() and bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) ~= DOTA_DAMAGE_FLAG_REFLECTION then
		local unit = keys.unit
		local original_damage = keys.original_damage
		local damage_type = keys.damage_type
		local inflictor = keys.inflictor

		if unit == self:GetParent() and self.bond_table then
			for _, bonded_enemy in pairs(self.bond_table) do
				if not bonded_enemy:IsNull() and bonded_enemy ~= self:GetParent() then
					local damageTable = {
						victim			= bonded_enemy,
						damage			= keys.original_damage * self.link_damage_share_pct * 0.01,
						damage_type		= keys.damage_type,
						attacker		= self:GetCaster(),
						ability			= self.ability,
						damage_flags	= DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
					}

					ApplyDamage(damageTable)
				
					local particle_hit_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_warlock/warlock_fatal_bonds_hit.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
					ParticleManager:SetParticleControlEnt(particle_hit_fx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(particle_hit_fx, 1, bonded_enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", bonded_enemy:GetAbsOrigin(), true)
					ParticleManager:ReleaseParticleIndex(particle_hit_fx)
					
					if self.parent:HasModifier(self.modifier_word) and not bonded_enemy:HasModifier(self.modifier_word) then

						if not self.ability_word_handler then
							return nil
						end

						if not bonded_enemy:IsMagicImmune() then
							local modifier_word_handler = self.parent:FindModifierByName(self.modifier_word)
							if modifier_word_handler then
								local duration_remaining = modifier_word_handler:GetRemainingTime()
								bonded_enemy:AddNewModifier(self.caster, self.ability_word_handler, self.modifier_word, {duration = duration_remaining})
							end
						end
					end
				end
			end
		end
	end
end
