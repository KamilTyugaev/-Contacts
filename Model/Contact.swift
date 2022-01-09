//
//  Contact.swift
//  Contacts
//
//  Created by IosDeveloper on 11.12.2021.
//

import Foundation

protocol ContactProtocol {
    var name:String {get set}
    var numberPhone: String {get set}
}
struct Contact:ContactProtocol {
    var name:String
    var numberPhone:String
}

protocol ContactStorageProtocol {
    // Loading list contacts
    func load() -> [ContactProtocol]
    //update list contacts
    //for save data
    func save(contact:[ContactProtocol])
}
class ContactStorage: ContactStorageProtocol{
    // Ссылка на хранилище
    private var linkStorage = UserDefaults.standard
    // Ключ, по которому будет происходить сохранение хранилища
    private var keySave = "contact"
    // Перечисление с ключами для записи в User Defaults
    private enum ContactKeys:String {
        case name
        case phone
    }
    func load() -> [ContactProtocol] {
        var resultContact: [ContactProtocol] = []
        let contactsFromStorage = linkStorage.array(forKey: keySave) as? [[String:String]] ?? []
        for contact in contactsFromStorage {
            guard let name = contact[ContactKeys.name.rawValue],
                  let phone = contact[ContactKeys.phone.rawValue] else {
                continue
            }
            resultContact.append(Contact(name: name, numberPhone: phone))
        }
        return resultContact
    }
    func save(contact: [ContactProtocol]) {
        var arrayForStorage: [[String:String]] = []
        contact.forEach { contacts in
            var newElementForStorage: Dictionary<String,String> = [:]
            newElementForStorage[ContactKeys.name.rawValue] = contacts.name
            newElementForStorage[ContactKeys.phone.rawValue] = contacts.numberPhone
            arrayForStorage.append(newElementForStorage)
        }
        linkStorage.set(arrayForStorage, forKey: keySave)
    }
}
