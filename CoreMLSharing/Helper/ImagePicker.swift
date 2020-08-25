//
//  ImagePicker.swift
//  CoreMLSharing
//
//  Created by Aurum on 24/08/20.
//  Copyright © 2020 Digital Khrisna. All rights reserved.
//

import Foundation
import SwiftUI

internal struct ImagePicker: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIImagePickerController
    typealias Coordinator = ImagePickerCoordinator
    
    @Binding internal var isShown: Bool
    internal var _completion: ((UIImage) -> Void)
    
    private let sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    internal func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
    }
    
    internal func makeCoordinator() -> ImagePicker.Coordinator {
        return ImagePickerCoordinator(isShown: $isShown, completion: _completion)
    }
    
    internal func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> ImagePicker.UIViewControllerType {
        
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
}

internal class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @Binding private var isShown: Bool
    private var _completion: ((UIImage) -> Void)
    
    internal init(isShown: Binding<Bool>, completion: @escaping ((UIImage) -> Void)) {
        _isShown = isShown
        _completion = completion
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        _completion(uiImage)
        isShown = false
        
    }
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isShown = false
    }
    
}
