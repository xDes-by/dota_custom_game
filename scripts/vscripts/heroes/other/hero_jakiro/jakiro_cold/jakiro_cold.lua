LinkLuaModifier("modifier_imba_winter_wyvern_cold_embrace", "heroes/hero_jakiro/jakiro_cold/jakiro_cold.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_winter_wyvern_cold_embrace_freeze", "heroes/hero_jakiro/jakiro_cold/jakiro_cold.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_winter_wyvern_cold_embrace_resistance", "heroes/hero_jakiro/jakiro_cold/jakiro_cold.lua", LUA_MODIFIER_MOTION_NONE)
jakiro_cold = class({})

function jakiro_cold:GetCooldown(nLevel)
	return self.BaseClass.GetCooldown( self, nLevel )
end

function jakiro_cold:OnSpellStart()
	if IsServer() then 	
		local caster = self:GetCaster();
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
		if #enemies == 0 then
		
			caster:EmitSound("Hero_Winter_Wyvern.ColdEmbrace.Cast");

			if RandomInt(1,100) > 80 then 
				caster:EmitSound("winter_wyvern_winwyv_coldembrace_0"..RandomInt(1, 5));
			end
			local cold_embrace_start_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_winter_wyvern/wyvern_cold_embrace_start.vpcf", PATTACH_POINT, caster);
			ParticleManager:SetParticleControl(cold_embrace_start_particle, 0, caster:GetAbsOrigin());
			ParticleManager:SetParticleControl(cold_embrace_start_particle, 1, caster:GetAbsOrigin());
			ParticleManager:ReleaseParticleIndex(cold_embrace_start_particle);
		end
		
		  for _, hEnemy in pairs( enemies ) do
			local ability 					= self;
			local duration 					= self:GetSpecialValueFor("duration");
			
			if self:GetCaster():FindAbilityByName("special_bonus_unique_jakiro_custom"):IsTrained() then 
			duration = duration + 1
			end
						
			local damage_treshold_pct_hp 	= self:GetSpecialValueFor("damage_treshold_pct_hp");
			local freeze_duration 			= self:GetSpecialValueFor("duration");


			caster:EmitSound("Hero_Winter_Wyvern.ColdEmbrace.Cast");

			if RandomInt(1,100) > 80 then 
				caster:EmitSound("winter_wyvern_winwyv_coldembrace_0"..RandomInt(1, 5));
			end

			
			local cold_embrace_start_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_winter_wyvern/wyvern_cold_embrace_start.vpcf", PATTACH_POINT, caster);
			ParticleManager:SetParticleControl(cold_embrace_start_particle, 0, caster:GetAbsOrigin());
			ParticleManager:SetParticleControl(cold_embrace_start_particle, 1, caster:GetAbsOrigin());
			ParticleManager:ReleaseParticleIndex(cold_embrace_start_particle);

			hEnemy:AddNewModifier(caster, ability, "modifier_winter_wyvern_cold_embrace", {duration = duration});
			hEnemy:AddNewModifier(caster, ability, "modifier_imba_winter_wyvern_cold_embrace_freeze", {duration = duration});
			hEnemy:AddNewModifier(caster, ability, "modifier_imba_winter_wyvern_cold_embrace_resistance", {duration = duration});
			hEnemy:AddNewModifier(caster, ability, "modifier_imba_winter_wyvern_cold_embrace", {duration = duration, damage_treshold_pct_hp = damage_treshold_pct_hp, freeze_duration = freeze_duration});
		end
	end
end

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

modifier_imba_winter_wyvern_cold_embrace = class({})
function modifier_imba_winter_wyvern_cold_embrace:IsHidden() return true end
function modifier_imba_winter_wyvern_cold_embrace:IsPurgable() return false end
function modifier_imba_winter_wyvern_cold_embrace:IsDebuff() return false end
function modifier_imba_winter_wyvern_cold_embrace:DeclareFunctions() 
	decFuncs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return decFuncs
