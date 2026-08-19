// =====================================================================
//  ENGR 2405 - Lab 10: Power Transfer in AC Circuits
//  Theoretical and measured load power for Case 1 and Case 2.
//  Theory uses the measured delivered source amplitude Vin = 2.0 V
//  (backed out from the no-capacitor points; see report).
// =====================================================================
clear;

Vin = 2.00;       // measured delivered amplitude, V (nominal setting was higher)
Rs  = 100;        // source resistance, ohm
L   = 33e-3;      // line inductance, H
f   = 5000;       // frequency, Hz
w   = 2*%pi*f;    // rad/s
XL  = w*L;        // inductive reactance, ohm

RLopt = sqrt(Rs^2 + XL^2);
Copt  = L/(w^2*L^2 + Rs^2);
mprintf("XL = %.1f ohm   RL,opt = %.1f ohm   C,opt = %.2f nF\n", XL, RLopt, Copt*1e9);

// ---------------------------- CASE 1 ---------------------------------
RL1 = [10 47 100 330 680 1000 2200 10000];
VL1 = [0.04 0.20 0.28 0.608 1.06 1.32 1.88 2.52];   // measured amplitude, V
PL1m = (VL1.^2)./(2*RL1);
PL1t = (Vin^2/2)*RL1./((Rs+RL1).^2 + XL^2);
mprintf("\nCASE 1\n  RL(ohm)   VL(V)  PLmeas(mW) PLtheo(mW)  err(%%)\n");
for k=1:length(RL1)
  e=100*(PL1m(k)-PL1t(k))/PL1t(k);
  mprintf("%9.0f %7.3f %10.3f %10.3f %8.1f\n",RL1(k),VL1(k),PL1m(k)*1e3,PL1t(k)*1e3,e);
end

// ---------------------------- CASE 2 ---------------------------------
function P=ploadC(C,RL,Vin,Rs,L,w)
  D1=Rs+RL-w^2*RL*L*C; D2=w*(L+RL*Rs*C);
  P=(Vin^2/2)*RL ./ (D1.^2+D2.^2);
endfunction

// capacitance values used (F). "series" is 47nF in series with 100nF.
Cser = 47e-9*100e-9/(47e-9+100e-9);
Clist = [0 10e-9 22e-9 Cser 47e-9 113e-9];
RLset = [1000 680 2200];
VL2 = [1.320 1.380 1.440 1.360 1.260 0.696;   // RL = 1000
       1.046 1.134 1.209 1.225 1.163 0.633;   // RL = 680
       1.740 2.273 3.154 3.490 2.537 0.723];  // RL = 2200 (reordered to match Clist)
for i=1:size(RLset,2)
  R=RLset(i);
  mprintf("\nCASE 2  RL=%g ohm\n   C(nF)   VL(V)  PLmeas(mW) PLtheo(mW)  err(%%)\n",R);
  for j=1:length(Clist)
    pm=VL2(i,j)^2/(2*R); pt=ploadC(Clist(j),R,Vin,Rs,L,w);
    e=100*(pm-pt)/pt;
    mprintf("%8.2f %7.3f %10.3f %10.3f %8.1f\n",Clist(j)*1e9,VL2(i,j),pm*1e3,pt*1e3,e);
  end
end
