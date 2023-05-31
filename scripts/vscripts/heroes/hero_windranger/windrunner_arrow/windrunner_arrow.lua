LinkLuaModifier( "modifier_ult_armor", "heroes/hero_windranger/modifier_ult_armor", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_stop", "heroes/hero_windranger/modifier_stop", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_chek", "heroes/hero_windranger/windrunner_arrow/windrunner_arrow", LUA_MODIFIER_MOTION_NONE )

windrunner_arrow = class({})

function windrunner_arrow:GetManaCost(iLevel)
local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_windrunner_int7")             
	if abil ~= nil then 
		local ability = self:GetCaster():FindAbilityByName("windrunner_passive_lua")
			if ability:GetLevel() > 0 then
				mp_loss = ability:GetSpecialValueFor("mp_loss") * 0.01
				 return math.min(65000, self:GetCaster():GetIntellect() *1.5 - (self:GetCaster():GetIntellect() * 2 * mp_loss))
			end	
		return math.min(65000, self:GetCaster():GetIntellect() * 1.5)
	end
		local ability = self:GetCaster():FindAbilityByName("windrunner_passive_lua")
			if ability:GetLevel() > 0 then
				mp_loss = ability:GetSpecialValueFor("mp_loss") * 0.01
				 return math.min(65000, self:GetCaster():GetIntellect() * 3 - (self:GetCaster():GetIntellect() * 4 * mp_loss))
			end	
				return math.min(65000, self:GetCaster():GetIntellect() * 3)
end

function windrunner_arrow:OnSpellStart()
    self:GetSpecialValue()
    local info = {
        EffectName = "particles/econ/items/windrunner/windrunner_weapon_sparrowhawk/windrunner_spell_powershot_sparrowhawk.vpcf",
        Ability = self,
        fStartRadius = 200,
        fEndRadius = 200,
        vVelocity = self:GetDirection() * 2000,
        fDistance = 2000,
        Source = self:GetCaster(),
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    }
    windrunner_arrow.delay = self.duration
    local count = self.duration * self.duration
	EmitSoundOn("Ability.Focusfire", self:GetCaster())
    GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("windrunner_arrow_think"), function ()
        if not self:GetCaster():IsAlive() then
            return nil
        end
		
		self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_chek",{ duration = 0.2 })
		
		
		local model = self:GetCaster():GetModelName()
		if model ~= "models/heroes/windrunner/windrunner.vmdl" and model ~= "models/items/windrunner/windrunner_arcana/wr_arcana_base.vmdl" then
            return nil
        end
		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_windrunner_str6")             
		if abil ~= nil then 
		self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_ult_armor",{ duration = 0.2 })
		end
		
        info.vSpawnOrigin = self:GetCaster():GetOrigin() + RandomVector(200)
        info.fExpireTime = GameRules:GetGameTime() + 2
        ProjectileManager:CreateLinearProjectile(info)
        count = count - 1
        if count <= 0 then
            return nil
        end
        return 0.2--0.1
    end, 0)
end

function windrunner_arrow:OnProjectileHit(hTarget, vLocation)
	if hTarget ~= nil and not hTarget:IsMagicImmune() and not hTarget:IsInvulnerable() then
		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_windrunner_str7")             
		if abil ~= nil then 
		hTarget:AddNewModifier(self:GetCaster(),self,"modifier_stop",{ duration = 0.2 })
		end
		
		ApplyDamage({
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self.damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		})
	end
	return false
end

function windrunner_arrow:GetSpecialValue()
    self.duration = self:GetSpecialValueFor("duration")
    self.scale = self:GetSpecialValueFor("scale")
    self.damage = self:GetSpecialValueFor("damage")
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_windrunner_int10")             
		if abil ~= nil then 
		self.duration = 5
		end
			
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_windrunner_int9")             
		if abil ~= nil then 
		self.damage = self:GetCaster():GetIntellect()
		end
		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_windrunner_int8")             
		if abil ~= nil then 
		self.damage = self.damage + (self:GetCaster():GetIntellect()/2)
		end		
end

function windrunner_arrow:GetDirection()
    local cursor_pos = self:GetCursorPosition()
    local caster_pos = self:GetCaster():GetOrigin()
    if cursor_pos == caster_pos then
        cursor_pos = cursor_pos + RandomVector(1)
    end
	local direction = cursor_pos - caster_pos
	direction.z = 0.0
	return direction:Normalized()
end

---------------------------------------------------------------------------------------------
modifier_chek = class({})

function modifier_chek:IsHidden()
	return true
end