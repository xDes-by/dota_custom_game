LinkLuaModifier("modifier_boss_8_illusion_cast", "abilities/bosses/line/boss_8/boss_8_illusion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_boss_8_illusion_attack", "abilities/bosses/line/boss_8/boss_8_illusion", LUA_MODIFIER_MOTION_NONE)

boss_8_illusion = class({})

function boss_8_illusion:OnSpellStart()
if not IsServer() then return end
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_boss_8_illusion_cast", {duration =  self:GetSpecialValueFor("duration")})
end

---------------------------------------------------------------------------------------------------------------------
modifier_boss_8_illusion_cast = class({})
function modifier_boss_8_illusion_cast:IsHidden() return true end
function modifier_boss_8_illusion_cast:IsPurgable() return false end
function modifier_boss_8_illusion_cast:RemoveOnDeath() return true end

function modifier_boss_8_illusion_cast:OnCreated()
	if IsServer() then
		StartAnimation(self:GetCaster(), {duration = self:GetAbility():GetSpecialValueFor("duration"), rate = 2, activity = ACT_DOTA_ATTACK, translate = "fast"})
		self:StartIntervalThink(1)
	end
end

function modifier_boss_8_illusion_cast:OnIntervalThink()
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_CLOSEST, false)
	for _,enemy in pairs(enemies) do
		if enemy:IsRealHero() then
			local creep = CreateUnitByName( "boss_8_minion", enemy:GetAbsOrigin() + RandomVector(RandomInt(50, 100)), true, nil, nil, self:GetCaster():GetTeamNumber() )
			creep:SetBaseDamageMin(self:GetCaster():GetBaseDamageMin())
			creep:SetBaseDamageMax(self:GetCaster():GetBaseDamageMax())
			creep:SetPhysicalArmorBaseValue(self:GetCaster():GetPhysicalArmorBaseValue())
			creep:SetBaseMagicalResistanceValue(self:GetCaster():GetBaseMagicalResistanceValue())
			creep:SetMaxHealth(self:GetCaster():GetMaxHealth())
			creep:SetBaseMaxHealth(self:GetCaster():GetBaseMaxHealth())
			creep:SetHealth(self:GetCaster():GetHealth())
			creep:AddNewModifier(self:GetCaster(), nil, "modifier_boss_8_illusion_attack", {duration = 1})
			creep:SetForceAttackTarget( enemy ) 
		end	
	end	
end

function modifier_boss_8_illusion_cast:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,	
		[MODIFIER_STATE_STUNNED] = true,
	}
	return state
end

-----------------------------------------------------------------------------------------------------------------------

modifier_boss_8_illusion_attack  = class({})

function modifier_boss_8_illusion_attack:IsPurgable()
	return false
end

function modifier_boss_8_illusion_attack:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
	}
	return state
end

function modifier_boss_8_illusion_attack:OnDestroy()
	self:GetParent():ForceKill(false)
end