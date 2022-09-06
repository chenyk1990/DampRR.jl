
# DampRR.jl

[![Build Status](https://travis-ci.com/DampRR/DampRR.jl.svg?branch=master)](https://travis-ci.com/DampRR/DampRR.jl)

This package contains Reconstruction tools for DampRR project.

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
@Article{weilin2016dmssa,
  author={Weilin Huang and Runqiu Wang and  Yangkang Chen and Huijian Li and Shuwei Gan},
  title = {Damped Multichannel Singular Spectrum Analysis for 3{D} Random Noise Attenuation },
  journal={Geophysics},
  year=2016,
  volume=81,
  issue=4,
  number=4,
  pages={V261-V270},
}
```
 
## Basic usage

The following example produces the figure below.

```Julia
using SeisPlot,PyPlot, DampRR, SeisProcessing

# Create linear events
d = SeisLinearEvents(p1 = [-.001, 0.0015],tau=[1, 1/3],dx1=5); 

#Randomly decimate, perc=80 means that 80% of the bins are empty
deci = SeisDecimate(d;perc=80);

param = Dict(:Niter=>100,:fmax=>60,:padt=>2,:padx=>2,:dt=>0.004)
dpocs = SeisPOCS(deci;param...);

subplot(121)
SeisPlotTX(deci,cmap="seismic",fignum=1,pclip=200,title="Decimated data")
subplot(122)
SeisPlotTX(dpocs[:,:,1,1,1],cmap="seismic",fignum=1,pclip=200,title="After POCS")
```
