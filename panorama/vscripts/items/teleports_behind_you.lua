item_teleports_behind_you = class({})

LinkLuaModifier("modifier_item_teleports_behind_you", "items/teleports_behind_you", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_teleports_behind_you_meteor_form", "items/teleports_behind_you", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_teleports_behind_you_meteor_burn", "items/teleports_behind_you", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_teleports_behind_you_meteor_stun", "items/teleports_behind_you", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
function item_teleports_behind_you:GetIntrinsicModifierName()
	return "modifier_item_teleports_behind_you"
end

-- Item active
function item_teleports_behind_you:GetAOERadius()
	return self:GetSpecialValueFor("meteor_land_radius")
end

function item_teleports_behind_you:OnSpellStart()
	local caster = self:GetCaster()
	local target_loc = self:GetCursorPosition()
	
	-- Play start point effects
	caster:EmitSound("DOTA_Item.BlinkDagger.Activate")

	local blink_pfx = ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:ReleaseParticleIndex(blink_pfx)

	-- Blink and disjoint projectiles
	FindClearSpaceForUnit(caster, target_loc, true)
	ProjectileManager:ProjectileDodge( caster )

	-- Play end point effects
	caster:EmitSound("DOTA_Item.MeteorHammer.Cast")
	caster:EmitSound("Blink_Layer.Swift")
	caster:EmitSound("Blink_Layer.Arcane")

	local blink_end_pfx = ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:ReleaseParticleIndex(blink_end_pfx)

	-- Meteor drop
	local meteor_land_time = self:GetSpecialValueFor("meteor_fall_time")
	local buff_duration = self:GetSpecialValueFor("buff_duration") + meteor_land_time -- Duration is wasted while caster is in meteor
	
	local meteor_pfx = ParticleManager:CreateParticle("particles/items4_fx/meteor_hammer_spell.vpcf", PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(meteor_pfx, 0, target_loc + Vector(0, 0, 1000)) -- 1000 feels kinda arbitrary but it also feels correct
	ParticleManager:SetParticleControl(meteor_pfx, 1, target_loc)
	ParticleManager:SetParticleControl(meteor_pfx, 2, Vector(meteor_land_time, 0, 0))
	ParticleManager:ReleaseParticleIndex(meteor_pfx)

	caster:AddNewModifier(caster, self, "modifier_item_arcane_blink_buff", {duration = buff_duration})
	caster:AddNewModifier(caster, self, "modifier_item_swift_blink_buff", {duration = buff_duration})
	caster:AddNewModifier(caster, self, "modifier_item_teleports_behind_you_meteor_form", {duration = meteor_land_time})
end



-- Item Stats
modifier_item_teleports_behind_you = class({})

function modifier_item_teleports_behind_you:IsDebuff() return false end
function modifier_item_teleports_behind_you:IsHidden() return true end
function modifier_item_teleports_behind_you:IsPurgable() return false end
function modifier_item_teleports_behind_you:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_item_teleports_behind_you:OnCreated(keys)
	self:OnRefresh(keys)
end

function modifier_item_teleports_behind_you:OnRefresh(keys)
	local ability = self:GetAbility()
	if (not ability) or ability:IsNull() then return end

	self.bonus_all_stats = ability:GetSpecialValueFor("bonus_all_stats")
	self.blink_damage_cooldown = ability:GetSpecialValueFor("blink_damage_cooldown")
end

function modifier_item_teleports_behind_you:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end

function modifier_item_teleports_behind_you:GetModifierBonusStats_Strength()
	return self.bonus_all_stats or 0
end

function modifier_item_teleports_behind_you:GetModifierBonusStats_Agility()
	return self.bonus_all_stats or 0
end

function modifier_item_teleports_behind_you:GetModifierBonusStats_Intellect()
	return self.bonus_all_stats or 0
end

function modifier_item_teleports_behind_you:GetModifierIncomingDamage_Percentage(keys)
	if keys.attacker == keys.target or keys.original_damage <= 0 then return end

	if (not keys.attacker:IsControllableByAnyPlayer()) then return end

	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then return end

	local ability = self:GetAbility()
	if ability and (not ability:IsNull()) and ability:GetCooldownTimeRemaining() < self.blink_damage_cooldown then
		ability:StartCooldown(self.blink_damage_cooldown)
	end
end



-- Meteor Form
modifier_item_teleports_behind_you_meteor_form = class({})

function modifier_item_teleports_behind_you_meteor_form:IsDebuff() return false end
function modifier_item_teleports_behind_you_meteor_form:IsHidden() return true end
function modifier_item_teleports_behind_you_meteor_form:IsPurgable() return false end
function modifier_item_teleports_behind_you_meteor_form:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_item_teleports_behind_you_meteor_form:CheckState()
	if IsServer() then
		return {
			[MODIFIER_STATE_STUNNED] = true,
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_UNSELECTABLE] = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			[MODIFIER_STATE_OUT_OF_GAME] = true,
			[MODIFIER_STATE_UNTARGETABLE] = true,
		}
	else
		return {
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_UNSELECTABLE] = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			[MODIFIER_STATE_OUT_OF_GAME] = true,
			[MODIFIER_STATE_UNTARGETABLE] = true,
		}
	end
