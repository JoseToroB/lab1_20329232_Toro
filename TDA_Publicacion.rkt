#lang scheme
;
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
