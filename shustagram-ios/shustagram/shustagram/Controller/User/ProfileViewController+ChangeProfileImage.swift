//
//  ProfileViewController+ChangeProfileImage.swift
//  shustagram
//
//  Created by 徐乾智 on 7/25/21.
//

import Foundation
import UIKit
import JGProgressHUD
import Alamofire

extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func handleChangeProfileImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            dismiss(animated: true) {
                self.uploadUserProfileImage(image: selectedImage)
            }
        } else {
            dismiss(animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func uploadUserProfileImage(image: UIImage) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Updating profile"
        hud.show(in: view)
        
        let url = "\(Service.shared.baseUrl)/profile"
        
        
        AF.upload(multipartFormData: { (formData) in
            guard let user = self.user else { return }
            
            formData.append(Data(user.fullName.utf8), withName: "fullName")
            
            guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
            formData.append(imageData, withName: "imagefile", fileName: "DoesntMatterSoMuch", mimeType: "image/jpg")
        }, to: url)
        .response { res in
            switch res.result {
            case .failure(let err):
                hud.dismiss()
                print("Failed to update profile:", err)
            case .success(_):
                hud.dismiss()
                if let c = res.response?.statusCode, c >= 300 {
                    print("Failed upload with status code: ", c)
                    return
                }
                print("Successfully updated user profile")
                
                self.fetchUserProfile()
            }
        }
    }
    
}
