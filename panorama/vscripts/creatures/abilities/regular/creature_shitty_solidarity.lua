LinkLuaModifier("modifier_creature_shitty_solidarity", "creatures/abilities/regular/creature_shitty_solidarity", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_shitty_solidarity_buff", "creatures/abilities/regular/creature_shitty_solidarity", LUA_MODIFIER_MOTION_NONE)

creature_shitty_solidarity = class({})

function creature_shitty_solidarity:GetIntrinsicModifierName()
	return "modifier_creature_shitty_solidarity"
end

modifier_creature_shitty_solidarity = class({})

function modifier_creature_shitty_solidarity:IsHidden() return true end
function modifier_creature_shitty_solidarity:IsDebuff() return false end
function modifier_creature_shitty_solidarity:IsPurgable() return false end
function modifier_creature_shitty_solidarity:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_creature_shitty_solidarity:RemoveOnDeath() return false end

function modifier_creature_shitty_solidarity:OnCreated(keys)
	self:OnRefresh(keys)
end

function modifier_creature_shitty_solidarity:OnRefresh(keys)
	self.power_mult = self:GetAbility():GetSpecialValueFor("power_mult")
end

function modifier_creature_shitty_solidarity:DeclareFunctions()
	if IsServer() then return {	MODIFIER_EVENT_ON_DEATH } end
end

function modifier_creature_shitty_solidarity:OnDeath(keys)
	if IsClient() or (not keys.unit) or keys.unit ~= self:GetParent() then return end
	-- disable stats increases if creep is illusion or dominated
	if keys.unit:IsIllusion() then return end
	if keys.unit:GetTeam() ~= DOTA_TEAM_NEUTRALS then return end

	keys.unit:EmitSound("CreaturePack.Death")

	local allies = FindUnitsInRadius(keys.unit:GetTeam(), keys.unit:GetAbsOrigin(), nil, 1500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, ally in pairs(allies) do

		local max_health = ally:GetMaxHealth()
		local min_damage = ally:GetBaseDamageMin()
		local max_damage = ally:GetBaseDamageMax()
		local heal = ally:GetHealth()

		max_health = math.min(self.power_mult * max_health, 10 * ROUND_MANAGER_CREEP_STATS_CAP)
		min_damage = math.min(self.power_mult * min_damage, ROUND_MANAGER_CREEP_STATS_CAP)
		max_damage = math.min(self.power_mult * max_damage, ROUND_MANAGER_CREEP_STATS_CAP)
		heal = math.min((self.power_mult - 1) * heal, 10 * ROUND_MANAGER_CREEP_STATS_CAP)

		ally:SetBaseMaxHealth(max_health)
		ally:SetMaxHealth(max_health)
		ally:SetBaseDamageMin(min_damage)
		ally:SetBaseDamageMax(max_damage)
		ally:Heal(heal, nil)

		ally:AddNewModifier(ally, nil, "modifier_creature_shitty_solidarity_buff", {}):IncrementStackCount()
	end
end



modifier_creature_shitty_solidarity_buff = class({})

function modifier_creature_shitty_solidarity_buff:IsHidden() return false end
function modifier_creature_shitty_solidarity_buff:IsDebuff() return false end
function modifier_creature_shitty_solidarity_buff:IsPurgable() return false end
function modifier_creature_shitty_solidarity_buff:GetTexture() return "skeleton_king_reincarnation" end

function modifier_creature_shitty_solidarity_buff:GetEffectName() return "particles/creature/shitty_solidarity.vpcf" end

function modifier_creature_shitty_solidarity_buff:DeclareFunctions()
	return { MODIFIER_PROPERTY_MODEL_SCALE }
end

function modifier_creature_shitty_solidarity_buff:GetModifierModelScale() return 18 * self:GetStackCount() end
