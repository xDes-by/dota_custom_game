LinkLuaModifier("modifier_empower_buff", "heroes/hero_magnataur/magnataur_empower_lua/modifier_empower_buff.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_talent_str12", "heroes/hero_magnataur/magnataur_empower_lua/modifier_talent_str12.lua", LUA_MODIFIER_MOTION_NONE)

magnataur_empower_lua = {}

function magnataur_empower_lua:OnAbilityPhaseStart()
	return true
end

function magnataur_empower_lua:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local duration = self:GetSpecialValueFor( "empower_duration" )
	if caster:FindAbilityByName("npc_dota_hero_magnataur_agi9") then
		duration = duration + 20
	end
	target:AddNewModifier(
		caster,
		self,
		"modifier_empower_buff",
		{ duration = duration }
	)

	EmitSoundOn( "Hero_Magnataur.Empower.Cast", caster )
	EmitSoundOn( "Hero_Magnataur.Empower.Target", target )
end