#lang scheme
(require "FECHA.rkt")
(require "TDA_RS.rkt")
(require "TDA_respuestas.rkt")
(require "TDA_User.rkt")
(require "TDA_Publicacion.rkt")

;;funciones para el trabajo con listas;;;;;;;
;similar al append
;dom lista x lista
;rec lista
(define unir(lambda (x y)
    (if (null? x);si la primera lista esta vacia retorno el segundo 
        (list y)
        (cons (car x) (unir (cdr x) y));si la primera lista no es vacia, hago car y cdrs para concatenar por partes
        )
    )
  )
(define buscar(lambda (lista buscado)
                (if (null? lista)
                    #f
                    (if (equal?(car (car lista)) buscado)
                        (car lista)
                        (buscar(cdr lista) buscado)
                        )
                    )
                )
  )
;funcion remover remueve el elemento que ocupe la posicion "pos" de la lista 
;dom: lista X numb
;rec: lista
(define remover(lambda (lista pos)
                 (if (and (= pos 0) (null? lista))
                     (list)
                     (if (= pos 0)
                         (cdr lista)
                         (cons (car lista) (remover (cdr lista) (- pos 1)))
                         )
                     )
                 )
  )
;;;;;;;;;;;;;
;esta funcion es la que utilizo para encriptar y desencriptar en mis testeos
(define Seguridad(lambda (s) (list->string (reverse (string->list s)))))

;;;;;;;;;;;;;
;Register
;DOM socialnetwork X date X string X string
;REC socialnetwork            
(define (Register RS fecha User pass)
  (if (and(equal? User (buscarUserPass User (getUSUARIOS->RS RS))) (not(equal? User "")));no permito la existencia del usario "" ya que es como represento una sesion inactiva
      RS;Usuario ya Registrado o Nombre invalido
      (if (equal? "" (getFechaRS RS))
          RS; RS sin fecha
          ;   Lista_usarios online CantUsers
          (construirRS
           (getNombreRS RS)
           (getFechaRS RS)
           (getEncriptar RS)
           (getDesencript RS)
           (ID_UltimaPregunta->RS RS)
           (getPreguntas->RS RS)
           (ID_UltimaRespuesta->RS RS)
           (getRespuestas->RS RS)
           (unir (getUSUARIOS->RS RS) (seguridadUser(getEncriptar RS) (crearUser User pass (list) fecha (+(getCantUsers->RS RS) 1) (list) (list)) ));aqui encripto
           ""
           (+(getCantUsers->RS RS)1)
           )
          );cierre if interior
       );cierre if exterior
  );cierre define

;;;;;;;;;;;;;
;login
;dom: socialnetwork X string X string X function 
;rec: function, rec final socialnetwork

(define Login 
  (lambda (RS User Pass function)
    (if (and 
         (equal? ((getEncriptar RS)Pass) (getPass (buscarUserPass ((getEncriptar RS)User) (getUSUARIOS->RS RS )) )) ; si contraseña encriptada = pass user encriptada
         (equal? ((getEncriptar RS)User) (getNick (buscarUserPass ((getEncriptar RS)User) (getUSUARIOS->RS RS )) )) ;si nick encriptado = nick user encriptado
         );condicion nick=nick and pass=pass
        ;usuario logeado
        (function(construirRS
           (getNombreRS RS)
           (getFechaRS RS)
           (getEncriptar RS)
           (getDesencript RS)
           (ID_UltimaPregunta->RS RS)
           (getPreguntas->RS RS)
           (ID_UltimaRespuesta->RS RS)
           (getRespuestas->RS RS)
           (getUSUARIOS->RS RS)
           User
           (getCantUsers->RS RS))
                 )
        ;usuario no logeado
        RS ;retorno la Rs
        )
    );cierre lambda
  );cierre define

