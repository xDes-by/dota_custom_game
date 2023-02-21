spirit_arc_lightning = class({})

function spirit_arc_lightning:OnSpellStart()
	target = self:GetCursorTarget()
	caster = self:GetCaster()
	damage_lighing = self:GetSpecialValueFor("damage")
	
	self:GetCaster():EmitSound("Hero_Zuus.ArcLightning.Cast")
	
	if not target:TriggerSpellAbsorb(self) then
		local head_particle = ParticleManager:CreateParticle("particles/items_fx/chain_lightning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControlEnt(head_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(head_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(head_particle, 62, Vector(2, 0, 2))
		
		if caster:FindAbilityByName("npc_dota_hero_wisp_int_last") ~= nil then
			damage_lighing = damage_lighing + caster:GetIntellect()/2
		end
	
		if caster:FindAbilityByName("npc_dota_hero_wisp_agi6") ~= nil then
			damage_lighing = damage_lighing + caster:GetAttackDamage()
		end
		
		damage_type = DAMAGE_TYPE_PHYSICAL
		if caster:FindAbilityByName("npc_dota_hero_wisp_int11") ~= nil then
			damage_type = DAMAGE_TYPE_MAGICAL
		end
		
		ApplyDamage({victim = target, attacker = caster, damage = damage_lighing, damage_type = damage_type})
	end
end

