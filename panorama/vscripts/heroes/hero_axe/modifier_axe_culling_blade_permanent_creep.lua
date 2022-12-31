modifier_axe_culling_blade_permanent_creep_lua = class({})

function modifier_axe_culling_blade_permanent_creep_lua:IsHidden() return false end
function modifier_axe_culling_blade_permanent_creep_lua:IsDebuff() return false end
function modifier_axe_culling_blade_permanent_creep_lua:IsPurgable() return false end
function modifier_axe_culling_blade_permanent_creep_lua:RemoveOnDeath() return false end
function modifier_axe_culling_blade_permanent_creep_lua:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_axe_culling_blade_permanent_creep_lua:OnCreated(keys)
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.caster or self.caster:IsNull() then return end
	if not self.ability or self.ability:IsNull() then return end

	self.armor_per_stack_creep = self.ability:GetSpecialValueFor("armor_per_stack_creep")

	if not self.listener then
		self.listener = ListenToGameEvent(
			"dota_player_learned_ability", 
			Dynamic_Wrap(modifier_axe_culling_blade_permanent_creep_lua, "OnPlayerLearnedAbility"),
			self
		)	
	end
end

function modifier_axe_culling_blade_permanent_creep_lua:OnRefresh(keys)
	self:OnCreated(keys)
end

function modifier_axe_culling_blade_permanent_creep_lua:OnDestroy()
	if not self or self:IsNull() then return end
	if self.listener then
		StopListeningToGameEvent(self.listener)
	end
end

function modifier_axe_culling_blade_permanent_creep_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_axe_culling_blade_permanent_creep_lua:GetModifierPhysicalArmorBonus()
	return self.armor_per_stack_creep * self:GetStackCount()
end

function modifier_axe_culling_blade_permanent_creep_lua:OnPlayerLearnedAbility( keys )
	if not self or self:IsNull() then return end
	if keys.PlayerID ~= self.caster:GetPlayerOwnerID() then return end
	if self.ability and (keys.abilityname == self.ability:GetAbilityName() or keys.abilityname == "special_bonus_unique_axe_3")  then		-- refresh armor calculation
		self.armor_per_stack_creep = self.ability:GetSpecialValueFor("armor_per_stack_creep")
	end
end