;;;;;;
;post
;dom: socialnetwork
;rec function: date X string (contenido) X user list
;rec final: socialnetwork
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;ya que no se especifica que tipo de publicacion asumire que todas son tipo texto;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (post RS)(lambda (fechaPublicacion)
                   (lambda (tipoPost contenido . users)
                     ;debo revisar si "etiqueto" gente
                    (if (or(null? users) (sonAmigos (getUSUARIOS->RS RS) users ((getEncriptar RS)(getOnline->RS RS)) (getEncriptar RS) ) )
                         ;no etiqueto o son amigos 
                         (construirRS;crear una RS identica con ciertas partes modificadas
                          (getNombreRS RS)
                          (getFechaRS RS)
                          (getEncriptar RS)
                          (getDesencript RS)
                          ;actualizo IDUltimoPregunta sumandole 1
                          (+(ID_UltimaPregunta->RS RS)1)
                          ;actualizo la lista de preguntas agregando la publicacion
                          (unir
                           (getPreguntas->RS RS);lista preguntas/publicaciones/posteos
                           ;debo encriptar la publicacion
                           (crearPublicacion;creo publicacion
                            (+(ID_UltimaPregunta->RS RS)1);asigno id
                           ( (getEncriptar RS) contenido) ;encripto el contenido
                            tipoPost;asumo es texto ya que en ninguna parte del llamado se permite saber el dato
                            fechaPublicacion
                            (list);lista respuestas/comentarios
                            0;likes
                            (getOnline->RS RS);asigno el autor para lograr identificarlas mas facil
                            users;asigno sus "etiquetados"
                            ))
                          (ID_UltimaRespuesta->RS RS)
                          (getRespuestas->RS RS)
                          ;actualizo al usuario que publico
                          (unir
                           (remover (getUSUARIOS->RS RS) (obtenerPosUser (getUSUARIOS->RS RS) ((getEncriptar RS)(getOnline->RS RS)) 0) );elimino al usuario
                                 (crearUser;(list "removiuser" "fecha") ;creo al usuario que removi, pero agregando la pregunta/post(solo la id) a su lista de posts
                                  ((getEncriptar RS)(getOnline->RS RS))
                                  (getPass (buscarUserPass ((getEncriptar RS)(getOnline->RS RS)) (getUSUARIOS->RS RS)))
                                  ;agrego la publicacion realizada(solo la id)
                                  (unir (getPublicaciones (buscarUserPass ((getEncriptar RS)(getOnline->RS RS)) (getUSUARIOS->RS RS)))  (+(ID_UltimaPregunta->RS RS)1))
                                  (getFechaRegistro(buscarUserPass ((getEncriptar RS)(getOnline->RS RS)) (getUSUARIOS->RS RS)))
                                  (getIDUser(buscarUserPass ((getEncriptar RS)(getOnline->RS RS)) (getUSUARIOS->RS RS)))
                                  (getAmigos(buscarUserPass ((getEncriptar RS)(getOnline->RS RS)) (getUSUARIOS->RS RS)))
                                  (getCompartidos(buscarUserPass ((getEncriptar RS)(getOnline->RS RS)) (getUSUARIOS->RS RS))))
                                   )
                           
                          "";desconecto el usuario
                          (getCantUsers->RS RS))
                         ;no son amigos por ende retorno la RS sin publicacion
                         RS; " Solo se puede publicar mensajes en cuentas de terceros si es que está dentro de la lista de contactos del usuario "
                         ;por ende si no son amigos no se puede crear la publicacion
                         )
                     )
                   )
                   
  )
;
;esta funcion es la que permite que dos usuarios se consideren "contactos" es decir es la que permite
;"etiquetar" a otros usuarios en publicaciones
;
;FOLLOW
;DOM socialnetwork
;REC function: date X user
;REC FINAL socialnetwork
;por como se realiza el llamado de ejemplo esta 2blemente currificada
;( ( (login facebook “user” “pass” follow) (date 30 10 2020) ) “user1”) ;

