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
<<<<<<< HEAD
	self.MinigameStarted = false
	if IsInToolsMode() or GameRules:IsCheatMode() then
		return
	end
=======
>>>>>>> main
	self:StartIntervalThink(0.2)
end

function modifier_cheack_afk:OnIntervalThink()
	if self.MinigameStarted then
		return
	end
	if not self.parent:IsAlive() then
		if self.parent:GetTimeUntilRespawn() > 11 then
			hero:SetTimeUntilRespawn(10)
		end
	end
	if not self.MinigameStarted and _G.kill_invoker then
		if self.timer then
			Timers:RemoveTimer(self.timer)
			self.timer = nil
		end
		return
	end
	local pos = self.parent:GetOrigin()
	local dist = (pos-self.currentpos):Length2D()
	self.currentpos = pos
	
	if dist == 0 and not self.parent:IsAttacking() and not self.parent:IsChanneling() then 
		if not self.timer then
			self.timer = Timers:CreateTimer(300, function()
<<<<<<< HEAD
				self.modifier1 = self.parent:AddNewModifier(self.parent, nil, "modifier_invulnerable", {})
				self.modifier2 = self.parent:AddNewModifier(self.parent, nil, "modifier_stunned", {})
				self.MinigameStarted = true
				ListenToGameEvent("player_reconnected", Dynamic_Wrap(self, 'OnPlayerReconnected'), self)
				CustomUI:DynamicHud_Create(self.parent:GetPlayerOwnerID(), "minigame_container", "file://{resources}/layout/custom_game/minigame/minigame.xml", nil)
				Talents:EnableAFKGame(self:GetParent():GetPlayerID())
=======
				print("say hello bitch")
				self.parent:EmitSound("Hero_Necrolyte.ReapersScythe.Cast")
				local scythe_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_necrolyte/necrolyte_scythe_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
				ParticleManager:SetParticleControlEnt(scythe_fx, 0, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(scythe_fx, 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(scythe_fx)
		
				self.parent:ForceKill(false)
>>>>>>> main
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
    return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DIRECT_MODIFICATION,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
    }
end

function modifier_cheack_afk:GetModifierMagicalResistanceDirectModification()
	return -0.1 * self:GetParent():GetIntellect()
end

function modifier_cheack_afk:GetModifierConstantManaRegen()
	return -0.049 * self:GetParent():GetIntellect()
end

function modifier_cheack_afk:OnPlayerReconnected(data)
	if data.PlayerID == self.parent:GetPlayerOwnerID() then
		CustomUI:DynamicHud_Create(self.parent:GetPlayerOwnerID(), "minigame_container", "file://{resources}/layout/custom_game/minigame.xml", nil)
	end
end