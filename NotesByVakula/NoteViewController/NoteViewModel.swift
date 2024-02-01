//
//  NoteViewModel.swift
//  NotesByVakula
//
//  Created by Roman Vakulenko on 31.01.2024.
//


import UIKit

protocol AddNoteDelegate: AnyObject {
    func reloadData()
}

protocol EditNoteDelegate: AnyObject {
    func reloadEditedNoteAt(_ indexPath: IndexPath, dueTo tappedButton: NoteVCState)
}

final class NoteViewModel {

    // MARK: - Public properties
    private(set) var noteModel: NoteModel?
    var closureChangingText: ((String) -> Void)?
    var noteText: String = "" {
        didSet {
            closureChangingText?(noteText)
        }
    }

    // MARK: - Private properties
    private weak var coordinator: NotesCoordinatorProtocol?
    private weak var addNoteDelegate: AddNoteDelegate?
    private weak var editNoteDelegate: EditNoteDelegate?
    private var currentIndexPath: IndexPath?

    // MARK: - Init
    init(coordinator: NotesCoordinatorProtocol, existingModel: NoteModel, editDelegate: EditNoteDelegate, indexPath: IndexPath) {
        self.coordinator = coordinator
        self.noteModel = existingModel
        self.editNoteDelegate = editDelegate
        self.currentIndexPath = indexPath
    }

    init(coordinator: NotesCoordinatorProtocol, addDelegate: AddNoteDelegate) {
        self.coordinator = coordinator
        self.addNoteDelegate = addDelegate
    }

    // MARK: - Public methods
    func didTapBack(at state: NoteVCState) {
        if let indexPath = currentIndexPath {
            switch state {
            case .edit:
                editNoteDelegate?.reloadEditedNoteAt(indexPath, dueTo: .edit)
            default: return
            }
        } else {
            addNoteDelegate?.reloadData()
        }

        coordinator?.popToRootVC()
    }

}
