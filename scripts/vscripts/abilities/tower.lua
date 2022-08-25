tower_ability = class({})
LinkLuaModifier( "modifier_tower_ability", "abilities/tower", LUA_MODIFIER_MOTION_NONE )


function tower_ability:GetIntrinsicModifierName()
	return "modifier_tower_ability"
end
----------------------------------------------------------------------------------------------------------------

modifier_tower_ability = class({})

function modifier_tower_ability:IsHidden()
	return false
end

function modifier_tower_ability:OnCreated( kv )
	self.caster = self:GetCaster()
	self:StartIntervalThink( 0.2 )
end

function modifier_tower_ability:IsPurgable()
	return false
end


function modifier_tower_ability:OnIntervalThink()
if IsServer() then
	local health = self.caster:GetHealthPercent()
		if health <= 33 and not self.caster:HasModifier("modifier_heavens_halberd_debuff") then
					self.caster:AddNewModifier( self.caster, nil, "modifier_heavens_halberd_debuff", {} )
		end
		
		if health > 33 and self.caster:HasModifier("modifier_heavens_halberd_debuff") then 
					self.caster:RemoveModifierByName("modifier_heavens_halberd_debuff")
		end
					
		if health > 35 and health ~= 100 and self.caster:HasModifier("modifier_attack_immune") then
					self.caster:RemoveModifierByName("modifier_attack_immune")
		end
	end
end