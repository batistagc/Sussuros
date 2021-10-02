import AVFoundation

class SpeechSynthesizer {
    static let shared = SpeechSynthesizer()
    private init() {}
    
    private var nextSpeeches: [String] = []
    
    let synthesizer = AVSpeechSynthesizer()
    var volume: Float = 0.8
    var language: String = "pt-BR"
    
    func speak(_ string: String) {
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
    
    func addNextSpeech(_ speech: String) {
        nextSpeeches.insert(speech, at: 0)
    }
    
    func speakNextSpeech() {
        guard let nextSpeech = nextSpeeches.popLast() else { return }
        speak(nextSpeech)
    }
    
    func clearNextSpeeches() {
        nextSpeeches = []
    }
}
