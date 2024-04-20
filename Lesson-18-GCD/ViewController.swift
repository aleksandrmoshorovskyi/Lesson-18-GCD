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
    
    @IBAction func secondButtonAction(_ sender: Any) {
        
        //runSomeInGLobalUserDefaultSYNC()
        runSomeInGLobalUserDefault_ASYNC_ASYNC()
    }
    
    @IBAction func btnAction(_ sender: Any) {
        
        //MAIN Thread 1 Queue : com.apple.main-thread (serial)
        /*
        Інтерфейс завжди працює у main потоці, та все, що виконується
        у цьому ж потоці, блокує інтерфейс
         
        debugPrint("🏁 RUN button did tap")
        Printer().printSomeText(text: "⏳")
        debugPrint("☑️ RUN btnAction completed")
         */
        
        //Виконаємо код у головній черзі main.async
        /*
        debugPrint("🏁 RUN button did tap")
        runSomeCodeInMain()
        debugPrint("☑️ RUN btnAction completed")
         */
        
        //паралельно з високим пріоритетом (інтерфейс активний)
        debugPrint("🏁 RUN button did tap")
        runSomeInGLobalUserInteractive()
        runSomeInGLobalUserInitiated()
        runSomeInGLobalUserDefault()
        debugPrint("☑️ RUN btnAction completed")
        
    }
    
    func runSomeCodeInMain() {
        
        //працювати з інтерфейсом можливо тільки в main.async
        DispatchQueue.main.async {
            //буде виконуватись дуже довго, блокуючи інтерфейс
            Printer().printSomeText(text: "☕️ Main -> Serial")
        }
    }
    
    func runSomeCodeInMainWRONGFUNC() {
        
        DispatchQueue.main.sync {
            //Thread 1: EXC_BREAKPOINT (code=1, subcode=0x10615e8f8)
            //Так робити не можна - DeadLock
            Printer().printSomeText(text: "⏳")
        }
    }
    
    //global черга з різним пріоритетом (інтерфейс активний)
    //userInteractive - високий пріоритет
    func runSomeInGLobalUserInteractive() {
        DispatchQueue.global(qos: .userInteractive).async {
            Printer().printSomeText(text: "🏀 userInteractive")
        }
    }
    
    //userInitiated - середній пріоритет
    func runSomeInGLobalUserInitiated() {
        DispatchQueue.global(qos: .userInitiated).async {
            Printer().printSomeText(text: "🧘‍♀️ userInitiated")
        }
    }
    
    //default - default пріоритет
    // (зазвичай використовують цей пріорітет)
    func runSomeInGLobalUserDefault() {
        DispatchQueue.global(qos: .default).async {
            Printer().printSomeText(text: "👍 default")
        }
    }
    
    func runSomeInGLobalUserDefaultSYNC() {
        
        /*
         якщо запустити sync, то спочатку виконається sync
         
         ДОКИ sync - інтерфейс буде заблоковано
         
         а потім async
         */
        
        DispatchQueue.global(qos: .default).sync {
            Printer().printSomeText(text: "🛑 default")
            
            DispatchQueue.main.async {
                Printer().printSomeText(text: "🎃 default")
            }
        }
    }
    
    func runSomeInGLobalUserDefault_ASYNC_ASYNC() {
        
        /*
         якщо запустити async - async,
         то усе одно спочатку виконається перша частина коду,
         потім друга
         
         АЛЕ інтерфейс буде ДОСТУПНИЙ
         
         і можна запустити ще код async
         */
        
        DispatchQueue.global(qos: .default).async {
            Printer().printSomeText(text: "🛑 default")
            
            DispatchQueue.main.async {
                Printer().printSomeText(text: "🎃 default")
            }
        }
    }
    
    func runSomeInGLobalUserDefault_SYNC_SYNC() {
        
        /*
         ⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️
         ⛔️ SYNC - SYNC ⛔️
         ⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️
         
         DEADLOCK
         
         🔒 🔒 🔒 🔒 🔒
         
         */
        
        DispatchQueue.global(qos: .default).sync {
            Printer().printSomeText(text: "🛑 default")
            
            DispatchQueue.main.sync {
                Printer().printSomeText(text: "🎃 default")
            }
        }
    }
    
    //utility - низький пріоритет
    func runSomeInGLobalUserUtility() {
        DispatchQueue.global(qos: .utility).async {
            Printer().printSomeText(text: "🥱 utility")
        }
    }
    
    //background - дуже низький пріоритет
    //може не завершитись, закенселетись,
    //якщо, наприклад, user піде з екрану
    func runSomeInGLobalUserBackground() {
        DispatchQueue.global(qos: .background).async {
            Printer().printSomeText(text: "🔙 background")
        }
    }
    
    //    ..1:12:55..
    
    //TODO
}

