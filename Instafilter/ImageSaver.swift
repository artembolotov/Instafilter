//
//  ImageSaver.swift
//  Instafilter
//
//  Created by artembolotov on 09.03.2023.
//

import UIKit

class ImageSaver: NSObject {
    var sucessHandler: (() -> Void)?
    var errorHandler: ((Error) -> Void)?
    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, context: UnsafeRawPointer) {
        if let error {
            errorHandler?(error)
        } else {
            sucessHandler?()
        }
    }
}
