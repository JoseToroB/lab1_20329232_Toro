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
           (getPublicaciones->RS RS)
           0;(ID_UltimaRespuesta->RS RS) solo la id ya no la utilizo 
           (list);(getRespuestas->RS RS) 
           (unir (getUSUARIOS->RS RS) (seguridadUser(getEncriptar RS) (crearUser User pass (list) fecha (+(getCantUsers->RS RS) 1) (list) (list) (list) ) ));aqui encripto
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
           (getPublicaciones->RS RS)
           0;(ID_UltimaRespuesta->RS RS)
           (list);(getRespuestas->RS RS)
           (getUSUARIOS->RS RS)
           User
           (getCantUsers->RS RS))
                 )
        ;usuario no logeadoss
        (function RS) ;retorno funcion rs
        )
    );cierre lambda
  );cierre define

;;;;;;
;post
;dom: socialnetwork
;rec function: date X string (contenido) X user list
;rec final: socialnetwork
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
                           (getPublicaciones->RS RS);lista preguntas/publicaciones/posteos
                           ;debo encriptar la publicacion
                           (crearPublicacion;creo publicacion
                            (+(ID_UltimaPregunta->RS RS)1);asigno id
                           ( (getEncriptar RS) contenido) ;encripto el contenido
                           ( (getEncriptar RS) tipoPost)
                            fechaPublicacion
                            (list);lista respuestas/comentarios
                            0;likes
                            (getOnline->RS RS);asigno el autor para lograr identificarlas mas facil
                            users;asigno sus "etiquetados"
                            0;compartidos
                            0;como es una publicacion tipo publicacion es id0 , si fuese comentario seria idRespuesta
                            ))
                          0;(ID_UltimaRespuesta->RS RS) solo la id ya no se utiliza
                          (list);(getRespuestas->RS RS)
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
                                  (getCompartidos(buscarUserPass ((getEncriptar RS)(getOnline->RS RS)) (getUSUARIOS->RS RS)))
                                  (getListaLikes(buscarUserPass ((getEncriptar RS)(getOnline->RS RS)) (getUSUARIOS->RS RS))))
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
                                          (getPublicaciones->RS RS)
                                          0; el tda respuesta quedo eliminado a ultimo momento
                                          (list);(getRespuestas->RS RS);pero su antigua lista para almacenar si lo utilizo
                                          ;solo dejare los datos iniciales 
                                          ;debo "modificar" al usuario online, para eso lo remuevo y lo agrego con sus nuevos valores
                                          (unir
                                           (remover (getUSUARIOS->RS RS) (obtenerPosUser (getUSUARIOS->RS RS) ((getEncriptar RS)(getOnline->RS RS)) 0) );
                                           (crearUser;agrego la id de userAseguir en la lista de ids del user online
                                             ((getEncriptar RS)(getOnline->RS RS))
                                             (getPass (buscarUserPass ((getEncriptar RS)(getOnline->RS RS)) (getUSUARIOS->RS RS)))
                                             (getPublicaciones (buscarUserPass ((getEncriptar RS)(getOnline->RS RS)) (getUSUARIOS->RS RS))) 
                                             (getFechaRegistro(buscarUserPass ((getEncriptar RS)(getOnline->RS RS)) (getUSUARIOS->RS RS)))
                                             (getIDUser(buscarUserPass ((getEncriptar RS)(getOnline->RS RS)) (getUSUARIOS->RS RS)))
                                              ;ahora agrego la id del usuario a seguir a su lista de seguidos
                                             (unir
                                              (getAmigos (buscarUserPass ((getEncriptar RS)(getOnline->RS RS)) (getUSUARIOS->RS RS)))
                                              (getIDUser (buscarUserPass ((getEncriptar RS)userAseguir) (getUSUARIOS->RS RS))))
                                             (getCompartidos (buscarUserPass ((getEncriptar RS)(getOnline->RS RS)) (getUSUARIOS->RS RS)))
                                             (getListaLikes (buscarUserPass ((getEncriptar RS)(getOnline->RS RS)) (getUSUARIOS->RS RS)))
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
                                   (if (list?(buscarPublicacionID  IDpubli (getPublicaciones->RS RS)))
                                       ;si existe la pubicacion
                                       ;creo una RS con el usuario modificado (agrego la id, fecha , etiquetados dentro de su list  de compartidos)
                                       (construirRS;crear una RS identica con ciertas partes modificadas
                                          (getNombreRS RS)
                                          (getFechaRS RS)
                                          (getEncriptar RS)
                                          (getDesencript RS)
                                          (ID_UltimaPregunta->RS RS)
                                          ;debo hacer getVecesCompartidas +1 en la publicacion
                                          (unir;remuevo la publi vieja
                                           (remover (getPublicaciones->RS RS) (obtenerPosPubli (getPublicaciones->RS RS) IDpubli 0))
                                           (crearPublicacion ; copio la publicacion y solo cambio el valor que necesito
                                            (getIDPublicacion (buscarPublicacionID IDpubli (getPublicaciones->RS RS)))
                                            (getConCompPublicacion(buscarPublicacionID IDpubli (getPublicaciones->RS RS)))
                                            (getTipoDatPublicacion(buscarPublicacionID IDpubli (getPublicaciones->RS RS)))
                                            (getFechaPublicacion(buscarPublicacionID IDpubli (getPublicaciones->RS RS)))
                                            (getRespuestasPublicacion(buscarPublicacionID IDpubli (getPublicaciones->RS RS)))
                                            (getLikesPublicacion(buscarPublicacionID IDpubli (getPublicaciones->RS RS)))
                                            (getAutorPublicacion(buscarPublicacionID IDpubli (getPublicaciones->RS RS)))
                                            (getEtiquetados(buscarPublicacionID IDpubli (getPublicaciones->RS RS)))
                                            (+(getVecesCompartidas(buscarPublicacionID IDpubli (getPublicaciones->RS RS)))1);sumo el 1
                                            (getIDResponder(buscarPublicacionID IDpubli (getPublicaciones->RS RS)))
                                            )
                                           )
                                                
                                          0;(ID_UltimaRespuesta->RS RS)
                                          (list);(getRespuestas->RS RS)
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
                                                 ;reviso si la compartio antes o no
                                                 (if (Compartida? IDpubli (getCompartidos (buscarUserPass ((getEncriptar RS)(getOnline->RS RS)) (getUSUARIOS->RS RS))))
                                                     ;si la ha compartido no agrego nada
                                                     (getCompartidos (buscarUserPass ((getEncriptar RS)(getOnline->RS RS)) (getUSUARIOS->RS RS)))
                                                     ;si no la ha compartido la agrego
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
                                                 )
                                                     )
                                                 (getListaLikes (buscarUserPass ((getEncriptar RS)(getOnline->RS RS)) (getUSUARIOS->RS RS)))
                                                       
                                                 )) 
                                          "";desconecto el usuario
                                          (getCantUsers->RS RS))
                                       ;si no existe retorno la RS
                                       RS
                                       )
                                   )
                    )
  )

