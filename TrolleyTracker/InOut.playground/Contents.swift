//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

var mutableVar = 0

func testing(inout test: Int) {
    test++
}

var aVar = 1
print(aVar)
testing(&aVar)
print(aVar)

print(mutableVar)
