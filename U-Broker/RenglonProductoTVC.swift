//
//  RenglonProductoTVC.swift
//  U-Broker
//
//  Created by Luis Andrés Rodríguez Santoyo on 27/07/17.
//  Copyright © 2017 Grupo Arquimo. All rights reserved.
//

import UIKit

class RenglonProductoTVC: UITableViewCell {

    @IBOutlet var lblDescripcionProducto: UILabel!
    @IBOutlet var ivImagenProducto: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
