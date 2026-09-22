; ========================================
; RNF Scenario Template
; ========================================

*entry

[cm]

; 作品開始シーンを記録
[eval exp="window.RNF.setScene(window.RNF.getProjectConfig().SCENES.S000)"]

; 匿名Participantを生成し、
; Sessionへ追加して現在参加者に選択
[eval exp="window.RNF.initializeAnonymousParticipant()"]

; 大学側で研究同意を取得済みであることを前提に、
; RNF内部のConsent状態だけを現在Participantへ登録
[eval exp="window.RNF.recordConsent()"]

; 本編開始へ
[jump target="*start"]


; ========================================
; 注意事項
; ========================================

*notice

[cm]

;タイトル画面用にメッセージ枠を隠す設定(first.ks)が正しく効いていない場合の
;保険として、ここでも明示的に隠しておく（サイズ未設定の枠が一瞬重なって
;黒く見えてしまう不具合の対策）
@layopt layer="message" visible=false

;注意事項一覧はユーザー作成のnotice001.jpg（日英併記）に差し替え
;メニューボタンと同様、少し時間をかけて表示させる
[bg storage="notice001.jpg" time=1500]
;STARTボタンは、画面中央(x=640)ではなく本文テキストの中心付近（x≈610）に
;合わせるとバランスが良かったため少し左へ。また元のy=640だと画面下端(720)
;まで20pxしかなくボタン下端が見切れていたため、文末より少し下・画面端より
;十分上のy=580へ移動
;※[glink]は環境によってサイズが指定より大きく描画される不具合があったため、
;　テキストを画像に焼き込んだ[button]方式に変更
[iscript]

if ($('#straying-notice-style').length === 0) {
    $('head').append(`
        <style id="straying-notice-style">

        .straying-notice-button {
            position: absolute;

            width: 460px;
            height: 74px;

            background-image: url("./data/image/button/modalselect_off.png");
            background-size: 100% 100%;
            background-repeat: no-repeat;

            display: flex;
            align-items: center;
            justify-content: center;

            box-sizing: border-box;

            color: #ffffff;
            font-family: sans-serif;
            font-size: 30px;
            font-weight: normal;
            letter-spacing: 0.08em;
            line-height: 1;

            text-align: center;
            cursor: pointer;
            z-index: 9999;
        }

        .straying-notice-button:hover {
            background-image: url("./data/image/button/modalselect_on.png");
        }

        </style>
    `);
}

var $noticeButton = $('<div></div>')
    .addClass('straying-notice-button')
    .text('START')
    .css({
        left: '410px',
        top: '610px'
    });

$noticeButton.on('click', function () {
    $('.straying-notice-button').remove();

    TYRANO.kag.ftag.startTag('jump', {
        target: '*start'
    });
});

$('#tyrano_base').append($noticeButton);

[endscript]

[s]


; ========================================
; 研究参加への同意
; ========================================

*consent

[cm]

;notice001.jpgの背景をここで消しておく（消さないとこの後もずっと背景に残ってしまう）
[bg storage="bimg_black.png" time=100]

;同意画面から見た目を本編と統一する（メッセージ枠・クリック待ち矢印）ため、
;*startで行っている設定をここで済ませておく。*notice画面には枠を
;被せたくないため、*entryではなくここ（*notice以降）で設定している
[position layer=message0 left=0 top=423 width=1280 height=297 page=fore visible=true frame="config/t_window.png"]
[position layer=message0 page=fore margint="110" marginl="60" marginr="60" marginb="30"]
[glyph line="t_arrow.png" folder="image" fix=true left=1219 top=668 width=41 height=32]

Do you agree to participate in this study?[p]

[glink text="I agree" target="*consent_agree"]

[glink text="I do not agree" target="*consent_decline"]

[s]


; ========================================
; 同意した場合
; ========================================

*consent_agree

[cm]

; Consent記録 + Withdrawal Code発行
[eval exp="f.rnf_research_start=window.RNF.startResearchParticipation()"]

; Withdrawal Codeを一時変数へ保存
[eval exp="f.rnf_withdrawal_code=f.rnf_research_start.withdrawal ? f.rnf_research_start.withdrawal.withdrawalCode : ''"]

Your withdrawal code is: [emb exp="f.rnf_withdrawal_code"][p]

Please save this code if you may want to withdraw your participation later.[p]

[jump target="*start"]


; ========================================
; 同意しない場合
; ========================================

*consent_decline

[cm]

Thank you. You have chosen not to participate in this study.[p]

[s]


; ========================================
; 0. オープニング
; ========================================

*start

; 新規ゲーム用データを初期化
[call storage="straying_sou.ks" target="*setup_new_game"]

; ゲーム共通セットアップ
[call storage="straying_sou.ks" target="*setup_common"]

; ============================================================
; 0. オープニング（霧の森／目を開ける・開けない）
; ============================================================
*start1
[cm]


;※time=0以外だと、クロスフェード完了を待つ処理が何らかの条件で
;　完了コールバックを呼ばないまま止まってしまうことがあったため、
;　time=0（即時）にし、代わりにwaitで間を取るようにしている
[bg storage="bimg_black.png" time=0]
[wait time=2000]

[emb exp="window.StrayingI18n.get('g00.l001')"][p]

[emb exp="window.StrayingI18n.get('g00.l002')"][p]

[emb exp="window.StrayingI18n.get('g00.l003')"][p]

[wait time=2000]

; ----------------------------------------------------------
; 選択場面0-1：目を開ける／目を開けない（1回目）
; ----------------------------------------------------------
[iscript]

f.selEye1 =
    window.StrayingI18n.get(
        "g00.c001"
    );

f.selEye2 =
    window.StrayingI18n.get(
        "g00.c002"
    );

f.popUpText =
    window.StrayingI18n.get(
        "g00.ui001"
    );

[endscript]

[iscript]

$('#straying-choice-guide').remove();

var $guide = $('<div id="straying-choice-guide"></div>');

$guide
    .text(f.popUpText)
    .css({
        position: 'absolute',

        left: '470px',
        top: '92px',

        width: '340px',
        height: '66px',

        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',

        boxSizing: 'border-box',

        padding: '0 24px',

        background:
            'rgba(12, 18, 22, 0.82)',

        border:
            '1px solid rgba(230,146,63,0.78)',

        borderRadius: '24px',

        boxShadow:
            '0 0 14px rgba(230,146,63,0.10)',

        color:
            '#e6923f',

        fontFamily:
            '"Straying Sans", sans-serif',

        fontSize: '20px',
        fontWeight: '400',

        textAlign: 'center',
        lineHeight: '1.4',

        letterSpacing: '0.04em',

        zIndex: 20,

        opacity: 0
    });

$('#tyrano_base').append($guide);

$guide.animate(
    {
        opacity: 1
    },
    350
);

[endscript]

[glink x=270 y=200 text="&f.selEye1" target="*eyes_open" graphic="select_off.png" enterimg="select_on.png" width="600" height="50" size="32" ]
[glink x=270 y=320 text="&f.selEye2" target="*eyes_closed_1" graphic="select_off.png" enterimg="select_on.png" width="600" height="50" size="32" ]

[s]

;---------
*eyes_open
;---------
[cm]

[iscript]
$('#straying-choice-guide').fadeOut(300, function () {
    $(this).remove();
});
[endscript]

[freeimage layer="1" time="700"]
;「どちらかを選んでください」の案内テキストも合わせて消す
;※name=を指定せずに[ptext text=""]を呼ぶと「上書き」ではなく「新規追加」になってしまい
;　元のテキストは消えずに残ったままだったため、overwrite=true + 同じname=で修正
[ptext layer="1" x="437" y="95" text="" color="black" edge="0xFFFFFF" size="24" name="popup_ptext" overwrite="true"]

;まぶたの開け閉めのような演出（明滅）
;※動く霧レイヤーをこの時点から重ねると、明滅の間もずっと霧が揺れ動いてしまい
;　不自然に見えたため、明滅中はbg001a.jpgに霧をあらかじめ合成した
;　静止画（bg001a_fog.jpg）を使用する。動く霧は目が完全に開いてから重ねる
[bg storage="bg001a_fog.jpg" time="80"]
[wait time=120]
[bg storage="bimg_black.png" time="80"]
[wait time=250]

[bg storage="bg001a_fog.jpg" time="80"]
[wait time=120]
[bg storage="bimg_black.png" time="80"]
[wait time=300]

; ============================================================
; 最後の開眼：本編用の無限スクロール霧
; ============================================================

; layer 2 を取得するためのアンカー
[image layer="2" page="fore" visible=true storage="bg004.png" folder="image" opacity=0 x=0 y=0 name="fog_main_anchor"]

[iscript]
(function () {

    if (window.strayingFogMainRaf) {
        cancelAnimationFrame(window.strayingFogMainRaf);
        window.strayingFogMainRaf = null;
    }

    $('.straying-main-fog').remove();

    var $anchor = $('.fog_main_anchor');

    if (!$anchor.length) {
        return;
    }

    var $layer = $anchor.parent();
    $anchor.remove();

    var $fog = $('<div class="straying-main-fog"></div>');

    $fog.css({
        position: 'absolute',
        left: '0px',
        top: '0px',

        width: '1280px',
        height: '720px',

        backgroundImage: 'url("./data/image/bg004.png")',
        backgroundRepeat: 'repeat-x',
        backgroundPosition: '0px 0px',
        backgroundSize: 'auto 720px',

        opacity: 0,
        pointerEvents: 'none'
    });

    $layer.append($fog);

    var speed = 15;
    var positionX = 0;
    var lastTime = performance.now();

    function moveFog(now) {

        if (!$fog[0] || !$fog[0].isConnected) {
            window.strayingFogMainRaf = null;
            return;
        }

        var delta = Math.min((now - lastTime) / 1000, 0.05);
        lastTime = now;

        positionX -= speed * delta;

        $fog.css(
            'background-position',
            positionX + 'px 0px'
        );

        window.strayingFogMainRaf =
            requestAnimationFrame(moveFog);
    }

    window.strayingFogMainRaf =
        requestAnimationFrame(moveFog);

    ; 目が開くと同時に霧をゆっくり出す
    $fog.animate({ opacity: 1 }, 2600);

})();
[endscript]

; 黒から森へゆっくり開眼
[bg storage="bg001a.jpg" time="1800"]

; 霧が十分馴染むまで待つ
[wait time=800]
[wait time=400]

; 夜の森の環境音
[playbgm storage="bgm002.mp3" html5=true]

[emb exp="window.StrayingI18n.get('g00.l004')"][p]

[emb exp="window.StrayingI18n.get('g00.l005a')"][l][r]
[emb exp="window.StrayingI18n.get('g00.l005b')"][r]
[emb exp="window.StrayingI18n.get('g00.l005c')"][p]

[emb exp="window.StrayingI18n.get('g00.l006a')"][r]
[emb exp="window.StrayingI18n.get('g00.l006b')"][p]

[playse storage="se001.mp3"]

[emb exp="window.StrayingI18n.get('g00.l007a')"][r]
[emb exp="window.StrayingI18n.get('g00.l007b')"][p]

[emb exp="window.StrayingI18n.get('g00.l008a')"][r]
[emb exp="window.StrayingI18n.get('g00.l008b')"][p]

@jump target=*forest_start

;---------
*eyes_closed_1
;---------
[cm]

[iscript]
$('#straying-choice-guide').fadeOut(300, function () {
    $(this).remove();
});
[endscript]

;「……。」の静かな間は選択を求めていないため、案内ポップアップも一旦消す
[freeimage layer="1" time="300"]
[ptext layer="1" x="437" y="95" text="" color="black" edge="0xFFFFFF" size="24" name="popup_ptext" overwrite="true"]

[emb exp="window.StrayingI18n.get('g00.l009')"][p]

[emb exp="window.StrayingI18n.get('g00.l010')"][p]

; ----------------------------------------------------------
; 選択場面0-2：目を開ける／目を開けない（2回目）
; ----------------------------------------------------------
;案内ポップアップは最初の1回だけ表示すればよいため、ここでは出し直さない

[iscript]

f.selEye1 =
    window.StrayingI18n.get(
        "g00.c001"
    );

f.selEye2 =
    window.StrayingI18n.get(
        "g00.c002"
    );

[endscript]

[glink x=270 y=200 text="&f.selEye1" target="*eyes_open" graphic="select_off.png" enterimg="select_on.png" width="600" height="50" size="32" ]
[glink x=270 y=320 text="&f.selEye2" target="*eyes_closed_2" graphic="select_off.png" enterimg="select_on.png" width="600" height="50" size="32" ]

[s]

;---------
*eyes_closed_2
;---------
[cm]
;「……。」の静かな間は選択を求めていないため、案内ポップアップも一旦消す
[freeimage layer="1" time="300"]
[ptext layer="1" x="437" y="95" text="" color="black" edge="0xFFFFFF" size="24" name="popup_ptext" overwrite="true"]

[emb exp="window.StrayingI18n.get('g00.l009')"][p]

[emb exp="window.StrayingI18n.get('g00.l010')"][p]

; ----------------------------------------------------------
; 選択場面0-3：目を開ける（強制・3回目）
; ----------------------------------------------------------
;案内ポップアップは最初の1回だけ表示すればよいため、ここでは出し直さない

[iscript]

f.selEye1 =
    window.StrayingI18n.get(
        "g00.c001"
    );

f.selEye2 =
    window.StrayingI18n.get(
        "g00.c002"
    );

[endscript]

[glink x=270 y=250 text="&f.selEye1" target="*eyes_open" graphic="select_off.png" enterimg="select_on.png" width="600" height="50" size="32" ]

[s]

; ============================================================
; 1. 導入：霧の森で迷子になる
; ============================================================
*forest_start
[autosave]
[cm]

[emb exp="window.StrayingI18n.get('g01.l001')"][p]

[emb exp="window.StrayingI18n.get('g01.l002a')"][r]
[emb exp="window.StrayingI18n.get('g01.l002b')"][p]

[emb exp="window.StrayingI18n.get('g01.l003')"][p]

[emb exp="window.StrayingI18n.get('g01.l004a')"][r]
[emb exp="window.StrayingI18n.get('g01.l004b')"][p]

[emb exp="window.StrayingI18n.get('g01.l005')"][p]

; ----------------------------------------------------------
; 選択場面1：声のする方へ歩く／その場にとどまる
; ----------------------------------------------------------
[iscript]

f.selApproach1 =
    window.StrayingI18n.get(
        "g01.c001"
    );

f.selApproach2 =
    window.StrayingI18n.get(
        "g01.c002"
    );

[endscript]

[glink x=270 y=200 text="&f.selApproach1" target="*approach_child" graphic="select_off.png" enterimg="select_on.png" width="600" height="50" size="32" ]
[glink x=270 y=320 text="&f.selApproach2" target="*stay_still" graphic="select_off.png" enterimg="select_on.png" width="600" height="50" size="32" ]

