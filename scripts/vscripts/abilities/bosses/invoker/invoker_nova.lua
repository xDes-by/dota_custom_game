LinkLuaModifier("modifier_invoker_nova_egg_thinker", "abilities/bosses/invoker/invoker_nova", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invoker_nova_caster_dummy", "abilities/bosses/invoker/invoker_nova", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invoker_nova_dmg", "abilities/bosses/invoker/invoker_nova", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invoker_nova_scepter_passive", "abilities/bosses/invoker/invoker_nova", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invoker_nova_scepter_passive_cooldown", "abilities/bosses/invoker/invoker_nova", LUA_MODIFIER_MOTION_NONE)


invoker_nova = class({})

function invoker_nova:OnSpellStart()
	if not IsServer() then return end
	
	local caster = self:GetCaster()
	local ability = self
	
	local egg_duration = self:GetSpecialValueFor("duration")
	local max_attack = self:GetSpecialValueFor("max_attack")
	
	local caster_pos = self:GetCaster():GetAbsOrigin()
	
	for i = 1, 3 do
		local angle = RandomInt(0, 360)
		local variance = RandomInt(-1000, 1000)
		local dy = math.sin(angle) * variance
		local dx = math.cos(angle) * variance
		local target_point = Vector(caster_pos.x + dx, caster_pos.y + dy, caster_pos.z)
		local ground_location = GetGroundPosition(target_point, caster)

		local egg = CreateUnitByName("npc_dota_phoenix_sun", ground_location, false, caster, caster:GetOwner(), caster:GetTeamNumber())
		egg:AddNewModifier(caster, ability, "modifier_kill", {duration = egg_duration })
		egg:AddNewModifier(egg, ability, "modifier_invoker_nova_egg_thinker", {duration = egg_duration + 0.3 })

		egg.max_attack = max_attack
		egg.current_attack = 0

		local egg_playback_rate = 6 / egg_duration
		egg:StartGestureWithPlaybackRate(ACT_DOTA_IDLE , egg_playback_rate)

		caster.egg = egg
		caster.HasDoubleEgg = false
		end
end

-----------------------------------------------------------------------------------------------------------

modifier_invoker_nova_egg_thinker = class({})

function modifier_invoker_nova_egg_thinker:IsHidden() 				return false end
function modifier_invoker_nova_egg_thinker:IsPurgable() 				return false end
function modifier_invoker_nova_egg_thinker:RemoveOnDeath() 			return true end
function modifier_invoker_nova_egg_thinker:IgnoreTenacity() 			return true end
function modifier_invoker_nova_egg_thinker:IsAura() 					return true end
function modifier_invoker_nova_egg_thinker:GetAuraSearchTeam() 		return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_invoker_nova_egg_thinker:GetAuraSearchType() 		return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
function modifier_invoker_nova_egg_thinker:GetAuraRadius() 			return self:GetAbility():GetSpecialValueFor("aura_radius") end
function modifier_invoker_nova_egg_thinker:GetModifierAura()			return "modifier_invoker_nova_dmg" end

function modifier_invoker_nova_egg_thinker:GetTexture()
	return "phoenix_supernova"
end

function modifier_invoker_nova_egg_thinker:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACKED,
		MODIFIER_EVENT_ON_DEATH,
	}
end

function modifier_invoker_nova_egg_thinker:GetModifierIncomingDamage_Percentage()
	return -100
end

