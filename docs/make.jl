using Pkg; Pkg.add("Documenter")
using Documenter, DampRR

makedocs(
    sitename = "DampRR.jl",
    format = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true"),
    modules = [DampRR],
    pages = [
        "Home" => "index.md",
	"Library" => Any[
			"Public" => "lib/public.md",
],
],
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.

deploydocs(
	repo = "github.com/chenyk1990/DampRR.jl.git",
        target = "build",
	deps = nothing,
	make = nothing
)
