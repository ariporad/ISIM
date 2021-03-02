% This file is exactly the same as finalcalc.mlx, simply copied to a normal text file for posterity

syms dR R_0 dL L G_F V_in V_out V_ref I V_plus V_minus gain;

sg_eqn = (dR / R_0) == G_F * (dL / L)
R = R_0 + dR
V_minus = V_in * (R / (R + 121)) % pin 2, strain gauge
% book_eqn = (dR/R) == ((V_in / V_minus) - 2)
% dR_2 = solve(book_eqn, dR)
% V_minus = subs(V_minus, dR, dR_2)
% dR = solve(book_eqn, dR)
amp_eqn = V_out == (V_ref + (gain * (V_plus- V_minus)))
% amp_eqn_2 = subs(subs(amp_eqn))
gain = 501;
V_plus = 2.5 % pin 3, other voltage divider
G_F = 2.1
V_ref = 2.5;
V_in = 5;
R_0 = 120
amp_eqn_3 = subs(amp_eqn)
amp_eqn_4 = solve(amp_eqn_3, dR)

double(subs(amp_eqn_4, V_out, 0.020))
