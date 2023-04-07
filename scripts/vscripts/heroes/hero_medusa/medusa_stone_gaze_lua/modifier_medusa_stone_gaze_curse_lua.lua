modifier_medusa_stone_gaze_curse_lua = class({})

function modifier_medusa_stone_gaze_curse_lua:OnCreated( kv )
	if not IsServer() then return end
	self:PlayEffects()
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_medusa_stone_gaze_curse_applied_once_lua", {})
end

function modifier_medusa_stone_gaze_curse_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
	return funcs
end

function modifier_medusa_stone_gaze_curse_lua:GetModifierIncomingDamage_Percentage( params )
	if params.damage_type==DAMAGE_TYPE_PHYSICAL then
		if self:GetCaster():FindAbilityByName("npc_dota_hero_medusa_agi7") ~= nil then
			return self:GetAbility():GetSpecialValueFor("damage_bonus") + 50
		end
		return self:GetAbility():GetSpecialValueFor("damage_bonus")
	end
end

function modifier_medusa_stone_gaze_curse_lua:CheckState()
	local state = 
	{
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
	}
	return state
end

function modifier_medusa_stone_gaze_curse_lua:GetStatusEffectName()
	return "particles/status_fx/status_effect_medusa_stone_gaze.vpcf"
end

function modifier_medusa_stone_gaze_curse_lua:StatusEffectPriority()
	return MODIFIER_PRIORITY_ULTRA
end

function modifier_medusa_stone_gaze_curse_lua:PlayEffects()
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_medusa/medusa_stone_gaze_debuff_stoned.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt( effect_cast, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", Vector( 0,0,0 ), true )
	self:AddParticle( effect_cast, false, false, -1, false, false  )
	EmitSoundOnClient( "Hero_Medusa.StoneGaze.Stun", self:GetParent():GetPlayerOwner() )
end


modifier_medusa_stone_gaze_curse_applied_once_lua = class({})
function modifier_medusa_stone_gaze_curse_applied_once_lua:IsHidden()
	return true
end
