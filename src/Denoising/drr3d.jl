"""
    drr3d(in;<keyword arguments>)

	DRR3D: 3D damped rank-reduction method for denoising

# Arguments
- `in`: input data that can have up to 5 dimensions. Time is in the first dimension.

"""
# import FFTW
# using FFTW,LinearAlgebra,ToeplitzMatrices
function drr3d(D, flow=1, fhigh=124, dt=0.004, N=1, K=3, verb=0)

# 	using FFTW,LinearAlgebra,ToeplitzMatrices,Printf
	
	(nt,nx,ny)=size(D)
	
	nf=nextpow(2,nt);
	nf=Int(nf)
	
	D1=zeros(nf,nx,ny)
	D1[1:nt,:,:]=D;
	D=D1;
	
	#Transform into F-X domain
	DATA_FX=fft(D,1);
	DATA_FX0=zeros(ComplexF32,nf,nx,ny) ##Note, only ComplexF32/64 works
	
	#First and last nts of the DFT.
	ilow=floor(flow*dt*nf)+1;
	if ilow<1
		ilow=1;
	end
	
	ihigh = floor(fhigh*dt*nf)+1;
	if ihigh>floor(nf/2)+1
		ihigh=floor(nf/2)+1;
	end
	
	ilow=Int(ilow)
	ihigh=Int(ihigh)

	lx=Int(floor(nx/2)+1);
	lxx=nx-lx+1;
	ly=Int(floor(ny/2)+1);
	lyy=ny-ly+1;
	M=zeros(ComplexF32,lx*ly,lxx*lyy);
	
	#main loop
	for k in ilow:ihigh
		M=P_H(DATA_FX[k,:,:],lx,ly); 
# 		print(DATA_FX)
		M=P_RD(M,N,K);
		DATA_FX0[k,:,:]=P_A(M,nx,ny,lx,ly);
	
		if mod(k,5) == 0 && verb==1
# 			@printf("F %d is done!\n\n",k);
			println("F ",k, " is done!\n")
		end
	
	end
	
	for k in Int(nf/2)+2:nf
		DATA_FX0[k,:,:] = conj(DATA_FX0[nf-k+2,:,:]);
	end
	
	#Back to TX (the output)
	print(typeof(DATA_FX0))
	
	D1=real(ifft(DATA_FX0,1));
	D1=D1[1:nt,:,:];
	
	return D1
end

function P_H(din,lx,ly)
# forming block Hankel matrix
	(nx,ny)=size(din);
	lxx=nx-lx+1;
	lyy=ny-ly+1;
	dout=zeros(ComplexF32,lx*ly,lxx*lyy);
	
	for j in 1:ny
		r=Hankel(din[1:lx,j],din[lx:nx,j]);
		if j<ly
			for id in 1:j
				dout[(j-1)*lx-(id-1)*lx+1:j*lx-(id-1)*lx,(id-1)*lxx+1:lxx+(id-1)*lxx]=r;
			end
		else
			for id in 1:ny-j+1

				dout[(ly-1)*lx-(id-1)*lx+1:ly*lx-(id-1)*lx,(j-ly)*lxx+(id-1)*lxx+1:(j-ly+1)*lxx+(id-1)*lxx]=r;
			end
		end
	end
	return dout
end

function P_RD(din,N,K)
# Rank reduction on the block Hankel matrix
	(U,D,V)=svd(din);
	if K<=20 #RR
		for j in 1:N
			D[j] = D[j]*(1-D[N+1]^K/(D[j]^K+0.000000001));
		end
	end
	dout=U[:,1:N]*diagm(D[1:N])*V[:,1:N]';
	return dout
end

function P_A(din,nx,ny,lx,ly)
# Averaging the block Hankel matrix to output the result
	lxx=nx-lx+1;
	lyy=ny-ly+1;
	
	dout = zeros(ComplexF32,nx,ny);
	for j in 1:ny
		if j<ly
			for id in 1:j
				dout[:,j] =dout[:,j]+ ave_antid(din[(j-1)*lx-(id-1)*lx+1:j*lx-(id-1)*lx,(id-1)*lxx+1:lxx+(id-1)*lxx])/j;
			end
		else
			for id in 1:ny-j+1
				dout[:,j] =dout[:,j]+ ave_antid(din[(ly-1)*lx-(id-1)*lx+1:ly*lx-(id-1)*lx,(j-ly)*lxx+(id-1)*lxx+1:(j-ly+1)*lxx+(id-1)*lxx])/(ny-j+1);
			end
		end
	end
	return dout
end

function ave_antid(din)
# averaging along antidiagonals
	(n1,n2) = size(din);
	nout=n1+n2-1;
	dout = zeros(ComplexF32, nout, 1);
	
	for i in 1:nout
		if i<n1
			for id in 1:i
				dout[i]=dout[i] + din[i-(id-1),id]/i;
			end
		else
			for id in 1:nout+1-i
				dout[i]=dout[i] + din[n1-(id-1),(i-n1)+id]/(nout+1-i); 
			end
		end
	end
	return dout
end







