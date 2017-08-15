//
//  CuentaNoVerificadaVC.swift
//  U-Broker
//
//  Created by Luis Andrés Rodríguez Santoyo on 10/08/17.
//  Copyright © 2017 Grupo Arquimo. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
class CuentaNoVerificadaVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        Auth.auth().addStateDidChangeListener() { (auth, user) in
            if user != nil{
                user?.reload(completion: { (error) in
                    print("CUENTA NO VERIFICADA | ", error)
                })
                if (user?.isEmailVerified)! {
                    self.performSegue(withIdentifier: "pantallaInicio", sender: self)
                }
            }else{
                
            }
        }
        
    }

    @IBAction func btnEnviarCorreoVerificacion(_ sender: UIButton) {
        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
            if error != nil{
                print("CUENTA NO VERIFICADA | ",error)
            }else{
                print("CUENTA NO VERIFICADA | EMAIL ENVIADO")

            }
        })
    }

    @IBAction func btnSalir(_ sender: UIButton) {
        
        do {
            try Auth.auth().signOut()
            let manager = FBSDKLoginManager()
            manager.logOut()
            exit(0)
        } catch let signOutError as NSError {
            
            print ("Error Cerrando Sesión: %@", signOutError)
        }
    }
}
