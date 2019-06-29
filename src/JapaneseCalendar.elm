module JapaneseCalendar exposing(JapaneseCalendar, toString, YMD, fromYMD, fromEraWithYear, unknownEra, calendar)

import List.Extra

type alias JapaneseCalendar =
    { era : Era
    , gregorianYear : Int
    , japaneseYear : Int
    , japaneseYearString : String
    }

toString : JapaneseCalendar -> String
toString jc =
    if jc.era == unknownEra then
        "unknown"
    else
        jc.era.name ++ jc.japaneseYearString ++ "年"


type alias YMD =
    { year : Int
    , month : Int
    , day : Int
    }

ymdLessThanEqual : YMD -> YMD -> Bool
ymdLessThanEqual d1 d2 =
    if d1.year /= d2.year then
        d1.year < d2.year
    else if d1.month /= d2.month then
        d1.month < d2.month
    else
        d1.day <= d2.day

toJapaneseYearString : Int -> String
toJapaneseYearString year =
    if year == 1 then
        "元"
    else
        String.fromInt year

fromYMD : YMD -> JapaneseCalendar
fromYMD date =
    let
        maybeEra = List.Extra.find (\e -> ymdLessThanEqual e.startedOn date) calendar
        era = Maybe.withDefault unknownEra maybeEra
        japaneseYear = date.year - era.startedOn.year + 1
        japaneseYearString = toJapaneseYearString japaneseYear
    in
    { era = era
    , gregorianYear = date.year
    , japaneseYear = japaneseYear
    , japaneseYearString = japaneseYearString
    }


fromEraWithYear : String -> Int -> JapaneseCalendar
fromEraWithYear eraName japaneseYear =
    let
        maybeEra = List.Extra.find (\e -> e.name == eraName) calendar
        era = Maybe.withDefault unknownEra maybeEra
        gregorianYear = era.startedOn.year + japaneseYear - 1
        japaneseYearString = toJapaneseYearString japaneseYear
    in
    { era = era
    , gregorianYear = gregorianYear
    , japaneseYear = japaneseYear
    , japaneseYearString = japaneseYearString
    }



type alias Era =
    { name : String
    , startedOn : YMD
    }

unknownEra = { name = "unknown", startedOn = { year = round (-1/0), month =  1, day = 1 } }

calendar : List Era
calendar =
    [ { name = "令和", startedOn = { year = 2019, month =  5, day =  1 } }
    , { name = "平成", startedOn = { year = 1989, month =  1, day =  8 } }
    , { name = "昭和", startedOn = { year = 1926, month = 12, day = 25 } }
    , { name = "大正", startedOn = { year = 1912, month =  7, day = 30 } }
    , { name = "明治", startedOn = { year = 1868, month =  1, day =  1 } }
    -- more?
    ]
