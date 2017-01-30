//
//  NewMessageController.swift
//  Chat app
//
//  Created by Jane Hsieh on 1/22/17.
//  Copyright © 2017 Shooting Stars. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {
    
    let cellId = "cellId"
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)

        fetchuser()
    }
    
    func fetchuser() {
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
           
            if let dictionary = snapshot.value as? [String: AnyObject] {
            let user = User()
            user.id = snapshot.key
//            print(user.id)
                
                 user.setValuesForKeys(dictionary)
//                user.name = dictionary["name"] as! String?
//                user.email = dictionary["email"] as! String?
                self.users.append(user)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    func handleCancel() {
         dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell

        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        
        if let profileImageURL = user.profileImageURL {
            cell.profileImageView.loadImageUsingCache(urlString: profileImageURL)
            
//            let url = URL(string: profileImageURL)
//            
//            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
//            
//                if error != nil {
//                    print (error!)
//                    return
//                }
//                DispatchQueue.main.async( execute: {
//                    cell.profileImageView.image = UIImage(data: data!)
//
//                })
//                
//            }).resume()

        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    var messagesController: MessagesController?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
        print("Dismiss complete")
        let user = self.users[indexPath.row]
        self.messagesController?.showChatControllerForUser(user: user)
        print (user.id!)
        }
    }
}


