    //
    //  FilterService.swift
    //  Camera Filter
    //
    //  Created by Skander Bahri on 24/11/2020.
    //

    import UIKit
    import CoreImage
    import RxSwift

    class FilterService {
        private var context : CIContext
        init() {
            self.context = CIContext()
        }
        
        func applyFilter(to inputImage : UIImage) -> Observable<UIImage>{
            return Observable<UIImage>.create{ observer in
                self.applyFilter(to: inputImage){ filtredImage in
                    observer.onNext(filtredImage)
                }
                return Disposables.create()
            }
        }
        
        private func applyFilter(to inputImage : UIImage, completion: @escaping ((UIImage) -> ())){
            guard let filterStr = filterArraySimlified.randomElement() else { return }
            let filter = CIFilter(name: filterStr)
            filter?.setValue(5.0, forKey: kCIInputWidthKey)
            if let sourceImage = CIImage(image: inputImage){
                filter?.setValue(sourceImage, forKey: kCIInputImageKey )
                if let filter = filter {
                    if let outputImage = filter.outputImage {
                        if let cgImage = self.context.createCGImage(outputImage, from: outputImage.extent){
                            let processedImage = UIImage(cgImage: cgImage, scale: inputImage.scale, orientation: inputImage.imageOrientation)
                            completion(processedImage)
                        }
                    }
                }
            }
        }
    }
