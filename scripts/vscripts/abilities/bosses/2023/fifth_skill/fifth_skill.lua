hero_destroyer_fifth_skill = class({})
LinkLuaModifier( "modifier_hero_destroyer_fifth_skill_1", "abilities/bosses/2023/fifth_skill/fifth_skill", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hero_destroyer_fifth_skill_2", "abilities/bosses/2023/fifth_skill/fifth_skill", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hero_destroyer_fifth_skill_3", "abilities/bosses/2023/fifth_skill/fifth_skill", LUA_MODIFIER_MOTION_NONE )

function hero_destroyer_fifth_skill:OnSpellStart()
	local duration = self:GetSpecialValueFor("duration")

	self:GetCaster():Purge(false, true, false, true, false)
	
	local int = RandomInt(1,3)

	self:GetCaster():AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_hero_destroyer_fifth_skill_" ..int,
		{ duration = duration }
	)
	self:PlayEffects()
end

function hero_destroyer_fifth_skill:PlayEffects()
	local sound_cast = "Hero_Ursa.Enrage"
	EmitSoundOn( sound_cast, self:GetCaster() )
end

---------------------------------------------------------------------------------------------------------------------

modifier_hero_destroyer_fifth_skill_1 = class({})  --only phys

function modifier_hero_destroyer_fifth_skill_1:IsHidden()
	return false
end

function modifier_hero_destroyer_fifth_skill_1:IsDebuff()
	return false
end

function modifier_hero_destroyer_fifth_skill_1:IsPurgable()
	return false
end

function modifier_hero_destroyer_fifth_skill_1:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_PROPERTY_MODEL_SCALE,
	}
	return funcs
end

function modifier_hero_destroyer_fifth_skill_1:GetAbsoluteNoDamageMagical( params )
	return 1
end

function modifier_hero_destroyer_fifth_skill_1:GetAbsoluteNoDamagePure( params )
	return 1
end

function modifier_hero_destroyer_fifth_skill_1:GetModifierModelScale( params )
	return 30
end

function modifier_hero_destroyer_fifth_skill_1:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_enrage_buff.vpcf"
end

function modifier_hero_destroyer_fifth_skill_1:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_hero_destroyer_fifth_skill_1:GetStatusEffectName()
	return "particles/raid_str.vpcf"
end

function modifier_hero_destroyer_fifth_skill_1:StatusEffectPriority()
	return 15 
end

---------------------------------------------------------------------------------------------------------------------

modifier_hero_destroyer_fifth_skill_2 = class({}) --only magic

function modifier_hero_destroyer_fifth_skill_2:IsHidden()
	return false
end

function modifier_hero_destroyer_fifth_skill_2:IsDebuff()
	return false
end

function modifier_hero_destroyer_fifth_skill_2:IsPurgable()
	return false
end

function modifier_hero_destroyer_fifth_skill_2:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_PROPERTY_MODEL_SCALE,
	}
	return funcs
end

function modifier_hero_destroyer_fifth_skill_2:GetAbsoluteNoDamagePhysical( params )
	return 1
end

function modifier_hero_destroyer_fifth_skill_2:GetAbsoluteNoDamagePure( params )
	return 1
end

function modifier_hero_destroyer_fifth_skill_2:GetModifierModelScale( params )
	return 30
end

function modifier_hero_destroyer_fifth_skill_2:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_enrage_buff.vpcf"
end

function modifier_hero_destroyer_fifth_skill_2:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_hero_destroyer_fifth_skill_2:GetStatusEffectName()
	return "particles/raid_mag.vpcf"
end

function modifier_hero_destroyer_fifth_skill_2:StatusEffectPriority()
	return 15 
end
 
---------------------------------------------------------------------------------------------------------------------

modifier_hero_destroyer_fifth_skill_3 = class({})  --only pure

function modifier_hero_destroyer_fifth_skill_3:IsHidden()
	return false
end

function modifier_hero_destroyer_fifth_skill_3:IsDebuff()
	return false
end

function modifier_hero_destroyer_fifth_skill_3:IsPurgable()
	return false
end

function modifier_hero_destroyer_fifth_skill_3:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_MODEL_SCALE,
	}
	return funcs
end

function modifier_hero_destroyer_fifth_skill_3:GetAbsoluteNoDamagePhysical( params )
	return 1
end

function modifier_hero_destroyer_fifth_skill_3:GetAbsoluteNoDamageMagical( params )
	return 1
end

function modifier_hero_destroyer_fifth_skill_3:GetModifierModelScale( params )
	return 30
end

function modifier_hero_destroyer_fifth_skill_3:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_enrage_buff.vpcf"
end

function modifier_hero_destroyer_fifth_skill_3:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_hero_destroyer_fifth_skill_3:GetStatusEffectName()
	return "particles/raid_pure.vpcf"
end

function modifier_hero_destroyer_fifth_skill_3:StatusEffectPriority()
	return 15 
end
