//
//  SegundoNivel.swift
//  U-Broker
//
//  Created by Luis Andrés Rodríguez Santoyo on 02/08/17.
//  Copyright © 2017 Grupo Arquimo. All rights reserved.
//

import UIKit

protocol SegundoNivelDelegate {
    func toggleSection(header: SegundoNivel, section: Int)
}

class SegundoNivel: UITableViewHeaderFooterView {

    var delegate : SegundoNivelDelegate?
    var section : Int!
    
    override init(reuseIdentifier : String?){
        super.init(reuseIdentifier: reuseIdentifier)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectHeaderAction)))
    }
    
    func selectHeaderAction(gestureRecognizer: UITapGestureRecognizer ){
        let renglon = gestureRecognizer.view as! SegundoNivel
        delegate?.toggleSection(header: self, section: renglon.section)
    }
    
    func customInit(title:String, section:Int, delegate:SegundoNivelDelegate){
        self.textLabel?.text = title
        self.section = section
        self.delegate = delegate
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textLabel?.textColor = UIColor.white
        self.contentView.backgroundColor = UIColor.darkGray
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) no fue implementado")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
