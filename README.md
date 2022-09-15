
# DampRR.jl

[![Build Status](https://travis-ci.com/DampRR/DampRR.jl.svg?branch=master)](https://travis-ci.com/DampRR/DampRR.jl)

This package contains various tools based on the damped rank-reduction (DRR) method.

At the moment, it is updated and tested against Julia v1.

## Installation

To use this package you must first install the [Julia](http://julialang.org/downloads/) programming language.
Then, run the Julia application and type, at the prompt

```
julia>using Pkg
julia>Pkg.add(PackageSpec(url="https://github.com/chenyk1990/DampRR.jl.git"))
julia>using DampRR
```

If you use the DampRR project, please cite the following paper
```
@Article{huang2016dmssa,
  author={Weilin Huang and Runqiu Wang and  Yangkang Chen and Huijian Li and Shuwei Gan},
  title = {Damped Multichannel Singular Spectrum Analysis for 3{D} Random Noise Attenuation },
  journal={Geophysics},
  year=2016,
  volume=81,
  issue=4,
  number=4,
  pages={V261-V270},
}

@article{chen2016drr5d,
  title={Simultaneous denoising and reconstruction of 5{D} seismic data via damped rank-reduction method},
  author={Yangkang Chen and Dong Zhang and Zhaoyu Jin and Xiaohong Chen and Shaohuan Zu and Weilin Huang and Shuwei Gan},
  journal={Geophysical Journal International},
  volume={206},
  number={3},
  issue={3},
  pages={1695-1717},
  year={2016}
}

@article{chen2016drr3d,
  title={An open-source Matlab code package for improved rank-reduction 3{D} seismic data denoising and reconstruction},
  author={Yangkang Chen and Dong Zhang and Weilin Huang and Wei Chen},
  journal={Computers \& Geosciences},
  volume={95},
  pages={59-66},
  year={2016}
}
```

## Basic usage

The following example produces the figure below.

```Julia
using DampRR,Random,Statistics,PyPlot

## Create planar synthetic data
d0=planar3d();

## add noise
(n1,n2,n3)=size(d0)
Random.seed!(20212223)
n=0.2*randn(n1,n2,n3)
dn=d0+n;

## Denoising
d1=drr3d(dn,0,120,0.004,3,100,1);	#RR
noi1=dn-d1;
d2=drr3d(dn,0,120,0.004,3,3,1);	#DRR
noi2=dn-d2;

## Plotting results and comparison
subplot(141)
pcolormesh(d0[:,:,10]);
subplot(142)
pcolormesh(dn[:,:,10]);
subplot(143)
pcolormesh(d1[:,:,10]);
subplot(144)
pcolormesh(d2[:,:,10]);
show()
```

