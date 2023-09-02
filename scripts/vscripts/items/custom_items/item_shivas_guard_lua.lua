item_shivas_guard_lua = class({})

item_shivas_guard_lua1 = item_shivas_guard_lua
item_shivas_guard_lua2 = item_shivas_guard_lua
item_shivas_guard_lua3 = item_shivas_guard_lua
item_shivas_guard_lua4 = item_shivas_guard_lua
item_shivas_guard_lua5 = item_shivas_guard_lua
item_shivas_guard_lua6 = item_shivas_guard_lua
item_shivas_guard_lua7 = item_shivas_guard_lua
item_shivas_guard_lua8 = item_shivas_guard_lua

item_shivas_guard_lua1_gem1 = item_shivas_guard_lua
item_shivas_guard_lua2_gem1 = item_shivas_guard_lua
item_shivas_guard_lua3_gem1 = item_shivas_guard_lua
item_shivas_guard_lua4_gem1 = item_shivas_guard_lua
item_shivas_guard_lua5_gem1 = item_shivas_guard_lua
item_shivas_guard_lua6_gem1 = item_shivas_guard_lua
item_shivas_guard_lua7_gem1 = item_shivas_guard_lua
item_shivas_guard_lua8_gem1 = item_shivas_guard_lua

item_shivas_guard_lua1_gem2 = item_shivas_guard_lua
item_shivas_guard_lua2_gem2 = item_shivas_guard_lua
item_shivas_guard_lua3_gem2 = item_shivas_guard_lua
item_shivas_guard_lua4_gem2 = item_shivas_guard_lua
item_shivas_guard_lua5_gem2 = item_shivas_guard_lua
item_shivas_guard_lua6_gem2 = item_shivas_guard_lua
item_shivas_guard_lua7_gem2 = item_shivas_guard_lua
item_shivas_guard_lua8_gem2 = item_shivas_guard_lua

item_shivas_guard_lua1_gem3 = item_shivas_guard_lua
item_shivas_guard_lua2_gem3 = item_shivas_guard_lua
item_shivas_guard_lua3_gem3 = item_shivas_guard_lua
item_shivas_guard_lua4_gem3 = item_shivas_guard_lua
item_shivas_guard_lua5_gem3 = item_shivas_guard_lua
item_shivas_guard_lua6_gem3 = item_shivas_guard_lua
item_shivas_guard_lua7_gem3 = item_shivas_guard_lua
item_shivas_guard_lua8_gem3 = item_shivas_guard_lua

item_shivas_guard_lua1_gem4 = item_shivas_guard_lua
item_shivas_guard_lua2_gem4 = item_shivas_guard_lua
item_shivas_guard_lua3_gem4 = item_shivas_guard_lua
item_shivas_guard_lua4_gem4 = item_shivas_guard_lua
item_shivas_guard_lua5_gem4 = item_shivas_guard_lua
item_shivas_guard_lua6_gem4 = item_shivas_guard_lua
item_shivas_guard_lua7_gem4 = item_shivas_guard_lua
item_shivas_guard_lua8_gem4 = item_shivas_guard_lua

item_shivas_guard_lua1_gem5 = item_shivas_guard_lua
item_shivas_guard_lua2_gem5 = item_shivas_guard_lua
item_shivas_guard_lua3_gem5 = item_shivas_guard_lua
item_shivas_guard_lua4_gem5 = item_shivas_guard_lua
item_shivas_guard_lua5_gem5 = item_shivas_guard_lua
item_shivas_guard_lua6_gem5 = item_shivas_guard_lua
item_shivas_guard_lua7_gem5 = item_shivas_guard_lua
item_shivas_guard_lua8_gem5 = item_shivas_guard_lua

