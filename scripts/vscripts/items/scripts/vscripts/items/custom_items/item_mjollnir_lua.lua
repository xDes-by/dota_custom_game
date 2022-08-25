item_mjollnir_lua1 = item_mjollnir_lua1 or class({})
item_mjollnir_lua2 = item_mjollnir_lua1 or class({})
item_mjollnir_lua3 = item_mjollnir_lua1 or class({})
item_mjollnir_lua4 = item_mjollnir_lua1 or class({})
item_mjollnir_lua5 = item_mjollnir_lua1 or class({})
item_mjollnir_lua6 = item_mjollnir_lua1 or class({})
item_mjollnir_lua7 = item_mjollnir_lua1 or class({})


LinkLuaModifier("modifier_item_mjollnir", 'items/custom_items/item_mjollnir_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_mjollnir_strike", 'items/custom_items/item_mjollnir_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_mjollnir_active", 'items/custom_items/item_mjollnir_lua.lua', LUA_MODIFIER_MOTION_NONE)

function item_mjollnir_lua1:GetIntrinsicModifierName()
	return "modifier_item_mjollnir"
end

function item_mjollnir_lua1:OnSpellStart()
	local target = self:GetCursorTarget()
		if self:GetCaster():GetTeamNumber() == self:GetCursorTarget():GetTeam() and not target:IsBuilding() == true then 
			target:AddNewModifier(self:GetCaster(), self, "modifier_item_mjollnir_active", {duration = 15})
			self:GetParent():EmitSound("DOTA_Item.Mjollnir.Activate")
		end
end

-------------------------------------------------------------------------------------
modifier_item_mjollnir_active = class({})

function modifier_item_mjollnir_active:GetTexture()
	return item_mjollnir
end

function modifier_item_mjollnir_active:OnCreated()
	self.shield_particle = ParticleManager:CreateParticle("particles/items2_fx/mjollnir_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:AddParticle(self.shield_particle, false, false, -1, false, false)

	self.static_chance	 	= self:GetAbility():GetSpecialValueFor("static_chance")
	self.static_strikes	 	= self:GetAbility():GetSpecialValueFor("static_strikes")
	self.static_damage	 	= self:GetAbility():GetSpecialValueFor("static_damage")
	self.static_radius		= self:GetAbility():GetSpecialValueFor("static_radius")
	self.static_cooldown	= self:GetAbility():GetSpecialValueFor("static_cooldown")

	self.prock = true
end

function modifier_item_mjollnir_active:DeclareFunctions()
	return{
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
end

function modifier_item_mjollnir_active:OnIntervalThink()
	self.prock = true
	self:StartIntervalThink(-1)
end

function modifier_item_mjollnir_active:OnTakeDamage(keys)
	-- "Can only proc on damage instances of 5 or greater (after reductions)."
	if keys.unit == self:GetParent() and keys.attacker ~= self:GetParent() and self.prock == true and keys.damage >= 5 and RandomInt(1,5) == 5 then
		self:GetParent():EmitSound("Item.Maelstrom.Chain_Lightning.Jump")
		if (keys.attacker:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() <= self.static_radius and not keys.attacker:IsBuilding() and not keys.attacker:IsOther() and keys.attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
			local static_particle	= nil
			static_particle = ParticleManager:CreateParticle("particles/items_fx/chain_lightning.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.unit)
			ParticleManager:SetParticleControlEnt(static_particle, 0, keys.attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.attacker:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(static_particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(static_particle)
			
			ApplyDamage({
				victim 			= keys.attacker,
				damage 			= self.static_damage,
				damage_type		= DAMAGE_TYPE_MAGICAL,
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= self:GetCaster(),
				ability 		= self:GetAbility()
			})	
		end
		
		local unit_count = 0
		
		for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.static_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)) do
			if enemy ~= keys.attacker then
				static_particle = ParticleManager:CreateParticle("particles/items_fx/chain_lightning.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
				ParticleManager:SetParticleControlEnt(static_particle, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(static_particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(static_particle)
				ApplyDamage({
					victim 			= enemy,
					damage 			= self.static_damage,
					damage_type		= DAMAGE_TYPE_MAGICAL,
					damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
					attacker 		= self:GetCaster(),
					ability 		= self:GetAbility()
				})
								
				unit_count = unit_count + 1
				
				if (unit_count >= self.static_strikes and self.static_strikes > 0) then
					break
				end
			end
		end
		
		self.bStaticCooldown = true
		self:StartIntervalThink(self.static_cooldown)
	end
end

--------------------------------------------------------------------------------

modifier_item_mjollnir = class({})

function modifier_item_mjollnir:IsHidden()
	return true
end

function modifier_item_mjollnir:IsPurgable()
	return false
end

function modifier_item_mjollnir:RemoveOnDeath()	
	return false 
end

function modifier_item_mjollnir:OnCreated()
	self.bonus_damage	= self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")

	self.static_chance	 	= self:GetAbility():GetSpecialValueFor("static_chance")
	self.static_strikes	 	= self:GetAbility():GetSpecialValueFor("static_strikes")
	self.static_damage	 	= self:GetAbility():GetSpecialValueFor("static_damage")
	self.static_radius		= self:GetAbility():GetSpecialValueFor("static_radius")
	self.static_cooldown	= self:GetAbility():GetSpecialValueFor("static_cooldown")

	self:StartIntervalThink(0.2)
end

function modifier_item_mjollnir:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
end

function modifier_item_mjollnir:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_item_mjollnir:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

function modifier_item_mjollnir:OnIntervalThink()
	self.prock = true
	self:StartIntervalThink(-1)
end

function modifier_item_mjollnir:OnAttackLanded(keys)
	-- Chain Lightning Logic
	if keys.attacker == self:GetParent() and self:GetParent():IsAlive() and not self.prock and not self:GetParent():IsIllusion() and not keys.target:IsMagicImmune() and not keys.target:IsBuilding() and not keys.target:IsOther() and self:GetParent():GetTeamNumber() ~= keys.target:GetTeamNumber() and RandomInt(1, 5) == 5 then
		
		self:GetParent():EmitSound("Item.Maelstrom.Chain_Lightning")
	
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_mjollnir_strike", {
			starting_unit_entindex	= keys.target:entindex()
		})
		
		self.bChainCooldown = true
		
		self:StartIntervalThink(0.2)
	end
end

-----------------------------------------------------------------------------

modifier_item_mjollnir_strike = class({})

function modifier_item_mjollnir_strike:IsHidden()		return true end
function modifier_item_mjollnir_strike:IsPurgable()	return false end
function modifier_item_mjollnir_strike:RemoveOnDeath()	return false end

function modifier_item_mjollnir_strike:OnCreated()
	self.bonus_damage	= self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.chain_damage	= self:GetAbility():GetSpecialValueFor("chain_damage")
	self.chain_strikes	= self:GetAbility():GetSpecialValueFor("chain_strikes")
	self.chain_radius	= self:GetAbility():GetSpecialValueFor("chain_radius")
	self.chain_delay	= self:GetAbility():GetSpecialValueFor("chain_delay")

	self.starting_unit_entindex	= keys.starting_unit_entindex

	self.units_affected			= {}
	self.unit_counter			= 0
	
	self:OnIntervalThink()
	self:StartIntervalThink(self.chain_delay)
end

function modifier_item_mjollnir_strike:OnIntervalThink()
	self.zapped = false

	for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.current_unit:GetAbsOrigin(), nil, self.chain_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)) do
		if not self.units_affected[enemy] then
			enemy:EmitSound("Item.Maelstrom.Chain_Lightning.Jump")
			
			self.zap_particle = ParticleManager:CreateParticle("particles/items_fx/chain_lightning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.current_unit, self:GetCaster())
			
			if self.unit_counter == 0 then
				ParticleManager:SetParticleControlEnt(self.zap_particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
			else
				ParticleManager:SetParticleControlEnt(self.zap_particle, 0, self.current_unit, PATTACH_POINT_FOLLOW, "attach_hitloc", self.current_unit:GetAbsOrigin(), true)
			end
			
			ParticleManager:SetParticleControlEnt(self.zap_particle, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(self.zap_particle, 2, Vector(1, 1, 1))
			ParticleManager:ReleaseParticleIndex(self.zap_particle)
		
			self.unit_counter						= self.unit_counter + 1
			self.current_unit						= enemy
			self.units_affected[self.current_unit]	= true
			self.zapped								= true
			
			ApplyDamage({
				victim 			= enemy,
				damage 			= self.chain_damage,
				damage_type		= DAMAGE_TYPE_MAGICAL,
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= self:GetCaster(),
				ability 		= self:GetAbility()
			})
			
			break
		end
	end
	
	if (self.unit_counter >= self.chain_strikes and self.chain_strikes > 0) or not self.zapped then
		self:StartIntervalThink(-1)
		self:Destroy()
	end
end