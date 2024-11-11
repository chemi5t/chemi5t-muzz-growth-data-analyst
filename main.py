import pandas as pd
from pathlib import Path
from database_utils import DatabaseConnector as dc
from data_extraction import download_and_extract_gdrive as de
from decouple import config

# Google Drive file URL
url = "https://drive.google.com/uc?id=1y6QkiNvptCCaEI3dAqBORSw_dq4DVb_v"

def main():
    """
    Main function to download, extract, and load data into PostgreSQL.
    """
    # Step 1: Download and extract files from Google Drive
    extract_dir = de(url)

    if extract_dir is None:
        print("Extraction failed, exiting program.")
        return

    # Navigate to the subfolder where the CSV files are stored
    data_dir = extract_dir / "product_data_analyst_data_2024"

    if not data_dir.exists():
        print(f"Error: The expected data directory '{data_dir}' does not exist.")
        return

    # Step 2: Read database credentials and initialize database connection
    db_connector = dc()
    db_credentials = db_connector.read_db_creds(config('credentials_env'))  # Use the config function to read from the .env
    engine = db_connector.init_db_engine(db_credentials)

    if engine is None:
        print("Failed to initialize database engine.")
        return

    # Step 3: Load each CSV file in the data directory to PostgreSQL
    with engine.connect() as conn:
        for file in data_dir.glob("*.csv"):
            table_name = file.stem  # Use file name (without .csv) as table name
            db_connector.load_csv_to_postgresql(file, table_name, conn)

    print("Data loading completed and database connection closed.")

if __name__ == "__main__":
    main()
