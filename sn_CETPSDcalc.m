function data = sn_CETPSDcalc(reref)

% Parameters
FS      = reref(1).fsample;
FREQ    = [1 70];
DUR     = 285; % use last 285 seconds of trial data for calculation
WINDOW  = 2;
NFFT    = 2; % window in seconds, resolution = 1/WINDOW

A       = [];
A(1)    = find(strcmp({reref.block},'Open EEG'));
A(2)    = find(strcmp({reref.block},'Closed EEG'));

for a = 1:length(A)
    for ch = 1:size(reref(A(a)).trial{1},1)
        temp    = reref(A(a)).trial{1}(:,(end - FS*DUR + 1):end);
        [P,F]   = pwelch(temp(ch,:),FS*WINDOW,[],FS*NFFT,FS);
        i       = find(F >= FREQ(1) & F <= FREQ(2));
        
        data(a).PSD(ch,:) = P(i);
        
        if ch == size(reref(a).trial{1},1)
            data(a).freq    = F(i);
            data(a).label   = reref(a).label;
            data(a).block   = reref(a).block;
            data(a).fsample = reref(a).fsample;
        end
    end
end
