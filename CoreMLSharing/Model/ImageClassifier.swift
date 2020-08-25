//
//  ImageClassifier.swift
//  CoreMLSharing
//
//  Created by Aurum on 25/08/20.
//  Copyright © 2020 Digital Khrisna. All rights reserved.
//

import CoreML
import UIKit
import Vision

internal class ImageClassifier {
    private let coreMLModel: VNCoreMLModel
    private var classificationResult: [String] = []
    private var completion: ((String) -> Void)?
    
    private lazy var visionRequest: VNCoreMLRequest = {
        let request = VNCoreMLRequest(model: self.coreMLModel) { [weak self] request, _ in
            self?.processResult(request: request)
        }
        request.imageCropAndScaleOption = .centerCrop
        return request
    }()
    
    init?(coreMLModel: MLModel) {
        if let model = try? VNCoreMLModel(for: coreMLModel) {
            self.coreMLModel = model
        } else {
            return nil
        }
    }
    
    internal func classify(images: [UIImage], completion: ((String) -> Void)?) {
        self.classificationResult = []
        self.completion = completion
        DispatchQueue.global(qos: .background).async {
            let handlers = images.compactMap { image -> VNImageRequestHandler? in
                guard let cgImage = image.cgImage,
                    let orientation = CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue)) else {
                        return nil
                }
                return VNImageRequestHandler(cgImage: cgImage, orientation: orientation, options: [:])
            }
            
            handlers.forEach { handler in
                do {
                    try handler.perform([self.visionRequest])
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func processResult(request: VNRequest) {
        guard let result = request.results?.first as? VNClassificationObservation else { return }
        classificationResult.append(result.identifier)
        completion?(classificationResult.joined(separator: ", "))
    }
}
