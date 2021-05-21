#lang scheme
;
(require "TDA_RS.rkt")
(require "TDA_User.rkt")
;importo TDA_USER ya que utilizo funciones que estan almacenadas en el tda de usuarios 
(provide (all-defined-out))
;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;aqui empieza el TDA Publicacion
;id(int) , contenidoCompartido(string) ,tipoDato(string), fecha (string), lista de ids(de respuestas), reacciones("likes" int),Publicador(nick string)
;constructor
;entran varios datos
;sale una lista del tipo del TDA si esque los datos son validos
(define crearPublicacion(lambda(id contenidoCompartido tipoDato fecha ListaRespuestas likes autor)
                          (if (esPublicacion id contenidoCompartido tipoDato fecha ListaRespuestas likes autor)
                              (list id contenidoCompartido tipoDato fecha ListaRespuestas likes autor)
                              #f
                              )
                          ))

;pertenencia
;entran varios datos
;retorna un bool
(define esPublicacion(lambda(id contenidoCompartido tipoDato fecha ListaRespuestas likes autor)
                       (if (and (number? id)(string? contenidoCompartido)(string? tipoDato )(string? fecha) (list? ListaRespuestas) (number? likes) (string? autor) )
                           #t
                           #f
                           )
                       )
  )

;selectores publicacion
(define getIDPublicacion(lambda (publicacion)
                          (car publicacion)
                          )
  )
(define getConCompPublicacion(lambda (publicacion)
                          (car(cdr publicacion))
                          )
  )
(define getTipoDatPublicacion(lambda (publicacion)
                          (car(cdr(cdr publicacion)))
                          )
  )
(define getFechaPublicacion(lambda (publicacion)
                          (car(cdr(cdr(cdr publicacion))))
                          )
  )
(define getRespuestasPublicacion(lambda (publicacion)
                          (car(cdr(cdr(cdr(cdr publicacion)))))
                          )
  )
(define getLikesPublicacion(lambda (publicacion)
                          (car(cdr(cdr(cdr(cdr(cdr publicacion))))))
                          )
  )
(define getAutorPublicacion(lambda (publicacion)
                          (car(cdr(cdr(cdr(cdr(cdr(cdr publicacion)))))))
                          )
  )
;

;esta funcion une dos elementos que esten dentro de listas
(define unirLista(lambda (x y)
    (if (null? x);si la primera lista esta vacia retorno el segundo 
        (cons y null)
        (cons (car x) (unirLista (cdr x) y));si la primera lista no es vacia, hago car y cdrs para concatenar por partes
        )
    )
  )
;
;;funcion para buscar un elemento "publicacion" mediante su id (entero),dentro de una lista de publicaciones
;dom: string X lista
;rec: lista(tda publicacion)
;utiliza recursion
(define (buscarPublicacionPorId ID lista)
   (if (null? lista)
       #f
       (if (equal? (car (car lista)) ID)
           (car lista)
           (buscarPublicacionPorId ID (cdr lista))
           )
       )
  )
;;esta funcion obtiene la posicion de una pregunta mediante su ID
;dom: lista x string x entero
;rec: entero
;recursion natural
;esta funcion es utilizada por la funcion remover
(define obtenerPosPublicacion(lambda (lista ID pos)
                   (if (equal? (getIDPublicacion (car lista)) ID)
                      pos
                     (obtenerPosPublicacion (cdr lista) ID (+ pos 1))
                       )
                    )
  )  
