function FIGS = sim_models(InitialConditions,PATH)
assignin('base','k',InitialConditions.k);
%% system
FIGS = system_variable_structure1(PATH);  
FIGS = system_variable_structure2(InitialConditions,PATH,FIGS); 


end
