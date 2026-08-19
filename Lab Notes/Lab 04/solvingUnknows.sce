// Unknowns [VQ; VP]; A = +3 V, B = -5 V
G = [1/2200 + 1/4700 + 1/1000, -1/1000;
-1/1000, 1/4700 + 1/2200 + 1/1000];
disp("Matrix G:")
disp(G);
I = [3/2200; -5/4700];
disp("Vector I:")
disp(I);
V = G\I; // backslash: numerically stable
disp("Result V:")
disp(V);
VL = V(1) - V(2) // -> 0.9101 (V across the 1k load)
disp("V_L=V(1)-V(2):")
disp(VL);
