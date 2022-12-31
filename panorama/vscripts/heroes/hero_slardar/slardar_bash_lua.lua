slardar_bash_lua = class({})
LinkLuaModifier("modifier_slardar_bash_lua_counter", "heroes/hero_slardar/slardar_bash_lua", LUA_MODIFIER_MOTION_NONE)

function slardar_bash_lua:GetIntrinsicModifierName()
	return "modifier_slardar_bash_lua_counter"
end


function slardar_bash_lua:GetCooldown(level)
	local caster = self:GetCaster()
	if not caster or caster:IsNull() then return self.BaseClass.GetCooldown(self, level) end
	if caster:HasModifier("modifier_hero_dueling") then return self:GetSpecialValueFor("duel_cooldown") end
	return 0
end




modifier_slardar_bash_lua_counter = class({})


function modifier_slardar_bash_lua_counter:IsPurgable() 	return false end
function modifier_slardar_bash_lua_counter:IsHidden() 		return self:GetStackCount() == 0 end
function modifier_slardar_bash_lua_counter:RemoveOnDeath() 	return false end


function modifier_slardar_bash_lua_counter:OnCreated()
	if not IsServer() then return end
	self:OnRefresh()
end


function modifier_slardar_bash_lua_counter:OnRefresh()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	if not self.ability or self.ability:IsNull() then self:Destroy() return end
	if not self.parent or self.parent:IsNull() then self:Destroy() return end

	self.bonus_damage 	= self.ability:GetSpecialValueFor("bonus_damage")
	self.bash_duration 	= self.ability:GetSpecialValueFor("duration")
	self.attack_count 	= self.ability:GetSpecialValueFor("attack_count")
end


function modifier_slardar_bash_lua_counter:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_TOOLTIP,
	}
end


function modifier_slardar_bash_lua_counter:OnTooltip()
	return self.attack_count
end


if not IsServer() then return end


function modifier_slardar_bash_lua_counter:GetModifierProcAttack_BonusDamage_Physical(params)
	if not params.target or params.target:IsNull() then return end
	if not self.ability or self.ability:IsNull() then return end
	if not self.parent or self.parent:IsNull() then return end
	
	if params.target:IsOther() then return end
	if not self.ability:IsCooldownReady() then return end
	if self.parent:PassivesDisabled() then return end
	if self.parent:IsIllusion() then return end

	self:IncrementStackCount()

	if self:GetStackCount() <= self.attack_count then return 0 end

	params.target:AddNewModifier(self.parent, self.ability, "modifier_bashed", {
		duration = self.bash_duration * (1 - params.target:GetStatusResistance())
	})
	params.target:EmitSound("Hero_Slardar.Bash")

	self:SetStackCount(0)
	self.ability:UseResources(false, false, true)

	local bash_bonus_damage = self.bonus_damage + self.parent:FindTalentValue("special_bonus_unique_slardar_2")

	-- double damage to creeps
	if params.target:IsCreep() or params.target:IsCreepHero() then
		return bash_bonus_damage * 2
	end

	return bash_bonus_damage
end
