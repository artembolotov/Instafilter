//
//  ImageSaver.swift
//  Instafilter
//
//  Created by artembolotov on 09.03.2023.
//

import UIKit

class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError: Error?, context: UnsafeRawPointer) {
        print("Save finished!")
    }
}
