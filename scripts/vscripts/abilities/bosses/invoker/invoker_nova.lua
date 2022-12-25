LinkLuaModifier("modifier_invoker_nova_egg_thinker", "abilities/bosses/invoker/invoker_nova", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invoker_nova_dmg", "abilities/bosses/invoker/invoker_nova", LUA_MODIFIER_MOTION_NONE)

invoker_nova = class({})

function invoker_nova:OnSpellStart()
	if not IsServer() then return end
	local egg_duration = self:GetSpecialValueFor("duration")
	local max_attack = self:GetSpecialValueFor("max_attack")
	local caster_pos = self:GetCaster():GetAbsOrigin()
	
	for i = 1, 2 do
		local angle = RandomInt(0, 360)
		local variance = RandomInt(-800, 800)
		local dy = math.sin(angle) * variance
		local dx = math.cos(angle) * variance
		local target_point = Vector(caster_pos.x + dx, caster_pos.y + dy, caster_pos.z)
		local ground_location = GetGroundPosition(target_point, self:GetCaster())

		egg = CreateUnitByName("npc_dota_phoenix_sun", ground_location, false, self:GetCaster(), self:GetCaster():GetOwner(), self:GetCaster():GetTeamNumber())
		egg:AddNewModifier(egg, self, "modifier_kill", {duration = egg_duration })
		egg:AddNewModifier(egg, self, "modifier_invoker_nova_egg_thinker", {duration = egg_duration + 0.3 })

		egg.max_attack = max_attack
		egg.current_attack = 0

		local egg_playback_rate = 6 / egg_duration
		egg:StartGestureWithPlaybackRate(ACT_DOTA_IDLE , egg_playback_rate)
	end
end

-----------------------------------------------------------------------------------------------------------

modifier_invoker_nova_egg_thinker = class({})

function modifier_invoker_nova_egg_thinker:IsHidden() return true end
function modifier_invoker_nova_egg_thinker:IsPurgable() return false end

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
	
	if not IsServer() then return end

	local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_phoenix/phoenix_supernova_egg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt( pfx, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
	ParticleManager:ReleaseParticleIndex( pfx )
	StartSoundEvent( "Hero_Phoenix.SuperNova.Begin", self:GetParent())
	StartSoundEvent( "Hero_Phoenix.SuperNova.Cast", self:GetParent())

	GridNav:DestroyTreesAroundPoint(self:GetParent():GetAbsOrigin(), self:GetAbility():GetSpecialValueFor("cast_range") , false)
	self:StartIntervalThink(1.0)
end

function modifier_invoker_nova_egg_thinker:OnIntervalThink()
	if not IsServer() then return end
	if not self:GetParent():IsAlive() then return end
	
	AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self.aura_radius, math.min(1, self:GetRemainingTime()), false)
	
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("aura_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
	for _, enemy in pairs(enemies) do
		local damageTable = {
			victim = enemy,
			attacker = self:GetCaster(),
			damage = self.damage_per_sec,
			damage_type = DAMAGE_TYPE_MAGICAL,
		}
		ApplyDamage(damageTable)
	end
end

function modifier_invoker_nova_egg_thinker:OnDeath( keys )
	if not IsServer() then return end
	local killer = keys.attacker

	StopSoundEvent("Hero_Phoenix.SuperNova.Begin", self:GetParent())
	StopSoundEvent( "Hero_Phoenix.SuperNova.Cast", self:GetParent())
	if self:GetParent() == killer then
		StartSoundEvent( "Hero_Phoenix.SuperNova.Explode", self:GetParent())
		local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_phoenix/phoenix_supernova_reborn.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControl( pfx, 0, self:GetParent():GetAbsOrigin() )
		ParticleManager:SetParticleControl( pfx, 1, Vector(1.5,1.5,1.5) )
		ParticleManager:SetParticleControl( pfx, 3, self:GetParent():GetAbsOrigin() )
		ParticleManager:ReleaseParticleIndex(pfx)

		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("aura_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
		for _, enemy in pairs(enemies) do
			enemy:AddNewModifier( self:GetCaster(), enemy, "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("stun_duration")} )
		end
		UTIL_Remove( self:GetParent() )
	else
		StartSoundEventFromPosition( "Hero_Phoenix.SuperNova.Death", self:GetParent():GetAbsOrigin())
		local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_phoenix/phoenix_supernova_death.vpcf", PATTACH_WORLDORIGIN, nil )
		local attach_point = self:GetCaster():ScriptLookupAttachment( "attach_hitloc" )
		ParticleManager:SetParticleControl( pfx, 0, self:GetCaster():GetAttachmentOrigin(attach_point) )
		ParticleManager:SetParticleControl( pfx, 1, self:GetCaster():GetAttachmentOrigin(attach_point) )
		ParticleManager:SetParticleControl( pfx, 3, self:GetCaster():GetAttachmentOrigin(attach_point) )
		ParticleManager:ReleaseParticleIndex(pfx)
	end
end

function modifier_invoker_nova_egg_thinker:OnAttacked( keys )
	if not IsServer() then return end
	local attacker = keys.attacker
	if keys.target ~= self:GetParent() then return end

	local max_attack = egg.max_attack
	local current_attack = egg.current_attack

	if attacker:IsRealHero() or attacker:IsClone() or attacker:IsTempestDouble() then
		egg.current_attack = egg.current_attack + 1
	end
	
	if egg.current_attack >= egg.max_attack then
		self:GetParent():Kill(self:GetAbility(), attacker)
	else
		self:GetParent():SetHealth( (self:GetParent():GetMaxHealth() * ((egg.max_attack-egg.current_attack)/egg.max_attack)) )
	end
	local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_phoenix/phoenix_supernova_hit.vpcf", PATTACH_POINT_FOLLOW, self:GetParent() )
	local attach_point = self:GetParent():ScriptLookupAttachment( "attach_hitloc" )
	ParticleManager:SetParticleControlEnt( pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAttachmentOrigin(attach_point), true )
	ParticleManager:SetParticleControlEnt( pfx, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAttachmentOrigin(attach_point), true )
end