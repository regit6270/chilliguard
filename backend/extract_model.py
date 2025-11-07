# backend/extract_model.py
import json
import os
import sys
import warnings
warnings.filterwarnings('ignore')

print("🔄 Extracting model from leafcure.ipynb...")

try:
    import nbformat
    from nbconvert import PythonExporter

    # Read notebook
    with open('app/ml_models/leafcure.ipynb', 'r') as f:
        nb = nbformat.read(f, as_version=4)

    # Convert to Python script
    exporter = PythonExporter()
    python_code, _ = exporter.from_notebook_node(nb)

    # Execute to extract model
    # This loads the trained model from the notebook
    exec_globals = {}
    exec(python_code, exec_globals)

    # Model should be in exec_globals as 'model'
    model = exec_globals.get('model')

    if model:
        os.makedirs('app/ml_models', exist_ok=True)
        model.save('app/ml_models/chili_disease_model.h5')
        print("✅ Model extracted and saved to app/ml_models/chili_disease_model.h5")
    else:
        print("❌ Model not found in notebook")

except Exception as e:
    print(f"⚠️ Automated extraction failed: {e}")
    print("\n📝 MANUAL EXTRACTION (Alternative):")
    print("1. Open leafcure.ipynb in Jupyter")
    print("2. Find the cell with model.save() or the model definition")
    print("3. Copy the model object or its save command")
    print("4. Run it in Jupyter to save the model")
    print("5. Move the .h5 file to backend/app/ml_models/")
