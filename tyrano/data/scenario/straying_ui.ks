; ============================================================
; Straying 共通UI
; NEW GAME / CONTINUE 共通で使用するUI機能を定義
; ============================================================

[iscript]

window.StrayingUI = window.StrayingUI || {};

// ==================================================
// Straying用 キーコンフィグ
// ==================================================

if (window.__tyrano_key_config) {

    // キーボード操作をいったん全て無効化
    Object.keys(window.__tyrano_key_config.key || {}).forEach(function (key) {
        window.__tyrano_key_config.key[key] = "";
    });

    // 開発中だけCtrl長押しスキップ
    window.__tyrano_key_config.key.Control = "holdskip";

    // デバッグ時のF12のみ許可
    window.__tyrano_key_config.key.F12 = "default_debug";


    // マウス操作を無効化
    Object.keys(window.__tyrano_key_config.mouse || {}).forEach(function (key) {
        window.__tyrano_key_config.mouse[key] = "";
    });


    // スマホ・タブレットのジェスチャー操作を無効化
    Object.keys(window.__tyrano_key_config.gesture || {}).forEach(function (key) {
        window.__tyrano_key_config.gesture[key] = "";
    });


    // ゲームパッド操作を無効化
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

window.StrayingUI.applyFonts = function () {

    // すでに存在する場合も一度作り直す
    $('#straying-font-style').remove();

    var css = '';

    // --------------------------------------------------
    // Font Face
    // --------------------------------------------------

    css += '@' + 'font-face {';
    css += 'font-family:"Straying Serif";';
    css += 'src:url("./data/others/font/NotoSerifJP-Regular.ttf") format("truetype");';
    css += 'font-weight:400;';
    css += 'font-style:normal;';
    css += '}';

    css += '@' + 'font-face {';
    css += 'font-family:"Straying Serif";';
    css += 'src:url("./data/others/font/NotoSerifJP-Medium.ttf") format("truetype");';
    css += 'font-weight:500;';
    css += 'font-style:normal;';
    css += '}';

    css += '@' + 'font-face {';
    css += 'font-family:"Straying Sans";';
    css += 'src:url("./data/others/font/NotoSansJP-Regular.ttf") format("truetype");';
    css += 'font-weight:400;';
    css += 'font-style:normal;';
    css += '}';

    css += '@' + 'font-face {';
    css += 'font-family:"Straying Sans";';
    css += 'src:url("./data/others/font/NotoSansJP-Medium.ttf") format("truetype");';
    css += 'font-weight:500;';
    css += 'font-style:normal;';
    css += '}';

    css += '@' + 'font-face {';
    css += 'font-family:"Montserrat";';
    css += 'src:url("./data/others/font/Montserrat-Regular.ttf") format("truetype");';
    css += 'font-weight:400;';
    css += 'font-style:normal;';
    css += '}';

    // --------------------------------------------------
    // 本文
    // --------------------------------------------------

    css += '.message_inner,';
    css += '.message_inner *,';
    css += '.message0_fore {';
    css += 'font-family:"Straying Serif",serif !important;';
    css += 'font-weight:400 !important;';
    css += '}';

    // --------------------------------------------------
    // 選択肢
    // --------------------------------------------------

    css += '.button_graphic.event-setting-element,';
    css += '.button_graphic.event-setting-element * {';
    css += 'font-family:"Straying Sans",sans-serif !important;';
    css += 'font-weight:400 !important;';
    css += 'font-size:32px !important;';
    css += 'text-align:center !important;';
    css += 'line-height:50px !important;';
    css += 'padding:27px 64px 37px !important;';
    css += '}';

    // --------------------------------------------------
    // 入力欄
    // --------------------------------------------------

    css += 'input,textarea {';
    css += 'font-family:"Straying Sans",sans-serif !important;';
    css += 'font-weight:400;';
    css += '}';

        // --------------------------------------------------
    // タイトルボタン
    // --------------------------------------------------

    css += '.straying-title-button {';
    css += 'font-family:"Montserrat",sans-serif !important;';
    css += 'font-weight:400;';
    css += '}';

    // --------------------------------------------------
    // 通知ボタン
    // --------------------------------------------------

    css += '.straying-notice-button {';
    css += 'font-family:"Straying Sans",sans-serif !important;';
    css += 'font-weight:500;';
    css += '}';

    // --------------------------------------------------
    // CSS反映
    // --------------------------------------------------

    $('<style>')
        .attr('id', 'straying-font-style')
        .text(css)
        .appendTo('head');

    // フォントを事前ロード
    if (document.fonts) {
        document.fonts.load('400 16px "Straying Serif"');
        document.fonts.load('500 16px "Straying Serif"');
        document.fonts.load('400 16px "Straying Sans"');
        document.fonts.load('500 16px "Straying Sans"');
    }
};

// ==================================================
// LANG UI
// NEW GAME / CONTINUE の両方から再生成できるよう関数化
// ==================================================

window.StrayingUI.createLanguageUI = function (fadeIn) {

    // ==================================================
    // LANGボタン
    // ==================================================

    // 二重生成防止
    $('#straying-lang-button').remove();

    var langNormal =
        './data/image/button/btn_lang_normal.png';

    var langHover =
        './data/image/button/btn_lang_hover.png';

    var langPressed =
        './data/image/button/btn_lang_pressed.png';


    var $langBtn = $('<img>')
        .attr(
            'id',
            'straying-lang-button'
        )
        .attr(
            'src',
            langNormal
        )
        .css({

            position: 'absolute',

            left: '1005px',
            top: '20px',

            width: '120px',
            height: '48px',

            cursor: 'pointer',

            zIndex: 21000,

            opacity: fadeIn ? 0 : 1

        });


    // ゲーム画面へ追加
    $('#tyrano_base').append(
        $langBtn
    );


    // START時だけフェードイン
    if (fadeIn) {

    $langBtn.animate(
        {
            opacity: 1
        },
        2500
    );

    }

    // hover
    $langBtn.on(
        'mouseenter',
        function() {

            $(this).attr(
                'src',
                langHover
            );
        }
    );


    // normal
    $langBtn.on(
        'mouseleave',
        function() {

            $(this).attr(
                'src',
                langNormal
            );
        }
    );


    // pressed
    $langBtn.on(
        'mousedown',
        function() {

            $(this).attr(
                'src',
                langPressed
            );
        }
    );


    // hoverへ戻す
    $langBtn.on(
        'mouseup',
        function() {

            $(this).attr(
                'src',
                langHover
            );
        }
    );


    // ==================================================
    // 言語選択パネル
    // ==================================================

    // 二重生成防止
    $('#straying-language-panel').remove();


    var $langPanel =
        $('<div id="straying-language-panel"></div>');


    $langPanel.css({

        position: 'absolute',

        left: '1005px',
        top: '76px',

        width: '120px',

        padding: '6px',

        boxSizing: 'border-box',

        background:
            'rgba(20, 28, 34, 0.94)',

        border:
            '1px solid rgba(255,255,255,0.35)',

        borderRadius: '10px',

        zIndex: 21001,

        display: 'none'

    });


    // --------------------------------------------------
    // 言語項目を作る関数
    // --------------------------------------------------

    function createLanguageItem(
        label,
        lang
    ) {

        var $item =
            $('<div></div>');


        $item
            .text(label)
            .css({

                width: '100%',

                padding: '9px 4px',

                boxSizing: 'border-box',

                color: '#ffffff',

                fontSize: '14px',

                textAlign: 'center',

                cursor: 'pointer',

                borderRadius: '7px'

            });


        $item.on(
            'mouseenter',
            function() {

                $(this).css(
                    'background',
                    'rgba(255,255,255,0.15)'
                );
            }
        );


        $item.on(
            'mouseleave',
            function() {

                $(this).css(
                    'background',
                    'transparent'
                );
            }
        );


        $item.on(
            'click',
            function(e) {

                e.stopPropagation();


                window.StrayingI18n.setLanguage(lang);


                // パネルを閉じる
                $langPanel.fadeOut(
                    150
                );


                console.log(
                    'Language selected:',
                    lang
                );

            }
        );


        $langPanel.append(
            $item
        );

    }


    // --------------------------------------------------
    // 対応言語
    // --------------------------------------------------

    createLanguageItem(
        '日本語',
        'ja'
    );

    createLanguageItem(
        'English',
        'en'
    );


    // ゲーム画面へ追加
    $('#tyrano_base').append(
        $langPanel
    );


    // ==================================================
    // LANGクリック
    // ==================================================

    $langBtn.on(
        'click.strayingLanguage',
        function(e) {

            e.preventDefault();

            e.stopPropagation();


            $langPanel
                .stop(
                    true,
                    true
                )
                .fadeToggle(
                    150
                );

        }
    );


    // ==================================================
    // パネル外クリックで閉じる
    // ==================================================

    $(document)
        .off(
            'click.strayingLanguage'
        )
        .on(
            'click.strayingLanguage',
            function() {

                $langPanel.fadeOut(
                    150
                );

            }
        );


    // パネル内クリックは閉じない
    $langPanel.on(
        'click',
        function(e) {

            e.stopPropagation();

        }
    );


    // ==================================================
    // MENUボタンをStraying専用MENUへ接続
    // ==================================================

    var $strayingMenuButton = $('img').filter(function () {

        var src = this.src || '';

        return src.indexOf('btn_menu_') !== -1;

    });

        $strayingMenuButton.each(function () {

        var menuButton = this;
        var lastTouchTime = 0;

        if (menuButton.dataset.strayingMenuRegistered === 'true') {
            return;
        }

        menuButton.dataset.strayingMenuRegistered = 'true';

        // スマートフォン・タブレット
        menuButton.addEventListener(
            'touchend',
            function (e) {

                lastTouchTime = Date.now();

                e.preventDefault();
                e.stopPropagation();
                e.stopImmediatePropagation();

                window.StrayingUI.showMenu();

            },
            true
        );

        // PC
        menuButton.addEventListener(
            'click',
            function (e) {

                // touchend直後に生成されたclickは無視
                if (Date.now() - lastTouchTime < 700) {
                    return;
                }

                e.preventDefault();
                e.stopPropagation();
                e.stopImmediatePropagation();

                window.StrayingUI.showMenu();

            },
            true
        );

    });


    // ==================================================
    // LOGボタンをStraying専用LOGへ接続
    // ==================================================

    var $strayingLogButton = $('img').filter(function () {

        var src = this.src || '';

        return src.indexOf('btn_log_') !== -1;

    });

    $strayingLogButton.each(function () {

        var logButton = this;

        if (logButton.dataset.strayingLogRegistered === 'true') {
            return;
        }

        logButton.dataset.strayingLogRegistered = 'true';

        logButton.addEventListener(
            'click',
            function (e) {

                e.preventDefault();
                e.stopPropagation();
                e.stopImmediatePropagation();

                window.StrayingUI.showLog();

            },
            true
        );

    });


    // ==================================================
    // EXITボタンをStraying専用EXITへ接続
    // ==================================================

    var $strayingExitButton = $('img').filter(function () {

        var src = this.src || '';

        return src.indexOf('btn_exit_') !== -1;

    });

    $strayingExitButton.each(function () {

        var exitButton = this;

        if (exitButton.dataset.strayingExitRegistered === 'true') {
            return;
        }

        exitButton.dataset.strayingExitRegistered = 'true';

        exitButton.addEventListener(
            'click',
            function (e) {

                e.preventDefault();
                e.stopPropagation();
                e.stopImmediatePropagation();

                window.StrayingUI.showExit();

            },
            true
        );

    }); 

};

// ==================================================
// Straying専用 LOG
// ==================================================

window.StrayingUI.showLog = function () {

    // 二重生成防止
    $('#straying-log-overlay').remove();

    // LANGパネルは閉じる
    $('#straying-language-panel').hide();

    // LANGボタンも隠す
$('#straying-lang-button').hide();


// ==================================================
// Tyranoのクリック受付レイヤーを一時停止
// ==================================================

$('.layer_event_click, .layer_event').each(function () {

    var $layer = $(this);

    $layer.attr(
        'data-straying-log-pointer-events',
        $layer.css('pointer-events') || ''
    );

    $layer.css(
        'pointer-events',
        'none'
    );

});


// ==================================================
// 選択肢を一時的に隠す
// ==================================================

$('.event-setting-element:visible').each(function () {

    var $choice = $(this);

    $choice.attr(
        'data-straying-log-hidden',
        'true'
    );

    $choice.hide();

});

// ==================================================
// LOG表示中はLANGも隠す
// ==================================================

$('#straying-lang-button').hide();


    // ==================================================
    // Tyrano側の右上UI・選択肢を一時的に隠す
    // ==================================================

    $('.event-setting-element:visible').each(function () {

    var $element = $(this);

    $element.attr(
        'data-straying-log-hidden',
        'true'
    );

    $element.hide();

});

    // ==================================================
    // 選択肢を一時的に隠す
    // ==================================================

    $('.event-setting-element:visible').each(function () {

    var $choice = $(this);

    $choice.attr(
        'data-straying-log-hidden',
        'true'
    );

    $choice.hide();

});

    // --------------------------------------------------
    // バックログ取得
    // --------------------------------------------------

    var backlog = [];

    try {

        if (
            window.TYRANO &&
            TYRANO.kag &&
            TYRANO.kag.variable &&
            TYRANO.kag.variable.tf &&
            TYRANO.kag.variable.tf.system &&
            Array.isArray(TYRANO.kag.variable.tf.system.backlog)
        ) {

            backlog =
                TYRANO.kag.variable.tf.system.backlog.slice();

        }

    } catch (e) {

        console.warn(
            'Straying LOG: backlog取得失敗',
            e
        );

    }


    // --------------------------------------------------
    // オーバーレイ
    // --------------------------------------------------

    var $overlay =
        $('<div id="straying-log-overlay"></div>');

    $overlay.css({

    position: 'absolute',

    left: 0,
    top: 0,

    width: '100%',
    height: '100%',

    zIndex: 2147483000,

    pointerEvents: 'auto',

    background:
        'rgba(7, 12, 16, 0.985)',

    opacity: 0

});


    // --------------------------------------------------
    // 中央コンテナ
    // --------------------------------------------------

    var $container =
        $('<div></div>');

    $container.css({

        position: 'absolute',

        left: '50%',
        top: '50%',

        transform:
            'translate(-50%, -50%)',

        width: '78%',
        height: '78%',

        boxSizing: 'border-box'

    });


    // --------------------------------------------------
    // タイトル
    // --------------------------------------------------

    var $title =
        $('<div>LOG</div>');

    $title.css({

        fontFamily:
            '"Montserrat", sans-serif',

        fontSize: '28px',

        letterSpacing: '0.18em',

        color: '#ffffff',

        marginBottom: '12px'

    });


    // --------------------------------------------------
    // オレンジライン
    // --------------------------------------------------

    var $line =
        $('<div></div>');

    $line.css({

        width: '100%',

        height: '2px',

        background:
            'rgba(230, 146, 63, 0.85)',

        marginBottom: '28px'

    });


    // --------------------------------------------------
    // ログ本文エリア
    // --------------------------------------------------

    var $logArea =
        $('<div></div>');

    $logArea.css({

        width: '100%',

        height:
            'calc(100% - 105px)',

        overflowY: 'auto',

        boxSizing: 'border-box',

        paddingRight: '18px',

        fontFamily:
            '"Straying Serif", serif',

        fontSize: '24px',

        lineHeight: '1.9',

        color:
            'rgba(255,255,255,0.88)',

        textAlign: 'left'

    });


    // --------------------------------------------------
    // バックログを追加
    // --------------------------------------------------

    if (backlog.length === 0) {

        var $empty =
            $('<div></div>');

        $empty
            .text('No log yet.')
            .css({

                opacity: 0.45,

                fontFamily:
                    '"Montserrat", sans-serif',

                fontSize: '16px'

            });

        $logArea.append(
            $empty
        );

    } else {

        backlog.forEach(
            function (entry) {

                var $entry =
                    $('<div></div>');

                $entry
                    .html(entry)
                    .css({

                        marginBottom: '20px'

                    });

                $logArea.append(
                    $entry
                );

            }
        );

    }


    // --------------------------------------------------
    // CLOSE
    // --------------------------------------------------

    var $close =
        $('<div>CLOSE</div>');

    $close.css({

    position: 'absolute',

    right: 0,
    top: 0,

    zIndex: 999999,
    pointerEvents: 'auto',

    fontFamily:
        '"Montserrat", sans-serif',

    fontSize: '16px',

    letterSpacing: '0.12em',

    color:
        'rgba(255,255,255,0.72)',

    cursor: 'pointer',

    padding: '8px 0 8px 20px'

});


    $close.on(
        'mouseenter',
        function () {

            $(this).css(
                'color',
                '#e6923f'
            );

        }
    );


    $close.on(
        'mouseleave',
        function () {

            $(this).css(
                'color',
                'rgba(255,255,255,0.72)'
            );

        }
    );


    $close.on(
    'click',
    function (e) {

        e.preventDefault();
        e.stopPropagation();

        $overlay.fadeOut(
            200,
            function () {

                // ==================================================
                // 隠していた選択肢を戻す
                // ==================================================

                $('[data-straying-log-hidden="true"]')
                    .each(function () {

                        $(this)
                            .show()
                            .removeAttr(
                                'data-straying-log-hidden'
                            );

                    });


                // ==================================================
                // LANGボタンを戻す
                // ==================================================

                $('#straying-lang-button').show();


                // ==================================================
                // Tyranoのクリック受付レイヤーを元に戻す
                // ==================================================

                $('.layer_event_click, .layer_event').each(function () {

                    var $layer = $(this);

                    var original =
                        $layer.attr(
                            'data-straying-log-pointer-events'
                        );

                    if (original) {

                        $layer.css(
                            'pointer-events',
                            original
                        );

                    } else {

                        $layer.css(
                            'pointer-events',
                            ''
                        );

                    }

                    $layer.removeAttr(
                        'data-straying-log-pointer-events'
                    );

                });


                // ==================================================
                // LOG画面を削除
                // ==================================================

                $overlay.remove();

            }
        );

    }
);


    // --------------------------------------------------
    // 組み立て
    // --------------------------------------------------

    $container.append(
        $title
    );

    $container.append(
        $line
    );

    $container.append(
        $logArea
    );

    $container.append(
        $close
    );

    $overlay.append(
        $container
    );

    $('#tyrano_base').append(
        $overlay
    );


    // --------------------------------------------------
    // 表示
    // --------------------------------------------------

    $overlay.animate(
        {
            opacity: 1
        },
        250
    );


    // 最新ログ位置までスクロール
    $logArea.scrollTop(
        $logArea[0].scrollHeight
    );


        // 背景クリックでは閉じない
    $overlay.on(
        'click',
        function (e) {

            e.stopPropagation();

        }
    );

    // LOG内のホイール操作をTyrano側へ伝えない
    $overlay.on(
        'wheel mousewheel DOMMouseScroll',
        function (e) {

            e.stopPropagation();

        }
    );

};
// ==================================================
// Straying専用 EXIT
// ==================================================

window.StrayingUI.showExit = function () {

    var lang =
        window.StrayingI18n.getLanguage();

    var isEnglish =
        lang === 'en';

    // 二重生成防止
    $('#straying-exit-overlay').remove();

    // LANGを隠す
    $('#straying-lang-button').hide();
    $('#straying-language-panel').hide();


    // --------------------------------------------------
    // オーバーレイ
    // --------------------------------------------------

    var $overlay =
        $('<div id="straying-exit-overlay"></div>');

    $overlay.css({

        position: 'absolute',

        left: 0,
        top: 0,

        width: '100%',
        height: '100%',

        zIndex: 2147483000,

        pointerEvents: 'auto',

        background:
            'rgba(7, 12, 16, 0.985)',

        opacity: 0

    });


    // --------------------------------------------------
    // 中央コンテナ
    // --------------------------------------------------

    var $container =
        $('<div></div>');

    $container.css({

        position: 'absolute',

        left: '50%',
        top: '50%',

        transform:
            'translate(-50%, -50%)',

        width: '62%',

        boxSizing: 'border-box',

        textAlign: 'left'

    });


    // --------------------------------------------------
    // タイトル
    // --------------------------------------------------

    var $title =
        $('<div>EXIT</div>');

    $title.css({

        fontFamily:
            '"Montserrat", sans-serif',

        fontSize: '28px',

        letterSpacing: '0.18em',

        color: '#ffffff',

        marginBottom: '12px'

    });


    // --------------------------------------------------
    // オレンジライン
    // --------------------------------------------------

    var $line =
        $('<div></div>');

    $line.css({

        width: '100%',

        height: '2px',

        background:
            'rgba(230, 146, 63, 0.85)',

        marginBottom: '42px'

    });


    // --------------------------------------------------
    // メッセージ
    // --------------------------------------------------

    var $message =
    $('<div></div>');

$message.html(
    isEnglish
        ? 'Exit the game?<br><span style="font-size:16px; opacity:0.65;">You can resume your game at any time by selecting “CONTINUE” on the title screen.</span>'
        : 'プレイを終了しますか？<br><span style="font-size:16px; opacity:0.65;">中断しても、タイトル画面の「CONTINUE」からいつでも再開することができます。</span>'
);
    $message.css({

        fontFamily:
            '"Straying Serif", serif',

        fontSize: '26px',

        lineHeight: '2.0',

        color:
            'rgba(255,255,255,0.90)',

        marginBottom: '48px'

    });


    // --------------------------------------------------
    // ボタンエリア
    // --------------------------------------------------

    var $buttonArea =
        $('<div></div>');

    $buttonArea.css({

        display: 'flex',

        justifyContent: 'center',

        gap: '28px'

    });


    // --------------------------------------------------
    // 戻る
    // --------------------------------------------------

    var $cancel =
    $('<div></div>');

$cancel.text(
    isEnglish
        ? 'BACK'
        : '戻る'
);

    $cancel.css({

        minWidth: '180px',

        padding: '14px 26px',

        boxSizing: 'border-box',

        border:
            '1px solid rgba(255,255,255,0.45)',

        borderRadius: '24px',

        fontFamily:
            '"Straying Sans", sans-serif',

        fontSize: '18px',

        color:
            'rgba(255,255,255,0.88)',

        cursor: 'pointer',

        textAlign: 'center',

        pointerEvents: 'auto'

    });


    // --------------------------------------------------
    // 終了する
    // --------------------------------------------------

    var $exit =
    $('<div></div>');

$exit.text(
    isEnglish
        ? 'EXIT'
        : '終了する'
);

    $exit.css({

        minWidth: '180px',

        padding: '14px 26px',

        boxSizing: 'border-box',

        border:
            '1px solid rgba(230,146,63,0.85)',

        borderRadius: '24px',

        fontFamily:
            '"Straying Sans", sans-serif',

        fontSize: '18px',

        color:
            '#e6923f',

        textAlign: 'center',
        cursor: 'pointer',

        pointerEvents: 'auto'

    });


    // --------------------------------------------------
    // hover
    // --------------------------------------------------

    $cancel.on(
        'mouseenter',
        function () {

            $(this).css(
                'border-color',
                'rgba(255,255,255,0.85)'
            );

        }
    );

    $cancel.on(
        'mouseleave',
        function () {

            $(this).css(
                'border-color',
                'rgba(255,255,255,0.45)'
            );

        }
    );


    $exit.on(
        'mouseenter',
        function () {

            $(this).css(
                'background',
                'rgba(230,146,63,0.12)'
            );

        }
    );

    $exit.on(
        'mouseleave',
        function () {

            $(this).css(
                'background',
                'transparent'
            );

        }
    );


    // --------------------------------------------------
    // 戻る
    // --------------------------------------------------

    $cancel.on(
    'click',
    function (e) {

        e.preventDefault();
        e.stopPropagation();

        // LANGはゲーム画面と同時に復帰させる
        $('#straying-lang-button').show();

        $overlay.fadeOut(
            200,
            function () {

                $overlay.remove();

            }
        );

    }
);


    // --------------------------------------------------
    // 終了する
    // --------------------------------------------------

    $exit.on(
        'click',
        function (e) {

            e.preventDefault();
            e.stopPropagation();

            window.location.href =
                './index.html';

        }
    );


    // --------------------------------------------------
    // 組み立て
    // --------------------------------------------------

    $buttonArea.append(
        $cancel
    );

    $buttonArea.append(
        $exit
    );

    $container.append(
        $title
    );

    $container.append(
        $line
    );

    $container.append(
        $message
    );

    $container.append(
        $buttonArea
    );

    $overlay.append(
        $container
    );

    $('#tyrano_base').append(
        $overlay
    );


    // --------------------------------------------------
    // 表示
    // --------------------------------------------------

    $overlay.animate(
        {
            opacity: 1
        },
        250
    );


    // 背景クリックでは閉じない
    $overlay.on(
        'click',
        function (e) {

            e.stopPropagation();

        }
    );

};

// ==================================================
// Straying専用 MENU
// ==================================================

window.StrayingUI.showMenu = function () {

    // 二重生成防止
    $('#straying-menu-overlay').remove();

    // タイトル画面から開いたMENUかどうか
    var fromTitle =
        $('#straying-title-menu').length > 0;

    // 本編から開いた場合だけ、本編用LANGを隠す
    if (!fromTitle) {

        $('#straying-lang-button').hide();
        $('#straying-language-panel').hide();

    }


    // --------------------------------------------------
    // 現在の音量
    // --------------------------------------------------

    var currentBgm =
        parseInt(TYRANO.kag.config.defaultBgmVolume, 10);

    var currentSe =
        parseInt(TYRANO.kag.config.defaultSeVolume, 10);

    if (isNaN(currentBgm)) {
        currentBgm = 100;
    }

    if (isNaN(currentSe)) {
        currentSe = 100;
    }


    // --------------------------------------------------
    // オーバーレイ
    // --------------------------------------------------

    var $overlay =
        $('<div id="straying-menu-overlay"></div>');

    $overlay.css({

        position: 'absolute',

        left: 0,
        top: 0,

        width: '100%',
        height: '100%',

        zIndex: 2147483000,

        pointerEvents: 'auto',

        background:
            'rgba(7, 12, 16, 0.985)',

        opacity: 0

    });


    // --------------------------------------------------
    // コンテナ
    // --------------------------------------------------

    var $container =
        $('<div></div>');

    $container.css({

        position: 'absolute',

        left: '50%',
        top: '50%',

        transform:
            'translate(-50%, -50%)',

        width: '72%',

        boxSizing: 'border-box'

    });


    // --------------------------------------------------
    // タイトル
    // --------------------------------------------------

    var $title =
        $('<div>MENU</div>');

    $title.css({

        fontFamily:
            '"Montserrat", sans-serif',

        fontSize: '28px',

        letterSpacing: '0.18em',

        color: '#ffffff',

        marginBottom: '12px'

    });


    // --------------------------------------------------
    // オレンジライン
    // --------------------------------------------------

    var $line =
        $('<div></div>');

    $line.css({

        width: '100%',

        height: '2px',

        background:
            'rgba(230, 146, 63, 0.85)',

        marginBottom: '42px'

    });


    // ==================================================
    // 音量行を作る関数
    // ==================================================

    function createVolumeRow(
        label,
        value,
        onChange
    ) {

        var $row =
            $('<div></div>');

        $row.css({

            display: 'grid',

            gridTemplateColumns:
                '180px 1fr 60px',

            alignItems: 'center',

            gap: '24px',

            marginBottom: '30px'

        });


        var $label =
            $('<div></div>');

        $label
            .text(label)
            .css({

                fontFamily:
                    '"Montserrat", sans-serif',

                fontSize: '17px',

                letterSpacing: '0.08em',

                color:
                    'rgba(255,255,255,0.85)'

            });


        var $slider =
            $('<input type="range" min="0" max="100" step="10">');

        $slider
            .val(value)
            .css({

                width: '100%',

                cursor: 'pointer',

                accentColor: '#e6923f'

            });


        var $value =
            $('<div></div>');

        $value
            .text(value)
            .css({

                fontFamily:
                    '"Montserrat", sans-serif',

                fontSize: '16px',

                color:
                    'rgba(255,255,255,0.65)',

                textAlign: 'right'

            });


        $slider.on(
            'input',
            function () {

                var newValue =
                    parseInt(
                        $(this).val(),
                        10
                    );

                $value.text(
                    newValue
                );

                onChange(
                    newValue
                );

            }
        );


        $row.append(
            $label
        );

        $row.append(
            $slider
        );

        $row.append(
            $value
        );


        return $row;

    }


    // ==================================================
    // BGM
    // ==================================================

    var $bgmRow =
        createVolumeRow(
            'BGM VOLUME',
            currentBgm,
            function (value) {

                TYRANO.kag.ftag.startTag(
                    'bgmopt',
                    {
                        volume:
                            String(value)
                    }
                );

            }
        );


    // ==================================================
    // SE
    // ==================================================

    var $seRow =
        createVolumeRow(
            'SE VOLUME',
            currentSe,
            function (value) {

                TYRANO.kag.ftag.startTag(
                    'seopt',
                    {
                        volume:
                            String(value)
                    }
                );

            }
        );



    // ==================================================
    // スマートフォン向け音量案内
    // ==================================================

    var $mobileVolumeNote =
    $('<div>※ スマートフォンでは音量調整が正常に動作しない場合があります。端末本体の音量設定をご利用ください。<br>On smartphones, volume controls may not work properly. Please use your device&rsquo;s volume controls instead.</div>');
    $mobileVolumeNote.css({

        fontFamily:
            '"Straying Sans", sans-serif',

        fontSize: '14px',

        lineHeight: '1.7',

        letterSpacing: '0.04em',

        color:
            'rgba(255,255,255,0.55)',

        marginTop: '-8px',

        marginBottom: '0'

    });

    // --------------------------------------------------
    // 区切り
    // --------------------------------------------------

    var $divider =
        $('<div></div>');

    $divider.css({

        height: '1px',

        background:
            'rgba(255,255,255,0.15)',

        margin:
            '38px 0 24px'

    });


    // ==================================================
    // LANGUAGE
    // ==================================================

    var $language =
        $('<div>LANGUAGE</div>');

    $language.css({

        fontFamily:
            '"Montserrat", sans-serif',

        fontSize: '18px',

        letterSpacing: '0.08em',

        color:
            'rgba(255,255,255,0.88)',

        padding:
            '16px 0',

        cursor: 'pointer',

        borderBottom:
            '1px solid rgba(255,255,255,0.10)'

    });


    $language.on(
        'mouseenter',
        function () {

            $(this).css(
                'color',
                '#e6923f'
            );

        }
    );


    $language.on(
        'mouseleave',
        function () {

            $(this).css(
                'color',
                'rgba(255,255,255,0.88)'
            );

        }
    );


    $language.on(
    'click',
    function (e) {

        e.preventDefault();
        e.stopPropagation();

        // 二重生成防止
        $('#straying-menu-language-panel').remove();


        // ----------------------------------------------
        // LANGUAGEパネル
        // ----------------------------------------------

        var $menuLangPanel =
            $('<div id="straying-menu-language-panel"></div>');

        $menuLangPanel.css({

            position: 'absolute',

            left: '50%',
            top: '50%',

            transform:
                'translate(-50%, -50%)',

            width: '360px',

            boxSizing: 'border-box',

            padding: '28px 32px',

            background:
                'rgba(12, 18, 22, 0.98)',

            border:
                '1px solid rgba(255,255,255,0.22)',

            borderRadius: '14px',

            zIndex: 2147483002,

            textAlign: 'center',

            opacity: 0

        });


        // ----------------------------------------------
        // タイトル
        // ----------------------------------------------

        var $menuLangTitle =
            $('<div>LANGUAGE</div>');

        $menuLangTitle.css({

            fontFamily:
                '"Montserrat", sans-serif',

            fontSize: '18px',

            letterSpacing: '0.12em',

            color: '#ffffff',

            marginBottom: '24px'

        });


        // ----------------------------------------------
        // 言語項目を作る関数
        // ----------------------------------------------

        function createMenuLanguageItem(
            label,
            lang
        ) {

            var $item =
                $('<div></div>');

            $item
                .text(label)
                .css({

                    width: '100%',

                    padding: '12px 8px',

                    marginBottom: '10px',

                    boxSizing: 'border-box',

                    fontFamily:
                        '"Straying Sans", sans-serif',

                    fontSize: '17px',

                    color:
                        'rgba(255,255,255,0.88)',

                    cursor: 'pointer',

                    border:
                        '1px solid rgba(255,255,255,0.16)',

                    borderRadius: '10px',

                    background:
                        'rgba(255,255,255,0.03)'

                });


            $item.on(
                'mouseenter',
                function () {

                    $(this).css({

                        color:
                            '#e6923f',

                        borderColor:
                            'rgba(230,146,63,0.65)',

                        background:
                            'rgba(230,146,63,0.08)'

                    });

                }
            );


            $item.on(
                'mouseleave',
                function () {

                    $(this).css({

                        color:
                            'rgba(255,255,255,0.88)',

                        borderColor:
                            'rgba(255,255,255,0.16)',

                        background:
                            'rgba(255,255,255,0.03)'

                    });

                }
            );


            $item.on(
                'click',
                function (e) {

                    e.preventDefault();
                    e.stopPropagation();

                    window.StrayingI18n.setLanguage(
                        lang
                    );

                    $menuLangPanel.fadeOut(
                        150,
                        function () {

                            $menuLangPanel.remove();

                        }
                    );

                }
            );


            return $item;

        }


        // ----------------------------------------------
        // 日本語
        // ----------------------------------------------

        var $ja =
            createMenuLanguageItem(
                '日本語',
                'ja'
            );


        // ----------------------------------------------
        // English
        // ----------------------------------------------

        var $en =
            createMenuLanguageItem(
                'English',
                'en'
            );


        // ----------------------------------------------
        // 組み立て
        // ----------------------------------------------

        $menuLangPanel.append(
            $menuLangTitle
        );

        $menuLangPanel.append(
            $ja
        );

        $menuLangPanel.append(
            $en
        );


        // MENUオーバーレイ内に追加
        $overlay.append(
            $menuLangPanel
        );


        // 表示
        $menuLangPanel.animate(
            {
                opacity: 1
            },
            150
        );

    }
);


    // ==================================================
    // CONTACT
    // ==================================================

    var $contact =
        $('<div>CONTACT</div>');

    $contact.css({

        fontFamily:
            '"Montserrat", sans-serif',

        fontSize: '18px',

        letterSpacing: '0.08em',

        color:
            'rgba(255,255,255,0.88)',

        padding:
            '16px 0',

        cursor: 'pointer',

        borderBottom:
            '1px solid rgba(255,255,255,0.10)'

    });


    $contact.on(
        'mouseenter',
        function () {

            $(this).css(
                'color',
                '#e6923f'
            );

        }
    );


    $contact.on(
        'mouseleave',
        function () {

            $(this).css(
                'color',
                'rgba(255,255,255,0.88)'
            );

        }
    );


    $contact.on(
    'click',
    function (e) {

        e.preventDefault();
        e.stopPropagation();

        var lang =
            window.StrayingI18n.getLanguage();

        var contactUrl =
            lang === 'en'
                ? 'https://docs.google.com/forms/d/e/1FAIpQLScOLfGaPHRwvQoYMi0PEGBAiLfD-cNyMwcKBIUl1a_KNYuTaA/viewform?usp=publish-editor'
                : 'https://docs.google.com/forms/d/e/1FAIpQLSePnqpBCSvNkbiwzjae3U-hvcSonvb05hG5NAHipZDLOyOuhg/viewform?usp=publish-editor';

        window.open(
            contactUrl,
            '_blank',
            'noopener,noreferrer'
        );

    }
);


    // ==================================================
    // CLOSE
    // ==================================================

    var $close =
        $('<div>CLOSE</div>');

    $close.css({

        position: 'absolute',

        right: 0,
        top: 0,

        zIndex: 999999,

        pointerEvents: 'auto',

        fontFamily:
            '"Montserrat", sans-serif',

        fontSize: '16px',

        letterSpacing: '0.12em',

        color:
            'rgba(255,255,255,0.72)',

        cursor: 'pointer',

                padding:
            '14px 14px 14px 20px',

        minWidth: '44px',

        minHeight: '44px',

        boxSizing: 'border-box',

        display: 'flex',

        alignItems: 'center',

        justifyContent: 'flex-end'

    });


    $close.on(
        'mouseenter',
        function () {

            $(this).css(
                'color',
                '#e6923f'
            );

        }
    );


    $close.on(
        'mouseleave',
        function () {

            $(this).css(
                'color',
                'rgba(255,255,255,0.72)'
            );

        }
    );


    $close.on(
    'click',
    function (e) {

        e.preventDefault();
        e.stopPropagation();

        $('#straying-language-panel').hide();

        $('#straying-menu-language-panel').remove();

        // LANGはゲーム画面と同時に復帰させる
        if (!fromTitle) {

       $('#straying-lang-button').show();

    }

        $overlay.fadeOut(
            200,
            function () {

                $overlay.remove();

            }
        );

    }
);


    // --------------------------------------------------
    // 組み立て
    // --------------------------------------------------

    $container.append(
        $title
    );

    $container.append(
        $line
    );

    $container.append(
        $bgmRow
    );

        $container.append(
        $seRow
    );

    $container.append(
        $mobileVolumeNote
    );

    $container.append(
        $divider
    );

    $container.append(
        $language
    );

    $container.append(
        $contact
    );

    $container.append(
        $close
    );


    $overlay.append(
        $container
    );


    $('#tyrano_base').append(
        $overlay
    );


    // --------------------------------------------------
    // 表示
    // --------------------------------------------------

    $overlay.animate(
        {
            opacity: 1
        },
        250
    );


    $overlay.on(
        'click',
        function (e) {

            e.stopPropagation();

        }
    );

};
[endscript]

[return]