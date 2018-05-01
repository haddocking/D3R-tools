% Li Xue (l.xue@uu.nl)
% Utrecht University
% Oct. 3rd, 2017

clear;
close all;
addpath('/Users/lixue/tools/libsvm-3.21/matlab'); % change the dir to the local installation of libsvm

TRAIN_kernel = dlmread('TRAIN.matrix');
size(TRAIN_kernel)

TEST_kernel = dlmread('TEST.matrix');
size(TEST_kernel)

IC50_ori = csvread('IC50_train.csv', 1); % read the file starting from row 2
IC50 = IC50_ori(:,2);


%---- 5-fold cv on training set
n_cv = 5;
n_repeat = 10;
n = size(TRAIN_kernel,1); 
c=cvpartition(n,'KFold', n_cv);

K = TRAIN_kernel;
predictedIC50 = train(K, IC50, n_cv, n_repeat, '-s 4 -t 4 ');


figure;
%plot(predictedIC50.pred, predictedIC50.real,'o');
scatter(predictedIC50.pred, predictedIC50.real,'filled')
xlabel('predicted ln(IC50)', 'FontSize', 20);
ylabel('experimental ln(IC50)', 'FontSize', 20);
%title('10 repeats of 5-fold cross-validation on 229 FXR ligands', 'FontSize', 20);
set(gca,'fontsize', 20);
print('-dpng', '-r600', '-cmyk', 'CV_plot.png');

%-- calculate corr 
spearman = [];
pearson =[];
kendall =[];

for j = 1:n_repeat
    idx = predictedIC50.repeat ==j;
    results = predictedIC50(idx,:);
    spearman = [spearman; corr(results.pred, results.real, 'type', 'Spearman')]; %  0.7220
    pearson = [pearson; corr(results.pred, results.real, 'type', 'Pearson')]; %  0.7172
    kendall = [kendall; corr(results.pred, results.real, 'type', 'Kendall')]; 
end


ave = mean(spearman);
sd =std(spearman);
fprintf('spearman = %.2f ± %.2f\n', ave, sd);

ave = mean(pearson);
sd =std(pearson);
fprintf('pearson = %.2f ± %.2f\n', ave, sd);

ave = mean(kendall);
sd =std(kendall);
fprintf('kendall = %.2f ± %.2f\n', ave, sd);



% optimization finished, #iter = 1384
% epsilon = 0.697248
% obj = -1539.726095, rho = -6.075790
% nSV = 862, nBSV = 610
% Mean squared error = 2.49009 (regression)
% Squared correlation coefficient = 0.724293 (regression)
% spearman = 0.84 ± 0.00
% pearson = 0.84 ± 0.00
% kendall = 0.66 ± 0.00

%--------------------------------------------------------

%--- build svm model on all training data
n = size(IC50, 1)
K_all = [(1:n)', TRAIN_kernel ];
train_label_all = log(IC50);
%histogram(train_label_all);
model_all = svmtrain(train_label_all, K_all , '-s 4 -t 4 ');


% optimization finished, #iter = 1610
% epsilon = 0.679673
% obj = -1856.185741, rho = -6.279170
% nSV = 1065, nBSV = 772


%---- test on training set
 test_label = train_label_all;
 [predict_label_P, accuracy_P, dec_values_P] = svmpredict(test_label , K_all, model_all);
 figure
 plot(predict_label_P, test_label, 'o');
 xlabel('predicted log(IC50)')
 ylabel('real log(IC50)')
 title('prediction on the training set');


%--- predict log(IC50) for D3R challenge
l = size(TEST_kernel,1);
TEST_label = ones(l,1);
[predict_label_D3R, accuracy_D3R, dec_values_D3R] = svmpredict( TEST_label , [ (1:l)'  TEST_kernel], model_all);

csvwrite('predicted_logIC50.csv', predict_label_D3R);
