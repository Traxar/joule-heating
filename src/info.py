INFOCOLOR = '\033[36m'
BOLD = '\033[1m'
ENDC = '\033[0m'

def info(text):
    print(INFOCOLOR + BOLD + text + ENDC)

class Task:
    def __init__(self, name) -> None:
        self.name = name
        info(name + '...')

    def status(self, status):
        info(self.name + '... ' + status)
