//
//  HomeViewController.swift
//  JAKMALLTakeHomeTest
//
//  Created by Abdiel CT MNC on 03/03/23.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    // MARK: - UI Variable -
    @IBOutlet weak var jokeTableView: UITableView!
    
    private var viewModel: HomeViewModel?
    private let bag = DisposeBag()
    private var fetchDetailJoke = PublishSubject<(category: String, amount: String)>()
    private var refreshJoke = PublishSubject<Void>()
    private var categoryDetail = ""
    private var sectionData = [HomeViewObject]()
    private var indexPathTemp: IndexPath = IndexPath(row: 0, section: 0)
    private let refreshControl = UIRefreshControl()
    private var flagAddMoreData = false
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        bindViewModel()
    }
    
    private func setUI() {
        
        title = "My Application"
        jokeTableView.register(
            JokeTableViewCell.nib(),
            forCellReuseIdentifier: JokeTableViewCell.identifier
        )
        jokeTableView.register(
            JokeCategoryHeaderTableViewCell.nib(),
            forCellReuseIdentifier: JokeCategoryHeaderTableViewCell.identifier
        )
        jokeTableView.register(
            AddJokeTableViewCell.nib(),
            forCellReuseIdentifier: AddJokeTableViewCell.identifier
        )
        jokeTableView.dataSource = self
        jokeTableView.delegate = self
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(
            self, action: #selector(self.refresh(_:)), for: .valueChanged
        )
        jokeTableView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        sectionData = [HomeViewObject]()
        refreshJoke.onNext()
    }
    
    private func bindViewModel(){
        viewModel = HomeViewModel()
        
        
        let input = HomeViewModel.Input(
            fetchJokeCategories: Observable.just(()).asDriverOnErrorJustComplete(),
            fetchDetailJoke: fetchDetailJoke.asDriverOnErrorJustComplete(),
            refreshJokes: refreshJoke.asDriverOnErrorJustComplete()
        )
        
        guard let output = viewModel?.transform(input: input) else { return }
        
        output.successFetchJokeCategories.drive(onNext: { viewObject in
            self.sectionData = viewObject
            self.jokeTableView.reloadData()
            self.refreshControl.endRefreshing()
        }).disposed(by: bag)
        
        output.successFetchDetailJoke.drive(onNext: { detailViewObject in
            if self.flagAddMoreData {
                self.sectionData[self.indexPathTemp.section].detail += detailViewObject.jokes ?? []
                self.jokeTableView.reloadSections(
                    [self.indexPathTemp.section], with: .none
                )
                self.flagAddMoreData = false
            }
            else {
                self.sectionData[self.indexPathTemp.section].detail = detailViewObject.jokes ?? []
                self.sectionData[self.indexPathTemp.section].isOpen.toggle()
                self.jokeTableView.reloadSections(
                    [self.indexPathTemp.section], with: .none
                )
                self.indexPathTemp = IndexPath(row: 0, section: 0)
            }
        }).disposed(by: bag)
        
        output.successRefreshJokes.drive(onNext: { viewObject in
            self.sectionData = viewObject
            self.jokeTableView.reloadData()
            self.refreshControl.endRefreshing()
        }).disposed(by: bag)
        
        output.loading.drive(onNext: { isLoading in
            isLoading ? self.showSpinner(onView: self.view) : self.removeSpinner()
        }).disposed(by: bag)
        
        output.error.drive(onNext: { error in
            guard let error = error as? BaseError else {return}
            self.showToast(message: error.getError.getDesc())
            self.refreshControl.endRefreshing()
        }).disposed(by: bag)
    }
    
    private func callApi(index: IndexPath) {
        let category = sectionData[index.section].category
        if sectionData[index.section].detail.isEmpty {
            if sectionData[index.section].category == category {
                fetchDetailJoke.onNext((category, "2"))
                indexPathTemp = index
            }
            else {
                sectionData[index.section].isOpen.toggle()
                jokeTableView.reloadSections([index.section], with: .none)
            }
        }
        else {
            sectionData[index.section].isOpen.toggle()
            jokeTableView.reloadSections([index.section], with: .none)
        }
    }

}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionData.count
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        let section = sectionData[section]
        
        if section.isOpen {
            return section.detail.count + 2
        }else {
            return 1
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: JokeCategoryHeaderTableViewCell.identifier,
                for: indexPath
            ) as! JokeCategoryHeaderTableViewCell
            cell.configure(
                category: sectionData[indexPath.section].category,
                index: indexPath.section
            )
            cell.delegate = self
            return cell
            
        }else {
            if indexPath.row == sectionData[indexPath.section].detail.count + 1 {
                if self.sectionData[indexPath.section].disableAddData == 2 {
                    return UITableViewCell()
                }
                else {
                    let cell = tableView.dequeueReusableCell(
                        withIdentifier: AddJokeTableViewCell.identifier,
                        for: indexPath
                    ) as! AddJokeTableViewCell
                    return cell
                }

            }
            else {
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: JokeTableViewCell.identifier,
                    for: indexPath
                ) as! JokeTableViewCell
                cell.configureCell(
                    joke: sectionData[indexPath.section].detail[indexPath.row - 1]
                )
                return cell
            }
        }
        
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if indexPath.row == 0 {
            self.callApi(index: indexPath)
        }
        else if indexPath.row ==  sectionData[indexPath.section].detail.count + 1{
            self.fetchDetailJoke.onNext((sectionData[indexPath.section].category, "1"))
            self.indexPathTemp = indexPath
            self.sectionData[indexPath.section].disableAddData += 1
            self.flagAddMoreData = true
        }
        else {
            self.showDialog(
                title: sectionData[indexPath.section].category,
                desc: sectionData[indexPath.section].detail[indexPath.row - 1].joke ?? ""
            )
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        if indexPath.row == 0 {
            return 60
        }
        else if indexPath.row == sectionData[indexPath.section].detail.count + 1{
            return 50
        }
        else {
            return 100
        }
    }
    
    
}

extension HomeViewController: JokeTableViewDelegate {
    func arrowClicked(category: String) {
        categoryDetail = category
    }
    
    func goTopClicked(index: Int) {
        sectionData.swapAt(0, index)
        jokeTableView.reloadData()
    }
}
