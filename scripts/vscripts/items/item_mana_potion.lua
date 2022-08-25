item_mana_potion = class({})

--------------------------------------------------------------------------------

function item_mana_potion:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end

--------------------------------------------------------------------------------

function item_mana_potion:OnSpellStart()
	if IsServer() then
		local mana_restore_pct = self:GetSpecialValueFor( "mana_restore_pct" )
		self:GetCaster():EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		
		local Heroes = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), 1000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 0, false )
		for _,Hero in pairs( Heroes ) do
			local flManaAmount = Hero:GetMaxMana() * mana_restore_pct / 100
			Hero:GiveMana( flManaAmount / #Heroes )
				
			local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/mango_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, Hero )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		end
		self:SpendCharge()
	end
end

--------------------------------------------------------------------------------