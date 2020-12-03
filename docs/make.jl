using ErrorFlow
using Documenter

makedocs(;
    modules=[ErrorFlow],
    authors="Jan Weidner <jw3126@gmail.com> and contributors",
    repo="https://github.com/jw3126/ErrorFlow.jl/blob/{commit}{path}#L{line}",
    sitename="ErrorFlow.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://jw3126.github.io/ErrorFlow.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/jw3126/ErrorFlow.jl",
)
