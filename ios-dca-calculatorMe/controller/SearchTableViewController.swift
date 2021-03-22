//
//  ViewController.swift
//  ios-dca-calculatorMe
//
//  Created by Иван Кочетков on 20.03.2021.
//

import UIKit
import Combine

class SearchTableViewController: UITableViewController { //хочу добавить ​​строку управления пользовательского интерфейса к первому контроллеру табличного представления.

    //назовем этот контроллер SearchTableViewController
    
    private lazy var searchController: UISearchController = { // создаем контроллер поиска
        let sc = UISearchController (searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Find company or ticker"
        sc.searchBar.autocapitalizationType = .allCharacters
        return sc
    } ()
    
    private let apiService = APIService()
    private var subscribers = Set <AnyCancellable> () //создали связь издатель - подписчик
    @Published private var searchQuerry = String () //наблюдаем за переменной из поискового запроса
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        observeForm()
        //performsSearch()
    }
    private func setupNavigationBar () {
        navigationItem.searchController = searchController
    }
    // ряд пунктов в разделах
    private func observeForm(){
        
        $searchQuerry
            .debounce(for: .milliseconds(750), scheduler: RunLoop.main)
            .sink {[unowned self] (searchQuerry) in
                //если происходит ошибка, она происходит здесь
                self.apiService.fetchSymbolsPublisher(keywords: searchQuerry).sink { (completion) in
                    switch completion {
                    case.failure (let error):
                        print(error.localizedDescription)
                    case.finished: break
                    }
                } receiveValue: { (searchResults) in
                    print(searchResults)
                }.store(in:&self.subscribers)
            }.store(in: &subscribers)
    }
    
    private func performsSearch() {
    }
        
    //ячейкb для роли
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int {
        return 5
    }
    // cellid идентфикатор ячейки
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath)
         return cell
      }
    //сгенерировали ленту с несколькими прототипами ячеек
}
extension SearchTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) { // обновление результатов поиска
        guard let searchQuerry =  searchController.searchBar.text,
              !searchQuerry.isEmpty else {return}
        // вызов API используя поисковой запрос
        self.searchQuerry = searchQuerry//запрос самопоиска равено самому поиску. Я что-то получаю из поиска,присваиваю значение
        
    }
}
