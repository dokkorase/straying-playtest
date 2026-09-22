; ============================================================
; Straying 注意事項画面
; タイトル画面の前に表示
; ============================================================

*start

[cm]
[layopt layer="message" visible=false]

[iscript]

(function () {

    // --------------------------------------------------
    // 二重生成防止
    // --------------------------------------------------

    $('#straying-notice-screen').remove();

    if (window.StrayingUI && window.StrayingUI.applyFonts) {
        window.StrayingUI.applyFonts();
    }

    var $base = $('#tyrano_base');

    // --------------------------------------------------
    // 画面全体
    // --------------------------------------------------

    var $screen = $('<div id="straying-notice-screen"></div>');

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
        fontFamily: '"Straying Sans", sans-serif'
    });

// --------------------------------------------------
// Notice用 LANG / MENU
// タイトル画面と同じ画像を使用
// --------------------------------------------------

var noticeLangNormal =
    './data/image/button/btn_lang_normal.png';

var noticeLangHover =
    './data/image/button/btn_lang_hover.png';

var noticeLangPressed =
    './data/image/button/btn_lang_pressed.png';

var noticeMenuNormal =
    './data/image/button/btn_menu_normal.png';

var noticeMenuHover =
    './data/image/button/btn_menu_hover.png';

var noticeMenuPressed =
    './data/image/button/btn_menu_pressed.png';


// ==================================================
// LANGボタン
// ==================================================

var $noticeLang = $('<img>')
    .attr('id', 'straying-notice-lang')
    .attr('src', noticeLangNormal)
    .css({
        position: 'absolute',

        left: '1005px',
        top: '20px',

        width: '120px',
        height: '48px',

        cursor: 'pointer',
        zIndex: 30002
    });

$noticeLang.on('mouseenter', function () {
    $(this).attr(
        'src',
        noticeLangHover
    );
});

$noticeLang.on('mouseleave', function () {
    $(this).attr(
        'src',
        noticeLangNormal
    );
});

$noticeLang.on('mousedown', function () {
    $(this).attr(
        'src',
        noticeLangPressed
    );
});

$noticeLang.on('mouseup', function () {
    $(this).attr(
        'src',
        noticeLangHover
    );
});


// ==================================================
// MENUボタン
// ==================================================

var $noticeMenu = $('<img>')
    .attr('id', 'straying-notice-menu')
    .attr('src', noticeMenuNormal)
    .css({
        position: 'absolute',

        left: '1140px',
        top: '20px',

        width: '120px',
        height: '48px',

        cursor: 'pointer',
        zIndex: 30002
    });

$noticeMenu.on('mouseenter', function () {
    $(this).attr(
        'src',
        noticeMenuHover
    );
});

$noticeMenu.on('mouseleave', function () {
    $(this).attr(
        'src',
        noticeMenuNormal
    );
});

$noticeMenu.on('mousedown', function () {
    $(this).attr(
        'src',
        noticeMenuPressed
    );
});

$noticeMenu.on('mouseup', function () {
    $(this).attr(
        'src',
        noticeMenuHover
    );
});


// ==================================================
// 言語選択パネル
// ==================================================

var $noticeLangPanel =
    $('<div id="straying-notice-language-panel"></div>');

$noticeLangPanel.css({
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

    zIndex: 30003,

    display: 'none'
});


// --------------------------------------------------
// 言語項目
// --------------------------------------------------

function createNoticeLanguageItem(
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

            fontFamily:
                '"Straying Sans", sans-serif',

            color: '#ffffff',

            fontSize: '14px',

            textAlign: 'center',

            cursor: 'pointer',

            borderRadius: '7px'
        });

    $item.on(
        'mouseenter',
        function () {

            $(this).css(
                'background',
                'rgba(255,255,255,0.15)'
            );
        }
    );

    $item.on(
        'mouseleave',
        function () {

            $(this).css(
                'background',
                'transparent'
            );
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

            $noticeLangPanel.hide();

            renderNotice();
        }
    );

    return $item;
}

$noticeLangPanel.append(
    createNoticeLanguageItem(
        '日本語',
        'ja'
    )
);

$noticeLangPanel.append(
    createNoticeLanguageItem(
        'English',
        'en'
    )
);


// ==================================================
// LANGクリック
// ==================================================