[s]

;---------
*approach_child
;---------
[cm]

[eval exp="window.RNF.recordChoice(window.RNF.getProjectConfig().ANSWERS.Q001.QUESTION_ID,window.RNF.getProjectConfig().ANSWERS.Q001.CHOICES.C01,'Walk toward the sound')"]

[playse storage="se002.mp3"]

[emb exp="window.StrayingI18n.get('g01.l006a')"][r]
[emb exp="window.StrayingI18n.get('g01.l006b')"][p]

@jump target=*see_child

;---------
*stay_still
;---------
[cm]

[eval exp="window.RNF.recordChoice(window.RNF.getProjectConfig().ANSWERS.Q001.QUESTION_ID,window.RNF.getProjectConfig().ANSWERS.Q001.CHOICES.C02,'Stay where you are')"]

[emb exp="window.StrayingI18n.get('g01.l007a')"][r]
[emb exp="window.StrayingI18n.get('g01.l007b')"][p]

[emb exp="window.StrayingI18n.get('g01.l008')"][p]

[emb exp="window.StrayingI18n.get('g01.l009a')"][r]
[emb exp="window.StrayingI18n.get('g01.l009b')"][p]

[playse storage="se002.mp3"]

[emb exp="window.StrayingI18n.get('g01.l010a')"][r]
[emb exp="window.StrayingI18n.get('g01.l006b')"][p]

@jump target=*see_child

; ============================================================
; 2. 子どもとの出会い
; ============================================================
*see_child
[autosave]
[cm]

[emb exp="window.StrayingI18n.get('g02.l001a')"][r]
[emb exp="window.StrayingI18n.get('g02.l001b')"][p]

[emb exp="window.StrayingI18n.get('g02.l002a')"][r]
[emb exp="window.StrayingI18n.get('g02.l002b')"][p]
[fadeoutbgm time="1800"]

[emb exp="window.StrayingI18n.get('g02.l003')"][p]

[emb exp="window.StrayingI18n.get('g02.l004a')"][l][r]
[emb exp="window.StrayingI18n.get('g02.l004b')"][p]

[chara_show name="child"]

; ----------------------------------------------------------
; 選択場面2：声をかける／声をかけない
; ----------------------------------------------------------
[iscript]
f.selCall1 = window.StrayingI18n.get('g02.c001')
f.selCall2 = window.StrayingI18n.get('g02.c002')
[endscript]

[glink x=270 y=200 text="&f.selCall1" target="*call_out" graphic="select_off.png" enterimg="select_on.png" width="600" height="50" size="32" ]
[glink x=270 y=320 text="&f.selCall2" target="*dont_call" graphic="select_off.png" enterimg="select_on.png" width="600" height="50" size="32" ]

[s]

;---------
*call_out
;---------
[cm]

[eval exp="window.RNF.recordChoice(window.RNF.getProjectConfig().ANSWERS.Q002.QUESTION_ID,window.RNF.getProjectConfig().ANSWERS.Q002.CHOICES.C01,'Call out to the child')"]

[playbgm storage="bgm001.mp3" html5=true]

[emb exp="window.StrayingI18n.get('g02.l005')"][p]

[emb exp="window.StrayingI18n.get('g02.l006a')"][r]
[emb exp="window.StrayingI18n.get('g02.l006b')"][p]

[emb exp="window.StrayingI18n.get('g02.l007')"][p]

[emb exp="window.StrayingI18n.get('g02.l008a')"][r]
[emb exp="window.StrayingI18n.get('g02.l008b')"][r]
[emb exp="window.StrayingI18n.get('g02.l008c')"][p]

@jump target=*child_notices

;---------
*dont_call
;---------
[cm]

[eval exp="window.RNF.recordChoice(window.RNF.getProjectConfig().ANSWERS.Q002.QUESTION_ID,window.RNF.getProjectConfig().ANSWERS.Q002.CHOICES.C02,'Do not call out')"]

[emb exp="window.StrayingI18n.get('g00.l009')"][p]

[emb exp="window.StrayingI18n.get('g00.l010')"][p]

; 結局は声をかける流れになるが、いきなり強制するのではなく
; 「自分で選んだ」形にするため、選択肢を一つだけ挟む（編集メモ反映）
[glink x=270 y=250 text="&window.StrayingI18n.get('g02.c001')" target="*dont_call_decide" graphic="select_off.png" enterimg="select_on.png" width="600" height="50" size="32" ]

[s]

;---------
*dont_call_decide
;---------
[cm]

[playbgm storage="bgm001.mp3" html5=true]
[emb exp="window.StrayingI18n.get('g02.l005')"][p]

[emb exp="window.StrayingI18n.get('g02.l006a')"][l][r]
[emb exp="window.StrayingI18n.get('g02.l006b')"][p]

[emb exp="window.StrayingI18n.get('g02.l007')"][p]

[emb exp="window.StrayingI18n.get('g02.l008a')"][r]
[emb exp="window.StrayingI18n.get('g02.l008b')"][r]
[emb exp="window.StrayingI18n.get('g02.l008c')"][p]

@jump target=*child_notices

; ============================================================
; 3. 一緒に探す（探し物の中身）
; ============================================================
*child_notices
[autosave]
[cm]

[emb exp="window.StrayingI18n.get('g03.l001')"][p]

[emb exp="window.StrayingI18n.get('g03.l002a')"][l][r]
[emb exp="window.StrayingI18n.get('g03.l002b')"][r]
[emb exp="window.StrayingI18n.get('g03.l002c')"][p]

; --- 「迷子かな？」：分岐ではなく、押すと進む会話ボタン ---
[glink x=270 y=250 text="&window.StrayingI18n.get('g03.c001')" target="*ask_lost" graphic="select_off.png" enterimg="select_on.png" width="600" height="50" size="32" ]
[s]

;---------
*ask_lost
;---------
[cm]

[emb exp="window.StrayingI18n.get('g03.c001')"][p]

[emb exp="window.StrayingI18n.get('g03.l003a')"][r]
[emb exp="window.StrayingI18n.get('g03.l003b')"][p]

[emb exp="window.StrayingI18n.get('g03.l004')"][p]

[emb exp="window.StrayingI18n.get('g03.l005')"][p]

; --- 「なにを？」：会話ボタン ---
[glink x=270 y=250 text="&window.StrayingI18n.get('g03.c002')" target="*ask_what" graphic="select_off.png" enterimg="select_on.png" width="600" height="50" size="32" ]
[s]

;---------
*ask_what
;---------
[cm]

[emb exp="window.StrayingI18n.get('g03.l006')"][p]

[emb exp="window.StrayingI18n.get('g03.l007')"][p]

[emb exp="window.StrayingI18n.get('g03.l008')"][p]

[emb exp="window.StrayingI18n.get('g03.l009a')"][r]
[emb exp="window.StrayingI18n.get('g03.l009b')"][p]

[emb exp="window.StrayingI18n.get('g03.l010a')"][r]
[emb exp="window.StrayingI18n.get('g03.l010b')"][p]

[emb exp="window.StrayingI18n.get('g03.l011')"][p]

[emb exp="window.StrayingI18n.get('g03.l012a')"][l][r]
[emb exp="window.StrayingI18n.get('g03.l012b')"][p]

; --- 「家族はどこ？」：会話ボタン ---
[glink x=270 y=250 text="&window.StrayingI18n.get('g03.c003')" target="*ask_family" graphic="select_off.png" enterimg="select_on.png" width="600" height="50" size="32" ]
[s]

;---------
*ask_family
;---------
[cm]

[emb exp="window.StrayingI18n.get('g03.l013')"][p]

[emb exp="window.StrayingI18n.get('g03.l014')"][p]

[emb exp="window.StrayingI18n.get('g03.l015a')"][l][r]
[emb exp="window.StrayingI18n.get('g03.l015b')"][p]

[emb exp="window.StrayingI18n.get('g03.l016')"][p]

[emb exp="window.StrayingI18n.get('g03.l017')"][p]

[emb exp="window.StrayingI18n.get('g03.l018a')"][r]
[emb exp="window.StrayingI18n.get('g03.l018b')"][p]

[emb exp="window.StrayingI18n.get('g03.l019a')"][r]
[emb exp="window.StrayingI18n.get('g03.l019b')"][r]
[emb exp="window.StrayingI18n.get('g03.l019c')"][p]

[fadeoutbgm time="1800"]
[emb exp="window.StrayingI18n.get('g03.l020')"][p]

; ----------------------------------------------------------
; 選択場面3：一緒に探そう／できることはある？
; Q003
; ----------------------------------------------------------
[iscript]
f.selHelp1 = window.StrayingI18n.get('g03.c004')
f.selHelp2 = window.StrayingI18n.get('g03.c005')
[endscript]

[glink x=270 y=200 text="&f.selHelp1" target="*offer_search" graphic="select_off.png" enterimg="select_on.png" width="600" height="50" size="32" ]
[glink x=270 y=320 text="&f.selHelp2" target="*ask_help" graphic="select_off.png" enterimg="select_on.png" width="600" height="50" size="32" ]

[s]

;---------
*offer_search
;---------
[cm]

[eval exp="window.RNF.recordChoice(window.RNF.getProjectConfig().ANSWERS.Q003.QUESTION_ID,window.RNF.getProjectConfig().ANSWERS.Q003.CHOICES.C01,'Search together')"]

[emb exp="window.StrayingI18n.get('g03.l021')"][p]

[emb exp="window.StrayingI18n.get('g03.l022')"][p]

@jump target=*search_together_yes


;---------
*ask_help
;---------
[cm]

[eval exp="window.RNF.recordChoice(window.RNF.getProjectConfig().ANSWERS.Q003.QUESTION_ID,window.RNF.getProjectConfig().ANSWERS.Q003.CHOICES.C02,'Ask what you can do')"]

[emb exp="window.StrayingI18n.get('g03.l023')"][p]

[emb exp="window.StrayingI18n.get('g03.l024')"][p]

[emb exp="window.StrayingI18n.get('g03.l025')"][p]

[emb exp="window.StrayingI18n.get('g03.l026')"][p]

[emb exp="window.StrayingI18n.get('g03.l022')"][p]

@jump target=*search_together_yes

;---------
*search_together_yes
;---------
[cm]

[playbgm storage="bgm004.mp3" html5=true]
[emb exp="window.StrayingI18n.get('g03.l027a')"][r]
[emb exp="window.StrayingI18n.get('g03.l027b')"][p]

[emb exp="window.StrayingI18n.get('g03.l028')"][p]

[emb exp="window.StrayingI18n.get('g03.l029')"][p]

[emb exp="window.StrayingI18n.get('g03.l030a')"][r]
[emb exp="window.StrayingI18n.get('g03.l030b')"][p]

[emb exp="window.StrayingI18n.get('g03.l031a')"][r]
[emb exp="window.StrayingI18n.get('g03.l031b')"][p]

[emb exp="window.StrayingI18n.get('g03.l032')"][p]

[emb exp="window.StrayingI18n.get('g03.l033')"][p]

[emb exp="window.StrayingI18n.get('g03.l034a')"][l][r]
[emb exp="window.StrayingI18n.get('g03.l034b')"][p]

[emb exp="window.StrayingI18n.get('g03.l035a')"][r]
[emb exp="window.StrayingI18n.get('g03.l035b')"][p]

[emb exp="window.StrayingI18n.get('g03.l036')"][p]

;[chara_face]はmap_face（顔の対応表）を更新するだけで、既に表示中の
;キャラクターの見た目はその場では切り替わらない仕様だった（エラーは直ったが
;画像自体が変わらなかった原因）。*ask_nameで使っている「一度隠して
;顔を指定し直して見せる」パターンで、実際に表示を切り替える
[chara_hide name="child"]
[chara_show name="child" face="hand"]

[emb exp="window.StrayingI18n.get('g03.l037a')"][r]
[emb exp="window.StrayingI18n.get('g03.l037b')"][p]

; ----------------------------------------------------------
; 選択場面3-2：握り返す／そのままにする
; Q004
; ----------------------------------------------------------
[iscript]
f.selHand1 = window.StrayingI18n.get('g03.c006')
f.selHand2 = window.StrayingI18n.get('g03.c007')
[endscript]

[glink x=270 y=200 text="&f.selHand1" target="*hand_back" graphic="select_off.png" enterimg="select_on.png" width="600" height="50" size="32" ]
[glink x=270 y=320 text="&f.selHand2" target="*hand_leave" graphic="select_off.png" enterimg="select_on.png" width="600" height="50" size="32" ]

[s]

;---------
*hand_back
;---------
[cm]

[eval exp="window.RNF.recordChoice(window.RNF.getProjectConfig().ANSWERS.Q004.QUESTION_ID,window.RNF.getProjectConfig().ANSWERS.Q004.CHOICES.C01,'Hold the hand back')"]

[chara_hide name="child"]
[chara_show face="shake" name="child"]

[emb exp="window.StrayingI18n.get('g03.l038a')"][r]
[emb exp="window.StrayingI18n.get('g03.l038b')"][p]

[emb exp="window.StrayingI18n.get('g03.l039')"][p]

[emb exp="window.StrayingI18n.get('g03.l040a')"][r]
[emb exp="window.StrayingI18n.get('g03.l040b')"][r]
[emb exp="window.StrayingI18n.get('g03.l040c')"][p]

@jump target=*ask_name


;---------
*hand_leave
;---------
[cm]

[eval exp="window.RNF.recordChoice(window.RNF.getProjectConfig().ANSWERS.Q004.QUESTION_ID,window.RNF.getProjectConfig().ANSWERS.Q004.CHOICES.C02,'Leave the hand as it is')"]

[emb exp="window.StrayingI18n.get('g03.l041a')"][l][r]
[emb exp="window.StrayingI18n.get('g03.l041b')"][p]

@jump target=*ask_name

; ============================================================
; 4. 名前をつける
; ============================================================
*ask_name
[autosave]
[cm]

[chara_hide name="child"]
[chara_show face="walk" name="child"]

[emb exp="window.StrayingI18n.get('g04.l001')"][p]

[emb exp="window.StrayingI18n.get('g04.l002a')"][r]
[emb exp="window.StrayingI18n.get('g04.l002b')"][p]

[emb exp="window.StrayingI18n.get('g04.l003')"][p]

[chara_hide name="child"]

*name_input

;プレースホルダー文字は入力欄の幅(280px)に収まる短い言葉にしている
;（元は「呼び名を教えてください」で長すぎて入りきっていなかった）
[iscript]

f.name_placeholder =
    window.StrayingI18n.get("namePlaceholder");

[endscript]

[chara_hide name="child"]

; 再入力時に古いOKボタンが残らないよう削除
[iscript]
$('.straying-name-ok-button').remove();
[endscript]

; 入力欄を画面中央へ
[edit name="sf.player_name" width="280" height="50" size="30" left=500 top=175 maxchars=8]

