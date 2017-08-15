//
//  ReglonMisClientesTableViewCell.swift
//  U-Broker
//
//  Created by Luis Andrés Rodríguez Santoyo on 26/07/17.
//  Copyright © 2017 Grupo Arquimo. All rights reserved.
//

import UIKit

class ReglonMisClientesTableViewCell: UITableViewCell {
    
    
    @IBOutlet var ivImagen: UIImageView!
    @IBOutlet var pbBarraProgreso: UIProgressView!
    @IBOutlet var lblProducto: UILabel!
    @IBOutlet var lblNombre: UILabel!
    
    override func awakeFromNib() {
      super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
