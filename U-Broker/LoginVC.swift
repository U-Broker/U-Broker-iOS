//
//  LoginVC.swift
//  U-Broker
//
//  Created by Luis Andrés Rodríguez Santoyo on 11/07/17.
//  Copyright © 2017 Grupo Arquimo. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth
import FirebaseMessaging

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("SE CERRÓ LA SESIÓN")
    }


    let loginButton = FBSDKLoginButton()
    var usuario : Usuario!

    
    
    @IBOutlet var tfCorreoElectronico: UITextField!
    @IBOutlet var tfContrasena: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.esconderTeclado()
        
        view.addSubview(loginButton)
        
        loginButton.frame = CGRect(x: 15, y : view.frame.maxY - 60, width: view.frame.width - 32, height: 30)
        loginButton.delegate = self
        
        loginButton.readPermissions = ["email", "public_profile"]
        
        
 
        
        Auth.auth().addStateDidChangeListener() { (auth, user) in
            if user != nil{
                print("LOGIN | ", user!.displayName)
                print("LOGIN | ", user!.isEmailVerified)
                user?.reload(completion: { (error) in
                    print("LOGIN | ", error)
                })
                let estado_usuario = user!.isEmailVerified
                if estado_usuario {
                    print("LOGIN | "," CUENTA VALIDA VERIFICADA")
                    self.performSegue(withIdentifier: "pantallaInicio", sender: self)
                }else{
                    print("LOGIN | "," CUENTA VALIDA Y NO VERIFICADA")
                    self.performSegue(withIdentifier: "pantallaCuentaNoVerificada", sender: self)
                }
            }else{
                print("LOGIN | ", "USUARIO NULO")
            }
        }
        
        
    }


    
   
    
    

    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result:FBSDKLoginManagerLoginResult!, error: Error!){
        if error != nil{
            print(error)
            print("ERROR FACEBOOK | LOGIN: ", error)
        }

        
        let credenciales = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
            
        Auth.auth().signIn(with: credenciales) { (user, error) in
            if let error = error {
                print("ERROR FACEBOOK-FIREBASE | LOGIN: ", error)
                return
            }else{
                
                
                var primer_nombre : String = ""
                var segundo_nombre : String = ""
                var apellidos : String = ""
                let id_firebase :  String = (user?.uid)!
                let token_FCM : String = Messaging.messaging().fcmToken!
                
                FBSDKGraphRequest(graphPath:"/me", parameters:["fields":"id, name, email, first_name, middle_name, last_name" ]).start { (connection, result , error) in
                    if error != nil{
                        print("ERROR AL INICIAR LA PETICIÓN GRAPH | LOGIN: ", error!)
                    }
                    if let peticion = result as? NSDictionary{
                        primer_nombre = peticion["first_name"] as! String
                        segundo_nombre = peticion["middle_name"] as! String ?? ""
                        apellidos = peticion["last_name"] as! String
                    }
                    
                    self.usuario = Usuario(
                        id_firebase : id_firebase,
                        token_fcm : token_FCM,
                        nombres: primer_nombre + " " + segundo_nombre,
                        apellidos : apellidos,
                        correo : (user?.email)!
                    )
                    
                    var urlString = "http://arquimo.com/ubroker/registroCuenta.php?"
                    urlString += "id_firebase=" + self.usuario.id_firebase
                    urlString += "&tokenFCM" + self.usuario.token_fcm
                    var url : URL = URL(string:urlString)!
                    
                    self.registroUsuario(url: url)
                    
                    urlString = "http://arquimo.com/ubroker/registro.php?"
                    urlString += "id_firebase=" + self.usuario.id_firebase
                    urlString += "&nombres_usuario=" + self.usuario.formatearParametros(params: self.usuario.nombres)
                    urlString += "&apellidos_usuario=" + self.usuario.formatearParametros(params: self.usuario.apellidos)
                    urlString += "&correo_usuario=" + self.usuario.correo
                    url = URL(string: urlString)!
                    print(url)
                    
                    self.registroDatos(url: url)
                    
                    let estado_usuario = Auth.auth().currentUser?.isEmailVerified
                    
                    if !(estado_usuario!) {
                        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                            if error != nil{
                                print("LOGIN | ", error, "- FACEBOOK")
                            }else{
                                print("LOGIN | EMAIL ENVIADO - FACEBOOK")
                            }
                        })
                    }
                    
                   
                }
            
       
              
            }
        }
    }
    

    @IBAction func btnIniciarSesion(_ sender: UIButton) {
        let correo : String = tfCorreoElectronico.text!
        let password : String = tfContrasena.text!
        
        if !validarCorreo(correo: correo){
            ventanaNotificacion(titulo: "Correo no valido", mensaje: "El correo que ha ingresado no es una dirección valida", tipoVentana: "notificacion")
            return
        }
        
        if password.characters.count < 6{
            ventanaNotificacion(titulo: "Contraseña no valida", mensaje: "La contraseña debe tener 6 caracteres o más", tipoVentana: "notificacion")
            return
        }
        
       iniciarSesionCorreo(correo: correo, password: password)
        
    }

    
    
    
    func validarCorreo(correo : String) -> Bool{
        if correo.contains("@") && !correo.contains(" "){
            return true
        }
        return false
    }
    
    
    func ventanaNotificacion(titulo:String, mensaje:String, tipoVentana:String){
        
        let ventana : UIAlertController = UIAlertController(title:titulo, message:mensaje, preferredStyle: UIAlertControllerStyle.alert)
        
        switch tipoVentana{
            case "notificacion":
                ventana.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.default, handler: nil))
            break
            
        case "exito":
            ventana.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: nil))
            break
            
            default:
                ventana.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.default, handler: nil))
            break
            
        }
        
        
        present(ventana,animated: true)
        
        
    }
    
    
    
    
    
    func iniciarSesionCorreo(correo:String, password:String){
        
        Auth.auth().signIn(withEmail: correo, password: password) { (user, error) in
            if user != nil {
                let estado_usuario = user?.isEmailVerified
                if estado_usuario! {
                    self.performSegue(withIdentifier: "pantallaInicio", sender: self)
                }else{
                    self.performSegue(withIdentifier: "pantallaCuentaNoVerificada", sender: self)
                }
            }else{
                self.ventanaNotificacion(titulo: "Error Login", mensaje: "Ha ocurrido un error al intentar iniciar sesión", tipoVentana: "notificacion")
            }
        }
    }
    
    
    
    
    
    func registroUsuario(url:URL){
        URLSession.shared.dataTask(with: url) { (data, respuesta, error) -> Void in
            DispatchQueue.main.async {
                if error != nil{
                    print("ERROR PETICIÓN | REGISTRO: ", error!)
                }else{
                    if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary{
                        let status = json?.value(forKey: "status") as? String
                        if status != "OK"{
                            self.ventanaNotificacion(titulo: "Error Registro", mensaje: "Ha ocurrido un  problema al realizar el registro. Intentalo de nuevo.", tipoVentana: "notificacion")
                        }else{
                            
                        }
                    }
                }
            }
            
            }.resume()
        
    }
    
    func registroDatos(url:URL){
        URLSession.shared.dataTask(with: url) { (data, respuesta, error) -> Void in
            DispatchQueue.main.async {
                if error != nil{
                    print("ERROR PETICIÓN | REGISTRO: ", error!)
                }else{
                    if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary{
                        let status = json?.value(forKey: "status") as? String
                        if status != "OK"{
                            self.ventanaNotificacion(titulo: "Error Registro", mensaje: "Ha ocurrido un  problema al realizar el registro. Intentalo de nuevo.", tipoVentana: "notificacion")
                        }else{
                        }
                    }
                    
                }
            }
            
            }.resume()
        
    }
    
}



