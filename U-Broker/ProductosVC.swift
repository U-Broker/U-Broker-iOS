//
//  ProductosVC.swift
//  U-Broker
//
//  Created by Luis Andrés Rodríguez Santoyo on 27/07/17.
//  Copyright © 2017 Grupo Arquimo. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class ProductosVC: UIViewController, UITableViewDataSource {

    var idFirebase : String = ""
    let usuario = Auth.auth().currentUser

    
    var arrayProductos : [Productos] = []
    
    
    @IBOutlet var tvTablaProductos: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        Auth.auth().addStateDidChangeListener() { (auth, user) in
            if let usuario = user{
                self.idFirebase = (Auth.auth().currentUser?.uid)!
            }else{
                self.performSegue(withIdentifier: "pantallaInicio", sender: self)
            }
        }
        
        tvTablaProductos.separatorColor = UIColor(white:0.95, alpha : 1)

        let urlString : String = "http://arquimo.com/ubroker/consultarProductos.php"
        let url : URL = URL(string: urlString)!
        
        descargarJsonProductos(url: url)
    
    
    }

   

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.arrayProductos.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let renglon = tvTablaProductos.dequeueReusableCell(withIdentifier: "renglonProducto") as! RenglonProductoTVC
        
        
        
        renglon.contentView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        
        let descripcionProducto : String = arrayProductos[indexPath.row].descripcion
        let rutaImagen = URL(string: arrayProductos[indexPath.row].imagen)
        let imagen = NSData(contentsOf: (rutaImagen as? URL)! )
        
        renglon.lblDescripcionProducto.text = descripcionProducto
        renglon.ivImagenProducto.image = UIImage(data: imagen as! Data)
        
        return renglon
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        let urlVideo : URL =   URL(string: arrayProductos[indexPath.row].urlVideo)!
        UIApplication.shared.openURL(urlVideo)
    }
    
    
    
    
    
    
    
    
    
    func descargarJsonProductos(url:URL){
        URLSession.shared.dataTask(with: url) { (data, respuesta, error) -> Void in
            DispatchQueue.main.async {
                if error != nil{
                    print("ERROR PETICIÓN | PRODUCTOS: ", error)
                }else{
                    if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary{
                        if let arrayProductos = json?.value(forKey : "productos") as? NSArray{
                            for producto in arrayProductos{
                                if let contenidoProducto = producto as? NSDictionary{
                                    let nombreImagen = contenidoProducto.value(forKey: "img") as! String
                                    let imagen : String = "http://arquimo.com/ubroker/img/" + nombreImagen
                                    let producto = Productos(
                                        idProducto: contenidoProducto.value(forKey: "id_producto") as! String,
                                        nombre: contenidoProducto.value(forKey: "nombre") as! String,
                                        descripcion: contenidoProducto.value(forKey: "desc") as! String,
                                        imagen: imagen,
                                        urlVideo: contenidoProducto.value(forKey:"video") as! String
                                    )
                                    self.arrayProductos.append(producto)
                                }
                                OperationQueue.main.addOperation({
                                    self.tvTablaProductos.reloadData()
                                })
                            }
                        }
                    }
                    print(self.arrayProductos)
                }
            }
        }.resume()
    }
    
    
    
}


struct Productos{
    let idProducto : String
    let nombre : String
    let descripcion : String
    let imagen : String
    let urlVideo : String
    
    
    
    //CONSTRUCTOR CON IMAGENES
    init(idProducto:String, nombre:String, descripcion:String, imagen:String, urlVideo:String){
        self.idProducto = idProducto
        self.nombre = nombre
        self.descripcion = descripcion
        self.imagen = imagen
        self.urlVideo = urlVideo
    }
    
 
    
}
