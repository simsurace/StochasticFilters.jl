using StochasticFiltering
using Documenter

DocMeta.setdocmeta!(StochasticFiltering, :DocTestSetup, :(using StochasticFiltering); recursive=true)

makedocs(;
    modules=[StochasticFiltering],
    authors="Simone Carlo Surace",
    repo="https://github.com/simsurace/StochasticFiltering.jl/blob/{commit}{path}#{line}",
    sitename="StochasticFiltering.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)
