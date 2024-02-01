//
//  NotesFlowCoordinator.swift
//  NotesByVakula
//
//  Created by Roman Vakulenko on 31.01.2024.
//


import UIKit

protocol NotesCoordinatorProtocol: AnyObject {
    func pushAddNewNoteVC(noteVCState: NoteVCState, delegate: AddNoteDelegate)
    func pushEditNoteVC(
        modelForEdit: NoteModel,
        noteState: NoteVCState,
        delegate: EditNoteDelegate,
        indexPath: IndexPath
    )
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
        let viewModel = TableViewModel(coordinator: self)
        let tableVC = TableViewController(viewModel: viewModel)
        let navController = UINavigationController(rootViewController: tableVC)
        navigationController = navController
        return navigationController
    }

    private func makeAddNewNoteVC(addDelegate: AddNoteDelegate, noteState: NoteVCState) -> UIViewController {
        let viewModel = NoteViewModel(coordinator: self, addDelegate: addDelegate)
        let addNoteVC = NoteViewController(viewModel: viewModel, noteState: noteState)
        return addNoteVC
    }

    private func makeEditNoteVC(modelForEdit: NoteModel, noteState: NoteVCState, editNoteDelegate: EditNoteDelegate, indexPath: IndexPath) -> UIViewController {
        let viewModel = NoteViewModel(
            coordinator: self,
            existingModel: modelForEdit,
            editDelegate: editNoteDelegate,
            indexPath: indexPath
        )
        let editNoteVC = NoteViewController(viewModel: viewModel, noteState: noteState)
        return editNoteVC
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

    func pushAddNewNoteVC(noteVCState: NoteVCState, delegate: AddNoteDelegate) {
        let vc = makeAddNewNoteVC(addDelegate: delegate, noteState: noteVCState)
        navigationController.pushViewController(vc, animated: true)
    }

    func pushEditNoteVC(modelForEdit: NoteModel, noteState: NoteVCState, delegate: EditNoteDelegate, indexPath: IndexPath) {
        let vc = makeEditNoteVC(
            modelForEdit: modelForEdit,
            noteState: noteState,
            editNoteDelegate: delegate,
            indexPath: indexPath
        )
        navigationController.pushViewController(vc, animated: true)
    }

    func popToRootVC() {
        navigationController.popToRootViewController(animated: true)
    }
}
