// Calculations for computing the mesh and branch currents
// ENGR 2405 (ECE 402): Electrical Circuits I
// Abdon Morales

R = [150 -20 0 -80 0;
     -20 65 -30 -15 0;
      0 -30 50 0 -20;
     -80 -15 0 95 0;
      0 0 -20 0 80];
disp("R=");
disp(R);

V = [30;
      0;
    -12;
     20;
    -20];
disp("V=");
disp(V);

invR = inv(R);
disp("Inverse of R=");
disp(invR);

disp("This is the vector of mesh currents:");
I = invR * V;
disp(I);

disp("This is the vector of branch currents:");
branchCurrents = [I(1);
                  I(2)-I(1);
                  I(3);
                  I(5);
                  I(4)-I(1)];
disp(branchCurrents);
