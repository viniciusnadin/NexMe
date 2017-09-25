import Foundation

struct FileStore {
    func saveObject(object: AnyObject, withName name: String) {
        NSKeyedArchiver.archiveRootObject(object, toFile: pathForFilename(filename: name))
    }
    
    func getObjectWithName(name: String) -> AnyObject? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: pathForFilename(filename: name)) as AnyObject?
    }
    
    func deleteObjectWithName(name: String) {
        let fileManager = FileManager.default
        let path = pathForFilename(filename: name)
        
        if fileManager.fileExists(atPath: path) {
            let _ = try? fileManager.removeItem(atPath: path)
        }
    }
    
    private var documentsDirectory: URL {
        return FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first!
    }

    private func pathForFilename(filename: String) -> String {
        return documentsDirectory.appendingPathComponent(filename).path
    }
}
