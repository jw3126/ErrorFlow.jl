module ErrorFlow

export @catch
export @chain
export Error

struct Error
    value
    hints
    stacktrace
end

function Base.showerror(io::IO, err::Error)
    println(io, "Error:")
    Base.showerror(io, err.value)
    println(io)
    println(io)
    println(io, "Hints:")
    for (i, hint) in pairs(err.hints)
        print(io, i, ") ")
        println(io, hint)
    end
    Base.show_backtrace(
        io, err.stacktrace
    )
end

function append_hints(err::Error, hints)
    Error(err.value, [err.hints; hints], err.stacktrace)
end

macro chain(code, err)
    chain_macro(code, err)
end

macro var"catch"(code, hint=nothing)
    code = esc(code)
    if (hint === nothing)
        hints = []
    else
        hints = esc(:([$hint]))
    end
    quote
        try
            $code
        catch err
            st = $stacktrace($catch_backtrace())
            $Error(err, $hints, st)
        end
    end
end

function chain_macro(code, hint=nothing)
    code = esc(code)
    if (hint === nothing)
        hints = []
    else
        hints = esc(:([$hint]))
    end
    quote
        result = try
            $code
        catch err
            st = $stacktrace($catch_backtrace())
            ce = $Error(err, $hints, st)
            return ce
        end
        if result isa $Error
            return $append_hints(result, $hints)
        elseif result isa Exception
            st = $stacktrace($catch_backtrace())
            return $Error(result, $hints, st)
        else
            result
        end
    end
end

end
