"""
Build v1/unit-kerja-detail.html and v1/unit-kerja-edit.html - real Detail/Edit
pages for Unit Kerja. Before this, the list's "eye"/"pencil" row actions
(built by customize_unit_kerja.py) opened a generic preview modal / went
nowhere, since no detail data existed for a single unit kerja record -
request supplied a full sample record (Universitas Sevima Testing - f,
kode 041008) to build real pages from instead. customize_unit_kerja.py's
build_action_cell() now links straight to these two pages (see that
script), so run this one FIRST (or re-run customize_unit_kerja.py after,
if it was already updated before these pages existed).

Explicit ask: "preview/UI-nya sama seperti Mitra" - so this reuses Mitra's
own page skeletons verbatim rather than inventing a new layout:
- v1/mitra-detail.html's chrome+card+info-grid+contact-table pattern for
  unit-kerja-detail.html
- v1/mitra-edit.html's focused edit-mode chrome (its own mini header with
  Back/Simpan, Table-of-Contents sidebar, mobile save bar - no app
  navbar/sidebar at all, unlike the detail page) for unit-kerja-edit.html

One deliberate deviation on the DETAIL page only: mitra-detail.html's own
navbar highlights "Mitra" and its <aside> sidebar lists Mitra's two tabs
(Detail Mitra / Daftar Kerjasama) - grafting that verbatim onto a Unit Kerja
page would leave the wrong nav section highlighted. So the navbar+sidebar
blocks are swapped for the ones already in v1/unit-kerja.html (which
correctly highlight "Data Referensi" and list Unit Kerja's own reference-data
siblings) instead of Mitra's. The edit page needs no such swap - its focused
chrome has no app sidebar to mismatch in the first place.

"Kontak tetap ada" (per request): the contact card/table is carried over
essentially unchanged (same sample contact, same Tambah/Hapus mechanics on
the edit page) - just its heading text swapped from "Mitra" to "Unit Kerja".

Every row in v1/unit-kerja.html's list links to this same single pair of
pages (the one sample record given) - the same accepted limitation Mitra's
own list already has (every row's eye icon there also points at the one
static mitra-detail.html, not per-id data).

Usage:
    python mockups/scripts/build_unit_kerja_detail_edit.py
"""
from pathlib import Path

from bs4 import BeautifulSoup, NavigableString

ROOT = Path(__file__).resolve().parents[2]
V1 = ROOT / "v1"

# The one sample record supplied - used to fill both pages' fields.
RECORD = {
    "kode": "041008",
    "nama": "Universitas Sevima Testing - f",
    "kategori": "Universitas",
    "parent": "",
    "standar_iku": "Badan Akreditasi Nasional Perguruan Tinggi",
    "kebutuhan_lulusan": "",
    "kelompok_jurusan": "",
    "tanggal_berdiri": "",
    "aktif": "Ya",
    "jenjang": "",
    "ketua_prodi": "0406026001 - Jack Johnson",
}

# (label, record key) - split across two columns same as mitra-detail.html's
# info grid (7 left / 7 right there; 6/5 here, same shape of pattern).
LEFT_FIELDS = [
    ("Kode Unit Kerja", "kode"), ("Nama Unit Kerja", "nama"),
    ("Kategori Unit Kerja", "kategori"), ("Parent Unit Kerja", "parent"),
    ("Standar IKU", "standar_iku"), ("Kebutuhan Lulusan", "kebutuhan_lulusan"),
]
RIGHT_FIELDS = [
    ("Kelompok Jurusan", "kelompok_jurusan"), ("Tanggal Berdiri", "tanggal_berdiri"),
    ("Apakah Aktif", "aktif"), ("Jenjang", "jenjang"), ("Ketua Prodi", "ketua_prodi"),
]


