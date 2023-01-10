//
//  WelcomeViewController.swift
//  TestApp
//
//  Created by Vlad Lytvynets on 11.09.2022.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage

class WelcomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let picker = UIImagePickerController()
    
    @IBOutlet weak var mainImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainImage.layer.cornerRadius = 25
        self.picker.delegate = self
        self.picker.allowsEditing = true
      
    }
    
    
    @IBAction func logoutAction(_ sender: Any) {
        print("Print")
        do{
            try Auth.auth().signOut()
        }catch{
            print(error)
        }
    }
    
    //Adding a profile photo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let originImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.mainImage.image = originImage
        guard let image = mainImage.image?.imageAsset?.value(forKey: "assetName") else { return }
        print("NAME: \(image)")
        self.picker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addImage(_ sender: UIButton) {
        self.picker.sourceType = .photoLibrary
      //  let storageRef = Storage.storage().reference()
     //   guard let id = Auth.auth().currentUser?.uid else { return }
      //  guard let image = mainImage.image?.imageAsset?.value(forKey: "assetName") else { return }
      //  let riversRef = storageRef.child("\(id) /").storage.
       // riversRef.child(<#T##path: String##String#>)
      //  print("NAME: \(riversRef)")
        self.getImg(name: "084D02A0-0046-402F-82BC-328A9CEA47F1") { img in
            self.mainImage.image = img
        }
        self.present(picker, animated: true)
    }
    
    
    @IBAction func uploadImage(_ sender: UIButton) {
        addImgData()
    }
    
    
    func getImg(name: String, completion: @escaping (UIImage) -> Void){
        print("GETImage")
        let storageRef = Storage.storage()
        let reference = storageRef.reference()
        let refPath = reference.child("0qEYH3da1bMv8MdLeRAig1tFerz2 /")
        
        var image = UIImage(named: "3a34230e7c01ae8731abe980d2b165eb")!
        
        let fileRef = refPath.child(name + ".jpg")
        fileRef.getData(maxSize: 4288*2848) { data, error in
            guard error == nil else {completion(image); return }
            image = UIImage(data: data!)!
            completion(image)
        }
    }
    
    
    
    func addImgData() {
        let img = mainImage.image
        let storageRef = Storage.storage().reference()
        // Create a reference to the file you want to upload
        
        guard let id = Auth.auth().currentUser?.uid else { return }
        print("IiiiiiiiiiiiiiiiiiiiiiiiiiD: \(String(describing: id))")
        guard let image = mainImage.image?.imageAsset?.value(forKey: "assetName") else { return }
        let riversRef = storageRef.child("\(id) /\(image).jpg")
        print("PHOTO: \(riversRef.fullPath.count)")
        // Upload the file to the path "images/rivers.jpg"
        riversRef.putData((img?.pngData())!, metadata: nil) { (metadata, error) in
            guard metadata != nil else {
                print("Error UPLOAD DDDDAAAATTTAAAAA \(String(describing: error))")
                return
            }
            // You can also access to download URL after upload.
            riversRef.downloadURL { (url, error) in
                guard url != nil else {
                    //print(downloadURL)
                    return
                }
            }
        }
    }
}
