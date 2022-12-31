drow_ranger_marksmanship_lua = class({})
LinkLuaModifier( "modifier_drow_ranger_marksmanship_lua", "heroes/hero_drow_ranger/modifier_drow_ranger_marksmanship_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_marksmanship_lua_debuff", "heroes/hero_drow_ranger/modifier_drow_ranger_marksmanship_lua_debuff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_marksmanship_lua_effect", "heroes/hero_drow_ranger/modifier_drow_ranger_marksmanship_lua_effect", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function drow_ranger_marksmanship_lua:GetIntrinsicModifierName()
	return "modifier_drow_ranger_marksmanship_lua"
end

--------------------------------------------------------------------------------
-- Projectile
function drow_ranger_marksmanship_lua:OnProjectileHit_ExtraData( target, location, data )
	local caster = self:GetCaster()

	if not IsValidEntity(caster) or not IsValidEntity(target) or not target:IsAlive() then return end

	-- perform attack
	self.split = true
	self.split_procs = data.procs == 1
	self:ToggleProcs(false)
	caster.split_attack = true
	caster:PerformAttack( target, true, true, true, false, false, false, data.procs == 1)
	caster.split_attack = false
	self:ToggleProcs(true)
	self.split = false
end

drow_ranger_marksmanship_lua.abilities_disabled_on_split = {
	"medusa_split_shot",
	"frostivus2018_clinkz_searing_arrows",
}

function drow_ranger_marksmanship_lua:ToggleProcs(bActive)
	for _,abilityName in pairs(self.abilities_disabled_on_split) do
		local ability = self:GetCaster():FindAbilityByName(abilityName)

		if bActive then
			if ability then
				local isToggle = ability:IsToggle() 
				-- What passes:
				-- If it isn't a toggleable ability in the first place (Time Lock)
				-- If it's a toggleable ability and it is toggled on (Medusa Split Shot)
				if (not isToggle) or (isToggle and ability:GetToggleState()) then
					self:GetCaster():AddNewModifier(self:GetCaster(), ability, "modifier_"..abilityName, {})
				end
			end
		else
			local modifier = self:GetCaster():FindModifierByName("modifier_"..abilityName)
			if modifier then modifier:Destroy() end
		end
	end
end
