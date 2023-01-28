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
	self:StartIntervalThink(0.2)
end

function modifier_cheack_afk:OnIntervalThink()
	local pos = self.parent:GetOrigin()
	local dist = (pos-self.currentpos):Length2D()
	self.currentpos = pos
	
	if dist == 0 and not self.parent:IsAttacking() then 
		if not self.timer then
			self.timer = Timers:CreateTimer(300, function()
				print("say hello bitch")
				self.parent:EmitSound("Hero_Necrolyte.ReapersScythe.Cast")
				local scythe_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_necrolyte/necrolyte_scythe_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
				ParticleManager:SetParticleControlEnt(scythe_fx, 0, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(scythe_fx, 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(scythe_fx)
		
				self.parent:ForceKill(false)
			end)
		end	
	else
		if self.timer then
			Timers:RemoveTimer(self.timer)
			self.timer = nil
		end
	end
end