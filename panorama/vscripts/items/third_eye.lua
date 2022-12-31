item_third_eye_lua = class({})

LinkLuaModifier("modifier_item_third_eye_lua", "items/third_eye", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_third_eye_lua_emitter", "items/third_eye", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_third_eye_lua_truesight", "items/third_eye", LUA_MODIFIER_MOTION_NONE)



function item_third_eye_lua:GetIntrinsicModifierName()
	return "modifier_item_third_eye_lua"
end

modifier_item_third_eye_lua = class({})

function modifier_item_third_eye_lua:IsHidden() return true end
function modifier_item_third_eye_lua:IsDebuff() return false end
function modifier_item_third_eye_lua:IsPurgable() return false end
function modifier_item_third_eye_lua:RemoveOnDeath() return false end
function modifier_item_third_eye_lua:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end


function modifier_item_third_eye_lua:OnCreated(keys)
	if IsServer() then

		if not self:GetAbility() then self:Destroy() end

		self.truesight_radius = self:GetAbility():GetSpecialValueFor("truesight_radius")
		local caster = self:GetCaster()
		
		if not caster:HasModifier("modifier_item_third_eye_lua_emitter") then
			caster:AddNewModifier(caster, self:GetAbility(), "modifier_item_third_eye_lua_emitter", {})
		end
	else
		return
	end
end

function modifier_item_third_eye_lua:OnDestroy()
	if IsServer() then
		local caster = self:GetCaster()
		if not caster:HasModifier("modifier_item_third_eye_lua") then
			caster:RemoveModifierByName("modifier_item_third_eye_lua_emitter")
		end
	end
end

function modifier_item_third_eye_lua:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    }
end

function modifier_item_third_eye_lua:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
end

function modifier_item_third_eye_lua:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
end

function modifier_item_third_eye_lua:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
end

modifier_item_third_eye_lua_emitter = class({})

function modifier_item_third_eye_lua_emitter:IsAura() return true end
function modifier_item_third_eye_lua_emitter:IsHidden() return true end
function modifier_item_third_eye_lua_emitter:RemoveOnDeath() return false end
function modifier_item_third_eye_lua_emitter:GetAuraRadius() return self.truesight_radius end
function modifier_item_third_eye_lua_emitter:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_item_third_eye_lua_emitter:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_item_third_eye_lua_emitter:GetModifierAura() return "modifier_item_third_eye_lua_truesight" end

function modifier_item_third_eye_lua_emitter:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	self.truesight_radius = self:GetAbility():GetSpecialValueFor("truesight_radius")

end


modifier_item_third_eye_lua_truesight = class({})

function modifier_item_third_eye_lua_truesight:IsHidden() return true end
function modifier_item_third_eye_lua_truesight:IsDebuff() return true end
function modifier_item_third_eye_lua_truesight:IsPurgable() return false end
function modifier_item_third_eye_lua_truesight:GetPriority() return MODIFIER_PRIORITY_SUPER_ULTRA end

function modifier_item_third_eye_lua_truesight:CheckState()
	return {
		[MODIFIER_STATE_INVISIBLE] = false
	}
end 

function modifier_item_third_eye_lua_truesight:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL
	}
end

function modifier_item_third_eye_lua_truesight:GetModifierInvisibilityLevel()
	return 0
end
