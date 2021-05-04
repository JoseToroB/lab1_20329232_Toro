#lang racket
;
(provide (all-defined-out))
;
;una fecha es un string compuesto por 3 numeros enteros
;los cuales se revisa que cumplan con las fechas del calendario gregoriano
;se representa mediante un string de la forma "DD/MM/YY"

;CONSTRUCTOR
;funcion que crea una fecha
;dom: entero X entero X entero
;rec: string
(define (fecha d m a)
  (if (and (integer? d) (integer? m) (integer? a)
           (> d 0) (> m 0) (< m 13) (not (= a 0))
           (<=  d (getDiasDelMes m a)))
      (string-append (number->string d) "/" (number->string m) "/" (number->string a))
      ""
  )
)

;revisa si un year es bisisesto
;dom: entero
;rec: boolean
(define (bisiesto? a)
  (if (and (integer? a) (not (= a 0)))
      (or (= (remainder a 400) 0)
              (and (= (remainder a 4) 0) (not (= (remainder a 100) 0))))
      #f
  )
)

;determina los dias que tiene el mes
;dom: entero X entero
;rec: entero
(define (getDiasDelMes m a)
  (if (and (integer? m) (integer? a) (not (= a 0))
           (> m 0) (< m 13))
           (if (or (= m 1) (= m 3) (= m 5) (= m 7) (= m 8) (= m 10) (= m 12))
                31
                (if (= m 2)
                    (if (bisiesto? a)
                        29
                        28
                    )
                    30
                )
            )
           0
   )
 )
