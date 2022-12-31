LinkLuaModifier("modifier_boss_shield_wall", "creatures/abilities/boss/boss_shield_wall", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_boss_shield_wall_counter", "creatures/abilities/boss/boss_shield_wall", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_boss_shield_wall_buff", "creatures/abilities/boss/boss_shield_wall", LUA_MODIFIER_MOTION_NONE)

boss_shield_wall = class({})

function boss_shield_wall:GetIntrinsicModifierName()
	return "modifier_boss_shield_wall"
end



modifier_boss_shield_wall = class({})

function modifier_boss_shield_wall:IsHidden() return true end
function modifier_boss_shield_wall:IsDebuff() return false end
function modifier_boss_shield_wall:IsPurgable() return false end
function modifier_boss_shield_wall:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_boss_shield_wall:IsAura() return true end
function modifier_boss_shield_wall:GetAuraRadius() return 700 end
function modifier_boss_shield_wall:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_boss_shield_wall:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_boss_shield_wall:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_boss_shield_wall:GetModifierAura() return "modifier_boss_shield_wall_buff" end

function modifier_boss_shield_wall:GetAuraEntityReject(unit)
	if IsServer() then
		if self:GetStackCount() > 0 then
			return false
		else
			return true
		end
	end
end

function modifier_boss_shield_wall:OnCreated(keys)
	if IsServer() then
		Timers:CreateTimer(0.1, function()
			local initial_charges = self:GetAbility():GetSpecialValueFor("charges")
			if initial_charges >= 1 then
				for i = 1, initial_charges do
					self:ShieldUp()
				end
			end
		end)
	end
end

function modifier_boss_shield_wall:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_boss_shield_wall:OnAttackLanded(keys)
	if IsServer() then
		if keys.target == self:GetParent() then
			if self:GetStackCount() > 0 then
				self:ShieldDown()
			end
		end
	end
end

function modifier_boss_shield_wall:ShieldUp()
	if IsServer() then
		local parent = self:GetParent()
		self:IncrementStackCount()
		parent:EmitSound("BossShieldWall.Layer")
		parent:AddNewModifier(parent, self:GetAbility(), "modifier_boss_shield_wall_counter", {})
	end
end

function modifier_boss_shield_wall:ShieldDown()
	if IsServer() then
		local parent = self:GetParent()
		self:DecrementStackCount()
		parent:EmitSound("BossShieldWall.Break")
		parent:RemoveModifierByName("modifier_boss_shield_wall_counter")
	end
end



modifier_boss_shield_wall_counter = class({})

function modifier_boss_shield_wall_counter:IsHidden() return true end
function modifier_boss_shield_wall_counter:IsDebuff() return false end
function modifier_boss_shield_wall_counter:IsPurgable() return false end
function modifier_boss_shield_wall_counter:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_boss_shield_wall_counter:GetEffectName()
	return "particles/creature/boss_shield_wall.vpcf"
end

function modifier_boss_shield_wall_counter:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_boss_shield_wall_counter:ShouldUseOverheadOffset()
	return true
end



modifier_boss_shield_wall_buff = class({})

function modifier_boss_shield_wall_buff:IsHidden() return false end
function modifier_boss_shield_wall_buff:IsDebuff() return false end
function modifier_boss_shield_wall_buff:IsPurgable() return false end
function modifier_boss_shield_wall_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_boss_shield_wall_buff:GetEffectName()
	return "particles/creature/boss_shield_wall_buff.vpcf"
end

function modifier_boss_shield_wall_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_boss_shield_wall_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
	return funcs
end

function modifier_boss_shield_wall_buff:GetModifierIncomingDamage_Percentage()
	return -30
end
