using Test
using ErrorFlow

@testset "@catch" begin
    err = @catch error("oh no")
    @test err.value == ErrorException("oh no")
    @test err.hints == []

    err = @catch error("oh no") "bad"
    @test err.value == ErrorException("oh no")
    @test err.hints == ["bad"]
end


@testset "@chain example" begin
    msg_fail_load_config = "Failed to load config"
    msg_fail_parse_config = "Failed to parse config"

    app(succeed) = @chain load_config(succeed) msg_fail_load_config
    load_config(succeed) = @chain parse_line157(succeed) msg_fail_parse_config
    function parse_line157(succeed)
        if succeed
            return 42
        else
            error("Cannot parse line 157")
        end
    end

    @test app(true) == 42
    @inferred Union{Int, Error} app(true)
    err = app(false)
    @test err.value == ErrorException("Cannot parse line 157")
    s = sprint(showerror, err)
    @test occursin(msg_fail_load_config, s)
    @test occursin(msg_fail_parse_config, s)
    @test occursin("parse_line157", s)
end
