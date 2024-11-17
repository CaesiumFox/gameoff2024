from ffmpeg import FFmpeg
from os import listdir
from os.path import isfile, join

if __name__ == "__main__":
    in_path = "assets/sfx"
    sound_files = [f[0:-4] for f in listdir(in_path) if isfile(join(in_path, f)) and f.endswith(".wav") ]

    for name in sound_files:
        ffmpeg = (
            FFmpeg()
            .option("y")
            .input(f"assets/sfx/{name}.wav")
            .output(f"godot/assets/sfx/{name}.ogg")
        )
        ffmpeg.execute()
