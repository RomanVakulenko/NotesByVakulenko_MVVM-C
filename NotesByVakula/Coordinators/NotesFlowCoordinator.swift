//
//  NotesFlowCoordinator.swift
//  NotesByVakula
//
//  Created by Roman Vakulenko on 31.01.2024.
//

import Foundation
import UIKit

protocol NotesCoordinatorProtocol: AnyObject {
    func pushSecondVC()
    func popToRootVC()
}


final class NotesFlowCoordinator {

    // MARK: - Private properties
    private var navigationController: UINavigationController

    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Private methods
    private func createFirstVC() -> UIViewController {
//        let fileManager = LocalFilesManager(mapper: mapper)
        let viewModel = TableViewModel(coordinator: self)
        let tableVC = TableViewController(viewModel: viewModel)
        let navController = UINavigationController(rootViewController: tableVC)
        navigationController = navController
        return navigationController
    }

    private func createSecondVC() -> UIViewController {
//        let fileManager = LocalFilesManager(mapper: mapper)
        let viewModel = NoteViewModel(coordinator: self)
        let vc = NoteViewController(viewModel: viewModel)
        return vc
    }

}


// MARK: - CoordinatorProtocol
extension NotesFlowCoordinator: CoordinatorProtocol {
    func start() -> UIViewController {
        let vc = createFirstVC()
        return vc
    }
}


// MARK: - FlowCoordinatorProtocol
extension NotesFlowCoordinator: NotesCoordinatorProtocol {

    func pushSecondVC() {
        let secondVC = createSecondVC()
        navigationController.pushViewController(secondVC, animated: true)
    }

    func popToRootVC() {
        navigationController.popToRootViewController(animated: true)
    }
}
