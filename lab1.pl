% Классы
class(barbarian).
class(bard).
class(cleric).
class(druid).
class(fighter).
class(monk).
class(paladin).
class(ranger).
class(rogue).
class(sorcerer).
class(warlock).
class(wizard).

% Расы
race(human).
race(elf).
race(tiefling).
race(drow).
race(githyanki).
race(dwarf).
race(halfElf).
race(halfling).
race(gnome).
race(dragonborn).
race(halfOrc).

% Характеристики
stat(strength).
stat(dextirity).
stat(intelligence).
stat(charisma).
stat(wisdom).

% Главная характеристика класса
main_stat(barbarian, strength).
main_stat(bard, charisma).
main_stat(cleric, wisdom).
main_stat(druid, wisdom).
main_stat(fighter, strength).
main_stat(monk, dextirity).
main_stat(paladin, strength).
main_stat(ranger, dextirity).
main_stat(rogue, dextirity).
main_stat(sorcerer, charisma).
main_stat(warlock, charisma).
main_stat(wizard, intelligence).

% % Оружие и его урон
weapon(lutnia, 5).
weapon(club, 10).
weapon(dagger, 15).
weapon(greatclub, 20).
weapon(handaxe, 25).
weapon(javelin, 20).
weapon(lightcrossbow, 20).
weapon(lighthammer, 20).
weapon(morgenshtern, 30).
weapon(quarterstaff, 15).
weapon(shortbow, 15).
weapon(sickle, 25).
weapon(spear, 25).

% Имя игрока,его раса, его класс, оружие и уровень
player_info(valeriy, human, barbarian, morgenshtern, 10).
player_info(ivan, gnome, monk, morgenshtern, 5).
player_info(arina, tiefling, bard, lutnia, 18).

% Характеристики игрока
player_stat(valeriy, strength, 20).
player_stat(valeriy, dextirity, 15).
player_stat(valeriy, intelligence, 5).
player_stat(valeriy, charisma, 15).
player_stat(valeriy, wisdom, 5).

player_stat(ivan, strength, 10).
player_stat(ivan, dextirity, 45).
player_stat(ivan, intelligence, 15).
player_stat(ivan, charisma, 5).
player_stat(ivan, wisdom, 10).

player_stat(arina, strength, 5).
player_stat(arina, dextirity, 10).
player_stat(arina, intelligence, 25).
player_stat(arina, charisma, 25).
player_stat(arina, wisdom, 25).

% Определение силы игрока
player_strength(Player, TotalStrength) :-
    player_info(Player, _, Class, Weapon, Level),
    main_stat(Class, MainStat),
    weapon(Weapon, WeaponDamage),
    player_stat(Player, strength, Strength),
    player_stat(Player, dextirity, Dexterity),
    player_stat(Player, intelligence, Intelligence),
    player_stat(Player, charisma, Charisma),
    player_stat(Player, wisdom, Wisdom),
    player_stat(Player, MainStat, MainStatValue),
    TotalStrength is Level + Strength + Dexterity + Intelligence + Charisma + Wisdom + MainStatValue * 2 + WeaponDamage.

% Сравнение силы двух игроков
is_stronger(Player1, Player2) :-
    player_strength(Player1, Strength1),
    player_strength(Player2, Strength2),
    Strength1 > Strength2.

% Количество игроков с уровнем не ниже заданного
count_players_by_min_level(MinLevel, Count) :-
    findall(Player, player_info(Player, _, _, _, Level), Players),
    include(has_min_level(MinLevel), Players, FilteredPlayers),
    length(FilteredPlayers, Count).
has_min_level(MinLevel, Player) :-
    player_info(Player, _, _, _, Level),
    Level >= MinLevel.

% Самый сильный игрок
strongest_player_info(Player, Race, Class, Level, Strength) :-
    player_info(Player, Race, Class, _, Level),
    findall(OtherPlayer, (player_info(OtherPlayer, _, _, _, _), Player \= OtherPlayer), OtherPlayers),
    \+ (member(OtherPlayer, OtherPlayers), is_stronger(OtherPlayer, Player)),
    player_strength(Player, Strength).

% Кто слабее
is_weaker(Player1, Player2) :-
    player_strength(Player1, Strength1),
    player_strength(Player2, Strength2),
    Strength1 < Strength2.

% Правило для определения слабейшего игрока
weakest_player_info(Player, Race, Class, Level, Strength) :-
    player_info(Player, Race, Class, _, Level),
    player_strength(Player, Strength).

% Правило для поиска всех игроков с силой меньше заданной
weaker_players(Strength, Players) :-
    findall((Player, Race, Class, Level, PlayerStrength), (weakest_player_info(Player, Race, Class, Level, PlayerStrength), PlayerStrength < Strength), Players).
