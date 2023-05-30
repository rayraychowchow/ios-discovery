//
//  ImageProvider.swift
//  ios decovery
//
//  Created by Ray Chow on 30/5/2023.
//

import Foundation
import Kingfisher
import RxSwift
import UIKit

class ImageProvider {
    private let queue = DispatchQueue(label: "decovery.ImageProvider", qos: .default)
    
    private lazy var defaultOptions: KingfisherOptionsInfo = [.backgroundDecode, .transition(.fade(0.3)), .callbackQueue(.dispatch(queue))]

    private func getImageFromAsset(forName name: String) -> UIImage? {
        return UIImage(named: name)
    }
    
    func _getImage(forPath path: String?) -> Observable<UIImage> {
        Observable<UIImage>.create { [weak self] (observer) -> Disposable in
            guard let this = self, let _path = path, !_path.isEmpty else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            let isWebImage = path?.hasPrefix("http") != nil
            if isWebImage, let url = URL.init(string: _path) {
                // Get Image from Web
                // use retrievImage
                let resource = ImageResource(downloadURL: url)
                let downloadTask = KingfisherManager.shared.retrieveImage(with: resource, options: this.defaultOptions, progressBlock: nil) { result in
                    switch result {
                    case .success(let value):
                        observer.onNext(value.image)
                    case .failure(_):
                        break
                    }
                    observer.onCompleted()
                }
                return Disposables.create {
                    // Cancel image download task after dispose
                    downloadTask?.cancel()
                }
            } else {
                this.queue.async { [weak this] in
                    // Find image from Resource module
                    if let img = this?.getImageFromAsset(forName: _path) {
                        observer.onNext(img)
                    }
                    observer.onCompleted()
                }
                return Disposables.create()
            }
        }
    }
}
