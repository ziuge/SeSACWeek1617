//
//  SubjectViewModel.swift
//  SeSACWeek1617
//
//  Created by CHOI on 2022/10/25.
//

import Foundation
import RxCocoa
import RxSwift

struct Contact {
    var name: String
    var age: Int
    var number: String
}

class SubjectViewModel {
    
    var contactData = [
        Contact(name: "Jack", age: 23, number: "01012341234"),
        Contact(name: "Hue", age: 19, number: "01056785678"),
        Contact(name: "Bro", age: 20, number: "01099998888")
    ]
    
    var list = PublishSubject<[Contact]>()
    
    func fetchData() {
        list.onNext(contactData)
    }
    
    func resetData() {
        list.onNext([])
    }
    
    func newData() {
        let new = Contact(name: "고래밥", age: Int.random(in: 10...50), number: "")
        contactData.append(new) // 추가하고나서
        list.onNext(contactData) // 덮어씌워주기
    }
    
    func filterData(query: String) {
        let result = query != "" ? contactData.filter {
            $0.name.contains(query)
        } : contactData
        list.onNext(result)
        
    }
    
}
