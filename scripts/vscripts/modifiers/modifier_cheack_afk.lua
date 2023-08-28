modifier_cheack_afk = class({})

function modifier_cheack_afk:IsHidden()
	return true
end

function modifier_cheack_afk:IsPurgeException()
	return false
end	

function modifier_cheack_afk:IsPurgable()
	return false
end

function modifier_cheack_afk:RemoveOnDeath()
	return false
end


function modifier_cheack_afk:OnCreated( kv )
	if not IsServer() then return end
	self.parent = self:GetParent()
	self.currentpos = self.parent:GetOrigin()
	self.MinigameStarted = false
	self.modifier = nil
	self:StartIntervalThink(0.2)
end

function modifier_cheack_afk:OnIntervalThink()
	local pos = self.parent:GetOrigin()
	local dist = (pos-self.currentpos):Length2D()
	self.currentpos = pos
	
	if dist == 0 and not self.parent:IsAttacking() then 
		if not self.timer then
			-- self.timer = Timers:CreateTimer(300, function()
			-- 	self.parent:EmitSound("Hero_Necrolyte.ReapersScythe.Cast")
			-- 	local scythe_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_necrolyte/necrolyte_scythe_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
			-- 	ParticleManager:SetParticleControlEnt(scythe_fx, 0, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
			-- 	ParticleManager:SetParticleControlEnt(scythe_fx, 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
			-- 	ParticleManager:ReleaseParticleIndex(scythe_fx)
		
			-- 	self.parent:ForceKill(false)
			-- end)
			if self.MinigameStarted then
				return
			end
			self.timer = Timers:CreateTimer(300, function()
				self.modifier = self.parent:AddNewModifier(self.parent, nil, "modifier_stunned", {})
				self.MinigameStarted = true
				--@dansoo0911:добавить чтобы экспа капала в минус и раскидать папкам в контенете из архива вити все файлы
				--это на 131 строку в minigame.js
				--но вообще можешь куда угодно, тебе виднее
				--GameEvents.SendCustomGameEventToServer( "EndMiniGame", {} );
				CustomUI:DynamicHud_Create(self.parent:GetPlayerOwnerID(), "minigame_container", "file://{resources}/layout/custom_game/minigame.xml", nil)
			end)
		end	
	else
		if self.timer then
			Timers:RemoveTimer(self.timer)
			self.timer = nil
		end
	end
end

function modifier_cheack_afk:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DIRECT_MODIFICATION
    }
    return funcs
end

function modifier_cheack_afk:GetModifierMagicalResistanceDirectModification()
	return -0.1 * self:GetParent():GetIntellect()
end
