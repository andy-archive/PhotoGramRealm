//
//  FileManager+Extension.swift
//  PhotoGramRealm
//
//  Created by Taekwon Lee on 2023/09/05.
//

import UIKit

extension UIViewController {
    
    func documentDirectoryPath() -> URL? {
        //1. document path 찾기
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        return documentDirectory
    }
    
    func removeImageFromDocument(fileName: String) {
        //1. document path 찾기
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        //2. 저장할 경로 설정(세부 경로 & 이미지 저장할 위치)
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            print(error)
        }
    }
    
    // Document Folder에 이미지를 가져 오는 Method
    func loadImageFromDocument(fileName: String) -> UIImage {
        //1. document path 찾기
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return UIImage(systemName: "questionmark.square.dashed") ?? UIImage() }
        
        //2. 저장할 경로 설정(세부 경로 & 이미지 저장할 위치)
        let fileURL = documentDirectory.appendingPathComponent(fileName) // appendingPathComponent -> slash 역할
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path) ?? UIImage()
        } else {
            return UIImage(systemName: "questionmark.square.dashed") ?? UIImage()
        }
    }
    
    // Document Folder에 이미지를 저장하는 Method
    func saveImageToDocument(fileName: String, image: UIImage) {
        //1. document path 찾기
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        //2. 저장할 경로 설정(세부 경로 & 이미지 저장할 위치)
        let fileURL = documentDirectory.appendingPathComponent(fileName) // appendingPathComponent -> slash 역할
        
        //3. 이미지 변환
        guard let data = image.jpegData(compressionQuality: 0.5) else { return } // 압축률 조정
        
        // (+) 사용자 기기의 남은 저장 공간을 계산 -> 조건에 따라 이미지 저장
        
        //4. 이미지 저장 (file 저장은 do-try-catch 문을 자주 사용)
        do {
            try data.write(to: fileURL) // 데이터 저장 시 try 먼저 (우선 순위)
        } catch let error {
            print("file save error", error)
        }
    }
}
