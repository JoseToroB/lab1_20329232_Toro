#lang scheme
;
(provide (all-defined-out))
;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;aqui empieza el TDA Publicacion
;id(int) , contenidoCompartido(string) ,tipoDato(string), fecha (string), lista de ids(de respuestas), reacciones("likes" int),Publicador(nick string), etiquetados(strings)
;constructor
;entran varios datos
;sale una lista del tipo del TDA si esque los datos son validos
(define crearPublicacion(lambda(id contenidoCompartido tipoDato fecha ListaRespuestas likes autor etiquetados)
                          (if (esPublicacion id contenidoCompartido tipoDato fecha ListaRespuestas likes autor)
                              (list id contenidoCompartido tipoDato fecha ListaRespuestas likes autor etiquetados)
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
(define getEtiquetados(lambda (publicacion)
                          (car(cdr(cdr(cdr(cdr(cdr(cdr (cdr publicacion))))))))
                          )
  )
;FUNCIONES EXTRA
;busco una publicacion en la lista de publicaciones 
;dom: numb(id) x lista
;rec: lista(publicacion)
(define (buscarPublicacionID ID lista)
   (if (null? lista)
       #f
       (if (equal? (car(car lista)) ID)
           (car lista)
           (buscarPublicacionID  ID (cdr lista))
           )
       )
  )
(define etiquetadosAstringPubli(lambda (et)
                                 (if (null? et)
                                     ""
                                     (string-append (car et) (etiquetadosAstringPubli (cdr et)))
                                     )
                                  )
  )
;transoforma una publicacion a un string
;publicacionAstring
;dom list x func
;rec string
;(list id contenidoCompartido tipoDato fecha ListaRespuestas likes autor etiquetados)
(define publicacionAstring(lambda(publi formato)
                            (string-append
                             "ID: "(number->string(getIDPublicacion publi))" "
                             "Autor: "(getAutorPublicacion publi)" "
                             "Fecha Publicacion: "(getFechaPublicacion publi)"\n"
                             "Tipo de Publicacion: " (formato(getTipoDatPublicacion publi))" "
                             (if (null?(getEtiquetados publi))
                                 ""
                                 (string-append "Etiquetados: "(etiquetadosAstringPubli(getEtiquetados publi))"\n")
                                 )
                             (formato(getConCompPublicacion publi))
                             ;likes?
                             ;likes
                            )
                            )
  )
;concatena varios string publicacion
;publicacionesAString
;dom List x list x func
;rec string
(define publicacionesAStringUser(lambda (formato ListaPublicacionesRS ListaIDPubli )
                              (if (null? ListaIDPubli)
                                  "\n"
                                  (string-append
                                   (publicacionAstring (buscarPublicacionID (car ListaIDPubli) ListaPublicacionesRS ) formato )
                                   (publicacionesAStringUser formato ListaPublicacionesRS (cdr ListaIDPubli))
                                   )
                                  )

                              )
  )
;convierte una publicacion en un tipo de publicacion compartida(string)
;dom list x string x list x func
;rec string
(define publicacionCompartidaAstring(lambda (publi fecha et formato)
                                      (string-append
                                       "Publicacion Compartida el: "fecha " etiquetados "(etiquetadosAstringPubli et) "\n"
                                       "ID: "(number->string(getIDPublicacion publi))" "
                                       "Autor original: "(getAutorPublicacion publi)" "
                                       "Fecha Publicacion original: "(getFechaPublicacion publi)"\n"
                                       "Tipo de Publicacion: " (formato(getTipoDatPublicacion publi))" "
                                       (if (null?(getEtiquetados publi))
                                           ""
                                           (string-append "Etiquetados publicacion original: "(etiquetadosAstringPubli(getEtiquetados publi))"\n")
                                           )
                                       (formato(getConCompPublicacion publi))
                                       )
                                       
                                      )
  )
;concate varios string publicacion
;(publiCompAstringUser (getDesencript RS) (getPublicaciones->RS RS) (getCompartidos user) )
;dom func x list x list
;rec string
(define publiCompAstringUser (lambda (formato listaPublicacionesRS listaIDSCompartidas)
                               (if (null? listaIDSCompartidas)
                                   "\n"
                                   (string-append
                                   (publicacionCompartidaAstring
                                    (buscarPublicacionID (car(car listaIDSCompartidas)) listaPublicacionesRS)
                                    (cadr(car listaIDSCompartidas))
                                    (caddr(car listaIDSCompartidas))
                                    formato
                                    )
                                   (publiCompAstringUser formato listaPublicacionesRS (cdr listaIDSCompartidas))
                                   )
                               )
                               )
  )
;esta funcion simplemente sirve en el caso de que no exista USERONLINE  y se llame a la funcion ->string
;dom fun x list
;rec strin
(define PublicacionesAstringOFF (lambda ( formato lista )
                                  (if (null? lista)
                                      "\n"
                                      (string-append
                                       (publicacionAstring (car lista) formato)
                                       (PublicacionesAstringOFF formato (cdr lista))
                                       )
                                       )
                                  )
  )