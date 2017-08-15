//
//  NuevoUsuario.swift
//  U-Broker
//
//  Created by Luis Andrés Rodríguez Santoyo on 14/08/17.
//  Copyright © 2017 Grupo Arquimo. All rights reserved.
//

import Foundation

struct NuevoUsuario {
    var id_firebase : String
    var token_FCM : String
    var nombre : String
    var apellido : String
    var correo : String
    var contraseña : String
    var nombre_completo : String
    
    init(id_firebase : String, token_FCM: String, nombre : String, apellido : String, correo : String, contraseña : String){
        self.nombre = nombre.capitalized
        self.apellido = apellido.capitalized
        self.correo = correo
        self.contraseña = contraseña
        self.id_firebase = id_firebase
        self.token_FCM = token_FCM
        self.nombre_completo = nombre.capitalized + " " + apellido.capitalized
    }
    
    public mutating func set_id_firebase(id_firebase:String){
        self.id_firebase = id_firebase
    }
    
    public mutating  func set_token_FCM(token_FCM:String){
        self.token_FCM = token_FCM
    }
    
}
