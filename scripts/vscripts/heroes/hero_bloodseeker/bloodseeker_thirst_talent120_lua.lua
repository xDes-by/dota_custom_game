LinkLuaModifier("modifier_bloodseeker_thirst_talent120_lua", "heroes/hero_bloodseeker/bloodseeker_thirst_talent120_lua", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_bloodseeker_agi11 = class({})

function npc_dota_hero_bloodseeker_agi11:GetIntrinsicModifierName()
	return "modifier_bloodseeker_thirst_talent120_lua"
end

if modifier_bloodseeker_thirst_talent120_lua == nil then 
    modifier_bloodseeker_thirst_talent120_lua = class({})
end

function modifier_bloodseeker_thirst_talent120_lua:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH
	}
end

function modifier_bloodseeker_thirst_talent120_lua:OnDeath(params)
	if self:GetCaster() ~= params.attacker then return end
	self:AddStack()
end

function modifier_bloodseeker_thirst_talent120_lua:AddStack(count)
	count = count or 1
	if self:GetCaster():FindAbilityByName("npc_dota_hero_bloodseeker_str10") and RandomInt(1, 100) <= 20 then
		local mod = self:GetParent():AddNewModifier(
            self:GetParent(), -- player source
            self:GetAbility(), -- ability source
            "modifier_bloodseeker_thirst_lua_stack", -- modifier name
            {
                duration = self:GetAbility():GetSpecialValueFor("duration"),
            }
        )
        mod:SetStackCount( mod:GetStackCount() +  count)
        self:SetStackCount( self:GetStackCount() +  count )
	end
end