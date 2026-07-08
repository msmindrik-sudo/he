import tkinter as tk
from tkinter import ttk, filedialog
from utils import cv_to_tk


class BlendGUI(ttk.Frame):
    """
    GUI:
    - вкладки
    - кнопки загрузки изображений
    - ползунок для смещения границы смешивания
    """

    def __init__(self, master, blender):
        super().__init__(master)
        self.blender = blender
        self.result_photo = None

        self.notebook = ttk.Notebook(self)
        self.notebook.pack(fill=tk.BOTH, expand=True)

        self.tab_control = ttk.Frame(self.notebook)
        self.tab_result = ttk.Frame(self.notebook)

        self.notebook.add(self.tab_control, text="Управление")
        self.notebook.add(self.tab_result, text="Результат")

        self._build_control_tab()
        self._build_result_tab()

    def _build_control_tab(self):
        btn1 = ttk.Button(self.tab_control, text="Загрузить изображение 1",
                          command=self.load_image1)
        btn1.pack(pady=10)

        btn2 = ttk.Button(self.tab_control, text="Загрузить изображение 2",
                          command=self.load_image2)
        btn2.pack(pady=10)

        ttk.Label(self.tab_control, text="Положение центра градиента").pack(pady=5)

        self.slider = ttk.Scale(
            self.tab_control,
            from_=0,
            to=100,
            orient=tk.HORIZONTAL,
            command=self.on_slider_move
        )
        self.slider.set(50)
        self.slider.pack(fill=tk.X, padx=20, pady=5)

        save_btn = ttk.Button(self.tab_control, text="Сохранить результат",
                              command=self.save_result)
        save_btn.pack(pady=20)

    def _build_result_tab(self):
        self.result_label = ttk.Label(self.tab_result)
        self.result_label.pack(fill=tk.BOTH, expand=True, padx=10, pady=10)

    def load_image1(self):
        path = filedialog.askopenfilename(
            title="Выберите первое изображение",
            filetypes=[("Images", "*.png;*.jpg;*.jpeg;*.bmp")]
        )
        if path:
            self.blender.load_image1(path)
            self.update_result()

    def load_image2(self):
        path = filedialog.askopenfilename(
            title="Выберите второе изображение",
            filetypes=[("Images", "*.png;*.jpg;*.jpeg;*.bmp")]
        )
        if path:
            self.blender.load_image2(path)
            self.update_result()

    def on_slider_move(self, _value):
        self.update_result()

    def update_result(self):
        if self.blender.img1 is None or self.blender.img2 is None:
            return

        h, w = self.blender.img1.shape[:2]
        center_pos = (float(self.slider.get()) / 100.0) * (w - 1)

        res = self.blender.blend(center_pos=center_pos, width=w // 5)
        if res is None:
            return

        self.result_photo = cv_to_tk(res)
        self.result_label.configure(image=self.result_photo)

    def save_result(self):
        if self.blender.result is None:
            return
        path = filedialog.asksaveasfilename(
            title="Сохранить результат",
            defaultextension=".png",
            filetypes=[("PNG", "*.png"), ("JPEG", "*.jpg"), ("BMP", "*.bmp")]
        )
        if path:
            import cv2
            cv2.imwrite(path, self.blender.result)
