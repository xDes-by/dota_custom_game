LinkLuaModifier( "modifier_item_move_aura", "items/other/book_move", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_move_aura_cd", "items/other/book_move", LUA_MODIFIER_MOTION_NONE )

modifier_item_move_aura_cd = class({})
function modifier_item_move_aura_cd:IsHidden() return true end
function modifier_item_move_aura_cd:IsDebuff() return false end
function modifier_item_move_aura_cd:IsPurgable() return false end

item_move_aura = class({})

function item_move_aura:OnSpellStart()
	if IsServer() then
		self.caster = self:GetCaster()	
		self.radius = self:GetSpecialValueFor( "radius" )
		self.duration = self:GetSpecialValueFor( "duration" )
		self.caster:AddNewModifier(self.caster, self, "modifier_item_move_aura_cd", {duration = self:GetCooldown(self:GetLevel())* self.caster:GetCooldownReduction()})
		local Heroes = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 0, false )
		for _,Hero in pairs( Heroes ) do
		
		Hero:AddNewModifier(
		self.caster,
		self,
		"modifier_item_move_aura", 
		{duration = self.duration})
		end
			self.caster:EmitSound("Item.TomeOfKnowledge")
			self:SpendCharge()
			local new_charges = self:GetCurrentCharges()
			if new_charges <= 0 then
			self.caster:RemoveItem(self)
		end
	end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
modifier_item_move_aura = class({})

function modifier_item_move_aura:IsHidden()
	return false
end

function modifier_item_move_aura:GetTexture()
	return "scroll_3"
end

function modifier_item_move_aura:IsDebuff()
	return false
end

function modifier_item_move_aura:IsPurgable()
	return false
end

function modifier_item_move_aura:OnCreated( kv )
	if IsServer() then 
		self.caster = self:GetCaster()
		
	end
end

function modifier_item_move_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		}
	return funcs
end

function modifier_item_move_aura:GetModifierMoveSpeedBonus_Constant()
	return 100
end
