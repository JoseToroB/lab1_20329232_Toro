#lang scheme
;
(require "TDA_RS.rkt")
(require "TDA_User.rkt")
(provide (all-defined-out))
;
;importo el tda user ya que ahi se encuentran las funciones unir y remover
;TDA RESPUESTAS
;(define RespuestaStandar (list ID(number) autor(string) respuesta(string)  formatoResp(string) likes(number) fecha(string))

;constructor
(define crearRespuesta( lambda (id autor respuesta formatoResp likes fecha)
                         (if (esResp id autor respuesta formatoResp likes fecha)
                             (list id autor respuesta formatoResp likes fecha)
                             #f
                             )
                         )
  )
  
;pertenencia
(define esResp(lambda(id autor respuesta formatoResp likes fecha)
                (if (and (number? id)(string? autor)(string? respuesta)(string? formatoResp)(number? likes)(string? fecha))
                    #t
                    #f
                    )
                )
)

;selectores del TDA respuesta
;(list ID_respuesta autor "respuesta" "fecha respuesta" "si/no" votosPos votosNeg)
(define (getID_Respuesta respuesta)
  (car respuesta);la id de una respuesta es el 1er elemento de la lista pregunta
  )
(define (getAutor_Respuesta respuesta)
  (car (cdr respuesta));el autor es el 2do elemento de la lista pregunta
  )
(define (getRespuesta_Respuesta respuesta)
  (car (cddr respuesta));la respuesta es el 3er elemento de la lista pregunta
  )
(define (getFormato_Respuesta respuesta)
  (car (cdddr respuesta));la fecha es el 4to elemento de la lista pregunta
  )
(define (getLikes_Respuesta respuesta)
  (car (cdddr (cdr respuesta)));el estado es el 5to elemento de la lista pregunta
  )
(define (getFecha_Respuesta respuesta)
  (car (cdddr (cddr respuesta)));la lista de etiquetas es el 6to elemento de la lista pregunta
  )
;;;;;;;;;;

