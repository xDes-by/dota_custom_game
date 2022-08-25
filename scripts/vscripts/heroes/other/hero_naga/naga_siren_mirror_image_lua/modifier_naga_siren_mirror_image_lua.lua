modifier_naga_siren_mirror_image_lua = class({})

function modifier_naga_siren_mirror_image_lua:IsHidden()
	return true
end

function modifier_naga_siren_mirror_image_lua:IsDebuff()
	return false
end

function modifier_naga_siren_mirror_image_lua:IsStunDebuff()
	return false
end

function modifier_naga_siren_mirror_image_lua:IsPurgable()
	return false
end

function modifier_naga_siren_mirror_image_lua:OnCreated( kv )
	self.count = self:GetAbility():GetSpecialValueFor( "images_count" )
	self.duration = self:GetAbility():GetSpecialValueFor( "illusion_duration" )
	self.outgoing = self:GetAbility():GetSpecialValueFor( "outgoing_damage" )
	self.incoming = self:GetAbility():GetSpecialValueFor( "incoming_damage" )
	self.distance = 72

	if not IsServer() then return end
end

function modifier_naga_siren_mirror_image_lua:OnRefresh( kv )	
end

function modifier_naga_siren_mirror_image_lua:OnRemoved()
end

function modifier_naga_siren_mirror_image_lua:OnDestroy()
	if not IsServer() then return end

	for illusion,_ in pairs(self:GetAbility().illusions) do
		if not illusion:IsNull() then
			-- kill previous illusion
			--illusion:ForceKill( false )
				UTIL_Remove(illusion)
		end

		-- unregister
		self:GetAbility().illusions[ illusion ]	= nil	
	end
	
	if self:GetCaster():FindAbilityByName("special_bonus_unique_naga_custom3"):IsTrained() then 
	self.count = self.count + 1
	end

	local illusions = CreateIllusions(
		self:GetParent(), -- hOwner
		self:GetParent(), -- hHeroToCopy
		{
			outgoing_damage = self.outgoing,
			incoming_damage = self.incoming,
			duration = self.duration,
		}, -- hModiiferKeys
		self.count, -- nNumIllusions
		self.distance, -- nPadding
		true, -- bScramblePosition
		true -- bFindClearSpace
	)

	for _,illusion in pairs(illusions) do
		self:GetAbility().illusions[ illusion ] = true
	end
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_naga_siren_mirror_image_lua:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Helper
function modifier_naga_siren_mirror_image_lua:CreateIllusion()
	self:GetAbility().illusions = {}


end

function modifier_naga_siren_mirror_image_lua:SummonIllusion()

end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_naga_siren_mirror_image_lua:GetEffectName()
	return "particles/units/heroes/hero_siren/naga_siren_mirror_image.vpcf"
end

function modifier_naga_siren_mirror_image_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end