LinkLuaModifier("modifier_item_shivas_guard_lua", 'items/custom_items/item_shivas_guard_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_shivas_guard_aura_lua", 'items/custom_items/item_shivas_guard_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_shivas_guard_slow_lua", 'items/custom_items/item_shivas_guard_lua.lua', LUA_MODIFIER_MOTION_NONE)

function item_shivas_guard_lua:GetIntrinsicModifierName()
	return "modifier_item_shivas_guard_lua"
end

function item_shivas_guard_lua:OnSpellStart()
	local blast_radius = self:GetSpecialValueFor("blast_radius")
	local blast_speed = self:GetSpecialValueFor("blast_speed")
	local damage = self:GetSpecialValueFor("blast_damage")
	local blast_duration = blast_radius / blast_speed
	local current_loc = self:GetCaster():GetAbsOrigin()
	
	local slow_duration_tooltip	= self:GetSpecialValueFor("slow_duration_tooltip")

	local caster	= self:GetCaster()
	local ability	= self

	self:GetCaster():EmitSound("DOTA_Item.ShivasGuard.Activate")

	local blast_pfx = ParticleManager:CreateParticle("particles/items2_fx/shivas_guard_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(blast_pfx, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl(blast_pfx, 1, Vector(blast_radius, blast_duration * 1.33, blast_speed))
	ParticleManager:ReleaseParticleIndex(blast_pfx)

	local targets_hit = {}

	local current_radius = 0
	local tick_interval = 0.1
	Timers:CreateTimer(tick_interval, function()
		AddFOWViewer(self:GetCaster():GetTeamNumber(), current_loc, current_radius, 0.1, false)

		current_radius = current_radius + blast_speed * tick_interval
		current_loc = self:GetCaster():GetAbsOrigin()

		local nearby_enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), current_loc, nil, current_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,enemy in pairs(nearby_enemies) do
			local enemy_has_been_hit = false
			for _,enemy_hit in pairs(targets_hit) do
				if enemy == enemy_hit then enemy_has_been_hit = true end
			end

			if not enemy_has_been_hit then
				local hit_pfx = ParticleManager:CreateParticle("particles/items2_fx/shivas_guard_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
				ParticleManager:SetParticleControl(hit_pfx, 0, enemy:GetAbsOrigin())
				ParticleManager:SetParticleControl(hit_pfx, 1, enemy:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(hit_pfx)

				ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

				enemy:AddNewModifier(caster, ability, "modifier_item_shivas_guard_slow_lua", {duration = 4})

				end
				
				targets_hit[#targets_hit + 1] = enemy
		end
		if current_radius < blast_radius then
			return tick_interval
		end
	end)
end

-------------------------------------------------------------------------------------

modifier_item_shivas_guard_slow_lua = class({})

function modifier_item_shivas_guard_slow_lua:OnCreated()
	self.blast_movement_speed = self:GetAbility():GetSpecialValueFor("blast_movement_speed")
end

function modifier_item_shivas_guard_slow_lua:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end

function modifier_item_shivas_guard_slow_lua:GetModifierMoveSpeedBonus_Percentage()
	return self.blast_movement_speed
end



-------------------------------------------------------------------------------------
modifier_item_shivas_guard_aura_lua = class({})

function modifier_item_shivas_guard_aura_lua:IsHidden() return false end
function modifier_item_shivas_guard_aura_lua:IsPurgable() return false end
function modifier_item_shivas_guard_aura_lua:RemoveOnDeath() return false end
function modifier_item_shivas_guard_aura_lua:IsAuraActiveOnDeath() return false end

function modifier_item_shivas_guard_aura_lua:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_item_shivas_guard_aura_lua:GetModifierHPRegenAmplify_Percentage()
	return ( self:GetAbility():GetSpecialValueFor("hp_regen_degen_aura") * (-1) )
end

function modifier_item_shivas_guard_aura_lua:GetModifierAttackSpeedBonus_Constant()
	return (self:GetAbility():GetSpecialValueFor("aura_attack_speed"))
end

-------------------------------------------------------------------------------------

modifier_item_shivas_guard_lua = class({})

function modifier_item_shivas_guard_lua:IsHidden()
	return true
end

function modifier_item_shivas_guard_lua:IsPurgable()
	return false
end

function modifier_item_shivas_guard_lua:RemoveOnDeath()	
	return false 
end

function modifier_item_shivas_guard_lua:OnCreated()
	self.parent = self:GetParent()
	self.bonus_intellect = self:GetAbility():GetSpecialValueFor("bonus_intellect")
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
	if not IsServer() then
		return
	end
	self.value = self:GetAbility():GetSpecialValueFor("bonus_gem")
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {value = self.value})
	end
end

function modifier_item_shivas_guard_lua:OnDestroy()
	if not IsServer() then
		return
	end
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {value = self.value * -1})
	end
end

function modifier_item_shivas_guard_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end

function modifier_item_shivas_guard_lua:GetModifierBonusStats_Intellect()
	return self.bonus_intellect
end

function modifier_item_shivas_guard_lua:GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end

function modifier_item_shivas_guard_lua:IsAura()					return true end
function modifier_item_shivas_guard_lua:IsAuraActiveOnDeath() 		return false end
function modifier_item_shivas_guard_lua:GetAuraRadius()				return self:GetAbility():GetSpecialValueFor("aura_radius") end
function modifier_item_shivas_guard_lua:GetAuraSearchFlags()		return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_item_shivas_guard_lua:GetAuraSearchTeam()			return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_item_shivas_guard_lua:GetAuraSearchType()			return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_item_shivas_guard_lua:GetModifierAura()			return "modifier_item_shivas_guard_aura_lua" end