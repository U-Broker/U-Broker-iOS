//
//  ModalMisClientesVC.swift
//  U-Broker
//
//  Created by Luis Andrés Rodríguez Santoyo on 27/07/17.
//  Copyright © 2017 Grupo Arquimo. All rights reserved.
//

import UIKit

class ModalMisClientesVC: UIViewController {

    
    public var cliente : Clientes?
    
    
    
    @IBOutlet var lblProductoModal: UILabel!
    @IBOutlet var lblNombreModal: UILabel!
    
    @IBOutlet var lblAvanceModal: UILabel!
    
    @IBOutlet var lblComentariosModal: UILabel!
    @IBOutlet var pbAvanceModal: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let avance = (cliente?.progreso)! * 100
        
        lblNombreModal.text = (cliente?.nombres)! + " " + (cliente?.apellidos)!
        lblProductoModal.text = cliente?.nombreProducto
        
        pbAvanceModal.progress = (cliente?.progreso)!
        lblAvanceModal.text = "\(avance)%"
        
        
    }

    @IBAction func cerrarModal(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}
