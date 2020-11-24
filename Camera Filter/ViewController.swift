//
//  ViewController.swift
//  Camera Filter
//
//  Created by Skander Bahri on 09/11/2020.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var filterUIButton: UIButton!
    @IBOutlet weak var mainImageView: UIImageView!
    
    let disposeBag = DisposeBag()
    private var defaultMainImage : UIImage? = nil
    private var didDefaultSelected : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let navC = segue.destination as? UINavigationController,
            let photoCVC = navC.viewControllers.first as? PhotosUICollectionViewController
        else {
            fatalError("segue destination is not found")
        }
        photoCVC.selectedPhoto.subscribe(onNext: { [weak self] image in
            DispatchQueue.main.async {
                self?.updateUI(with: image)
            }
        }).disposed(by: disposeBag)
    }
    @IBAction func applyFilterAction(_ sender: Any) {
        guard let sourceImage = defaultMainImage else { return }
        FilterService().applyFilter(to: sourceImage).subscribe(onNext: { [weak self] filtredImage in
            DispatchQueue.main.async {
                self?.mainImageView.image = filtredImage
            }
        }).disposed(by: disposeBag)
    }
    
    private func updateUI(with image: UIImage){
        self.mainImageView.image = image
        self.filterUIButton.isHidden = false
        if didDefaultSelected == false{
            self.defaultMainImage = image
        }
    }

}