[iscript]
(function () {

    $('.straying-name-ok-button').remove();

    var $btn = $('<div class="straying-name-ok-button">OK</div>');

    $btn.css({
        position: 'absolute',

        /* 幅200pxなので (1280-200)/2 = 540 */
        left: '540px',
        top: '308px',

        width: '200px',
        height: '50px',

        backgroundImage: 'url("./data/image/button/modalselect_off.png")',
        backgroundSize: '100% 100%',
        backgroundRepeat: 'no-repeat',

        fontFamily: '"Straying Sans", sans-serif',
        fontSize: '28px',
        fontWeight: '400',
        color: '#fff',

        textAlign: 'center',
        lineHeight: '50px',

        cursor: 'pointer',
        userSelect: 'none',

        zIndex: 999
    });

    $btn.on('mouseenter', function () {
        $(this).css(
            'background-image',
            'url("./data/image/button/modalselect_on.png")'
        );
    });

    $btn.on('mouseleave', function () {
        $(this).css(
            'background-image',
            'url("./data/image/button/modalselect_off.png")'
        );
    });

    $btn.on('click', function () {

        $('.straying-name-ok-button').remove();

        TYRANO.kag.ftag.startTag('jump', {
            target: '*check_name'
        });

    });

    $('.layer_free').append($btn);

})();
[endscript]

[iscript]
$(function() {
    var $editBox = $('input[name="sf.player_name"]');
    var defaultText = f.name_placeholder;
    $editBox.val(defaultText);
    $editBox.css('color', '#888');
    $editBox.on('focus', function() {
        if ($(this).val() === defaultText) {
            $(this).val('');
            $(this).css('color', '#000');
        }
    });
    $editBox.on('blur', function() {
        if ($(this).val() === '') {
            $(this).val(defaultText);
            $(this).css('color', '#888');
        }
    });
});
[endscript]

[s]

*check_name
[commit]

[iscript]
$('.straying-name-ok-button').remove();
[endscript]

[iscript]

var trimmed_name = (sf.player_name || "").trim();

if (
    trimmed_name === "" ||
    trimmed_name === f.name_placeholder
) {
    f.is_empty_name = true;
} else {
    f.is_empty_name = false;
}

[endscript]

[if exp="f.is_empty_name==true"]
[cm]
;スキップ/既読による早送りで台詞が流れてしまわないよう明示的に止める
[skipstop]

[chara_show face="walk" name="child"]


[emb exp="window.StrayingI18n.get('g04.l004a')"][r]
[emb exp="window.StrayingI18n.get('g04.l004b')"][p]
[jump target="*name_input"]
[endif]

[cm]

;glinkのtext=属性の中では[emb]タグは評価されない（そのまま文字列として表示されて
;しまう）ため、先にiscriptで文字列を組み立ててから&f.xxxで渡している

[emb exp="window.StrayingI18n.get('g04.l005').replace('{value}', function () { return sf.player_name; })"][p]

[chara_show face="walk" name="child"]

[emb exp="window.StrayingI18n.get('g04.l006').replace('{value}', function () { return sf.player_name; })"][p]

[iscript]
f.name_confirm_text = window.StrayingI18n.get('g04.c001').replace('{value}', function () { return sf.player_name; })
[endscript]

; ----------------------------------------------------------
; 選択場面4：〈名前〉でいい／やっぱり変える
; ----------------------------------------------------------
[glink x=270 y=200 text="&f.name_confirm_text" target="*name_confirm" graphic="select_off.png" enterimg="select_on.png" width="600" height="50" size="32" ]
[glink x=270 y=320 text="&window.StrayingI18n.get('g04.c002')" target="*name_retry" graphic="select_off.png" enterimg="select_on.png" width="600" height="50" size="32" ]

[s]

;---------
*name_confirm
;---------
[cm]

[emb exp="window.StrayingI18n.get('g04.l007')"][p]

[emb exp="window.StrayingI18n.get('g04.l008').replace('{value}', function () { return sf.player_name; })"][p]

[fadeoutbgm time="1800"]
@jump target=*walk_together

;---------
*name_retry
;---------
[cm]

[emb exp="window.StrayingI18n.get('g04.l009')"][p]

@jump target=*name_input

; ============================================================
; 5. 森を歩きながらの対話
; ============================================================
*walk_together
[autosave]
[cm]

[chara_hide name="child"]

[emb exp="window.StrayingI18n.get('g00.l009')"][p]

[emb exp="window.StrayingI18n.get('g05.l001a')"][r]
[emb exp="window.StrayingI18n.get('g05.l001b')"][p]

[playbgm storage="bgm001.mp3" html5=true]

[emb exp="window.StrayingI18n.get('g05.l002a')"][r]
[emb exp="window.StrayingI18n.get('g05.l002b')"][p]

[emb exp="window.StrayingI18n.get('g05.l003a')"][r]
[emb exp="window.StrayingI18n.get('g05.l003b')"][p]

[emb exp="window.StrayingI18n.get('g05.l004a')"][r]
[emb exp="window.StrayingI18n.get('g05.l004b')"][p]

[wait time=2000]

[emb exp="window.StrayingI18n.get('g05.l005a')"][l][r]
[emb exp="window.StrayingI18n.get('g05.l005b')"][p]

[chara_show face="walk" name="child"]

; ----------------------------------------------------------
; 選択場面5-1：どこから来たの？／来た道はわかる？
; ----------------------------------------------------------
[glink x=270 y=200 text="&window.StrayingI18n.get('g05.c001')" target="*ask_where_from" graphic="select_off.png" enterimg="select_on.png" width="600" height="50" size="32" ]
[glink x=270 y=320 text="&window.StrayingI18n.get('g05.c002')" target="*ask_which_way" graphic="select_off.png" enterimg="select_on.png" width="600" height="50" size="32" ]

[s]

;---------
*ask_where_from
;---------
[cm]

[emb exp="window.StrayingI18n.get('g05.l006')"][p]

[emb exp="window.StrayingI18n.get('g05.l007a')"][r]
[emb exp="window.StrayingI18n.get('g05.l007b')"][p]

[emb exp="window.StrayingI18n.get('g05.l008')"][p]

[emb exp="window.StrayingI18n.get('g05.l009a')"][l][r]
[emb exp="window.StrayingI18n.get('g05.l009b')"][p]

[emb exp="window.StrayingI18n.get('g05.l010')"][p]

@jump target=*decide_walk

;---------
*ask_which_way
;---------
[cm]

[emb exp="window.StrayingI18n.get('g05.c002')"][p]

[emb exp="window.StrayingI18n.get('g05.l007a')"][r]
[emb exp="window.StrayingI18n.get('g05.l007b')"][p]

[emb exp="window.StrayingI18n.get('g05.l011')"][p]

[emb exp="window.StrayingI18n.get('g05.l012a')"][r]
[emb exp="window.StrayingI18n.get('g05.l012b')"][p]

[emb exp="window.StrayingI18n.get('g05.l013a')"][l][r]
[emb exp="window.StrayingI18n.get('g05.l009b')"][p]

[emb exp="window.StrayingI18n.get('g05.l010')"][p]

@jump target=*decide_walk

;---------
*decide_walk
;---------
[cm]

[emb exp="window.StrayingI18n.get('g05.l014')"][p]

; ----------------------------------------------------------
; 選択場面5-2：探検してみよう／歩いてみよう
; ----------------------------------------------------------
[glink x=270 y=200 text="&window.StrayingI18n.get('g05.c003')" target="*explore" graphic="select_off.png" enterimg="select_on.png" width="600" height="50" size="32" ]
[glink x=270 y=320 text="&window.StrayingI18n.get('g05.c004')" target="*just_walk" graphic="select_off.png" enterimg="select_on.png" width="600" height="50" size="32" ]

[s]

;---------
*explore
;---------
[cm]

[emb exp="window.StrayingI18n.get('g05.l015')"][p]

[emb exp="window.StrayingI18n.get('g05.l016')"][p]

[emb exp="window.StrayingI18n.get('g05.l017a')"][r]
[emb exp="window.StrayingI18n.get('g05.l017b')"][r]
[emb exp="window.StrayingI18n.get('g05.l017c')"][p]

[emb exp="window.StrayingI18n.get('g05.l018a')"][r]
[emb exp="window.StrayingI18n.get('g05.l018b')"][p]

@jump target=*walking_fog

;---------
*just_walk
;---------
[cm]

[emb exp="window.StrayingI18n.get('g05.l019')"][p]

[emb exp="window.StrayingI18n.get('g05.l020')"][p]

[emb exp="window.StrayingI18n.get('g05.l021a')"][r]
[emb exp="window.StrayingI18n.get('g05.l018b')"][p]

@jump target=*walking_fog

;---------
*walking_fog
;---------
[cm]

[fadeoutbgm time="1800"]
[chara_hide name="child"]
[wait time=2000]

[emb exp="window.StrayingI18n.get('g00.l009')"][p]

[emb exp="window.StrayingI18n.get('g00.l010')"][p]

[playse storage="se002.mp3"]
[emb exp="window.StrayingI18n.get('g05.l022a')"][r]
[emb exp="window.StrayingI18n.get('g05.l022b')"][p]


; 少し間を置く
[wait time=700]

[playbgm storage="bgm002.mp3" html5=true]
[playse storage="se003.mp3"]

[emb exp="window.StrayingI18n.get('g05.l023a')"][r]
[emb exp="window.StrayingI18n.get('g05.l023b')"][p]

[emb exp="window.StrayingI18n.get('g05.l024a')"][l][r]
[emb exp="window.StrayingI18n.get('g05.l024b')"][r]
[emb exp="window.StrayingI18n.get('g05.l024c')"][p]

[emb exp="window.StrayingI18n.get('g05.l025a')"][r]
[emb exp="window.StrayingI18n.get('g05.l025b')"][p]

[emb exp="window.StrayingI18n.get('g05.l026a')"][r]
[emb exp="window.StrayingI18n.get('g05.l026b')"][p]

[emb exp="window.StrayingI18n.get('g05.l027a')"][r]
[emb exp="window.StrayingI18n.get('g05.l027b')"][p]

[emb exp="window.StrayingI18n.get('g00.l009')"][p]

[emb exp="window.StrayingI18n.get('g05.l028a')"][l][r]
[emb exp="window.StrayingI18n.get('g05.l028b')"][p]

[chara_show name="child"]

[emb exp="window.StrayingI18n.get('g05.l029')"][p]

[emb exp="window.StrayingI18n.get('g05.l030a')"][l][r]
[emb exp="window.StrayingI18n.get('g05.l030b')"][r]
[emb exp="window.StrayingI18n.get('g05.l030c')"][p]

[emb exp="window.StrayingI18n.get('g05.l031a')"][r]
[emb exp="window.StrayingI18n.get('g05.l031b')"][p]

[emb exp="window.StrayingI18n.get('g05.l032')"][p]

[emb exp="window.StrayingI18n.get('g05.l033')"][p]

[emb exp="window.StrayingI18n.get('g05.l034')"][p]

[emb exp="window.StrayingI18n.get('g05.l035a')"][r]
[emb exp="window.StrayingI18n.get('g05.l035b')"][p]

[emb exp="window.StrayingI18n.get('g05.l036a')"][r]
[emb exp="window.StrayingI18n.get('g05.l036b')"][p]

[fadeoutbgm time="1800"]

; ----------------------------------------------------------
; 選択場面5-3：まだ思い出せない？／なにか思い出した？
; ----------------------------------------------------------
[glink x=270 y=200 text="&window.StrayingI18n.get('g05.c005')" target="*memory_no" graphic="select_off.png" enterimg="select_on.png" width="600" height="50" size="32" ]
[glink x=270 y=320 text="&window.StrayingI18n.get('g05.c006')" target="*memory_yes" graphic="select_off.png" enterimg="select_on.png" width="600" height="50" size="32" ]

[s]

;---------
*memory_no
;---------
[cm]

[emb exp="window.StrayingI18n.get('g05.l037a')"][r]
[emb exp="window.StrayingI18n.get('g05.l037b')"][p]

[emb exp="window.StrayingI18n.get('g05.l038')"][p]

@jump target=*ask_hint

;---------
*memory_yes
;---------
[cm]

[emb exp="window.StrayingI18n.get('g05.l039a')"][r]
[emb exp="window.StrayingI18n.get('g05.l039b')"][p]

[emb exp="window.StrayingI18n.get('g05.l040')"][p]

@jump target=*ask_hint

;---------
*ask_hint
;---------
[cm]

[playbgm storage="bgm005.mp3" html5=true]
[emb exp="window.StrayingI18n.get('g05.l041')"][p]

[emb exp="window.StrayingI18n.get('g05.l042')"][p]

[emb exp="window.StrayingI18n.get('g05.l043a')"][r]
[emb exp="window.StrayingI18n.get('g05.l043b')"][p]

[emb exp="window.StrayingI18n.get('g05.l044a')"][r]
[emb exp="window.StrayingI18n.get('g05.l044b')"][p]

[emb exp="window.StrayingI18n.get('g05.l045')"][p]

[emb exp="window.StrayingI18n.get('g05.l046a')"][r]
[emb exp="window.StrayingI18n.get('g05.l046b')"][p]

[emb exp="window.StrayingI18n.get('g05.l047a')"][l][r]
[emb exp="window.StrayingI18n.get('g05.l047b')"][p]

[emb exp="window.StrayingI18n.get('g05.l048')"][p]

[emb exp="window.StrayingI18n.get('g00.l009')"][p]

[emb exp="window.StrayingI18n.get('g05.l049')"][p]

[emb exp="window.StrayingI18n.get('g05.l050a').replace('{value}', function () { return sf.player_name; })"][l][r]
[emb exp="window.StrayingI18n.get('g05.l050b').replace('{value}', function () { return sf.player_name; })"][p]

[emb exp="window.StrayingI18n.get('g05.l051')"][p]

[emb exp="window.StrayingI18n.get('g05.l052a')"][r]
[emb exp="window.StrayingI18n.get('g05.l052b')"][p]

[emb exp="window.StrayingI18n.get('g05.l053')"][p]

[emb exp="window.StrayingI18n.get('g05.l054a')"][r]
[emb exp="window.StrayingI18n.get('g05.l054b')"][p]

[emb exp="window.StrayingI18n.get('g05.l055a')"][l][r]
[emb exp="window.StrayingI18n.get('g05.l055b')"][p]

; ----------------------------------------------------------
; 選択場面5-4：ポケットの中身（お金／学生証／スマホ）
; Q005
; ----------------------------------------------------------
[iscript]
f.selPocket1 = window.StrayingI18n.get('g05.c007')
f.selPocket2 = window.StrayingI18n.get('g05.c008')
f.selPocket3 = window.StrayingI18n.get('g05.c009')
f.button1 = 0
f.button2 = 0
f.button3 = 0
[endscript]

