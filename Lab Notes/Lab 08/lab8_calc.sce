// ENGR 2405 - Lab 8, Transient Response II
// Sallen-Key second-order step response.
// Computes damping parameters and characteristic-equation roots for the
// three as-built designs, then plots the normalized step response g(t).
// C1 = feedback cap, C2 = grounded cap.

clear;

names = ["Critically damped"; "Overdamped"; "Underdamped"];
R1 = [16e3;  47e3;  10e3];    // ohms
R2 = [16e3;  5.6e3; 10e3];
C1 = [10e-9; 10e-9; 22e-9];   // farads
C2 = [10e-9; 10e-9; 10e-9];

t = linspace(0, 3e-3, 3000);
scf(0); clf();

for k = 1:3
    Req   = R1(k)*R2(k)/(R1(k)+R2(k));
    w0    = sqrt(1/(R1(k)*C1(k)*R2(k)*C2(k)));
    alpha = 1/(2*Req*C1(k));
    Q     = w0/(2*alpha);
    f0    = w0/(2*%pi);
    zeta  = alpha/w0;          // damping ratio: 1 = critical

    mprintf("\n%s\n", names(k));
    mprintf("  Req = %7.1f ohm   f0 = %7.1f Hz   Q = %5.3f\n", Req, f0, Q);
    mprintf("  w0  = %7.1f rad/s   alpha = %7.1f 1/s\n", w0, alpha);

    if abs(zeta - 1) < 1e-3 then
        mprintf("  critically damped: double root s = %8.1f 1/s\n", -alpha);
        g = 1 - (1 + alpha*t).*exp(-alpha*t);
    elseif zeta > 1 then
        s1 = -alpha + alpha*sqrt(1 - 1/zeta^2);   // = -alpha + sqrt(alpha^2-w0^2)
        s2 = -alpha - alpha*sqrt(1 - 1/zeta^2);
        mprintf("  overdamped: s1 = %8.1f   s2 = %9.1f 1/s\n", s1, s2);
        g = 1 + (s2*exp(s1*t) - s1*exp(s2*t))/(s1 - s2);
    else
        wd = w0*sqrt(1 - zeta^2);
        Mp = exp(-%pi*alpha/wd)*100;
        mprintf("  underdamped: s = -%.1f +/- j%.1f 1/s   fd = %.1f Hz\n", ...
                alpha, wd, wd/(2*%pi));
        mprintf("  overshoot = %.1f %%   tp = %.0f us\n", Mp, %pi/wd*1e6);
        g = 1 - exp(-alpha*t).*(cos(wd*t) + (alpha/wd)*sin(wd*t));
    end

    plot(t*1e3, g);
end

xlabel("Time (ms)");
ylabel("Normalized V_out");
legend(names(1), names(2), names(3), 4);
xgrid();
