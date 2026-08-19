// ----------------- MAIN PROGRAM (Part II) -----------------
disp("Abdon Morales");
disp("ENGR 2405 - System of Linear Equations");
disp("========================================");
// Build the matrix and vector
A = [2 1 1; 1 2 1; 1 1 2];
X = [1;2;3];
disp("Matrix A = "); disp(A);
disp("Vector X = "); disp(X);

// Do the math via matrix-vector multiplication
Y = A*X;
disp("This is the result of A*X");
disp(Y);

// Do the matrix A inversion
invA = inv(A);
disp("This is A inverse =");
disp(invA);

// Now go back to find X using the inversion
out = invA * Y;
disp("Vector X using A inverse * Y");
disp(out);
