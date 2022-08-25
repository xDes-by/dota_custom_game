LinkLuaModifier("modifier_legion_ult", "heroes/hero_legion/legion_ult/legion_ult", LUA_MODIFIER_MOTION_NONE)

legion_ult = class({})

function legion_ult:GetIntrinsicModifierName()
	return "modifier_legion_ult"
end

modifier_legion_ult = class({})

function modifier_legion_ult:IsHidden() return false end
function modifier_legion_ult:IsDebuff() return false end
function modifier_legion_ult:IsPurgable() return false end
function modifier_legion_ult:IsPermanent() return true end
function modifier_legion_ult:RemoveOnDeath() return false end
function modifier_legion_ult:GetTexture()
    return "legion_commander_duel"
end

stack = 0.01

function modifier_legion_ult:OnCreated()
	self.shag = self:GetAbility():GetSpecialValueFor( "shag" )
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	self:StartIntervalThink(1.0)
end

function modifier_legion_ult:OnRefresh( kv )
	self.shag = self:GetAbility():GetSpecialValueFor( "shag" )
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
end
	
function modifier_legion_ult:OnIntervalThink()	
	self:OnRefresh()	
		self.caster = self:GetCaster()
		
		local level = self:GetAbility():GetLevel()
		
	if self:GetCaster():FindAbilityByName("npc_dota_hero_legion_commander_str_last") ~= nil then
		self.bonus_damage = self.bonus_damage * 5
	end
		local abil = self.caster:FindAbilityByName("npc_dota_hero_legion_commander_agi6")
		if abil ~= nil then 
		self.bonus_damage = self.bonus_damage + 1
		end
		
		local abil = self.caster:FindAbilityByName("npc_dota_hero_legion_commander_agi9")
		if abil ~= nil then 
		self.shag = self.shag - 1
		end
		
		local how = 1/self.shag
		stack = stack + how
	
		add_stack = math.floor(stack)
		if stack >= 1 then
		stack = 0
		end
		
	if IsServer() then	
		self.caster:SetModifierStackCount("modifier_legion_ult", self.caster, self:GetStackCount() + (add_stack * self.bonus_damage))
	end
end


function modifier_legion_ult:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE
	}
	return funcs
end

function modifier_legion_ult:GetModifierPreAttack_BonusDamage()
    return self:GetStackCount()
end

function modifier_legion_ult:GetModifierConstantHealthRegen()
self.caster = self:GetCaster()
local abil = self.caster:FindAbilityByName("npc_dota_hero_legion_commander_str9")
		if abil ~= nil then 
    return self:GetStackCount()/2
	end
	return 0
end

function modifier_legion_ult:GetModifierPercentageManacost()
self.caster = self:GetCaster()
local abil = self.caster:FindAbilityByName("npc_dota_hero_legion_commander_int8")
		if abil ~= nil then 
    return 100
	end
	return 0
end