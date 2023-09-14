//
//  BackupViewController.swift
//  PhotoGramRealm
//
//  Created by Taekwon Lee on 2023/09/07.
//

import UIKit
import Zip

final class BackupViewController: BaseViewController {
    
    private let backupButton = {
        let view = UIButton()
        view.backgroundColor = .systemOrange
        return view
    }()
    
    private let restoreButton = {
        let view = UIButton()
        view.backgroundColor = .systemGreen
        return view
    }()
    
    private let backupTableView = {
        let view = UITableView()
        view.rowHeight = 50
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return view
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backupTableView.delegate = self
        backupTableView.dataSource = self

        backupButton.addTarget(self, action: #selector(backupButtonTapped), for: .touchUpInside)
        restoreButton.addTarget(self, action: #selector(restoreButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func backupButtonTapped() {
        //1. 백업하려는 파일의 경로 배열 생성
        var urlPaths = [URL]()
        
        //2. 도큐먼트 위치
        guard let path = documentDirectoryPath() else {
            
//            // 얼럿을 통해 파일 경로를 못 찾는 경로 메시지 띄우기
//            let alert = UIAlertController(title: "파일 위치에 오류가 있습니다", message: nil, preferredStyle: .alert)
//            let ok = UIAlertAction(title: "확인", style: .cancel) { _ in
//            }
//            alert.addAction(ok)
//            present(alert, animated: true)
            
            print("파일 위치에 오류가 있습니다")
            return
        }
        
        
        //3. 백업하고자 하는 파일의 경로 ~/.../Document/default.realm
        let realmFile = path.appendingPathComponent("default.realm")
        
        //4. 3번 경로가 유효한지 확인
        guard FileManager.default.fileExists(atPath: realmFile.path) else {
            print("백업할 파일이 이미 존재합니다")
            return
        }
        
        //5. 압축하고자 하는 파일을 배열에 추가
        urlPaths.append(realmFile)
        
        //6. 압축
        do {
            let zipFilePath = try Zip.quickZipFiles(urlPaths, fileName: "AndyArchive_\(Int.random(in: 1...100))")
            print("location: \(zipFilePath)")
        } catch {
            print("Failed to zip file")
        }
    }
    
    @objc
    private func restoreButtonTapped() {
        
        // File 앱을 통한 복구 진행
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.archive], asCopy: true) // ContentTypes만 고정
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true)
    }
    
    override func configure() {
        super.configure()

        view.addSubview(backupTableView)
        view.addSubview(backupButton)
        view.addSubview(restoreButton)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        
        backupTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            make.bottom.horizontalEdges.equalToSuperview()
        }
        
        backupButton.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.top.leading.equalTo(view.safeAreaLayoutGuide)
        }
        
        restoreButton.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

//MARK: UIDocumentPickerDelegate

extension BackupViewController: UIDocumentPickerDelegate {
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print(#function)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        guard let selectedFileURL = urls.first else { // File 앱에서의 URL
            print("선택한 파일에 오류가 있습니다")
            return
        }
        
        guard let path = documentDirectoryPath() else { // Document Folder의 위치
            print("도큐먼트 위치에 오류가 있습니다")
            return
        }
        
        // Document Folder에서 최종적으로 저장할 위치
        let sandboxFileURL = path.appendingPathComponent(selectedFileURL.lastPathComponent)
        
        // 경로에 복구할 파일(.zip)이 이미 있는지 확인
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
            let fileURL = path.appendingPathComponent("AndyArchive.zip")
            
            do { // 같은 파일이 있으면 덮어쓰기
                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { progress in
                    print("progress: \(progress)")
                }, fileOutputHandler: { unzippedFile in
                    print("Unzip success: \(unzippedFile)")
                })
            } catch {
                print("Failed to unzip")
            }
        } else {
        // 경로에 복구할 파일이 없을 때
            do {
                try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
                
                let fileURL = path.appendingPathComponent("AndyArchive.zip")
                
                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { progress in
                    print("progress: \(progress)")
                }, fileOutputHandler: { unzippedFile in
                    print("Unzip success: \(unzippedFile)")
                })
            } catch {
                print("Failed to unzip")
            }
            
            exit(0) // 앱 강제 종료
        }
    }
}

//MARK: UITableViewDelegate & UITableViewDataSource

extension BackupViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func fetchZipList() -> [String] {
        var list = [String]()
        
        do {
            guard let path = documentDirectoryPath() else { return list } // 파일 경로 가져 오기
            let docs = try FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
            let zip = docs.filter { $0.pathExtension == "zip" } // 파일의 확장자
            for item in zip {
                list.append(item.lastPathComponent) // 마지막 경로의 요소만 더하기
            }
        } catch {
            print("Error")
        }
        return list
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchZipList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell() }
        cell.textLabel?.text = fetchZipList()[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showActivityViewController(fileName: fetchZipList()[indexPath.row])
    }
    
    private func showActivityViewController(fileName: String) {
        
        guard let path = documentDirectoryPath() else {
            print("도큐먼트 위치에 오류가 있습니다")
            return
        }
        
        let backupFileURL = path.appendingPathComponent(fileName)
        
        let vc = UIActivityViewController(activityItems: [backupFileURL], applicationActivities: [])
        present(vc, animated: true)
    }
}
