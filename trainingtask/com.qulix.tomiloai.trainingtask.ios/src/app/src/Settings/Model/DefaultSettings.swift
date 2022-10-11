import Foundation

/*
 DefaultSettings - сервис для получения настроек по умолчанию
 */
class DefaultSettings {
    
    private var defaultSettings: Settings?
    
    /*
     getDefaultSettings - метод получения настроек по умолчанию
     
     Возвращаемое значение Settings? - настройки по умолчанию, значение опционально, т.к. оно может не прийти и возникнет ошибка
     Будет производиться обработка ошибочной ситуации в случае неполучения данных
     */
    func getDefaultSettings() throws -> Settings? {
        if let path = Bundle.main.path(forResource: "Settings", ofType: ".plist"),
           let dictionary = NSDictionary(contentsOfFile: path),
           let settingsDictionary = dictionary.object(forKey: "Settings") as? NSDictionary,
           let url = settingsDictionary.value(forKey: "Url") as? String,
           let records = settingsDictionary.value(forKey: "Records") as? Int,
           let days = settingsDictionary.value(forKey: "Days") as? Int {
            defaultSettings = Settings(url: url, maxRecords: String(records), maxDays: String(days))
            return defaultSettings
        }
        return nil
    }
}
