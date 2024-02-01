//
//  TableCell.swift
//  NotesByVakula
//
//  Created by Roman Vakulenko on 31.01.2024.
//

import UIKit


final class TableCell: UITableViewCell {

    // MARK: - Private properties
    private var note: NoteModel!

    private let noteTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    func setup(note: NoteModel) {
        self.note = note
        self.noteTitle.text = note.name
    }

    // MARK: - Private methods
    private func setupView() {
        contentView.addSubview(noteTitle)
    }

    private func layout() {
        NSLayoutConstraint.activate([
            noteTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.insetForCell*2),
            noteTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.insetForCell),
            noteTitle.topAnchor.constraint(equalTo: contentView.topAnchor),
            noteTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
