boss_4_eidolon = class({})

function boss_4_eidolon:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local sound_cast = "Hero_Enigma.Demonic_Conversion"
	EmitSoundOn( sound_cast, caster )
	for i = 1, 5 do
		local eidolon = CreateUnitByName("boss_4_eidolon", target:GetOrigin(), true, caster, caster, caster:GetTeamNumber())
		eidolon:AddNewModifier(caster, self, "modifier_kill", {duration = 15})
		difficality_modifier(eidolon)
		setting(caster, eidolon)
	end
	target:ForceKill(false)
end

LinkLuaModifier( "modifier_easy", "abilities/difficult/easy", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_normal", "abilities/difficult/normal", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hard", "abilities/difficult/hard", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ultra", "abilities/difficult/ultra", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_insane", "abilities/difficult/insane", LUA_MODIFIER_MOTION_NONE )

function difficality_modifier(unit)
	if diff_wave.wavedef == "Easy" then
		unit:AddNewModifier(unit, nil, "modifier_easy", {})
	end
	if diff_wave.wavedef == "Normal" then
		unit:AddNewModifier(unit, nil, "modifier_normal", {})
	end
	if diff_wave.wavedef == "Hard" then
		unit:AddNewModifier(unit, nil, "modifier_hard", {})
	end	
	if diff_wave.wavedef == "Ultra" then
		unit:AddNewModifier(unit, nil, "modifier_ultra", {})
	end		
	if diff_wave.wavedef == "Insane" then
		unit:AddNewModifier(unit, nil, "modifier_insane", {})
		new_abil_passive = abiility_passive[RandomInt(1,#abiility_passive)]
		unit:AddAbility(new_abil_passive):SetLevel(4)
	end	
end	

function setting(caster, eidolon)
	eidolon:SetBaseDamageMin(caster:GetBaseDamageMin()/10)
	eidolon:SetBaseDamageMax(caster:GetBaseDamageMax()/10)
	eidolon:SetPhysicalArmorBaseValue(caster:GetPhysicalArmorBaseValue()/10)
	eidolon:SetBaseMagicalResistanceValue(caster:GetBaseMagicalResistanceValue()/10)
	eidolon:SetMaxHealth(caster:GetMaxHealth()/10)
	eidolon:SetBaseMaxHealth(caster:GetBaseMaxHealth()/10)
	eidolon:SetHealth(caster:GetHealth()/10)
	eidolon:SetDeathXP(caster:GetDeathXP()/10)
end