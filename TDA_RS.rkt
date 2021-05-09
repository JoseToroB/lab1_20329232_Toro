#lang scheme
;
(provide (all-defined-out))
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; la red social tiene la siguiente forma
;( ID_UltimaPublicacion(entero) (lista de publicaciones)  ID_UltimaRespuesta(entero) (lista de respuestas) (lista de Usuarios) )
;;;;;;;;;;;;;;;;;;;;;;;;;
;tda red social

;constructores
(define (CrearRSvacia)
  (CrearStack 0 (list) 0 (list) (list) );esto crea una red social vacia
  )
;esta funcion crea  con los parametros ingresados
(define (CrearRS ID_ultimaPublicacion publicaciones ID_UltimaRespuesta respuestas usuarios)
  (list ID_ultimaPublicacion publicaciones ID_UltimaRespuesta respuestas usuarios);
  );cierre define

;selectores
(define (ID_UltimaPregunta->RS RS)
  (car RS);el id de la ultima pregunta es el primer elemento de la RS
  )
(define (getPreguntas->RS RS)
  (car (cdr RS));ya que las preguntas estan en la segunda posicion
  )
(define (ID_UltimaRespuesta->RS RS)
  (car(cddr RS));el id de la ultima pregunta es el tercer elemento
  )
(define (getRespuestas->RSRS)
  (car(cdddr RS));las respuestas(replicas a publicaciones) estan en la 4ta posicion
  )
(define (getUSUARIOS->RS RS)
 (car(cddddr RS));el usuario es la 5ta posicion
  )
;;;;;;;;;;;;;;;;;;;;;

;modificadores AUN FALTA DEFINIR VARIOS MODIFICADORES PERO ESTE ES EL FORMATO STANDAR X AHORA
;esta funcion modifica un parametro
(define (setParametro->RS RS modiciar)
  (CrearRS
   (ID_UltimaPregunta->stack stack)
   (getPreguntas->stack stack)
   (ID_UltimaRespuesta->stack stack)
   (getRespuestas->stack stack)
   (getUSUARIOS->stack stack)
   );esto crea una RS practicamente igual a la que entra como parametro solo que modifica un parametro
  );cierre define
