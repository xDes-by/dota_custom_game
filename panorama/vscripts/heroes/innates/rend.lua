innate_rend = class({})

LinkLuaModifier("modifier_innate_rend", "heroes/innates/rend", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_innate_rend_tear", "heroes/innates/rend", LUA_MODIFIER_MOTION_NONE)

function innate_rend:GetIntrinsicModifierName()
	return "modifier_innate_rend"
end


modifier_innate_rend = class({})

function modifier_innate_rend:IsHidden() return true end
function modifier_innate_rend:IsDebuff() return false end
function modifier_innate_rend:IsPurgable() return false end
function modifier_innate_rend:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_rend:DeclareFunctions()
	if IsServer() then return { MODIFIER_PROPERTY_PROCATTACK_FEEDBACK } end
end

function modifier_innate_rend:OnCreated()
	if IsClient() then return end

	self:GetParent():SetRangedProjectileName("particles/items_fx/desolator_projectile.vpcf")
	--TODO make particle not red
end

function modifier_innate_rend:GetModifierProcAttack_Feedback(keys)
	if keys.target:GetTeamNumber() == keys.attacker:GetTeamNumber() then return end

	keys.target:EmitSound("Item_Desolator.Target")
	
	local modifier_rend = keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_innate_rend_tear", {})
	if modifier_rend and not modifier_rend:IsNull() then modifier_rend:IncrementStackCount() end
end



modifier_innate_rend_tear = class({})

function modifier_innate_rend_tear:IsHidden() return false end
function modifier_innate_rend_tear:IsDebuff() return true end
function modifier_innate_rend_tear:IsPurgable() return false end
function modifier_innate_rend_tear:GetTexture() return "innates/innate_rend" end

function modifier_innate_rend_tear:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end

function modifier_innate_rend_tear:OnCreated()
	self.armor_tear = (-1) * self:GetAbility():GetSpecialValueFor("armor_tear")

	if IsClient() then return end

	self.rend_pfx = ParticleManager:CreateParticle("particles/custom/innates/rend_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(self.rend_pfx, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false)
	ParticleManager:SetParticleControl(self.rend_pfx, 2, Vector(1,0,0))
end

function modifier_innate_rend_tear:OnStackCountChanged()
	if self.rend_pfx then
		ParticleManager:SetParticleControl(self.rend_pfx, 2, Vector(self:GetStackCount(), 0, 0))
	end
end

function modifier_innate_rend_tear:OnDestroy()
	if self.rend_pfx then
		ParticleManager:DestroyParticle(self.rend_pfx, false)
		ParticleManager:ReleaseParticleIndex(self.rend_pfx)
	end
end

function modifier_innate_rend_tear:GetModifierPhysicalArmorBonus()
	return self.armor_tear * self:GetStackCount()
end

function modifier_innate_rend_tear:OnRoundEndForTeam(keys)
	self:OnPvpEndedForDuelists(keys)
end

function modifier_innate_rend_tear:OnPvpEndedForDuelists(keys)
	if IsClient() then return end

	self:Destroy()
end
