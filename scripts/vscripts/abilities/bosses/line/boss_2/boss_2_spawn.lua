boss_2_spawn = class({})

LinkLuaModifier("modifier_boss_2_spawn", "abilities/bosses/line/boss_2/boss_2_spawn", LUA_MODIFIER_MOTION_VERTICAL)

function boss_2_spawn:GetIntrinsicModifierName()
	return "modifier_boss_2_spawn"
end

------------------------------------------------------------------------------------------------------------------------------------------------------------
modifier_boss_2_spawn = class({})

function modifier_boss_2_spawn:IsHidden()
	return true
end

function modifier_boss_2_spawn:IsPurgable()
	return false
end

function modifier_boss_2_spawn:OnCreated( kv )
	self:StartIntervalThink(1)
end

function modifier_boss_2_spawn:OnIntervalThink()
	if IsServer() then
		if self:GetAbility():IsCooldownReady() and self:GetParent():IsAlive() then
			local hEnemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, 1100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
			if #hEnemies > 0 then
				local unit = CreateUnitByName("boss_2_minion", self:GetParent():GetAbsOrigin(), true, nil, nil, self:GetParent():GetTeamNumber())
				unit:AddNewModifier(unit, nil, "modifier_kill", {duration = 3})
				self:GetAbility():UseResources(false, false, false, true)
			end	
		end
	end
end

function aura_dif(unit)
	if wave.wavedef == "Easy" then
		unit:AddNewModifier(unit, nil, "modifier_easy", {})
	end
	if wave.wavedef == "Normal" then
		unit:AddNewModifier(unit, nil, "modifier_normal", {})
	end
	if wave.wavedef == "Hard" then
		unit:AddNewModifier(unit, nil, "modifier_hard", {})
	end		
	if wave.wavedef == "Ultra" then
		unit:AddNewModifier(unit, nil, "modifier_ultra", {})
	end	
	if diff_wave.wavedef == "Insane" then
		unit:AddNewModifier(unit, nil, "modifier_insane", {})
		new_abil_passive = abiility_passive[RandomInt(1,#abiility_passive)]
		unit:AddAbility(new_abil_passive):SetLevel(4)
	end	
	if diff_wave.wavedef == "Impossible" then
		unit:AddNewModifier(unit, nil, "modifier_impossible", {})
		new_abil_passive = abiility_passive[RandomInt(1,#abiility_passive)]
		unit:AddAbility(new_abil_passive):SetLevel(4)
	end	
end