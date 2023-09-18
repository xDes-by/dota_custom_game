techies_stasis_trap_lua = class({})

LinkLuaModifier("modifier_stasis_trap", "heroes/hero_techies/techies_stasis_trap/stasis_trap.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_stasis_trap_active_delay", "heroes/hero_techies/techies_stasis_trap/stasis_trap.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_stasis_trap_explose_delay", "heroes/hero_techies/techies_stasis_trap/stasis_trap.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_stasis_trap_root_pfx", "heroes/hero_techies/techies_stasis_trap/stasis_trap.lua", LUA_MODIFIER_MOTION_NONE)

function techies_stasis_trap_lua:GetAOERadius() return self:GetSpecialValueFor("radius") end

function techies_stasis_trap_lua:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect()/100)
end

function techies_stasis_trap_lua:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local mine = CreateUnitByName("npc_dota_techies_stasis_trap", pos, true, caster, caster, caster:GetTeamNumber())
	mine:EmitSound("Hero_Techies.StasisTrap.Plant")
	mine:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
	mine:AddNewModifier(caster, self, "modifier_stasis_trap_active_delay", {duration = self:GetSpecialValueFor("activation_delay")})
	mine:AddNewModifier(caster, self, "modifier_stasis_trap", {})
end

modifier_stasis_trap_active_delay = class({})

function modifier_stasis_trap_active_delay:IsDebuff()			return false end
function modifier_stasis_trap_active_delay:IsHidden() 			return true end
function modifier_stasis_trap_active_delay:IsPurgable() 		return false end
function modifier_stasis_trap_active_delay:IsPurgeException() 	return false end
function modifier_stasis_trap_active_delay:GetEffectName() return "particles/units/heroes/hero_techies/techies_stasis_beams_heroelec.vpcf" end

modifier_stasis_trap = class({})

function modifier_stasis_trap:IsDebuff()			return false end
function modifier_stasis_trap:IsHidden() 			return true end
function modifier_stasis_trap:IsPurgable() 		return false end
function modifier_stasis_trap:IsPurgeException() 	return false end
function modifier_stasis_trap:DeclareFunctions() 	return {MODIFIER_PROPERTY_MOVESPEED_MAX, MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE} end
function modifier_stasis_trap:GetModifierMoveSpeed_Max() return 25 end
function modifier_stasis_trap:GetModifierMoveSpeed_Absolute() return 25 end
function modifier_stasis_trap:CheckState() return (self:GetParent():HasModifier("modifier_stasis_trap_active_delay") and {[MODIFIER_STATE_NO_UNIT_COLLISION] = true} or {[MODIFIER_STATE_INVISIBLE] = true, [MODIFIER_STATE_NO_UNIT_COLLISION] = true}) end

function modifier_stasis_trap:OnCreated()
	self:StartIntervalThink(0.1)
end

function modifier_stasis_trap:OnIntervalThink()
    if IsServer() then
        local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
        if #enemies > 0 and not self:GetParent():HasModifier("modifier_stasis_trap_active_delay") and not self:GetParent():HasModifier("modifier_stasis_trap_explose_delay") then
            self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stasis_trap_explose_delay", {duration = self:GetAbility():GetSpecialValueFor("explosion_delay")})
        end
    end
end

function modifier_stasis_trap:OnDestroy()
	if IsServer() and self:GetStackCount() > 0 then
		local sound = CreateModifierThinker(self:GetCaster(), nil, "modifier_dummy_thinker", {duration = 1.0}, self:GetParent():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
		sound:EmitSound("Hero_Techies.StasisTrap.Stun")
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_stasis_trap_explode.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, Vector(self:GetAbility():GetSpecialValueFor("radius"),0,0))
		Timers:CreateTimer(3.0, function()
				ParticleManager:DestroyParticle(pfx, true)
				ParticleManager:ReleaseParticleIndex(pfx)
				return nil
			end
		)
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_rooted", {duration = self:GetAbility():GetSpecialValueFor("root_duration")})
			enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stasis_trap_root_pfx", {duration = self:GetAbility():GetSpecialValueFor("root_duration")})
			
			if self:GetCaster():FindAbilityByName("npc_dota_hero_techies_agi8") ~= nil then
				ApplyDamage({victim = enemy, attacker = self:GetCaster(), damage = self:GetCaster():GetMaxHealth() * 0.03, damage_type = DAMAGE_TYPE_MAGICAL})
			end
		end
	end
end

modifier_stasis_trap_explose_delay = class({})

function modifier_stasis_trap_explose_delay:IsDebuff()			return false end
function modifier_stasis_trap_explose_delay:IsHidden() 		return true end
function modifier_stasis_trap_explose_delay:IsPurgable() 		return false end
function modifier_stasis_trap_explose_delay:IsPurgeException() return false end

function modifier_stasis_trap_explose_delay:OnDestroy()
	if IsServer() then
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		if #enemies > 0 and self:GetElapsedTime() >= self:GetDuration() then
			local buff = self:GetParent():FindModifierByName("modifier_stasis_trap")
			if buff then
				buff:SetStackCount(1)
			end
			self:GetParent():ForceKill(false)
		end
	end
end

modifier_stasis_trap_root_pfx = class({})

function modifier_stasis_trap_root_pfx:IsDebuff()			return true end
function modifier_stasis_trap_root_pfx:IsHidden() 			return true end
function modifier_stasis_trap_root_pfx:IsPurgable() 		return true end
function modifier_stasis_trap_root_pfx:IsPurgeException() 	return true end
function modifier_stasis_trap_root_pfx:GetStatusEffectName() return "particles/status_fx/status_effect_techies_stasis.vpcf" end
function modifier_stasis_trap_root_pfx:StatusEffectPriority() return 15 end
function modifier_stasis_trap_root_pfx:GetEffectName() return "particles/units/heroes/hero_techies/techies_stasis_beams_heroelec.vpcf" end

function modifier_stasis_trap_root_pfx:OnCreated()
	self.debuff = self:GetAbility():GetSpecialValueFor("debuff")
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_techies_str10") ~= nil then
		self.debuff = self:GetAbility():GetSpecialValueFor("debuff") + 10
	end	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_techies_str7") ~= nil then
		self.debuff = self:GetAbility():GetSpecialValueFor("debuff") + 10
	end	
end

function modifier_stasis_trap_root_pfx:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
end

function modifier_stasis_trap_root_pfx:GetModifierPhysicalArmorBonus()
	local armor = self:GetParent():GetPhysicalArmorBaseValue()/100
	return armor * self.debuff * (-1)
end

function modifier_stasis_trap_root_pfx:GetModifierMagicalResistanceBonus()
	return self.debuff * (-1 )
end