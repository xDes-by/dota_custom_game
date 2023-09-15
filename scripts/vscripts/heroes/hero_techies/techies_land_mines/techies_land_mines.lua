techies_land_mines_lua = class({})

LinkLuaModifier("modifier_land_mines", "heroes/hero_techies/techies_land_mines/techies_land_mines.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_land_mines_explose_delay", "heroes/hero_techies/techies_land_mines/techies_land_mines.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dummy_thinker", "heroes/hero_techies/techies_land_mines/techies_land_mines.lua", LUA_MODIFIER_MOTION_NONE)

modifier_dummy_thinker = {}

function techies_land_mines_lua:IsHidden() 		            return false end
function techies_land_mines_lua:IsRefreshable() 			return true end
function techies_land_mines_lua:IsStealable() 				return true end
function techies_land_mines_lua:IsNetherWardStealable()	return false end
function techies_land_mines_lua:GetAOERadius() return self:GetSpecialValueFor("small_radius") end

function techies_land_mines_lua:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end

function techies_land_mines_lua:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local count = 1
	if self:GetCaster():FindAbilityByName("npc_dota_hero_techies_str_last") ~= nil then
		count = 2
	end	
	
	self:GetCaster():EmitSound("Hero_Techies.LandMine.Plant")
	
	for i=1,count  do
		local mine = CreateUnitByName("land_mine_trap", pos + RandomVector( RandomInt( count * 10, count * 10 )), true, caster, caster, caster:GetTeamNumber())
		mine:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
		mine:AddNewModifier(caster, self, "modifier_land_mines", {})
		if self:GetCaster():FindAbilityByName("npc_dota_hero_techies_agi6") == nil then
			mine:AddNewModifier(caster, self, "modifier_invulnerable", {})
		end	
	end
end

---------------------------------------------------------------------------------------------------

modifier_land_mines = class({})

function modifier_land_mines:IsDebuff()
	return false
end

function modifier_land_mines:IsHidden()
	return true
end

function modifier_land_mines:IsPurgable()
	return false
end

function modifier_land_mines:IsPurgeException()
	return false
end

function modifier_land_mines:DeclareFunctions()
	return {
	MODIFIER_PROPERTY_MOVESPEED_MAX,
	MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
	}
end

function modifier_land_mines:GetModifierMoveSpeed_Max()
	return 25
end

function modifier_land_mines:GetModifierMoveSpeed_Absolute()
	return 25
end

