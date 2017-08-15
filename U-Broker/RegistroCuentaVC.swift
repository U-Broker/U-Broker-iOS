//
//  RegistroCuentaVC.swift
//  U-Broker
//
//  Created by Luis Andrés Rodríguez Santoyo on 14/07/17.
//  Copyright © 2017 Grupo Arquimo. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseMessaging
class RegistroCuentaVC: UIViewController {

    
    
    @IBOutlet var tfNombres: UITextField!
    @IBOutlet var tfApellidos: UITextField!
    @IBOutlet var tfCorreo: UITextField!
    @IBOutlet var tfPassword: UITextField!
    @IBOutlet var tfVPassword: UITextField!
    
    var nuevo_usuario : NuevoUsuario!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.esconderTeclado()
    }

    @IBAction func btnRegistrarmeApretar(_ sender: UIButton) {
        let nombres = tfNombres.text ?? ""
        let apellidos = tfApellidos.text ?? ""
        let correo = tfCorreo.text ?? ""
        let password = tfPassword.text ?? ""
        let vPassword = tfVPassword.text ?? ""
        let banderaCrearCuenta : Bool = validarRegistro(nombres: nombres, apellidos : apellidos, correo : correo, password: password, vPassword : vPassword)
        if banderaCrearCuenta{
            self.nuevo_usuario = NuevoUsuario(id_firebase: "", token_FCM: "", nombre: nombres, apellido: apellidos, correo: correo, contraseña: password)
            crearCuenta(usuario: self.nuevo_usuario)
        }
    }
    
    func crearCuenta(usuario : NuevoUsuario){
        let correo = usuario.correo
        let password = usuario.contraseña
        Auth.auth().createUser(withEmail: correo, password: password) { (user, error) in
            if (error != nil){
                self.ventanaNotificacion(titulo: "Error al crear la cuenta", mensaje: "ERROR | \(error ?? "Desconocido" as! Error)", tipoVentana: "notificacion")
            }else{
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = self.nuevo_usuario.nombre_completo
                changeRequest?.commitChanges(completion: nil)
                Auth.auth().currentUser?.reload(completion: nil)
                Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                    if error != nil{
                        print("REGISTRAR CUENTA | ", error)
                    }else{
                        print("REGISTRAR CUENTA | EMAIL ENVIADO")
                    }
                })
                self.nuevo_usuario.set_id_firebase(id_firebase: (user?.uid)!)
                self.nuevo_usuario.set_token_FCM(token_FCM: Messaging.messaging().fcmToken!)
                var urlString = "http://arquimo.com/ubroker/registroCuenta.php?"
                urlString += "id_firebase=" + self.nuevo_usuario.id_firebase
                urlString += "&tokenFCM=" + self.nuevo_usuario.token_FCM
                urlString = self.formatearParametros(params: urlString)
                let url : URL = URL(string: urlString)!
                self.registroUsuario(url: url)
            }
        }
    }
    
    func validarRegistro(nombres:String, apellidos:String, correo:String, password:String, vPassword:String) -> Bool{
        if nombres.isEmpty || apellidos.isEmpty || correo.isEmpty || password.isEmpty || vPassword.isEmpty{
                ventanaNotificacion(titulo: "Campos Vacios", mensaje: "Ningún campo del formulario puede ir vacio.", tipoVentana: "notificacion")
                return false
            }
        if !correo.contains("@") || correo.contains(" "){
            ventanaNotificacion(titulo: "Correo No Valido", mensaje: "La dirección de correo eletrónico que has ingresado no es valida.", tipoVentana: "notificacion")
            return false
        }
        if password.characters.count < 6{
            ventanaNotificacion(titulo: "Contraseña muy corta", mensaje: "La contraseña debe ser de 6 caracteres o más.", tipoVentana: "notificacion")
            return false
        }
        if password != vPassword{
            ventanaNotificacion(titulo: "Contraseñas No Coinciden", mensaje: "La contraseña y su validación deben de ser iguales para poder validar que escribio bien su contraseña.", tipoVentana: "notificacion")
            return false
        }
        return true
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
    
    func registroUsuario(url:URL){
        URLSession.shared.dataTask(with: url) { (data, respuesta, error) -> Void in
            DispatchQueue.main.async {
                if error != nil{
                    print("ERROR PETICIÓN | REGISTRO: ", error)
                }else{
                    if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary{
                        let status = json?.value(forKey: "status") as? String
                        if status != "OK"{
                            self.ventanaNotificacion(titulo: "Error Registro", mensaje: "Ha ocurrido un  problema al realizar el registro. Intentalo de nuevo.", tipoVentana: "notificacion")
                        }else{
                            var urlString = "http://arquimo.com/ubroker/registro.php?"
                            urlString += "id_firebase=" + self.nuevo_usuario.id_firebase
                            urlString += "&nombres_usuario=" + self.nuevo_usuario.nombre
                            urlString += "&apellidos_usuario=" + self.nuevo_usuario.apellido
                            urlString += "&correo_usuario=" + self.nuevo_usuario.correo
                            urlString = self.formatearParametros(params: urlString)
                            let url : URL = URL(string: urlString)!
                            self.registroDatos(url: url)
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
                    print("ERROR PETICIÓN | REGISTRO: ", error)
                }else{
                    if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary{
                        let status = json?.value(forKey: "status") as? String
                        if status != "OK"{
                            self.ventanaNotificacion(titulo: "Error Registro", mensaje: "Ha ocurrido un  problema al realizar el registro. Intentalo de nuevo.", tipoVentana: "notificacion")
                        }else{
                            self.performSegue(withIdentifier: "pantallaLogin", sender: self)
                        }
                    }
                }
            }
        }.resume()
    }
    
    func formatearParametros(params:String)->String{
        var parametros = params.replacingOccurrences(of: " ", with: "%20")
        parametros = parametros.folding(options: .diacriticInsensitive, locale: .current)
        return parametros
    }
}


