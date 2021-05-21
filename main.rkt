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
           (unir (getUSUARIOS->RS RS) (encriptarUser RS (crearUser User pass (list) fecha) ))
           )
          );cierre if interior
       );cierre if exterior
  );cierre define

;;;;;;;;;;;;;
;funcion para loguearse
;esta funcion solicita el usuario y la contrasenia, luego con ayuda de la funcion buscarUserPass, se comparan las contraseñas
;si estas coinciden el usuario se conecta (se hace un append(funcion unir) al stack señalando que el usuario esta conectado)
;dom stack X string X string X funcion
;rec  stack
;(define Login 
;  (lambda (stack User Pass function)
 ;   (if (equal? (car(cdr(buscarUserPass User (getUSUARIOS->stack stack)))) Pass)
  ;      ;usuario bien logeado
   ;     (function(CrearStack (ID_UltimaPregunta->stack stack);caso verdadero, se conecta el usuario
   ;                         (getPreguntas->stack stack)
   ;                        (ID_UltimaRespuesta->stack stack)
   ;                       (getRespuestas->stack stack)
   ;                      (getUSUARIOS->stack stack)
   ;                     (getFecha->stack stack)
   ;                    User));como el usuario se conecta se agrega al final del stack su nick
   ;usuario mal logeado
   ;   stack; en caso falso retorno el stack inicial
   ;   );como el usuario n conecta agrego un string "" en la posicion del usuario conectado
 ;   );cierre lambda
;  );cierre define
  
