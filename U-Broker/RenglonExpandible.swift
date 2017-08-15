//
//  RenglonExpandible.swift
//  U-Broker
//
//  Created by Luis Andrés Rodríguez Santoyo on 02/08/17.
//  Copyright © 2017 Grupo Arquimo. All rights reserved.
//

import UIKit

protocol RenglonExpandibleDelegate {
    func toggleSection(header: RenglonExpandible, section: Int)
}

class RenglonExpandible: UITableViewHeaderFooterView {
    
    
    //VARIABLES
    var delegate : RenglonExpandibleDelegate?
    var section : Int!
    
    //COMPONENTES
    @IBOutlet weak var lblNombreReferencia: UILabel!
    @IBOutlet weak var lblMensaje: UILabel!
  
    
    override init(reuseIdentifier: String?){
        super.init(reuseIdentifier: reuseIdentifier)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectHeaderView)))
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectHeaderView)))
    }
    
    
    func selectHeaderView(gesture: UITapGestureRecognizer){
        let celda = gesture.view as! RenglonExpandible
        delegate?.toggleSection(header:self, section: celda.section)
    }
    
    func customInit(titulo: String, mensaje:String, section: Int, delegate: RenglonExpandibleDelegate){
        self.lblNombreReferencia.text = titulo
        self.lblMensaje.text = mensaje
        self.section = section
        self.delegate = delegate
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.lblNombreReferencia?.textColor = UIColor.darkGray
        self.lblMensaje?.textColor = UIColor.darkGray
        self.lblMensaje?.alpha = 0.7
        self.contentView.backgroundColor = UIColor.white
    }
    
}
