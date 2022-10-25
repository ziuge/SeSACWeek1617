//
//  RxCocoaExampleViewController.swift
//  SeSACWeek1617
//
//  Created by CHOI on 2022/10/24.
//

import UIKit
import RxCocoa
import RxSwift

class RxCocoaExampleViewController: UIViewController {

    @IBOutlet weak var simpleTableView: UITableView!
    @IBOutlet weak var simplePickerView: UIPickerView!
    @IBOutlet weak var simpleLabel: UILabel!
    @IBOutlet weak var simpleSwitch: UISwitch!
    
    @IBOutlet weak var signName: UITextField!
    @IBOutlet weak var signEmail: UITextField!
    @IBOutlet weak var signButton: UIButton!
    
    @IBOutlet weak var nicknameLabel: UILabel!
    
    var disposeBag = DisposeBag()
    var nickname = Observable.just("Jack")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nickname
            .bind(to: nicknameLabel.rx.text)
            .disposed(by: disposeBag)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
        }
        
        setTableView()
        setPickerView()
        setSwitch()
        setSign()
        setOperator()
    }

    func setTableView() {
        
        simpleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let items = Observable.just([ // 뭔가 보내는 곳. 뭔가 요소를 가지고 있음. 어떤 오퍼레이터가 just라고 보면 됨.
            "First Item",
            "Second Item",
            "Third Item"
        ])

        items
        .bind(to: simpleTableView.rx.items) { (tableView, row, element) in // 누가 구독하고 있는지? simpleTableView에서 연결이 된다. 세 가지 매개변수 가지고 있음.
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(element) @ row \(row)"
            return cell
        }
        .disposed(by: disposeBag)
        
        simpleTableView.rx.modelSelected(String.self)
            .map { data in // 최종적으로 bind 될 요소를 변경할 수도 있음
                "\(data)를 클릭했습니다."
            }
            .bind(to: simpleLabel.rx.text) // bind로 현 상태 묶어 label로 보냄
            .disposed(by: disposeBag)
    }
    
    func setPickerView() {
        let items = Observable.just([
                "영화",
                "애니메이션",
                "드라마",
                "기타"
            ])
     
        items
            .bind(to: simplePickerView.rx.itemTitles) { (row, element) in
                return element
            }
            .disposed(by: disposeBag)
        
        simplePickerView.rx.modelSelected(String.self)
            .map { $0.description } // 배열 스트링으로 변화 주기
            .bind(to: simpleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func setSwitch() {
        Observable.of(false)
            .bind(to: simpleSwitch.rx.isOn)
            .disposed(by: disposeBag)
    }

    func setSign() {
        // ex. 텍1(Observable), 텍2(Observable) > 그대로 레이블에 보여주기(Observer, bind)
        Observable.combineLatest(signName.rx.text.orEmpty, signEmail.rx.text.orEmpty) { value1, value2 in
            return "name: \(value1), email: \(value2)"
        }
        .bind(to: simpleLabel.rx.text)
        .disposed(by: disposeBag)
        
        // 이름 4글자 이상이면 이메일 텍스트필드가 나타나기
        signName.rx.text.orEmpty
            .map { $0.count < 4 }
            .bind(to: signEmail.rx.isHidden, signButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        signEmail.rx.text.orEmpty
            .map { $0.count > 4 }
            .bind(to: signButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        signButton.rx.tap // tap = touchUpInside
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                vc.showAlert()
            })
            .disposed(by: disposeBag)
        
    }
    
    func setOperator() {
        let itemsA = [3.3, 4.0, 5.0, 2.9, 3.6, 4.8]
        let itemsB = [2.3, 2.0, 1.3]
        
        // practice
        Observable.never()
            .subscribe {
                print("never printed here")
            }
            .disposed(by: disposeBag)
        
        Observable.empty()
            .subscribe { event in
                print(event)
            }
            .disposed(by: disposeBag)
        
        Observable.just("😘")
            .subscribe { event in
                print(event)
            }
            .disposed(by: disposeBag)
        
        let myObservable = { (element: String) -> Observable<String> in
            return Observable.create { observer in
                observer.on(.next(element))
                observer.on(.completed)
                return Disposables.create()
            }
        }
        myObservable("🧡")
            .subscribe { print($0) }
            .disposed(by: disposeBag)
        
        Observable.range(start: 1, count: 5) // 1부터 5까지
            .subscribe { print($0) }
            .disposed(by: disposeBag)
        
        Observable.repeatElement("⭐️")
            .take(5)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        Observable.generate( // as long as condition true
                initialState: 0,
                condition: { $0 < 5 },
                iterate: { $0 + 1 }
            )
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        Observable.deferred {
            print("create")
            return Observable.create { observer in
                print("emitting")
                observer.onNext("next")
                observer.onNext("next2")
                return Disposables.create()
            }
        }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
        
//        Observable<Int>.error(Error.Type)
//            .subscribe { print($0) }
//            .disposed(by: disposeBag)
        
        Observable.of("1", "2", "3", "4")
            .do(onNext: { print("Intercepted:", $0) },
                afterNext: { print("Intercepted after:", $0) },
                onError: { print("Intercepted Error:", $0)},
                afterError: { print("Intercepted after Error:", $0)},
                onCompleted: { print("Completed") },
                afterCompleted: { print("After Completed") })
                .subscribe(onNext: { print($0) })
                .disposed(by: disposeBag)
        
        Observable.just(itemsA)
            .subscribe { value in
                print("just - \(value)")
            } onError: { error in
                print("just - \(error)")
            } onCompleted: {
                print("just completed")
            } onDisposed: {
                print("just disposed")
            }
            .disposed(by: disposeBag)

        Observable.of(itemsA, itemsB)
            .subscribe { value in
                print("of - \(value)")
            } onError: { error in
                print("of - \(error)")
            } onCompleted: {
                print("of completed")
            } onDisposed: {
                print("of disposed")
            }
            .disposed(by: disposeBag)
        
        Observable.from(itemsA)
            .subscribe { value in
                print("from - \(value)")
            } onError: { error in
                print("from - \(error)")
            } onCompleted: {
                print("from completed")
            } onDisposed: {
                print("from disposed")
            }
            .disposed(by: disposeBag)
        
        Observable.repeatElement("Jack") // Infinite Observable Sequence
            .take(5) // Finite Observable Sequence
            .subscribe { value in
                print("repeat - \(value)")
            } onError: { error in
                print("repeat - \(error)")
            } onCompleted: {
                print("repeat completed")
            } onDisposed: {
                print("repeat disposed")
            }
            .disposed(by: disposeBag)
        
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe { value in
                print("interval - \(value)")
            } onError: { error in
                print("interval - \(error)")
            } onCompleted: {
                print("interval completed")
            } onDisposed: {
                print("interval disposed")
            }
            .disposed(by: disposeBag)

//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            self.disposeBag = DisposeBag() // 한번에 리소스 정리
//        }
        
    }
    
    deinit {
        print("RxCocoaExampleViewController")
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "하하하", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let ok = UIAlertAction(title: "확인", style: .default)
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
    
}
