modifier_aegis_buff = class({})

function modifier_aegis_buff:IsHidden() return false end
function modifier_aegis_buff:IsDebuff() return false end
function modifier_aegis_buff:IsPurgable() return false end
function modifier_aegis_buff:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_aegis_buff:GetTexture()
	return "omniknight_repel"
end

function modifier_aegis_buff:OnCreated(table)
	if IsServer() then
	     local nWingsParticleIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_guardian_angel_omni.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	     ParticleManager:SetParticleControl(nWingsParticleIndex, 0, self:GetParent():GetAbsOrigin())
	     ParticleManager:SetParticleControlEnt(nWingsParticleIndex, 5, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	     self:AddParticle(nWingsParticleIndex, false, false, -1, false, false)    

	    -- Halo particle
	    local nHaloParticleIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_guardian_angel_halo_buff.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	    ParticleManager:SetParticleControlEnt(nHaloParticleIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)    
	    self:AddParticle(nHaloParticleIndex, false, false, -1, false, false)

	    self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_aegis_buff_invul", {duration = 1.25})
	end

	self.damage_in = -65
	self.damage_out = 100
end

function modifier_aegis_buff:DeclareFunctions()
  local funcs = {
       MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
       MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
  }

  return funcs
end


function modifier_aegis_buff:GetModifierIncomingDamage_Percentage()
     return self.damage_in or 0
end

function modifier_aegis_buff:GetModifierTotalDamageOutgoing_Percentage()
     return self.damage_out or 0
end
