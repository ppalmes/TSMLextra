module TestCaret
using TSML
using TSMLextra
using Test

const IRIS = getiris()
const X = IRIS[:,1:4] |> DataFrame
const Y = IRIS[:,5] |> Vector

const XX = IRIS[:,1:1] |> DataFrame
const YY = IRIS[:,4] |> Vector

#const learners=["rf","treebag","svmRadialWeights","pls","svmLinear","bagFDA","rpart"]
const learners=["rf"]

function test_caret_fit(learner::String)
    #crt = CaretLearner(Dict(:learner=>learner,:fitControl=>"trainControl(method='cv')"))
    @info learner
    crt = CaretLearner(Dict(:learner=>learner))
    fit!(crt,X,Y)
    @test crt.model != nothing
end

function test_caret_transform(learner::String)
    #crt = CaretLearner(Dict(:learner=>learner,:fitControl=>"trainControl(method='cv')"))
    @info learner
    crt = CaretLearner(Dict(:learner=>learner))
    fit!(crt,X,Y)
    @test sum(transform!(crt,X) .== Y)/length(Y) > 0.10
end

if !Sys.islinux() # bug in travis using old linux and R versions
    @testset "caret training classifiers" begin
	for lrn in learners
	    test_caret_fit(lrn)
	end
    end

    @testset "caret prediction classifiers" begin
	for lrn in learners
	    test_caret_transform(lrn)
	end
    end
end

end
