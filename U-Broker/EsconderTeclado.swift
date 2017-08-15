//
//  EsconderTeclado.swift
//  U-Broker
//
//  Created by Luis Andrés Rodríguez Santoyo on 15/08/17.
//  Copyright © 2017 Grupo Arquimo. All rights reserved.
//

import Foundation
extension UIViewController
{
    func esconderTeclado()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    func descartarTeclado()
    {
        view.endEditing(true)
    }
}
