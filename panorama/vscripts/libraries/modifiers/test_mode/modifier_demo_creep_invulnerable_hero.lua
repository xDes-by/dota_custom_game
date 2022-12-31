modifier_demo_creep_invulnerable_hero = class({})
function modifier_demo_creep_invulnerable_hero:IsPurgable() return false end
function modifier_demo_creep_invulnerable_hero:IsPurgeException() return false end 
function modifier_demo_creep_invulnerable_hero:IsHidden() return true end
function modifier_demo_creep_invulnerable_hero:RemoveOnDeath() return false end
--  modifier only for js checked
