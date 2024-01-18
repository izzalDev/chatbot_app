from flask import Flask, jsonify, request
from flask_cors import CORS
import pickle
import json
import random

app = Flask(__name__)
CORS(app)

# Memuat model dari file pickle
with open('./assets/model/knn.pkl', 'rb') as model_file:
    model = pickle.load(model_file)

with open('./assets/intents.json', 'r') as file:
    data = json.load(file)

def get_random_response(tag):
    intent = next((intent for intent in data['intents'] if intent['tag'] == tag), None)
    return random.choice(intent['responses']) if intent else None

# API endpoint untuk memprediksi dengan model machine learning
@app.route('/predict', methods=['POST'])
def predict():
    # Pastikan input dalam format JSON
    if not request.json or 'message' not in request.json:
        return jsonify({'error': 'Input tidak valid'}), 400

    # Ambil pesan dari input JSON
    user_message = request.json['message']

    # Lakukan prediksi menggunakan model
    prediction = model.predict([user_message])[0]

    response = get_random_response(prediction)

    # Kembalikan hasil prediksi sebagai respons
    return jsonify({'prediction': response})

if __name__ == '__main__':
    app.run(debug=True, port=5000)

