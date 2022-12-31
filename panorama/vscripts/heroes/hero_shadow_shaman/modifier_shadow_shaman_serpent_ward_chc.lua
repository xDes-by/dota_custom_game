---@class modifier_shadow_shaman_serpent_ward_chc:CDOTA_Modifier_Lua
modifier_shadow_shaman_serpent_ward_chc = class({})


function modifier_shadow_shaman_serpent_ward_chc:IsHidden() return true end
function modifier_shadow_shaman_serpent_ward_chc:IsPurgable() return false end
function modifier_shadow_shaman_serpent_ward_chc:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_shadow_shaman_serpent_ward_chc:CheckState()
	return {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true
	}
end

function modifier_shadow_shaman_serpent_ward_chc:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_LIFETIME_FRACTION,
		MODIFIER_PROPERTY_AVOID_DAMAGE,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_DISABLE_HEALING,
	}
end

function modifier_shadow_shaman_serpent_ward_chc:GetDisableHealing()
	return 1
end


function modifier_shadow_shaman_serpent_ward_chc:OnAttack(event)
	local parent = self:GetParent()
	if event.attacker == parent and not self.lock_attack_event then
		local caster = self:GetCaster()
		if caster and caster:HasScepter() then
			local targets = FindUnitsInRadius(
				parent:GetTeam(), 
				parent:GetAbsOrigin(),
				nil,
				parent:Script_GetAttackRange(),
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_ALL - DOTA_UNIT_TARGET_OTHER,
				DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE,
				FIND_ANY_ORDER,
				false
			)

			--exclude original attack target
			table.remove_item(targets, event.target)

			if #targets > 0 then
				local target = table.random(targets)
				self.lock_attack_event = true
				parent:PerformAttack(target, false, false, true, false, true, false, false)
				self.lock_attack_event = false
			end
		end
	end
end

function modifier_shadow_shaman_serpent_ward_chc:GetModifierAttackRangeBonus()
	local caster = self:GetCaster()

	if caster then
		local bonus = caster:FindTalentValue("special_bonus_unique_shadow_shaman_8")
		
		if caster:HasScepter() then
			bonus = bonus + (self.scepter_range or 0)
		end

		return bonus
	end
	return 0
end

function modifier_shadow_shaman_serpent_ward_chc:GetModifierAvoidDamage(params)
	local parent = self:GetParent()
	local health = parent:GetHealth()

	if params.damage_category == DOTA_DAMAGE_CATEGORY_SPELL then 
		return 1
	end

	local damage = params.attacker:IsRealHero() and 4 or (params.attacker:IsControllableByAnyPlayer() and 2) or 1

	if health > damage then
		parent:SetHealth(health - damage)
	else
		parent:Kill(nil, params.attacker)
	end

	return 1
end

function modifier_shadow_shaman_serpent_ward_chc:GetUnitLifetimeFraction()
    return (self:GetDieTime() - GameRules:GetGameTime()) / self:GetDuration()
end

function modifier_shadow_shaman_serpent_ward_chc:OnCreated(kv)
	if IsServer() then
		self:StartIntervalThink(0.1)
		self.ward_count = kv.ward_count or 1
		self:SetStackCount(self.ward_count)
	end

	local ability = self:GetAbility()
	if ability then
		self.scepter_range = ability:GetSpecialValueFor("scepter_range")
	end
end

function modifier_shadow_shaman_serpent_ward_chc:GetModifierModelScale()
	local parent = self:GetParent()

	local ward_count = self:GetStackCount()
	local round_to = 100 / ward_count
	local x = math.ceil(parent:GetHealthPercent() / round_to) * round_to

	return x * ward_count / 10
end

if IsClient() then return end

function modifier_shadow_shaman_serpent_ward_chc:OnDestroy()
	self:GetParent():ForceKill(false)
end

function modifier_shadow_shaman_serpent_ward_chc:OnIntervalThink()
	local parent = self:GetParent()
	self.original_damage_min = self.original_damage_min or parent:GetBaseDamageMin()
	self.original_damage_max = self.original_damage_max or parent:GetBaseDamageMax()

	--Set wards damage according to their health
	local round_to = 100 / self.ward_count
	local x = math.ceil(parent:GetHealthPercent() / round_to) * round_to / 100
	parent:SetBaseDamageMin(self.original_damage_min * x)
	parent:SetBaseDamageMax(self.original_damage_max * x)
end

