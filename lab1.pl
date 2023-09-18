% Классы
class(warrior).
class(mage).
class(archer).
class(rogue).
class(knight).
class(sorcerer).
class(assassin).
class(paladin).
class(thief).
class(witch).
class(druid).
class(cleric).
class(bard).
class(monk).
class(necromancer).
class(templar).
class(ranger).
class(enchanter).
class(alchemist).

% Главная характеристика класса
main_stat(warrior, strength).
main_stat(mage, intelligence).
main_stat(archer, agility).
main_stat(rogue, agility).
main_stat(knight, strength).
main_stat(sorcerer, intelligence).
main_stat(assassin, agility).
main_stat(paladin, strength).
main_stat(thief, agility).
main_stat(witch, intelligence).
main_stat(druid, intelligence).
main_stat(cleric, intelligence).
main_stat(bard, charisma).
main_stat(monk, agility).
main_stat(necromancer, intelligence).
main_stat(templar, strength).
main_stat(ranger, agility).
main_stat(enchanter, intelligence).
main_stat(alchemist, intelligence).

% Имя игрока, его класс и уровень
player_info(john, warrior, 10).
player_info(sarah, mage, 8).
player_info(alex, archer, 12).
player_info(lisa, rogue, 7).
player_info(mike, knight, 14).
player_info(emily, sorcerer, 9).
player_info(dave, assassin, 11).
player_info(olivia, paladin, 13).
player_info(chris, thief, 6).
player_info(rachel, witch, 10).
player_info(jack, druid, 8).
player_info(anna, cleric, 12).
player_info(matt, bard, 7).
player_info(lily, monk, 10).
player_info(peter, necromancer, 9).
player_info(sophia, templar, 14).
player_info(daniel, ranger, 11).
player_info(laura, enchanter, 12).
player_info(victor, alchemist, 10).

% % Оружие игрока
weapon(john, sword).
weapon(sarah, staff).
weapon(alex, bow).
weapon(lisa, daggers).
weapon(mike, sword).
weapon(emily, staff).
weapon(dave, daggers).
weapon(olivia, sword).
weapon(chris, daggers).
weapon(rachel, wand).
weapon(jack, staff).
weapon(anna, mace).
weapon(matt, flute).
weapon(lily, fists).
weapon(peter, staff).
weapon(sophia, sword).
weapon(daniel, bow).
weapon(laura, staff).
weapon(victor, potions).

% Характеристики игрока
characteristics(john, strength, 12).
characteristics(john, agility, 8).
characteristics(john, intelligence, 5).

characteristics(sarah, strength, 6).
characteristics(sarah, agility, 7).
characteristics(sarah, intelligence, 15).

characteristics(alex, strength, 7).
characteristics(alex, agility, 12).
characteristics(alex, intelligence, 6).

characteristics(lisa, strength, 9).
characteristics(lisa, agility, 15).
characteristics(lisa, intelligence, 4).

characteristics(mike, strength, 14).
characteristics(mike, agility, 10).
characteristics(mike, intelligence, 3).

characteristics(emily, strength, 5).
characteristics(emily, agility, 7).
characteristics(emily, intelligence, 16).

characteristics(dave, strength, 10).
characteristics(dave, agility, 14).
characteristics(dave, intelligence, 7).

characteristics(olivia, strength, 13).
characteristics(olivia, agility, 9).
characteristics(olivia, intelligence, 8).

characteristics(chris, strength, 8).
characteristics(chris, agility, 16).
characteristics(chris, intelligence, 5).

characteristics(rachel, strength, 6).
characteristics(rachel, agility, 9).
characteristics(rachel, intelligence, 14).

characteristics(jack, strength, 8).
characteristics(jack, agility, 11).
characteristics(jack, intelligence, 7).

characteristics(anna, strength, 12).
characteristics(anna, agility, 8).
characteristics(anna, intelligence, 7).

characteristics(matt, strength, 5).
characteristics(matt, agility, 11).
characteristics(matt, intelligence, 10).

characteristics(lily, strength, 10).
characteristics(lily, agility, 12).
characteristics(lily, intelligence, 6).

characteristics(peter, strength, 7).
characteristics(peter, agility, 9).
characteristics(peter, intelligence, 12).

characteristics(sophia, strength, 14).
characteristics(sophia, agility, 6).
characteristics(sophia, intelligence, 9).

characteristics(daniel, strength, 11).
characteristics(daniel, agility, 13).
characteristics(daniel, intelligence, 7).

characteristics(laura, strength, 6).
characteristics(laura, agility, 10).
characteristics(laura, intelligence, 14).

characteristics(victor, strength, 7).
characteristics(victor, agility, 8).
characteristics(victor, intelligence, 15).


% определение силы игрока
player_strength(Player, TotalStrength) :-
    player_info(Player, Class, Level),
    main_stat(Class, MainStat),
    characteristics(Player, MainStat, MainStatValue),
    findall(StrengthValue, (characteristics(Player, Char, CharValue), Char \= MainStat, StrengthValue is CharValue), StrengthValues),
    sum_list(StrengthValues, Sum),
    TotalStrength is Level + Sum + MainStatValue * 1.5.


% сравнение силы двух игроков
is_stronger(Player1, Player2) :-
    player_strength(Player1, Strength1),
    player_strength(Player2, Strength2),
    Strength1 > Strength2.

% количество игроков определенного класса
count_players_by_class(Class, Count) :-
    findall(Player, player_info(Player, Class, _), Players),
    length(Players, Count).

% количество игроков с уровнем не ниже заданного
count_players_by_min_level(MinLevel, Count) :-
    findall(Player, (player_info(Player, _, Level), Level >= MinLevel), Players),
    length(Players, Count).

% самый сильный игрок
strongest_player_info(Player, Class, Level, Strength) :-
    player_info(Player, Class, Level),
    player_strength(Player, Strength),
    \+ (player_info(_, _, OtherLevel), player_strength(_, OtherStrength), OtherStrength > Strength, OtherLevel >= Level).