function modifier_invoker_nova_egg_thinker:OnCreated()
	self.aura_radius	= self:GetAbility():GetSpecialValueFor("aura_radius")
	self.damage_per_sec	= self:GetAbility():GetSpecialValueFor("damage_per_sec")
	
	if not IsServer() then
		return
	end
	local egg = self:GetParent()
	local caster = self:GetCaster()
	local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_phoenix/phoenix_supernova_egg.vpcf", PATTACH_ABSORIGIN_FOLLOW, egg )
	ParticleManager:SetParticleControlEnt( pfx, 1, egg, PATTACH_POINT_FOLLOW, "attach_hitloc", egg:GetAbsOrigin(), true )
	ParticleManager:ReleaseParticleIndex( pfx )
	StartSoundEvent( "Hero_Phoenix.SuperNova.Begin", egg)
	StartSoundEvent( "Hero_Phoenix.SuperNova.Cast", egg)

	local ability = self:GetAbility()
	GridNav:DestroyTreesAroundPoint(egg:GetAbsOrigin(), ability:GetSpecialValueFor("cast_range") , false)
	
	AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self.aura_radius, 1, false)
	self:StartIntervalThink(1.0)
end

function modifier_invoker_nova_egg_thinker:OnIntervalThink()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local egg = self:GetParent()
	if not egg:IsAlive() then
		return
	end
	
	AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self.aura_radius, math.min(1, self:GetRemainingTime()), false)
	
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), egg:GetAbsOrigin(), nil, ability:GetSpecialValueFor("aura_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
	for _, enemy in pairs(enemies) do
		local damageTable = {
			victim = enemy,
			attacker = caster,
			damage = self.damage_per_sec,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = ability,
		}
		ApplyDamage(damageTable)
	end
end

function modifier_invoker_nova_egg_thinker:OnDeath( keys )
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local egg = self:GetParent()
	local killer = keys.attacker

	StopSoundEvent("Hero_Phoenix.SuperNova.Begin", egg)
	StopSoundEvent( "Hero_Phoenix.SuperNova.Cast", egg)
	if egg == killer then
		StartSoundEvent( "Hero_Phoenix.SuperNova.Explode", egg)
		local pfxName = "particles/units/heroes/hero_phoenix/phoenix_supernova_reborn.vpcf"
		local pfx = ParticleManager:CreateParticle( pfxName, PATTACH_ABSORIGIN_FOLLOW, caster )
		ParticleManager:SetParticleControl( pfx, 0, egg:GetAbsOrigin() )
		ParticleManager:SetParticleControl( pfx, 1, Vector(1.5,1.5,1.5) )
		ParticleManager:SetParticleControl( pfx, 3, egg:GetAbsOrigin() )
		ParticleManager:ReleaseParticleIndex(pfx)

		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), egg:GetAbsOrigin(), nil, ability:GetSpecialValueFor("aura_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
		for _, enemy in pairs(enemies) do
			enemy:AddNewModifier( caster, enemy, "modifier_stunned", {duration = ability:GetSpecialValueFor("stun_duration")} )
		end
	else
		StartSoundEventFromPosition( "Hero_Phoenix.SuperNova.Death", egg:GetAbsOrigin())
			local egg_buff = caster:FindModifierByNameAndCaster("modifier_invoker_nova_caster_dummy", caster)
			if egg_buff then
				egg_buff:Destroy()
			end
			if caster.ally and caster.ally:IsAlive() then
				local egg_buff2 = caster.ally:FindModifierByNameAndCaster("modifier_invoker_nova_caster_dummy", caster)
				if egg_buff2 then
					egg_buff2:Destroy()
				end
			end
	
		local pfxName = "particles/units/heroes/hero_phoenix/phoenix_supernova_death.vpcf"
		local pfx = ParticleManager:CreateParticle( pfxName, PATTACH_WORLDORIGIN, nil )
		local attach_point = caster:ScriptLookupAttachment( "attach_hitloc" )
		ParticleManager:SetParticleControl( pfx, 0, caster:GetAttachmentOrigin(attach_point) )
		ParticleManager:SetParticleControl( pfx, 1, caster:GetAttachmentOrigin(attach_point) )
		ParticleManager:SetParticleControl( pfx, 3, caster:GetAttachmentOrigin(attach_point) )
		ParticleManager:ReleaseParticleIndex(pfx)
	end
	caster.ally = nil
	caster.egg = nil
	self.bIsFirstAttacked = nil
end

function modifier_invoker_nova_egg_thinker:OnAttacked( keys )
	if not IsServer() then
		return
	end

	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local egg = self:GetParent()
	local attacker = keys.attacker

	if keys.target ~= egg then
		return
	end

	local max_attack = egg.max_attack
	local current_attack = egg.current_attack

	if attacker:IsRealHero() or attacker:IsClone() or attacker:IsTempestDouble() then
		egg.current_attack = egg.current_attack + 1
--	else
--		egg.current_attack = egg.current_attack + 0.25
	end
	if egg.current_attack >= egg.max_attack then
		egg:Kill(ability, attacker)
	else
		egg:SetHealth( (egg:GetMaxHealth() * ((egg.max_attack-egg.current_attack)/egg.max_attack)) )
	end
	local pfxName = "particles/units/heroes/hero_phoenix/phoenix_supernova_hit.vpcf"
	local pfx = ParticleManager:CreateParticle( pfxName, PATTACH_POINT_FOLLOW, egg )
	local attach_point = egg:ScriptLookupAttachment( "attach_hitloc" )
	ParticleManager:SetParticleControlEnt( pfx, 0, egg, PATTACH_POINT_FOLLOW, "attach_hitloc", egg:GetAttachmentOrigin(attach_point), true )
	ParticleManager:SetParticleControlEnt( pfx, 1, egg, PATTACH_POINT_FOLLOW, "attach_hitloc", egg:GetAttachmentOrigin(attach_point), true )
	--ParticleManager:ReleaseParticleIndex(pfx)
end

modifier_invoker_nova_dmg = modifier_invoker_nova_dmg or class({})

function modifier_invoker_nova_dmg:IsHidden() return false end
function modifier_invoker_nova_dmg:IsDebuff() return true end
function modifier_invoker_nova_dmg:IsPurgable() return false end

function modifier_invoker_nova_dmg:GetHeroEffectName() return "particles/units/heroes/hero_phoenix/phoenix_supernova_radiance.vpcf" end

function modifier_invoker_nova_dmg:GetEffectAttachType() return PATTACH_WORLDORIGIN end

function modifier_invoker_nova_dmg:OnCreated()
	self.extreme_burning_spell_amp	= self:GetAbility():GetSpecialValueFor("extreme_burning_spell_amp") * (-1)

	if not IsServer() then
		return
	end
	local target = self:GetParent()
	local caster = self:GetCaster()
	self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_supernova_radiance_streak_light.vpcf", PATTACH_POINT_FOLLOW, target)
	-- The fucking particle I can't do
	ParticleManager:SetParticleControlEnt( self.pfx, 8, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true )

end

function modifier_invoker_nova_dmg:OnDestroy()
	if not IsServer() then
		return
	end
	ParticleManager:DestroyParticle(self.pfx, false)
	ParticleManager:ReleaseParticleIndex(self.pfx)
end

function modifier_invoker_nova_dmg:DeclareFunctions()
	return {
		--MODIFIER_PROPERTY_MISS_PERCENTAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
	}
end


function modifier_invoker_nova_dmg:GetModifierSpellAmplify_Percentage()
	return self.extreme_burning_spell_amp
end

modifier_invoker_nova_scepter_passive = modifier_invoker_nova_scepter_passive or class({})

function modifier_invoker_nova_scepter_passive:IsDebuff()					return false end
function modifier_invoker_nova_scepter_passive:IsHidden()
	if self:GetCaster():HasScepter() and not self:GetCaster():HasModifier("modifier_invoker_nova_scepter_passive_cooldown") then
		return false
	else
		return true
	end
end
function modifier_invoker_nova_scepter_passive:IsPurgable() 				return false end
function modifier_invoker_nova_scepter_passive:IsPurgeException() 		return false end
function modifier_invoker_nova_scepter_passive:IsStunDebuff() 			return false end
function modifier_invoker_nova_scepter_passive:RemoveOnDeath()
	if self:GetCaster():IsRealHero() then
		return false
	else
		return true
	end
end
function modifier_invoker_nova_scepter_passive:RemoveOnDeath() 			return false end
function modifier_invoker_nova_scepter_passive:AllowIllusionDuplicate() 	return true end

function modifier_invoker_nova_scepter_passive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MIN_HEALTH,
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
end

function modifier_invoker_nova_scepter_passive:GetMinHealth()
	if self:GetCaster():PassivesDisabled() or self:GetCaster():HasModifier("modifier_invoker_nova_caster_dummy") or self:GetCaster():HasModifier("modifier_invoker_nova_scepter_passive_cooldown") or not self:GetCaster():IsRealHero() then
		return nil
	end
	if not self:GetCaster():HasScepter() then
		return nil
	else
		return 1
	end
end

function modifier_invoker_nova_scepter_passive:OnTakeDamage( keys )
	if not  IsServer() then
		return
	end
	if keys.unit ~= self:GetCaster() then
		return
	end
	if not self:GetCaster():HasScepter() then
		return
	end
	if self:GetCaster():FindModifierByName("modifier_invoker_nova_caster_dummy") or self:GetCaster():HasModifier("modifier_invoker_nova_scepter_passive_cooldown") then
		return
	end
	if self:GetCaster():PassivesDisabled() or not self:GetCaster():IsRealHero() then
		return
	end

	if self:GetCaster():GetHealth() <= 1 then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local cooldown_modifier = caster:AddNewModifier(caster, ability, "modifier_invoker_nova_scepter_passive_cooldown", { duration = scepter_cooldown})
		local egg_duration = ability:GetSpecialValueFor("duration")

		local location = caster:GetAbsOrigin()

		local max_attack = ability:GetSpecialValueFor("max_attack")

		caster:AddNewModifier(caster, ability, "modifier_invoker_nova_caster_dummy", {duration = egg_duration + extend_duration })
		caster:AddNoDraw()

		local egg = CreateUnitByName("npc_dota_phoenix_sun",location,false,caster,caster:GetOwner(),caster:GetTeamNumber())
		egg:AddNewModifier(caster, ability, "modifier_kill", {duration = egg_duration + extend_duration })
		egg:AddNewModifier(caster, ability, "modifier_invoker_nova_egg_thinker", {duration = egg_duration + extend_duration + 0.3})

		egg.max_attack = max_attack
		egg.current_attack = 0

		local egg_playback_rate = 6 / (egg_duration)
		egg:StartGestureWithPlaybackRate(ACT_DOTA_IDLE , egg_playback_rate)

		caster.egg = egg

		-- Set health to max here as compromise to prevent easy insta-gibs I guess
		caster:SetHealth(caster:GetMaxHealth())
	end
end

modifier_invoker_nova_scepter_passive_cooldown = modifier_invoker_nova_scepter_passive_cooldown or class({})

function modifier_invoker_nova_scepter_passive_cooldown:IsDebuff()				return true end
function modifier_invoker_nova_scepter_passive_cooldown:IsHidden() 				return false end
function modifier_invoker_nova_scepter_passive_cooldown:IsPurgable() 				return false end
function modifier_invoker_nova_scepter_passive_cooldown:IsPurgeException() 		return false end
function modifier_invoker_nova_scepter_passive_cooldown:IsStunDebuff() 			return false end
function modifier_invoker_nova_scepter_passive_cooldown:RemoveOnDeath() 			return false end
function modifier_invoker_nova_scepter_passive_cooldown:AllowIllusionDuplicate() 	return false end
function modifier_invoker_nova_scepter_passive_cooldown:OnCreated() 
	if IsServer() then 
		self:StartIntervalThink(1)
	end
end

function modifier_invoker_nova_scepter_passive_cooldown:OnIntervalThink() 
	if IsServer() then 
		self:SetStackCount(self:GetStackCount() - 1)
	end
end