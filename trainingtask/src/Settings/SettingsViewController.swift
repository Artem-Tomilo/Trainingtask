import UIKit

/*
 SettingsViewController - экран Настройки, который отображает либо дефолтные, либо пользовательские настройки
 */

class SettingsViewController: UIViewController {
    
    private var settingsView = SettingsView()
    private let alertController = ErrorAlert()
    
    private let settingsManager: SettingsManager
    
    init(settingsManager: SettingsManager) {
        self.settingsManager = settingsManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        displaySettings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        settingsView.initFirstResponder()
    }
    
    private func setup() {
        navigationController?.isNavigationBarHidden = false
        self.title = "Настройки"
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        view.backgroundColor = .white
        
        view.addSubview(settingsView)
        
        NSLayoutConstraint.activate([
            settingsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            settingsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            settingsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveSettings(_:)))
        navigationItem.rightBarButtonItem = saveButton
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel(_:)))
        navigationItem.leftBarButtonItem = cancelButton
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureTapped(_:)))
        view.addGestureRecognizer(gesture)
    }
    
    /*
     Метод для отображения настроек в соответствующих полях, в случае обнаружения ошибок будет производиться их обработка
     */
    private func displaySettings() {
        do {
            let settings = try settingsManager.getSettings()
            
            settingsView.bindText(urlTextFieldText: settings.url,
                                  recordsTextFieldText: String(settings.maxRecords),
                                  daysTextFieldText: String(settings.maxDays))
        } catch {
            handleError(error)
        }
    }
    
    /*
     Метод сохранения пользовательских настроек, в случае обнаружения ошибок будет производиться их обработка
     */
    private func saveSettings() {
        let newSettings = Settings(url: settingsView.unbindUrl(), maxRecords: Int(settingsView.unbindRecords()) ?? 0, maxDays: Int(settingsView.unbindDays()) ?? 0)
        do {
            try settingsManager.saveUserSettings(settings: newSettings)
        } catch {
            handleError(error)
        }
    }
    
    /*
     Метод обработки ошибки - ошибка обрабатывается и вызывается алерт с предупреждением
     
     parameters:
     error - обрабатываемая ошибка
     */
    private func handleError(_ error: Error) {
        let settingsError = error as! BaseError
        alertController.showAlertController(message: settingsError.message, viewController: self)
    }
    
    /*
     Target на кнопку Save - вызывает метод сохранения пользовательских настроек и возвращает на экран Главное меню
     */
    @objc func saveSettings(_ sender: UIBarButtonItem) {
        saveSettings()
        navigationController?.popViewController(animated: true)
    }
    
    /*
     Target на кнопку Cancel - возвращает на экран Главное меню
     */
    @objc func cancel(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    /*
     Target для UITapGestureRecognizer, который скрывает клавиатуру при нажатии на сводобное пространство на экране
     */
    @objc func tapGestureTapped(_ sender: UITapGestureRecognizer) {
        guard sender.state == .ended else { return }
        view.endEditing(false)
    }
}
