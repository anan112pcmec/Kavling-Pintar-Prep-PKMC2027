// ============================================================
//  KAVLING PINTAR — Paper gambaran besar sistem
//  Compile: typst compile kavling-pintar.typ
//  Ganti placeholder foto dengan: foto("Caption", isi: image("foto/nama-file.jpg", width: 100%))
// ============================================================

// ---------- Konfigurasi dasar ----------

#let judul = "Kavling Pintar"
#let penulis = "Faiz Hannan Hakim"
#let versi = "Draf Kv-001"

// Palet warna (satu aksen saja supaya tetap rapi)
#let accent = rgb("#2E6B3F")
#let accent-soft = accent.lighten(90%)
// Warna sekunder: oker/amber (cahaya matahari), pasangan hangat untuk hijau
#let accent2 = rgb("#B8741A")
#let accent2-soft = accent2.lighten(88%)
#let ink = luma(30)
#let muted = luma(110)

#let bulan = (
  "Januari", "Februari", "Maret", "April", "Mei", "Juni",
  "Juli", "Agustus", "September", "Oktober", "November", "Desember",
)
#let tanggal = {
  let d = datetime.today()
  [#d.day() #bulan.at(d.month() - 1) #d.year()]
}

#set document(title: judul, author: penulis)
#set page(
  paper: "a4",
  margin: (x: 2.5cm, top: 2.8cm, bottom: 2.5cm),
  header: [
    #set text(size: 9pt, fill: muted)
    #judul #h(1fr) #versi
    #v(-0.55em)
    #line(length: 100%, stroke: 0.4pt + luma(200))
  ],
  footer: context [
    #set text(size: 9pt, fill: muted)
    #align(center, counter(page).display())
  ],
)
#set text(font: "New Computer Modern", size: 11pt, lang: "id", fill: ink)
#set par(justify: true, leading: 0.7em, spacing: 1.1em)

// ---------- Heading ----------

#set heading(numbering: "1.1.1")
#show heading.where(level: 1): set text(size: 16pt, fill: accent)
#show heading.where(level: 2): set text(size: 13pt, fill: accent)
#show heading.where(level: 3): set text(size: 11.5pt, fill: accent)
#show heading.where(level: 1): it => block(
  width: 100%,
  above: 2em,
  below: 1em,
  stroke: (bottom: 1pt + gradient.linear(
    (accent2, 0%), (accent2, 12%), (accent, 12%), (accent, 100%),
  )),
  inset: (bottom: 5pt),
  it,
)
#show heading.where(level: 2): set block(above: 1.6em, below: 0.8em)
#show heading.where(level: 3): set block(above: 1.2em, below: 0.6em)

// ---------- Figure & tabel ----------

#show figure: set block(breakable: false, above: 1.2em, below: 1.2em)
#show figure.caption: it => context {
  set text(size: 9.5pt, fill: muted)
  text(weight: "bold", fill: accent2)[#it.supplement #it.counter.display(it.numbering)]
  it.separator
  it.body
}
#set figure.caption(separator: [. ])
#show figure.where(kind: table): set figure.caption(position: top)
#show table: set par(justify: false)

// ---------- Helper ----------

// Placeholder foto: nanti isi `isi:` dengan image(...)
#let foto(caption, h: 5cm, isi: none) = figure(
  kind: image,
  supplement: [Gambar],
  if isi == none {
    rect(
      width: 100%,
      height: h,
      radius: 3pt,
      stroke: (paint: luma(170), dash: "dashed"),
      fill: luma(247),
    )[
      #align(center + horizon, text(fill: muted, size: 10pt)[Tempat foto komponen])
    ]
  } else { isi },
  caption: caption,
)

// Daftar poin dalam sel tabel
#let lst(..items) = {
  let xs = items.pos()
  if xs.len() == 0 [—] else {
    list(
      tight: true,
      marker: text(fill: accent2)[•],
      indent: 0pt,
      body-indent: 6pt,
      ..xs,
    )
  }
}

#let tbd = text(fill: muted, style: "italic")[Belum ditentukan]

// Tabel dengan baris header (gaya garis horizontal saja)
#let tabel(columns: (auto, 1fr), align: left, ..rows) = table(
  columns: columns,
  align: align,
  inset: (x: 8pt, y: 7pt),
  stroke: (x, y) => (
    top: if y == 0 { 1pt + accent } else { none },
    bottom: if y == 0 { 1pt + accent2 } else { 0.4pt + luma(215) },
  ),
  fill: (x, y) => if y == 0 { accent-soft } else { none },
  ..rows,
  table.hline(stroke: 1pt + accent),
)

