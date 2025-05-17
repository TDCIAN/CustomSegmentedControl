//
//  MainViewController.swift
//  CustomSegmentedControl
//
//  Created by 김정민 on 5/17/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    
    private lazy var underlineSegmentedControl: UISegmentedControl = {
        let segmentedControl = UnderlineSegmentedControl(items: ["First", "Second", "Third"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.gray,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold)
            ],
            for: .normal
        )
        segmentedControl.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.systemBlue,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold)
            ],
            for: .selected
        )
        return segmentedControl
    }()
    
    private let firstViewController: FirstViewController = FirstViewController()
    private let secondViewController: SecondViewController = SecondViewController()
    private let thirdViewController: ThirdViewController = ThirdViewController()

    private var dataViewControllers: [UIViewController] {
        return [firstViewController, secondViewController, thirdViewController]
    }

    private lazy var pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
        pageViewController.setViewControllers(
            [dataViewControllers[0]],
            direction: .forward,
            animated: false,
            completion: nil
        )
        pageViewController.dataSource = self
        pageViewController.delegate = self
        return pageViewController
    }()
    
    private var currentPage: Int = 0 {
        didSet {
            // from segmentedControl -> pageViewController update
            print("### currentPage - oldValue: \(oldValue), currentPage: \(currentPage)")
            
            let direction: UIPageViewController.NavigationDirection = oldValue <= currentPage ? .forward : .reverse
            
            pageViewController.setViewControllers(
                [dataViewControllers[currentPage]],
                direction: direction,
                animated: true,
                completion: nil
            )
        }
    }
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bind()
    }

    private func setUI() {
        view.addSubview(underlineSegmentedControl)
        view.addSubview(pageViewController.view)
        
        underlineSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview().inset(4)
            make.height.equalTo(50)
        }
        
        pageViewController.view.snp.makeConstraints { make in
            make.top.equalTo(underlineSegmentedControl.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func bind() {
        underlineSegmentedControl.rx.selectedSegmentIndex
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, selectedIndex in
                print("### subscribe - selectedIndex: \(selectedIndex)")
                owner.currentPage = selectedIndex
            })
            .disposed(by: disposeBag)
    }
}

extension MainViewController: UIPageViewControllerDataSource {
    
    
    /*
     MARK: 한국어
     기능: 현재 보여지고 있는 뷰 컨트롤러 기준으로 이전(왼쪽) 뷰 컨트롤러를 반환
     호출 시점: 사용자가 이전(왼쪽)으로 스와이프할 때 호출
     반환값: 현재 뷰 컨트롤러가 첫 번째라면(nil 반환), 더 이상 이전 페이지가 없으므로 스와이프가 멈춤
     
     MARK: English
     Function: Returns the previous (left) view controller based on the currently displayed view controller
     When called: Called when the user swipes to the previous (left) page
     Return value: Returns nil if the current view controller is the first one, so swiping stops as there are no more previous pages
     */
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        
        guard let index = dataViewControllers.firstIndex(of: viewController),
              index - 1 >= 0
        else { return nil }
        
        return dataViewControllers[index - 1]
    }
    
    /*
     MARK: 한국어
     기능: 현재 보여지고 있는 뷰 컨트롤러 기준으로 다음(오른쪽) 뷰 컨트롤러를 반환
     호출 시점: 사용자가 다음(오른쪽)으로 스와이프할 때 호출
     반환값: 현재 뷰 컨트롤러가 마지막이라면(nil 반환), 더 이상 다음 페이지가 없으므로 스와이프가 멈춤

     MARK: English
     Function: Returns the next (right) view controller based on the currently displayed view controller
     When called: Called when the user swipes to the next (right) page
     Return value: Returns nil if the current view controller is the last one, so swiping stops as there are no more next pages
     */
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        
        guard let index = dataViewControllers.firstIndex(of: viewController),
              index + 1 < dataViewControllers.count
        else { return nil }
        
        return dataViewControllers[index + 1]
    }
}

extension MainViewController: UIPageViewControllerDelegate {
    /*
     MARK: 한국어
     기능: 사용자가 페이지를 스와이프(드래그)해서 이동하는 애니메이션이 끝났을 때 호출됨

     MARK: English
     Function: Called when the animation for swiping (dragging) between pages finishes
     */
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard let viewController = pageViewController.viewControllers?.first,
              let index = dataViewControllers.firstIndex(of: viewController)
        else { return }
        
        currentPage = index
        underlineSegmentedControl.selectedSegmentIndex = index
    }
}
