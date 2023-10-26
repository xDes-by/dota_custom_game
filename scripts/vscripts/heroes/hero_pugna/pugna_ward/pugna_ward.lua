LinkLuaModifier("modifier_pugna_nether_ward_lua", "heroes/hero_pugna/pugna_ward/pugna_ward.lua", LUA_MODIFIER_MOTION_NONE)


pugna_nether_ward_lua = class({})
local ability_class = pugna_nether_ward_lua

function ability_class:GetAOERadius()
	return self:GetSpecialValueFor('radius')
end
function ability_class:GetCastRange(vLocation, hTarget)
	return self:GetSpecialValueFor('cast_range')
end

function ability_class:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end

if IsServer() then
	function ability_class:OnSpellStart()
		local ability = self
		local caster = self:GetCaster()
		local point = self:GetCursorPosition()
		local duration = ability:GetSpecialValueFor('duration')

		EmitSoundOn("Hero_Pugna.NetherWard", caster)
		if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_pugna_int50") then
			local position = point
			local unit_name = 'npc_dota_pugna_nether_ward_lua'
			local unit = CreateUnitByName(unit_name, position, false, caster, caster, caster:GetTeamNumber())
			if unit and IsValidEntity(unit) then
				FindClearSpaceForUnit(unit, position, false)
				unit:AddNewModifier(caster, ability, "modifier_kill", {duration = duration})
				unit:AddNewModifier(caster, ability, "modifier_pugna_nether_ward_lua", {duration = duration})
			end
		end
		local position = point
		local unit_name = 'npc_dota_pugna_nether_ward_lua'
		local unit = CreateUnitByName(unit_name, position, false, caster, caster, caster:GetTeamNumber())
		if unit and IsValidEntity(unit) then
			FindClearSpaceForUnit(unit, position, false)
			unit:AddNewModifier(caster, ability, "modifier_kill", {duration = duration})
			unit:AddNewModifier(caster, ability, "modifier_pugna_nether_ward_lua", {duration = duration})
		end		
	end
end

-----------------------------------------------------------------------------------------

modifier_pugna_nether_ward_lua = class({})
local modifier_effect = modifier_pugna_nether_ward_lua

function modifier_effect:IsHidden() return true end
function modifier_effect:IsPurgable() return false end

function modifier_effect:GetEffectName()
	return "particles/units/heroes/hero_pugna/pugna_ward_ambient.vpcf"
end
function modifier_effect:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_BONUS_DAY_VISION,
		MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		-- MODIFIER_EVENT_ON_ATTACKED,
	}
end

function modifier_effect:GetModifierAttackRangeBonus( )
	return self:GetAbility():GetSpecialValueFor('radius')
end
function modifier_effect:GetBonusDayVision( )
	return self:GetAbility():GetSpecialValueFor('radius')
end
function modifier_effect:GetBonusNightVision( )
	return self:GetAbility():GetSpecialValueFor('radius')
end



function modifier_effect:OnTakeDamage( event )
	if not IsServer() then return nil end
	if event.unit ~= self:GetParent() then return nil end
	if event.attacker:IsIllusion() then return nil end

	local target = event.unit
	local attacker = event.attacker

	self:_OnAttacked(attacker)
end

function modifier_effect:OnAttacked( event )
	if not IsServer() then return nil end
	if event.target ~= self:GetParent() then return nil end
	if event.attacker:IsIllusion() then return nil end

	local target = event.target
	local attacker = event.attacker

end

