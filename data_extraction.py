import gdown
import zipfile
from pathlib import Path

def download_and_extract_gdrive(url, extract_to="muzz_files"):
    """
    Downloads a file from Google Drive and extracts it to a specified directory.

    Args:
        url (str): The Google Drive file URL.
        extract_to (str): The directory where the file should be extracted.

    Returns:
        Path: The path to the directory where the files were extracted.
    """
    download_path = Path(f"{extract_to}.zip")
    extract_dir = Path(extract_to)

    try:
        gdown.download(url, str(download_path), quiet=False)
    except Exception as e:
        print(f"Download failed: {e}")
        return None

    try:
        with zipfile.ZipFile(download_path, 'r') as zip_ref:
            zip_ref.extractall(extract_dir)
        print(f"Files extracted to: '{extract_dir}'")
    except zipfile.BadZipFile:
        print("Error: The downloaded file is not a valid zip file.")
        return None
    finally:
        if download_path.exists():
            download_path.unlink()

    return extract_dir
