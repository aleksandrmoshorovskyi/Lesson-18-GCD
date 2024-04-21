//
//  ViewController.swift
//  Lesson-18-GCD
//
//  Created by Aleksandr Moroshovskyi on 18.04.2024.
//

/*
 //ченсто використований код
 //виконуємо щось async,
 //потім передаємо в main - для змін на view, наприклад
 
 DispatchQueue.global(qos: .default).async {
     Printer().printSomeText(text: "🛑 default")
     
     DispatchQueue.main.async {
         Printer().printSomeText(text: "🎃 default")
     }
 }
 */

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var btn: UIButton!
    
    //оголошення своєї черги
    //let myQueue = DispatchQueue(label: "MyOwnQueue", qos: .default)
    let myQueue = DispatchQueue(label: "MyOwnQueue", attributes: .concurrent)
    
    //without .concurrent - it's Serial
    let myQueueSerial = DispatchQueue(label: "MyOwnQueue")
    
    //одна операція на весь клас
    let mySingleOperationQueue = OperationQueue()
    let mySingleOperationQueueSerial = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //if 1 - it's serial
        mySingleOperationQueueSerial.maxConcurrentOperationCount = 1
        
        //test
        progressView.progress = 0
    }
    
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBAction func thirdBtnAction(_ sender: Any) {
        
        debugPrint("🟤 Third button did tap")
        
        //Operation
        //runOperation()
        
        test()
            
        debugPrint("✔️ Third button action completed")
    }
    
    @IBAction func secondButtonAction(_ sender: Any) {
        
        debugPrint("🚛 BIG second button did tap")
        
        //runSomeInGLobalUserDefaultSYNC()
        //runSomeInGLobalUserDefault_ASYNC_ASYNC()
        
        //.concurrent
        //runSomeCode1()
        //runSomeCode2()
        //runSomeCode3()
        
        //.serial
        //runSomeCode1_async_mainasync()
        //runSomeCode2_async_mainasync()
        //runSomeCode3_async_mainasync()
        
        //DispatchGroup
        //runMultipleCodeInClobal()
        
        runMultipleCodeInClobalFor()
        
        debugPrint("✅ BIG secondButtonAction completed")
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
         ⛔️⛔️⛔️⛔️⛔️ ⛔️⛔️⛔️⛔️⛔️
         
         ⛔️ SYNC - SYNC ⛔️
         
         ⛔️⛔️⛔️⛔️⛔️ ⛔️⛔️⛔️⛔️⛔️
         
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
    
    //приклад, три func у одній черзі
    func runSomeCode1() {
        //DispatchQueue.global(qos: .default).async {
        myQueue.async {
            Printer().printSomeText(text: "1️⃣ default")
        }
    }
    
    func runSomeCode2() {
        //DispatchQueue.global(qos: .default).async {
        myQueue.async {
            Printer().printSomeText(text: "2️⃣ default")
        }
    }
    
    func runSomeCode3() {
        //DispatchQueue.global(qos: .default).async {
        myQueue.async {
            Printer().printSomeText(text: "3️⃣ default")
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///
    ///виконаємо код async і передамо результат у myQueueSerial
    func runSomeCode1_async_mainasync() {
        DispatchQueue.global(qos: .default).async {
            Printer().printSomeText(text: "1️⃣ default")
            self.myQueueSerial.sync {
                debugPrint("Code 1 has been finished")
            }
        }
    }
    
    func runSomeCode2_async_mainasync() {
        DispatchQueue.global(qos: .default).async {
            Printer().printSomeText(text: "2️⃣ default")
            self.myQueueSerial.sync {
                debugPrint("Code 2 has been finished")
            }
        }
    }
    
    func runSomeCode3_async_mainasync() {
        DispatchQueue.global(qos: .default).async {
            Printer().printSomeText(text: "3️⃣ default")
            self.myQueueSerial.sync {
                debugPrint("Code 3 has been finished")
            }
        }
    }
    
    
    //DispatchGroup
    func runMultipleCodeInClobal() {
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        let task1 = DispatchWorkItem {
            debugPrint("task1")
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        let task2 = DispatchWorkItem {
            debugPrint("task2")
            dispatchGroup.leave()
        }
        
        task2.perform()
        task1.perform()
        
        dispatchGroup.wait()
        
        debugPrint("Task1 and Task2 completed!")
    }
    
    func runMultipleCodeInClobalFor() {
        
        let dispatchGroup = DispatchGroup()
        var tasks: [DispatchWorkItem] = []
        
        for i in 0 ... 99 {
            dispatchGroup.enter()
            let task = DispatchWorkItem {
                debugPrint("task \(i)")
                dispatchGroup.leave()
            }
            tasks.append(task)
        }
        
        tasks.forEach { $0.perform() }
        
        dispatchGroup.wait()
        
        debugPrint("ALL Tasks completed!")
    }
    
    //Operation
    func runOperation() {
        
        let operationQueue = OperationQueue()
        //count of operations
        //if 1 - serial
        //if 2 and >2 - concurrent
        operationQueue.maxConcurrentOperationCount = 2
        
        //Operation
        
        operationQueue.addOperation {
            Printer().printSomeText(text: "🚗 operation 1")
        }
        
        operationQueue.addOperation {
            Printer().printSomeText(text: "🚙 operation 2")
        }
        
        operationQueue.addOperation {
            Printer().printSomeText(text: "🚕 operation 3")
        }
        
        operationQueue.addOperation {
            Printer().printSomeText(text: "🚓 operation 4")
        }
        
        //помітка для системи, що операція може бути скасована
        //operationQueue.cancelAllOperations()
    }
    
    //test виводу статусу завантаження на екран
    //ПОГАНИЙ ПРИКЛАД - ЯК НЕ ТРЕБА РОБИТИ)))
    func test() {
        
        let print = Printer()
        print.completion = { [weak self] params in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self?.counterLabel.text = params.text
                self?.progressView.progress = params.count
            }
        }
        
        DispatchQueue.global(qos: .default).async {
            
            print.printSomeTextWithCounter(text: "🚧 test")
        }
    }
    
}

