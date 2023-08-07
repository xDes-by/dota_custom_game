---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_witch_doctor_5", "heroes/hero_witch_doctor/maledict/maledict.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_witch_doctor_maledict_duration", "heroes/hero_witch_doctor/maledict/maledict.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_witch_doctor_8", "heroes/hero_witch_doctor/maledict/maledict.lua", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_witch_doctor_5	= modifier_special_bonus_imba_witch_doctor_5 or class({})
modifier_special_bonus_witch_doctor_maledict_duration	= modifier_special_bonus_witch_doctor_maledict_duration or class({})
modifier_special_bonus_imba_witch_doctor_8	= modifier_special_bonus_imba_witch_doctor_8 or class({})

function modifier_special_bonus_imba_witch_doctor_5:IsHidden() 		return true end
function modifier_special_bonus_imba_witch_doctor_5:IsPurgable()		return false end
function modifier_special_bonus_imba_witch_doctor_5:RemoveOnDeath() 	return false end

function modifier_special_bonus_witch_doctor_maledict_duration:IsHidden() 		return true end
function modifier_special_bonus_witch_doctor_maledict_duration:IsPurgable()		return false end
function modifier_special_bonus_witch_doctor_maledict_duration:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_witch_doctor_8:IsHidden() 		return true end
function modifier_special_bonus_imba_witch_doctor_8:IsPurgable()		return false end
function modifier_special_bonus_imba_witch_doctor_8:RemoveOnDeath() 	return false end

LinkLuaModifier("modifier_special_bonus_imba_witch_doctor_9", "heroes/hero_witch_doctor/maledict/maledict.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_witch_doctor_maledict_radius", "heroes/hero_witch_doctor/maledict/maledict.lua", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_witch_doctor_9	= class({})
modifier_special_bonus_witch_doctor_maledict_radius	= modifier_special_bonus_witch_doctor_maledict_radius or class({})

function modifier_special_bonus_imba_witch_doctor_9:IsHidden() 		return true end
function modifier_special_bonus_imba_witch_doctor_9:IsPurgable() 		return false end
function modifier_special_bonus_imba_witch_doctor_9:RemoveOnDeath() 	return false end

function modifier_special_bonus_witch_doctor_maledict_radius:IsHidden() 		return true end
function modifier_special_bonus_witch_doctor_maledict_radius:IsPurgable() 		return false end
function modifier_special_bonus_witch_doctor_maledict_radius:RemoveOnDeath() 	return false end

function witch_doctor_maledict:OnOwnerSpawned()
	if self:GetCaster():FindAbilityByName("special_bonus_imba_witch_doctor_9") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_witch_doctor_9") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_witch_doctor_9"), "modifier_special_bonus_imba_witch_doctor_9", {})
	end
	
	if self:GetCaster():FindAbilityByName("special_bonus_witch_doctor_maledict_radius") and not self:GetCaster():HasModifier("modifier_special_bonus_witch_doctor_maledict_radius") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_witch_doctor_maledict_radius"), "modifier_special_bonus_witch_doctor_maledict_radius", {})
	end
end