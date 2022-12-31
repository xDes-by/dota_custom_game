item_eye_of_midas = class({})

LinkLuaModifier("modifier_item_eye_of_midas", "items/eye_of_midas", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_eye_of_midas_cooldown", "items/eye_of_midas", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_eye_of_midas_debuff", "items/eye_of_midas", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
function item_eye_of_midas:GetIntrinsicModifierName()
	return "modifier_item_eye_of_midas"
end

function item_eye_of_midas:GetAbilityTextureName()
	if self:GetCurrentCharges() < self:GetSpecialValueFor("active_cooldown") then
		return "neutral/eye_of_midas_disabled"
	end
	return "neutral/eye_of_midas"
end

-- Item Active
function item_eye_of_midas:CastFilterResultTarget(target)
	local caster = self:GetCaster()

	if self:GetCurrentCharges() < self:GetSpecialValueFor("active_cooldown") then
		return UF_FAIL_CUSTOM
	end

	if target:IsHero() then
		return UF_FAIL_HERO
	end

	if target:IsConsideredHero() then
		return UF_FAIL_CONSIDERED_HERO
	end

	return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, caster:GetTeamNumber())
end

function item_eye_of_midas:GetCustomCastErrorTarget(target)
	local caster = self:GetCaster()

	if self:GetCurrentCharges() < self:GetSpecialValueFor("active_cooldown") then
		return "#hud_error_eye_of_midas_cooldown"
	end
end

function item_eye_of_midas:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- Remove charges
	self:SetCurrentCharges(self:GetCurrentCharges() - self:GetSpecialValueFor("active_cooldown"))

	-- Play sound and show gold gain message to the owner
	target:EmitSound("DOTA_Item.Hand_Of_Midas")

	-- Draw the midas gold conversion particle
	local midas_pfx = ParticleManager:CreateParticle("particles/items2_fx/hand_of_midas.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(midas_pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), false)
	ParticleManager:ReleaseParticleIndex(midas_pfx)

	-- Grant extra gold and kill the target
	if caster.GetPlayerID then
		RoundManager:GiveGoldToPlayer(caster:GetPlayerID(), self:GetSpecialValueFor("bonus_gold"))
	end

	target:RemoveModifierByName("modifier_creature_shared_soul")
	target:Kill(self, caster)
end



-- Item Stats
modifier_item_eye_of_midas = class({})

function modifier_item_eye_of_midas:IsHidden() return true end
function modifier_item_eye_of_midas:IsDebuff() return false end
function modifier_item_eye_of_midas:IsPurgable() return false end
function modifier_item_eye_of_midas:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_item_eye_of_midas:OnCreated(keys)
	self:OnRefresh(keys)

	if IsClient() then return end
	
	if not self:GetParent():IsHero() or self:GetParent():FindModifierByName("modifier_tempest_double_illusion_permanent") then
		self:GetAbility():SetCurrentCharges(0)
	end
end

function modifier_item_eye_of_midas:OnRefresh(keys)
	local ability = self:GetAbility()
	if (not ability) or ability:IsNull() then return end

	self.bonus_str = ability:GetSpecialValueFor("bonus_str")
	self.bonus_agi = ability:GetSpecialValueFor("bonus_agi")
	self.bonus_int = ability:GetSpecialValueFor("bonus_int")
	self.bonus_attack_speed = ability:GetSpecialValueFor("bonus_attack_speed")
	self.bonus_hp = ability:GetSpecialValueFor("bonus_hp")
	self.bonus_mp = ability:GetSpecialValueFor("bonus_mp")
	self.debuff_duration = ability:GetSpecialValueFor("debuff_duration")
	self.bonus_creep_gold = ability:GetSpecialValueFor("bonus_creep_gold")

	if IsServer() then
		self.original_projectile = self:GetParent():GetRangedProjectileName()
		self:GetParent():SetRangedProjectileName("particles/items/eye_of_midas_projectile.vpcf")

		if not self:GetParent():HasModifier("modifier_item_eye_of_midas_cooldown") then
			self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_eye_of_midas_cooldown", {}):SetStackCount(ability:GetSpecialValueFor("active_cooldown"))
		end
	end
end

function modifier_item_eye_of_midas:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
	}
end

function modifier_item_eye_of_midas:GetModifierBonusStats_Strength()
	return self.bonus_str or 0
end

function modifier_item_eye_of_midas:GetModifierBonusStats_Agility()
	return self.bonus_agi or 0
end

function modifier_item_eye_of_midas:GetModifierBonusStats_Intellect()
	return self.bonus_int or 0
end

function modifier_item_eye_of_midas:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed or 0
end

function modifier_item_eye_of_midas:GetModifierHealthBonus()
	return self.bonus_hp or 0