;画面中央に3つ並べて表示（この後、選んだ分だけ*after_pocket_checkで中央揃えし直す）
[glink x=416 y=206 text="&f.selPocket1" target="*pocket_money" graphic="select_off.png" enterimg="select_on.png" width="320" height="44" size="32" ]
[glink x=416 y=306 text="&f.selPocket2" target="*pocket_id" graphic="select_off.png" enterimg="select_on.png" width="320" height="44" size="32" ]
[glink x=416 y=406 text="&f.selPocket3" target="*pocket_phone" graphic="select_off.png" enterimg="select_on.png" width="320" height="44" size="32" ]

[s]

;---------
*pocket_money
;---------
[cm]

[eval exp="window.RNF.recordChoice(window.RNF.getProjectConfig().ANSWERS.Q005.QUESTION_ID,window.RNF.getProjectConfig().ANSWERS.Q005.CHOICES.C01,'Money')"]

[eval exp="f.button1=1"]

[emb exp="window.StrayingI18n.get('g05.l056')"][p]

[emb exp="window.StrayingI18n.get('g05.l057')"][p]

[emb exp="window.StrayingI18n.get('g05.l058a')"][l][r]
[emb exp="window.StrayingI18n.get('g05.l058b')"][p]

@jump target=*after_pocket_check


;---------
*pocket_id
;---------
[cm]

[eval exp="window.RNF.recordChoice(window.RNF.getProjectConfig().ANSWERS.Q005.QUESTION_ID,window.RNF.getProjectConfig().ANSWERS.Q005.CHOICES.C02,'Student ID')"]

[eval exp="f.button2=1"]

[emb exp="window.StrayingI18n.get('g05.l059a')"][r]
[emb exp="window.StrayingI18n.get('g05.l059b')"][p]

[emb exp="window.StrayingI18n.get('g05.l060')"][p]

[emb exp="window.StrayingI18n.get('g05.l061')"][p]

@jump target=*after_pocket_check


;---------
*pocket_phone
;---------
[cm]

[eval exp="window.RNF.recordChoice(window.RNF.getProjectConfig().ANSWERS.Q005.QUESTION_ID,window.RNF.getProjectConfig().ANSWERS.Q005.CHOICES.C03,'Smartphone')"]

[eval exp="f.button3=1"]

[emb exp="window.StrayingI18n.get('g05.l062a')"][r]
[emb exp="window.StrayingI18n.get('g05.l062b')"][p]

[emb exp="window.StrayingI18n.get('g05.l063')"][p]

[emb exp="window.StrayingI18n.get('g05.l061')"][p]

@jump target=*after_pocket_check

;---------
*after_pocket_check
;---------
[cm]

; 3択すべて選ぶまで繰り返す
; 残りの選択肢を常に画面中央へ再配置する
[if exp="f.button1==0 || f.button2==0 || f.button3==0"]

[iscript]

// Refresh display text for the current language.
f.selPocket1 = window.StrayingI18n.get('g05.c007');
f.selPocket2 = window.StrayingI18n.get('g05.c008');
f.selPocket3 = window.StrayingI18n.get('g05.c009');
// End display text refresh.

var pocket_remaining = [];

if (f.button1 == 0) pocket_remaining.push("money");
if (f.button2 == 0) pocket_remaining.push("id");
if (f.button3 == 0) pocket_remaining.push("phone");

; 見た目上の画面中央
var pocket_centerY = 360;

; ボタン同士の中心間隔
var pocket_gap = 100;

; CSSのpadding込みで見た目の高さは約108px
; glinkのyはボタン外枠の上端なので、その半分を引く
var pocket_visual_half = 54;

var pocket_startCenterY =
    pocket_centerY -
    (pocket_remaining.length - 1) * pocket_gap / 2;

var pocket_posMap = {};

for (var pi = 0; pi < pocket_remaining.length; pi++) {

    var centerY =
        pocket_startCenterY +
        pi * pocket_gap;

    pocket_posMap[pocket_remaining[pi]] =
        Math.round(centerY - pocket_visual_half);
}

f.pos_y_money = pocket_posMap.money;
f.pos_y_id = pocket_posMap.id;
f.pos_y_phone = pocket_posMap.phone;

[endscript]


[if exp="f.button1==0"]
[glink x=416 y="&f.pos_y_money" text="&f.selPocket1" target="*pocket_money" graphic="select_off.png" enterimg="select_on.png" width="320" height="44" size="32" ]
[endif]

[if exp="f.button2==0"]
[glink x=416 y="&f.pos_y_id" text="&f.selPocket2" target="*pocket_id" graphic="select_off.png" enterimg="select_on.png" width="320" height="44" size="32" ]
[endif]

[if exp="f.button3==0"]
[glink x=416 y="&f.pos_y_phone" text="&f.selPocket3" target="*pocket_phone" graphic="select_off.png" enterimg="select_on.png" width="320" height="44" size="32" ]
[endif]

[s]

[endif]

@jump target=*after_pocket

;---------
*after_pocket
;---------
[cm]

[emb exp="window.StrayingI18n.get('g05.l064')"][p]

[emb exp="window.StrayingI18n.get('g05.l065a')"][l][r]
[emb exp="window.StrayingI18n.get('g05.l065b')"][p]

[emb exp="window.StrayingI18n.get('g05.l066a')"][l][r]
[emb exp="window.StrayingI18n.get('g05.l066b')"][p]

[emb exp="window.StrayingI18n.get('g05.l067a')"][l][r]
[emb exp="window.StrayingI18n.get('g05.l067b')"][p]

[emb exp="window.StrayingI18n.get('g05.l068a')"][l][r]
[emb exp="window.StrayingI18n.get('g05.l068b')"][p]

[emb exp="window.StrayingI18n.get('g05.l069')"][p]

[emb exp="window.StrayingI18n.get('g05.l070a')"][l][r]
[emb exp="window.StrayingI18n.get('g05.l070b')"][p]

[emb exp="window.StrayingI18n.get('g05.l071a')"][l][r]
[emb exp="window.StrayingI18n.get('g05.l071b')"][p]

[emb exp="window.StrayingI18n.get('g05.l072a')"][l][r]
[emb exp="window.StrayingI18n.get('g05.l072b')"][p]

[emb exp="window.StrayingI18n.get('g05.l073a')"][l][r]
[emb exp="window.StrayingI18n.get('g05.l073b')"][p]

[emb exp="window.StrayingI18n.get('g05.l074a')"][l][r]
[emb exp="window.StrayingI18n.get('g05.l074b')"][r]
[emb exp="window.StrayingI18n.get('g05.l074c')"][p]

[emb exp="window.StrayingI18n.get('g05.l075')"][p]

[emb exp="window.StrayingI18n.get('g05.l076a')"][l][r]
[emb exp="window.StrayingI18n.get('g05.l076b')"][p]

; ----------------------------------------------------------
; 選択場面5-5：一緒に考えよう／思いつかない
; Q006
; ----------------------------------------------------------
[glink x=270 y=200 text="&window.StrayingI18n.get('g05.c010')" target="*think_together" graphic="select_off.png" enterimg="select_on.png" width="600" height="50" size="32" ]
[glink x=270 y=320 text="&window.StrayingI18n.get('g05.c011')" target="*cant_think" graphic="select_off.png" enterimg="select_on.png" width="600" height="50" size="32" ]

[s]

;---------
*think_together
;---------
[cm]

[eval exp="window.RNF.recordChoice(window.RNF.getProjectConfig().ANSWERS.Q006.QUESTION_ID,window.RNF.getProjectConfig().ANSWERS.Q006.CHOICES.C01,'Think together')"]

[emb exp="window.StrayingI18n.get('g05.l077')"][p]

[emb exp="window.StrayingI18n.get('g05.l078')"][p]

[emb exp="window.StrayingI18n.get('g05.l079')"][p]

@jump target=*floating_words


;---------
*cant_think
;---------
[cm]

[eval exp="window.RNF.recordChoice(window.RNF.getProjectConfig().ANSWERS.Q006.QUESTION_ID,window.RNF.getProjectConfig().ANSWERS.Q006.CHOICES.C02,'Cannot think of anything')"]

[emb exp="window.StrayingI18n.get('g05.l080')"][p]

[emb exp="window.StrayingI18n.get('g05.l081')"][p]

[emb exp="window.StrayingI18n.get('g05.l082a')"][l][r]
[emb exp="window.StrayingI18n.get('g05.l082b')"][p]

@jump target=*floating_words

;---------
*floating_words
;---------
[cm]

[emb exp="window.StrayingI18n.get('g05.l083')"][p]

[emb exp="window.StrayingI18n.get('g05.l084a')"][r]
[emb exp="window.StrayingI18n.get('g05.l084b')"][p]

[chara_hide name="child"]

; ----------------------------------------------------------
; 演出：候補の言葉がふわっと浮かぶ
; ----------------------------------------------------------

[iscript]
(function () {

    $('.straying-floating-words').remove();

    var $wrap = $('<div class="straying-floating-words"></div>');

    $wrap.css({
        position: 'absolute',
        left: '0px',
        top: '0px',
        width: '1280px',
        height: '720px',
        pointerEvents: 'none',
        zIndex: 9999
    });

    $('.layer_fore:visible').last().append($wrap);

    function makeWord(text, left, top, delay) {

    var $word = $('<div></div>');
    var $text = $('<span></span>');
    var $glow = $('<div></div>');

    $text.text(text);

    $word.css({
        position: 'absolute',
        left: left + 'px',
        top: top + 'px',

        width: '320px',
        height: '60px',

        textAlign: 'center',
        lineHeight: '60px',

        opacity: 0
    });

    $glow.css({
        position: 'absolute',
        left: '20px',
        top: '10px',

        width: '280px',
        height: '40px',

        borderRadius: '50%',

        background:
            'radial-gradient(ellipse at center, ' +
            'rgba(225, 240, 248, 0.20) 0%, ' +
            'rgba(195, 222, 235, 0.10) 45%, ' +
            'rgba(160, 200, 220, 0.00) 75%)',

        filter: 'blur(10px)',

        pointerEvents: 'none',
        zIndex: '0'
    });

    $text.css({
        position: 'relative',
        zIndex: '1',

        fontFamily: '"Straying Sans", sans-serif',
        fontSize: '28px',
        fontWeight: '400',

        color: 'rgba(250, 252, 255, 0.97)',

        textShadow:
            '0 0 6px rgba(255, 255, 255, 0.65), ' +
            '0 0 14px rgba(225, 240, 248, 0.45), ' +
            '0 0 28px rgba(190, 220, 235, 0.30)'
    });

    $word.append($glow);
    $word.append($text);

    $wrap.append($word);

    setTimeout(function () {

        $word.animate(
            {
                opacity: 0.85,
                top: (top - 12) + 'px'
            },
            1800
        );

    }, delay);
}

    // 1つずつ、ゆっくり間を空けて表示
    makeWord(window.StrayingI18n.get('g05.c012'),      120, 110,    0);
    makeWord(window.StrayingI18n.get('g05.c013'),      480,  90, 1200);
    makeWord(window.StrayingI18n.get('g05.c014'),          820, 140, 2400);
    makeWord(window.StrayingI18n.get('g05.c015'),          180, 300, 3600);
    makeWord(window.StrayingI18n.get('g05.c016'),          540, 320, 4800);
    makeWord(window.StrayingI18n.get('g05.c017'),  860, 280, 6000);

})();
[endscript]

; 最後の言葉が完全に出るまで待つ
[wait time=8000]

; 6つを眺める時間
[wait time=2500]

; プレイヤーが確認してから次へ
[p]

[emb exp="window.StrayingI18n.get('g05.l085a')"][l][r]
[emb exp="window.StrayingI18n.get('g05.l085b')"][p]

[emb exp="window.StrayingI18n.get('g05.l086a')"][l][r]
[emb exp="window.StrayingI18n.get('g05.l086b')"][p]

[emb exp="window.StrayingI18n.get('g05.l087a')"][l][r]
[emb exp="window.StrayingI18n.get('g05.l087b')"][p]

[emb exp="window.StrayingI18n.get('g05.l088')"][p]

[emb exp="window.StrayingI18n.get('g05.l089a').replace('{value}', function () { return sf.player_name; })"][l][r]
[emb exp="window.StrayingI18n.get('g05.l089b').replace('{value}', function () { return sf.player_name; })"][r]
[emb exp="window.StrayingI18n.get('g05.l089c').replace('{value}', function () { return sf.player_name; })"][p]

[emb exp="window.StrayingI18n.get('g05.l090a')"][l][r]
[emb exp="window.StrayingI18n.get('g05.l090b')"][p]

[emb exp="window.StrayingI18n.get('g05.l091a')"][l][r]
[emb exp="window.StrayingI18n.get('g05.l091b')"][r]
[emb exp="window.StrayingI18n.get('g05.l091c')"][p]

[emb exp="window.StrayingI18n.get('g05.l092')"][p]

; 候補語演出を選択肢表示前に消す
[iscript]
$('.straying-floating-words').fadeOut(700, function () {
    $(this).remove();
});
[endscript]

[wait time=700]

; ----------------------------------------------------------
; 選択場面5-6：ある／多分ある
; ----------------------------------------------------------
[glink x=270 y=200 text="&window.StrayingI18n.get('g05.c018')" target="*there_is" graphic="select_off.png" enterimg="select_on.png" width="600" height="50" size="32" ]
[glink x=270 y=320 text="&window.StrayingI18n.get('g05.c019')" target="*maybe_is" graphic="select_off.png" enterimg="select_on.png" width="600" height="50" size="32" ]

[s]

;---------
*there_is
;---------
[cm]

[emb exp="window.StrayingI18n.get('g05.l093')"][p]

[emb exp="window.StrayingI18n.get('g05.l094')"][p]

[emb exp="window.StrayingI18n.get('g05.l095a')"][l][r]
[emb exp="window.StrayingI18n.get('g05.l095b')"][p]

[emb exp="window.StrayingI18n.get('g05.l096a').replace('{value}', function () { return sf.player_name; })"][l][r]
[emb exp="window.StrayingI18n.get('g05.l096b').replace('{value}', function () { return sf.player_name; })"][r]
[emb exp="window.StrayingI18n.get('g05.l096c').replace('{value}', function () { return sf.player_name; })"][p]

[emb exp="window.StrayingI18n.get('g05.l097a')"][l][r]
[emb exp="window.StrayingI18n.get('g05.l097b')"][p]

@jump target=*treasure_category

;---------
*maybe_is
;---------
[cm]

[emb exp="window.StrayingI18n.get('g05.l098')"][p]

[emb exp="window.StrayingI18n.get('g05.l099')"][p]

[emb exp="window.StrayingI18n.get('g05.l095a')"][l][r]
[emb exp="window.StrayingI18n.get('g05.l100b')"][p]

[emb exp="window.StrayingI18n.get('g05.l101a')"][l][r]
[emb exp="window.StrayingI18n.get('g05.l101b')"][p]