if IsServer() then
	function modifier_effect:OnCreated(table)
		local parent = self:GetParent()
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local radius = ability:GetSpecialValueFor('radius')
		local interval = ability:GetSpecialValueFor('interval')
		local attacks_to_destroy = ability:GetSpecialValueFor('attacks_to_destroy')
		parent.attack_counter = attacks_to_destroy
		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_pugna_int10")	
		if abil ~= nil then 
		interval = interval - 1
		end	

		local health = attacks_to_destroy
		parent:SetBaseMaxHealth(health)
		parent:SetMaxHealth(health)
		parent:SetHealth(health)
		parent:ModifyHealth(health, ability, false, 0)

		self:OnIntervalThink()
		self:StartIntervalThink(interval)
	end

	function modifier_effect:OnDestroy()
		local parent = self:GetParent()
		self:StartIntervalThink(-1)
		parent:ForceKill(false)
	end

	function modifier_effect:OnIntervalThink()
		local parent = self:GetParent()
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		
		local radius = ability:GetSpecialValueFor('radius')
		local max_count = ability:GetSpecialValueFor('count')
		local base_damage = ability:GetSpecialValueFor("base_damage")
		intelligence_damage =  ability:GetSpecialValueFor("intelligence_damage")

		
		local damage = base_damage + caster:GetIntellect() * (intelligence_damage / 100.0)

		local enemy_list = FindUnitsInRadius(
			caster:GetTeamNumber(),
			parent:GetAbsOrigin(),
			nil,
			radius,
			ability:GetAbilityTargetTeam(),
			ability:GetAbilityTargetType(),
			ability:GetAbilityTargetFlags(),
			FIND_ANY_ORDER,
			false
		)
		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_pugna_int6")	
		if abil ~= nil then 
		max_count = max_count + 5
		end	
		
		
		local count = 0
		for _,enemy in pairs(enemy_list) do
			if count < max_count then
				count = count + 1
				self:_FireEffect(enemy)
				self:_ApplyDamage(enemy)
			end
		end
	end

	function modifier_effect:_OnAttacked(attacker)
		local parent = self:GetParent()
		local ability = self:GetAbility()
	
		if parent.attack_counter > 1 then
			parent.attack_counter = parent.attack_counter - 1
			parent:SetHealth(parent.attack_counter)
			parent:ModifyHealth(parent.attack_counter, ability, false, 0)
		end
	end

	function modifier_effect:_FireEffect(target)
		local parent = self:GetParent()
		local caster = self:GetCaster()
		local ability = self:GetAbility()

		local ward = parent
		-- There are some light/medium/heavy unused versions
		local p_list = {
			"particles/units/heroes/hero_pugna/pugna_ward_attack.vpcf",
			"particles/units/heroes/hero_pugna/pugna_ward_attack_light.vpcf",
			"particles/units/heroes/hero_pugna/pugna_ward_attack_medium.vpcf",
			"particles/units/heroes/hero_pugna/pugna_ward_attack_heavy.vpcf",
		}
		local p_id = RandomInt(1, #p_list)
		local p_name = p_list[p_id]
		local p_attack = ParticleManager:CreateParticle(p_name, PATTACH_ABSORIGIN_FOLLOW, ward)
		ParticleManager:SetParticleControl(p_attack, 1, target:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(p_attack)

		--target:EmitSound("Hero_Pugna.NetherWard.Target")
		-- caster:EmitSound("Hero_Pugna.NetherWard.Attack")
		ward:EmitSound("Hero_Pugna.NetherWard.Attack")
	end

	function modifier_effect:_ApplyDamage(target)
		local parent = self:GetParent()
		local caster = self:GetCaster()
		local ability = self:GetAbility()

		local base_damage = ability:GetSpecialValueFor("base_damage")
		local intelligence_damage =  ability:GetSpecialValueFor("intelligence_damage")
		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_pugna_int7")	
		if abil ~= nil then 
		intelligence_damage = intelligence_damage +25
		end	
		if self:GetCaster():FindAbilityByName("npc_dota_hero_pugna_str_last") ~= nil then
			intelligence_damage =  intelligence_damage + 50
		end
		damage = base_damage + caster:GetIntellect() * (intelligence_damage / 100.0)
		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_pugna_agi11")	
		if abil ~= nil then 
		damage = caster:GetAgility() + damage
		end	
		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_pugna_str6")	
		if abil ~= nil then 
		damage = self:GetCaster():GetStrength() + damage
		end	
			
		ApplyDamage({
			attacker = caster,
			victim = target,
			ability = ability,
			damage_type = DAMAGE_TYPE_MAGICAL,
			damage = damage
		})
	end

end
