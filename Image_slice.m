!Exploring Slices from a 3-Dimensional MRI Data Set 
!https://matlab.mathworks.com/
!Step 1: Load and View Horizontal MRI
load mri;
montage(D,map)
title('Horizontal Slices');
!Step 2: Extract Sagittal Slice from Horizontal Slices Using IMTRANSFORM
M1 = D(:,64,:,:); size(M1)
M2 = reshape(M1,[128 27]); size(M2)
figure, imshow(M2,map);
title('Sagittal - Raw Data');
T0 = maketform('affine',[0 -2.5; 1 0; 0 0]);
R2 = makeresampler({'cubic','nearest'},'fill');
M3 = imtransform(M2,T0,R2);  
figure, imshow(M3,map);
title('Sagittal - IMTRANSFORM')

!Step 3: Extract Sagittal Slice from the Horizontal Slices Using TFORMARRAY
T1 = maketform('affine',[-2.5 0; 0 1; 68.5 0]);  
inverseFcn = @(X,t) [X repmat(t.tdata,[size(X,1) 1])];
T2 = maketform('custom',3,2,[],inverseFcn,64);
Tc = maketform('composite',T1,T2);
R3 = makeresampler({'cubic','nearest','nearest'},'fill');
M4 = tformarray(D,Tc,R3,[4 1 2],[1 2],[66 128],[],0);
figure, imshow(M4,map);
title('Sagittal - TFORMARRAY');

!Step 4: Create and Display Sagittal Slices
T3 = maketform('affine',[-2.5 0 0; 0 1 0; 0 0 0.5; 68.5 0 -14]);
S = tformarray(D,T3,R3,[4 1 2],[1 2 4],[66 128 35],[],0);
S2 = padarray(S,[6 0 0 0],0,'both');
figure, montage(S2,map)
title('Sagittal Slices');

!Step 5: Create and Display Coronal Slices
T4 = maketform('affine',[-2.5 0 0; 0 1 0; 0 0 -0.5; 68.5 0 61]);
C = tformarray(D,T4,R3,[4 2 1],[1 2 4],[66 128 45],[],0);
C2 = padarray(C,[6 0 0 0],0,'both');
figure, montage(C2,map)
title('Coronal Slices');


