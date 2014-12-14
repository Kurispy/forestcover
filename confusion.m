#Truth = predictions(:,8);
#Guess = zeros(size(Truth));
#  for i = 1:size(Truth)
#    myOutput = max(predictions(i,1:7));
#    for j = 1:7
#      if (myOutput == predictions(i,j))
#        Guess(i) = j;
#        break
#      end
#    endfor
#  endfor 
  
cM = zeros(7,7);
for i = 1:size(Truth)
    if (Truth(i) != 0)
     cM(Truth(i),Guess(i)) += 1;
    else
      i
      fflush(stdout);
    end
endfor
