from flask import Flask, request, jsonify
import requests
app = Flask(__name__)

@app.route('/get_data', methods=['GET'])
def get_data():
    gemini_api_key = 'YOUR_GEMINI_API_KEY'
    gemini_api_url = 'GEMINI_API_URL_TO_GET_DATA'

    headers = {
        'Authorization': f'Bearer {gemini_api_key}'
    }

    response = requests.get(gemini_api_url, headers=headers)

    if response.status_code == 200:
        data = response.json()
        # Process the data as needed
        return jsonify(data)
    else:
        return jsonify({'error': 'Failed to fetch data'})

if __name__ == '__main__':
    app.run(debug=True)