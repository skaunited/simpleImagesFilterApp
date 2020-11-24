//
//  PhotosUICollectionViewController.swift
//  Camera Filter
//
//  Created by Skander Bahri on 23/11/2020.
//

import UIKit
import Photos
import RxSwift

class PhotosUICollectionViewController: UICollectionViewController {
    
    private var images = [PHAsset]()
    private let selectedPhotoSubject = PublishSubject<UIImage>()
    var selectedPhoto : Observable<UIImage>{
        selectedPhotoSubject.asObservable()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register cell classes
        populatePhotos()


    }

    private func populatePhotos(){
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            if status == .authorized {
                // here can I select a photo from the photos library
                let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
                assets.enumerateObjects { (object, count, stop) in
                    self?.images.append(object )
                }
                self?.images.reverse()
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
        }
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return images.count 
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCollectionViewCell", for: indexPath) as? PhotosCollectionViewCell
        else { return UICollectionViewCell() }
    
        // Configure the cell
        let asset = images[indexPath.row]
        let manager = PHImageManager.default()
        manager.requestImage(for: asset, targetSize: CGSize(width: 120, height: 120), contentMode: .aspectFit, options: nil){ image , info in
            DispatchQueue.main.async {
                let isDegradedImage = info?["PHImageResultIsDegradedKey"] as! Bool
                if !isDegradedImage{
                    if let image = image{
                        cell.imageView.image = image
                    }
                }
            }
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedAssets = images[indexPath.row]
        PHImageManager.default().requestImage(for: selectedAssets, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFit, options: nil)
        { [weak self] image, info in
            guard let info = info else { return }
            let isDegradedImage = info["PHImageResultIsDegradedKey"] as! Bool
            // if image has a good resolution then I get it
            if !isDegradedImage{
                if let image = image{
                    self?.selectedPhotoSubject.onNext(image)
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }

    

}
