#lang scheme
;
(provide (all-defined-out))
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; la red social tiene la siguiente forma
;( NombreRS(string) fecha(string) funcionEncriptar  funcionDesencriptar ID_UltimaPublicacion(entero) (lista de publicaciones)  ID_UltimaRespuesta(entero) (lista de respuestas) (lista de Usuarios) )
;donde los primeros dos parametros son correspondientes de la red social
;;;;;;;;;;;;;;;;;;;;;;;;;
;tda red social

;constructores
(define socialnetwork(lambda (name date encryptFunction decryptFunction)
                        (if (and (string? name) (equal? date ""));verifico que la fecha sea valida 
                            #f;si no es valida retorno F
                            (list name date encryptFunction decryptFunction 0 (list) 0 (list) (list) );si es valida creo la RS
                            )
                        )
  )

;selectores
;NombreRS(string)    
(define (getNombreRS RS)
  (car RS);entrego el nombre de la rs
  )
;;
;fecha(string) /como esta fecha solo representa la fecha de creacion de la RS no creare un selector
;funcionEncriptar /para las funciones de enciptar y desencriptar tampoco creare un selector
;funcionDesencriptar
;;
; ID_UltimaPublicacion(entero)
(define (ID_UltimaPregunta->RS RS)
  (car (cdr (cdr (cdr RS))))
  )
;(lista de publicaciones)
(define (getPreguntas->RS RS)
  (car (cdr (cdr (cdr (cdr RS)))))
  )
; ID_UltimaRespuesta(entero)
(define (ID_UltimaRespuesta->RS RS)
  (car (cdr (cdr (cdr (cdr (cdr RS))))))
  )
; (lista de respuestas) 
(define (getRespuestas->RS RS)
  (car (cdr (cdr (cdr (cdr (cdr (cdr RS)))))))
  )
 ;(lista de Usuarios)
(define (getUSUARIOS->RS RS)
  (car (cdr (cdr (cdr (cdr (cdr (cdr (cdr RS))))))))
  )
;;;;;;;;;;;;;;;;;;;;;
