import cv2
from PIL import Image, ImageTk


def cv_to_tk(img_bgr, max_w=800, max_h=500):
    """Конвертация BGR → Tkinter PhotoImage."""
    img_rgb = cv2.cvtColor(img_bgr, cv2.COLOR_BGR2RGB)
    pil_img = Image.fromarray(img_rgb)

    w, h = pil_img.size
    scale = min(max_w / w, max_h / h)
    pil_img = pil_img.resize((int(w * scale), int(h * scale)), Image.LANCZOS)

    return ImageTk.PhotoImage(pil_img)
