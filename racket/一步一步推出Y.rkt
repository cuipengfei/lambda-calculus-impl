#lang racket

;第一个版本，直接递归
(define (fac1 n)
  (if (< n 2) 1
      (* n (fac1 (- n 1)))))
(fac1 5)

;第二个版本，把自己传进去
(define (fac2 f n)
  (if (< n 2) 1
      (* n (f f (- n 1)))))
(fac2 fac2 5)

;第三个版本，还是把自己传进去，每次调用(fac3 fac3)或者是(f f)得到的都是同一个结果：接受一个n作为参数的lambda
(define (fac3 f)
  (lambda (n) 
    (if (< n 2) 1
        (* n ((f f) (- n 1))))))
((fac3 fac3) 5)

;第四个版本和第三个版本本质上一样，只是通过引入g，把(f f)替换成了g
(define (fac4 f)
  (define (g n) ((f f) n))
  (lambda (n)
    (if (< n 2) 1
        (* n (g (- n 1))))))
((fac4 fac4) 5)

;第五个版本，引入recur，这里，recur接受的lambda其实就是fac4。调用(recur fac4)的效果和调用(fac4 fac4)是一样的
(define (recur f) (f f))
(define fac5 (recur (lambda (f) 
                      (define (g n) ((f f) n))
                      (lambda (n)
                        (if (< n 2) 1
                            (* n (g (- n 1))))))))
(fac5 5)

;第六版，在第五版的基础上消除掉g，原来g是显式定义的，现在增加了一个接收itself的lambda，来把g作为参数传进去
(define fac6 (recur (lambda (f) 
                      ((lambda (itself)
                         (lambda (n)
                           (if (< n 2) 1
                               (* n (itself (- n 1)))))) 
                       (lambda (n) ((f f) n))
                       ))))
(fac6 5)

;第七版，第六版传给了recur很大一坨lambda，现在把这个很大的一坨lambda分成两块，也就是把原本接受itself的那个lambda抽出来，给它一个名字，叫做fake_fac
(define (fake_fac self) 
  (lambda (n) 
    (if (< n 2) 1
        (* n (self (- n 1))))))

(define fac7 (recur (lambda (f) 
                      (fake_fac 
                       (lambda (n) ((f f) n))))))
(fac7 5)

;第八版，从第七版的基础上消除掉对recur的调用，第七版是调用recur，给recur传递一坨lambda，第八版就是把recur直接写成一个lambda，给它传递那坨lambda
(define fac8 ((lambda (g) (g g)) 
              (lambda (f) 
                (fake_fac 
                 (lambda (n) ((f f) n))))) )
(fac8 5)

;第九版。第八版里，Y基本已经成型了，只是fac8和fake_fac还是紧耦合的，现在把它抽到参数上去，叫做fake_recur，Y就出来了。
(define Y (lambda (fake_recur) 
            ((lambda (g) (g g)) 
             (lambda (f) 
               (fake_recur 
                (lambda (n) ((f f) n)))))))
((Y (lambda (self) 
      (lambda (n) 
        (if (< n 2) 1
            (* n (self (- n 1))))))) 5)