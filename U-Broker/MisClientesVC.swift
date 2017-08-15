//
//  MisClientesVC.swift
//  U-Broker
//
//  Created by Luis Andrés Rodríguez Santoyo on 19/07/17.
//  Copyright © 2017 Grupo Arquimo. All rights reserved.
//

import UIKit
import Firebase



class MisClientesVC: UIViewController, UITableViewDataSource {

    let firebaseAuth = Auth.auth()
    let usuario = Auth.auth().currentUser
    var idFirebase : String = ""
    
    @IBOutlet var tvTablaMisClientes: UITableView!
    
    
    var urlString : String = "http://arquimo.com/ubroker/consultarClientes.php"
    var parametros = "?"
    var arrayClientes : [Clientes] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        //VERIFICA SESIÓN EN FIREBASE
        Auth.auth().addStateDidChangeListener() { (auth, user) in
      
            if self.usuario != nil{
                self.idFirebase = (self.usuario?.uid)!
                self.parametros += "id_firebase=" + self.idFirebase
                self.urlString += self.parametros
                let validUrl = URL(string: self.urlString)
                
                print("URL FORMATEADA | MIS CLIENTES: ",validUrl!)
                
                self.descargarJsonClientes(url: validUrl!)
                
                
                
            }else{
                self.performSegue(withIdentifier: "pantallaLogin", sender: self)
            }
        }
        
        // FIN VERIFICA LA SESIÓN EN FIREBASE
        
        
    }
    
    func descargarJsonClientes(url:URL){
        URLSession.shared.dataTask(with: url) { (data, respuesta, error) in
            DispatchQueue.main.async{
                if error != nil{
                    print("MIS CLIENTES | ERROR PETICIÓN: ", error!)
                }
                if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary{
                    if let clientes = json?.value(forKey:"clientes") as? NSArray{
                        for cliente in clientes{
                            let avance : Float = Float(Int(arc4random_uniform(100) + 1))/100
                            print("PROGRESO DEL CLIENTE: | MIC LCIENTES",avance)

                            if let datosCliente = cliente as? NSDictionary{
                                let cliente = Clientes(
                                    nombres: datosCliente.value(forKey: "nombres") as! String,
                                    apellidos: datosCliente.value(forKey: "apellidos") as! String,
                                    celular: datosCliente.value(forKey: "celular") as! String,
                                    correo: datosCliente.value(forKey: "correo") as! String,
                                    id_cliente: datosCliente.value(forKey: "id_cliente") as! String,
                                    producto: datosCliente.value(forKey: "producto") as! String,
                                    progreso: avance
                                )
                                self.arrayClientes.append(cliente)
                            

                                
                            }
                            OperationQueue.main.addOperation({
                                if(self.arrayClientes.count > 0){
                                    self.tvTablaMisClientes.isHidden = false
                                }
                                self.tvTablaMisClientes.reloadData()
                            })
                        }
                      
                    }
                 
                    
                    
                }
            }

        }.resume()

    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.arrayClientes.count
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let renglon = tvTablaMisClientes.dequeueReusableCell(withIdentifier: "renglon") as! ReglonMisClientesTableViewCell

        let nombreCompleto : String = arrayClientes[indexPath.row].nombres + " " + arrayClientes[indexPath.row].apellidos
        let nombreProducto : String = arrayClientes[indexPath.row].nombreProducto
        let nombreImagen : String = "clientes_mis_clientes"
        let progreso : Float = arrayClientes[indexPath.row].progreso
        renglon.lblNombre.text = nombreCompleto
        renglon.lblProducto.text = nombreProducto
        renglon.ivImagen.image = UIImage(imageLiteralResourceName: nombreImagen )
        renglon.pbBarraProgreso.progress = progreso
        return renglon
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        print("APRETAR CELDA | MIS CLIENTES: ", indexPath.row)
        performSegue(withIdentifier: "abrirModal", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("PREPARAR DATOS CLIENTE | MIS CLIENTES: ACCIONADO")
        if let identificador = segue.identifier{
            switch identificador {
            case "abrirModal":
                let index = self.tvTablaMisClientes.indexPathForSelectedRow
                var modalCliente = segue.destination as! ModalMisClientesVC
                
                modalCliente.cliente = self.arrayClientes[(index?.row)!]
                break
            default: break
            }
        }
     
    }
    
    
}

struct Clientes {
    let nombres : String
    let apellidos : String
    let celular : String
    let correo : String
    let id_cliente : String
    let nombreProducto : String
    let progreso : Float
    
    init(nombres:String, apellidos:String, celular:String, correo:String, id_cliente:String, producto:String, progreso:Float){
        self.nombres = nombres
        self.apellidos = apellidos
        self.celular = celular
        self.correo = correo
        self.id_cliente = id_cliente
        self.nombreProducto = producto
        self.progreso = progreso
    }
    
   
    
}


