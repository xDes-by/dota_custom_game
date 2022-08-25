treant_ult=class({})

LinkLuaModifier("modifier_treant_ult", "heroes/hero_treant/treant_skill_ult/treant_ult", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_treant_ult_pw", "heroes/hero_treant/treant_skill_ult/treant_ult", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_treant_poison", "heroes/hero_treant/treant_skill_ult/treant_ult", LUA_MODIFIER_MOTION_NONE)

function treant_ult:GetManaCost(iLevel)
	return self:GetCaster():GetIntellect()*3
end

function treant_ult:GetCooldown(level)
local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_treant_int10")	
		if abil ~= nil then 
	return self.BaseClass.GetCooldown(self, level) - 60
	end
	return self.BaseClass.GetCooldown(self, level)
end

function treant_ult:OnSpellStart()
		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_treant_int9")	
		if abil ~= nil then 
		if RandomInt(1,100) < 10 then
		self:EndCooldown()
		end
		end
		
    local caster = self:GetCaster()
	local front = self:GetCaster():GetForwardVector():Normalized()
	local pos = self:GetCaster():GetOrigin() + front * 100
   -- local pos = self:GetForwardVector() +100
    local duration = self:GetSpecialValueFor("duration") 
    EmitSoundOn( "Hero_Dark_Seer.Wall_of_Replica_Start", caster )
    self.base_dam = self:GetSpecialValueFor("base_dam")	
	
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_treant_agi10")	
		if abil ~= nil then 
		 self.base_dam =  self.base_dam + self:GetCaster():GetAgility()
		end

		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_treant_int_last")	
		if abil ~= nil then 
		 self.base_dam =  self.base_dam + self:GetCaster():GetIntellect()
		end
	
    self.damageTable = {
		attacker = caster,
		damage_type = DAMAGE_TYPE_MAGICAL,
		damage_flags = DOTA_UNIT_TARGET_FLAG_NONE, 
		ability = self,
		}
    CreateModifierThinker(caster, self, "modifier_treant_ult", {duration = duration}, pos, caster:GetTeamNumber(), false)
    CreateModifierThinker(caster, self, "modifier_treant_ult_pw", {duration = duration}, pos, caster:GetTeamNumber(), false)
end

function treant_ult:OnProjectileHit_ExtraData(target, location, kv)
    if target==nil then
        return 
    end
    local caster = self:GetCaster()
    if not target:IsMagicImmune()  then 
        self.damageTable.victim = target		
        self.damageTable.damage = self.base_dam
        ApplyDamage(self.damageTable)
    end
end

modifier_treant_ult= class({})

function modifier_treant_ult:IsHidden() 			
    return true 
end

function modifier_treant_ult:IsPurgable() 			
    return false 
end


function modifier_treant_ult:OnCreated() 
    
    
    self.caster = self:GetCaster()
    self.rg=self:GetAbility():GetSpecialValueFor("rg")/2
    self.wh=self:GetAbility():GetSpecialValueFor("wh")-50
    if IsServer() then 
        self.pos=self:GetParent():GetAbsOrigin()
        self.team=self.caster:GetTeam()
        self.start_pos=self.pos+self.caster:GetRightVector()*self.rg
        self.end_pos=self.pos+self.caster:GetRightVector()*-self.rg
        local P = ParticleManager:CreateParticle("particles/units/heroes/hero_dark_seer/dark_seer_wall_of_replica.vpcf", PATTACH_WORLDORIGIN,nil)
        ParticleManager:SetParticleControl(P,0,self.start_pos)
        ParticleManager:SetParticleControl(P,1,self.end_pos)
        ParticleManager:SetParticleControl(P,2,Vector(1,1,0))
        ParticleManager:SetParticleControl(P,60,Vector(255,206,120))
        ParticleManager:SetParticleControl(P,61,Vector(1,0,0))
        self:AddParticle( P, false, false, -1, false, false )   
        self:OnIntervalThink()
        self:StartIntervalThink(FrameTime())
    end
end

function modifier_treant_ult:OnIntervalThink()
    local enemies = FindUnitsInLine(self.team,  self.start_pos, self.end_pos, self.caster, self.wh, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE)
    if #enemies>0 then 
    for _,tar in pairs(enemies) do
            if not tar:IsMagicImmune() then 
				local front = tar:GetForwardVector():Normalized()
				local pos = tar:GetOrigin() - front * 15
					tar:SetAbsOrigin( pos)
					if not tar:HasModifier("modifier_treant_poison") then 
					tar:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_treant_poison",{duration = 1})
				end
            end 
        end
    end  
end

function GetDirection2D(endpos, startpos)
	local dir = (endpos - startpos):Normalized()
	dir.z = 0
	return dir
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

modifier_treant_poison = class({})

function modifier_treant_poison:IsHidden() 			
    return false 
end

function modifier_treant_poison:IsPurgable() 			
    return false 
end

function modifier_treant_poison:OnCreated() 
local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_treant_int7")	
		if abil ~= nil then 
		self.base_dam = self:GetAbility():GetSpecialValueFor("base_dam")/2 
		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_treant_agi10")	
		if abil ~= nil then 
		 self.base_dam =  self.base_dam + self:GetCaster():GetAgility()
		end
		
		ApplyDamage({
				victim = self:GetParent(),
				attacker = self:GetCaster(),
				damage = self.base_dam,
				damage_type = DAMAGE_TYPE_MAGICAL,
				damage_flags = DOTA_UNIT_TARGET_FLAG_NONE
			})
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

modifier_treant_ult_pw=class({})

function modifier_treant_ult_pw:IsHidden() 			
    return true 
end

function modifier_treant_ult_pw:IsPurgable() 			
    return false 
end



function modifier_treant_ult_pw:OnCreated() 
    
    
    self.caster=self:GetCaster()
    self.interval = self:GetAbility():GetSpecialValueFor("interval")
    self.dis=self:GetAbility():GetSpecialValueFor("dis")
    self.wh2=self:GetAbility():GetSpecialValueFor("wh2")
    if IsServer() then 
	
local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_treant_int11")	
	if abil ~= nil then 
	self.interval = 0.5
end		
	
        self.pos=self:GetParent():GetAbsOrigin()
        self.dir=GetDirection2D( self.pos, self.caster:GetAbsOrigin())
        self.team=self.caster:GetTeam()  
        self:StartIntervalThink(self.interval)
    end
end

function modifier_treant_ult_pw:OnIntervalThink()
    EmitSoundOn( "Ability.Powershot", self:GetParent() )
    local projectileTable =
	{
		EffectName ="particles/tgp/photon_wall/photon_wall_m.vpcf",
		Ability = self:GetAbility(),
		vSpawnOrigin =self.pos,
		vVelocity =self.dir*1000,
		fDistance =self.dis,
		fStartRadius = self.wh2,
		fEndRadius = self.wh2,
		Source = self.caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		fExpireTime = GameRules:GetGameTime() + 10.0,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		bProvidesVision = false,
	}
	ProjectileManager:CreateLinearProjectile( projectileTable )  
end