function modifier_land_mines:CheckState()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_techies_agi10") == nil then 
		return {[MODIFIER_STATE_ROOTED] = true, [MODIFIER_STATE_NO_UNIT_COLLISION] = true,[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,[MODIFIER_STATE_MAGIC_IMMUNE] = true}
	else
		return {[MODIFIER_STATE_NO_UNIT_COLLISION] = true, [MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true, [MODIFIER_STATE_MAGIC_IMMUNE] = true}
	end
end

function modifier_land_mines:GetEffectName()
	return "particles/units/heroes/hero_techies/techies_land_mine.vpcf"
end

function modifier_land_mines:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_land_mines:OnCreated()
	self.mine = self:GetParent()
	self.caster = self:GetCaster()
	self.damage = self:GetAbility():GetSpecialValueFor("damage")
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_techies_str9") ~= nil then
		self.damage = self:GetCaster():GetMaxHealth()*0.2
	end	
	
	self.small_radius = self:GetAbility():GetSpecialValueFor("small_radius")
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_techies_str11") ~= nil then
		self.small_radius = self:GetAbility():GetSpecialValueFor("small_radius") + 300
	end	
	
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end

function modifier_land_mines:OnIntervalThink()
	local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.mine:GetAbsOrigin(), nil, self.small_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #enemies > 0 and not self.mine:HasModifier("modifier_land_mines_explose_delay") then
		local sound = CreateModifierThinker(self.caster, self:GetAbility(), "modifier_dummy_thinker", {duration = 0.5}, self.mine:GetAbsOrigin(), self.caster:GetTeamNumber(), false)
		sound:EmitSound("Hero_Techies.LandMine.Priming")
		self.mine:AddNewModifier(self.caster, self:GetAbility(), "modifier_land_mines_explose_delay", {duration = self:GetAbility():GetSpecialValueFor("activation_time")})
	end
end

function modifier_land_mines:OnDestroy()
	if IsServer() and self:GetStackCount() > 0 then
		mine_damage = self:GetAbility():GetSpecialValueFor("damage")
		
		if self:GetCaster():FindAbilityByName("npc_dota_hero_techies_str9") ~= nil then
			mine_damage = self:GetCaster():GetMaxHealth() * 0.2 + mine_damage
		end	
		if self:GetCaster():FindAbilityByName("npc_dota_hero_techies_agi7") ~= nil then
			mine_damage = self:GetCaster():GetAttackDamage() + mine_damage
		end	
		if self:GetCaster():FindAbilityByName("npc_dota_hero_techies_agi11") ~= nil then
			mine_damage = mine_damage + mine_damage
		end	
		if self:GetCaster():FindAbilityByName("npc_dota_hero_techies_int6") ~= nil then
			mine_damage = mine_damage + self:GetCaster():GetIntellect()
		end			
		if self:GetCaster():FindAbilityByName("npc_dota_hero_techies_str8") ~= nil then
			local point = self:GetCaster():GetAbsOrigin()
			local point_mine = self.mine:GetAbsOrigin()
						
			local flDist = (point - point_mine):Length2D()
			if flDist < self.small_radius then
				mine_damage = mine_damage * 1.5
			end
		end
		
		local ampl = self:GetParent():GetOwner():GetSpellAmplification(false) + 1
		
		damage = mine_damage * ampl
		
		local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.mine:GetAbsOrigin(), nil, self.small_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			ApplyDamage({victim = enemy, attacker = self.mine, damage = damage, damage_type = self:GetAbility():GetAbilityDamageType(), ability = self:GetAbility()})
		end

		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, self.mine:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 2, Vector(self.small_radius, self.small_radius, self.small_radius))
		Timers:CreateTimer(5.0, function()
				ParticleManager:DestroyParticle(pfx, true)
				ParticleManager:ReleaseParticleIndex(pfx)
				return nil
			end
		)
		local sound = CreateModifierThinker(self.caster, self:GetAbility(), "modifier_dummy_thinker", {duration = 0.5}, self.mine:GetAbsOrigin(), self.caster:GetTeamNumber(), false)
		sound:EmitSound("Hero_Techies.LandMine.Detonate")
		self:GetParent():ForceKill(false)
	end
	-- self:GetAbility() = nil
	self.mine = nil
	self.caster = nil
	self.damage = nil
	self.small_radius = nil
end

---------------------------------------------------------------------------

modifier_land_mines_explose_delay = class({})

function modifier_land_mines_explose_delay:IsDebuff()			return false end
function modifier_land_mines_explose_delay:IsHidden() 			return true end
function modifier_land_mines_explose_delay:IsPurgable() 		return false end
function modifier_land_mines_explose_delay:IsPurgeException() 	return false end

function modifier_land_mines_explose_delay:OnDestroy()
	self.small_radius = self:GetAbility():GetSpecialValueFor("small_radius")
	if self:GetCaster():FindAbilityByName("npc_dota_hero_techies_str11") ~= nil then
		self.small_radius = self:GetAbility():GetSpecialValueFor("small_radius") + 300
	end	
	
	if IsServer() then
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.small_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #enemies > 0 and self:GetElapsedTime() >= self:GetDuration() then
			local buff = self:GetParent():FindModifierByName("modifier_land_mines")
			if buff then
				buff:SetStackCount(1)
				buff:Destroy()
			end
		end
	end
end