;como no dijieron que formato usar
;cuando el usuario esta online muestro un poco de sus datos luego sus contactos, sus publicaciones y por ultimo las publicaciones compartidas
;cuando no hay userOnline muestro un pequeño resumende la RS seguido de todas las publicaciones 
;RS->STRING
;Dom socialnetwork
;Rec string
(define (socialnetwork->string RS)
  ;hay dos casos, el caso donde existe alguien online y el caso donde no
  (if (equal? "" (getOnline->RS RS))
      ;caso ofline
      (casoUserOff RS (getDesencript RS))
      ;caso online
      (casoUserOnline RS  (getDesencript RS) (buscarUserPass ((getEncriptar RS)(getOnline->RS RS)) (getUSUARIOS->RS RS)))
                   
      )
  )
;esta funcion realiza el llamado en caso de que ->string  reciba una RS sin sesion inciada
(define casoUserOff(lambda (RS formato)
                     (string-append
                     "la Red Social "(getNombreRS RS) " fue creada el " (getFechaRS RS)"\n"
                     "actualmente cuenta con un total de "(number->string(getCantUsers->RS RS))" usuario/s\n"
                     "entre ellos han realizado un total de "(number->string(ID_UltimaPregunta->RS RS)) " publicacion/es\n"
                     ;como no hay formato definido simplemente mostrare todas las publicaciones en orden de su ID
                     "todas las publicaciones son\n"
                     (PublicacionesAstringOFF (getDesencript RS) (getPublicaciones->RS RS) )
                     )  
                     ) 
  )
