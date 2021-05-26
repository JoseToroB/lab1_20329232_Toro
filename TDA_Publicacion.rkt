#lang scheme
;
(provide (all-defined-out))
;
;debido a un cambio de ultimo momento el tda respuestas se fusiona con el tda publicacion
;ya que por la forma en que se realiza el llamado de comment no hay manera de distinguir comentario de publicacion
;((((login facebook “user” “pass” comment) (date 30 10 2020))54) “Mi respuesta”) ;comentario sobre publicación 54
;((((login facebook “user” “pass” comment) (date 30 10 2020))58) “Mi respuesta”) ;comentario sobre comentario 58
;ya que entra la misma cantidad de datos en esta funcion opte por esto
;por esto agrego idResp, si es un 0 es una publicacion, si es distinto a eso es la id a la que responde
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;aqui empieza el TDA Publicacion
;id(int) , contenidoCompartido(string) ,tipoDato(string), fecha (string), lista de ids(de respuestas), reacciones("likes" int),Publicador(nick string), etiquetados(list strings), vecesCompartidas(numb), idResp
;constructor
;entran varios datos
;sale una lista del tipo del TDA si esque los datos son validos
;ahora la lista de respuestas apunta a otros tda publicaciones que tienen 
(define crearPublicacion(lambda(id contenidoCompartido tipoDato fecha ListaRespuestas likes autor etiquetados vecesCompartidas idResp)
                          (if (esPublicacion id contenidoCompartido tipoDato fecha ListaRespuestas likes autor)
                              (list id contenidoCompartido tipoDato fecha ListaRespuestas likes autor etiquetados vecesCompartidas idResp)
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
(define getVecesCompartidas(lambda (publicacion)
                          (car(cdr(cdr(cdr(cdr(cdr(cdr (cdr (cdr publicacion)))))))))
                          )
  )
(define getIDResponder(lambda (publicacion)
                          (car(cdr(cdr(cdr(cdr(cdr(cdr (cdr (cdr (cdr publicacion))))))))))
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
;busca la posicion de una publica (mediante id) dentro de una lista publicaciones
;dom: lista x entero x entero
;rec: entero
(define obtenerPosPubli(lambda (lista id pos)
                   (if (equal? (getIDPublicacion (car lista)) id)
                       pos
                       (obtenerPosPubli (cdr lista) id (+ pos 1))
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
;transforma un tda publicacion tipo respuesta a string
;dom list x fun x list
;rec
(define respuestasAstring(lambda (listaPublicaciones formato listaIDS)
                           (if (null? listaIDS)
                               ""
                               (string-append
                                (publicacionAstring
                                 listaPublicaciones
                                 (buscarPublicacionID (car listaIDS) listaPublicaciones)
                                 formato)
                                "\n"
                                (respuestasAstring listaPublicaciones formato (cdr listaIDS))      
                               )
                           )
                           )
  )
;transoforma una publicacion a un string
;publicacionAstring
;dom list x func
;rec string
;(list id contenidoCompartido tipoDato fecha ListaRespuestas likes autor etiquetados)
(define publicacionAstring(lambda(listaPublicaciones publi formato)
                            (string-append
                             (if (equal? (getIDResponder publi) 0)
                                 ""
                                (string-append "\n  ID a la que responde : " (number->string(getIDResponder publi))"\n")
                                 )
                             "ID: "(number->string(getIDPublicacion publi))" "
                             "Autor: "(getAutorPublicacion publi)" "
                             "Fecha Publicacion: "(getFechaPublicacion publi)"\n"
                             "Tipo de Publicacion: " (formato(getTipoDatPublicacion publi))" "
                             "\nEsta publicacion fue compartida un total de: "(number->string(getVecesCompartidas publi)) " veces\n"
                             (if (null?(getEtiquetados publi))
                                 ""
                                 (string-append "Etiquetados: "(etiquetadosAstringPubli(getEtiquetados publi))"\n")
                                 )
                             (formato(getConCompPublicacion publi))
                             (if (null? (getRespuestasPublicacion publi))
                                 ;en caso de tener respuestas las entregara
                                 ""
                                 (string-append "\nRespuestas" (respuestasAstring listaPublicaciones formato (getRespuestasPublicacion publi)))
                                 )
                             ;likes?
                            "likes: "(number->string (getLikesPublicacion ))"\n"
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
                                   (publicacionAstring ListaPublicacionesRS (buscarPublicacionID (car ListaIDPubli) ListaPublicacionesRS ) formato )
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
;esta funcion revisa si una publicacion ya fue compartida por un user
(define Compartida?(lambda(IDpubli listaCompartidas)
                     (if(null? listaCompartidas)
                        ;si la lista esta vacia, retorno f
                        #f
                        ;si no esta vacia reviso si la publicacion actual es la que quiero compartir
                        (if (equal? IDpubli (car(car listaCompartidas)))
                            #t
                            (Compartida? IDpubli (cdr listaCompartidas))
                        )
                     )
                     )
  )