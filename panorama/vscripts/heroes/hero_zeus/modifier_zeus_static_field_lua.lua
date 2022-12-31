modifier_zeus_static_field_lua = class({})

function modifier_zeus_static_field_lua:IsHidden() return true end
function modifier_zeus_static_field_lua:IsPurgable() return false end

if not IsServer() then return end

function modifier_zeus_static_field_lua:OnCreated() 
	self:SetStats()
end


function modifier_zeus_static_field_lua:OnRefresh()
	self:SetStats()
end


function modifier_zeus_static_field_lua:SetStats()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	self.damage_health_pct = self.ability:GetSpecialValueFor("damage_health_pct") + self.parent:FindTalentValue("special_bonus_unique_zeus")
	self.damage_health_pct = self.damage_health_pct / 100.0
	self.nonzeus_multiplier = self.ability:GetSpecialValueFor("nonzeus_multiplier") / 100.0
	self.shock_duration = self.ability:GetSpecialValueFor("shock_duration")

	self.damage_table = {
		attacker = self.parent,
		damage_type = DAMAGE_TYPE_MAGICAL,
		damage_flag = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
		ability = self.ability,
	}

	self.zeus_abilities = {
		["zuus_arc_lightning"] = true,
		["zuus_lightning_bolt"] = true,
		["zuus_thundergods_vengeance"] = true,
	}
end


function modifier_zeus_static_field_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}
end

function modifier_zeus_static_field_lua:GetModifierProcAttack_Feedback(params)
	if self.parent:IsIllusion() then return end

	if params.target:HasModifier("modifier_zeus_static_field_shock_lua") then return end
	self:Shock(params.target, self.parent:GetUnitName() == "npc_dota_hero_zuus", true)
end

function modifier_zeus_static_field_lua:GetModifierTotalDamageOutgoing_Percentage(params)
	if self.parent:IsIllusion() then return end

	local inflictor = params.inflictor
	if not inflictor then return end

	if inflictor == self.ability then return end
	if inflictor:IsItem() then return end
	if inflictor:IsPassive() then return end
	if inflictor:HasBehavior(DOTA_ABILITY_BEHAVIOR_PASSIVE) then return end

	if self.parent:PassivesDisabled() then return end

	local is_zeus_ability = self.zeus_abilities[inflictor:GetAbilityName()]

	if params.target:HasModifier("modifier_zeus_static_field_shock_lua") and not is_zeus_ability then return end

	self:Shock(params.target, is_zeus_ability)

	return 100
end

function modifier_zeus_static_field_lua:Shock(target, is_zeus_ability, is_attack)
	if is_attack or not is_zeus_ability and target and target:IsAlive() then
		target:AddNewModifier(self.parent, self.ability, "modifier_zeus_static_field_shock_lua", {duration = self.shock_duration})
	end
	
	self.damage_table.victim = target
	self.damage_table.damage = target:GetHealth() * self.damage_health_pct
	if not is_zeus_ability then self.damage_table.damage = self.damage_table.damage * self.nonzeus_multiplier end
	ApplyDamage(self.damage_table)
	target:EmitSound("Hero_Zuus.StaticField")

	local particle_cast = ParticleManager:GetParticleReplacement("particles/units/heroes/hero_zuus/zuus_static_field.vpcf", self.parent)
	local particle = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle)
end
