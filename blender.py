import cv2
import numpy as np


class ImageBlender:
    """
    Класс обработки:
    - хранит два изображения
    - автоматически подгоняет второе под первое (cv2.resize)
    - генерирует горизонтальную градиентную маску
    - смешивает: res = img1 * mask + img2 * (1 - mask)
    """

    def __init__(self):
        self.img1 = None
        self.img2 = None
        self.result = None

    def load_image1(self, path: str):
        self.img1 = cv2.imread(path)
        self._sync_sizes()

    def load_image2(self, path: str):
        self.img2 = cv2.imread(path)
        self._sync_sizes()

    def _sync_sizes(self):
        """Автоматическая подгонка разрешения второго изображения под первое."""
        if self.img1 is not None and self.img2 is not None:
            h, w = self.img1.shape[:2]
            self.img2 = cv2.resize(self.img2, (w, h), interpolation=cv2.INTER_LINEAR)

    def blend(self, center_pos: float, width: int = 100):
        """
        Плавное смешивание двух матриц.
        center_pos — положение центра градиента (0..w-1)
        width — ширина перехода
        """
        if self.img1 is None or self.img2 is None:
            return None

        h, w = self.img1.shape[:2]

        x = np.arange(w, dtype=np.float32)
        mask_line = (x - center_pos) / max(width, 1) + 0.5
        mask_line = np.clip(mask_line, 0.0, 1.0)

        mask = np.tile(mask_line, (h, 1))[:, :, np.newaxis]

        img1_f = self.img1.astype(np.float32)
        img2_f = self.img2.astype(np.float32)

        res_f = img1_f * mask + img2_f * (1.0 - mask)

        self.result = np.clip(res_f, 0, 255).astype(np.uint8)
        return self.result
