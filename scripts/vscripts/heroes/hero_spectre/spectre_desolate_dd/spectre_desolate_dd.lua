function Desolate (keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = ability:GetLevelSpecialValueFor( "bonus_damage", ability:GetLevel()-1 )
	damage = damage + self:GetCaster():GetBaseDamageMax() / 100 * self:GetLevelSpecialValueFor( "base_damage_perc", ability:GetLevel()-1 )
	
    if target:IsAlive() and not target:IsMagicImmune() then
	local abil = caster:FindAbilityByName("npc_dota_hero_spectre_agi6")
	if abil ~= nil then 
	damage = damage * 2
	end
    local abil = caster:FindAbilityByName("npc_dota_hero_spectre_agi_last")
	if abil ~= nil then 
	damage = damage * 8
	end	
    	EmitSoundOn("Hero_Spectre.Desolate", caster)

    	local particle_name = "particles/units/heroes/hero_spectre/spectre_desolate.vpcf"
    	local particle = ParticleManager:CreateParticle(particle_name, PATTACH_POINT, target)
        local pelel = caster:GetForwardVector()
        ParticleManager:SetParticleControl(particle, 0, Vector(     target:GetAbsOrigin().x,
                                                                    target:GetAbsOrigin().y, 
                                                                    GetGroundPosition(target:GetAbsOrigin(), target).z + 140))
                                                                    
        ParticleManager:SetParticleControlForward(particle, 0, caster:GetForwardVector())
		
		
			damage_type = DAMAGE_TYPE_PURE
			damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
			
		if caster:FindAbilityByName("npc_dota_hero_spectre_int8") ~= nil then 
			damage_type = DAMAGE_TYPE_MAGICAL
			damage_flags = DOTA_DAMAGE_FLAG_NONE
		end
		local damageTable = {
			victim = target,
			attacker = caster,
			damage = damage,
			damage_type = damage_type,
			damage_flags = damage_flags,
			ability = keys.ability,
		}
		 
		ApplyDamage(damageTable)
    end
end