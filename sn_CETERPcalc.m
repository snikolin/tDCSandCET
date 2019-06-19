function data = sn_CETERPcalc(reref)
% Using structure array with EEG and NBACK data, output ERP averages

A = find(strcmp({reref.block},'Practice NBACK'));
B = find(strcmp({reref.block},'NBACK'));
C = find(strcmp({reref.block},'All NBACK'));

TYPE{1} = {'hit','fa','miss','stimulus'}; % all
TYPE{2} = {'hit','miss'}; % targets
TYPE{3} = {'stimulus','fa'}; % nontargets
TYPE{4} = {'hit','fa'}; % responses
TYPE{5} = {'stimulus','miss'}; % nonresponses
TYPE{6} = {'hit'}; % hits

CAT{1}  = 'all';
CAT{2}  = 'targets';
CAT{3}  = 'nontargets';
CAT{4}  = 'responses';
CAT{5}  = 'nonresponses';
CAT{6}  = 'hits';

BASE    = [-0.5 -0.2];

for t = [A,B,C] % Practice/Real/All
    for a = 1:length(TYPE)
        cfg             = [];
        tempdata        = reref(t);
        index           = sn_index(tempdata,TYPE{a});
        tempdata.trial  = tempdata.trial(index);
        tempdata.time   = tempdata.time(index);
        
        if t == A
            data.pre(a) = ft_timelockanalysis(cfg,tempdata);
            cfg         = [];
            cfg.channel = 'all';
            cfg.baseline= BASE;
            data.pre(a) = ft_timelockbaseline(cfg,data.pre(a));
        end
        if t == B
            data.post(a) = ft_timelockanalysis(cfg,tempdata);
            cfg         = [];
            cfg.channel = 'all';
            cfg.baseline= BASE;
            data.post(a) = ft_timelockbaseline(cfg,data.post(a));
        end
        if t == C
            data.all(a) = ft_timelockanalysis(cfg,tempdata);
            cfg         = [];
            cfg.channel = 'all';
            cfg.baseline= BASE;
            data.all(a) = ft_timelockbaseline(cfg,data.all(a));
        end
    end
end

for b = 1:length(CAT)
    data.pre(b).stimtype    = CAT{b};
    data.post(b).stimtype   = CAT{b};
    data.all(b).stimtype    = CAT{b};
end
