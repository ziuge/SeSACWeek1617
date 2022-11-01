//
//  ValidationViewController.swift
//  SeSACWeek1617
//
//  Created by CHOI on 2022/10/27.
//

import UIKit
import RxSwift
import RxCocoa

class ValidationViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var validationLabel: UILabel!
    @IBOutlet weak var stepButton: UIButton!
    
    let disposeBag = DisposeBag()
    let viewModel = ValidationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
        
    }

    func bind() {
        
        // After
        let input = ValidationViewModel.Input(text: nameTextField.rx.text, tap: stepButton.rx.tap) // 뷰모델로 데이터를 보내줌
        let output = viewModel.transform(input: input)
        
        output.text
            .drive(validationLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.validation
            .bind(to: stepButton.rx.isEnabled, validationLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.validation
            .withUnretained(self)
            .bind { (vc, value) in
                let color: UIColor = value ? .systemPink : .lightGray
                vc.stepButton.backgroundColor = color
            }
            .disposed(by: disposeBag)
        
        output.tap
            .bind { _ in
                print("SHOW ALERT")
            }
            .disposed(by: disposeBag)

        // Before
        viewModel.validText // Output
            .asDriver() // 여기서 asDriver로 변환 과정이 필요함!
            .drive(validationLabel.rx.text)
            .disposed(by: disposeBag)
        
        let validation = nameTextField.rx.text // String? (Optional) // Input
            .orEmpty // String? -> String
            .map { $0.count >= 8 } // String -> Bool
            .share() // Subject, Relay

        validation
            .bind(to: stepButton.rx.isEnabled, validationLabel.rx.isHidden)
            .disposed(by: disposeBag)

        validation
            .withUnretained(self)
            .bind { (vc, value) in
                let color: UIColor = value ? .systemPink : .lightGray
                vc.stepButton.backgroundColor = color
            }
            .disposed(by: disposeBag)
        
        stepButton.rx.tap // Input
            .bind { _ in
                print("SHOW ALERT")
            }
            .disposed(by: disposeBag)
        
    }
    
    func observableVSSubject() {
        
        let testA = stepButton.rx.tap
            .map { "안녕하세요" }
            .asDriver(onErrorJustReturn: "")
//            .share()

        testA
//            .bind(to: validationLabel.rx.text)
            .drive(validationLabel.rx.text)
            .disposed(by: disposeBag)
        
        testA
//            .bind(to: nameTextField.rx.text)
            .drive(nameTextField.rx.text)
            .disposed(by: disposeBag)
        
        testA
//            .bind(to: stepButton.rx.title())
            .drive(stepButton.rx.title())
            .disposed(by: disposeBag)
        
        
        let sampleInt = Observable<Int>.create { observer in
            observer.onNext(Int.random(in: 1...100))
            return Disposables.create()
        }
     
        sampleInt.subscribe { value in
            print("sampleInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        sampleInt.subscribe { value in
            print("sampleInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        sampleInt.subscribe { value in
            print("sampleInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        
        let subjectInt = BehaviorSubject(value: 0)
        subjectInt.onNext(Int.random(in: 1...100))
        
        subjectInt.subscribe { value in
            print("subjectInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        subjectInt.subscribe { value in
            print("subjectInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        subjectInt.subscribe { value in
            print("subjectInt: \(value)")
        }
        .disposed(by: disposeBag)
    }
}
