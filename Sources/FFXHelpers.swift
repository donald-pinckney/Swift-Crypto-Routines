func num(_ X: [UInt], forRadix: UInt) -> UInt {
    var sum: UInt = 0
    for x in X {
        sum = sum * forRadix + x
    }
    return sum
}

func num(_ X: [UInt], forRadix: Int) -> UInt {
    precondition(forRadix >= 0)
    return num(X, forRadix: UInt(forRadix))
}


func str(num: UInt, forRadix: Int, length m: Int) -> [UInt] {
    let r = UInt(forRadix)
    var x = num
    var X = [UInt](repeating: 0, count: m)
    for i in 1...m {
        X[m-i] = x % r
        x = x / r
    }
    return X
}