def make_info_column(soup, fields):
    col = soup.new_tag("div", **{"class": "row gx-1 gy-3"})
    for label, key in fields:
        c4 = soup.new_tag("div", **{"class": "col-4"})
        inner = soup.new_tag("div", **{"class": "d-flex gap-1 justify-content-between"})
        label_span = soup.new_tag("span", **{"class": "text-secondary"})
        label_span.string = label
        inner.append(label_span)
        colon = soup.new_tag("span")
        colon.string = ":"
        inner.append(colon)
        c4.append(inner)
        col.append(c4)

        c8 = soup.new_tag("div", **{"class": "col-8"})
        value_span = soup.new_tag("span")
        if RECORD[key]:
            value_span.string = RECORD[key]
        c8.append(value_span)
        col.append(c8)
    return col


def swap_asset_refs(soup, source_soup):
    """Favicon + header/footer logo <img src> - this page has no capture of
    its own, so it borrows unit-kerja.html's (same raw capture batch)."""
    icon = soup.find("link", rel="icon")
    src_icon = source_soup.find("link", rel="icon")
    if icon and src_icon:
        icon["href"] = src_icon["href"]

    for img in soup.find_all("img", alt="Example Campus Logo"):
        src_img = source_soup.find("img", alt="Example Campus Logo")
        if src_img:
            img["src"] = src_img["src"]
    for img in soup.find_all("img", alt="Logo SEVIMA"):
        src_img = source_soup.find("img", alt="Logo SEVIMA")
        if src_img:
            img["src"] = src_img["src"]


def build_detail_page():
    soup = BeautifulSoup((V1 / "mitra-detail.html").read_text(encoding="utf-8"), "lxml")
    unit_kerja_soup = BeautifulSoup((V1 / "unit-kerja.html").read_text(encoding="utf-8"), "lxml")

    soup.html["data-mockup-page-id"] = "unit-kerja/detail"
    soup.title.string = "SEVIMA Platform - Detail Unit Kerja"
    swap_asset_refs(soup, unit_kerja_soup)

    # Swap navbar + sidebar for unit-kerja.html's own (correct "Data
    # Referensi" active state + Unit Kerja's sibling list) - see module
    # docstring for why this can't just be Mitra's verbatim.
    navbar_wrap = soup.find("div", class_="p-md-3 py-md-0 px-xl-5 border-bottom shadow-sm bg-white")
    src_navbar_wrap = unit_kerja_soup.find("div", class_="p-md-3 py-md-0 px-xl-5 border-bottom shadow-sm bg-white")
    if navbar_wrap and src_navbar_wrap:
        navbar_wrap.replace_with(src_navbar_wrap)

    sidebar = soup.find("aside", id="sidebar")
    src_sidebar = unit_kerja_soup.find("aside", id="sidebar")
    if sidebar and src_sidebar:
        sidebar.replace_with(src_sidebar)

    # Breadcrumb: Home > Unit Kerja > Detail Unit Kerja
    breadcrumb = soup.find("ol", class_="breadcrumb")
    items = breadcrumb.find_all("li", class_="breadcrumb-item")
    items[1].find("a")["href"] = "unit-kerja.html"
    items[1].find("a").string = "Unit Kerja"
    items[2].string = "Detail Unit Kerja"

    soup.find("h4", class_="m-0").string = "Detail Unit Kerja"

    # Card header: title/subtitle/edit button.
    card_title = soup.find("h5", class_="m-0 text-wrap truncate-2")
    card_title.string = RECORD["nama"]
    card_subtitle = card_title.find_next("span", class_="fs-6 text-secondary")
    card_subtitle.string = "Detail informasi terkait data unit kerja dan kontak"
    edit_link = soup.find("a", class_="btn gap-2 d-md-flex btn-light")
    edit_link["href"] = "unit-kerja-edit.html"

    # Info grid: replace both columns' inner `.row.gx-1.gy-3` with Unit
    # Kerja's own fields (same two-column card-body> .row.gy-3 > .col-md-6
    # wrapper structure as mitra-detail.html).
    info_row = soup.find("div", class_="row gy-3")
    columns = info_row.find_all("div", class_="col-md-6", recursive=False)
    columns[0].find("div", class_="row gx-1 gy-3").replace_with(make_info_column(soup, LEFT_FIELDS))
    columns[1].find("div", class_="row gx-1 gy-3").replace_with(make_info_column(soup, RIGHT_FIELDS))

    # Contact table: left as-is ("Kontak tetap ada").

    for a in soup.find_all("a", href="mitra-detail.html"):
        a["href"] = "unit-kerja-detail.html"

    (V1 / "unit-kerja-detail.html").write_text(str(soup), encoding="utf-8")
    print("Wrote v1/unit-kerja-detail.html")


