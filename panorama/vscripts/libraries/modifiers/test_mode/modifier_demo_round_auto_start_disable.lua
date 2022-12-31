modifier_demo_round_auto_start_disable = class({})

function modifier_demo_round_auto_start_disable:IsPurgable() return false end
function modifier_demo_round_auto_start_disable:IsPurgeException() return false end 
function modifier_demo_round_auto_start_disable:IsHidden() return true end
function modifier_demo_round_auto_start_disable:RemoveOnDeath() return false end
--  modifier only for js checked
