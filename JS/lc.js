var zero = function (f) {
    return function (x) {
        return x;
    }
};

var one = function (f) {
    return function (x) {
        return f(x)
    };
}

var two = function (f) {
    return function (x) {
        return   f(f(x));
    };
}

var three = function (f) {
    return function (x) {
        return f(f(f(x)));
    };
}

//0 = λf.λx.x
//1 = λf.λx.f x
//2 = λf.λx.f (f x)
//3 = λf.λx.f (f (f x))
//lambda演算中的数字n就是一个把函数f作为参数并以f的n次幂为返回值的函数。换句话说，邱奇整数是一个高阶函数 -- 以单一参数函数f为参数，返回另一个单一参数的函数。

var print = function (expr) {
    console.log(expr(function (n) {
        return 1 + n
    })(0));
};

print(zero);
print(one);
print(two);
print(three);

//SUCC = λn.λf.λx.f(n f x)
var succ = function (n) {
    return function (f) {
        return function (x) {
            return f(n(f)(x));
        };
    };
};

console.log("one add one is: ");
print(succ(one));

//PLUS := λm.λn.λf.λx.m f (n f x)
var plus = function (m) {
    return function (n) {
        return function (f) {
            return function (x) {
                return m(f)(n(f)(x));
                ;
            };
        };
    };
};

console.log("two plus three is: ");
print(plus(two)(three));

//TRUE := λx.λy.x
//FALSE := λx.λy.y

var true_ = function (x) {
};