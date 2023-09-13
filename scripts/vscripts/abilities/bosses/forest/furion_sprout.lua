furion_sprout_lua = class({})

LinkLuaModifier("modifier_furion_sprout_lua_damage", "abilities/bosses/forest/furion_sprout", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_furion_sprout_lua_stun", "abilities/bosses/forest/furion_sprout", LUA_MODIFIER_MOTION_NONE)

function furion_sprout_lua:OnSpellStart()
	self.duration = self:GetSpecialValueFor( "duration" )
	self.radius = self:GetSpecialValueFor( "radius" )
	self.vision_range = self:GetSpecialValueFor( "vision_range" )

	local hTarget = self:GetCursorTarget()
	if hTarget == nil or ( hTarget ~= nil and ( not hTarget:TriggerSpellAbsorb( self ) ) ) then
		local vTargetPosition = nil
		if hTarget ~= nil then 
			vTargetPosition = hTarget:GetOrigin()
		else
			vTargetPosition = self:GetCursorPosition()
		end

		local r = self.radius 
		local c = math.sqrt( 2 ) * 0.5 * r 
		local x_offset = { -r, -c, 0.0, c, r, c, 0.0, -c }
		local y_offset = { 0.0, c, r, c, 0.0, -c, -r, -c }

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_furion/furion_sprout.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, vTargetPosition )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 0.0, r, 0.0 ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		for i = 1,8 do
			CreateTempTree( vTargetPosition + Vector( x_offset[i], y_offset[i], 0.0 ), self.duration )
		end

		for i = 1,8 do
			ResolveNPCPositions( vTargetPosition + Vector( x_offset[i], y_offset[i], 0.0 ), 64.0 ) --Tree Radius
		end

		AddFOWViewer( self:GetCaster():GetTeamNumber(), vTargetPosition, self.vision_range, self.duration, false )
		EmitSoundOnLocationWithCaster( vTargetPosition, "Hero_Furion.Sprout", self:GetCaster() )

		CreateModifierThinker(self:GetCaster(), self, "modifier_furion_sprout_lua_damage", {duration = self.duration}, vTargetPosition, self:GetCaster():GetTeamNumber(), false)	
	end
end

modifier_furion_sprout_lua_damage = class({})
--Classifications template
function modifier_furion_sprout_lua_damage:IsHidden()
	return true
end

function modifier_furion_sprout_lua_damage:IsDebuff()
	return false
end

function modifier_furion_sprout_lua_damage:IsPurgable()
	return false
end

function modifier_furion_sprout_lua_damage:IsPurgeException()
	return false
end

-- Optional Classifications
function modifier_furion_sprout_lua_damage:IsStunDebuff()
	return false
end

function modifier_furion_sprout_lua_damage:RemoveOnDeath()
	return true
end

function modifier_furion_sprout_lua_damage:DestroyOnExpire()
	return true
end

function modifier_furion_sprout_lua_damage:OnCreated()
	self.parent = self:GetParent()
	self.pos = self.parent:GetAbsOrigin()
	if not IsServer() then
		return
	end
	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_furion/furion_sprout_damage_aoe.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(p, 1, Vector(500,0,0))
	self:AddParticle(p, false, false, -1, false, false)
	self:StartIntervalThink(0.5)
	self:OnIntervalThink()
end

function modifier_furion_sprout_lua_damage:OnIntervalThink()
	local units = FindUnitsInRadius(self.parent:GetTeam(), self.pos, nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
	for _,u in pairs(units) do
		ApplyDamage({
			victim = u,
			attacker = self.parent,
			damage = u:GetMaxHealth() * 0.01,
			damage_type = DAMAGE_TYPE_MAGICAL,
			damage_flags = 0,
			ability = self:GetAbility()
		})
	end
end

function modifier_furion_sprout_lua_damage:OnDestroy()
	if not IsServer() then
		return
	end
	for i =1, 3 do
		local creep = CreateUnitByName( "npc_forest_boss_minion", self.pos + RandomVector(RandomInt(150, 350)), true, nil, nil, DOTA_TEAM_BADGUYS )
		creep:AddNewModifier(creep, nil, "modifier_kill", {duration = 10})
		add_modifier(creep)
	end	
	CreateModifierThinker(self:GetCaster(), self:GetAbility(), "modifier_furion_sprout_lua_stun", {duration = 10.1}, self.pos, self:GetCaster():GetTeamNumber(), false)
	UTIL_Remove(self.parent)
end

modifier_furion_sprout_lua_stun = class({})
--Classifications template
function modifier_furion_sprout_lua_stun:IsHidden()
	return true
end

function modifier_furion_sprout_lua_stun:IsDebuff()
	return false
end

function modifier_furion_sprout_lua_stun:IsPurgable()
	return false
end

function modifier_furion_sprout_lua_stun:IsPurgeException()
	return false
end

-- Optional Classifications
function modifier_furion_sprout_lua_stun:IsStunDebuff()
	return false
end

function modifier_furion_sprout_lua_stun:RemoveOnDeath()
	return true
end

function modifier_furion_sprout_lua_stun:DestroyOnExpire()
	return true
end

function modifier_furion_sprout_lua_stun:OnCreated()
	self.parent = self:GetParent()
	self.pos = self.parent:GetAbsOrigin()
	if not IsServer() then
		return
	end
	self.radius = 240
	self:StartIntervalThink(5)
	self:OnIntervalThink()
end

function modifier_furion_sprout_lua_stun:OnIntervalThink()
	local units = FindUnitsInRadius(self.parent:GetTeam(), self.pos, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
	for _,u in pairs(units) do
		ApplyDamage({
			victim = u,
			attacker = self.parent,
			damage = 1000,
			damage_type = DAMAGE_TYPE_MAGICAL,
			damage_flags = 0,
			ability = self:GetAbility()
		})
		u:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = 2})
	end
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "Hero_Leshrac.Split_Earth", self:GetCaster() )
	self.radius = self.radius + 60
	if self:GetRemainingTime() > 5 then
		local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_leshrac/leshrac_split_earth_aoe.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
		ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	end
end

function modifier_furion_sprout_lua_stun:OnDestroy()
	UTIL_Remove(self.parent)
end

function add_modifier(unit)
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