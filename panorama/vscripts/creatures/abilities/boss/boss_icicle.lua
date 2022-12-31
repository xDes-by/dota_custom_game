boss_icicle = class({})
LinkLuaModifier("modifier_boss_icicle", "creatures/abilities/boss/boss_icicle", LUA_MODIFIER_MOTION_NONE)

------------------------------------------------------------------

function boss_icicle:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function boss_icicle:OnSpellStart()
	if IsServer() then
       
        local delay = self:GetSpecialValueFor("delay")
	    local damage = self:GetSpecialValueFor("damage")
	    local radius = self:GetSpecialValueFor("radius")
	    local freeze_duration = self:GetSpecialValueFor("freeze_duration")
	    local hAbility = self
        local vOrigin = self:GetCursorPosition()
        local hCaster = self:GetCaster()

        local nFXIndex = ParticleManager:CreateParticle("particles/creature/dungeon_generic_blast_ovr_pre.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(nFXIndex, 0, self:GetCursorPosition() )
		ParticleManager:SetParticleControl(nFXIndex, 1, Vector( radius, delay, 1.0 ) )
		ParticleManager:SetParticleControl(nFXIndex, 15, Vector( 100, 100, 255 ) )
		ParticleManager:SetParticleControl(nFXIndex, 16, Vector( 1, 0, 0 ) )
		ParticleManager:ReleaseParticleIndex(nFXIndex )

		EmitSoundOn( "Hero_Tusk.IceShards.Projectile", self:GetCaster() )

	    Timers:CreateTimer(delay, function()
	    	EmitSoundOnLocationWithCaster(vOrigin, "Hero_Tusk.IceShards", hCaster)
		    local nFXIndex = ParticleManager:CreateParticle("particles/creature/frostbitten_icicle.vpcf", PATTACH_WORLDORIGIN, nil)
			ParticleManager:SetParticleControl(nFXIndex, 0, vOrigin + Vector( 0, 0, 40 ))
			ParticleManager:ReleaseParticleIndex(nFXIndex)

			local enemies = FindUnitsInRadius(hCaster:GetTeamNumber(), vOrigin, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
			for _,enemy in pairs(enemies) do
				if enemy ~= nil and enemy:IsMagicImmune() == false and enemy:IsInvulnerable() == false then
					local damageInfo =
					{
						victim = enemy,
						attacker = hCaster or enemy,
						damage = damage,
						damage_type = DAMAGE_TYPE_MAGICAL,
						ability = ability,
					}

					ApplyDamage( damageInfo )
					enemy:AddNewModifier(hCaster, hAbility, "modifier_boss_icicle", { duration = freeze_duration * (1 - enemy:GetStatusResistance()) } )
				end
			end
	    end)

	end
end



modifier_boss_icicle = class({})

------------------------------------------------------------------

function modifier_boss_icicle:OnCreated( kv )
end

function modifier_boss_icicle:GetEffectName()  
	return "particles/creature/boss_icicle.vpcf"
end

function modifier_boss_icicle:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_boss_icicle:GetStatusEffectName()  
	return "particles/status_fx/status_effect_wyvern_cold_embrace.vpcf"
end

--------------------------------------------------------------------------------

function modifier_boss_icicle:CheckState()
	local state = {}
	state[MODIFIER_STATE_STUNNED] = true
	state[MODIFIER_STATE_FROZEN] = true
	
	return state
end