$noticeLang.on(
    'click',
    function (e) {

        e.preventDefault();
        e.stopPropagation();

        $noticeLangPanel
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
// MENUクリック
// ==================================================

$noticeMenu.on(
    'click',
    function (e) {

        e.preventDefault();
        e.stopPropagation();

        $noticeLangPanel.hide();

        if (
            window.StrayingUI &&
            window.StrayingUI.showMenu
        ) {

            window.StrayingUI.showMenu();
        }
    }
);


// ==================================================
// 画面へ追加
// ==================================================

$screen.append(
    $noticeLang
);

$screen.append(
    $noticeMenu
);

$screen.append(
    $noticeLangPanel
);

    // --------------------------------------------------
    // 本文コンテナ
    // --------------------------------------------------

    var $content = $('<div></div>');

    $content.css({
        position: 'absolute',
        left: '150px',
        top: '80px',
        width: '980px',
        height: '560px',
        boxSizing: 'border-box'
    });

    $screen.append($content);

    // --------------------------------------------------
    // 言語に応じて内容を書き直す
    // --------------------------------------------------

    function renderNotice() {

        $content.empty();

        // ==============================================
        // 音声案内
        // ==============================================

        var $audioBox = $('<div></div>');

        $audioBox.css({
            padding: '18px 26px',
            marginBottom: '30px',
            border:
                '1px solid rgba(230, 153, 72, 0.75)',
            borderRadius: '12px',
            background:
                'rgba(230, 153, 72, 0.08)'
        });

        var $audioTitle = $('<div></div>')
            .text(
                '🔊 ' +
                window.StrayingI18n.get(
                    'noticeAudioTitle'
                )
            )
            .css({
                fontSize: '22px',
                fontWeight: '500',
                marginBottom: '8px'
            });

        var $audioBody = $('<div></div>')
            .text(
                window.StrayingI18n.get(
                    'noticeAudioBody'
                )
            )
            .css({
                fontSize: '17px',
                lineHeight: '1.7',
                opacity: 0.9
            });

        $audioBox.append(
            $audioTitle,
            $audioBody
        );

        $content.append($audioBox);

        // ==============================================
        // タイトル
        // ==============================================

        var $title = $('<div></div>')
            .text(
                window.StrayingI18n.get(
                    'noticeTitle'
                )
            )
            .css({
                fontSize: '25px',
                fontWeight: '500',
                marginBottom: '18px'
            });

        $content.append($title);

        // オレンジライン
        $content.append(
            $('<div></div>').css({
                width: '72px',
                height: '2px',
                marginBottom: '22px',
                background: '#e69948'
            })
        );

        // ==============================================
        // 注意事項本文
        // ==============================================

        var $list = $('<div></div>');

        $list.css({
            fontSize: '18px',
            lineHeight: '1.75'
        });

        for (var i = 1; i <= 6; i++) {

            var $item = $('<div></div>')
                .text(
                    '・' +
                    window.StrayingI18n.get(
                        'noticeItem' + i
                    )
                )
                .css({
                    marginBottom: '8px'
                });

            $list.append($item);
        }

        $content.append($list);

        // ==============================================
        // 確認ボタン
        // ==============================================

        var $button = $('<div></div>')
            .addClass('straying-notice-button')
            .text(
                window.StrayingI18n.get(
                    'noticeButton'
                )
            )
            .css({
                position: 'absolute',
                left: '340px',
                top: '530px',
                width: '300px',
                height: '58px',

                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',

                boxSizing: 'border-box',

                backgroundImage:
                    'url("./data/image/button/modalselect_off.png")',
                backgroundSize: '100% 100%',
                backgroundRepeat: 'no-repeat',

                fontSize: '22px',
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

        $button.one(
            'click',
            function (e) {

                e.preventDefault();
                e.stopPropagation();

                TYRANO.kag.variable.sf.notice_version = 1;

if (TYRANO.kag.saveSystemVariable) {
    TYRANO.kag.saveSystemVariable();
}

$('#straying-notice-screen').remove();

TYRANO.kag.ftag.startTag(
    'jump',
    {
        storage: 'title.ks'
    }
);
            }
        );

        $content.append($button);
    }

    // 初回描画
    renderNotice();

    // ゲーム画面へ追加
    $base.append($screen);

})();

[endscript]

[s]