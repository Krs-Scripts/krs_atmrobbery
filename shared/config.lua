lib.locale()

cfg = {}

cfg.robbery = {
    {
        duration = 20000, -- Duration progress in milliseconds
        labelText = 'Start Robbery', -- Label displayed ox_target
        label = 'Rapinando l\'atm',
        position = 'middle', -- Position progress (example, 'middle', 'bottom')
        dict = 'oddjobs@shop_robbery@rob_till', -- Animation dictionary for the robbery 
        clip = 'loop', -- Animation clip for the robbery
        Lspd = 0,  -- Lspd required for the robbery
        itemRequiredRobbery = 'water', -- Item required for the robbery to take
        props = { -- Props
            "prop_atm_01",
            "prop_atm_02",
            "prop_atm_03",
            "prop_fleeca_atm",
        }
    },
}