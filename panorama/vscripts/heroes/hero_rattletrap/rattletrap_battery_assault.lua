modifier_rattletrap_battery_assault_lua = class({})

function modifier_rattletrap_battery_assault_lua:OnCreated()
	if IsClient() then return end

	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.interval = self.ability:GetSpecialValueFor("interval")
	self.radius	= self.ability:GetSpecialValueFor("radius")
	self.damage = self.ability:GetSpecialValueFor("damage")

	-- Ministun interval reduction talent
	local interval_talent = self:GetCaster():FindAbilityByName("special_bonus_unique_clockwerk")
	if interval_talent and interval_talent:GetLevel() > 0 then
		-- Special value is already negative
		self.interval = self.interval + interval_talent:GetSpecialValueFor("value")
	end

	-- Damage increase talent
	local damage_talent = self:GetCaster():FindAbilityByName("special_bonus_unique_clockwerk_3")
	if damage_talent and damage_talent:GetLevel() > 0 then
		self.damage = self.damage + damage_talent:GetSpecialValueFor("value")
	end

	self.damageTable = {
		--victim 			= enemy,
		damage 			= self.damage,
		damage_type		= DAMAGE_TYPE_MAGICAL,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self.caster,
		ability = self.ability,
	}

	self:OnIntervalThink() -- First tick happens on the cast
	self:StartIntervalThink(self.interval)
end

function modifier_rattletrap_battery_assault_lua:OnIntervalThink()
	if (not self.caster) or self.caster:IsNull() then return end

	self.caster:EmitSound("Hero_Rattletrap.Battery_Assault_Launch")

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_rattletrap/rattletrap_battery_assault.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
	ParticleManager:ReleaseParticleIndex(particle)

	local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
		self.caster:GetAbsOrigin(),
		nil,
		self.radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false)

	if #enemies >= 1 then
		self.caster:EmitSound("Hero_Rattletrap.Battery_Assault_Impact")

		for _, enemy in pairs(enemies) do
			local shrapnel_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_rattletrap/rattletrap_battery_shrapnel.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
			ParticleManager:SetParticleControl(shrapnel_pfx, 1, enemy:GetAttachmentOrigin(DOTA_PROJECTILE_ATTACHMENT_HITLOCATION))
			ParticleManager:ReleaseParticleIndex(shrapnel_pfx)

			self.damageTable["victim"] = enemy
			ApplyDamage(self.damageTable)
			enemy:AddNewModifier(self.caster, self.ability, "modifier_rattletrap_battery_assault_lua_stun", {duration = 0.1})
		end
	else
		local shrapnel_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_rattletrap/rattletrap_battery_shrapnel.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
		ParticleManager:SetParticleControl(shrapnel_pfx, 1, self.caster:GetAbsOrigin() + RandomVector(RandomInt(0, 175)) + Vector(0, 0, 200))
		ParticleManager:ReleaseParticleIndex(shrapnel_pfx)
	end
end

-- Stun Modifier
LinkLuaModifier("modifier_rattletrap_battery_assault_lua_stun", "heroes/hero_rattletrap/rattletrap_battery_assault", LUA_MODIFIER_MOTION_NONE)

modifier_rattletrap_battery_assault_lua_stun = class({})

function modifier_rattletrap_battery_assault_lua_stun:GetTexture() return "rattletrap_battery_assault" end
function modifier_rattletrap_battery_assault_lua_stun:IsDebuff() return true end
function modifier_rattletrap_battery_assault_lua_stun:IsHidden() return false end
function modifier_rattletrap_battery_assault_lua_stun:IsPurgeException() return true end
function modifier_rattletrap_battery_assault_lua_stun:IsStunDebuff() return true end

function modifier_rattletrap_battery_assault_lua_stun:CheckState()
	return { [MODIFIER_STATE_STUNNED] = true }
end

function modifier_rattletrap_battery_assault_lua_stun:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_rattletrap_battery_assault_lua_stun:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_rattletrap_battery_assault_lua_stun:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
end

function modifier_rattletrap_battery_assault_lua_stun:GetOverrideAnimation()
	return ACT_DOTA_DISABLED
end