; ----------------------------------------------------------
; 選択場面5-7：ある気がしてきた（強制）
; ----------------------------------------------------------
[glink x=270 y=250 text="&window.StrayingI18n.get('g05.c020')" target="*there_is_now" graphic="select_off.png" enterimg="select_on.png" width="600" height="50" size="32" ]

[s]

;---------
*there_is_now
;---------
[cm]

[emb exp="window.StrayingI18n.get('g05.l102')"][p]

[emb exp="window.StrayingI18n.get('g05.l094')"][p]

[emb exp="window.StrayingI18n.get('g05.l095a')"][l][r]
[emb exp="window.StrayingI18n.get('g05.l095b')"][p]

[emb exp="window.StrayingI18n.get('g05.l096a').replace('{value}', function () { return sf.player_name; })"][l][r]
[emb exp="window.StrayingI18n.get('g05.l096b').replace('{value}', function () { return sf.player_name; })"][r]
[emb exp="window.StrayingI18n.get('g05.l096c').replace('{value}', function () { return sf.player_name; })"][p]

[emb exp="window.StrayingI18n.get('g05.l097a')"][l][r]
[emb exp="window.StrayingI18n.get('g05.l097b')"][p]

@jump target=*treasure_category

; ============================================================
; 6. 「大切なもの」カテゴリ選択＋自由記述（最大3回）
; ============================================================
*treasure_category
[autosave]
[cm]

[iscript]
f.selCat1 = window.StrayingI18n.get('g05.c012')
f.selCat2 = window.StrayingI18n.get('g05.c013')
f.selCat3 = window.StrayingI18n.get('g05.c014')
f.selCat4 = window.StrayingI18n.get('g05.c015')
f.selCat5 = window.StrayingI18n.get('g05.c016')
f.selCat6 = window.StrayingI18n.get('g05.c017')
[endscript]

[emb exp="window.StrayingI18n.get('g06.l001a')"][r]
[emb exp="window.StrayingI18n.get('g06.l001b')"][p]

; ----------------------------------------------------------
; 大切なもの：6つの言葉をそのまま選択肢にする
; ----------------------------------------------------------

[iscript]
// Refresh display text for the current language.
f.selCat1 = window.StrayingI18n.get('g05.c012');
f.selCat2 = window.StrayingI18n.get('g05.c013');
f.selCat3 = window.StrayingI18n.get('g05.c014');
f.selCat4 = window.StrayingI18n.get('g05.c015');
f.selCat5 = window.StrayingI18n.get('g05.c016');
f.selCat6 = window.StrayingI18n.get('g05.c017');
// End display text refresh.

(function () {

    $('.straying-treasure-choices').remove();

    var $wrap = $('<div class="straying-treasure-choices"></div>');

    $wrap.css({
        position: 'absolute',
        left: '0px',
        top: '0px',
        width: '1280px',
        height: '720px',
        pointerEvents: 'none',
        zIndex: 9999
    });

    $('.layer_fore:visible').last().append($wrap);

    var choiceLocked = false;


    function makeChoice(text, target, left, top, delay) {

        var $choice = $('<div></div>');
        var $text = $('<span></span>');
        var $glow = $('<div></div>');

        $text.text(text);


        /* 選択肢全体 */
        $choice.css({
            position: 'absolute',

            left: left + 'px',
            top: (top + 8) + 'px',

            width: '320px',
            height: '60px',

            textAlign: 'center',
            lineHeight: '60px',

            cursor: 'pointer',
            pointerEvents: 'auto',
            userSelect: 'none',

            opacity: 0
        });


        /* 文字の後ろの淡い光 */
        $glow.css({
            position: 'absolute',

            left: '20px',
            top: '10px',

            width: '280px',
            height: '40px',

            borderRadius: '50%',

            background:
                'radial-gradient(ellipse at center, ' +
                'rgba(225,240,248,0.12) 0%, ' +
                'rgba(195,222,235,0.06) 45%, ' +
                'rgba(160,200,220,0.00) 75%)',

            filter: 'blur(10px)',

            pointerEvents: 'none'
        });


        /* 通常時の文字 */
        $text.css({
            position: 'relative',
            zIndex: '1',

            fontFamily: '"Straying Sans", sans-serif',
            fontSize: '28px',
            fontWeight: '400',

            color: 'rgba(245,248,250,0.90)',

            textShadow:
                '0 0 6px rgba(255,255,255,0.35), ' +
                '0 0 14px rgba(220,235,245,0.20)',

            /* 「選べる」ことを示す薄い下線 */
            borderBottom:
                '1px solid rgba(230,240,245,0.16)',

            paddingBottom: '4px'
        });


        $choice.append($glow);
        $choice.append($text);

        $wrap.append($choice);


        /* 少しずつ出現 */
        setTimeout(function () {

            $choice.animate(
                {
                    opacity: 1,
                    top: top + 'px'
                },
                600
            );

        }, delay);


        /* --------------------------------
           ホバー時
        -------------------------------- */
        $choice.on('mouseenter', function () {

            $glow.css({
                background:
                    'radial-gradient(ellipse at center, ' +
                    'rgba(235,247,252,0.28) 0%, ' +
                    'rgba(205,230,240,0.14) 45%, ' +
                    'rgba(170,205,220,0.00) 78%)'
            });


            $text.css({

                color: 'rgba(255,255,255,1)',

                borderBottom:
                    '1px solid rgba(240,250,255,0.55)',

                textShadow:
                    '0 0 6px rgba(255,255,255,0.65), ' +
                    '0 0 16px rgba(220,240,248,0.42), ' +
                    '0 0 28px rgba(190,220,235,0.22)'
            });

        });


        /* --------------------------------
           ホバー解除
        -------------------------------- */
        $choice.on('mouseleave', function () {

            $glow.css({
                background:
                    'radial-gradient(ellipse at center, ' +
                    'rgba(225,240,248,0.12) 0%, ' +
                    'rgba(195,222,235,0.06) 45%, ' +
                    'rgba(160,200,220,0.00) 75%)'
            });


            $text.css({

                color: 'rgba(245,248,250,0.90)',

                borderBottom:
                    '1px solid rgba(230,240,245,0.16)',

                textShadow:
                    '0 0 6px rgba(255,255,255,0.35), ' +
                    '0 0 14px rgba(220,235,245,0.20)'
            });

        });


        /* --------------------------------
           選択時
        -------------------------------- */
        $choice.on('click', function () {

            if (choiceLocked) return;

            choiceLocked = true;


            $('.straying-treasure-choices').fadeOut(
                300,
                function () {

                    $(this).remove();

                    TYRANO.kag.ftag.startTag(
                        'jump',
                        {
                            target: target
                        }
                    );

                }
            );

        });

    }


    /* 6つの選択肢 */

    makeChoice(
        f.selCat1,
        '*cat_person',
        120,
        98,
        0
    );

    makeChoice(
        f.selCat2,
        '*cat_gift',
        480,
        78,
        180
    );

    makeChoice(
        f.selCat3,
        '*cat_words',
        820,
        128,
        360
    );

    makeChoice(
        f.selCat4,
        '*cat_treasure',
        180,
        288,
        540
    );

    makeChoice(
        f.selCat5,
        '*cat_goal',
        540,
        308,
        720
    );

    makeChoice(
        f.selCat6,
        '*cat_place',
        860,
        268,
        900
    );

})();
[endscript]

[s]

;---------
*cat_person
;---------
[cm]
[if exp="f.used_person == 0"]
[emb exp="window.StrayingI18n.get('g06.l002a')"][l][r]
[emb exp="window.StrayingI18n.get('g06.l002b')"][p]

[emb exp="window.StrayingI18n.get('g06.l003a').replace('{value}', function () { return sf.player_name; })"][r]
[emb exp="window.StrayingI18n.get('g06.l003b').replace('{value}', function () { return sf.player_name; })"][p]

[emb exp="window.StrayingI18n.get('g06.l004')"][p]

[emb exp="window.StrayingI18n.get('g06.l005a')"][r]
[emb exp="window.StrayingI18n.get('g06.l005b')"][r]
[emb exp="window.StrayingI18n.get('g06.l005c')"][p]

[else]
;2回目以降に同じカテゴリを選んだ場合の反応（新規に書き起こし）
[emb exp="window.StrayingI18n.get('g06.l006a')"][r]
[emb exp="window.StrayingI18n.get('g06.l006b')"][p]

[emb exp="window.StrayingI18n.get('g06.l007a')"][l][r]
[emb exp="window.StrayingI18n.get('g06.l007b')"][p]
[endif]
[eval exp="f.used_person = 1"]
[eval exp='if (f.first_category == "") f.first_category = "person";']
@jump target=*treasure_freewrite

;---------
*cat_gift
;---------
[cm]
[if exp="f.used_gift == 0"]
[emb exp="window.StrayingI18n.get('g06.l008a')"][l][r]
[emb exp="window.StrayingI18n.get('g06.l008b')"][p]

[emb exp="window.StrayingI18n.get('g06.l009a')"][r]
[emb exp="window.StrayingI18n.get('g06.l009b')"][p]

[emb exp="window.StrayingI18n.get('g06.l010')"][p]

[emb exp="window.StrayingI18n.get('g06.l011a')"][r]
[emb exp="window.StrayingI18n.get('g06.l011b')"][p]

[else]
[emb exp="window.StrayingI18n.get('g06.l012a')"][r]
[emb exp="window.StrayingI18n.get('g06.l012b')"][p]

[emb exp="window.StrayingI18n.get('g06.l013a')"][l][r]
[emb exp="window.StrayingI18n.get('g06.l013b')"][p]
[endif]
[eval exp="f.used_gift = 1"]
[eval exp='if (f.first_category == "") f.first_category = "gift";']
@jump target=*treasure_freewrite

;---------
*cat_words
;---------
[cm]
[if exp="f.used_words == 0"]
[emb exp="window.StrayingI18n.get('g06.l014a')"][l][r]
[emb exp="window.StrayingI18n.get('g06.l014b')"][p]

[emb exp="window.StrayingI18n.get('g06.l015a')"][r]
[emb exp="window.StrayingI18n.get('g06.l015b')"][r]
[emb exp="window.StrayingI18n.get('g06.l015c')"][p]

[emb exp="window.StrayingI18n.get('g06.l016')"][p]

[emb exp="window.StrayingI18n.get('g06.l017a')"][r]
[emb exp="window.StrayingI18n.get('g06.l017b')"][p]

[else]
[emb exp="window.StrayingI18n.get('g06.l018a')"][r]
[emb exp="window.StrayingI18n.get('g06.l018b')"][p]

[emb exp="window.StrayingI18n.get('g06.l019a')"][l][r]
[emb exp="window.StrayingI18n.get('g06.l019b')"][p]
[endif]
[eval exp="f.used_words = 1"]
[eval exp='if (f.first_category == "") f.first_category = "words";']
@jump target=*treasure_freewrite

;---------
*cat_treasure
;---------
[cm]
[if exp="f.used_treasure == 0"]
[emb exp="window.StrayingI18n.get('g06.l020a')"][l][r]
[emb exp="window.StrayingI18n.get('g06.l020b')"][p]

[emb exp="window.StrayingI18n.get('g06.l021a')"][r]
[emb exp="window.StrayingI18n.get('g06.l021b')"][p]

[emb exp="window.StrayingI18n.get('g06.l010')"][p]

[emb exp="window.StrayingI18n.get('g06.l022a')"][r]
[emb exp="window.StrayingI18n.get('g06.l022b')"][r]
[emb exp="window.StrayingI18n.get('g06.l022c')"][p]
[else]
[emb exp="window.StrayingI18n.get('g06.l012a')"][r]
[emb exp="window.StrayingI18n.get('g06.l023b')"][p]

[emb exp="window.StrayingI18n.get('g06.l013a')"][l][r]
[emb exp="window.StrayingI18n.get('g06.l024b')"][p]
[endif]
[eval exp="f.used_treasure = 1"]
[eval exp='if (f.first_category == "") f.first_category = "treasure";']
@jump target=*treasure_freewrite

;---------
*cat_goal
;---------
[cm]
[if exp="f.used_goal == 0"]
[emb exp="window.StrayingI18n.get('g06.l025a')"][l][r]
[emb exp="window.StrayingI18n.get('g06.l025b')"][p]

[emb exp="window.StrayingI18n.get('g06.l026a')"][r]
[emb exp="window.StrayingI18n.get('g06.l026b')"][r]
[emb exp="window.StrayingI18n.get('g06.l026c')"][p]

[emb exp="window.StrayingI18n.get('g06.l027')"][p]

[emb exp="window.StrayingI18n.get('g06.l028a')"][r]
[emb exp="window.StrayingI18n.get('g06.l028b')"][r]
[emb exp="window.StrayingI18n.get('g06.l028c')"][p]

[else]
[emb exp="window.StrayingI18n.get('g06.l012a')"][r]
[emb exp="window.StrayingI18n.get('g06.l029b')"][p]

[emb exp="window.StrayingI18n.get('g06.l013a')"][l][r]
[emb exp="window.StrayingI18n.get('g06.l030b')"][p]
[endif]
[eval exp="f.used_goal = 1"]
[eval exp='if (f.first_category == "") f.first_category = "goal";']
@jump target=*treasure_freewrite

;---------
*cat_place
;---------
[cm]
[if exp="f.used_place == 0"]
[emb exp="window.StrayingI18n.get('g06.l031a')"][l][r]
[emb exp="window.StrayingI18n.get('g06.l031b')"][p]

[emb exp="window.StrayingI18n.get('g06.l032a')"][r]
[emb exp="window.StrayingI18n.get('g06.l032b')"][p]

[emb exp="window.StrayingI18n.get('g06.l033')"][p]

[emb exp="window.StrayingI18n.get('g06.l034a')"][r]
[emb exp="window.StrayingI18n.get('g06.l034b')"][p]

[else]
[emb exp="window.StrayingI18n.get('g06.l012a')"][r]
[emb exp="window.StrayingI18n.get('g06.l035b')"][p]

[emb exp="window.StrayingI18n.get('g06.l013a')"][l][r]
[emb exp="window.StrayingI18n.get('g06.l036b')"][p]
[endif]
[eval exp="f.used_place = 1"]
[eval exp='if (f.first_category == "") f.first_category = "place";']
@jump target=*treasure_freewrite

; ----------------------------------------------------------
; 自由記述パート
; ----------------------------------------------------------
*treasure_freewrite
[cm]

[if exp="f.treasure_round == 0"]

[emb exp="window.StrayingI18n.get('g06.l037a')"][r]
[emb exp="window.StrayingI18n.get('g06.l037b')"][p]

[emb exp="window.StrayingI18n.get('g06.l038a')"][r]
[emb exp="window.StrayingI18n.get('g06.l038b')"][p]

[emb exp="window.StrayingI18n.get('g06.l039a')"][l][r]
[emb exp="window.StrayingI18n.get('g06.l039b')"][p]

[endif]

