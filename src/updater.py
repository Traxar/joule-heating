import subprocess
import sys
from info import Task

def install(*packages):
    list = [ name for name in packages]
    subprocess.check_call([sys.executable, '-m', 'pip', 'install'] + list) #add -q for quiet mode

def run():
    task = Task('Updating dependencies')
    install('pytest','numpy','matplotlib')
    task.status('done')

if __name__ == '__main__':
    run()
