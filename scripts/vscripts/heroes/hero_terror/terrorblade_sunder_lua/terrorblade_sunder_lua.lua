terrorblade_sunder_lua = class({})
LinkLuaModifier( "modifier_terrorblade_sunder_lua", "heroes/hero_terror/terrorblade_sunder_lua/terrorblade_sunder_lua", LUA_MODIFIER_MOTION_NONE )

function terrorblade_sunder_lua:GetManaCost(iLevel)
	return 150 + math.min(65000, self:GetCaster():GetIntellect()/ 30)
end

function terrorblade_sunder_lua:OnSpellStart()
	local caster = self:GetCaster()
	local point = caster:GetAbsOrigin()
	caster:EmitSound("Hero_Terrorblade.Sunder.Cast")
	local radius = self:GetSpecialValueFor( "range" )
	local duration = self:GetSpecialValueFor( "duration" )
	local sunderdamage = self:GetSpecialValueFor( "damage" )
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_terrorblade_int9")
	if abil ~= nil then
	sunderdamage = self:GetCaster():GetHealth()/2
	end
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_terrorblade_int11")
	if abil ~= nil then
		if self:GetCaster():HasModifier("modifier_terrorblade_metamorphosis_lua_aura") then
			sunderdamage = sunderdamage * 2 
		end
	end

	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		point,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_CREEP,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	caster:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_terrorblade_sunder_lua", -- modifier name
			{ duration = duration } -- kv
		)
	
		local modifier = caster:AddNewModifier(caster, caster, "modifier_terrorblade_sunder_lua", nil)
		caster:SetModifierStackCount("modifier_terrorblade_sunder_lua", caster, #enemies)
		damage_type = DAMAGE_TYPE_PURE
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
	for _,enemy in pairs(enemies) do
		ApplyDamage({victim = enemy, attacker = self:GetCaster(), ability = ability, damage = sunderdamage, damage_type = damage_type, damage_flags = damage_flags})
	end
end

------------------------------------------------------------
modifier_terrorblade_sunder_lua = class({})

function modifier_terrorblade_sunder_lua:IsHidden()
	return false
end

function modifier_terrorblade_sunder_lua:IsPurgable()
	return false
end

function modifier_terrorblade_sunder_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
	}
	return funcs
end

function modifier_terrorblade_sunder_lua:OnCreated()
	if IsServer() then
		self.caster = self:GetCaster()	
		local hp_hero = self.caster:GetMaxHealth()
		self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_terrorblade_int11")
		if abil ~= nil then
			if self:GetCaster():HasModifier("modifier_terrorblade_metamorphosis_lua_aura") then
				self.damage = self.damage * 2 
			end
		end
	
		Timers:CreateTimer(0.1, function()
			sunder_hp_stack = self:GetStackCount()*self.damage
			self.caster:SetMaxHealth(hp_hero+sunder_hp_stack)
		return nil
		end)
	end
end

function modifier_terrorblade_sunder_lua:GetModifierExtraHealthBonus()
	return sunder_hp_stack
end