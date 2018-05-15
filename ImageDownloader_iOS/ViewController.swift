//
//  ViewController.swift
//  ImageDownloader_iOS
//
//  Created by hoya kim on 15/05/2018.
//  Copyright © 2018 ChameleoN. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDownloadDelegate {
	@IBOutlet weak var imgView: UIImageView!
	@IBOutlet weak var activityInd: UIActivityIndicatorView!
	@IBOutlet weak var progressView: UIProgressView!
	
	var download_task:URLSessionDownloadTask!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	/* URLSessionDownloadDelegate ----------------------------------------------*/
	func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
		let progress:Float = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
		progressView.setProgress(progress, animated: true)
	}
	
	func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
		let data:Data = try! Data(contentsOf: location)
		imgView.image = UIImage(data: data)
		activityInd.stopAnimating()
	}
	/*--------------------------------------------------------------------------*/
	
	@IBAction func downloadAction(_ sender: Any) {
		imgView.image = nil
		activityInd.startAnimating()
		progressView.setProgress(0.0, animated: false)
		
		let session_config = URLSessionConfiguration.default
		// Delegate
//		let session = URLSession(configuration: session_config, delegate: self, delegateQueue: OperationQueue.main)
//		download_task = session.downloadTask(with: URL(string: "https://raw.githubusercontent.com/ChoiJinYoung/iphonewithswift2/master/sample.jpeg")!)
		// Closures
		let session = URLSession(configuration: session_config, delegate: nil, delegateQueue: OperationQueue.main)
		download_task = session.downloadTask(with: URL(string: "https://raw.githubusercontent.com/ChoiJinYoung/iphonewithswift2/master/sample.jpeg")!, completionHandler: {(location, resposne, error) -> Void in
			let data:Data = try! Data(contentsOf: location!)
			self.imgView.image = UIImage(data: data)
			self.activityInd.stopAnimating()
		})
		download_task.resume()
	}
	
	@IBAction func suspendAction(_ sender: Any) {
		download_task.suspend()
	}
	
	@IBAction func resumeAction(_ sender: Any) {
		download_task.resume()
	}
	
	@IBAction func cancelAction(_ sender: Any) {
		download_task.cancel()
		activityInd.stopAnimating()
		progressView.setProgress(0.0, animated: false)
	}
}
