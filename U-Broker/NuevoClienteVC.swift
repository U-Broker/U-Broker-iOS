//
//  NuevoClienteVC.swift
//  U-Broker
//
//  Created by Luis Andrés Rodríguez Santoyo on 18/07/17.
//  Copyright © 2017 Grupo Arquimo. All rights reserved.
//

import UIKit
import FirebaseAuth

class NuevoClienteVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var idFirebase = ""
    var nombres : String = ""
    var apellidos : String = ""
    var celular : String = ""
    var correo : String = ""
    var vCorreo : String = ""
    var idProducto : Int = 0
    
    var nombreProductos : [String] = [String]()
    var idProductos : [String] = [String]()
    
    @IBOutlet var tfNombres: UITextField!
    
    @IBOutlet var tfApellidos: UITextField!
    
    @IBOutlet var tfCelular: UITextField!
    
    @IBOutlet var tfCorreo: UITextField!
    
    @IBOutlet var tfVCorreo: UITextField!
    
    @IBOutlet var pvProductos: UIPickerView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.esconderTeclado()
        // Do any additional setup after loading the view.
        
    
        Auth.auth().addStateDidChangeListener() { (auth, user) in
            if let usuario = user{
                self.idFirebase = (Auth.auth().currentUser?.uid)!
            }else{
                self.performSegue(withIdentifier: "pantallaInicio", sender: self)
            }
        }
        
        
    
        var urlString = "http://arquimo.com/ubroker/consultarProductos.php"
        var url = URL(string : urlString)
        guard let validUrl = url else{ return }
        
        
        descargarJsonProductos(url: validUrl)
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    

     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return idProductos.count
    }
    
    func pickerView(_ pickerView: UIPickerView,  titleForRow row:Int, forComponent component: Int) -> String{
        self.idProducto = Int(idProductos[row])!
        return nombreProductos[row]
    }
    
    func btnTapRegistrarCliente(_ sender: UIButton) {
        nombres = tfNombres.text ?? ""
        apellidos = tfApellidos.text ?? ""
        correo = tfCorreo.text ?? ""
        vCorreo = tfVCorreo.text ?? ""
        celular = tfCelular.text ?? ""
        
        let banderaCrearCuenta : Bool = validarRegistro(nombres: nombres, apellidos : apellidos, correo : correo, vCorreo: vCorreo, celular : celular, idProducto: self.idProducto)
        
        
        
        if banderaCrearCuenta{
            registrarCliente(nombres: nombres, apellidos: apellidos, correo: correo, celular: celular, idProducto: idProducto, idFirebase: idFirebase)
           
            
        }
        
    }
    
    func validarRegistro(nombres:String, apellidos:String, correo:String, vCorreo:String, celular:String, idProducto : Int) -> Bool{
        
        if nombres.isEmpty || apellidos.isEmpty || correo.isEmpty || celular.isEmpty || vCorreo.isEmpty{
            ventanaNotificacion(titulo: "Campos Vacios", mensaje: "Ningún campo del formulario puede ir vacio.", tipoVentana: "notificacion")
            return false
        }
        
        if !correo.contains("@") || correo.contains(" "){
            ventanaNotificacion(titulo: "Correo No Valido", mensaje: "La dirección de correo eletrónico que has ingresado no es valida.", tipoVentana: "notificacion")
            
            return false
        }
        
    
        
        if idProducto < 1{
            ventanaNotificacion(titulo: "Producto No Seleccionado", mensaje: "Para porder registar un nuevo cliente tiene que seleccionar un producto de la lista", tipoVentana: "notificacion")
            return false
        }
        
        if correo != vCorreo{
            ventanaNotificacion(titulo: "Correos No Coinciden", mensaje: "Las direcciones de correo electrónico deben de coincidir.", tipoVentana: "notificacion")
            return false
        }
        
        return true
        
    }
    
    func registrarCliente(nombres:String, apellidos:String, correo:String, celular:String, idProducto:Int, idFirebase:String){
        var urlString : String = "http://arquimo.com/ubroker/registroNuevoCliente.php"
        var param = "?"
        param += "id_referencia=" + idFirebase
        param += "&nombres=" + nombres
        param += "&apellidos=" + apellidos
        param += "&celular=" + celular
        param += "&correo=" + correo
        param += "&id_producto=" + String(idProducto)
        param = formatearParametros(params: param)
        urlString += param
        print("URL FORMATEADA: ",urlString)
        let url = URL(string : urlString)
        URLSession.shared.dataTask(with: url!) { (data, respuesta, error) -> Void in
            DispatchQueue.main.async {
                if error != nil{
                    print("ERROR PETICION")
                }else{
                    if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary{
                        if let status = json?.value(forKey : "status") as? String{
                            if status == "OK"{
                               self.ventanaNotificacion(titulo: "Registro con Éxito", mensaje: "El cliente ha sido registrado correctamente.", tipoVentana: "inicio")
                               
                            } else{
                                self.ventanaNotificacion(titulo: "Ha ocurrido un error", mensaje: "Se ha encontrado un problema al intentar de realizar el registro.", tipoVentana: "notificacion")
                                
                            }
                        }
                        
                        
                    }
                }
            }
            
            }.resume()
        
    }
    
    
    
    
    func descargarJsonProductos(url:URL){
        URLSession.shared.dataTask(with: url) { (data, respuesta, error) -> Void in
            DispatchQueue.main.async {
                if error != nil{
                    print("ERROR PETICION")
                }else{
                    if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary{
                        if let arrayProductos = json?.value(forKey : "productos") as? NSArray{
                            for producto in arrayProductos{
                                if let contenidoProducto = producto as? NSDictionary{
                                    
                                    if let nombre = contenidoProducto.value(forKey:"nombre"){
                                        self.nombreProductos.append(nombre as! String)
                                    }
                                    if let idProducto = contenidoProducto.value(forKey:"id_producto"){
                                        self.idProductos.append(idProducto as! String)
                                    }
                                }
                                
                            }
                        }
                        
                        
                    }
                    self.pvProductos.dataSource = self
                    self.pvProductos.delegate = self
                }
            }
           
            }.resume()
       
    }
    
    func formatearParametros(params:String)->String{
        var parametros = params.replacingOccurrences(of: " ", with: "%20")
        parametros = parametros.folding(options: .diacriticInsensitive, locale: .current)
        return parametros
    }

    
 
    
    
    
    func ventanaNotificacion(titulo:String, mensaje:String, tipoVentana:String){
        
        let ventana : UIAlertController = UIAlertController(title:titulo, message:mensaje, preferredStyle: UIAlertControllerStyle.alert)
        
        switch tipoVentana{
        case "notificacion":
            ventana.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.default, handler: nil))
            break
            
        case "exito":
            ventana.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: nil))
            break
            
            case "inicio":
                ventana.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: {action in
                    self.performSegue(withIdentifier: "pantallaInicio", sender: self)
                }))
            break
        default:
            ventana.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.default, handler: nil))
            break
            
        }
        
        
        present(ventana,animated: true)
        
        
    }
    
}



extension UIViewController
{
    func esconderTeclado()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.descartarTeclado))
        
        view.addGestureRecognizer(tap)
    }
    
    func descartarTeclado()
    {
        view.endEditing(true)
    }
}

