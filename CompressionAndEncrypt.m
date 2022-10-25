clear

filename = 'W3.txt';

% Obtain the number of measurement parameters
fileID = fopen(filename,'r');
lines= textscan(fileID,'%s %[^\n]',1,'Headerlines',1);
ParN = lines{1,2}; %the number of measurement parameters
sizeParN = size(str2num(ParN{1}),2);
fclose(fileID);

% Read text data
fileID = fopen(filename,'r');
formatSpec = '%f';
sizeAb = [sizeParN+1 Inf];
Ab = fscanf(fileID,formatSpec,sizeAb);
fclose(fileID);

Ab = round(Ab,3); % Can be adjusted according to data accuracy
PPosi = [Ab(1,1),Ab(1,2)-Ab(1,1),size(Ab,2)]; %Position infomation
Abnz = Ab(2:end,:)~= -9999;
Abnzdf = Abnz(:,1:end-1)-Abnz(:,2:end); % Used to determine the location of valid data

itag = zeros(1,size(Abnz,1)); % Used to record whether there is effective data
bp = zeros(1,size(Abnz,1)); % Start position
ep = zeros(1,size(Abnz,1)); % End position

l_u = 0;
l_u_a = 0;
dict_n = 0;
% bit_n = 8;
total_b = zeros(1,size(Abnz,1));
per_l = zeros(1,size(Abnz,1));
ThrN = 128; %Number of unequal values threshold

data_bin = [];
l_bin = []; % Encoding length
sign_Aint_diff = []; % Record signs
l_sign = []; % Record sign size
data_dicts{1} = []; % Storage dictionary
data_bins{1} = []; % Storage encoded data
for i = 1:size(Abnz,1)
    temp = Abnzdf(i,:);
    bposi = find(temp==-1);
    if size(bposi,2) == 0
        bp(i) = -1;
        ep(i) = -1;
        itag(i) = 0;
        data_dicts{i} = [];
        data_bins{i} = [];
    else
        bp(i) = bposi(1)+1;
        itag(i) = 1;
        eposi = find(temp==1);
        if size(eposi,2) == 0
            ep(i) = size(temp,2);
        else
            ep(i) = eposi(end);
        end
        Aint = round(Ab(i+1,bp(i):ep(i))*1000);% Effective data integer
        l_u = l_u + size(unique(Aint),2);% Record the number of effective data
        Aint_diff = Aint;
        Aint_diff(2:end) = Aint(2:end)-Aint(1:end-1);% Difference
        Aint_diff(2:end) = Aint_diff(2:end)-Aint_diff(1:end-1);% Second difference
        sign_t = Aint_diff<0; 
        l_sign = [l_sign,size(sign_t,2)]; % Record sign size
        per_l(i) = size(sign_t,2);
        sign_Aint_diff = [sign_Aint_diff,sign_t]; % Record signs
        Aint_diff = abs(Aint_diff); % Take absolute value
        l_u_a = l_u_a + size(unique(Aint_diff),2);
        Aint_diff_b = []; % Storage separation bit
        
        % Low bit separation according to thresholdS
        j = 1;
        while size(unique(Aint_diff),2) > ThrN
            Aint_diff_b(j,:) = mod(Aint_diff,2);
            Aint_diff = (Aint_diff-Aint_diff_b(j,:))/2;
            j = j+1;
        end
        total_b(i) = j-1;
        
        e_datan = unique(Aint_diff);
        hn = hist(Aint_diff, e_datan);
        rhn = hn/size(Aint_diff,2);
        data_dictn = huffmandict(e_datan,rhn);
        dict_n = dict_n + size(data_dictn,1);
        data_encon = huffmanenco(Aint_diff,data_dictn);
        l_bin = [l_bin,size(data_encon,2)];
        data_bin = [data_bin,data_encon];
        data_dicts{i} = data_dictn;
        data_bins{i} = data_bin;
    end
end

% data_bin_all = convertAndCombine(PPosi,PName,itag,bp,ep,l_sign,sign_Aint_diff,total_b,Aint_diff_b,data_dicts,data_bins);

%% Encryption
% [x0, r0] = genPar(key);
% chaos_sq = chaossys8(x0,r0,ihigh*iwidth*4);
% inv_sq = double(chaos_sq>0.5);
% data_cipher = abs(inv_sq-data_bin_all);
% [~,order_sq] = sort(chaos_sq);
% data_cipher(order_sq) = data_cipher;
