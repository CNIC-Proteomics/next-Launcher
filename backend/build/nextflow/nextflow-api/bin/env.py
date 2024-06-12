import os

# load settings from environment variables
NXF_EXECUTOR = os.environ.get('NXF_EXECUTOR', default='local')
NXF_CONF = os.environ.get('NXF_CONF')
PVC_NAME = os.environ.get('PVC_NAME')

# define working directories
BASE_DIRS = {
	'k8s':    '/workspace',
	'local':  '/workspace',
	'pbspro': '/workspace',
}
BASE_DIR = BASE_DIRS[NXF_EXECUTOR]

DATASETS_DIR = os.path.join(BASE_DIR, '_datasets')
WORKFLOWS_DIR = os.path.join(BASE_DIR, '_workflows')
OUTPUTS_DIR = ''
TRACES_DIR = os.path.join(BASE_DIR, '_traces')
MODELS_DIR = os.path.join(BASE_DIR, '_models')

# Frontend: Access-Control-Allow-Origin 
CORS_HOST = 'http://localhost'
# CORS_HOST = 'http://10.142.33.54'
CORS_PORT = 3000

# validate environment settings
if NXF_EXECUTOR == 'k8s' and PVC_NAME is None:
	raise EnvironmentError('Using k8s executor but PVC is not defined')