[iscript]
f.treasureInput = window.StrayingI18n.get('g06.ui001')
[endscript]

*treasure_input_label
[label name="treasure_input_label"]

; 再入力時に古いOKボタンが残らないよう削除
[iscript]
$('.straying-treasure-ok-button').remove();
[endscript]

; 自由記入欄
; 最大60文字
[edit name="sf.player_treasure" width="700" height="50" size="26" left=290 top=280 maxchars=60]

[iscript]
(function () {

    var $editBox = $('input[name="sf.player_treasure"]');

    var placeholder =
    window.StrayingI18n.get("treasurePlaceholder");

    $editBox.val('');

    $editBox.attr(
        'placeholder',
        placeholder
    );

    $editBox.css({
        color: '#000',
        boxSizing: 'border-box'
    });

})();
[endscript]


; ----------------------------------------------------------
; OKボタン
; ----------------------------------------------------------
[iscript]
(function () {

    $('.straying-treasure-ok-button').remove();

    var $btn = $('<div class="straying-treasure-ok-button">OK</div>');

    $btn.css({
        position: 'absolute',

        left: '540px',
        top: '368px',

        width: '200px',
        height: '50px',

        backgroundImage: 'url("./data/image/button/modalselect_off.png")',
        backgroundSize: '100% 100%',
        backgroundRepeat: 'no-repeat',

        fontFamily: '"Straying Sans", sans-serif',
        fontSize: '28px',
        fontWeight: '400',
        color: '#fff',

        textAlign: 'center',
        lineHeight: '50px',

        cursor: 'pointer',
        userSelect: 'none',

        zIndex: 999
    });

    $btn.on('mouseenter', function () {
        $(this).css(
            'background-image',
            'url("./data/image/button/modalselect_on.png")'
        );
    });

    $btn.on('mouseleave', function () {
        $(this).css(
            'background-image',
            'url("./data/image/button/modalselect_off.png")'
        );
    });

    $btn.on('click', function () {

        $('.straying-treasure-ok-button').remove();

        TYRANO.kag.ftag.startTag('jump', {
            target: '*check_treasure'
        });

    });

    $('.layer_free').append($btn);

})();
[endscript]

[s]

*check_treasure
[commit]

[iscript]
$('.straying-treasure-ok-button').remove();

var treasureText = (sf.player_treasure || "").trim();

if (!Array.isArray(sf.treasures)) {
    sf.treasures = [];
}

sf.treasures.push(treasureText);
f.treasure_round = sf.treasures.length;

/*
 * 自由記入を入力順にRNFへ保存
 * 1回目 → I001_1
 * 2回目 → I001_2
 * 3回目 → I001_3
 */
var inputKey = "I001_" + f.treasure_round;
var answersConfig = window.RNF.getProjectConfig().ANSWERS;

if (answersConfig[inputKey]) {
    window.RNF.recordTextInput(
        answersConfig[inputKey].INPUT_ID,
        treasureText
    );
}
[endscript]

[cm]

[chara_show face="walk" name="child"]

[emb exp="window.StrayingI18n.get('g06.l041a').replace('{value}', function () { return sf.player_treasure; })"][r]
[emb exp="window.StrayingI18n.get('g06.l041b')"][p]

[emb exp="window.StrayingI18n.get('g06.l042')"][p]

[emb exp="window.StrayingI18n.get('g06.l043')"][p]

; ==========================================================
; 世界の変化は初回回答時だけ
; ==========================================================

[if exp="f.treasure_round == 1"]

[emb exp="window.StrayingI18n.get('g06.l044a')"][r]
[emb exp="window.StrayingI18n.get('g06.l044b')"][p]

; g06.l045直前で子どもを消す
[chara_hide name="child"]

[fadeoutbgm time="1800"]


;要素材：夜霧の森
[bg storage="bg001b.jpg" time="2000"]

[iscript]
$('.layer_fore')
    .filter(function(){
        return this.className.indexOf('2_fore') !== -1;
    })
    .animate({
        opacity: 170/255
    }, 4000);
[endscript]




[playbgm storage="bgm006.mp3" html5=true]

[emb exp="window.StrayingI18n.get('g06.l045')"][p]

[emb exp="window.StrayingI18n.get('g06.l046a')"][r]
[emb exp="window.StrayingI18n.get('g06.l046b')"][p]

[emb exp="window.StrayingI18n.get('g06.l047a')"][r]
[emb exp="window.StrayingI18n.get('g06.l047b')"][p]

[endif]


; ==========================================================
; 3回答えたら終了
; ==========================================================

[if exp="f.treasure_round >= 3"]

[iscript]
f.treasure_end_reason = "max";
[endscript]

@jump target=*treasure_finish

[endif]

; ==========================================================
; 1回目・2回目だけ継続確認
; ==========================================================

[emb exp="window.StrayingI18n.get('g06.l048a').replace('{value}', function () { return sf.player_name; })"][l][r]
[emb exp="window.StrayingI18n.get('g06.l048b').replace('{value}', function () { return sf.player_name; })"][r]
[emb exp="window.StrayingI18n.get('g06.l048c').replace('{value}', function () { return sf.player_name; })"][p]

[iscript]
f.selMore1 = window.StrayingI18n.get('g06.c001')
f.selMore2 = window.StrayingI18n.get('g06.c002')
[endscript]

[glink x=270 y=250 text="&f.selMore1" target="*treasure_category" graphic="select_off.png" enterimg="select_on.png" width="600" height="50" size="32"]

[glink x=270 y=350 text="&f.selMore2" target="*treasure_no_more" graphic="select_off.png" enterimg="select_on.png" width="600" height="50" size="32"]

[s]


; ==========================================================
; 「もう思いつかない」を選んだ場合
; ==========================================================

*treasure_no_more

[iscript]
f.treasure_end_reason = "no_more";
[endscript]

@jump target=*treasure_finish


; ==========================================================
; 自由記述終了
; ==========================================================

*treasure_finish
[cm]

; 自由記述終了時は分岐に関係なく子どもを消す
[chara_hide name="child"]

[if exp="f.treasure_end_reason == 'no_more'"]

[emb exp="window.StrayingI18n.get('g06.l049')"][p]

[emb exp="window.StrayingI18n.get('g06.l050')"][p]

[endif]

[fadeoutbgm time="1800"]

[emb exp="window.StrayingI18n.get('g06.l051a')"][l][r]
[emb exp="window.StrayingI18n.get('g06.l051b')"][p]

[emb exp="window.StrayingI18n.get('g06.l052a')"][l][r]
[emb exp="window.StrayingI18n.get('g06.l052b')"][r]
[emb exp="window.StrayingI18n.get('g06.l052c')"][p]

[emb exp="window.StrayingI18n.get('g06.l053a')"][l][r]
[emb exp="window.StrayingI18n.get('g06.l053b')"][r]
[emb exp="window.StrayingI18n.get('g06.l053c')"][p]

[emb exp="window.StrayingI18n.get('g06.l054')"][p]

[playbgm storage="bgm008.mp3" html5=true]

[emb exp="window.StrayingI18n.get('g06.l055')"][p]

; 子どもを再表示
[chara_show face="walk" name="child"]

[emb exp="window.StrayingI18n.get('g06.l056')"][p]

[emb exp="window.StrayingI18n.get('g06.l057a')"][l][r]
[emb exp="window.StrayingI18n.get('g06.l057b')"][r]
[emb exp="window.StrayingI18n.get('g06.l057c')"][p]

[emb exp="window.StrayingI18n.get('g06.l058')"][p]

[emb exp="window.StrayingI18n.get('g06.l059')"][p]

[emb exp="window.StrayingI18n.get('g06.l060a').replace('{value}', function () { return sf.player_name; })"][l][r]
[emb exp="window.StrayingI18n.get('g06.l060b').replace('{value}', function () { return sf.player_name; })"][p]

[emb exp="window.StrayingI18n.get('g06.l061')"][p]

; ============================================================
; 7. この場所が好き？
; ============================================================
*self_question
[autosave]
[cm]

;要素材：夜霧の森（さらに明るく、地面の草花がうっすら見え始める）
[bg storage="bg001c.jpg" time="2000"]

[iscript]
f.selSelf1 = window.StrayingI18n.get('g07.c001')
f.selSelf2 = window.StrayingI18n.get('g07.c002')
f.selSelf3 = window.StrayingI18n.get('g07.c003')
[endscript]

[glink x=270 y=200 text="&f.selSelf1" target="*self_like" graphic="select_off.png" enterimg="select_on.png" width="600" height="50" size="32" ]
[glink x=270 y=300 text="&f.selSelf2" target="*self_okay" graphic="select_off.png" enterimg="select_on.png" width="600" height="50" size="32" ]
[glink x=270 y=400 text="&f.selSelf3" target="*self_want" graphic="select_off.png" enterimg="select_on.png" width="600" height="50" size="32" ]

[s]

;---------
*self_like
;---------
[cm]

[eval exp="window.RNF.recordChoice(window.RNF.getProjectConfig().ANSWERS.Q007.QUESTION_ID,window.RNF.getProjectConfig().ANSWERS.Q007.CHOICES.C01,f.selSelf1)"]

[emb exp="window.StrayingI18n.get('g07.l001')"][p]

[emb exp="window.StrayingI18n.get('g03.l033')"][p]

[emb exp="window.StrayingI18n.get('g07.l002a')"][l][r]
[emb exp="window.StrayingI18n.get('g07.l002b')"][p]

[emb exp="window.StrayingI18n.get('g07.l003')"][p]

@jump target=*deepen

;---------
*self_okay
;---------
[cm]

[eval exp="window.RNF.recordChoice(window.RNF.getProjectConfig().ANSWERS.Q007.QUESTION_ID,window.RNF.getProjectConfig().ANSWERS.Q007.CHOICES.C02,f.selSelf2)"]

[emb exp="window.StrayingI18n.get('g07.l004')"][p]

[emb exp="window.StrayingI18n.get('g07.l005a')"][l][r]
[emb exp="window.StrayingI18n.get('g07.l005b')"][p]

[emb exp="window.StrayingI18n.get('g07.l006a')"][r]
[emb exp="window.StrayingI18n.get('g07.l006b')"][p]

@jump target=*deepen

;---------
*self_want
;---------
[cm]

[eval exp="window.RNF.recordChoice(window.RNF.getProjectConfig().ANSWERS.Q007.QUESTION_ID,window.RNF.getProjectConfig().ANSWERS.Q007.CHOICES.C03,f.selSelf3)"]

[emb exp="window.StrayingI18n.get('g07.l007')"][p]

[emb exp="window.StrayingI18n.get('g07.l008a')"][r]
[emb exp="window.StrayingI18n.get('g07.l008b')"][p]

[emb exp="window.StrayingI18n.get('g07.l005a')"][l][r]
[emb exp="window.StrayingI18n.get('g07.l009b')"][p]

[emb exp="window.StrayingI18n.get('g07.l010a')"][l][r]
[emb exp="window.StrayingI18n.get('g07.l010b')"][p]

@jump target=*deepen

; ============================================================
; 8. 深まる対話
; ============================================================
*deepen
[autosave]
[cm]

[emb exp="window.StrayingI18n.get('g08.l001a').replace('{value}', function () { return sf.player_name; })"][l][r]
[emb exp="window.StrayingI18n.get('g08.l001b').replace('{value}', function () { return sf.player_name; })"][r]
[emb exp="window.StrayingI18n.get('g08.l001c').replace('{value}', function () { return sf.player_name; })"][p]

[emb exp="window.StrayingI18n.get('g08.l002a')"][r]
[emb exp="window.StrayingI18n.get('g08.l002b')"][p]

[emb exp="window.StrayingI18n.get('g08.l003')"][p]

[emb exp="window.StrayingI18n.get('g08.l004a')"][l][r]
[emb exp="window.StrayingI18n.get('g08.l004b')"][p]

@jump target=*climax_elder

; ============================================================
; 9. クライマックス：老人との別れ
; ============================================================
*climax_elder
[autosave]
[cm]

[emb exp="window.StrayingI18n.get('g09.l001')"][p]

; 横になる描写に合わせて立ち絵を消す
[chara_hide name="child"]

[emb exp="window.StrayingI18n.get('g09.l002a')"][l][r]
[emb exp="window.StrayingI18n.get('g09.l002b')"][p]

[emb exp="window.StrayingI18n.get('g09.l003a')"][r]
[emb exp="window.StrayingI18n.get('g09.l003b')"][p]

[emb exp="window.StrayingI18n.get('g09.l004')"][p]

[emb exp="window.StrayingI18n.get('g09.l005')"][p]
[fadeoutbgm time="1800"]

[emb exp="window.StrayingI18n.get('g03.l008')"][p]

[emb exp="window.StrayingI18n.get('g09.l006a')"][l][r]
[emb exp="window.StrayingI18n.get('g09.l006b')"][p]

[playbgm storage="bgm006.mp3" html5=true]

[emb exp="window.StrayingI18n.get('g09.l007')"][p]

[emb exp="window.StrayingI18n.get('g09.l008a')"][l][r]
[emb exp="window.StrayingI18n.get('g09.l008b')"][p]

[emb exp="window.StrayingI18n.get('g09.l009a')"][l][r]
[emb exp="window.StrayingI18n.get('g09.l009b')"][r]
[emb exp="window.StrayingI18n.get('g09.l009c')"][p]

[emb exp="window.StrayingI18n.get('g09.l010a')"][l][r]
[emb exp="window.StrayingI18n.get('g09.l010b')"][p]

[emb exp="window.StrayingI18n.get('g09.l011a')"][r]
[emb exp="window.StrayingI18n.get('g09.l011b')"][p]

[emb exp="window.StrayingI18n.get('g09.l012')"][p]

; ----------------------------------------------------------
; これまで答えた「大切なもの」を、1つずつ[p]で見せる
; （画面での見え方を確認してから、見せ方を変える可能性あり）
; ----------------------------------------------------------
[emb exp="window.StrayingI18n.get('g09.l013a').replace('{value}', function () { return sf.treasures[0]; })"][r]
[emb exp="window.StrayingI18n.get('g09.l013b').replace('{value}', function () { return sf.treasures[0]; })"][r]
[emb exp="window.StrayingI18n.get('g09.l013c')"][p]

[if exp="sf.treasures.length >= 2"]
[emb exp="window.StrayingI18n.get('g09.l014a').replace('{value}', function () { return sf.treasures[1]; })"][r]
[emb exp="window.StrayingI18n.get('g09.l014b').replace('{value}', function () { return sf.treasures[1]; })"][p]
[endif]

[if exp="sf.treasures.length >= 3"]
[emb exp="window.StrayingI18n.get('g09.l014a').replace('{value}', function () { return sf.treasures[2]; })"][r]
[emb exp="window.StrayingI18n.get('g09.l014b').replace('{value}', function () { return sf.treasures[2]; })"][p]
[endif]

