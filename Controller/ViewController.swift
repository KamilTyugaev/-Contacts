//
//  ViewController.swift
//  Contacts
//
//  Created by IosDeveloper on 11.12.2021.
//

import UIKit

class ViewController: UIViewController {
//    var userDefaults = UserDefaults.standard
    //create хранилище
    var storage:ContactStorageProtocol!
    
    @IBOutlet weak var tableView: UITableView!
//    private var contacts = [ContactProtocol]()
    var contacts:[ContactProtocol] = [] {
        didSet{
            contacts.sort{$0.name < $1.name}
            //save contacts in storage
            storage.save(contact: contacts)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        storage = ContactStorage()
        loadContact()
        // Do any additional setup after loading the view.
    }
    private func loadContact(){
        contacts = storage.load()
    }
    @IBAction func showNewContactAlert(_ sender: Any) {
//    func showNewContactAlert(){
        let alertController = UIAlertController(title: "Creat new contact", message: "Type in name and phone", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Name"
        }
        alertController.addTextField { textField in
            textField.placeholder = "Phone"
        }
        //creat buttons
        //button creat contact
        let creatContactButton = UIAlertAction(title:"Creat", style: .default) { _ in
            guard let contactName = alertController.textFields?[0].text,
                  let contactPhone = alertController.textFields?[1].text else{
                return
            }
            //creat new contact
            let newContact = Contact(name: contactName, numberPhone: contactPhone)
            self.contacts.append(newContact)
            self.tableView.reloadData()
        }
        //Creat button cancel
        let creatButtonCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(creatContactButton)
        alertController.addAction(creatButtonCancel)
        
        self.present(alertController, animated: true, completion: nil)
        //observer for sort contacts
    }
}

extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if let reuseCell = tableView.dequeueReusableCell(withIdentifier: "MyCell") {
            print("Используем старую ячейку для строки с индексом \(indexPath.row)")
            cell = reuseCell
        } else {
            print("Создаем новую ячейку для строки с индексом \(indexPath.row)")
            cell = UITableViewCell(style: .default, reuseIdentifier: "MyCell") }
        configure(cell: &cell, for: indexPath)
        return cell
    }
private func configure(cell: inout UITableViewCell,for indexPath:IndexPath){
        var configuration = cell.defaultContentConfiguration()
        configuration.text = contacts[indexPath.row].name
        configuration.secondaryText = contacts[indexPath.row].numberPhone
        cell.contentConfiguration = configuration
    }
}
extension ViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionDelete = UIContextualAction(style: .destructive, title: "Удалить"){ _,_,_ in
            self.contacts.remove(at: indexPath.row)
            //заново формируем таблчное представление
            tableView.reloadData()
        }
        let action = UISwipeActionsConfiguration(actions: [actionDelete])
        return action
    }
}
