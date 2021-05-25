#lang scheme
;
(provide (all-defined-out))
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; la red social tiene la siguiente forma
;( NombreRS(string) fecha(string) funcionEncriptar  funcionDesencriptar ID_UltimaPublicacion(entero) (lista de publicaciones)  ID_UltimaRespuesta(entero) (lista de respuestas) (lista de Usuarios) userOn(string nick) cantidadUsers(number) )
;donde los primeros dos parametros son correspondientes de la red social
;;;;;;;;;;;;;;;;;;;;;;;;;
;tda red social

;constructores

;
(define socialnetwork(lambda (name date encryptFunction decryptFunction)
                        (if (and (string? name) (equal? date ""));verifico que la fecha sea valida 
                            #f;si no es valida retorno F
                            (construirRS name date encryptFunction decryptFunction 0 (list) 0 (list) (list) "" 0);si es valida creo la RS desde 0
                            )
                        )
  )
;este constructor es solo conocido por el programador por ende es un constructor de apoyo utilizado en socialnetwork
(define construirRS(lambda (name date encryptFunction decryptFunction ID_UltimaPublicacion ListaPublicaciones ID_ultimaRespuesta ListaResp Lista_usarios online CantUsers)
                     (list name date encryptFunction decryptFunction ID_UltimaPublicacion ListaPublicaciones ID_ultimaRespuesta ListaResp Lista_usarios online CantUsers)
                     )
  )


;
;selectores
;NombreRS(string)    
(define (getNombreRS RS)
  (car RS);entrego el nombre de la rs
  )
;fecha(string) 
(define (getFechaRS RS)
  (car (cdr RS))
  )
;funcionEncriptar
(define (getEncriptar RS)
  (car (cdr (cdr RS)))
  )
;funcionDesencriptar
(define (getDesencript RS)
  (car (cdr (cdr (cdr RS))))
  )
; ID_UltimaPublicacion(entero)
(define (ID_UltimaPregunta->RS RS)
  (car (cdr (cdr (cdr (cdr RS)))))
  )
;(lista de publicaciones)
(define (getPublicaciones->RS RS)
  (car (cdr (cdr (cdr (cdr (cdr RS))))))
  )
; ID_UltimaRespuesta(entero)
(define (ID_UltimaRespuesta->RS RS)
  (car (cdr (cdr (cdr (cdr (cdr (cdr RS)))))))
  )
; (lista de respuestas) 
(define (getRespuestas->RS RS)
  (car (cdr (cdr (cdr (cdr (cdr (cdr (cdr RS))))))))
  )
 ;(lista de Usuarios)
(define (getUSUARIOS->RS RS)
  (car (cdr (cdr (cdr (cdr (cdr (cdr (cdr (cdr RS)))))))))
  )
;userON
(define (getOnline->RS RS)
  (car (cdr (cdr (cdr (cdr (cdr (cdr (cdr (cdr (cdr RS))))))))))
  )
;cantUsers
(define (getCantUsers->RS RS)
  (car (cdr (cdr (cdr (cdr (cdr (cdr (cdr (cdr (cdr (cdr RS)))))))))))
  )
;;;;;;;;;;;;;;;;;;;;;
