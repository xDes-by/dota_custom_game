modifier_chc_mastery_ascension = class({})

function modifier_chc_mastery_ascension:IsHidden() return true end
function modifier_chc_mastery_ascension:IsDebuff() return false end
function modifier_chc_mastery_ascension:IsPurgable() return false end
function modifier_chc_mastery_ascension:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_chc_mastery_ascension:GetTexture() return "masteries/ascension" end

function modifier_chc_mastery_ascension:OnRoundEndForTeam(keys)
	if IsClient() then return end

	local parent = self:GetParent()

	if (not parent) or parent:IsNull() or (not keys.is_boss) then return end

	local levels = self.bonus_levels

	Timers:CreateTimer(1, function()
		parent:HeroLevelUp(true)

		local pfx = ParticleManager:CreateParticle("particles/custom/bonus_levelup_light.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
		ParticleManager:SetParticleControl(pfx, 0, parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 15, Vector(255, 255, 255))
		ParticleManager:ReleaseParticleIndex(pfx)

		levels = levels - 1
		if levels > 0 then
			return 1
		end
	end)
end



modifier_chc_mastery_ascension_1 = class(modifier_chc_mastery_ascension)
modifier_chc_mastery_ascension_2 = class(modifier_chc_mastery_ascension)
modifier_chc_mastery_ascension_3 = class(modifier_chc_mastery_ascension)

function modifier_chc_mastery_ascension_1:OnCreated(keys)
	self.bonus_levels = 1
end

function modifier_chc_mastery_ascension_2:OnCreated(keys)
	self.bonus_levels = 2
end

function modifier_chc_mastery_ascension_3:OnCreated(keys)
	self.bonus_levels = 3
end
