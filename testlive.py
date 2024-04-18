import sys
import base64
import cv2
import numpy as np
import torch
from cnn import CNN
from torchvision import transforms
from PIL import Image
import select
import mediapipe as mp
import os

class_to_letter = ['B', 'C', 'F', 'G', 'H', 'I', 'K', 'L', 'M', 'N', 'P', 'R', 'S', 'T', 'W', 'nothing']
loaded_model = torch.load('./model_KernelTestBetter')

def transform(image):
    if image is None or image.shape[0] == 0:
        return None
    image_gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    sharpening_kernel = np.array([
        [-2, -1, 0],
        [-1, 1, 1],
        [0, 1, 2]
    ])
    sharpened_image = cv2.filter2D(image_gray, -1, sharpening_kernel)
    image_resized = cv2.resize(sharpened_image, (50, 50), interpolation=cv2.INTER_AREA)
    return image_resized

transformed = transforms.Compose([
    transforms.ToTensor(),
])

def predict_image(image):
    if image is None:
        return "No image provided"
    image = transform(image)
    if image is None:
        return "Failed to transform image"
    image = Image.fromarray(image)
    image = transformed(image)
    output = loaded_model(image.unsqueeze(0))
    _, predicted_class = torch.max(output, 1)
    predicted_class_index = predicted_class.item()
    predicted_letter = class_to_letter[predicted_class_index]
    return predicted_letter

mp_hands = mp.solutions.hands
hands = mp_hands.Hands(static_image_mode=False, max_num_hands=1, min_detection_confidence=0.5)

cap = cv2.VideoCapture(0)

def check_for_signal():
    if os.path.exists('signal.txt'):
        try:
            os.remove('signal.txt')
        except Exception:
            return False
        return True
    return False

def main():
    predicted_letter = "None"
    while cap.isOpened():
        ret, frame = cap.read()
        if not ret:
            print("Error: Failed to capture frame")
            continue
        results_hands = hands.process(cv2.cvtColor(frame, cv2.COLOR_BGR2RGB))
        if results_hands.multi_hand_landmarks and check_for_signal():
            hand_landmarks = results_hands.multi_hand_landmarks[0]
            x_coords = [landmark.x for landmark in hand_landmarks.landmark]
            y_coords = [landmark.y for landmark in hand_landmarks.landmark]
            x_min, x_max = min(x_coords), max(x_coords)
            y_min, y_max = min(y_coords), max(y_coords)
            x_min = int(x_min * frame.shape[1] - 15)
            y_min = int(y_min * frame.shape[0] - 15)
            x_max = int(x_max * frame.shape[1] + 15)
            y_max = int(y_max * frame.shape[0] + 15)
            hand_region = frame[y_min:y_max, x_min:x_max]
            predicted_letter = predict_image(hand_region)
            if predicted_letter == 'L':
                predicted_letter = 'L'
            elif predicted_letter == 'W':
                predicted_letter = 'W'
            elif predicted_letter == 'F':
                predicted_letter = 'F'
            else:
                predicted_letter = "None"
        # else:
            # predicted_letter = "None"
        ret, buffer = cv2.imencode('.jpg', frame)
        frame_bytes = buffer.tobytes()
        yield base64.b64encode(frame_bytes).decode('utf-8') + "," + predicted_letter
           

if __name__ == "__main__":
    for data in main():
        print(data)