;esta funcion realiza el llamado cuando ->string recibe una RS con sesion activa
(define casoUserOnline(lambda (RS formato user )
                        ;como el user esta online debo mostrar solo lo relacionado a el
                        (string-append
                         "Usuario Online: " (formato(getNick user))
                         " Fecha de registro: " (getFechaRegistro user) "\n"
                         ;string con los contactos (solo nombres de usuarios
                         ;crea un string con los conctactos del usuario  
                         "\nContactos\n"
                         (ContactosAstring (getAmigos user) formato (getUSUARIOS->RS RS) )
                         ;string con las publicaciones
                         ;transforma a string cada publicacion del usuario
                         "\nPublicaciones\n"
                         (publicacionesAStringUser (getDesencript RS) (getPublicaciones->RS RS) (getPublicaciones user))
                         "\nPublicaciones Compartidas\n"
                         (publiCompAstringUser (getDesencript RS) (getPublicaciones->RS RS) (getCompartidos user) )
                                       ) 
                         )            
                        )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;FUNCIONES EXTRA;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;comment / 1pts
;dom socialnetwork X date X number X string 
;rec RS
;como no se especifica que tipo de respuesta genera esta funcion, asumo que solo se puede comentar con tipo texto
(define (comment RS)(lambda (fecha)(lambda (ID)(lambda (respuesta)
                                                 (if (list?(buscarPublicacionID  ID (getPublicaciones->RS RS)))
                                                     ;existe publicacion
                                                     (construirRS;crear una RS identica con ciertas partes modificadas
                                                      (getNombreRS RS)
                                                      (getFechaRS RS)
                                                      (getEncriptar RS)
                                                      (getDesencript RS)
                                                      (+(ID_UltimaPregunta->RS RS)1)
                                                      ;debo hacer agregar la nueva id a su lista de respuestas
                                                      (unir;agrego la publicacion tipo comentario (idResponder !=0 )
                                                       (unir;remuevo la publi vieja y la modifico
                                                       (remover (getPublicaciones->RS RS) (obtenerPosPubli (getPublicaciones->RS RS) ID 0))
                                                       (crearPublicacion ; copio la publicacion y solo cambio el valor que necesito
                                                        (getIDPublicacion (buscarPublicacionID ID (getPublicaciones->RS RS)))
                                                        (getConCompPublicacion(buscarPublicacionID ID (getPublicaciones->RS RS)))
                                                        (getTipoDatPublicacion(buscarPublicacionID ID (getPublicaciones->RS RS)))
                                                        (getFechaPublicacion(buscarPublicacionID ID (getPublicaciones->RS RS)))
                                                        (unir
                                                         (getRespuestasPublicacion (buscarPublicacionID ID (getPublicaciones->RS RS)))
                                                          (+(ID_UltimaPregunta->RS RS)1)
                                                         )
                                                        (getLikesPublicacion(buscarPublicacionID ID (getPublicaciones->RS RS)))
                                                        (getAutorPublicacion(buscarPublicacionID ID (getPublicaciones->RS RS)))
                                                        (getEtiquetados(buscarPublicacionID ID (getPublicaciones->RS RS)))
                                                        (getVecesCompartidas(buscarPublicacionID ID (getPublicaciones->RS RS)))
                                                        (getIDResponder(buscarPublicacionID ID (getPublicaciones->RS RS)))
                                                        )
                                                       )

                                                       (crearPublicacion;aqui creo la nueva publicacion (tipo comentario => IDRESPONDER != 0
                                                        (+(ID_UltimaPregunta->RS RS)1)
                                                        ((getEncriptar RS)respuesta)
                                                        ( (getEncriptar RS)"texto")
                                                        fecha
                                                        (list)
                                                        0
                                                        (getOnline->RS RS)
                                                        (list);lista etiquetados
                                                        0;cant compartidas
                                                        ID;id a la que responde
                                                        )
                                                       
                                                           )
                                                
                                                      0;(ID_UltimaRespuesta->RS RS)
                                                      (list)
                                                      ;al usuario no le agrego los comment a su lista de publicaciones ya que no es necesario debido a que cada
                                                      ;publicacion almacena la id de sus propios comentarios
                                                      (getUSUARIOS->RS RS) 
                                                      "";desconecto el usuario
                                                      (getCantUsers->RS RS))
                                                     ;no existe publicacion
                                                     RS
                                                     )
                                                 )
                                     )
                      )
  )

;funcion extra
;like 0.5 pts
;dom RS X DATE X ID post o comentario
;rec RS
;no dicen para que es la fecha en el pdf por ende no la utilice ya que un like es simplemente un numero
;Se puede dar like a cualquier publicación
(define (like RS) (lambda (fecha) (lambda (ID)
                                    (if (list?(buscarPublicacionID  ID (getPublicaciones->RS RS)))
                                        ;existe publicacion
                                        (construirRS;crear una RS identica con ciertas partes modificadas
                                                      (getNombreRS RS)
                                                      (getFechaRS RS)
                                                      (getEncriptar RS)
                                                      (getDesencript RS)
                                                      (ID_UltimaPregunta->RS RS)
                                                      ;debo hacer likes+1
                                                       (unir;remuevo la publi vieja y la modifico
                                                       (remover (getPublicaciones->RS RS) (obtenerPosPubli (getPublicaciones->RS RS) ID 0))
                                                       (crearPublicacion ; copio la publicacion y solo cambio el valor que necesito
                                                        (getIDPublicacion (buscarPublicacionID ID (getPublicaciones->RS RS)))
                                                        (getConCompPublicacion(buscarPublicacionID ID (getPublicaciones->RS RS)))
                                                        (getTipoDatPublicacion(buscarPublicacionID ID (getPublicaciones->RS RS)))
                                                        (getFechaPublicacion(buscarPublicacionID ID (getPublicaciones->RS RS)))
                                                        (getRespuestasPublicacion (buscarPublicacionID ID (getPublicaciones->RS RS)))
                                                        (+(getLikesPublicacion(buscarPublicacionID ID (getPublicaciones->RS RS)))1)
                                                        (getAutorPublicacion(buscarPublicacionID ID (getPublicaciones->RS RS)))
                                                        (getEtiquetados(buscarPublicacionID ID (getPublicaciones->RS RS)))
                                                        (getVecesCompartidas(buscarPublicacionID ID (getPublicaciones->RS RS)))
                                                        (getIDResponder(buscarPublicacionID ID (getPublicaciones->RS RS)))
                                                        )
                                                       )
                                                      0;(ID_UltimaRespuesta->RS RS)
                                                      (list)
                                                      ;al usuario no le agrego los comment a su lista de publicaciones ya que no es necesario debido a que cada
                                                      ;publicacion almacena la id de sus propios comentarios
                                                      (getUSUARIOS->RS RS) 
                                                      "";desconecto el usuario
                                                      (getCantUsers->RS RS))
                                        ;no existe publicacion
                                        RS
                                        )
                                    )
                    )
  )