end

function modifier_item_eye_of_midas:GetModifierManaBonus()
	return self.bonus_mp or 0
end

function modifier_item_eye_of_midas:GetModifierCreepGoldAmplification()
	return self.bonus_creep_gold or 0
end

function modifier_item_eye_of_midas:GetModifierProcAttack_Feedback(keys)
	if IsClient() then return end

	local ability = self:GetAbility()
	if (not keys.attacker) or (not keys.target) or (not ability) or keys.attacker:IsNull() or keys.target:IsNull() or ability:IsNull() then return end

	-- Does not work on friendly targets, buildings, or dead units
	if keys.attacker:GetTeam() == keys.target:GetTeam() or keys.target:IsBuilding() or (not keys.target:IsAlive()) then return end

	-- Apply the debuff
	local duration = self.debuff_duration or 0
	if keys.target.GetStatusResistance then duration = duration * (1 - keys.target:GetStatusResistance()) end
	keys.target:AddNewModifier(keys.attacker, ability, "modifier_item_eye_of_midas_debuff", {duration = duration})
end


function modifier_item_eye_of_midas:OnRoundEndForTeam(keys)
	self:OnPvpEndedForDuelists()
end

function modifier_item_eye_of_midas:OnPvpEndedForDuelists(keys)
	if IsClient() then return end
	local parent = self:GetParent()
	if not parent or parent:IsNull() then return end
	
	-- Make this cooldown check only on the main hero
	if PlayerResource:GetSelectedHeroEntity(parent:GetPlayerOwnerID()) ~= parent then return end

	local units = Util:FindAllOwnedUnits(parent:GetPlayerOwnerID())
	table.insert(units, parent)
	local eom_item = {}
	for _, unit in pairs(units) do
		for i = DOTA_ITEM_SLOT_1, DOTA_ITEM_NEUTRAL_SLOT do
			if not (i >= DOTA_STASH_SLOT_1 and i <= DOTA_STASH_SLOT_6) then
				local item = unit:GetItemInSlot(i)
				if item and item:GetName() == "item_eye_of_midas" then
					table.insert(eom_item, item)
				end
			end
		end
	end
	for i = DOTA_STASH_SLOT_1, DOTA_STASH_SLOT_6 do
		local item = self:GetParent():GetItemInSlot(i)
		if item and item:GetName() == "item_eye_of_midas" then
			table.insert(eom_item, item)
		end
	end
	
	local midas_to_give_charge = eom_item[math.random(#eom_item)]
	midas_to_give_charge:SetCurrentCharges(math.min(self:GetAbility():GetSpecialValueFor("active_cooldown"), midas_to_give_charge:GetCurrentCharges() + 1))
end

function modifier_item_eye_of_midas:OnRemoved()
	if IsServer() then
		self:GetParent():SetRangedProjectileName(self.original_projectile)
	end
end


modifier_item_eye_of_midas_debuff = class({})

function modifier_item_eye_of_midas_debuff:IsDebuff() return true end
function modifier_item_eye_of_midas_debuff:IsPurgable() return true end
function modifier_item_eye_of_midas_debuff:GetTexture() return "item_neutral/eye_of_midas" end

function modifier_item_eye_of_midas_debuff:OnCreated(keys)
	local ability = self:GetAbility()

	self.ranged_ms_slow = (-1) * ability:GetSpecialValueFor("debuff_ranged_ms_slow")
	self.ranged_as_slow = (-1) * ability:GetSpecialValueFor("debuff_ranged_atkspeed_slow")
	self.melee_ms_slow = (-1) * ability:GetSpecialValueFor("debuff_melee_ms_slow")
	self.melee_as_slow = (-1) * ability:GetSpecialValueFor("debuff_melee_atkspeed_slow")
	self.heal_reduction = (-1) * ability:GetSpecialValueFor("debuff_heal_reduction")
end

function modifier_item_eye_of_midas_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	}
end

function modifier_item_eye_of_midas_debuff:GetModifierAttackSpeedBonus_Constant()
	return (self:GetParent():IsRangedAttacker() and self.ranged_as_slow) or self.melee_as_slow
end

function modifier_item_eye_of_midas_debuff:GetModifierMoveSpeedBonus_Percentage()
	return (self:GetParent():IsRangedAttacker() and self.ranged_ms_slow) or self.melee_ms_slow
end

function modifier_item_eye_of_midas_debuff:GetModifierHPRegenAmplify_Percentage()
	return self.heal_reduction
end

function modifier_item_eye_of_midas_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost_lich.vpcf"
end

function modifier_item_eye_of_midas_debuff:StatusEffectPriority()
	return 10
end
