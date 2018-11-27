//
//  TextInputView.swift
//  Translate Messenger
//
//  Created by zhussupov on 11/23/18.
//  Copyright © 2018 Zhussupov. All rights reserved.
//

import Foundation
import UIKit
import Speech

enum Language {
    case Ru
    case En
}

protocol TextInputViewDelegate: class {
    func didTapSend(with message: Message)
    func textInputViewHeightChanged(to height: CGFloat)
}

class TextInputView: BaseView {
    
    // MARK:- Properties
    
    weak var delegate: TextInputViewDelegate?
    
    let audioEngine = AVAudioEngine()
    var recognitionTask: SFSpeechRecognitionTask? = nil
    
    var isRecording = false
    
    public var language: Language = .Ru {
        didSet {
            changeLanguage(language: language)
        }
    }
    
    private lazy var languageView: LanguageView = {
        let view = LanguageView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var messageTextViewHeightConstraint: NSLayoutConstraint!
    private var messageTextViewPlaceholder = "Русский"
    private lazy var messageTextView: UITextView = {
        let view = UITextView()
        view.textColor = .white
        view.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
        view.backgroundColor = .clear
        view.delegate = self
        view.isScrollEnabled = false
        view.setupAccessoryInput()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var sendButton: UIButton = {
        let view = UIButton()
        view.setImage(#imageLiteral(resourceName: "sendIcon"), for: .normal)
        view.contentHorizontalAlignment = .fill
        view.contentVerticalAlignment = .fill
        view.isHidden = true
        view.imageEdgeInsets = UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 9)
        view.addTarget(self, action: #selector(didTapSend), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var microphoneButton: UIButton = {
        let view = UIButton()
        view.setImage(#imageLiteral(resourceName: "mic"), for: .normal)
        view.contentHorizontalAlignment = .fill
        view.contentVerticalAlignment = .fill
        view.imageEdgeInsets = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        view.addTarget(self, action: #selector(didTapMic), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stopRecordingButton: UIButton = {
        let view = UIButton()
        view.isHidden = true
        view.addTarget(self, action: #selector(didTapStopRecording), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var recordingView: RecordingView = {
        let view = RecordingView()
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.activityIndicatorViewStyle = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK:- Setup
    
    override func setupView() {
        super.setupView()
        configureViews()
        configureConstraints()
        changeLanguage(language: .Ru, animated: false)
    }
    
    private func configureViews() {
        layer.cornerRadius = 22.0
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.white.cgColor
        
        [languageView, messageTextView,sendButton, microphoneButton, stopRecordingButton, indicatorView].forEach {
            addSubview($0)
        }
        
        stopRecordingButton.addSubview(recordingView)
    }
    
    private func configureConstraints() {
        
        messageTextViewHeightConstraint = messageTextView.heightAnchor.constraint(equalToConstant: 41.0)
        [
            heightAnchor.constraint(greaterThanOrEqualToConstant: 44.0),
            languageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4.0),
            languageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4.0),
            
            messageTextView.leadingAnchor.constraint(equalTo: languageView.trailingAnchor, constant: 6.0),
            messageTextView.topAnchor.constraint(equalTo: topAnchor, constant: 3.0),
            messageTextView.bottomAnchor.constraint(equalTo: bottomAnchor),
            messageTextViewHeightConstraint,
            messageTextView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -6.0),
            
            microphoneButton.widthAnchor.constraint(equalToConstant: 40.0),
            microphoneButton.heightAnchor.constraint(equalToConstant: 44.0),
            microphoneButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0.0),
            microphoneButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4.0),
            
            stopRecordingButton.widthAnchor.constraint(equalToConstant: 40.0),
            stopRecordingButton.heightAnchor.constraint(equalToConstant: 44.0),
            stopRecordingButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0.0),
            stopRecordingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4.0),
            
            recordingView.centerXAnchor.constraint(equalTo: stopRecordingButton.centerXAnchor),
            recordingView.centerYAnchor.constraint(equalTo: stopRecordingButton.centerYAnchor),
            
            indicatorView.centerXAnchor.constraint(equalTo: stopRecordingButton.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: stopRecordingButton.centerYAnchor),
            
            sendButton.widthAnchor.constraint(equalToConstant: 40.0),
            sendButton.heightAnchor.constraint(equalToConstant: 44.0),
            sendButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0.0),
            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4.0)
            ].forEach { $0.isActive = true }
    }
    
    // MARK:- Actions
    
    func showActivityIndicator() {
        sendButton.isHidden = true
        microphoneButton.isHidden = true
        stopRecordingButton.isHidden = true
        indicatorView.startAnimating()
    }
    
    func hideActivitoIndicator() {
        indicatorView.stopAnimating()
        adjustActionButton()
    }
    
    private func changeLanguage(language: Language, animated: Bool = true) {
        
        messageTextViewPlaceholder = language == .Ru ? "Русский" : "Английский"
        clearTextField()
        
        if animated {
            UIView.animate(withDuration: 0.2) {
                self.backgroundColor = language == .Ru ? Colors.themeColorRed : Colors.themeColorBlue
            }
        } else {
            backgroundColor = language == .Ru ? Colors.themeColorRed : Colors.themeColorBlue
        }
    }
    
    @objc private func didTapSend() {
        guard let messageText = messageTextView.text else { return }
        
        if messageText.trimmingCharacters(in: .whitespaces).isEmpty {
            return
        }
        
        let message = Message(text: messageText, source: .outgoing, primaryLanguage: language)
        
        clearTextField()
        delegate?.didTapSend(with: message)
    }
    
    @objc private func didTapMic() {
        if isRecording {
            return
        }
        
        if let task = recognitionTask {
            if !task.isFinishing {
                return
            }
        }
        
        isRecording = true
        adjustActionButton()
        
        languageView.isUserInteractionEnabled = false
        resignResponder()
        
        clearTextField()
        adjustPlaceholder()
        
        recordAndRecognizeSpeech()
    }
    
    @objc private func didTapStopRecording() {
        if !isRecording {
            return
        }
        isRecording = false
        if let task = recognitionTask {
            if !task.isFinishing {
                recognitionTask?.finish()
                audioEngine.inputNode.removeTap(onBus: 0)
            }
        } else {
            return
        }
        languageView.isUserInteractionEnabled = true
        adjustActionButton()
        if messageTextView.textColor == Colors.placeholderColor {
            clearTextField()
        }
        adjustPlaceholder()
    }
    
    func resignResponder() {
        messageTextView.resignFirstResponder()
    }
    
    func clearTextField() {
        messageTextView.text = ""
        adjustPlaceholder()
        textViewDidChange(messageTextView)
    }
    
    func recordAndRecognizeSpeech() {
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        let request = SFSpeechAudioBufferRecognitionRequest()
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            request.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            return print(error)
        }
        
        guard let myRecognizer = SFSpeechRecognizer() else {
            print("A recognizer is not supported for the current locale")
            return
        }
        if !myRecognizer.isAvailable {
            print("A recognizer is not available right now")
            return
        }
        
        let identifier = language == .Ru ? "ru-RU" : "en-US"
        
        let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale.init(identifier: identifier))
        
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { (result, error) in
            if let result = result {
                let bestString  = result.bestTranscription.formattedString
                if (self.isRecording) {
                    self.messageTextView.text = bestString
                    self.adjustPlaceholder()
                    self.textViewDidChange(self.messageTextView)
                }
            } else if let error = error {
                print(error)
            }
        })
        
    }
    
    private func adjustActionButton() {
        
        sendButton.isHidden = true
        microphoneButton.isHidden = true
        stopRecordingButton.isHidden = true
        
        if indicatorView.isAnimating {
            return
        }
        
        if isRecording {
            stopRecordingButton.isHidden = false
            recordingView.animate()
            return
        }
        
        if messageTextView.isFirstResponder {
            sendButton.isHidden = false
            return
        }
        
        if messageTextView.textColor == Colors.placeholderColor {
            microphoneButton.isHidden = false
        } else {
            sendButton.isHidden = false
        }
    }
    
    private func adjustPlaceholder() {
        
        if isRecording {
            if messageTextView.text != "Говорите..." {
                if messageTextView.text.isEmpty {
                    messageTextView.textColor = Colors.placeholderColor
                    messageTextView.text =  "Говорите..."
                    messageTextView.font = UIFont.systemFont(ofSize: 17.0, weight: .heavy)
                } else {
                    messageTextView.textColor = .white
                    messageTextView.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
                }
            }
            return
        }
        
        if messageTextView.isFirstResponder {
            if messageTextView.textColor == Colors.placeholderColor {
                messageTextView.text = nil
                messageTextView.textColor = .white
                messageTextView.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
            }
        } else {
            if messageTextView.text.isEmpty {
                messageTextView.textColor = Colors.placeholderColor
                messageTextView.text =  isRecording ? "Говорите..." : messageTextViewPlaceholder
                messageTextView.font = UIFont.systemFont(ofSize: 17.0, weight: .heavy)
            } else {
                messageTextView.textColor = .white
                messageTextView.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
            }
        }
        
    }
    
}

extension TextInputView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        adjustPlaceholder()
        didTapStopRecording()
        adjustActionButton()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        adjustPlaceholder()
        adjustActionButton()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        messageTextView.isScrollEnabled = estimatedSize.height > 100
        
        let toValue = min(estimatedSize.height, 100)
        
        if messageTextViewHeightConstraint.constant != toValue {
            messageTextViewHeightConstraint.constant = toValue
            self.delegate?.textInputViewHeightChanged(to: toValue)
        } else {
            messageTextViewHeightConstraint.constant = toValue
        }
        
        adjustActionButton()
        
    }
    
}

extension TextInputView: LanguageViewDelegate {
    func didChangeLanguage(to language: Language) {
        clearTextField()
        self.language = language
        adjustActionButton()
    }
}

