import os
import shutil
import sys

current_dir = os.getcwd()
#current_dir = sys.argv[1:]

ARG_OVERWRITE_SYNTAX = "--overwrite"
ARG_NO_OVERWRITE_CONTENT_SYNTAX = "--no-overwrite-content"

def copy(input, output, overwrite=False):
    for filename in os.listdir(current_dir):
        if filename.lower().endswith(".timbermesh") or filename.lower().endswith(".timbermesh.meta"):
            print("Skipping .timbersmith file.")
            continue

        if input in filename:
            new_filename = filename.replace(input, output)

            if os.path.exists(new_filename) and not overwrite:
                print(f"{new_filename} already exists. Use {ARG_OVERWRITE_SYNTAX} to overwrite.")
            else:
                shutil.copy(filename, new_filename)
                print(f"Copied {filename} to {new_filename}")

                if ARG_NO_OVERWRITE_CONTENT_SYNTAX in sys.argv:
                    print(f"Skip overwriting content because {ARG_NO_OVERWRITE_CONTENT_SYNTAX} has been passed")
                    continue

                with open(new_filename, "r+") as f:
                    #print(f"Editing file")
                    content = f.read()
                    content = content.replace(input, output)
                    f.seek(0)
                    f.write(content)
                    f.truncate()



if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python main.py <input_string> <output_string>")
    else:
        input_str = sys.argv[1]
        output_str = sys.argv[2]
        is_overwrite = ARG_OVERWRITE_SYNTAX in sys.argv
        if "," in output_str:
            output_filenames = output_str.split(",")
            for output_filename in output_filenames:
                copy(input_str, output_filename, is_overwrite)
        else:
            copy(input_str, output_str, is_overwrite)
