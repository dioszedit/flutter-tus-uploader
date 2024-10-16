# Flutter TUS Uploader

A Proof of Concept (POC) Flutter application demonstrating resilient file uploading using the TUS (Resumable Upload) protocol.

## Features

- File selection from device storage
- Upload files to a TUS-compatible server
- Display upload progress
- Handle network interruptions gracefully (to be implemented)

## Prerequisites

- Flutter SDK
- Docker (for running the TUS server)

## Setup

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/flutter-tus-uploader.git
   cd flutter-tus-uploader
   ```

2. Install dependencies:
   ```
   flutter pub get
   ```

3. Run the TUS server using Docker:
   ```
   docker-compose up -d
   ```

4. Update the server URL in `lib/main.dart` if necessary:
   ```
   // Client host
    Uri.parse("http://your-host:1080/files/"),
   ```

5. Run the Flutter app:
   ```
   flutter run
   ```

## Project Structure

- `lib/main.dart`: Main application code
- `pubspec.yaml`: Flutter project configuration and dependencies

## Dependencies

- `tus_client_dart`: TUS protocol client implementation
- `file_picker`: For selecting files from device storage
- `path_provider`: For working with the file system

## License

This project is open source and available under the [MIT License](LICENSE).
