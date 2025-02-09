//
//  CryptoTests.swift
//  CryptoTests
//
//  Created by Oskar Emilsson on 2025-02-03.
//

import XCTest
@testable import Crypto

final class MainViewModelTests: XCTestCase {
    
    var viewModel: MainViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = MainViewModel(cryptoList: MainViewModel.dummyData, isDebug: true)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
    }
    
    func testFilteredCurrenciesWithSearchText() {
        viewModel.searchText = "Bitcoin"
        let filtered = viewModel.filteredCurrencies
        XCTAssertEqual(filtered.count, 2)
        XCTAssertEqual(filtered.first?.name, "Bitcoin")
    }
    
    func testFilteredCurrenciesWithSearchTextNoResults() {
        viewModel.searchText = "abcabcabc"
        let filtered = viewModel.filteredCurrencies
        XCTAssertEqual(filtered.count, 0)
    }
}
