

---------------------------------------------------------------------------------

modifier_bleeding = class({})


function modifier_bleeding:IsHidden()
	return false
end

function modifier_bleeding:IsDebuff()
	return true
end

function modifier_bleeding:IsStunDebuff()
	return false
end

function modifier_bleeding:IsPurgable()
	return true
end


function modifier_bleeding:OnCreated( kv )
if IsServer() then
	self.caster = self:GetCaster()
	local damage = self:GetCaster():GetStrength()/2

	damage_type = DAMAGE_TYPE_MAGICAL
	
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = damage_type,
		ability = self, --Optional.
	}

	self:StartIntervalThink( 0.5 )
	self:OnIntervalThink()
end
end

function modifier_bleeding:OnRefresh( kv )
end

function modifier_bleeding:OnRemoved()
end

function modifier_bleeding:OnDestroy()
end


function modifier_bleeding:OnIntervalThink()
	ApplyDamage( self.damageTable )
end


function modifier_bleeding:GetEffectName()
	return "particles/blood_impact/blood_advisor_pierce_spray.vpcf"
end

function modifier_bleeding:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_bleeding:GetStatusEffectName()
	return "particles/status_fx/status_effect_bloodrage.vpcf"
end