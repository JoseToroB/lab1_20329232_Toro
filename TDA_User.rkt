#lang scheme
;
(provide (all-defined-out))
;
;TDA USUARIO
;el TDA usuario tiene los siguientes elementos
;(nickname(string) password(string) publicaciones(LISTA DE  IDS/ENTEROS) fechaRegistro(string)

;;Funcion crearUser
;DOM ;string X string 
;REC ;TDA usuario
(define (crearUser User pass publicaciones fecha)
  (if (and (string? User) (or(string? pass)(number? pass)) (list? publicaciones) (string? fecha))
      (list User pass publicaciones fecha)
      #f
      )
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;Selectores

;funcion getNick
;dom; lista
;rec: string
;dada una lista"usuario" entrega el primer valor "nickname"
(define getNick(lambda (lista)
                            (car lista)
                    )
  )
;funcion getPass
;dom; lista
;rec: string
;dada una lista"usuario" entrega el valor "pass"
(define getPass(lambda (lista)
                            (car(cdr lista))
                    )
  )
;funcion getPublicaciones
;dom; lista
;rec: string
;dada una lista"usuario" entrega la lista de publicaciones
(define getPublicaciones(lambda (lista)
                            (car(cddr lista))
                    )
  )
;funcion getFechaRegistro
;dom; lista
;rec: string
;dada una lista"usuario" entrega el valor "fecha registro"
(define getFechaRegistro(lambda (lista)
                            (car(cdddr lista))
                    )
  )
;;;;;;;;; funciones extra ;;;;;;;

;;funcion para buscar un elemento "usuario" dentro de una lista "lista de usuarios"
;dom: string X lista
;rec: lista
;utiliza recursion
(define (buscarUserPass buscado lista)
   (if (null? lista)
       #f
       (if (equal? (car(car lista)) buscado)
           (car lista)
           (buscarUserPass buscado (cdr lista))
           )
       )
  )

