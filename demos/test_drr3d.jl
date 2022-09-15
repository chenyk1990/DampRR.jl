#  DEMO script (Julia version) for DRR
#  
#  Copyright (C) 2022 Yangkang Chen
#  
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published
#  by the Free Software Foundation, either version 3 of the License, or
#  any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details: http://www.gnu.org/licenses/
#  
## generate synthetic data
#This synthetic data was used in Huang et al., 2016, Damped multichannel singular spectrum analysis for 3D random noise attenuation, Geophysics, 81, V261-V270.

using DampRR,Random, Statistics, PyPlot

d0=planar3d();

## add noise
(n1,n2,n3)=size(d0)

Random.seed!(20212223)
n=0.2*randn(n1,n2,n3)
dn=d0+n;
println("data std=",std(dn))

d1=drr3d(dn,0,120,0.004,3,100,1);	#RR
noi1=dn-d1;


d2=drr3d(dn,0,120,0.004,3,3,1);	#DRR
noi2=dn-d2;

## compare SNR
# println('SNR of RR is %g'%drr_snr(d0,d1,2));
# println('SNR of DRR is %g'%drr_snr(d0,d2,2));

subplot(141)
pcolormesh(d0[:,:,10]);

subplot(142)
pcolormesh(dn[:,:,10]);

subplot(143)
pcolormesh(d1[:,:,10]);

subplot(144)
pcolormesh(d2[:,:,10]);
show()




