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

using DampRR
## generate the synthetic data
a1=zeros(300,20)
n=size(a1,1)
m=size(a1,2)
a3=zeros(300,20)
a4=zeros(300,20)

k=0;
a=0.1;
b=1;
pi=3.14159265359


ts=range(-0.055,0.055+0.002,step=0.002) #-0.055:0.002:0.057
b1=zeros(length(ts),1)
b2=zeros(length(ts),1)
b3=zeros(length(ts),1)
b4=zeros(length(ts),1)



println("n=",n," m=",m," pi=",pi)
print(ts,'\n')

for t in ts
	global k=k+1;
    b1[k]=(1-2*(pi*30*t)*(pi*30*t))*exp(-(pi*30*t)*(pi*30*t));
    b2[k]=(1-2*(pi*40*t)*(pi*40*t))*exp(-(pi*40*t)*(pi*40*t));
    b3[k]=(1-2*(pi*40*t)*(pi*40*t))*exp(-(pi*40*t)*(pi*40*t));
    b4[k]=(1-2*(pi*30*t)*(pi*30*t))*exp(-(pi*30*t)*(pi*30*t));
end
    
    
t1=zeros(Int,m,1,)
t3=zeros(Int,m,1)
t4=zeros(Int,m,1)
    

for i in 1:m
	t1[i]=round(140);
	t3[i]=round(-6*i+180);
	t4[i]=round(6*i+10);
	a1[t1[i]:t1[i]+k-1,i]=b1;
	a3[t3[i]:t3[i]+k-1,i]=b1;
	a4[t4[i]:t4[i]+k-1,i]=b1;
end
    
    
temp=a1[1:300,:]+a3[1:300,:]+a4[1:300,:]; 


shot=zeros(300,20,20);
for j in 1:20
	a4=zeros(300,20);
	for i in 1:m
		t4[i]=round(6*i+10+3*j);
		a4[t4[i]:t4[i]+k-1,i]=b1;
		t1[i]=round(140-2*j);
		a1[t1[i]:t1[i]+k-1,i]=b1;

	shot[:,:,j]=a1[1:300,:]+a3[1:300,:]+a4[1:300,:];
	end
end

d0=shot;

## add noise
(n1,n2,n3)=size(d0)
using Random, Statistics
Random.seed!(20212223)
n=0.2*randn(n1,n2,n3)
dn=d0+n;
println("data std=",std(dn))

# include("drr3d.jl")
d1=drr3d(dn,0,120,0.004,3,100,1);	#RR
noi1=dn-d1;


d2=drr3d(dn,0,120,0.004,3,3,1);	#DRR
noi2=dn-d2;


## compare SNR
# println('SNR of RR is %g'%drr_snr(d0,d1,2));
# println('SNR of DRR is %g'%drr_snr(d0,d2,2));

using PyPlot
subplot(141)
pcolormesh(d0[:,:,10]);

subplot(142)
pcolormesh(dn[:,:,10]);

subplot(143)
pcolormesh(d1[:,:,10]);

subplot(144)
pcolormesh(d2[:,:,10]);
show()