[emb exp="window.StrayingI18n.get('g09.l016a')"][r]
[emb exp="window.StrayingI18n.get('g09.l016b')"][p]

[emb exp="window.StrayingI18n.get('g09.l017a')"][l][r]
[emb exp="window.StrayingI18n.get('g09.l017b')"][p]

[emb exp="window.StrayingI18n.get('g09.l018a')"][l][r]
[emb exp="window.StrayingI18n.get('g09.l018b')"][p]

[emb exp="window.StrayingI18n.get('g09.l019')"][p]

[emb exp="window.StrayingI18n.get('g09.l020a')"][l][r]
[emb exp="window.StrayingI18n.get('g09.l020b')"][r]
[emb exp="window.StrayingI18n.get('g09.l020c')"][p]

[emb exp="window.StrayingI18n.get('g09.l021a')"][l][r]
[emb exp="window.StrayingI18n.get('g09.l021b')"][p]

[emb exp="window.StrayingI18n.get('g09.l022')"][p]

[emb exp="window.StrayingI18n.get('g09.l023a')"][l][r]
[emb exp="window.StrayingI18n.get('g09.l023b')"][p]

;;イラスト：子どもと手を繋ぐ
[chara_hide name="child"]
[chara_show face="shake" name="child"]

[emb exp="window.StrayingI18n.get('g09.l024a')"][l][r]
[emb exp="window.StrayingI18n.get('g09.l024b')"][p]

[emb exp="window.StrayingI18n.get('g09.l025a')"][l][r]
[emb exp="window.StrayingI18n.get('g09.l025b')"][p]

[emb exp="window.StrayingI18n.get('g09.l026')"][p]
[fadeoutbgm time="800"]

; 「その瞬間。」の直後で子どもを消す
[chara_hide name="child"]

; 一瞬、静かな間を置く
[wait time=450]

; 風が吹き抜ける
[playse storage="se004.mp3"]

; 風が立ち上がるのを少し待つ
[wait time=350]

; 朝の森へ切り替え
[bg storage="bg001d.jpg" time="900"]

; 光が一気に広がる
[iscript]

(function () {

    $('#straying-light-flash').remove();

    var $flash = $('<div id="straying-light-flash"></div>');

    $flash.css({
        position: 'absolute',
        left: '0px',
        top: '0px',
        width: '1280px',
        height: '720px',

        background:
            'radial-gradient(circle at 50% 42%, ' +
            'rgba(255,255,245,0.95) 0%, ' +
            'rgba(255,248,220,0.78) 28%, ' +
            'rgba(255,240,200,0.38) 58%, ' +
            'rgba(255,255,255,0) 100%)',

        opacity: 0,
        pointerEvents: 'none',
        zIndex: 5000
    });

    $('#tyrano_base').append($flash);

    $flash
    .animate(
        { opacity: 1 },
        280
    )
    .animate(
        { opacity: 0.24 },
        1200
    )
    .animate(
        { opacity: 0 },
        1800,
        function () {
            $(this).remove();
        }
    );

})();

[endscript]

; 光が森になじむ余韻
[wait time=700]

[emb exp="window.StrayingI18n.get('g09.l027a')"][l][r]
[emb exp="window.StrayingI18n.get('g09.l027b')"][r]
[emb exp="window.StrayingI18n.get('g09.l027c')"][p]

[emb exp="window.StrayingI18n.get('g09.l028a')"][l][r]
[emb exp="window.StrayingI18n.get('g09.l028b')"][r]
[emb exp="window.StrayingI18n.get('g09.l028c')"][p]

[emb exp="window.StrayingI18n.get('g06.l045')"][p]

[emb exp="window.StrayingI18n.get('g09.l029a')"][l][r]
[emb exp="window.StrayingI18n.get('g09.l029b')"][p]

;;イラスト：老人の手
[chara_hide name="child"]
[chara_show face="old" name="child"]
[emb exp="window.StrayingI18n.get('g09.l030a')"][l][r]
[emb exp="window.StrayingI18n.get('g09.l030b')"][p]

[emb exp="window.StrayingI18n.get('g09.l031a')"][l][r]
[emb exp="window.StrayingI18n.get('g09.l031b')"][r]
[emb exp="window.StrayingI18n.get('g09.l031c')"][p]

[playbgm storage="bgm009.mp3" html5=true]

[emb exp="window.StrayingI18n.get('g09.l032a')"][l][r]
[emb exp="window.StrayingI18n.get('g09.l032b')"][r]
[emb exp="window.StrayingI18n.get('g09.l032c')"][p]

[emb exp="window.StrayingI18n.get('g09.l033a')"][l][r]
[emb exp="window.StrayingI18n.get('g09.l033b')"][p]

[emb exp="window.StrayingI18n.get('g09.l034a')"][l][r]
[emb exp="window.StrayingI18n.get('g09.l034b')"][p]

[emb exp="window.StrayingI18n.get('g09.l035a')"][r]
[emb exp="window.StrayingI18n.get('g09.l035b')"][p]

[emb exp="window.StrayingI18n.get('g09.l036')"][p]

[emb exp="window.StrayingI18n.get('g09.l037')"][p]

[emb exp="window.StrayingI18n.get('g09.l038a')"][l][r]
[emb exp="window.StrayingI18n.get('g09.l038b')"][p]

; ----------------------------------------------------------
; 傾向による分岐：最初に選んだカテゴリで決まる
; ----------------------------------------------------------
[if exp='f.first_category == "person"']
[emb exp="window.StrayingI18n.get('g09.l039a')"][l][r]
[emb exp="window.StrayingI18n.get('g09.l039b')"][p]
[elsif exp='f.first_category == "gift"']
[emb exp="window.StrayingI18n.get('g09.l040a')"][l][r]
[emb exp="window.StrayingI18n.get('g09.l040b')"][p]
[elsif exp='f.first_category == "words"']
[emb exp="window.StrayingI18n.get('g09.l041a')"][l][r]
[emb exp="window.StrayingI18n.get('g09.l041b')"][p]
[elsif exp='f.first_category == "treasure"']
[emb exp="window.StrayingI18n.get('g09.l042a')"][l][r]
[emb exp="window.StrayingI18n.get('g09.l042b')"][p]
[elsif exp='f.first_category == "goal"']
[emb exp="window.StrayingI18n.get('g09.l043a')"][l][r]
[emb exp="window.StrayingI18n.get('g09.l043b')"][p]
[elsif exp='f.first_category == "place"']
[emb exp="window.StrayingI18n.get('g09.l044a')"][l][r]
[emb exp="window.StrayingI18n.get('g09.l044b')"][p]
[endif]

[emb exp="window.StrayingI18n.get('g09.l045')"][p]

;;イラスト：老人の手を非表示（このあとの「手の感触が消える」描写に合わせる）
[chara_hide name="child"]

[emb exp="window.StrayingI18n.get('g09.l046a')"][l][r]
[emb exp="window.StrayingI18n.get('g09.l046b')"][p]

[emb exp="window.StrayingI18n.get('g09.l047a')"][l][r]
[emb exp="window.StrayingI18n.get('g09.l047b')"][p]

[emb exp="window.StrayingI18n.get('g09.l048a')"][l][r]
[emb exp="window.StrayingI18n.get('g09.l048b')"][p]

[emb exp="window.StrayingI18n.get('g09.l049')"][p]

[emb exp="window.StrayingI18n.get('g09.l050')"][p]

[emb exp="window.StrayingI18n.get('g09.l051a')"][l][r]
[emb exp="window.StrayingI18n.get('g09.l051b')"][p]

[emb exp="window.StrayingI18n.get('g06.l060a').replace('{value}', function () { return sf.player_name; })"][l][r]
[emb exp="window.StrayingI18n.get('g06.l060b').replace('{value}', function () { return sf.player_name; })"][p]

@jump target=*wake_transition

; ============================================================
; 10. エンディング：霧が晴れ、夢から目覚める
; ============================================================
*wake_transition
[autosave]
[cm]

[emb exp="window.StrayingI18n.get('g10.l001a')"][l][r]
[emb exp="window.StrayingI18n.get('g10.l001b')"][p]

[emb exp="window.StrayingI18n.get('g10.l002a').replace('{value}', function () { return sf.player_name; })"][l][r]
[emb exp="window.StrayingI18n.get('g10.l002b').replace('{value}', function () { return sf.player_name; })"][p]

; ----------------------------------------------------------
; 選択場面10：自分のことが好き？（好き／悪くない／今より好きになりたい）
; ----------------------------------------------------------

[glink x=270 y=200 text="&window.StrayingI18n.get('g10.c001')" target="*final_like" graphic="select_off.png" enterimg="select_on.png" width="600" height="50" size="32" ]
[glink x=270 y=300 text="&window.StrayingI18n.get('g10.c002')" target="*final_okay" graphic="select_off.png" enterimg="select_on.png" width="600" height="50" size="32" ]
[glink x=270 y=400 text="&window.StrayingI18n.get('g10.c003')" target="*final_want" graphic="select_off.png" enterimg="select_on.png" width="600" height="50" size="32" ]

[s]

;---------
*final_like
;---------
[cm]
[eval exp="window.RNF.recordChoice(window.RNF.getProjectConfig().ANSWERS.Q008.QUESTION_ID,window.RNF.getProjectConfig().ANSWERS.Q008.CHOICES.C01,window.StrayingI18n.get('g10.c001'))"]

[emb exp="window.StrayingI18n.get('g10.l003')"][p]

[emb exp="window.StrayingI18n.get('g10.l004')"][p]
@jump target=*wake_transition2

;---------
*final_okay
;---------
[cm]

[eval exp="window.RNF.recordChoice(window.RNF.getProjectConfig().ANSWERS.Q008.QUESTION_ID,window.RNF.getProjectConfig().ANSWERS.Q008.CHOICES.C02,window.StrayingI18n.get('g10.c002'))"]
[emb exp="window.StrayingI18n.get('g10.l005')"][p]

[emb exp="window.StrayingI18n.get('g10.l006a')"][l][r]
[emb exp="window.StrayingI18n.get('g10.l006b')"][p]
@jump target=*wake_transition2

;---------
*final_want
;---------
[cm]

[eval exp="window.RNF.recordChoice(window.RNF.getProjectConfig().ANSWERS.Q008.QUESTION_ID,window.RNF.getProjectConfig().ANSWERS.Q008.CHOICES.C03,window.StrayingI18n.get('g10.c003'))"]
[emb exp="window.StrayingI18n.get('g07.l007')"][p]

[emb exp="window.StrayingI18n.get('g10.l007a')"][l][r]
[emb exp="window.StrayingI18n.get('g07.l008b')"][p]
@jump target=*wake_transition2

;---------
*wake_transition2
;---------
[cm]

[emb exp="window.StrayingI18n.get('g10.l008a')"][l][r]
[emb exp="window.StrayingI18n.get('g10.l008b')"][p]

[emb exp="window.StrayingI18n.get('g10.l009a')"][l][r]
[emb exp="window.StrayingI18n.get('g10.l009b')"][p]

[emb exp="window.StrayingI18n.get('g10.l010a')"][l][r]
[emb exp="window.StrayingI18n.get('g10.l010b')"][p]

[emb exp="window.StrayingI18n.get('g10.l011a')"][l][r]
[emb exp="window.StrayingI18n.get('g10.l011b')"][p]

[emb exp="window.StrayingI18n.get('g10.l012a')"][l][r]
[emb exp="window.StrayingI18n.get('g10.l012b')"][p]

; ----------------------------------------------------------
; エンディング演出：暗転→まぶたの開け閉め→現実へ
; ----------------------------------------------------------

[wait time=1500]

[emb exp="window.StrayingI18n.get('g10.l013a')"][l][r]
[emb exp="window.StrayingI18n.get('g10.l013b')"][p]

[fadeoutbgm time="2200"]


; ----------------------------------------------------------
; 暗転前に霧レイヤーを消す
; ----------------------------------------------------------

[freeimage layer="2"]


; ----------------------------------------------------------
; 暗転
; ----------------------------------------------------------

[bg storage="bimg_black.png" time="1200"]
[wait time=800]

[emb exp="window.StrayingI18n.get('g00.l009')"][p]


; ----------------------------------------------------------
; 明滅中はテキストウィンドウを非表示
; ----------------------------------------------------------

[layopt layer="message" visible="false"]


; ----------------------------------------------------------
; まぶたの開け閉めのような演出（明滅）
; ----------------------------------------------------------

[bg storage="bg003.jpg" time="350"]
[wait time=400]

[bg storage="bimg_black.png" time="350"]
[wait time=500]

[bg storage="bg003.jpg" time="450"]
[wait time=500]

[bg storage="bimg_black.png" time="400"]
[wait time=650]

[bg storage="bg003.jpg" time="1600"]

[wait time=900]

; ----------------------------------------------------------
; 明滅終了後、テキストウィンドウを再表示
; ----------------------------------------------------------

[layopt layer="message" visible="true"]

[emb exp="window.StrayingI18n.get('g00.l010')"][p]

[emb exp="window.StrayingI18n.get('g10.l014a')"][l][r]

[playbgm storage="bgm010.mp3" html5=true]

[emb exp="window.StrayingI18n.get('g10.l014b')"][p]

[emb exp="window.StrayingI18n.get('g10.l015a')"][l][r]
[emb exp="window.StrayingI18n.get('g10.l015b')"][r]
[emb exp="window.StrayingI18n.get('g10.l015c')"][p]

; ----------------------------------------------------------
; 記入した「大切なもの」を1件ずつ表示
; ----------------------------------------------------------

[if exp="sf.treasures.length >= 1"]
[emb exp="window.StrayingI18n.get('g10.ui001')"]
[emb exp="sf.treasures[0]"]
[emb exp="window.StrayingI18n.get('g10.ui002')"][r]
[endif]

[if exp="sf.treasures.length >= 2"]
[emb exp="window.StrayingI18n.get('g10.ui001')"]
[emb exp="sf.treasures[1]"]
[emb exp="window.StrayingI18n.get('g10.ui002')"][r]
[endif]

[if exp="sf.treasures.length >= 3"]
[emb exp="window.StrayingI18n.get('g10.ui001')"]
[emb exp="sf.treasures[2]"]
[emb exp="window.StrayingI18n.get('g10.ui002')"][r]
[endif]

[p]

[emb exp="window.StrayingI18n.get('g10.l016a')"][r]
[emb exp="window.StrayingI18n.get('g10.l016b')"][p]

[emb exp="window.StrayingI18n.get('g10.l017a')"][l][r]
[emb exp="window.StrayingI18n.get('g10.l017b')"][p]

*ending
[cm]

[clearfix]

[iscript]
$('#straying-lang-button').hide();
$('#straying-language-panel').hide();
[endscript]

[chara_hide name="child"]

; 少し余韻を置いてからクレジットへ
[wait time=800]

@jump target=*credits


; ==========================================================
; END CREDITS
; ==========================================================

*credits

