"""Replace the website placeholders with website domains from env_config
Generate the test data"""
import json
import sys
import os

# Add parent directory to path to import env_config directly
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

# Import env_config directly without triggering browser_env/__init__.py
import importlib.util
spec = importlib.util.spec_from_file_location("env_config", "browser_env/env_config.py")
env_config = importlib.util.module_from_spec(spec)
spec.loader.exec_module(env_config)

# Extract the variables
GITLAB = env_config.GITLAB
REDDIT = env_config.REDDIT
SHOPPING = env_config.SHOPPING
SHOPPING_ADMIN = env_config.SHOPPING_ADMIN
WIKIPEDIA = env_config.WIKIPEDIA
MAP = env_config.MAP


def main() -> None:
    with open("config_files/test.raw.json", "r") as f:
        raw = f.read()
    raw = raw.replace("__GITLAB__", GITLAB)
    raw = raw.replace("__REDDIT__", REDDIT)
    raw = raw.replace("__SHOPPING__", SHOPPING)
    raw = raw.replace("__SHOPPING_ADMIN__", SHOPPING_ADMIN)
    raw = raw.replace("__WIKIPEDIA__", WIKIPEDIA)
    raw = raw.replace("__MAP__", MAP)
    with open("config_files/test.json", "w") as f:
        f.write(raw)
    # split to multiple files
    data = json.loads(raw)
    for idx, item in enumerate(data):
        with open(f"config_files/{idx}.json", "w") as f:
            json.dump(item, f, indent=2)


if __name__ == "__main__":
    main()
