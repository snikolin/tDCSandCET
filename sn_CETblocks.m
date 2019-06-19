function meta = sn_CETblocks(data) 
EEG     = find(strcmp({data.event.type},'eeg'));
INDEX   = zeros(length(EEG),2);
LABELS  = {'Open EEG','Closed EEG'};

for a = 1:length(EEG)
    EOG_start   = data.event(EEG(a)).sample;
    EOG_end     = data.event(EEG(a)).sample + data.event(EEG(a)).sampdur - 1;
    INDEX(a,:)  = [EOG_start, EOG_end];
end

% Create blocks
for b = 1:size(INDEX,1)
    tempdata            = data;
    tempdata.label      = tempdata.label(1:32);
    tempdata.trial{1}   = data.trial{1}(1:32,INDEX(b,1):INDEX(b,2));
    tempdata.time{1}    = data.time{1}(1,INDEX(b,1):INDEX(b,2));
    tempdata.sampleinfo = [INDEX(b,1),INDEX(b,2)];
    tempdata.event      = data.event(EEG(b));
    tempdata.block      = LABELS{b};
    tempdata.trialinfo  = [];
    
    meta(b) = tempdata;
end

% remove fields using: meta = rmfield(meta,'trialinfo');
meta = orderfields(meta,sort(fieldnames(meta)));
