%j=%i
function x=polar2cart(m, a); 
x=m*cos(a)+(%j*m*sin(a)); 
endfunction

function p=cart2polar(x);
re = real(x); im = imag(x);
m = sqrt(re^2 + im^2);
a = atan(im, re);
p = [m,a];
endfunction

// ----------------- MAIN PROGRAM (Part I) -----------------
disp("Abdon Morales");
disp("ENGR 2405 - Polar/Cartesian Conversions Testcases");
disp("========================================");
// --- Test cart2polar ---
disp("--- Testing cart2polar ---");
x1 = 3 + 4*%i;
printf("Input  (cartesian): %g + %gi\n", real(x1), imag(x1));
out1 = cart2polar(x1);
printf("Output [m a]:  m = %g,  a = %g rad  (%g deg)\n", ...
       out1(1), out1(2), out1(2)*180/%pi);
// --- Test polar2cart ---
disp("--- Testing polar2cart ---");
m2 = 5;
a2 = 0.9273;   // ~53.13 deg expressed in radians
printf("Input  (polar): m = %g,  a = %g rad\n", m2, a2);
out2 = polar2cart(m2, a2);
printf("Output (cartesian): %g + %gi\n", real(out2), imag(out2));
// --- Round-trip check  ---
disp("--- Round-trip: cart -> polar -> cart ---");
back = polar2cart(out1(1), out1(2));
printf("Should match 3 + 4i:  %g + %gi\n", real(back), imag(back));
// --- Quadrant test: -3 + 4i (second quadrant) ---
disp("--- Testing cart2polar in Quadrant II ---");
x3 = -3 + 4*%i;
printf("Input  (cartesian): %g + %gi\n", real(x3), imag(x3));
out3 = cart2polar(x3);
printf("Output [m a]:  m = %g,  a = %g rad  (%g deg)\n", ...
       out3(1), out3(2), out3(2)*180/%pi);
