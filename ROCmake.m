%For loop: classes
#foo1 = 0:100;
#foo1 = 2*foo1/100000;
#foo2 = 3:100;
#foo2 = foo2/100;
#steps = [foo1 foo2];

#step = size(steps)(2)
#TPR = zeros(step,7);
#FPR = zeros(step,7);
#P = zeros(step,7);

for myClass = 1:7;
  answer = myClass
  fflush(stdout);
    for i = 1:step
    iteration = i
    fflush(stdout);
    threshold = steps(i);
    TP = 0;
    FP = 0;
    FN = 0;
    TN = 0;
      for j = 1:size(predictions)
        if ( predictions(j,myClass) >= threshold ) %Guess Positive 
          if (predictions(j,8) == myClass) %True Positive
           TP = TP + 1;
         else  % False Positive
           FP = FP + 1;
         end
        else
         if (predictions(j,8) == myClass)  %False Negative
          FN = FN + 1;
         else
          TN = TN + 1;
         end
        end
      endfor
      TPR(i, myClass) = TP / (TP + FN);
      FPR(i,myClass) = FP / (FP + TN);
      P(i,myClass) = TP / (TP + FP);
      if (TP == 0)
        TPR(i,myClass) = 0;
        P(i, myClass) = 0;
      end
      if (FP == 0)
        FPR(i, myClass) = 0;
      end
      
    endfor
endfor
