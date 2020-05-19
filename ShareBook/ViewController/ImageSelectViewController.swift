//
//  ImageSelectViewController.swift
//  ShareBook
//
//  Created by 石田悠 on 2020/05/15.
//  Copyright © 2020 yuu.ishida. All rights reserved.
//

import UIKit

class ImageSelectViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
//MARK: - ライブラリ（カメラロール）を指定してピッカーを開く
    @IBAction func handleLibraryButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) { //isSourceTypeAvailableは利用可能確認
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }
    }
//MARK:-  カメラを指定してピッカーを開く
    @IBAction func handleCameraButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) { //isSourceTypeAvailableは利用可能確認
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)
        }
    }
//MARK:- 画面を閉じる
    @IBAction func handleCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
//MARK:- 写真を撮影(Usefoto)/選択したときに呼ばれる<必須>メソッド
       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           if info[.originalImage] != nil {
               
               let image = info[.originalImage] as! UIImage //  info[.originalImage]は撮影/選択された画像を取得する

               // あとでCLImageEditorライブラリの加工は行わない
               print("DEBUG_PRINT: image = \(image)1")
            
            // 投稿画面を開く
            let postViewController = self.storyboard?.instantiateViewController(withIdentifier: "Post") as! PostViewController
            postViewController.image = image
            picker.present(postViewController, animated: true, completion: nil)
            print("DEBUG_PRINT: image = \(image)2")
            

           }
        
       }
//MARK:- キャンセル(Retake)したときに呼ばれる<必須>メソッド
       func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           // ImageSelectViewController画面を閉じてタブ画面に戻る
//           self.presentingViewController?.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


}
