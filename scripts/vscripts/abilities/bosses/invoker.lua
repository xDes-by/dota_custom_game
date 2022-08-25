invoker_spfere = class({})

LinkLuaModifier( "modifier_invoker_spfere", "abilities/bosses/invoker.lua", LUA_MODIFIER_MOTION_NONE )

function invoker_spfere:GetIntrinsicModifierName()
    return "modifier_invoker_spfere"
end

modifier_invoker_spfere = class({})

function modifier_invoker_spfere:IsHidden()
    return true
end

function modifier_invoker_spfere:RemoveOnDeath()
    return false
end

function modifier_invoker_spfere:OnCreated()
    self.spfere = {}
    self.spfere[1] = "particles/econ/items/invoker_kid/invoker_dark_artistry/invoker_kid_dark_artistry_wex_orb.vpcf" 
    self.spfere[2] = "particles/econ/items/invoker_kid/invoker_dark_artistry/invoker_kid_dark_artistry_quas_orb.vpcf" 
    self.spfere[3] = "particles/econ/items/invoker_kid/invoker_dark_artistry/invoker_kid_dark_artistry_exort_orb.vpcf"
    if self.invoked_orbs_particle_attach == nil then
        self.invoked_orbs_particle_attach = {}
        self.invoked_orbs_particle_attach[1] = "attach_orb1"
        self.invoked_orbs_particle_attach[2] = "attach_orb2"
        self.invoked_orbs_particle_attach[3] = "attach_orb3"
    end
    if self.invoked_orbs_particle == nil then
        self.invoked_orbs_particle = {}
    end
end

function modifier_invoker_spfere:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ABILITY_START  
    }
end

function modifier_invoker_spfere:OnAbilityStart(data)
    if self:GetCaster() ~= data.unit then return end

    if self.invoked_orbs_particle[1] ~= nil then
        ParticleManager:DestroyParticle(self.invoked_orbs_particle[1], false)
		self.invoked_orbs_particle[1] = nil
    end

    
    self.invoked_orbs_particle[1] = self.invoked_orbs_particle[2]
    self.invoked_orbs_particle[2] = self.invoked_orbs_particle[3]
    self.invoked_orbs_particle[3] = ParticleManager:CreateParticle(self.spfere[RandomInt(1,3)], PATTACH_OVERHEAD_FOLLOW, self:GetCaster())
    ParticleManager:SetParticleControlEnt(self.invoked_orbs_particle[3], 1, self:GetCaster(), PATTACH_POINT_FOLLOW , self.invoked_orbs_particle_attach[1], self:GetCaster():GetAbsOrigin(), false)

    local temp_attachment_point = self.invoked_orbs_particle_attach[1]
    self.invoked_orbs_particle_attach[1] = self.invoked_orbs_particle_attach[2]
    self.invoked_orbs_particle_attach[2] = self.invoked_orbs_particle_attach[3]
    self.invoked_orbs_particle_attach[3] = temp_attachment_point

	--if caster.bPersona then
	--	quas_attack = "particles/units/heroes/hero_invoker_kid/invoker_kid_base_attack_quas.vpcf"
	--	wex_attack = "particles/units/heroes/hero_invoker_kid/invoker_kid_base_attack_wex.vpcf"
	--	exort_attack = "particles/units/heroes/hero_invoker_kid/invoker_kid_base_attack_exort.vpcf"
	--	all_attack = "particles/units/heroes/hero_invoker_kid/invoker_kid_base_attack_all.vpcf"
	--end

	--if quas >= 2 then
	--	caster:SetRangedProjectileName(quas_attack)
	--elseif wex >= 2 then
	--	caster:SetRangedProjectileName(wex_attack)
	--elseif exort >= 2 then
	--	caster:SetRangedProjectileName(exort_attack)
	--elseif quas == 1 and wex == 1 and exort == 1 then
	--	caster:SetRangedProjectileName(all_attack)
	--end
end




        