def make_edit_field(soup, label, key, kind="text", options=None, required=False):
    """One .form-group matching mitra-edit.html's own markup (label + input/
    select/date), pre-filled from RECORD."""
    value = RECORD[key]
    group = soup.new_tag("div", **{"class": "form-group col-md-6"})
    label_tag = soup.new_tag("label", **{"class": "form-label", "for": key})
    label_tag.append(NavigableString(label + " "))
    if required:
        star = soup.new_tag("span", **{"class": "text-danger"})
        star.string = "*"
        label_tag.append(star)
    group.append(label_tag)
    group.append(soup.new_tag("br"))

    # `name` collides with new_tag()'s own first positional parameter when
    # passed via **kwargs - must go through the explicit `attrs=` dict form.
    if kind == "select":
        select = soup.new_tag("select", attrs={
            "class": "form-select", "id": f"form-control-{key}", "name": key,
        })
        placeholder = soup.new_tag("option", value="")
        placeholder.string = f"Pilih {label}"
        select.append(placeholder)
        for opt in options or []:
            opt_tag = soup.new_tag("option", value=opt)
            if opt == value:
                opt_tag["selected"] = ""
            opt_tag.string = opt
            select.append(opt_tag)
        group.append(select)
    else:
        input_tag = soup.new_tag("input", attrs={
            "class": "form-control placeholder:text-gray-500",
            "id": f"form-control-{key}", "name": key,
            "type": "date" if kind == "date" else "text",
            "placeholder": f"Masukkan {label}" + ("" if required else " (opsional)"),
        })
        if value:
            input_tag["value"] = value
        group.append(input_tag)
    return group


def make_aktif_field(soup):
    group = soup.new_tag("div", **{"class": "form-group col-md-6"})
    label_tag = soup.new_tag("label", **{"class": "form-label", "for": "aktif"})
    label_tag.string = "Apakah Aktif "
    group.append(label_tag)
    group.append(soup.new_tag("br"))
    wrap = soup.new_tag("div")
    for value, text in (("Ya", "Ya"), ("Tidak", "Tidak")):
        check = soup.new_tag("div", **{"class": "form-check form-check-inline"})
        input_tag = soup.new_tag("input", attrs={
            "class": "form-check-input", "id": f"aktif_{value.lower()}",
            "name": "aktif", "type": "radio", "value": value,
        })
        if value == RECORD["aktif"]:
            input_tag["checked"] = ""
        check.append(input_tag)
        check_label = soup.new_tag("label", **{"class": "form-check-label", "for": f"aktif_{value.lower()}"})
        check_label.string = text
        check.append(check_label)
        wrap.append(check)
    group.append(wrap)
    return group


