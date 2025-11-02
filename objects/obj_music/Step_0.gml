var gain = audio_sound_get_gain(music);
if (gain <= 0){
	audio_pause_sound(music);
} else {
	audio_resume_sound(music);
}