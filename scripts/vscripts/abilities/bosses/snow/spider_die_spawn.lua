spider_die_spawn = class({})

LinkLuaModifier("modifier_spider_die_spawn", "abilities/bosses/snow/spider_die_spawn", LUA_MODIFIER_MOTION_VERTICAL)
LinkLuaModifier("modifier_spider_die_spawn_effect", "abilities/bosses/snow/spider_die_spawn", LUA_MODIFIER_MOTION_VERTICAL)

function spider_die_spawn:GetIntrinsicModifierName()
	return "modifier_spider_die_spawn"
end

------------------------------------------------------------------------------------------------------------------------------------------------------------

modifier_spider_die_spawn = class({})

function modifier_spider_die_spawn:IsHidden()
	return true
end

function modifier_spider_die_spawn:IsPurgable()
	return false
end

function modifier_spider_die_spawn:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_DEATH
	}
	return funcs
end

function modifier_spider_die_spawn:OnDeath(keys)
	if IsServer() then
		if keys.unit == self:GetParent() then
			local ice_blast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_final.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
			ParticleManager:SetParticleControl(ice_blast_particle, 0, self:GetParent():GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(ice_blast_particle)
			self:GetCaster():EmitSound("Hero_Ancient_Apparition.IceBlastRelease.Cast")		
			
			Timers:CreateTimer(1.1, function()
				
			self:GetCaster():EmitSound("Hero_Ancient_Apparition.IceBlast.Target")		
			local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, 450, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				for _, enemy in pairs(enemies) do			
					enemy:AddNewModifier(enemy, nil, "modifier_spider_die_spawn_effect", { duration = 5})
				end
			end)	
		end
	end
end

--------------------------------------------------------------------------------------

modifier_spider_die_spawn_effect = class({})				
				
function modifier_spider_die_spawn:IsHidden() return false end				
function modifier_spider_die_spawn_effect:IsDebuff() return true end
function modifier_spider_die_spawn_effect:IsPurgable() return false end

function modifier_spider_die_spawn_effect:GetEffectName()
	return "particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_debuff.vpcf"
end

function modifier_spider_die_spawn_effect:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost.vpcf"
end

function modifier_spider_die_spawn_effect:OnCreated(params)
	if not IsServer() then return end
	
	if params.caster_entindex then
		self.caster = EntIndexToHScript(params.caster_entindex)
	else
		self.caster = self:GetParent()
	end
	
	self.damage_table	= {
		victim 			= self:GetParent(),
		damage 			= 10000,
		damage_type		= DAMAGE_TYPE_MAGICAL,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self.caster,
		ability 		= self:GetAbility()
	}
	
	self:StartIntervalThink(1 - self:GetParent():GetStatusResistance())
end

function modifier_spider_die_spawn_effect:OnRefresh(params)
	self:OnCreated(params)
end

function modifier_spider_die_spawn_effect:OnIntervalThink()
	self:GetParent():EmitSound("Hero_Ancient_Apparition.IceBlastRelease.Tick")
	ApplyDamage(self.damage_table)
--	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), self.dot_damage, nil)
end

function modifier_spider_die_spawn_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_DISABLE_HEALING,
	}
end

function modifier_spider_die_spawn_effect:GetDisableHealing()
	return 1
end