(define (follow RS)(lambda(fecha)(lambda (userAseguir)
                                   (if (not(equal? (getOnline->RS RS) userAseguir));online!=userAseguir
                                    (if (not;reviso que la persona a seguir no sea ya seguida por el usuario conectado
                                         (estaEn?;reviso si la id esta en la lista
                                          (getIDUser(buscarUserPass ((getEncriptar RS)userAseguir) (getUSUARIOS->RS RS)));id user a seguir
                                          (getAmigos(buscarUserPass ((getEncriptar RS)(getOnline->RS RS)) (getUSUARIOS->RS RS)))));lista user online
                                        ;se puede seguir
                                         (construirRS;crear una RS identica con ciertas partes modificadas
                                          (getNombreRS RS)
                                          (getFechaRS RS)
                                          (getEncriptar RS)
                                          (getDesencript RS)
                                          (ID_UltimaPregunta->RS RS)
                                          (getPreguntas->RS RS)
                                          (ID_UltimaRespuesta->RS RS)
                                          (getRespuestas->RS RS)
                                          ;debo "modificar" al usuario online, para eso lo remuevo y lo agrego con sus nuevos valores
                                          (unir (remover (getUSUARIOS->RS RS) (obtenerPosUser (getUSUARIOS->RS RS) ((getEncriptar RS)(getOnline->RS RS)) 0) );remuevo online
                                                (crearUser;agrego la id de userAseguir en la lista de ids del user online
                                              ((getEncriptar RS)(getOnline->RS RS))
                                              (getPass (buscarUserPass ((getEncriptar RS)(getOnline->RS RS)) (getUSUARIOS->RS RS)))
                                              (getPublicaciones (buscarUserPass ((getEncriptar RS)(getOnline->RS RS)) (getUSUARIOS->RS RS))) 
                                              (getFechaRegistro(buscarUserPass ((getEncriptar RS)(getOnline->RS RS)) (getUSUARIOS->RS RS)))
                                              (getIDUser(buscarUserPass ((getEncriptar RS)(getOnline->RS RS)) (getUSUARIOS->RS RS)))
                                              ;ahora agrego la id del usuario a seguir a su lista de seguidos
                                              (unir (getAmigos(buscarUserPass ((getEncriptar RS)(getOnline->RS RS)) (getUSUARIOS->RS RS))) (getIDUser (buscarUserPass ((getEncriptar RS)userAseguir) (getUSUARIOS->RS RS))))
                                              (getCompartidos (buscarUserPass ((getEncriptar RS)(getOnline->RS RS)) (getUSUARIOS->RS RS)))
                                              )) 
                                        
                                          "";desconecto el usuario
                                          (getCantUsers->RS RS))
                                        ;ya se sigue al user
                                        RS
                                        )
                                    ;auto follow 
                                    RS
                                    )
                                  )
                    )
                )
;;;
;share
;dom socialnetwork
;rec function: date X postID X userList
;rec final socialnetwork 
;(((login facebook “user” “pass” share) (date 30 10 2020)) 54)  ;la publicación con ID 54 se comparte en la cuenta de user
(define (share RS)(lambda (fecha)(lambda (IDpubli . users)
                                   ;reviso que exista la publicacion con esa ID
                                   (if (list?(buscarPublicacionID  IDpubli (getPreguntas->RS RS)))
                                       ;si existe la pubicacion
                                       ;creo una RS con el usuario modificado (agrego la id, fecha , etiquetados dentro de su list  de compartidos)
                                       (construirRS;crear una RS identica con ciertas partes modificadas
                                          (getNombreRS RS)
                                          (getFechaRS RS)
                                          (getEncriptar RS)
                                          (getDesencript RS)
                                          (ID_UltimaPregunta->RS RS)
                                          (getPreguntas->RS RS)
                                          (ID_UltimaRespuesta->RS RS)
                                          (getRespuestas->RS RS)
                                          ;debo "modificar" al usuario online, para eso lo remuevo y lo agrego con sus nuevos valores
                                          (unir (remover (getUSUARIOS->RS RS) (obtenerPosUser (getUSUARIOS->RS RS) ((getEncriptar RS)(getOnline->RS RS)) 0) );remuevo online
                                                (crearUser;agrego la id de userAseguir en la lista de ids del user online
                                                 ((getEncriptar RS)(getOnline->RS RS))
                                                 (getPass (buscarUserPass ((getEncriptar RS)(getOnline->RS RS)) (getUSUARIOS->RS RS)))
                                                 (getPublicaciones (buscarUserPass ((getEncriptar RS)(getOnline->RS RS)) (getUSUARIOS->RS RS))) 
                                                 (getFechaRegistro(buscarUserPass ((getEncriptar RS)(getOnline->RS RS)) (getUSUARIOS->RS RS)))
                                                 (getIDUser(buscarUserPass ((getEncriptar RS)(getOnline->RS RS)) (getUSUARIOS->RS RS)))
                                                 ;ahora agrego la id del usuario a seguir a su lista de seguidos
                                                 (getAmigos(buscarUserPass ((getEncriptar RS)(getOnline->RS RS)) (getUSUARIOS->RS RS)))
                                                 (unir (getCompartidos (buscarUserPass ((getEncriptar RS)(getOnline->RS RS)) (getUSUARIOS->RS RS)))
                                                       (list
                                                        IDpubli
                                                        fecha
                                                        ;reviso que los "etiquetados" sean amigos del user online
                                                        (if (or(null? users) (sonAmigos (getUSUARIOS->RS RS) users ((getEncriptar RS)(getOnline->RS RS)) (getEncriptar RS) ) )
                                                            ;si son amigos los agrego
                                                            users
                                                            ;si no son amigos lo dejo como ""
                                                            ""
                                                            ))
                                                 ))) 
                                          "";desconecto el usuario
                                          (getCantUsers->RS RS))
                                       ;si no existe retorno la RS
                                       RS
                                       )
                                   )
                    )
  )
