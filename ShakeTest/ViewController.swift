//
//  ViewController.swift
//  ShakeTest
//
//  Created by Mag isb-10 on 30/09/2024.
//

import UIKit
import Lottie
import CoreMotion

class ViewController: UIViewController {

  @IBOutlet weak var animationView: LottieAnimationView!
  @IBOutlet weak var counterLbl: UILabel!
  
  var count: Int = 0
  var motionManager: CMMotionManager!
  let shakeThresold: Double = 2.7
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    becomeFirstResponder()
    
    motionManager = CMMotionManager()
    
    if motionManager.isAccelerometerAvailable {
      motionManager.accelerometerUpdateInterval = 0.1
      motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { [weak self] data, error in
        guard let self = self, let data = data else { return }
        
        let acceleration = data.acceleration
        let magnitude = sqrt(acceleration.x * acceleration.x + acceleration.y * acceleration.y + acceleration.z * acceleration.z)
        
        if magnitude > self.shakeThresold {
          DispatchQueue.main.async {
            self.incrementCounter()
          }
        }
        
      }
    }
    
    
  }

  override var canBecomeFirstResponder: Bool {
    return true
  }
  
  func incrementCounter() {
    if count < 10 {
      count+=1
      counterLbl.text = "\(count)"
    } else {
      showAnimation()
    }
  }
  
  func showAnimation() {
    counterLbl.isHidden = true
    
    animationView.contentMode = .scaleAspectFill
    animationView.loopMode = .loop
    animationView.animationSpeed = 1.2
    animationView.play()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
      self.counterLbl.isHidden = false
      self.animationView.stop()
      self.count = 0
      self.counterLbl.text = "\(self.count)"
    }
    
  }

  deinit {
    motionManager.stopAccelerometerUpdates()
  }
}

