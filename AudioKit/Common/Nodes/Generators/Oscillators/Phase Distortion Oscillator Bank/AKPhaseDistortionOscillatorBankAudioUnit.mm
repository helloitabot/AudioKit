//
//  AKPhaseDistortionOscillatorBankAudioUnit.mm
//  AudioKit
//
//  Created by Aurelius Prochazka, revision history on Github.
//  Copyright © 2017 Aurelius Prochazka. All rights reserved.
//

#import "AKPhaseDistortionOscillatorBankAudioUnit.h"
#import "AKPhaseDistortionOscillatorBankDSPKernel.hpp"

#import "BufferedAudioBus.hpp"

#import <AudioKit/AudioKit-Swift.h>

@implementation AKPhaseDistortionOscillatorBankAudioUnit {
    // C++ members need to be ivars; they would be copied on access if they were properties.
    AKPhaseDistortionOscillatorBankDSPKernel _kernel;
    BufferedInputBus _inputBus;
}
@synthesize parameterTree = _parameterTree;

- (void)setPhaseDistortion:(float)phaseDistortion {
    _kernel.setPhaseDistortion(phaseDistortion);
}

- (void)setAttackDuration:(float)attackDuration {
    _kernel.setAttackDuration(attackDuration);
}
- (void)setDecayDuration:(float)decayDuration {
    _kernel.setDecayDuration(decayDuration);
}
- (void)setSustainLevel:(float)sustainLevel {
    _kernel.setSustainLevel(sustainLevel);
}
- (void)setReleaseDuration:(float)releaseDuration {
    _kernel.setReleaseDuration(releaseDuration);
}
- (void)setDetuningOffset:(float)detuningOffset {
    _kernel.setDetuningOffset(detuningOffset);
}
- (void)setDetuningMultiplier:(float)detuningMultiplier {
    _kernel.setDetuningMultiplier(detuningMultiplier);
}

- (void)setupWaveform:(int)size {
    _kernel.setupWaveform((uint32_t)size);
}
- (void)setWaveformValue:(float)value atIndex:(UInt32)index; {
    _kernel.setWaveformValue(index, value);
}

- (void)startNote:(uint8_t)note velocity:(uint8_t)velocity {
    _kernel.startNote(note, velocity);
}
- (void)startNote:(uint8_t)note velocity:(uint8_t)velocity frequency:(float)frequency {
    _kernel.startNote(note, velocity, frequency);
}

- (void)stopNote:(uint8_t)note {
    _kernel.stopNote(note);
}

- (BOOL)isSetUp {
    return _kernel.resetted;
}

- (void)createParameters {

    standardSetup(PhaseDistortionOscillatorBank)

    AudioUnitParameterOptions flags = kAudioUnitParameterFlag_IsWritable | kAudioUnitParameterFlag_IsReadable | kAudioUnitParameterFlag_DisplayLogarithmic;

    // Create a parameter object for the phaseDistortion.
    AUParameter *phaseDistortionAUParameter = [AUParameter parameter:@"phaseDistortion"
                                                                name:@"Phase Distortion"
                                                             address:phaseDistortionAddress
                                                                 min:0.0
                                                                 max:1.0
                                                                unit:kAudioUnitParameterUnit_Generic];
    // Create a parameter object for the attackDuration.
    AUParameter *attackDurationAUParameter =
    [AUParameterTree createParameterWithIdentifier:@"attackDuration"
                                              name:@"Attack time"
                                           address:attackDurationAddress
                                               min:0
                                               max:99
                                              unit:kAudioUnitParameterUnit_Seconds
                                          unitName:nil
                                             flags:flags
                                      valueStrings:nil
                               dependentParameters:nil];
    // Create a parameter object for the decayDuration.
    AUParameter *decayDurationAUParameter =
    [AUParameterTree createParameterWithIdentifier:@"decayDuration"
                                              name:@"Decay time"
                                           address:decayDurationAddress
                                               min:0
                                               max:99
                                              unit:kAudioUnitParameterUnit_Seconds
                                          unitName:nil
                                             flags:flags
                                      valueStrings:nil
                               dependentParameters:nil];
    // Create a parameter object for the sustainLevel.
    AUParameter *sustainLevelAUParameter =
    [AUParameterTree createParameterWithIdentifier:@"sustainLevel"
                                              name:@"Sustain Level"
                                           address:sustainLevelAddress
                                               min:0
                                               max:99
                                              unit:kAudioUnitParameterUnit_Generic
                                          unitName:nil
                                             flags:flags
                                      valueStrings:nil
                               dependentParameters:nil];
    // Create a parameter object for the releaseDuration.
    AUParameter *releaseDurationAUParameter = [AUParameter parameter:@"releaseDuration"
                                                                name:@"Release time"
                                                             address:releaseDurationAddress
                                                                 min:0
                                                                 max:99
                                                                unit:kAudioUnitParameterUnit_Seconds];
    // Create a parameter object for the detuningOffset.
    AUParameter *detuningOffsetAUParameter = [AUParameter parameter:@"detuningOffset"
                                                               name:@"Frequency offset (Hz)"
                                                            address:detuningOffsetAddress
                                                                min:-1000
                                                                max:1000
                                                               unit:kAudioUnitParameterUnit_Hertz];
    // Create a parameter object for the detuningMultiplier.
    AUParameter *detuningMultiplierAUParameter = [AUParameter parameter:@"detuningMultiplier"
                                                                   name:@"Frequency detuning multiplier"
                                                                address:detuningMultiplierAddress
                                                                    min:0.0
                                                                    max:FLT_MAX
                                                                   unit:kAudioUnitParameterUnit_Generic];

    // Initialize the parameter values.
    phaseDistortionAUParameter.value = 0.0;

    attackDurationAUParameter.value = 0.1;
    decayDurationAUParameter.value = 0.1;
    detuningOffsetAUParameter.value = 0;
    detuningMultiplierAUParameter.value = 1;

    _kernel.setParameter(phaseDistortionAddress,    phaseDistortionAUParameter.value);
    _kernel.setParameter(attackDurationAddress,  attackDurationAUParameter.value);
    _kernel.setParameter(decayDurationAddress,   decayDurationAUParameter.value);
    _kernel.setParameter(sustainLevelAddress,    sustainLevelAUParameter.value);
    _kernel.setParameter(releaseDurationAddress, releaseDurationAUParameter.value);
    _kernel.setParameter(detuningOffsetAddress,     detuningOffsetAUParameter.value);
    _kernel.setParameter(detuningMultiplierAddress, detuningMultiplierAUParameter.value);

    // Create the parameter tree.
    _parameterTree = [AUParameterTree createTreeWithChildren:@[
        phaseDistortionAUParameter,
        attackDurationAUParameter,
        decayDurationAUParameter,
        sustainLevelAUParameter,
        releaseDurationAUParameter,
        detuningOffsetAUParameter,
        detuningMultiplierAUParameter
    ]];
	parameterTreeBlock(PhaseDistortionOscillatorBank)
}

AUAudioUnitGeneratorOverrides(PhaseDistortionOscillatorBank)


@end


