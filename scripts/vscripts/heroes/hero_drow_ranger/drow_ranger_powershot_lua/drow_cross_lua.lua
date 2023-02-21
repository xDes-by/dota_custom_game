drow_cross_lua = class({})

function drow_cross_lua:GetManaCost(iLevel)
    local caster = self:GetCaster()
    self.mana = caster:GetIntellect()
    if caster then
    local abil = caster:FindAbilityByName("npc_dota_hero_drow_ranger_int7")
        if abil ~= nil    then 
        	self.mana = caster:GetIntellect() / 2
		end
        if self:GetCaster():FindAbilityByName("npc_dota_hero_drow_ranger_int_last") ~= nil then
            self.mana = self.mana * 0.9
        end
    end
    return math.min(65000, self.mana)
end

function drow_cross_lua:GetCooldown(level)
    self.bonus = self.BaseClass.GetCooldown( self, level )
    local caster = self:GetCaster()
    local abil = caster:FindAbilityByName("npc_dota_hero_drow_ranger_int8")
        if abil ~= nil then 
             self.bonus =  0.1
		end
		if self:GetCaster():FindAbilityByName("npc_dota_hero_drow_ranger_int_last") ~= nil and self.bonus == 0.1 then
        	self.bonus = 0
   	 	end        
    return self.bonus
end


function drow_cross_lua:OnSpellStart()
	self.caster = self:GetCaster()
	self.width_initial = 100
	self.width_end = 100
	self.speed = self:GetSpecialValueFor("speed")
	self.distance = self:GetSpecialValueFor("distance")
	self.count = self:GetSpecialValueFor("count")-1
	local shot_damage = self:GetSpecialValueFor( "damage" )
	
	local front = self:GetCaster():GetForwardVector():Normalized()
	local target_pos = self:GetCaster():GetOrigin() + front * 700
	
	damage_type = DAMAGE_TYPE_PHYSICAL
	damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
	
	if self.caster:FindAbilityByName("npc_dota_hero_drow_ranger_int9") ~= nil then 
		shot_damage = self.caster:GetIntellect()
	end
	
	if self.caster:FindAbilityByName("npc_dota_hero_drow_ranger_int10") ~= nil then 
		self.count = 3
	end
	
	if self.caster:FindAbilityByName("npc_dota_hero_drow_ranger_int11") ~= nil then 
		damage_type = DAMAGE_TYPE_MAGICAL
		damage_flags = DOTA_DAMAGE_FLAG_NONE
	end
	
	self.damage = {
		attacker = self.caster,
		damage = shot_damage,	
		damage_type = damage_type,
		damage_flags = damage_flags,
	}
	local center_distance = {0,200,400,600,800}

	local orso_distance = {100,200,300,400,500}

	local a = target_pos
	local b = self:GetCaster():GetOrigin()
	local length = 0
	local c1 = self:GetCaster():GetOrigin()
	local c2 = self:GetCaster():GetOrigin()

	for i=1, self.count do 
		local offset = target_pos

		if a.x-b.x < 0 then
			offset.x = a.x-center_distance[i]*math.cos(math.atan((b.y-a.y)/(b.x-a.x)))
			offset.y = a.y-center_distance[i]*math.sin(math.atan((b.y-a.y)/(b.x-a.x)))
		else
			offset.x = a.x+center_distance[i]*math.cos(math.atan((b.y-a.y)/(b.x-a.x)))
			offset.y = a.y+center_distance[i]*math.sin(math.atan((b.y-a.y)/(b.x-a.x)))
		end 

		length = orso_distance[i]
		c1.x = b.x+(length*(offset.y-b.y)/math.sqrt((offset.x-b.x)*(offset.x-b.x)+(offset.y-b.y)*(offset.y-b.y)))
		c1.y = b.y-(length*(offset.x-b.x)/math.sqrt((offset.x-b.x)*(offset.x-b.x)+(offset.y-b.y)*(offset.y-b.y)))
		c2.x = b.x-(length*(offset.y-b.y)/math.sqrt((offset.x-b.x)*(offset.x-b.x)+(offset.y-b.y)*(offset.y-b.y)))
		c2.y = b.y+(length*(offset.x-b.x)/math.sqrt((offset.x-b.x)*(offset.x-b.x)+(offset.y-b.y)*(offset.y-b.y)))

		local vDirection1 = offset - c1	
		vDirection1.z = 0.0
		vDirection1 = vDirection1:Normalized()
		local vDirection2 = offset - c2	
		vDirection2.z = 0.0
		vDirection2 = vDirection2:Normalized()	
		self.speed = self.speed * ( self.distance / ( self.distance - self.width_initial ) )

		local info1 = {
			EffectName = "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_spell_powershot_v2.vpcf",
			Ability = self,
			vSpawnOrigin = c1, 
			fStartRadius = self.width_initial,
			fEndRadius = self.width_end,
			vVelocity = vDirection1 * self.speed,
			fDistance = self.distance,
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		}
		ProjectileManager:CreateLinearProjectile( info1 )	
		local info2 = {
			EffectName = "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_spell_powershot_v2.vpcf",
			Ability = self,
			vSpawnOrigin = c2, 
			fStartRadius = self.width_initial,
			fEndRadius = self.width_end,
			vVelocity = vDirection2 * self.speed,
			fDistance = self.distance,
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		}
		ProjectileManager:CreateLinearProjectile( info2 )
	end 

	self:GetCaster():EmitSound("Ability.Powershot")
end

function drow_cross_lua:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
		self.damage.victim = hTarget
		ApplyDamage( self.damage )
 	end
end