end

function modifier_imba_winter_wyvern_cold_embrace:OnAttackLanded(keys) 
	if IsServer() then 
		local parent = self:GetParent();
		if keys.target == parent and not keys.attacker:IsTower() then
			self.damage_taken = self.damage_taken + keys.damage;
			
			if self.damage_taken >= self.damage_treshold and not self.activated then
					
					if not keys.attacker:IsMagicImmune() then
					--	keys.attacker:AddNewModifier(parent, nil, "modifier_imba_winter_wyvern_cold_embrace_freeze", {duration = self.freeze_duration * (1 - keys.attacker:GetStatusResistance())});
					end
				
					local curse_blast = ParticleManager:CreateParticle("particles/units/heroes/hero_winter_wyvern/wyvern_winters_curse_blast.vpcf", PATTACH_ABSORIGIN, parent);
					ParticleManager:SetParticleControl(curse_blast, 2, Vector(1,1,1000));
					ParticleManager:ReleaseParticleIndex(curse_blast);
						
					self.damage_taken = 0

					self.activated = true
			end
		end
	end
end

function modifier_imba_winter_wyvern_cold_embrace:OnCreated(keys)
	if IsServer() then 
		self.triggered 			= false;
		self.damage_taken 		= 0;
		self.freeze_duration 	= keys.freeze_duration;
		self.damage_treshold 	= (self:GetCaster():GetMaxHealth() / 100) * keys.damage_treshold_pct_hp;
	end
end

function modifier_imba_winter_wyvern_cold_embrace:OnRefreshed(keys)
	if IsServer() then 
		self.triggered 			= false;
		self.damage_taken 		= 0;
		self.freeze_duration 	= keys.freeze_duration;
		self.damage_treshold 	= (self:GetCaster():GetMaxHealth() / 100) * keys.damage_treshold_pct_hp;
	end
end

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

modifier_imba_winter_wyvern_cold_embrace_resistance = class({})

function modifier_imba_winter_wyvern_cold_embrace_resistance:IsHidden()
return true
end

function modifier_imba_winter_wyvern_cold_embrace_resistance:IsDebuff()
	return true
end

function modifier_imba_winter_wyvern_cold_embrace_resistance:IsStunDebuff()
	return false
end

function modifier_imba_winter_wyvern_cold_embrace_resistance:IsPurgable()
	return false
end

function modifier_imba_winter_wyvern_cold_embrace_resistance:OnCreated(keys)
	self.magic_resist = self:GetAbility():GetSpecialValueFor( "resist" )
end

function modifier_imba_winter_wyvern_cold_embrace_resistance:OnRefreshed(keys)
	self.magic_resist = self:GetAbility():GetSpecialValueFor( "resist" )
end

function modifier_imba_winter_wyvern_cold_embrace_resistance:DeclareFunctions() 
	decFuncs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}

	return decFuncs
end

function modifier_imba_winter_wyvern_cold_embrace_resistance:GetModifierMagicalResistanceBonus()
	return self.magic_resist
end


modifier_imba_winter_wyvern_cold_embrace_freeze = class({})
function modifier_imba_winter_wyvern_cold_embrace_freeze:IsDebuff() return true end
function modifier_imba_winter_wyvern_cold_embrace_freeze:IsPurgable() return false end
function modifier_imba_winter_wyvern_cold_embrace_freeze:IsHidden() return false end
function modifier_imba_winter_wyvern_cold_embrace_freeze:CheckState()
	return {
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}
end

function modifier_imba_winter_wyvern_cold_embrace_freeze:OnCreated()
	EmitSoundOn("Hero_Ancient_Apparition.ColdFeetCast", self:GetParent())
end

function modifier_imba_winter_wyvern_cold_embrace_freeze:GetEffectName()
	return "particles/units/heroes/hero_ancient_apparition/ancient_apparition_cold_feet_frozen.vpcf"
end

function modifier_imba_winter_wyvern_cold_embrace_freeze:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
