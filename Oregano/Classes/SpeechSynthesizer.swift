import AVFoundation

class SpeechSynthesizer {
    public static let shared = SpeechSynthesizer()
    private init() {}
    
    private let synthesizer = AVSpeechSynthesizer()
    public var volume: Float = 0.8
    public var language: String = "pt-BR"
    
    public func speak(_ string: String) {
        // Create an utterance.
        let utterance = AVSpeechUtterance(string: string)

        utterance.prefersAssistiveTechnologySettings = true
        
        // Configure the utterance.
        utterance.volume = volume

        // Retrieve the voice from selected language.
        let voice = AVSpeechSynthesisVoice(language: language)

        // Assign the voice to the utterance.
        utterance.voice = voice

        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        // Tell the synthesizer to speak the utterance.
        synthesizer.speak(utterance)
    }
}
