% Load the data in
trainData = load('train.csv');

% Get the types into separate matrices
spruceIdx = (trainData(:,56) == 1);
spruce = trainData(spruceIdx,:);

lodgepolePineIdx = (trainData(:,56) == 2);
lodgepolePine = trainData(lodgepolePineIdx,:);

ponderosaPineIdx = (trainData(:,56) == 3);
ponderosaPine = trainData(ponderosaPineIdx,:);

willowIdx = (trainData(:,56) == 4);
willow = trainData(willowIdx,:);

aspenIdx = (trainData(:,56) == 5);
aspen = trainData(aspenIdx,:);

douglasIdx = (trainData(:,56) == 6);
douglas = trainData(douglasIdx,:);

krummholzIdx = (trainData(:,56) = 7);
krummholz = trainData(krummholzIdx,:);


% Partition the train datas columns into named variables
Id = trainData(:, 1);
Elevation = trainData(:, 2);
Aspect = trainData(:, 3);
Slope = trainData(:, 4);
Horizontal_Distance_To_Hydrology = trainData(:, 5);
Vertical_Distance_To_Hydrology = trainData(:, 6);
Horizontal_Distance_To_Roadways = trainData(:, 7);
Hillshade_9am = trainData(:, 8);
Hillshade_Noon = trainData(:, 9);
Hillshade_3pm = trainData(:, 10);
Horizontal_Distance_To_Fire_Points = trainData(:, 11);
Wilderness_Area1 = trainData(:, 12);
Wilderness_Area2 = trainData(:, 13);
Wilderness_Area3 = trainData(:, 14);
Wilderness_Area4 = trainData(:, 15);
Soil_Type1 = trainData(:, 16);
Soil_Type2 = trainData(:, 17);
Soil_Type3 = trainData(:, 18);
Soil_Type4 = trainData(:, 19);
Soil_Type5 = trainData(:, 20);
Soil_Type6 = trainData(:, 21);
Soil_Type7 = trainData(:, 22);
Soil_Type8 = trainData(:, 23);
Soil_Type9 = trainData(:, 24);
Soil_Type10 = trainData(:, 25);
Soil_Type11 = trainData(:, 26);
Soil_Type12 = trainData(:, 27);
Soil_Type13 = trainData(:, 28);
Soil_Type14 = trainData(:, 29);
Soil_Type15 = trainData(:, 30);
Soil_Type16 = trainData(:, 31);
Soil_Type17 = trainData(:, 32);
Soil_Type18 = trainData(:, 33);
Soil_Type19 = trainData(:, 34);
Soil_Type20 = trainData(:, 35);
Soil_Type21 = trainData(:, 36);
Soil_Type22 = trainData(:, 37);
Soil_Type23 = trainData(:, 38);
Soil_Type24 = trainData(:, 39);
Soil_Type25 = trainData(:, 40);
Soil_Type26 = trainData(:, 41);
Soil_Type27 = trainData(:, 42);
Soil_Type28 = trainData(:, 43);
Soil_Type29 = trainData(:, 44);
Soil_Type30 = trainData(:, 45);
Soil_Type31 = trainData(:, 46);
Soil_Type32 = trainData(:, 47);
Soil_Type33 = trainData(:, 48);
Soil_Type34 = trainData(:, 49);
Soil_Type35 = trainData(:, 50);
Soil_Type36 = trainData(:, 51);
Soil_Type37 = trainData(:, 52);
Soil_Type38 = trainData(:, 53);
Soil_Type39 = trainData(:, 54);
Soil_Type40 = trainData(:, 55);
Cover_Type = trainData(:, 56);