//
//  HomeScreenViewModel.swift
//  DeezerMusicTests
//
//  Created by Zvonimir Medak on 11/05/2020.
//  Copyright © 2020 Zvonimir Medak. All rights reserved.
//

import Foundation
import RxTest
import RxSwift
import Cuckoo
import Quick
import Nimble
@testable import DeezerMusic

class  HomeScreenViewModel: QuickSpec{
    
    override func spec(){
        describe("HomeScreenViewModel testing"){
            var homeScreenViewModel: HomeScreenViewModelImpl!
            var testScheduler: TestScheduler!
            var disposeBag: DisposeBag!
            beforeEach {
                homeScreenViewModel = HomeScreenViewModelImpl()
                disposeBag = DisposeBag()
                testScheduler = TestScheduler(initialClock: 0)
                homeScreenViewModel.initializeDataObservable().disposed(by: disposeBag)
            }
            
            describe("Loader logic") {
                it("Testing if the loader starts/stops"){
                    let loaderObserver = testScheduler.createObserver(Bool.self)
                    testScheduler.scheduleAt(10) {
                        homeScreenViewModel.loadData()
                    }
                    testScheduler.start()
                    expect(loaderObserver.events).to(equal([.next(10, true), .next(10, false)]))
                }
            }
        }
    }
}
