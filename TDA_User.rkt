#lang scheme
;
(provide (all-defined-out))
;
;TDA USUARIO
;el TDA usuario tiene los siguientes elementos
;(nickname(string) password(string) publicaciones(LISTA DE  IDS/ENTEROS) fechaRegistro(string) IDUser(number) listaAmigos(ids) compartidos(lista publicaciones compartidas (ID FECHA ETIQUETADOS))

;;Funcion crearUser
;DOM ;string X string 
;REC ;TDA usuario
(define (crearUser User pass publicaciones fecha ID listaAmigos compartidos)
  (if (and (string? User) (string? pass) (list? publicaciones) (string? fecha) (number? ID)(list? listaAmigos) (list? compartidos)  )
      (list User pass publicaciones fecha ID listaAmigos compartidos)
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
;funcion getIDUser
;dom; lista
;rec: number
(define getIDUser(lambda (lista)
                            (car(cddddr lista))
                    )
  )
;funcion getAmigos
;dom; lista
;rec: lista
(define getAmigos(lambda (lista)
                            (car(cddddr (cdr lista)))
                    )
  )
;funcion getCompartidos
;dom; lista
;rec: lista
(define getCompartidos(lambda (lista)
                            (car(cddddr (cddr lista)))
                    )
  )
;;;;;;;;; funciones extra ;;;;;;;

;busco un user dentro de una lista users
;dom: string X lista(de users)
;rec: lista(user)
(define (buscarUserPass buscado lista)
   (if (null? lista)
       #f
       (if (equal? (car(car lista)) buscado)
           (car lista)
           (buscarUserPass buscado (cdr lista))
           )
       )
  )
;
;esta funcion sirve para encriptar/desencriptar un tda usuario
(define seguridadUser (lambda (funcion user)
                        (list
                         (funcion  (getNick user));encripto el nick
                         (funcion  (getPass user));encripto la pass
                         (getPublicaciones user);no encripto el resto
                         (getFechaRegistro user)
                         (getIDUser user)
                         (getAmigos user)
                         (getCompartidos user)
                         )         
                        )
  )

;busca la posicion de un usuario (mediante el nick) dentro de una lista de users
;dom: lista x string x entero
;rec: entero
(define obtenerPosUser(lambda (lista user pos)
                   (if (equal? (getNick (car lista)) user)
                       pos
                       (obtenerPosUser (cdr lista) user (+ pos 1))
                       )
                    )
  )
;revisa si un id esta en una lista
;dom ID(entero) X lista
;rec bool
;utiliza recursion
(define (estaEn? ID lista)
  (if (null? lista)
      #f;si la lista esta vacia retorno un false
      (if(equal? ID (car lista));si el primer elemento de la lista es la ID retorno #t
         #t
         (estaEn? ID (cdr lista));sino llamo a la funcion con el (cdr lista)
         )
       )
  )
;funcion que me retorna #t o #f para saber si una lista de usuarios pertenece a los amigos de otro
(define sonAmigos(lambda (ListaUsers supuestosAmigos user formato)
                   (if (equal? supuestosAmigos null);si no hay mas o si esta vacia #t
                       #t
                       (if(estaEn? (getIDUser(buscarUserPass (formato(car supuestosAmigos)) ListaUsers)) (getAmigos(buscarUserPass user ListaUsers) ) )
                          (sonAmigos ListaUsers (cdr supuestosAmigos) user formato);si el actual es amigo, reviso el siguiente
                          #f;si el actual no es amigo, retorno f
                        )
                   )
                   )
  )