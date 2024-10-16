# Flutter TUS Uploader

A Proof of Concept (POC) Flutter application demonstrating resilient file uploading using the TUS (Resumable Upload) protocol, with a Dockerized TUS server.

## Features

- File selection from device storage
- Upload files to a TUS-compatible server
- Display upload progress
- Handle network interruptions gracefully (to be implemented)
- Dockerized TUS server for easy deployment

## Prerequisites

- Flutter SDK
- Docker

## Setup

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/flutter-tus-uploader.git
   cd flutter-tus-uploader
   ```

2. Install Flutter dependencies:
   ```
   flutter pub get
   ```

3. Build and run the TUS server using Docker:
   ```
   cd server
   docker build -t my-tusd .
   docker run -p 1080:1080 my-tusd
   ```

4. Update the server URL in `lib/main.dart` if necessary:
   ```dart
   final client = TusClient(
     Uri.parse('http://your-server-ip:1080/files/'),
     _file!,
     store: TusMemoryStore(),
   );
   ```

5. Run the Flutter app:
   ```
   flutter run
   ```

## Project Structure

- `lib/main.dart`: Main Flutter application code
- `pubspec.yaml`: Flutter project configuration and dependencies
- `server/`: Directory containing Docker configuration for TUS server
  - `Dockerfile`: Docker configuration for TUS server
  - `tusd.config`: Configuration file for TUS server (if needed)

## Docker Configuration

The project includes a Dockerized TUS server for easy deployment. The `Dockerfile` in the `server/` directory sets up the TUS server:

```dockerfile
FROM tusproject/tusd
EXPOSE 1080
CMD ["tusd", "-port=1080", "-behind-proxy"]
```

To customize the TUS server configuration, you can modify the `tusd.config` file (if present) or adjust the `CMD` in the Dockerfile.

## Dependencies

- `tus_client_dart`: TUS protocol client implementation
- `file_picker`: For selecting files from device storage
- `path_provider`: For working with the file system

## License

This project is open source and available under the [MIT License](LICENSE).