end

function modifier_item_teleports_behind_you_meteor_form:OnCreated()
	if IsClient() then return end

	self:GetCaster():AddNoDraw()
end

function modifier_item_teleports_behind_you_meteor_form:OnDestroy()
	if IsClient() then return end
	
	local caster = self:GetCaster()
	if (not caster) or caster:IsNull() then return end

	caster:RemoveNoDraw()

	local ability = self:GetAbility()
	if (not ability) or ability:IsNull() then return end

	-- Numbers
	local effect_radius = ability:GetSpecialValueFor("meteor_land_radius")
	local base_damage = ability:GetSpecialValueFor("overwhelming_blink_damage_base")
	local str_damage = 0.01 * ability:GetSpecialValueFor("overwhelming_blink_damage_str_multiplier")
	local burn_duration = ability:GetSpecialValueFor("meteor_burn_duration")
	local stun_duration = ability:GetSpecialValueFor("meteor_stun_duration")
	local slow_duration = stun_duration + ability:GetSpecialValueFor("slow_duration")

	local damage_table = {
		attacker = caster,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = ability,
		damage = base_damage + str_damage * (caster.GetStrength and caster:GetStrength() or 0)
	}

	-- Effects
	caster:EmitSound("DOTA_Item.MeteorHammer.Impact")
	caster:EmitSound("Blink_Layer.Overwhelming")

	local overwhelming_pfx = ParticleManager:CreateParticle("particles/items3_fx/blink_overwhelming_burst.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(overwhelming_pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(overwhelming_pfx, 1, Vector(effect_radius, effect_radius, effect_radius))
	ParticleManager:ReleaseParticleIndex(overwhelming_pfx)

	-- Impact
	local enemies = FindUnitsInRadius(caster:GetTeam(), 
		caster:GetAbsOrigin(), 
		nil, 
		effect_radius, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, 
		DOTA_UNIT_TARGET_FLAG_NONE, 
		FIND_ANY_ORDER, 
		false)

	for _, enemy in pairs(enemies) do
		enemy:EmitSound("DOTA_Item.MeteorHammer.Damage")

		enemy:AddNewModifier(caster, ability, "modifier_item_overwhelming_blink_debuff", {duration = slow_duration})
		enemy:AddNewModifier(caster, ability, "modifier_item_teleports_behind_you_meteor_burn", {duration = burn_duration})
		enemy:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration})

		damage_table.victim = enemy

		ApplyDamage(damage_table)
	end
end



-- Meteor Burn
modifier_item_teleports_behind_you_meteor_burn = class({})

function modifier_item_teleports_behind_you_meteor_form:IsHidden() return false end
function modifier_item_teleports_behind_you_meteor_form:IsDebuff() return true end
function modifier_item_teleports_behind_you_meteor_burn:IsPurgable() return true end

function modifier_item_teleports_behind_you_meteor_burn:OnCreated()
	if IsClient() then return end

	self.burn_dps = self:GetAbility():GetSpecialValueFor("meteor_burn_dps") or 0

	self:StartIntervalThink(1.0)
	self:OnIntervalThink()
end

function modifier_item_teleports_behind_you_meteor_burn:OnIntervalThink()
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local ability = self:GetAbility()

	if (not caster) or (not parent) or (not ability) or caster:IsNull() or parent:IsNull() or ability:IsNull() then self:Destroy() return end

	local actual_damage = ApplyDamage({
		ability = ability,
		attacker = caster,
		victim = parent,
		damage = self.burn_dps,
		damage_type	= DAMAGE_TYPE_MAGICAL
	})

	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, parent, actual_damage, nil)
end

function modifier_item_teleports_behind_you_meteor_burn:GetEffectName()
	return "particles/items4_fx/meteor_hammer_spell_debuff.vpcf"
end
