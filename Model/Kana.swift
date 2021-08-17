//
//  Kana.swift
//  Kanji Kitsune
//
//  Created by Nicholas Alba on 6/16/21.
//

import Foundation

func katakana(for hiragana: String) -> String {
    var katakana = ""
    for hiraganaCharacter in hiragana {
        if let katakanaCharacter = hiraganaToKatana[String(hiraganaCharacter)] {
            katakana.append(katakanaCharacter)
        } else {
            print(hiraganaCharacter)
            fatalError("Tried to convert non-hiragana character to katakana.")
        }
    }
    return katakana
}

let hiraganaToKatana = ["あ":"ア", "い":"イ", "う":"ウ", "え":"エ", "お":"オ", "か":"カ", "き":"キ", "く":"ク", "け":"ケ", "こ":"コ", "さ":"サ", "し":"シ", "す":"ス", "せ":"セ", "そ":"ソ", "た":"タ", "ち":"チ", "つ":"ツ", "て":"テ", "と":"ト", "な":"ナ", "に":"ニ", "ぬ":"ヌ", "ね":"ネ", "の":"ノ", "は":"ハ", "ひ":"ヒ", "ふ":"フ", "へ":"ヘ", "ほ":"ホ", "ま":"マ", "み":"ミ", "む":"ム", "め":"メ", "も":"モ", "や":"ヤ", "ゆ":"ユ", "よ":"ヨ", "ら":"ラ", "り":"リ", "る":"ル", "れ":"レ", "ろ":"ロ", "わ":"ハ", "ん":"ン", "が":"ガ", "ぎ":"ギ", "ぐ":"グ", "げ":"ゲ", "ご":"ゴ", "ざ":"ザ", "じ":"ジ", "ず":"ズ", "ぜ":"ゼ", "ぞ":"ゾ", "だ":"ダ", "ぢ":"ヂ", "づ":"ヅ", "で":"デ", "ど":"ド", "ば":"バ", "び":"ビ", "ぶ":"ブ", "べ":"ベ", "ぼ":"ボ", "ぱ":"パ", "ぴ":"ピ", "ぷ":"プ", "ぺ":"ペ", "ぽ":"ポ", "ゃ":"ャ", "ゅ":"ュ", "ょ":"ョ", "っ":"ッ", "-":"-"]
