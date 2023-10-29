pudge_flesh_heap_lua = class({})

LinkLuaModifier("modifier_flesh_heap_stacks_lua", "heroes/hero_pudge/flesh_heap/flesh_heap.lua", LUA_MODIFIER_MOTION_NONE)

function pudge_flesh_heap_lua:GetIntrinsicModifierName() 
    return "modifier_flesh_heap_stacks_lua" 
end

modifier_flesh_heap_stacks_lua = class({})

function modifier_flesh_heap_stacks_lua:IsHidden() 		
    return false 
end

function modifier_flesh_heap_stacks_lua:IsPurgable() 		
    return false
end

function modifier_flesh_heap_stacks_lua:RemoveOnDeath()
    return false
end

function modifier_flesh_heap_stacks_lua:OnCreated( kv )
	self.caster = self:GetCaster()
	self.stack_str = self:GetAbility():GetSpecialValueFor("stack_str")
	self.base_magic_resist = self:GetAbility():GetSpecialValueFor( "base_magic_resist" )
	self:StartIntervalThink(1)
end

function modifier_flesh_heap_stacks_lua:OnRefresh( kv )
	self.caster = self:GetCaster()
	self.stack_str = self:GetAbility():GetSpecialValueFor("stack_str")
	self.base_magic_resist = self:GetAbility():GetSpecialValueFor( "base_magic_resist" )
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_pudge_str9") ~= nil then 
	self.stack_str = self:GetAbility():GetSpecialValueFor("stack_str") + 0.5
	end
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_pudge_agi6") ~= nil then 
	self.stack_str = self:GetAbility():GetSpecialValueFor("stack_str") + 0.5
	end
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_pudge_str6") ~= nil then 
	self.base_magic_resist = self:GetAbility():GetSpecialValueFor("base_magic_resist") * 2
	end
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_pudge_str50") ~= nil then 
		self.double_stack = true
	end
end

function modifier_flesh_heap_stacks_lua:OnIntervalThink()
	self:OnRefresh()
end

function modifier_flesh_heap_stacks_lua:DeclareFunctions() 
	local funcs = {
			MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
			MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, 
			MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
			MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
			MODIFIER_EVENT_ON_DEATH,
			MODIFIER_EVENT_ON_TAKEDAMAGE
		}
	return funcs
end

function modifier_flesh_heap_stacks_lua:OnDeath(params)
	local parent = self:GetParent()
	if IsMyKilledBadGuys(parent, params) then
		self:IncrementStackCount()
		if self.double_stack then
			self:IncrementStackCount()
		end
		parent:CalculateStatBonus(true)
	end
end

function modifier_flesh_heap_stacks_lua:GetModifierBonusStats_Strength() 
if self:GetCaster():FindAbilityByName("npc_dota_hero_pudge_agi6") ~= nil then
	return 0
	end
	return self:GetStackCount() * self.stack_str
end

function modifier_flesh_heap_stacks_lua:GetModifierBonusStats_Agility()
if self:GetCaster():FindAbilityByName("npc_dota_hero_pudge_agi6") ~= nil then
	return self:GetStackCount() * self.stack_str
	end
	return 0
end

function modifier_flesh_heap_stacks_lua:GetModifierBonusStats_Intellect()
if self:GetCaster():FindAbilityByName("npc_dota_hero_pudge_int10") ~= nil then
	return self:GetStackCount() * self.stack_str
	end
	return 0
end

function modifier_flesh_heap_stacks_lua:GetModifierMagicalResistanceBonus()
	return self.base_magic_resist
end

function IsMyKilledBadGuys(hero, params)
    if params.unit:GetTeamNumber() ~= DOTA_TEAM_BADGUYS then
        return false
    end
    local attacker = params.attacker
    if hero == attacker then
        return true
    else
        if hero == attacker:GetOwner() then
            return true
        else
            return false
        end
    end
end

function modifier_flesh_heap_stacks_lua:OnTakeDamage(keys)
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local ability = self:GetAbility()
	local attacker = keys.attacker
	local target = keys.unit
	if self:GetCaster():FindAbilityByName("npc_dota_hero_pudge_int_last") ~= nil then
		if attacker:GetTeamNumber() ~= parent:GetTeamNumber() and parent == target and not attacker:IsOther() and not attacker:IsBuilding() then
			if RandomInt(0,100) < 5 then
				attacker:AddNewModifier(caster, self, "modifier_rot_enemy", {duration = 1})
			end
		end
	end
end

-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_rot_enemy", "heroes/hero_pudge/flesh_heap/flesh_heap.lua", LUA_MODIFIER_MOTION_NONE)

modifier_rot_enemy = class({})

function modifier_rot_enemy:IsDebuff()			
	return true 
end

function modifier_rot_enemy:IsHidden() 			
	return false 
end

function modifier_rot_enemy:IsPurgable() 		
	return false 
end

function modifier_rot_enemy:IsPurgeException() 	
	return false 
end

function modifier_rot_enemy:OnCreated()
	if IsServer() then
	
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_pudge/pudge_rot.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(pfx, 1, Vector(300, 0, 0))
	self:AddParticle(pfx, false, false, 15, false, false)
	
	self.atribute = self:GetCaster():GetStrength()
	caster_ability = self:GetCaster():FindAbilityByName("pudge_rot_lua")
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_pudge_int7") ~= nil then
		self.atribute = self:GetCaster():GetIntellect()
	end
	
	self.dmg = (caster_ability:GetSpecialValueFor("base_damage") + self.atribute * caster_ability:GetSpecialValueFor("damage_per_str"))/5
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_pudge_str8") ~= nil then
		self.dmg = (caster_ability:GetSpecialValueFor("base_damage")*2 + self.atribute * caster_ability:GetSpecialValueFor("damage_per_str"))/5	
	end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_pudge_str10") ~= nil then	
		self.dmg = (caster_ability:GetSpecialValueFor("base_damage") + self.atribute * (caster_ability:GetSpecialValueFor("damage_per_str")+0.2))/5
	end
		self:StartIntervalThink(caster_ability:GetSpecialValueFor("rot_tick"))
	end
end

function modifier_rot_enemy:OnIntervalThink()

	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetAbsOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		300,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	for _,enemy in pairs(enemies) do
	
	local damageTable = {
						victim = enemy,
						attacker = self:GetCaster(),
						damage = self.dmg,
						damage_type = caster_ability:GetAbilityDamageType(),
						damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
						}
	ApplyDamage(damageTable)
	end
end

function modifier_rot_enemy:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    }
    return decFuncs
end

function modifier_rot_enemy:GetModifierMagicalResistanceBonus()
if self:GetCaster():FindAbilityByName("npc_dota_hero_pudge_int8") ~= nil then
	return -15
	end
	return 0
end