modifier_chc_mastery_cleave = class({})

function modifier_chc_mastery_cleave:IsHidden() return true end
function modifier_chc_mastery_cleave:IsDebuff() return false end
function modifier_chc_mastery_cleave:IsPurgable() return false end
function modifier_chc_mastery_cleave:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_chc_mastery_cleave:GetTexture() return "masteries/cleave" end

function modifier_chc_mastery_cleave:DeclareFunctions()
	if IsServer() then return {	MODIFIER_PROPERTY_PROCATTACK_FEEDBACK } end
end

function modifier_chc_mastery_cleave:GetModifierProcAttack_Feedback(keys)
	if keys.attacker and keys.target and not (keys.attacker:IsNull() or keys.target:IsNull() or keys.target:IsBuilding()) and keys.attacker:GetTeam() ~= keys.target:GetTeam() and keys.damage > 0 then 

		-- Special handling for Fury Swipes
		local fury_swipes_damage = 0
		if keys.attacker:HasAbility("ursa_fury_swipes") and keys.target:HasModifier("modifier_ursa_fury_swipes_damage_increase") then
			local fury_swipes_ability = keys.attacker:FindAbilityByName("ursa_fury_swipes")
			if fury_swipes_ability and (not fury_swipes_ability:IsNull()) then
				local stacks = keys.target:GetModifierStackCount("modifier_ursa_fury_swipes_damage_increase", keys.attacker)
				fury_swipes_damage = stacks * fury_swipes_ability:GetSpecialValueFor("damage_per_stack")
			end
		end

		local splash_damage = (keys.original_damage + fury_swipes_damage) * (self.splash or 0)
		local target_loc = keys.target:GetAbsOrigin()

		local blast_pfx = ParticleManager:CreateParticle("particles/custom/shrapnel.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(blast_pfx, 0, target_loc)
		ParticleManager:ReleaseParticleIndex(blast_pfx)

		local enemies = FindUnitsInRadius(keys.attacker:GetTeam(), target_loc, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			if enemy ~= keys.target then
				ApplyDamage({victim	= enemy, attacker = keys.attacker, damage = splash_damage, damage_type = DAMAGE_TYPE_PHYSICAL, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL})
			end
		end
	end
end



modifier_chc_mastery_cleave_1 = class(modifier_chc_mastery_cleave)
modifier_chc_mastery_cleave_2 = class(modifier_chc_mastery_cleave)
modifier_chc_mastery_cleave_3 = class(modifier_chc_mastery_cleave)

function modifier_chc_mastery_cleave_1:OnCreated(keys)
	self.splash = 0.35
	self.radius = 425
end

function modifier_chc_mastery_cleave_2:OnCreated(keys)
	self.splash = 0.7
	self.radius = 425
end

function modifier_chc_mastery_cleave_3:OnCreated(keys)
	self.splash = 1.4
	self.radius = 425
end
