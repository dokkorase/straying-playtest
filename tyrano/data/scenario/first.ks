;一番最初に呼び出されるファイル

*start

; 開発中は true
; 通常起動を確認するときは false
[eval exp="f.dev_direct_demo = false"]

; ============================================================
; Straying 言語データ読み込み
; ============================================================

[call storage="straying_lang_ja.ks"]
[call storage="straying_lang_en.ks"]

; ============================================================
; Straying 多言語UI辞書
; ※作品固有の表示文言をここで一元管理する
; ※RNF共通機能とは分離する
; ============================================================

[iscript]

window.StrayingI18n = window.StrayingI18n || {

    defaultLanguage: "ja",

    getLanguage: function () {

    var lang =
        TYRANO.kag.variable.sf.language;

    if (
        lang !== "ja" &&
        lang !== "en"
    ) {
        lang = this.defaultLanguage;
    }

    return lang;
},

setLanguage: function (lang) {

    if (
        lang !== "ja" &&
        lang !== "en"
    ) {
        lang = this.defaultLanguage;
    }

    TYRANO.kag.variable.sf.language = lang;

    if (TYRANO.kag.saveSystemVariable) {
        TYRANO.kag.saveSystemVariable();
    }

    return lang;
},


    messages:
    window.StrayingMessages || {},

    get: function (key) {

    var lang = this.getLanguage();

    var messages =
        this.messages[lang] || {};

    if (
        Object.prototype.hasOwnProperty.call(
            messages,
            key
        )
    ) {
        return messages[key];
    }

    var fallback =
        this.messages[this.defaultLanguage] || {};

    return fallback[key] || "";
}


};

[endscript]


; ==================================================
; Straying用 キーコンフィグ最終設定
; ==================================================

[iscript]

if (window.__tyrano_key_config) {

    Object.keys(window.__tyrano_key_config.key || {}).forEach(function (key) {
        window.__tyrano_key_config.key[key] = "";
    });

    // 開発中だけCtrl長押しスキップ
    window.__tyrano_key_config.key.Control = "holdskip";

    // デバッグ時のF12のみ許可
    window.__tyrano_key_config.key.F12 = "default_debug";


    Object.keys(window.__tyrano_key_config.mouse || {}).forEach(function (key) {
        window.__tyrano_key_config.mouse[key] = "";
    });


    Object.keys(window.__tyrano_key_config.gesture || {}).forEach(function (key) {
        window.__tyrano_key_config.gesture[key] = "";
    });


    if (window.__tyrano_key_config.gamepad) {

        Object.keys(
            window.__tyrano_key_config.gamepad.button || {}
        ).forEach(function (key) {
            window.__tyrano_key_config.gamepad.button[key] = "";
        });

        Object.keys(
            window.__tyrano_key_config.gamepad.stick_digital || {}
        ).forEach(function (key) {
            window.__tyrano_key_config.gamepad.stick_digital[key] = "";
        });

        Object.keys(
            window.__tyrano_key_config.gamepad.stick || {}
        ).forEach(function (key) {
            window.__tyrano_key_config.gamepad.stick[key] = "";
        });
    }
}

[endscript]


; Straying共通UIを読み込む
[call storage="straying_ui.ks"]


[if exp="f.dev_direct_demo === true"]

    [title name="Straying Through the Fog"]

    ; デバッグ用：任意のラベルへ直接ジャンプできる入力画面
    ; 何も入力せずOKを押すと*entry（先頭）から開始する
    [cm]
    Debug: enter a label to jump to (leave blank to start from the beginning)[p]
    [iscript]
    f.debug_jump_label = "";
    [endscript]
    [edit name="f.debug_jump_label" width="400" height="50" size="24" left=440 top=300]
    [button graphic="ok.png" folder="image" target="*debug_jump_check" x=650 y=370]

    [s]

    *debug_jump_check
    [commit]
    [iscript]
      f.debug_jump_label = (f.debug_jump_label || "").trim();
      if (f.debug_jump_label === "") { f.debug_jump_label = "entry"; }
      if (f.debug_jump_label.charAt(0) !== "*") { f.debug_jump_label = "*" + f.debug_jump_label; }
    [endscript]
    ;*entry以外へ飛ぶ場合は、キャラクター登録などの共通セットアップ（*setup_common）を
    ;先に済ませておく。*start以降のラベルはchara_new等が未実行の前提で書かれているため、
    ;素通りすると[chara_hide]等でエラーになる
    [if exp='f.debug_jump_label !== "*entry"']
    [call storage="straying_sou.ks" target="*setup_common"]
    [endif]
    [jump storage="straying_sou.ks" target="&f.debug_jump_label"]

[else]

    [title name="Straying Through the Fog"]

    [stop_keyconfig]

    @call storage="tyrano.ks"

    @layopt layer="message" visible=false

    [hidemenubutton]

    [if exp="sf.notice_version == 1"]

    @jump storage="title.ks"

    [else]

    @jump storage="straying_notice.ks"

    [endif]

    [endif]

[s]