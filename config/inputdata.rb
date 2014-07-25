#!/usr/bin/ruby
# encoding: utf-8

#Настройки инстаграма
$client_ids = [
'ecb050ce18984d9b91d4add9c86960b3',
'5e4e396e82a9459bb33548d6c7a989a5',
'c30b505ed8eb4c40bbc5e95fd77a853'
]
$access_tokens = [
'1275040614.ecb050c.8447f27dd3e6458c98a8fa66e535a234',
'1275042319.ecb050c.53eaf0d800ae460ea193e6058a181e7f',
'1275043233.ecb050c.4706e0faacc54166a566915946b55bed',
'1278702301.ecb050c.34c3fc4228d34aa1b430ef1e992d37ae',
'1278705613.ecb050c.a50d33bba1cf4a2fa322d6f2b1b25f36',
'1278708748.ecb050c.ad50d8a9f53147828121bfa6e8c6d27c',
'1278711781.ecb050c.0c633149be634c19abdcb6a98609dd8e'
]
$cti_access_tokens = [
    '298454841.ecb050c.f4b4e7e913f043de937ab4cc3b6d1762']

#$cti_access_tokens = [
#'298454841.ecb050c.f4b4e7e913f043de937ab4cc3b6d1762',
#'298454841.5e4e396.df4a7432f0ff45728e0f7d46b07a3105',
#'298454841.c30b505.914f50ab038a4bccaa0b063499c92656'
#]

#Хештеги
$hashtags = []
$hashtags << 'вейк' << 'вейкборд'
$hashtags << 'мото' << 'мотокросс' << 'эндуро' << 'байк'
$hashtags << 'сноуборд'<<'горныелыжи'<<'twintip'
$hashtags << 'спорт' << 'экстрим'
$hashtags << 'снежком' << 'snejcom'
$hashtags << 'красная_поляна' << 'krasnaya_polyana' << 'волен'
$hashtags << 'кайт' << 'серфинг' << 'серф'
$hashtags << '2manwakepark' << 'kraskovowakepark'
$hashtags << 'колено'
$hashtags << 'хоккей' << 'футбол'

$locations = []
$locations << '170295' #СНЕЖ.КОМ
#$locations << '1776709' #Роза хутор
#$locations << '8753478' #Роза хутор
#$locations << '1631430' #Красная поляна
$locations << '5489423' #Траектория
#$locations << '1488303' #Волен
#$locations << '36328788' #SkyTecSport – Кант
#$locations << '501009' #Сорочаны, спортивный курорт
#$locations << '6727017' #Степаново
#$locations << '6274890' #Горнолыжный Клуб Леонида Тягачева
$locations << '19038189' #Траектория СПб
$locations << '2144065' #Hip-notics
$locations << '3323995' #Спортхит
$locations << '2327777' #Экстрим
$locations << '13625668' #Глобус-экстрим
$locations << '2863798' #Спорт Экстрим
$locations << '84774236' #Мотогора
$locations << '3442613' #Вейк-клуб Малибу
$locations << '1754948' #Sexton байк-центр
$locations << '15667443' #Кайт питер
$locations << '7570247' #Мототрек питер
$locations << '4973914' #sunpark
$locations << '15856759' #Ramada
#$locations << '' #
#$locations << '' #
#$locations << '' #

$tagstocheck = []
$tagstocheck << 'мото' << 'мотокросс' << 'эндуро'
$tagstocheck << 'вейкборд' 
