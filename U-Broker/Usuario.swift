//
//  Usuario.swift
//  U-Broker
//
//  Created by Luis Andrés Rodríguez Santoyo on 14/08/17.
//  Copyright © 2017 Grupo Arquimo. All rights reserved.
//

import Foundation

struct Usuario{
    let id_firebase : String
    let token_fcm : String
    let nombres : String
    let apellidos : String
    let correo : String
    
    init(id_firebase:String, token_fcm : String, nombres : String, apellidos : String, correo : String){
        self.id_firebase = id_firebase
        self.token_fcm = token_fcm
        self.nombres = nombres
        self.apellidos = apellidos
        self.correo = correo
    }
    
    
    func formatearParametros(params:String)->String{
        var parametros = params.replacingOccurrences(of: " ", with: "%20")
        parametros = parametros.folding(options: .diacriticInsensitive, locale: .current)
        return parametros
    }
}
