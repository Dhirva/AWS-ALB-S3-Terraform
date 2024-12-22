# Application

This is a Python Flask application that interacts with an Amazon S3 bucket to list the content of a bucket or a specific folder within the bucket. The application exposes two endpoints:

- `/list-bucket-content`: Lists the contents of an S3 bucket or folder.
- `/health`: Provides a health check for the application.

## Prerequisites

1. **Python**: Ensure Python 3.9 or above is installed on your system.
2. **AWS Credentials**: Obtain your AWS credentials with the following environment variables:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `AWS_REGION`
   - `S3_BUCKET_NAME`
3. **Docker**: To run the application in a Docker container, install Docker.
4. **Flask**: The application uses Flask as the web framework.

## Local Setup

### 1. Clone the Repository
Clone the repository to your local machine:

```bash
git clone https://github.com/Dhirva/AWS-ALB-S3-Terraform.git
cd AWS-ALB-S3-Terraform
```

### 2. Install Dependencies
Install the required Python packages by running:

```bash
pip install -r requirements.txt
```

### 3. Set Up Environment Variables
Create a `.env` file in the root directory of the project with the following content:

```bash
AWS_ACCESS_KEY_ID=your-access-key-id
AWS_SECRET_ACCESS_KEY=your-secret-access-key
AWS_REGION=your-region
S3_BUCKET_NAME=your-bucket-name
```

### 4. Run the Application Locally
Run the Flask application with:

```bash
python app.py
```

The application will start and listen on port `5000`.

### 5. Test the Application
- **Health Check Endpoint:**
  Open your browser or use a tool like `curl` to access the health check endpoint:

  ```bash
  curl http://localhost:5000/health
  ```

  Expected Response:

  ```json
  {
    "status": "healthy"
  }
  ```

- **List Bucket Content:**
  Access the bucket listing endpoint:

  ```bash
  curl http://localhost:5000/list-bucket-content
  ```

  Expected Response:

  ```json
  {
    "content": ["file1", "folder1"]
  }
  ```

## Run with Docker

### 1. Build the Docker Image
Build the Docker image using the provided `Dockerfile`:

```bash
docker build -t flask-s3-app .
```

### 2. Run the Docker Container
Run the container with the required environment variables:

```bash
docker run -p 5000:5000 \
  -e AWS_ACCESS_KEY_ID=your-access-key-id \
  -e AWS_SECRET_ACCESS_KEY=your-secret-access-key \
  -e AWS_REGION=your-region \
  -e S3_BUCKET_NAME=your-bucket-name \
  flask-s3-app
```

### 3. Test the Application
Test the endpoints as described above. Replace `localhost` with the container’s IP if necessary.

## Files Included

- `Dockerfile`: Defines the Docker image for the application.
- `app.py`: The Flask application code.
- `requirements.txt`: List of Python dependencies.

