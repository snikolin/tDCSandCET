function comps = sn_CETICAcheck(comps)
% Identify which components are to be removed
% Done through automated process to suggest components with a 
% follow-up visual confirmation. 
% Prompt to list components at the end

% Automated process to suggest components for removal
sn_CETautoICA(comps)

% Visual inspection of components
sn_CETplotICA(comps);

% Creates prompt for user to include which components need to be rejected
prompt          = 'list components to reject. Approximately 10-15% of total:';
x               = input(prompt);
comps.rejected  = x;
