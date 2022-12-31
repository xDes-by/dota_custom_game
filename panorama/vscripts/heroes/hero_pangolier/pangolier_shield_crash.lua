modifier_pangolier_shield_crash_creep_check = class({})

function modifier_pangolier_shield_crash_creep_check:IsHidden() return true end
function modifier_pangolier_shield_crash_creep_check:IsDebuff() return false end
function modifier_pangolier_shield_crash_creep_check:IsPurgable() return false end
function modifier_pangolier_shield_crash_creep_check:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_pangolier_shield_crash_creep_check:OnCreated()
	if IsClient() then return end
	if self:GetParent():HasModifier("modifier_pangolier_gyroshell") then
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("jump_duration_gyroshell") - 0.1)
	else
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("jump_duration") - 0.1)
	end 
end

function modifier_pangolier_shield_crash_creep_check:OnIntervalThink()
	local caster = self:GetParent()
	local ability = self:GetAbility()

	local buff_duration = ability:GetSpecialValueFor("duration")
	local radius = ability:GetSpecialValueFor("radius")
	local creep_stacks = ability:GetSpecialValueFor("creep_stacks")
	local hero_stacks = ability:GetSpecialValueFor("hero_stacks")

	local creeps = FindUnitsInRadius(	caster:GetTeamNumber(), 
										caster:GetAbsOrigin(), 
										nil, 
										radius, 
										DOTA_UNIT_TARGET_TEAM_ENEMY, 
										DOTA_UNIT_TARGET_CREEP, 
										DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	local heroes = FindUnitsInRadius(	caster:GetTeamNumber(), 
										caster:GetAbsOrigin(), 
										nil, 
										radius, 
										DOTA_UNIT_TARGET_TEAM_ENEMY, 
										DOTA_UNIT_TARGET_HERO, 
										DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false)

	if not caster:HasModifier("modifier_pangolier_shield_crash_buff") then
		caster:AddNewModifier(caster, ability, "modifier_pangolier_shield_crash_buff", {duration = buff_duration})
	end
	local buff = caster:FindModifierByName("modifier_pangolier_shield_crash_buff")

	if buff then
		local damage_resistance = 0
		local damage_resistance_buff = buff:GetStackCount() or 0
		damage_resistance = damage_resistance + #creeps * creep_stacks + #heroes * hero_stacks

		buff:SetStackCount(math.max(damage_resistance, damage_resistance_buff))
		buff:ForceRefresh()
	end

	self:Destroy()
end
