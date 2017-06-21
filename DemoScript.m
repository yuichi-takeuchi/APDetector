% Copyright (c) Yuichi Takeuchi 2017
%% StructInfo
StructInfo.matfilenamebase = 'Demo';
StructInfo.expnum = 1;
StructInfo.sr = 20000;

%% (Optional) Extraction of voltage and current channels from mat file outputs of PatchMaster software (ver 2.901, HEKA)
% k = StructInfo.expnum;
% evalstr = ['StructData' num2str(k) ' = struct([]);'];
% eval(evalstr)
% Varlist = who('Trace_*');
% for l = 1:length(Varlist)
%     A = sscanf(Varlist{l}, 'Trace_%d_%d_%d_%d');
%     switch A(4)
%         case 1
%            evalstr = ['StructData' num2str(A(1)) '(' num2str(A(2)) ').Time{' num2str(A(3)) ', 1} = ' Varlist{l} '(:,1);'];
%            eval(evalstr)
%            evalstr = ['StructData' num2str(A(1)) '(' num2str(A(2)) ').Voltage{' num2str(A(3)) ', 1} =' Varlist{l} '(:,2);'];
%            eval(evalstr)
%         case 2
%            evalstr = ['StructData' num2str(A(1)) '(' num2str(A(2)) ').Current{' num2str(A(3)) ', 1} =' Varlist{l} '(:,2);'];
%            eval(evalstr)
%         otherwise
%            disp('otherwise')
%     end
% end
% 
% clear evalstr Varlist A k l Trace*

%% Opening guide
guide APDetector.fig

%% Saving StructAP and TbAP
k = StructInfo.expnum;
evalstr = ['StructAP' num2str(k) ' = StructAP;'];
eval(evalstr)
evalstr = ['TbAP' num2str(k) ' = struct2table(StructAP);'];
eval(evalstr)

clear StructAP k evalstr

%% writetables of mAPs
k = StructInfo.expnum;
evalstr = ['writetable(TbAP' num2str(k) ', ''' StructInfo.matfilenamebase '_TbAP' num2str(k) '.csv'');'];
eval(evalstr)

clear k evalstr

%% save mat file
tic
disp('Saving ...')
save([StructInfo.matfilenamebase '.mat']);
disp('...')
toc