
% repeated cv on Kernel based svm
%
% Li Xue (l.xue@uu.nl)
% Utrecht University
% Oct. 3rd, 2017

function predictedIC50 = train(K, IC50, n_cv, n_repeat, svm_option)

% svm_option = '-s 3 -t 4'

pred=[];
real=[];
Fold=[];
repeat=[];

for j = 1:n_repeat
    
    n_train = size(K,1); 

    c=cvpartition(n_train,'KFold', n_cv);
    
    for i = 1:n_cv
        
  
        %-- train
        train_label = log(IC50(c.training(i)==1));
        K_train = K( c.training(i) ==1, c.training(i) ==1);
        n = size(K_train,1); %-- number of training cases
        model = svmtrain(train_label, [(1:n)', K_train], svm_option);
        
        %-- test
        test_label = log(IC50(c.training(i)==0));
        K_test = K( c.training(i) ==0, c.training(i) ==1);
        m = size(K_test,1); %-- number of test cases
        [predict_label_P, accuracy_P, dec_values_P] = svmpredict(test_label ,[(1:m)', K_test ], model);
        
        %-- keep results
        pred = [pred; predict_label_P];
        real = [real; test_label];
        Fold = [Fold; repmat(i, size(test_label )) ];
        repeat = [repeat; repmat(j, size(test_label))];
        
        %--
        %fprintf('repeat = %d, fold = %d, num_train = %d, num_test = %d\n', j, i, n,m);
        
    end
end


predictedIC50 = table(pred, real, Fold, repeat);

