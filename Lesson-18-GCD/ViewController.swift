//
//  ViewController.swift
//  Lesson-18-GCD
//
//  Created by Aleksandr Moroshovskyi on 18.04.2024.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    @IBAction func btnAction(_ sender: Any) {
        
        //MAIN Thread 1 Queue : com.apple.main-thread (serial)
        /*
        Інтерфейс завжди працює у main потоці, та все, що виконується
        у цьому ж потоці, блокує інтерфейс
         */
        debugPrint("🏁 RUN button did tap")
        Printer().printSomeText(text: "👾")
        debugPrint("☑️ RUN btnAction completed")
        
    }
}

