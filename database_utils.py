import pandas as pd
from sqlalchemy import create_engine
import yaml

class DatabaseConnector:
    def __init__(self):
        self.db_creds = None
        self.engine = None

    def read_db_creds(self, creds_file):
        """
        Reads database credentials from a YAML or config file.

        Args:
            creds_file (str): Path to the YAML or config file containing credentials.

        Returns:
            dict: A dictionary containing the database connection details.
        """
        try:
            with open(creds_file, 'r') as file:
                self.db_creds = yaml.safe_load(file)
            return self.db_creds
        except Exception as e:
            print(f"Error reading credentials: {e}")
            return None

    @staticmethod
    def init_db_engine(credentials: dict):
        """
        Initializes the database engine based on the provided credentials.

        Args:
            credentials (dict): Dictionary containing database connection details.

        Returns:
            sqlalchemy.engine.base.Engine: Database engine object.
        """
        engine = create_engine(f"{credentials['DATABASE_TYPE']}+{credentials['DBAPI']}://{credentials['USER']}:{credentials['PASSWORD']}@{credentials['HOST']}:{credentials['PORT']}/{credentials['DATABASE']}")
        return engine

    def load_csv_to_postgresql(self, file_path, table_name, db_connection):
        """
        Loads a CSV file into a PostgreSQL table.

        Args:
            file_path (Path): Path to the CSV file.
            table_name (str): The name of the table in PostgreSQL.
            db_connection (Connection): The database connection object.
        """
        # Read CSV file into a DataFrame
        df = pd.read_csv(file_path)

        # Load DataFrame into PostgreSQL
        try:
            df.to_sql(table_name, db_connection, if_exists="replace", index=False)
            print(f"Loaded '{file_path.name}' into table '{table_name}' successfully.")
        except Exception as e:
            print(f"Failed to load '{file_path.name}' into table '{table_name}': {e}")
