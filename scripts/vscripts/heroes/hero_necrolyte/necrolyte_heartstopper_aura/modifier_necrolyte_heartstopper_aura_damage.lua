modifier_necrolyte_heartstopper_aura_damage = class({})


function modifier_necrolyte_heartstopper_aura_damage:IsHidden()
	if self:GetStackCount() == 0 then
		return true
	end
end

function modifier_necrolyte_heartstopper_aura_damage:IsDebuff()
	return true
end

function modifier_necrolyte_heartstopper_aura_damage:IsPurgable()
	return false
end

function modifier_necrolyte_heartstopper_aura_damage:OnCreated()
	if IsServer() then
        self.tick_rate = self:GetAbility():GetSpecialValueFor("tick_rate")
        self.heal_regen_to_damage_perc = self:GetAbility():GetSpecialValueFor("heal_regen_to_damage") / 100 * self.tick_rate
        self.caster = self:GetCaster()
        self.damageTable = {
            victim = self:GetParent(),
            attacker = self:GetCaster(),
            damage_type = DAMAGE_TYPE_MAGICAL,
			damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL,
        }		
		self:StartIntervalThink(self.tick_rate)
	end
end

function modifier_necrolyte_heartstopper_aura_damage:OnIntervalThink()
	if IsServer() then
        self.damageTable.damage = self.heal_regen_to_damage_perc * self.caster:GetHealthRegen()
		ApplyDamage(self.damageTable)
	end
end