LinkLuaModifier("modifier_riki_cloak_and_dagger_lua", "heroes/hero_riki/riki_cloak_and_dagger_lua/modifier_riki_cloak_and_dagger_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_riki_cloak_and_dagger_invisibility", "heroes/hero_riki/riki_cloak_and_dagger_lua/modifier_riki_cloak_and_dagger_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_riki_cloak_and_dagger_invisibility_spell_amplify", "heroes/hero_riki/riki_cloak_and_dagger_lua/modifier_riki_cloak_and_dagger_lua", LUA_MODIFIER_MOTION_NONE)

riki_cloak_and_dagger_lua		= riki_cloak_and_dagger_lua or class({})


function riki_cloak_and_dagger_lua:GetIntrinsicModifierName()
	return "modifier_riki_cloak_and_dagger_lua"
end

function riki_cloak_and_dagger_lua:GetBehavior()
	return self.BaseClass.GetBehavior(self)
end

function riki_cloak_and_dagger_lua:OnOwnerSpawned()
	if self:GetCaster():HasModifier("modifier_riki_cloak_and_dagger_lua") then
		self:GetCaster():FindModifierByName("modifier_riki_cloak_and_dagger_lua"):SetDuration(-1, false)
	end
	
end

-- This block apparently just needs to exist to show that green border on the ability icon
function riki_cloak_and_dagger_lua:OnToggle()

end
