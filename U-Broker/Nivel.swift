//
//  PrimerNivel.swift
//  U-Broker
//
//  Created by Luis Andrés Rodríguez Santoyo on 02/08/17.
//  Copyright © 2017 Grupo Arquimo. All rights reserved.
//

import Foundation

struct Nivel {
    var nombre : String!
    var apellido : String!
    var mensaje : String! 
    var referenciados : [String]!
    var expandible : Bool!
    
    init(nombre:String, apellido:String, mensaje: String,  referenciados:[String], expandible:Bool){
        self.nombre = nombre
        self.apellido = apellido
        self.mensaje = mensaje
        self.referenciados = referenciados
        self.expandible = expandible
    }
}
