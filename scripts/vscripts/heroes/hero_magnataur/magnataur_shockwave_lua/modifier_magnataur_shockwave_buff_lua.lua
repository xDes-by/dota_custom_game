modifier_magnataur_shockwave_buff_lua = {}

function modifier_magnataur_shockwave_buff_lua:OnCreated()
    self.parent = self:GetParent()
	self.caster = self:GetCaster()
    self.ability = self:GetAbility()
	self.tick = 0
    self:StartIntervalThink( 1 )
	self:OnIntervalThink()

end

function modifier_magnataur_shockwave_buff_lua:IsHidden()
	if self:GetStackCount() > 0 then
		return false
	end
	return true
end

function modifier_magnataur_shockwave_buff_lua:AddStack( count )
	self:SetStackCount( self:GetStackCount() + count)
end


function modifier_magnataur_shockwave_buff_lua:OnIntervalThink()
    if not IsServer() then return end
	------- Talent ------------
	local int10 = self.caster:FindAbilityByName("npc_dota_hero_magnataur_int10")
	if int10 ~= nil then
		self.tick = self.tick + 1
		if self.tick % 3 == 0 then
			self:AddStack(1)
		end
	end
	----------------------------
	if self:GetStackCount() < 1 then return end
	
    local origin = self.parent:GetAbsOrigin()

    -- Находим все вражеские юниты в радиусе 1000 единиц от героя
    local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
    local point = nil
    if #enemies>0 then 
        local rand = RandomInt(1, #enemies)
        point = enemies[1]:GetOrigin()
    else
        local angle = math.random(0, 360) -- генерируем случайный угол в градусах
        local random_vector = Vector(math.cos(angle), math.sin(angle), 0) -- создаем вектор из полученного угла

        point = origin + (random_vector * 500) -- получаем случайную точку вокруг персонажа
    end

	-- load data
	local name = "particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf"
	local distance = self.ability:GetCastRange( point, nil )
	local radius = self.ability:GetSpecialValueFor( "shock_width" )
	local speed = self.ability:GetSpecialValueFor( "shock_speed" )

	local direction = point - self.parent:GetOrigin()
	direction.z = 0
	direction = direction:Normalized()

	-- create projectile
	local info = {
		Source = self.parent,
		Ability = self.ability,
		vSpawnOrigin = origin,
		
	    bDeleteOnHit = true,
	    
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = name,
	    fDistance = distance,
	    fStartRadius = radius,
	    fEndRadius = radius,
		vVelocity = direction * speed,
	}
	ProjectileManager:CreateLinearProjectile(info)
	self:DecrementStackCount()
end

function modifier_magnataur_shockwave_buff_lua:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK
	}
end

function modifier_magnataur_shockwave_buff_lua:OnAttack( params )
	if params.attacker~=self:GetParent() then return end
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_magnataur_int50") and RollPercentage(10) then
		self:IncrementStackCount()
		self:OnIntervalThink()
	end
end