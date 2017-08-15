//
//  MiRedVC.swift
//  U-Broker
//
//  Created by Luis Andrés Rodríguez Santoyo on 27/07/17.
//  Copyright © 2017 Grupo Arquimo. All rights reserved.
//

import UIKit

//PARA PROBAR LA CELL EXPANDABLE SE AGREGA ESTO DESPUES DE LA CLASE -> SegundoNivelDelegate

class MiRedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, RenglonExpandibleDelegate {

    @IBOutlet weak var tvTablaMiRed: UITableView!
   
    
    var referenciados = [
        Nivel(nombre: "Rogelio",
           apellido: "Sanchéz Pallarres",
           mensaje: "Oportunidades: 1 | Cantidad Red: 2",
           referenciados: [
                "Marco Antonio Sombrerero",
                "Jorge Gonzalez Solorzano"
            ],
           expandible: false
        ),
        Nivel(
            nombre: "Mario Adán",
            apellido: "López Martinez",
            mensaje: "Oportunidades: 0 | Cantidad Red: 2",
            referenciados: [
                "Roberto Gonzalez",
                "Adrián Moreno"
            ],
            expandible: false
        ),
        Nivel(
            nombre: "Irving Román",
            apellido: "Soto Toriz",
            mensaje: "Oportunidades: 4 | Cantidad Red: 2",
            referenciados: [
                "Guillermo Mascote",
                "Eduardo Martínez"
            ],
            expandible: false
        )
     ]
    
    //var selectedIndexPath = IndexPath!
    
    /*var referenciados = [
        ReferenciaDirecta(nombre: "Rogelio", apellido: "Sanchéz Pallarres", referenciados: [
            "Marco Antonio Sombrerero", "Jorge Gonzalez Solorzano"],
            expandible: false),
        ReferenciaDirecta(nombre: "Mario Adán", apellido: "López Martinez", referenciados: [
            "Roberto Gonzalez", "Adrián Moreno"],
                          expandible: false),
        ReferenciaDirecta(nombre: "Irving Román", apellido: "Soto Toriz", referenciados: [
            "Guillermo Mascote", "Eduardo Martínez"],
                          expandible: false)
    ] */
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // selectedIndexPath = IndexPath(row: -1, section:-1)
        let nib = UINib(nibName:"RenglonExpandible", bundle: nil)
        tvTablaMiRed.register(nib, forHeaderFooterViewReuseIdentifier: "RenglonExpandible")
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return referenciados.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return referenciados[section].referenciados.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 58
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if referenciados[indexPath.section].expandible{
            return 44
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tvTablaMiRed.dequeueReusableHeaderFooterView(withIdentifier: "RenglonExpandible") as! RenglonExpandible
        let nombre = referenciados[section].nombre + " " + referenciados[section].apellido
        let mensaje = referenciados[section].mensaje!
        headerView.customInit(titulo: nombre, mensaje:mensaje, section: section, delegate: self)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tvTablaMiRed.dequeueReusableCell(withIdentifier: "etiqueta_celda")
        celda?.textLabel?.text = referenciados[indexPath.section].referenciados[indexPath.row]
        return celda!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    
        //referenciados[indexPath.section].expandible = !referenciados[indexPath.section].expandible
        tvTablaMiRed.beginUpdates()
        tvTablaMiRed.reloadSections([indexPath.section], with: .automatic)
        tvTablaMiRed.endUpdates()
    }
    
    func toggleSection(header: RenglonExpandible, section: Int) {
        referenciados[section].expandible = !referenciados[section].expandible
        tvTablaMiRed.beginUpdates()
        tvTablaMiRed.reloadSections([section], with: .automatic)
        tvTablaMiRed.endUpdates()
    }
    
/*
     //MÉTODOS PARA LA TABLA EXPANDIBLE NO PERSONALIZADA
    func numberOfSections(in tableView: UITableView) -> Int {
        return referenciados.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return referenciados[section].referenciados.count
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if referenciados[indexPath.section].expandible{
            return 44
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = SegundoNivel()
        let nombre = referenciados[section].nombre + " " + referenciados[section].apellido
        header.customInit(title: nombre, section: section, delegate: self )
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tvTablaMiRed.dequeueReusableCell(withIdentifier: "etiqueta_celda")!
        celda.textLabel?.text = referenciados[indexPath.section].referenciados[indexPath.row]
        return celda
    }
    
    func toggleSection(header: SegundoNivel, section: Int) {
        referenciados[section].expandible = !referenciados[section].expandible
        
        
        tvTablaMiRed.beginUpdates()
        for i in 0..<referenciados[section].referenciados.count {
            tvTablaMiRed.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        tvTablaMiRed.endUpdates()
    }
    */
}


