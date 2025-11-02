var gain = audio_sound_get_gain(music)
if (gain < 1) audio_sound_gain(music,1,500);
if (gain >= 1) audio_sound_gain(music,0,500);
