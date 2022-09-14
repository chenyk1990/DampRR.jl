
function planar3d()
## generate the synthetic data
a1=zeros(300,20)
n=size(a1,1)
m=size(a1,2)
a3=zeros(300,20)
a4=zeros(300,20)

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

for k in range(1,length(ts))
	t=ts[k]
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
return d0
end