[cm]

; メッセージウィンドウを非表示
[layopt layer="message" visible="false"]

; クレジット背景
[bg storage="bg_endcr004.jpg" time="3000"]

[wait time=700]

[iscript]
(function () {

    // 二重生成防止
    $('#straying-end-credits').remove();

    var $credits = $('<div id="straying-end-credits"></div>');

    $credits.css({
        position: 'absolute',
        left: '0',
        top: '0',
        width: '1280px',
        height: '720px',
        zIndex: 9998,
        color: '#ffffff',
        cursor: 'pointer',
        boxSizing: 'border-box'
    });


    // --------------------------------------------------
    // 右側クレジット
    // --------------------------------------------------

    var $main = $('<div></div>');

    $main.css({
    position: 'absolute',
    left: '650px',
    top: '105px',
    width: '520px',
    textAlign: 'center',
    fontFamily: '"Montserrat", sans-serif',
    fontWeight: '400',
    textShadow: '0 5px 8px rgba(0,0,0,0.55)',
    opacity: 0
});

    $main.html(

        '<div style="font-size:25px; margin-bottom:10px;">Produced by</div>' +

        '<div style="font-size:34px; margin-bottom:52px;">' +
            'Hironori &#39;Tom&#39; SAKAI' +
        '</div>' +

        '<div style="font-size:25px; margin-bottom:10px;">Directed &amp; Written by</div>' +

        '<div style="font-size:34px; margin-bottom:52px;">' +
            'Akane YATA' +
        '</div>' +

        '<div style="font-size:25px; margin-bottom:10px;">Development by</div>' +

        '<div style="font-size:34px; margin-bottom:62px;">' +
            'Hizakake LLC' +
        '</div>'
    );

// --------------------------------------------------
// FOR YOU
// 少し遅れて、ゆっくり表示
// --------------------------------------------------

var $forYou = $('<div>FOR YOU</div>');

$forYou.css({
    position: 'absolute',

    left: '650px',
    top: '555px',
    width: '520px',

    textAlign: 'center',

    fontFamily: '"Straying Serif", serif',
    fontSize: '39px',
    fontWeight: '500',

    color: '#ffffff',

    textShadow:
        '0 5px 8px rgba(0,0,0,0.55)',

    opacity: 0
});



    // --------------------------------------------------
    // クリック案内
    // --------------------------------------------------

    var $returnText = $('<div></div>');

    $returnText
    .text('CONTINUE')
        .css({
            position: 'absolute',
            right: '28px',
            bottom: '22px',
            fontFamily: '"Montserrat", sans-serif',
            fontSize: '11px',
            fontWeight: '400',
            letterSpacing: '0.12em',
            color: 'rgba(255,255,255,0.55)'
        });


    $credits.append($main);
    $credits.append($forYou);

    $main.animate(
    {
        opacity: 1
    },
    2200
);

    $forYou
    .delay(2800)
    .animate(
        {
            opacity: 1
        },
        2600
    );

    $credits.append($returnText);

    $('#tyrano_base').append($credits);


// --------------------------------------------------
// クリックでアンケート案内画面へ
// --------------------------------------------------

$credits.one('click', function () {

    $(this).fadeOut(
        800,
        function () {

            $(this).remove();

            TYRANO.kag.ftag.startTag(
                'jump',
                {
                    target: '*post_survey'
                }
            );

        }
    );

});

})();
[endscript]

[s]

; ==========================================================
; POST GAME SURVEY
; ==========================================================

*post_survey

[cm]

[layopt layer="message" visible="false"]

[bg storage="bimg_black.png" time="1200"]

[wait time=500]

[iscript]

(function () {

    $('#straying-post-survey').remove();

    var lang =
        window.StrayingI18n.getLanguage();

    var isEnglish =
        lang === 'en';


    // --------------------------------------------------
    // 仮アンケートURL
    // 本番URLが届いたらここだけ差し替える
    // --------------------------------------------------

    var surveyUrlJa =
        'https://example.com/#straying-post-survey-ja';

    var surveyUrlEn =
        'https://example.com/#straying-post-survey-en';


    // --------------------------------------------------
    // 画面
    // --------------------------------------------------

    var $screen =
        $('<div id="straying-post-survey"></div>');

    $screen.css({

        position: 'absolute',

        left: '0',
        top: '0',

        width: '1280px',
        height: '720px',

        zIndex: 30000,

        boxSizing: 'border-box',

        background:
            'linear-gradient(180deg, #171c20 0%, #101417 100%)',

        color: '#f3f1ec',

        fontFamily:
            '"Straying Sans", sans-serif',

        opacity: 0
    });


    // --------------------------------------------------
    // コンテンツ
    // --------------------------------------------------

    var $content =
        $('<div></div>');

    $content.css({

        position: 'absolute',

        left: '190px',
        top: '160px',

        width: '900px',

        textAlign: 'center'
    });


    // --------------------------------------------------
    // タイトル
    // --------------------------------------------------

    var titleText =
        isEnglish
            ? 'Thank you for being part of this experience.'
            : '体験いただき、ありがとうございました。';

    var $title =
        $('<div></div>')
            .text(titleText)
            .css({

                fontSize: '34px',

                fontWeight: '500',

                marginBottom: '24px',

                letterSpacing: '0.03em'
            });


    // --------------------------------------------------
    // オレンジライン
    // --------------------------------------------------

    var $line =
        $('<div></div>');

    $line.css({

        width: '72px',
        height: '2px',

        margin:
            '0 auto 34px auto',

        background:
            '#e69948'
    });


    // --------------------------------------------------
    // 説明
    // --------------------------------------------------

    var bodyText =
        isEnglish
            ? 'Please complete the post-game survey about your experience.'
            : '今回の体験について、アンケートへのご回答をお願いいたします。';

    var $body =
        $('<div></div>')
            .text(bodyText)
            .css({

                fontSize: '21px',

                lineHeight: '1.8',

                marginBottom: '56px',

                opacity: 0.92
            });


    // --------------------------------------------------
    // アンケートボタン
    // --------------------------------------------------

    var buttonText =
        isEnglish
            ? 'CONTINUE TO SURVEY'
            : 'アンケートへ進む';

    var $button =
        $('<div></div>')
            .text(buttonText)
            .css({

                width: '360px',
                height: '66px',

                margin:
                    '0 auto',

                display: 'flex',

                alignItems: 'center',
                justifyContent: 'center',

                boxSizing: 'border-box',

                backgroundImage:
                    'url("./data/image/button/modalselect_off.png")',

                backgroundSize:
                    '100% 100%',

                backgroundRepeat:
                    'no-repeat',

                fontFamily:
                    '"Montserrat", "Straying Sans", sans-serif',

                fontSize:
                    isEnglish ? '20px' : '22px',

                fontWeight: '500',

                cursor: 'pointer',

                userSelect: 'none'
            });


    $button.on(
        'mouseenter',
        function () {

            $(this).css(
                'background-image',
                'url("./data/image/button/modalselect_on.png")'
            );
        }
    );


    $button.on(
        'mouseleave',
        function () {

            $(this).css(
                'background-image',
                'url("./data/image/button/modalselect_off.png")'
            );
        }
    );


    var isSurveyTransitioning = false;

$button.on(
    'click',
    async function (e) {
        e.preventDefault();
        e.stopPropagation();

        if (isSurveyTransitioning) {
            return;
        }

        isSurveyTransitioning = true;

        var url =
            isEnglish
                ? surveyUrlEn
                : surveyUrlJa;

        var flushResult =
            await window.RNF.flushResearchRecords();

        if (
            !flushResult.success ||
            window.RNF.getResearchQueueCount() > 0
        ) {
            console.error(
                'Straying: 研究データの送信が完了していないため、アンケート遷移を中止します。',
                flushResult
            );

            isSurveyTransitioning = false;
            return;
        }

        console.log(
            '✅ Straying: 研究データ送信完了。事後アンケートへ移動します。'
        );

        window.location.href =
            url;
    }
);


    // --------------------------------------------------
    // コピー
    // --------------------------------------------------

    var $tagline =
        $('<div></div>')
            .text(
                'Stray, and still advance.'
            )
            .css({

                position: 'absolute',

                left: '0',
                bottom: '54px',

                width: '1280px',

                textAlign: 'center',

                fontFamily:
                    '"Straying Serif", serif',

                fontSize: '22px',

                letterSpacing: '0.03em',

                color:
                    'rgba(255,255,255,0.62)'
            });


    // --------------------------------------------------
    // 組み立て
    // --------------------------------------------------

    $content.append($title);
    $content.append($line);
    $content.append($body);
    $content.append($button);

    $screen.append($content);
    $screen.append($tagline);

    $('#tyrano_base').append($screen);


    // --------------------------------------------------
    // ゆっくり表示
    // --------------------------------------------------

    $screen.animate(
        {
            opacity: 1
        },
        1800
    );

})();

[endscript]

[s]

; ========================================
; 新規ゲーム専用初期化
; CONTINUE時には呼ばない
; ========================================
*setup_new_game

[iscript]

sf.save = 0;

// --- 「大切なもの」自由記述（複数回答をすべて保存） ---
sf.treasures = [];
sf.player_treasure = "";
f.treasure_round = 0;
f.first_category = "";

// --- カテゴリごとに「一度選んだか」フラグ ---
f.used_person = 0;
f.used_gift = 0;
f.used_words = 0;
f.used_treasure = 0;
f.used_goal = 0;
f.used_place = 0;

[endscript]

[return]

; ========================================
; 共通セットアップ（[call]で呼び出す想定のサブルーチン）
; *startから呼ばれる他、first.ksのデバッグジャンプ機能からも
; 任意のラベルへ飛ぶ前に呼ばれる（キャラクター未登録エラー対策）
; ========================================
*setup_common

[title name="Straying Through the Fog"]

[iscript]

window.StrayingUI.applyFonts();

[endscript]

[cm]
[clearfix]
[start_keyconfig]

[layopt layer="0" visible="true"]
[layopt layer="1" visible="true"]
[layopt layer="2" visible="true"]

;夜霧の深い森。足もとまで白く沈むくらい濃い霧
;[bg storage="bg001a.jpg" time="100"]

[button name="role_button" role="menu" graphic="button/btn_exit_normal.png" enterimg="button/btn_exit_hover.png" x="735" y="20" width="120" height="48"]

[button name="role_button" role="backlog" graphic="button/btn_log_normal.png" enterimg="button/btn_log_hover.png" x="870" y="20" width="120" height="48"]

[button name="role_button" role="sleepgame" graphic="button/btn_menu_normal.png" enterimg="button/btn_menu_hover.png" storage="config.ks" x="1140" y="20" width="120" height="48"]

;右上UI
;EXIT / LOG / LANG / MENU
;LANGはJavaScriptで生成し、言語選択パネルを開く
[iscript]


// ==================================================
// EXIT / LOG / MENU
// ==================================================

var $menuBtns = $('.fixlayer').filter(function() {

    var src = this.src || "";

    return src.indexOf("btn_exit_") !== -1 ||
           src.indexOf("btn_log_") !== -1 ||
           src.indexOf("btn_menu_") !== -1;
});


// --------------------------------------------------
// フェードイン
// --------------------------------------------------

$menuBtns
    .css("opacity", 0)
    .animate({
        opacity: 1
    }, 2500);


// --------------------------------------------------
// pressed画像
// --------------------------------------------------

$menuBtns.each(function() {

    var $btn = $(this);

    var normalSrc = $btn.attr('src');
    var hoverSrc = normalSrc.replace(
        '_normal.png',
        '_hover.png'
    );
    var pressedSrc = normalSrc.replace(
        '_normal.png',
        '_pressed.png'
    );


    $btn.on(
        'mousedown.strayingButton',
        function() {

            $btn.attr(
                'src',
                pressedSrc
            );
        }
    );


    $btn.on(
        'mouseup.strayingButton',
        function() {

            $btn.attr(
                'src',
                hoverSrc
            );
        }
    );


    $btn.on(
        'mouseleave.strayingButton',
        function() {

            $btn.attr(
                'src',
                normalSrc
            );
        }
    );

});

// ==================================================
// LANG UI
// NEW GAME / CONTINUE の両方から再生成できるよう関数化
// ==================================================

window.StrayingUI.createLanguageUI(true);

[endscript]


;選択肢ボタン（select_off/select_on）上のテキストを、上下左右中央に表示する
;（デフォルトでは高さを固定すると上寄りになってしまうため、CSSで中央揃えに上書き。
;　他のスタイルとの優先度勝負にならないよう!importantを付けている）
;[iscript]
;if ($('#straying-glink-style').length === 0) {
;    $('head').append('<style id="straying-glink-style">.glink_button{display:flex !important;align-items:center !important;justify-content:center !important;padding:0 !important;margin:0 !important;text-align:center !important;line-height:normal !important;box-sizing:border-box !important;}</style>');
;}
;[endscript]

;メッセージウィンドウを画面下部に固定（背景がほとんど見える大きさに縮小）
;t_window.pngの絵の内容（透明→下部半透明グレーのグラデーション）が
;画面幅いっぱい・高さ297px相当だったため、そのサイズに合わせています
[position layer=message0 left=0 top=423 width=1280 height=297 page=fore visible=true frame="config/t_window.png"]
[position layer=message0 page=fore margint="110" marginl="60" marginr="60" marginb="30"]

;クリック待ちの矢印（ウィンドウ右下に固定表示）。[glyph]は呼ぶたびに設定がリセットされるため、ここで一度だけ指定する
;※[glyph]の画像指定は storage= ではなく line= 。folder=を省略すると
;  エンジン内蔵のtyrano/images/system/を見に行ってしまうため、
;  data/image/を見せるには folder="image" の指定が必須
;t_arrow.pngの実サイズ(122x96px)の約1/3(41x32px)に縮小し、
;画面(1280x720)の右下ぎりぎり（余白20px）に収まる座標に調整
[glyph line="t_arrow.png" folder="image" fix=true left=1219 top=668 width=41 height=32]

[chara_config ptext="chara_name_area"]

[keyframe name=flow1]
[frame p=50% y=5 ]
[frame p=100% y=0]
[endkeyframe]

[keyframe name=flow2]
[frame p=100% y=0 ]
[frame p=25% y=-5]
[endkeyframe]

;霧がゆっくり右へ流れるアニメーション
;移動量を-40→-80に、時間も9000ms→6000msに変更し、揺れをわかりやすくした
[keyframe name=fogdrift]
[frame p=0% x=0]
[frame p=100% x=-180]
[endkeyframe]

[chara_new name="child" storage="child/ch001.png" jname="子供" height="725" width="1280"]
[chara_face name="child" face="hand" storage="child/ch002.png"]
[chara_face name="child" face="shake" storage="child/ch003.png"]
[chara_face name="child" face="walk" storage="child/ch004.png"]
[chara_face name="child" face="old" storage="child/ch005.png"]

[wa]

[return]