// Tabel label-isi (kolom pertama = label)
#let tbl(..rows) = block(breakable: false, table(
  columns: (4cm, 1fr),
  align: left,
  inset: (x: 8pt, y: 7pt),
  stroke: (x, y) => (
    top: if y == 0 { 1pt + accent } else { none },
    bottom: 0.4pt + luma(215),
  ),
  fill: (x, y) => if x == 0 { accent-soft } else { none },
  ..rows,
  table.hline(stroke: 1pt + accent),
))

// Poin 1
#let tjn(masalah, goal) = tbl(
  [*Masalah*], masalah,
  [*Goal*], goal,
)

// Poin 3
#let teknis(param, deteksi, pasif, reaktif) = tbl(
  [*Parameter ideal*], param,
  [*Pendeteksian*], deteksi,
  [*Aksi pasif*], pasif,
  [*Aksi reaktif*], reaktif,
)

// ---------- Template satu bagian sistem ----------
// Tiap bagian: 1) Masalah dan Goal  2) Penjelasan Visual
//              3) Teknis Bagian     4) Penjelasan Komponen
//                 (penjelasan -> teknis komponen -> bahan komponen)

// Judul poin bernomor 1-4 (di-reset di setiap bagian)
#let poin(judul) = {
  counter("poin").step()
  block(above: 1.3em, below: 0.6em, sticky: true)[
    #context text(weight: "bold", fill: accent2)[#counter("poin").display().]
    #text(weight: "bold")[#judul]
  ]
}

// Sub-label di dalam poin 4 (jangan dinamai `sub`, bentrok dengan subskrip H#sub[2]O)
#let sublabel(judul) = block(above: 1em, below: 0.5em, sticky: true)[
  #text(fill: accent2, weight: "bold")[›] #text(weight: "bold", style: "italic")[#judul]
]

// Poin 4: satu komponen (nama opsional kalau satu bagian punya beberapa komponen)
#let komponen(nama: none, penjelasan, teknis, bahan) = {
  if nama != none {
    block(above: 1em, below: 0.4em, sticky: true, text(weight: "bold", fill: accent)[#nama])
  }
  penjelasan
  sublabel[Teknis komponen]
  teknis
  sublabel[Bahan komponen]
  bahan
}

#let bagian(masalah-goal, visual, teknis-bagian, komponen-bagian) = {
  counter("poin").update(0)
  poin[Masalah dan Goal]
  masalah-goal
  poin[Penjelasan Visual]
  block(breakable: false, visual)
  poin[Teknis Bagian]
  teknis-bagian
  poin[Penjelasan Komponen]
  komponen-bagian
}

// Kartu ciri fisik tanaman
#let ciri(judul, ket) = block(
  stroke: (left: 2.5pt + accent2),
  inset: (left: 9pt, y: 3pt),
)[
  *#judul* \
  #text(size: 9.5pt, fill: muted)[#ket]
]

// ============================================================
//  SAMPUL
// ============================================================

#page(header: none, footer: none, margin: (x: 3cm, y: 3cm))[
  #set par(justify: false)
  #text(size: 10pt, weight: "bold", fill: accent2, tracking: 2pt)[DOKUMEN RANCANGAN SISTEM]
  #v(1fr)
  #text(size: 40pt, weight: "bold")[#judul]
  #v(0.5em)
  #stack(
    dir: ltr,
    line(length: 2.6cm, stroke: 3pt + accent),
    line(length: 1.2cm, stroke: 3pt + accent2),
  )
  #v(0.8em)
  #text(size: 15pt, fill: luma(70))[Rancangan Sistem Kavling Otomatis \ untuk Perawatan Tanaman]
  #v(1fr)
  #grid(
    columns: (2.6cm, 1fr),
    row-gutter: 0.8em,
    text(fill: muted)[Penulis], penulis,
    text(fill: muted)[Versi], versi,
    text(fill: muted)[Tanggal], tanggal,
  )
]
#counter(page).update(1)

// ============================================================
//  ABSTRAK & DAFTAR ISI
// ============================================================

