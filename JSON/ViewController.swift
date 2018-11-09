//
//  ViewController.swift
//  JSON
//
//  Created by Student on 09/11/2018.
//  Copyright © 2018 Student. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var copyrightLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load { photoInfo in
            self.updateUI(photoInfo: photoInfo)
        }
    }
    
    func updateUI(photoInfo: PhotoInfo){
        DispatchQueue.main.async {
            self.descriptionLabel.text = photoInfo.description
            self.copyrightLabel.text = photoInfo.copyright
        }
        let url = photoInfo.url
        let task = URLSession.shared.dataTask(with: url){
            data, _, _ in
            if let data = data, let image = UIImage(data: data){
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
        task.resume()
    }

    func load(completion: @escaping (PhotoInfo) -> Void){
        let url = URL(string: "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY")!
        let task = URLSession.shared.dataTask(with: url) {data, _, _ in
            let decoder = JSONDecoder()
                if let data = data,
                    let photoInfo = try? decoder.decode(PhotoInfo.self, from: data){
                    
                    completion(photoInfo)
            }
        }
        task.resume()
    }
}

