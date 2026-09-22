;このファイルは削除しないでください！
;
;make.ks はデータをロードした時に呼ばれる特別なKSファイルです。
;Fixレイヤーの初期化など、ロード時点で再構築したい処理をこちらに記述してください。
;
;

; ============================================================
; Straying ロード後UI復元
; ============================================================


[skipstop]
[autostop]

[iscript]

if (window.StrayingUI) {

    // セーブロード後にフォントを再適用
    if (typeof window.StrayingUI.applyFonts === "function") {
        window.StrayingUI.applyFonts();
    }

    // CONTINUE時はLANGを即時表示
    if (typeof window.StrayingUI.createLanguageUI === "function") {
        window.StrayingUI.createLanguageUI(false);
    }

}

[endscript]

;make.ks はロード時にcallとして呼ばれるため、return必須です。
[return]

