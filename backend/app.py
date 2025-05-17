from fastapi import FastAPI, File, UploadFile
from PIL import Image
import numpy as np
import tensorflow as tf
import io

# Load the TFLite model
interpreter = tf.lite.Interpreter(model_path="skin_type_model.tflite")
interpreter.allocate_tensors()

# Load input and output details
input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

app = FastAPI()

@app.post("/analyze-face/")
async def analyze_face(file: UploadFile = File(...)):
    contents = await file.read()
    image = Image.open(io.BytesIO(contents)).convert("RGB")
    image = np.array(image.resize((224, 224)))
    image = image / 255.0
    image = np.expand_dims(image, axis=0).astype(np.float32)

    # Run the model
    interpreter.set_tensor(input_details[0]['index'], image)
    interpreter.invoke()
    output_data = interpreter.get_tensor(output_details[0]['index'])

    # Get prediction
    predicted_class = np.argmax(output_data)
    labels = ["Oily", "Dry", "Normal"]

    return {"skin_type": labels[predicted_class]}
