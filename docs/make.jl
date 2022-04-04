using StochasticFilters
using Documenter

DocMeta.setdocmeta!(StochasticFilters, :DocTestSetup, :(using StochasticFilters); recursive=true)

makedocs(;
    modules=[StochasticFilters],
    authors="Simone Carlo Surace",
    repo="https://github.com/simsurace/StochasticFilters.jl/blob/{commit}{path}#{line}",
    sitename="StochasticFilters.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)
