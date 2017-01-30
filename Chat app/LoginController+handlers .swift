//
//  LoginController+handlers .swift
//  Chat app
//
//  Created by Jane Hsieh on 1/22/17.
//  Copyright © 2017 Shooting Stars. All rights reserved.
//

import UIKit
import Firebase

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func handleRegister() {

        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text
        
        else {
            print("Form is not valid")
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion:{(user: FIRUser?, error) in
            
            if error != nil {
                print (error!)
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
//            sucessfully authenticated user
            let imageName = NSUUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageName).jpg")
            
            if let profileImage = self.profileImage.image, let uploadData = UIImageJPEGRepresentation(profileImage, 1/100000) {
                
            
            
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil {
                        print(error!)
                        return
                        
                    }
                    
                    if let profileImageURL = metadata?.downloadURL()?.absoluteString {
                    
                        let values = ["name": name,"email":email,"profileImageURL":profileImageURL]
                        
                        self.registerUserIntoDatabase(uid: uid, values: values)
                    }
                })
            }
        })
        
    }
    
    private func registerUserIntoDatabase(uid:String,values:[String:String]) {
        
        let ref = FIRDatabase.database().reference()
        let usersReference = ref.child("users").child(uid)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (Error, ref) in
        
            if Error != nil {
                print(Error!)
                return
            }
            
//            self.messagesController?.navigationItem.title = values["name"]
            let user = User()
            user.setValuesForKeys(values)
            self.messagesController?.setupNavBarWithUser(user: user)
            
            self.dismiss(animated: true, completion: nil)
            
        })
    }
    
    func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        }
        else if let originalImage =  info["UIImagePickerControllerOriginalImage"] as? UIImage {
        
            selectedImageFromPicker = originalImage
            
        }
            
            if let selectedImage = selectedImageFromPicker {
                profileImage.image = selectedImage
            }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canclled picker")
        dismiss(animated: true, completion: nil)
        
    }
}