#block(
  width: 100%,
  fill: accent-soft,
  radius: (right: 3pt),
  stroke: (left: 3pt + accent2),
  inset: (x: 0.9cm, y: 0.7cm),
)[
  #text(weight: "bold", fill: accent)[Abstrak]
  #v(0.3em)
  #set text(size: 10.5pt)
  Kavling Pintar adalah rancangan kavling yang berisi tanaman beserta pot-potnya
  dan bertugas merawat tanaman tersebut secara mandiri. Kavling dirancang untuk
  memanfaatkan sumber daya di sekitarnya, seperti cahaya matahari, udara luar,
  dan air, seefisien mungkin. Sistem terdiri dari tiga bagian besar: kavling
  (atap, badan, dan pot), box suplai bahan, dan box antarmuka pengguna. Setiap bagian dijelaskan dengan format NTK (_Need To Know_), yaitu
  komponen, parameter ideal, pendeteksian, aksi pasif, aksi reaktif, tujuan,
  dan atribut elektronik. Dokumen ini adalah gambaran besar; foto komponen
  dan nilai parameter akan dilengkapi pada tahap berikutnya.
  #v(0.4em)
  #text(size: 9.5pt)[#text(fill: accent2, weight: "bold")[Kata kunci:] kavling pintar, otomasi tanaman, sensor, IoT]
]

#v(0.8cm)
#show outline.entry.where(level: 1): it => {
  v(0.5em, weak: true)
  strong(it)
}
#outline(title: "Daftar Isi", indent: 1.2em, depth: 3)
#pagebreak()

// ============================================================
//  ISI
// ============================================================

= Pendahuluan

== Latar Belakang

Merawat tanaman membutuhkan perhatian rutin: menyiram, memberi pupuk,
menjaga kelembapan dan keasaman tanah, mengatur suhu dan sirkulasi udara,
serta melindungi tanaman dari hujan dan paparan matahari yang berlebihan.
Kavling Pintar mencoba mengotomatiskan pekerjaan tersebut dalam satu sistem
tertutup yang dapat membaca kondisi lingkungan dan bereaksi terhadapnya.

== Deskripsi Singkat

Kavling Pintar adalah kavling yang di dalamnya diletakkan tanaman beserta
pot-potnya. Kavling bertugas memelihara tanaman di dalamnya dan harus pandai
memanfaatkan sumber daya di sekitarnya seefisien mungkin.

== NTK (_Need To Know_)

Setiap bagian sistem dijelaskan dengan tujuh elemen pada @tbl-ntk.

#figure(
  kind: table,
  supplement: [Tabel],
  caption: [Tujuh elemen NTK],
  tabel(
    columns: (4cm, 1fr),
    [*Elemen*], [*Pengertian*],
    [Component], [Komponen yang bertugas atas suatu hal.],
    [Parameter Ideal], [Parameter yang nanti ditentukan di dalam program.],
    [Pendeteksian], [Pembacaan dinamika lingkungan yang dijadikan parameter penilaian.],
    [Aksi Pasif], [Aksi yang pasti dilakukan tanpa bergantung pada pendeteksian parameter.],
    [Aksi Reaktif], [Aksi yang merupakan hasil keputusan dari pendeteksian parameter.],
    [Goal], [Tujuan dari bagian yang dimaksud.],
    [Attributes Electronic], [Komponen robotik yang digunakan oleh component.],
  ),
) <tbl-ntk>

#pagebreak(weak: true)

= Tanaman Target

Tanaman target kavling adalah tanaman yang tidak membutuhkan tanah terlalu
dalam dan tidak tumbuh terlalu tinggi menjulang. Semuanya adalah tanaman
sayuran daun (hortikultura semusim):

#let tanaman = (
  ("Sawi", "Brassica juncea", "jpeg"),
  ("Bayam", "Amaranthus tricolor", "jpg"),
  ("Kangkung", "Ipomoea aquatica", "jpg"),
  ("Selada", "Lactuca sativa", "jpg"),
  ("Kailan", "Brassica oleracea var. alboglabra", "jpg"),
  ("Pakcoy", "Brassica rapa subsp. chinensis", "jpg"),
)

#block(breakable: false, grid(
  columns: (1fr, 1fr, 1fr),
  column-gutter: 1em,
  row-gutter: 1em,
  ..tanaman.enumerate(start: 1).map(((i, t)) => {
    let (nama, ilmiah, ext) = t
    align(center)[
      #box(clip: true, radius: 3pt)[
        #image("foto/" + lower(nama) + "." + ext, width: 100%, height: 3cm, fit: "stretch")
      ]
      #v(0.2em)
      *#i. #nama* \
      #text(size: 9.5pt, emph(ilmiah))
    ]
  }),
))

#v(0.6em)

Dengan demikian, kavling pintar akan merawat tanaman dengan ciri fisik berikut:

#v(0.3em)

#block(breakable: false, grid(
  columns: (1fr, 1fr),
  column-gutter: 2em,
  row-gutter: 1em,
  ciri([Batang pendek dan lunak], [Tidak berkayu dan bertekstur basah/berair]),
  ciri([Kanopi rendah dan mendatar], [Tumbuh melebar ke samping, tidak menjulang]),
  ciri([Dominasi daun rimbun], [Fokus visual pada helai daun yang lebat]),
  ciri([Akar di permukaan tanah], [Berupa perakaran serabut yang dangkal]),
))

