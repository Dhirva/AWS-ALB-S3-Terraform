from flask import Flask, jsonify
import boto3
import os

app = Flask(__name__)

s3 = boto3.client(
    's3',
    aws_access_key_id=os.getenv('AWS_ACCESS_KEY_ID'),
    aws_secret_access_key=os.getenv('AWS_SECRET_ACCESS_KEY'),
    region_name=os.getenv('AWS_REGION')
)

AWS_ACCESS_KEY_ID = os.getenv("AWS_ACCESS_KEY_ID")
AWS_SECRET_ACCESS_KEY = os.getenv("AWS_SECRET_ACCESS_KEY")
AWS_REGION = os.getenv("AWS_REGION")
BUCKET_NAME = os.getenv("S3_BUCKET_NAME")
# BUCKET_NAME = "aws-s3-content-fe-1"

@app.route('/list-bucket-content', defaults={'path': ''}, methods=['GET'])
@app.route('/list-bucket-content/<path:path>', methods=['GET'])
def list_bucket_content(path):
    try:
        if path:
            prefix = path.rstrip('/') + '/'
        else:
            prefix = ''

        response = s3.list_objects_v2(Bucket=BUCKET_NAME, Prefix=prefix, Delimiter='/')

        content = []

        if 'CommonPrefixes' in response:
            content.extend([cp['Prefix'].rstrip('/').split('/')[-1] for cp in response['CommonPrefixes']])

        if 'Contents' in response:
            content.extend([obj['Key'].split('/')[-1] for obj in response['Contents'] if obj['Key'] != prefix])

        return jsonify({"content": content})

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
@app.route("/health", methods=['GET'])
def health_check():
    """Health check endpoint to verify if the application is healthy."""
    return jsonify({"status": "healthy"}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
