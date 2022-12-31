LinkLuaModifier("modifier_creature_explode_poison", "creatures/abilities/regular/creature_explode_poison", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_explode_poison_thinker", "creatures/abilities/regular/creature_explode_poison", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_explode_poison_counter", "creatures/abilities/regular/creature_explode_poison", LUA_MODIFIER_MOTION_NONE)

creature_explode_poison = class({})

function creature_explode_poison:OnOwnerDied()
	if IsServer() then
		CreateModifierThinker(self:GetCaster(), self, "modifier_creature_explode_poison_thinker", {duration = self:GetSpecialValueFor("duration")}, self:GetCaster():GetAbsOrigin(), DOTA_TEAM_NEUTRALS, false)
	end
end



modifier_creature_explode_poison_thinker = class({})

function modifier_creature_explode_poison_thinker:IsHidden() return true end
function modifier_creature_explode_poison_thinker:IsDebuff() return false end
function modifier_creature_explode_poison_thinker:IsPurgable() return false end

function modifier_creature_explode_poison_thinker:IsAura() return true end
function modifier_creature_explode_poison_thinker:GetAuraRadius() return 250 end
function modifier_creature_explode_poison_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_creature_explode_poison_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_creature_explode_poison_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_creature_explode_poison_thinker:GetModifierAura() return "modifier_creature_explode_poison" end

function modifier_creature_explode_poison_thinker:OnCreated(keys)
	if IsServer() then

		local caster = self:GetCaster()
		caster:EmitSound("CreaturePoison.Explode")
		caster:EmitSound("CreaturePoison.Loop")

		self.poison_pfx = ParticleManager:CreateParticle("particles/econ/items/viper/viper_immortal_tail_ti8/viper_immortal_ti8_nethertoxin.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(self.poison_pfx, 0, caster:GetAbsOrigin())
	end
end

function modifier_creature_explode_poison_thinker:OnDestroy()
	if IsServer() then
		local caster = self:GetCaster()
		if caster and not caster:IsNull() then
			caster:StopSound("CreaturePoison.Loop")
		end

		ParticleManager:DestroyParticle(self.poison_pfx, true)
		ParticleManager:ReleaseParticleIndex(self.poison_pfx)
	end
end



modifier_creature_explode_poison = class({})

function modifier_creature_explode_poison:IsHidden() return true end
function modifier_creature_explode_poison:IsDebuff() return true end
function modifier_creature_explode_poison:IsPurgable() return false end
function modifier_creature_explode_poison:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_creature_explode_poison:GetEffectName()
	return "particles/creature/explode_poison.vpcf"
end

function modifier_creature_explode_poison:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_creature_explode_poison:OnCreated(keys)
	if IsServer() then
		local ability = self:GetAbility()
		if ability and (not ability:IsNull()) then
			local parent = self:GetParent()

			self.base_damage = ability:GetSpecialValueFor("base_damage")
			self.max_damage = ability:GetSpecialValueFor("max_damage")
			self.damage_increment = (self.max_damage - self.base_damage) * 0.125
			self.current_damage = self.base_damage - self.damage_increment

			parent:AddNewModifier(parent, ability, "modifier_creature_explode_poison_counter", {}):IncrementStackCount()
	
			self:StartIntervalThink(0.5)
		else
			self:Destroy()
		end
	end
end

function modifier_creature_explode_poison:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		if parent:HasModifier("modifier_creature_explode_poison_counter") then
			local modifier_counter = parent:FindModifierByName("modifier_creature_explode_poison_counter")
			modifier_counter:DecrementStackCount()
			if modifier_counter:GetStackCount() <= 0 then
				parent:RemoveModifierByName("modifier_creature_explode_poison_counter")
			end
		end
	end
end

function modifier_creature_explode_poison:OnIntervalThink()
	if IsServer() then
		local caster = self:GetCaster()
		if caster and (not caster:IsNull()) then
			local parent = self:GetParent()
			self.current_damage = math.min(self.current_damage + self.damage_increment, self.max_damage)

			local actual_damage = ApplyDamage({victim = parent, attacker = caster, damage = self.current_damage * 0.5, damage_type = DAMAGE_TYPE_MAGICAL})
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, parent, actual_damage, nil)
		end
	end
end

function modifier_creature_explode_poison:CheckState()
	local state = {
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,
	}
	return state
end



modifier_creature_explode_poison_counter = class({})

function modifier_creature_explode_poison_counter:IsHidden() return false end
function modifier_creature_explode_poison_counter:IsDebuff() return true end
function modifier_creature_explode_poison_counter:IsPurgable() return false end
