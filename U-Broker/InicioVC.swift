//
//  InicioVC.swift
//  U-Broker
//
//  Created by Luis Andrés Rodríguez Santoyo on 14/07/17.
//  Copyright © 2017 Grupo Arquimo. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit


class InicioVC: UIViewController {

    let firebaseAuth = Auth.auth()
    
    let usuario = Auth.auth().currentUser

    
    
    @IBOutlet var lblSaludo: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        Auth.auth().addStateDidChangeListener() { (auth, user) in
            if self.usuario != nil{
                let nombreUsuario = self.usuario?.displayName?.components(separatedBy: " ")[0]
                var saludo : String = ""
                if nombreUsuario == nil{
                    saludo = "Bienvenido"
                }else{
                    saludo = "¡Hola, \(nombreUsuario!)!"
                }
                self.lblSaludo.text = saludo
            }else{
                self.performSegue(withIdentifier: "pantallaLogin", sender: self)
            }
        }
    }

    
    @IBAction func btnApretarSalir(_ sender: UIBarButtonItem) {
        
        
        do {
            try firebaseAuth.signOut()
            let manager = FBSDKLoginManager()
            manager.logOut()

            self.performSegue(withIdentifier: "pantallaLogin", sender: self)
        } catch let signOutError as NSError {
            print ("Error Cerrando Sesión: %@", signOutError)
        }
        
        
    }

}
