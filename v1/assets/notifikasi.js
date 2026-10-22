// Komponen Notifikasi (lonceng + dropdown) dan badge counter menu Validasi Kerjasama.
// Mockup scaffolding - FOX-1231 (Notifikasi) & FOX-1232 (Counter Validasi Kerjasama).
//
// Pola mengacu ke dropdown_notification Quantum-3 (dipakai modul DMS,
// Modules/DMS/.../outer/header.blade.php): header (judul + "tandai semua dibaca"),
// tab, body bergrup per hari (judul grup + item: ikon, teks tebal, waktu - sumber),
// footer ("lihat semua notifikasi" + ikon pengaturan). CSS kelas `notification__*`
// milik Quantum-3 tidak ikut bundle QUANTUM v2 yang dipakai mockup, jadi pola yang
// sama dibangun ulang dengan komponen Bootstrap/QUANTUM + token --bs-*.
//
// State via query string (untuk capture desain / review):
//   ?notif=kosong      -> dropdown tanpa notifikasi (empty state, badge lonceng hilang)
//   ?notif=dibaca      -> ada notifikasi, semuanya sudah dibaca (badge hilang)
//   ?counter=0|3|12|120 -> angka badge Validasi Kerjasama (0 = disembunyikan, >99 tampil 99+)
(function () {
    var SAMPLE = [
        { id: 1, type: 'validasi',    unread: true,  group: 'Hari Ini',   html: 'Pengajuan kerjasama <b>PT Teknologi Nusantara</b> menunggu validasi Anda', time: '2 jam lalu', src: 'Validasi Kerjasama' },
        { id: 2, type: 'kedaluwarsa', unread: true,  group: 'Hari Ini',   html: 'Kerjasama <b>MoU Universitas Gadjah Mada</b> akan kedaluwarsa dalam 30 hari', time: '5 jam lalu', src: 'Status Kerjasama' },
        { id: 3, type: 'reminder',    unread: true,  group: 'Kemarin',    html: 'Pengingat perpanjangan: <b>PKS RS Sevima Sehat</b> berakhir 14 hari lagi', time: 'Kemarin, 09.12', src: 'Perpanjangan' },
        { id: 4, type: 'disetujui',   unread: false, group: 'Kemarin',    html: 'Pengajuan <b>PKS PT Karya Mandiri</b> disetujui oleh Validator', time: 'Kemarin, 08.30', src: 'Validasi Kerjasama' },
        { id: 5, type: 'ditolak',     unread: false, group: 'Sebelumnya', html: 'Pengajuan <b>MoA Dinas Pendidikan</b> ditolak. Lihat alasan penolakan', time: '3 hari lalu', src: 'Validasi Kerjasama' }
    ];
    var TYPES = {
        validasi:    { icon: 'sym-check-square',     tone: 'primary' },
        kedaluwarsa: { icon: 'sym-clock-fast-forward', tone: 'warning' },
        reminder:    { icon: 'sym-clock-refresh',    tone: 'info' },
        disetujui:   { icon: 'sym-check-circle',     tone: 'success' },
        ditolak:     { icon: 'sym-alert-circle',     tone: 'danger' }
    };

    var css = '' +
        '#qn-notif-menu{right:0;left:auto;top:calc(100% + 8px);border-radius:12px;border:1px solid var(--bs-border-color);box-shadow:0 8px 24px rgba(16,24,40,.18)}' +
        '.qn-notif{width:380px;max-width:calc(100vw - 24px);background:var(--bs-body-bg);color:var(--bs-body-color);font-size:.875rem}' +
        '.qn-notif__header{padding:16px 16px 0}' +
        '.qn-notif__title{font-size:1rem;font-weight:600;margin:0}' +
        '.qn-notif__readall{background:none;border:0;padding:0;color:var(--bs-primary);font-size:.8125rem;font-weight:500;cursor:pointer}' +
        '.qn-notif__readall:disabled{color:var(--bs-secondary-color);cursor:default}' +
        '.qn-notif__tabs{display:flex;gap:4px;margin:12px 16px 0;border-bottom:1px solid var(--bs-border-color)}' +
        '.qn-notif__tab{background:none;border:0;border-bottom:2px solid transparent;padding:8px 8px;margin-bottom:-1px;font-weight:500;color:var(--bs-secondary-color);cursor:pointer}' +
        '.qn-notif__tab.is-active{color:var(--bs-primary);border-bottom-color:var(--bs-primary)}' +
        '.qn-notif__count{display:inline-block;margin-left:4px;padding:0 6px;border-radius:999px;font-size:.6875rem;background:var(--bs-primary-bg-subtle);color:var(--bs-primary-text-emphasis)}' +
        '.qn-notif__body{max-height:380px;overflow:auto}' +
        '.qn-notif__group{padding:12px 16px 4px;font-size:.6875rem;font-weight:600;letter-spacing:.04em;text-transform:uppercase;color:var(--bs-secondary-color)}' +
        '.qn-notif__item{display:flex;gap:12px;align-items:flex-start;padding:12px 16px;text-decoration:none;color:inherit;border-top:1px solid transparent}' +
        '.qn-notif__item:hover{background:var(--bs-tertiary-bg);color:inherit}' +
        '.qn-notif__item.is-unread{background:var(--bs-primary-bg-subtle)}' +
        '.qn-notif__item.is-unread:hover{background:var(--bs-primary-border-subtle)}' +
        '.qn-notif__ico{width:36px;height:36px;border-radius:50%;display:flex;align-items:center;justify-content:center;flex:none;font-size:1.125rem}' +
        '.qn-notif__text{display:block;line-height:1.4;color:var(--bs-emphasis-color)}' +
        '.qn-notif__muted{display:block;margin-top:2px;font-size:.75rem;color:var(--bs-secondary-color)}' +
        '.qn-notif__dot{width:8px;height:8px;border-radius:50%;background:var(--bs-primary);flex:none;margin-top:6px}' +
        '.qn-notif__empty{padding:40px 24px;text-align:center;color:var(--bs-secondary-color)}' +
        '.qn-notif__empty i{font-size:2.25rem;display:block;margin-bottom:8px}' +
        '.qn-notif__empty strong{display:block;color:var(--bs-emphasis-color);font-size:.9375rem;margin-bottom:4px}' +
        '.qn-notif__footer{display:flex;align-items:center;justify-content:space-between;padding:10px 16px;border-top:1px solid var(--bs-border-color)}' +
        '.qn-notif__footer a{font-weight:500;text-decoration:none}' +
        '.qn-notif__panel{background:var(--bs-body-bg);border:1px solid var(--bs-border-color);border-radius:12px;box-shadow:0 8px 24px rgba(16,24,40,.12);overflow:hidden;display:inline-block}' +
        '.qn-bell-badge{font-size:.625rem!important;min-width:18px;padding:3px 5px!important}' +
        '.qn-counter{font-size:.6875rem;font-weight:600;vertical-align:text-top;margin-left:4px}';
    var st = document.createElement('style'); st.textContent = css; document.head.appendChild(st);

    function params() { try { return new URLSearchParams(location.search); } catch (e) { return new URLSearchParams(''); } }
    function fmt(n) { return n > 99 ? '99+' : String(n); }
    function esc(s) { return String(s).replace(/[&<>"]/g, function (c) { return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c]; }); }

    function panelHTML(items, tab) {
        var unread = items.filter(function (i) { return i.unread; });
        var list = tab === 'unread' ? unread : items;
        var body;
        if (!items.length) {
            // State kosong: tidak ada notifikasi sama sekali.
            body = '<div class="qn-notif__empty"><i class="sym sym-bell-off-02"></i><strong>Tidak ada notifikasi</strong>Notifikasi terkait validasi dan status kerjasama akan muncul di sini.</div>';
        } else if (!list.length) {
            body = '<div class="qn-notif__empty"><i class="sym sym-check-circle"></i><strong>Semua sudah dibaca</strong>Tidak ada notifikasi yang belum dibaca.</div>';
        } else {
            var last = null; body = '';
            list.forEach(function (n) {
                if (n.group !== last) { body += '<div class="qn-notif__group">' + esc(n.group) + '</div>'; last = n.group; }
                var t = TYPES[n.type];
                body += '<a class="qn-notif__item' + (n.unread ? ' is-unread' : '') + '" data-notif-id="' + n.id + '" href="#">' +
                    '<span class="qn-notif__ico bg-' + t.tone + '-subtle text-' + t.tone + '"><i class="sym ' + t.icon + '"></i></span>' +
                    '<span class="flex-grow-1"><span class="qn-notif__text">' + n.html + '</span><span class="qn-notif__muted">' + esc(n.time) + ' - ' + esc(n.src) + '</span></span>' +
                    (n.unread ? '<span class="qn-notif__dot" title="Belum dibaca"></span>' : '') + '</a>';
            });
        }
        return '<div class="qn-notif">' +
            '<div class="qn-notif__header d-flex align-items-center justify-content-between"><h3 class="qn-notif__title">Notifikasi</h3>' +
            '<button class="qn-notif__readall" data-notif-readall type="button"' + (unread.length ? '' : ' disabled') + '>Tandai semua dibaca</button></div>' +
            '<div class="qn-notif__tabs"><button class="qn-notif__tab' + (tab !== 'unread' ? ' is-active' : '') + '" data-notif-tab="all" type="button">Semua</button>' +
            '<button class="qn-notif__tab' + (tab === 'unread' ? ' is-active' : '') + '" data-notif-tab="unread" type="button">Belum Dibaca' + (unread.length ? '<span class="qn-notif__count">' + unread.length + '</span>' : '') + '</button></div>' +
            '<div class="qn-notif__body">' + body + '</div>' +
            '<div class="qn-notif__footer"><a href="#">Lihat semua notifikasi</a><a aria-label="Pengaturan notifikasi" href="#"><i class="sym sym-settings"></i></a></div></div>';
    }

    // mount: render panel ke root & pasang interaksi. onChange(items) dipanggil tiap ada perubahan baca/belum.
    function mount(root, items, onChange) {
        var tab = 'all';
        function draw() { root.innerHTML = panelHTML(items, tab); if (onChange) onChange(items); }
        root.addEventListener('click', function (e) {
            var t = e.target.closest('[data-notif-tab]'), r = e.target.closest('[data-notif-readall]'), it = e.target.closest('[data-notif-id]');
            if (t) { tab = t.dataset.notifTab; draw(); e.stopPropagation(); }
            else if (r) { items.forEach(function (n) { n.unread = false; }); draw(); }
            else if (it) {
                e.preventDefault();
                items.forEach(function (n) { if (String(n.id) === it.dataset.notifId) n.unread = false; }); draw();
            }
        });
        draw();
    }

    function initialItems() {
        var s = params().get('notif');
        if (s === 'kosong') return [];
        return SAMPLE.map(function (n) { var c = {}; for (var k in n) c[k] = n[k]; if (s === 'dibaca') c.unread = false; return c; });
    }

    function setBadge(el, n) {
        if (!el) return;
        el.textContent = fmt(n);
        el.classList.toggle('d-none', n <= 0);
    }

    // Lonceng di header (semua halaman).
    var host = document.getElementById('qn-notif-menu');
    var bell = document.querySelector('[data-qn-notif-badge]');
    if (host) {
        mount(host, initialItems(), function (items) {
            setBadge(bell, items.filter(function (n) { return n.unread; }).length);
        });
    }

    // Badge counter menu Validasi Kerjasama: angka pengajuan menunggu validasi; 0 = disembunyikan.
    // NOTE (developer): angka diisi server (jumlah tahap_validasi berstatus 'menunggu' milik unit user); >99 ditampilkan "99+".
    var c = params().get('counter');
    var count = c === null ? 3 : parseInt(c, 10) || 0;
    document.querySelectorAll('[data-qn-counter]').forEach(function (el) { setBadge(el, count); });

    window.QnNotif = { sample: function () { return initialItems(); }, samples: SAMPLE, mount: mount, panelHTML: panelHTML, fmt: fmt };
})();