#pagebreak(weak: true)

= Gambaran Sistem

Kavling Pintar terdiri dari tiga bagian besar: *kavling*, *box penyedia sumber
daya kavling* (Kavling Source Supply), dan *box interface data kavling*
(Kavling Interface). Kavling sendiri dibagi menjadi tiga bagian: atap kavling
yang melindungi tanaman dari lingkungan luar, badan kavling (sisi-sisi
kavling) yang melindungi tanaman dari kondisi luar yang tidak terprediksi
sekaligus mengatur suhu di dalam kavling, dan pot kavling yang mengondisikan
keadaan tanah. Box suplai menyediakan bahan-bahan pendukung, dan box
antarmuka menyampaikan informasi kepada pengamat (@tbl-bagian).

== Sistem Kavling

Bagian ini memaparkan bagaimana sistem kavling tersusun, beserta skema teknis
dan rancangan skematiknya.

#figure(
  kind: table,
  supplement: [Tabel],
  caption: [Pembagian bagian sistem Kavling Pintar],
  tabel(
    columns: (auto, 1fr, 1fr, 1.2fr),
    align: (center, left, left, left),
    [*No*], [*Kelompok*], [*Bagian*], [*Padanan NTK*],
    [1], [Kavling], [Atap Kavling], [Kavling ke Lingkungan Luar],
    [2], [Kavling], [Badan Kavling], [Kavling ke Lingkungan Internal],
    [3], [Kavling], [Pot Kavling], [Kavling Pot ke Tanaman],
    [4], [Box penyedia sumber daya], [Box di samping kavling], [Kavling Source Supply],
    [5], [Box interface data], [Box interface di samping kavling], [Kavling Interface ke User],
  ),
) <tbl-bagian>

#grid(
  columns: (1fr, 1fr),
  column-gutter: 1em,
  foto(
    "Tampak penuh Kavling",
    isi: image("foto/Tampak_Full.png", width: 100%, height: 5.5cm, fit: "contain"),
  ),
  foto(
    "Tampak rangka Kavling",
    isi: image("foto/Tampak_Rangka.png", width: 100%, height: 5.5cm, fit: "contain"),
  ),
)

Gambar di atas adalah rancangan bentuk kavling secara garis besar. Ukuran,
volume, dan skematik teknis kavling dirinci pada bagian berikutnya.

#foto(
  "Kavling Luar",
  isi: image("foto/Skematik_Kavling_Luar.png", width: 100%, height: 6cm, fit: "contain"),
)

=== Atap Kavling (Kavling ke Lingkungan Luar)

#bagian(
  tjn(
    [Tanaman di dalam kavling terancam hujan dan flux matahari yang terlalu tinggi.],
    [Menjaga tanaman di dalam kavling dari gangguan lingkungan luar (hujan, indeks matahari tinggi).],
  ),
  grid(
    columns: (1fr, 1fr),
    column-gutter: 1em,
    foto("Atap kavling", h: 4.5cm),
    foto("Geared DC motor dan sensor infrared", h: 4.5cm),
  ),
  teknis(
    lst([Flux matahari]),
    lst([Flux matahari / intensitas cahaya], [Air hujan]),
    lst([Buka-tutup atap kavling pada pagi hari, pukul 07:00 – 09:00]),
    lst([Buka-tutup atap kavling saat hujan atau saat flux UV matahari terlalu tinggi]),
  ),
  komponen(
    tbd,
    tbd,
    lst([Geared DC motor], [Sensor infrared #sym.times 2]),
  ),
)

=== Badan Kavling (Kavling ke Lingkungan Internal)

#bagian(
  tjn(
    [Kualitas udara di dalam kavling harus dijaga agar tanaman tumbuh baik.],
    [Membuat lingkungan udara yang ideal sesuai parameter ideal.],
  ),
  foto("Sisi-sisi kavling", h: 5cm),
  teknis(
    lst([Suhu], [Kadar oksigen], [Kadar karbon dioksida]),
    lst([Suhu], [Kadar oksigen (malam)], [Kadar karbon dioksida (siang)], [Kelembapan udara]),
    lst(
      [Penyemprotan air pada jam-jam tertentu sesuai program],
      [Penyemprotan pestisida pada jam-jam tertentu sesuai program],
    ),
    lst(
      [Memasukkan udara dari lingkungan luar ke internal kavling],
      [Penyesuaian kadar oksigen / karbon dioksida],
      [Penyesuaian kelembapan udara],
      [Penyaluran gas karbon dioksida saat jam-jam efektif flux matahari],
      [Penyaluran gas oksigen saat kadar oksigen kurang pada malam hari],
    ),
  ),
  komponen(
    tbd,
    [
      #figure(
        kind: table,
        supplement: [Tabel],
        caption: [Rancangan geometri dan struktur kavling dalam],
        tabel(
          columns: (auto, 1fr, 2fr),
          align: (center, center, left),
          [*No*], [*Keterangan*], [*Nilai*],
          [1], [Dimensi], [266 (panjang) #sym.times 186 (lebar) #sym.times 120 (tinggi) cm],
          [2], [Keliling], [904 cm],
          [3], [Volume], [5.937.120 cm#super[3]],
        ),
      ) <tbl-geometri>
    ],
    tbd,
  ),
)

=== Pot Kavling (Kavling ke Tanaman)

#bagian(
  tjn(
    [Kondisi tanah di dalam pot harus sesuai kebutuhan tanaman.],
    [Membuat lingkungan tanah yang ideal sesuai parameter ideal.],
  ),
  foto("Pot tanaman dan sensor tanah", h: 5cm),
  teknis(
    lst([pH tanah], [Kelembapan tanah / kadar air tanah]),
    lst([pH tanah], [Kelembapan tanah / kadar air tanah]),
    lst([Pemasukan campuran air dan pupuk ke tanah]),
    lst([Pemasukan air ke tanah], [Pemasukan cairan pH]),
  ),
  komponen(
    tbd,
    tbd,
    tbd,
  ),
)

