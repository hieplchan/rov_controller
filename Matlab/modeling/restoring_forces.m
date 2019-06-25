function g = restoring_forces(W,B,theta,phi,r_g,r_b)
sth  = sin(theta); cth  = cos(theta);
sphi = sin(phi);   cphi = cos(phi);

g = [...
   (W-B)*sth
  -(W-B)*cth*sphi
  -(W-B)*cth*cphi
  -(r_g(2)*W-r_b(2)*B)*cth*cphi + (r_g(3)*W-r_b(3)*B)*cth*sphi
   (r_g(3)*W-r_b(3)*B)*sth      + (r_g(1)*W-r_b(1)*B)*cth*cphi
  -(r_g(1)*W-r_b(1)*B)*cth*sphi + (r_g(2)*W-r_b(2)*B)*sth      ];