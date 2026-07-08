import tkinter as tk
from blender import ImageBlender
from gui import BlendGUI


def main():
    root = tk.Tk()
    root.title("Смешивание двух изображений (OpenCV + Tkinter)")
    root.geometry("900x600")

    blender = ImageBlender()
    gui = BlendGUI(root, blender)
    gui.pack(fill=tk.BOTH, expand=True)

    root.mainloop()


if __name__ == "__main__":
    main()