== Kavling Source Supply

#bagian(
  tjn(
    [Lingkungan di dalam kavling membutuhkan suplai bahan pendukung yang tersedia dan terpantau.],
    [Menyediakan suplai bahan-bahan untuk mendukung lingkungan di dalam kavling.],
  ),
  foto("Box suplai dan tangki-tangki di samping kavling", h: 5cm),
  teknis(
    lst(
      [Air dalam tangki], [Pestisida dalam tangki], [Pupuk dalam tangki],
      [Air pH dalam tangki], [Baking soda dalam tangki], [Cuka dalam tangki],
      [Hidrogen peroksida (H#sub[2]O#sub[2]) 3% dalam tangki], [Ragi roti (Fermipan)],
    ),
    lst(
      [Kadar air dalam tangki], [Kadar pestisida dalam tangki], [Kadar pupuk dalam tangki],
      [Kadar larutan pupuk dengan air dalam tangki], [Kadar air pH dalam tangki],
      [Baking soda dalam tangki], [Cuka dalam tangki],
      [Hidrogen peroksida 3% dalam tangki], [Ragi roti (Fermipan)],
    ),
    [Tidak ada],
    lst(
      [Membunyikan alarm bahwa tangki tertentu kurang atau kosong],
      [Memasukkan campuran pupuk dengan air lalu mengaduknya],
    ),
  ),
  komponen(
    tbd,
    tbd,
    tbd,
  ),
)

== Kavling Interface

#bagian(
  tjn(
    [Pengguna tidak mengetahui keadaan suhu, udara, gas, dan banyak hal lain dalam ekosistem kavling.],
    lst(
      [Menyajikan data kavling terkini kepada pengguna / pengawas kavling],
      [Menentukan keberlangsungan kavling: sedang "Merawat" atau "Panen"],
    ),
  ),
  foto("Box interface (layar atau tampilan status)", h: 5cm),
  teknis(
    lst([Status kavling]),
    lst([Input status kavling]),
    lst(
      [Memberikan informasi suhu dalam kavling, kadar karbon dioksida, dan kadar oksigen],
      [Memberikan informasi kelembapan tanah dan pH di dalam kavling],
      [Memberikan informasi flux UV matahari],
      [Memberikan informasi kadar tangki: air, pestisida, pupuk, serta larutan air dan pupuk],
      [Memberikan informasi aksi yang sedang dilakukan atau idle],
    ),
    lst([Membuka atap kavling saat status "Panen"]),
  ),
  komponen(
    tbd,
    tbd,
    tbd,
  ),
)

= Penutup

Dokumen ini menjelaskan gambaran besar Kavling Pintar: tiga bagian besar
sistem (kavling, source supply, dan interface) beserta komponen, parameter,
pendeteksian, aksi, dan tujuannya. Nilai parameter ideal akan ditentukan di
dalam program, dan penjelasan serta daftar bahan komponen akan dilengkapi pada
tahap berikutnya.
