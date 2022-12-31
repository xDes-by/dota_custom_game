modifier_chc_mastery_revenge = class({})

function modifier_chc_mastery_revenge:IsHidden() return true end
function modifier_chc_mastery_revenge:IsDebuff() return false end
function modifier_chc_mastery_revenge:IsPurgable() return false end
function modifier_chc_mastery_revenge:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_chc_mastery_revenge:GetTexture() return "masteries/revenge" end



modifier_chc_mastery_revenge_1 = class(modifier_chc_mastery_revenge)
modifier_chc_mastery_revenge_2 = class(modifier_chc_mastery_revenge)
modifier_chc_mastery_revenge_3 = class(modifier_chc_mastery_revenge)



function modifier_chc_mastery_revenge_1:Revengesplosion()
	if IsClient() then return end

	local parent = self:GetParent()
	local spawns = FindUnitsInRadius(parent:GetTeam(), parent:GetAbsOrigin(), nil, 2900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	for _, creep in pairs(spawns) do
		creep:EmitSound("Revenge.Explosion")

		local explosion_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_suicide.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(explosion_pfx, 0, creep:GetAbsOrigin())
		ParticleManager:SetParticleControl(explosion_pfx, 1, Vector(100, 0, 0))
		ParticleManager:SetParticleControl(explosion_pfx, 2, creep:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(explosion_pfx)

		ApplyDamage({
			victim = creep,
			attacker = parent,
			damage = creep:GetMaxHealth() * 100,
			damage_type = DAMAGE_TYPE_PURE,
			damage_flags = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS
		})
	end
end




function modifier_chc_mastery_revenge_2:IsHidden() return self:GetStackCount() == 0 end

function modifier_chc_mastery_revenge_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
	}
end


function modifier_chc_mastery_revenge_2:GetModifierIncomingDamage_Percentage()
	return (-5) * self:GetStackCount()
end

function modifier_chc_mastery_revenge_2:GetModifierTotalDamageOutgoing_Percentage()
	return 5 * self:GetStackCount()
end




function modifier_chc_mastery_revenge_3:OnCreated()
	if IsClient() then return end
	local parent = self:GetParent()
	if parent and parent.hasAegisByRevengeMastery then return end

	parent.hasAegisByRevengeMastery = true

	local modifier_aegis = parent:FindModifierByName("modifier_aegis")
	if modifier_aegis then 
		modifier_aegis:IncrementStackCount() 
	else
		parent:AddNewModifier(parent, nil, "modifier_aegis", {}):SetStackCount(1)
	end
end
