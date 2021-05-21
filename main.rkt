#lang scheme
(require "FECHA.rkt")
(require "TDA_RS.rkt")
(require "TDA_respuestas.rkt")
(require "TDA_User.rkt")
(require "TDA_Publicacion.rkt")

;;;;;;;;;;;;;;;;;;;;;;;
(define unir(lambda (x y)
    (if (null? x);si la primera lista esta vacia retorno el segundo 
        (list y)
        (cons (car x) (unir (cdr x) y));si la primera lista no es vacia, hago car y cdrs para concatenar por partes
        )
    )
  )
;;;;;;;;;;;;;
;esta funcion es la que utilizo para encriptar y desencriptar en mis testeos
(define Seguridad(lambda (s) (list->string (reverse (string->list s)))))

;;;;;;;;;;;;;
;;Funcion Register
;DOM socialnetwork X date X string X string
;REC socialnetwork
;utiliza recursion en la funcion buscarUserPass
;esta funcion registra un usuario agregandolo a la lista USUARIOS dentro del stack
;si el usuario ya se encuentra registrado se retorna un mensaje de que ya esta registrado
;en caso de entregar un stack sin fecha se muestra un mensaje de esto
(define (Register RS fecha User pass)
  (if (equal? User (buscarUserPass User (getUSUARIOS->RS RS)))
      (display "Usuario ya Registrado")
      (if (equal? "" (getFechaRS RS))
          (display "se ha entregado una RS sin fecha\n")
          (construirRS
           (getNombreRS RS)
           (getFechaRS RS)
           (getEncriptar RS)
           (getDesencript RS)
           (ID_UltimaPregunta->RS RS)
           (getPreguntas->RS RS)
           (ID_UltimaRespuesta->RS RS)
           (getRespuestas->RS RS)
           (unir (getUSUARIOS->RS RS) (seguridadUser(getEncriptar RS) (crearUser User pass (list) fecha) ));aqui encripto
           "" )
          );cierre if interior
       );cierre if exterior
  );cierre define

;;;;;;;;;;;;;
;funcion para loguearse
;dom socialnetwork X string X string X function 
;rec function, rec final socialnetwork

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
           User )
                 )
        ;usuario no logeado
        RS ;retorno la Rs
        )
    );cierre lambda
  );cierre define
  
