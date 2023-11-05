modifier_riki_tricks_of_the_trade_can_move = class({})

function modifier_riki_tricks_of_the_trade_can_move:IsPurgable() return false end
function modifier_riki_tricks_of_the_trade_can_move:IsDebuff() return false end
function modifier_riki_tricks_of_the_trade_can_move:IsHidden() return false end

function modifier_riki_tricks_of_the_trade_can_move:OnCreated(params)
    local ability = self:GetAbility()
    self.dmg_perc = ability:GetSpecialValueFor("dmg_perc")
    self.radius = ability:GetSpecialValueFor("area_of_effect")
    self.agi = ability:GetSpecialValueFor("extra_agility") / 100 * self:GetParent():GetAgility()
	if IsServer() then
        self.attack_count2 = ability:GetSpecialValueFor("attack_count2")
        self.attack_count = ability:GetSpecialValueFor("attack_count")
        self.current_interval = 0
		local duration = ability:GetSpecialValueFor("channel_duration")
		if self:GetCaster():FindAbilityByName("npc_dota_hero_riki_agi12") then
			self.attack_count = self.attack_count + duration / (1 / (self:GetCaster():GetAttacksPerSecond() / 2))
		end
		self.attack_speed = duration / self.attack_count
		local particle_start = ParticleManager:CreateParticle("particles/units/heroes/hero_riki/riki_tricks_cast.vpcf", PATTACH_WORLDORIGIN, nil)
        self.particle_radius = ParticleManager:CreateParticle("particles/units/heroes/hero_riki/riki_tricks.vpcf", PATTACH_WORLDORIGIN, nil)
        ParticleManager:SetParticleControl(self.particle_radius, 0, self:GetParent():GetAbsOrigin())
        ParticleManager:SetParticleControl(self.particle_radius, 1, Vector(self.radius, 0, self.radius))
        ParticleManager:SetParticleControl(self.particle_radius, 2, Vector(self.radius, 0, self.radius))
        self:AddParticle(self.particle_radius, false, false, -1, false, false)
        self:OnIntervalThink()
        self:StartIntervalThink(FrameTime())
	end
end

function modifier_riki_tricks_of_the_trade_can_move:OnDestroy()
    if not IsServer() then return end
    FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
    -- self:GetParent():RemoveNoDraw()
    local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_riki/riki_tricks_end.vpcf", PATTACH_ABSORIGIN, self:GetParent())
    ParticleManager:ReleaseParticleIndex(particle)
end

function modifier_riki_tricks_of_the_trade_can_move:OnRefresh(params)
    if not IsServer() then return end
    self:OnCreated(params)
end

function modifier_riki_tricks_of_the_trade_can_move:OnIntervalThink()
    if not IsServer() then return end
    ParticleManager:SetParticleControl(self.particle_radius, 0, self:GetParent():GetAbsOrigin())
    self.current_interval = self.current_interval + FrameTime()
    if self.current_interval >= self.attack_speed then
        self.current_interval = 0
        local targets = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY , DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC , DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER , false)
        if #targets > 0 then
            for _, target in pairs(targets) do
                if target:IsAlive() and not target:IsAttackImmune() then
                    self:GetParent():PerformAttack(target, true, true, true, false, false, false, false)
                end
            end
        end
        self.attack_count = self.attack_count - 1
        if self.attack_count <= 0 then
            self:Destroy()
        end
    end
end

function modifier_riki_tricks_of_the_trade_can_move:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
end

function modifier_riki_tricks_of_the_trade_can_move:GetModifierAttackRangeBonus()
	return self.radius
end
function modifier_riki_tricks_of_the_trade_can_move:GetModifierDamageOutgoing_Percentage()
	return -100 + self.dmg_perc
end
function modifier_riki_tricks_of_the_trade_can_move:GetModifierBonusStats_Agility()
	return self.agi
end