def build_edit_page():
    soup = BeautifulSoup((V1 / "mitra-edit.html").read_text(encoding="utf-8"), "lxml")
    unit_kerja_soup = BeautifulSoup((V1 / "unit-kerja.html").read_text(encoding="utf-8"), "lxml")

    soup.html["data-mockup-page-id"] = "unit-kerja/edit"
    soup.title.string = "SEVIMA Platform - Edit Unit Kerja"
    swap_asset_refs(soup, unit_kerja_soup)

    # mitra-edit.html turns out to carry the full app header+navbar too
    # (just no <aside> sidebar, unlike mitra-detail.html) - same "wrong nav
    # section highlighted" problem as the detail page, same fix: swap in
    # unit-kerja.html's own navbar block instead of Mitra's.
    navbar_wrap = soup.find("div", class_="p-md-3 py-md-0 px-xl-5 border-bottom shadow-sm bg-white")
    src_navbar_wrap = unit_kerja_soup.find("div", class_="p-md-3 py-md-0 px-xl-5 border-bottom shadow-sm bg-white")
    if navbar_wrap and src_navbar_wrap:
        navbar_wrap.replace_with(src_navbar_wrap)

    for a in soup.find_all("a", href="mitra-detail.html"):
        a["href"] = "unit-kerja-detail.html"

    # Breadcrumbs (desktop "opacity-0" ghost one + mobile one) repeat
    # "Mitra"/"Edit Mitra"/"Edit" - relabel every occurrence rather than
    # hunting each one individually.
    for li in soup.find_all("li", class_=lambda c: c and "breadcrumb-item" in c):
        text = li.get_text(strip=True)
        if text == "Mitra":
            li.string = "Unit Kerja"
        elif text == "Edit Mitra":
            li.string = "Edit Unit Kerja"
    for h4 in soup.find_all("h4", class_="m-0"):
        if h4.get_text(strip=True) == "Edit Mitra":
            h4.string = "Edit Unit Kerja"
    for a in soup.find_all("a", class_="qn-toc-item"):
        text = a.get_text(strip=True)
        if text == "Informasi Mitra":
            a.string = "Informasi Unit Kerja"
        elif text == "Informasi Kontak Mitra":
            a.string = "Informasi Kontak Unit Kerja"

    # Card 1: Informasi Mitra -> Informasi Unit Kerja, fields replaced.
    info_card = soup.find("div", id="informasi-mitra")
    info_card["id"] = "informasi-unit-kerja"
    info_card.find("h5", class_="mb-0").string = "Informasi Unit Kerja"
    fields_row = info_card.find("div", class_="row row-cols-1 row-cols-md-3 g-3")
    new_fields_row = soup.new_tag("div", **{"class": "row row-cols-1 row-cols-md-3 g-3"})
    new_fields_row.append(make_edit_field(soup, "Kode Unit Kerja", "kode", required=True))
    new_fields_row.append(make_edit_field(soup, "Nama Unit Kerja", "nama", required=True))
    new_fields_row.append(make_edit_field(
        soup, "Kategori Unit Kerja", "kategori", kind="select",
        options=["Universitas", "Fakultas", "Program Studi", "Unit Non Akademik"], required=True,
    ))
    new_fields_row.append(make_edit_field(soup, "Parent Unit Kerja", "parent", kind="select", options=[]))
    new_fields_row.append(make_edit_field(
        soup, "Standar IKU", "standar_iku", kind="select",
        options=["Badan Akreditasi Nasional Perguruan Tinggi"],
    ))
    new_fields_row.append(make_edit_field(soup, "Kebutuhan Lulusan", "kebutuhan_lulusan"))
    new_fields_row.append(make_edit_field(soup, "Kelompok Jurusan", "kelompok_jurusan", kind="select", options=[]))
    new_fields_row.append(make_edit_field(soup, "Tanggal Berdiri", "tanggal_berdiri", kind="date"))
    new_fields_row.append(make_aktif_field(soup))
    new_fields_row.append(make_edit_field(soup, "Jenjang", "jenjang", kind="select", options=[]))
    new_fields_row.append(make_edit_field(soup, "Ketua Prodi", "ketua_prodi"))
    fields_row.replace_with(new_fields_row)

    # Card 2: Informasi Kontak Mitra -> ...Unit Kerja - heading only,
    # contact fields/mechanics left as-is ("Kontak tetap ada").
    contact_card = soup.find("div", id="informasi-kontak-mitra")
    contact_card["id"] = "informasi-kontak-unit-kerja"
    contact_card.find("h5", class_="mb-0").string = "Informasi Kontak Unit Kerja"

    (V1 / "unit-kerja-edit.html").write_text(str(soup), encoding="utf-8")
    print("Wrote v1/unit-kerja-edit.html")


if __name__ == "__main__":
    build_detail_page()
    build_edit_page()
    print("Note: v1/unit-kerja.html's own eye/edit action links are built "
          "directly by customize_unit_kerja.py (not this script) - re-run "
          "that one too if it hasn't already been updated to link here.")
