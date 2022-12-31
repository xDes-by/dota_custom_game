chen_hand_of_god_lua = class({})

--------------------------------------------------------------------------------
-- Written by Australia is my City
--------------------------------------------------------------------------------

function chen_hand_of_god_lua:GetCooldown(level)
    return self.BaseClass.GetCooldown(self, level) - self:GetCaster():FindTalentValue("special_bonus_unique_chen_7")
end

function chen_hand_of_god_lua:OnSpellStart()
	if not IsServer() then return end
    local caster = self:GetCaster()
    
    local immunity_duration = self:GetSpecialValueFor("immunity_duration")
    local heal_amount = self:GetSpecialValueFor("heal_amount") + caster:FindTalentValue("special_bonus_unique_chen_2_custom", "heal_amount")
    
	local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED, FIND_ANY_ORDER, false)

	local voiceline = "chen_chen_ability_handgod_0"..RandomInt(1, 3) or nil
    
	local particle_cast = ParticleManager:GetParticleReplacement("particles/units/heroes/hero_chen/chen_hand_of_god.vpcf", caster)
            
	for _, ally in pairs(allies) do
		if ally:IsRealHero() or ally:IsClone() or ally:GetOwnerEntity() == caster or (ally.GetPlayerID and caster.GetPlayerID and ally:GetPlayerID() == caster:GetPlayerID()) then

			-- Let's try not to blow up eardrums
			if voiceline and ally:IsRealHero() then
				ally:EmitSound(voiceline)
			end
            
            local total_heal_amount = 0
            
			if ally:IsRealHero() then
				ally:EmitSound("Hero_Chen.HandOfGodHealHero")
                total_heal_amount = heal_amount * ally:GetLevel() 
			else
				ally:EmitSound("Hero_Chen.HandOfGodHealCreep")
                total_heal_amount = heal_amount * caster:GetLevel() 
			end

			local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, ally)
			ParticleManager:ReleaseParticleIndex(effect_cast)
            
			if ally:IsHero() then
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, ally, total_heal_amount, nil)
			end
			
			ally:Heal(total_heal_amount, caster)
            ally:Purge(false, true, false, true, true)
            ally:AddNewModifier(caster, self, "modifier_chen_hand_of_god_lua", {duration = immunity_duration})
		end
	end
end


----------------------------------------------------
-- Spell immunity
----------------------------------------------------

LinkLuaModifier('modifier_chen_hand_of_god_lua', 'heroes/hero_chen/chen_hand_of_god_lua.lua', LUA_MODIFIER_MOTION_NONE)
modifier_chen_hand_of_god_lua = class({})

function modifier_chen_hand_of_god_lua:IsHidden() return false end
function modifier_chen_hand_of_god_lua:IsPurgable() return false end
function modifier_chen_hand_of_god_lua:IsDebuff() return false end

function modifier_chen_hand_of_god_lua:GetEffectName()
    return "particles/items5_fx/minotaur_horn.vpcf"
end

function modifier_chen_hand_of_god_lua:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_chen_hand_of_god_lua:CheckState()
    return {[MODIFIER_STATE_MAGIC_IMMUNE] = true}
end

function modifier_chen_hand_of_god_lua:OnCreated()  
    local ability = self:GetAbility()
    self.model_scale = ability:GetSpecialValueFor("model_scale")
    self.regen_amount = ability:GetSpecialValueFor("heal_per_second") + ability:GetCaster():FindTalentValue("special_bonus_unique_chen_2_custom", "heal_per_second")
end

function modifier_chen_hand_of_god_lua:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MODEL_SCALE,
        MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
    }
end

function modifier_chen_hand_of_god_lua:GetModifierModelScale()
    return self.model_scale
end

function modifier_chen_hand_of_god_lua:GetModifierHealthRegenPercentage()
    return self.regen_amount
end
