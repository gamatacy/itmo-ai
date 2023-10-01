from swiplserver import PrologMQI, PrologThread, create_posix_path
import re
from abc import ABC, abstractmethod

KNOWLEDGE_BASE_PATH = r'F:\code\itmo-ai\lab1.pl'

class AbstractQueryProcessor(ABC):
    def run(self, prolog: PrologThread):
        res = prolog.query(self.form_query())
        if not res or len(res) == 0:
            self.handle_failure(res)
        else:
            self.handle_success(res)
    
    @abstractmethod
    def form_query(self):
        pass

    @abstractmethod
    def handle_success(self, res):
        pass

    @abstractmethod
    def handle_failure(self, res):
        pass
    
class FindOpponents(AbstractQueryProcessor):
    def __init__(self, strength: str):
        self.strength = strength

    def form_query(self):
        return f'weaker_players({self.strength}, X)'

    def handle_success(self, res):
        length = len(res[0]['X'])
        print(f'Found {length} players that you can beat!')
        for player in res[0]['X']:
            name = player['args'][0]
            race = player['args'][1]['args'][0]
            player_class = player['args'][1]['args'][1]['args'][0]
            level = player['args'][1]['args'][1]['args'][1]['args'][0]
            strength = player['args'][1]['args'][1]['args'][1]['args'][1]
            print(f"Player: {name}, Race: {race}, Class: {player_class}, Level: {level}, Strength: {strength}")

    def handle_failure(self, res):
        print(f"No players that you can beat")

class FindByName(AbstractQueryProcessor):
    def __init__(self, name: str):
        self.name = name

    def form_query(self):
        return f'player_info({self.name}, RACE, CLASS, WEAPON, LEVEL)'

    def handle_success(self, res):
        race = res[0]['RACE']
        player_class = res[0]['CLASS']
        weapon = res[0]['WEAPON']
        level = res[0]['LEVEL']
        print(f"Player: {self.name}, Race: {race}, Class: {player_class}, Weapon: {weapon}, Level: {level}")

    def handle_failure(self, res):
        print(f"No such player")

class RecommendStat(AbstractQueryProcessor):
    def __init__(self, clazz: str):
        self.clazz = clazz
        
    def form_query(self):
        return f'main_stat({self.clazz}, X)'

    def handle_success(self, res):
        stat = res[0]['X']
        print(f'{stat} is the best choice')

    def handle_failure(self, res):
        print(f"Cant find this class")


patterns = {
    r'Who can I beat with strength (.+)\?': FindOpponents,
    r'Show me (.+) profile': FindByName,
    r'I am (.+), which stat should I improve\?': RecommendStat,
}

with PrologMQI() as mqi:
    with mqi.create_thread() as prolog:
        path = create_posix_path(KNOWLEDGE_BASE_PATH)
        print(prolog.query(f'consult("{path}")'))

        while True:
            query = input('> ')
            if query.lower() == 'exit':
                break

            for pattern in patterns:
                match = re.match(pattern, query, re.IGNORECASE)
                if match is None:
                    continue
                processor = patterns[pattern](*match.groups())
                processor.run(prolog)
                break
            else:
                print("Invalid query!")
        