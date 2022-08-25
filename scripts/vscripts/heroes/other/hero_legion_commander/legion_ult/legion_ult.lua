LinkLuaModifier("modifier_legion_ult", "heroes/hero_legion_commander/legion_ult/legion_ult", LUA_MODIFIER_MOTION_NONE)

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
    return "abyssal_underlord_cancel_dark_rift"
end


stack = 0.01
if IsServer() then
    function modifier_legion_ult:OnCreated()
		self:StartIntervalThink(1.0)
	end
	function modifier_legion_ult:OnIntervalThink()
		
		self.caster = self:GetCaster()
		
		local level = self:GetAbility():GetLevel()
		self.shag = self:GetAbility():GetSpecialValueFor( "shag" )
		self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
		
		local abil = self.caster:FindAbilityByName("special_bonus_unique_lega_custom")
		if abil ~= nil and abil:IsTrained()	then 
		bonus = abil:GetSpecialValueFor( "value" )
		self.shag = self.shag - 1
		end
		
		local how = 1/self.shag
		stack = stack + how
	
		add_stack = math.floor(stack)
		if stack >= 1 then
		stack = 0
		end
		
		self.caster:SetModifierStackCount("modifier_legion_ult", caster, self:GetStackCount() + (add_stack * self.bonus_damage))
	end
end

function modifier_legion_ult:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
	return funcs
end

function modifier_legion_ult:GetModifierPreAttack_BonusDamage()
    return self:GetStackCount()
end


