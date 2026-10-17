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

// Level 1-2: 1, 1.1 | Level 3: nomor poin 1., 2., ... (poin 1-7 tiap bagian)
#set heading(numbering: (..n) => {
  let p = n.pos()
  if p.len() == 3 { str(p.last()) + "." } else { numbering("1.1", ..p) }
})
#show heading.where(level: 1): set text(size: 16pt, fill: accent)
#show heading.where(level: 2): set text(size: 13pt, fill: accent)
#show heading.where(level: 3): set text(size: 11pt)
#show heading.where(level: 1): it => block(
  width: 100%,
  above: 2em,
  below: 1em,
  stroke: (bottom: 0.7pt + accent),
  inset: (bottom: 5pt),
  it,
)
#show heading.where(level: 2): set block(above: 1.6em, below: 0.8em)
#show heading.where(level: 3): set block(above: 1.2em, below: 0.6em)

// ---------- Figure & tabel ----------

#show figure: set block(breakable: false, above: 1.2em, below: 1.2em)
#show figure.caption: set text(size: 9.5pt, fill: muted)
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
      marker: text(fill: accent)[•],
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
    bottom: if y == 0 { 0.6pt + accent } else { 0.4pt + luma(215) },
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

// Poin 7
#let harga(..baris) = tabel(
  columns: (auto, 1fr, auto, auto, auto),
  align: (center, left, center, right, right),
  [*No*], [*Komponen*], [*Jumlah*], [*Harga satuan*], [*Subtotal*],
  ..baris,
)

// Kerangka 7 poin untuk setiap bagian sistem
#let bagian(p1, p2, p3, p4, p5, p6, p7) = {
  [=== Tujuan dan Masalah]
  p1
  [=== Penjelasan Visual]
  block(breakable: false, p2)
  [=== Teknis Bagian]
  p3
  [=== Pendalaman Bagian]
  p4
  [=== Material Penyusun Komponen]
  p5
  [=== Elektronika yang Bekerja]
  p6
  [=== Rincian Komponen dan Harga]
  p7
}

// Kartu ciri fisik tanaman
#let ciri(judul, ket) = block(
  stroke: (left: 2pt + accent),
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
  #text(size: 10pt, weight: "bold", fill: accent, tracking: 2pt)[DOKUMEN RANCANGAN SISTEM]
  #v(1fr)
  #text(size: 40pt, weight: "bold")[#judul]
  #v(0.5em)
  #line(length: 4cm, stroke: 3pt + accent)
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
  radius: 3pt,
  inset: (x: 0.9cm, y: 0.7cm),
)[
  #text(weight: "bold", fill: accent)[Abstrak]
  #v(0.3em)
  #set text(size: 10.5pt)
  Kavling Pintar adalah rancangan kavling yang berisi tanaman beserta pot-potnya
  dan bertugas merawat tanaman tersebut secara mandiri. Kavling dirancang untuk
  memanfaatkan sumber daya di sekitarnya, seperti cahaya matahari, udara luar,
  dan air, seefisien mungkin. Sistem dibagi menjadi lima bagian: atap,
  suplai bahan, lingkungan udara internal, pot tanaman, dan antarmuka
  pengguna. Setiap bagian dijelaskan dengan format NTK (_Need To Know_), yaitu
  komponen, parameter ideal, pendeteksian, aksi pasif, aksi reaktif, tujuan,
  dan atribut elektronik. Dokumen ini adalah gambaran besar; foto komponen
  dan nilai parameter akan dilengkapi pada tahap berikutnya.
  #v(0.4em)
  #text(size: 9.5pt)[*Kata kunci:* kavling pintar, otomasi tanaman, sensor, IoT]
]

#v(0.8cm)
#show outline.entry.where(level: 1): it => {
  v(0.5em, weak: true)
  strong(it)
}
#outline(title: "Daftar Isi", indent: 1.2em, depth: 2)
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
        #image("foto/" + lower(nama) + "." + ext, width: 100%, height: 3cm, fit: "cover")
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

= Gambaran Umum Sistem

Kavling Pintar terdiri dari lima bagian yang saling berhubungan. Atap
melindungi tanaman dari lingkungan luar, box suplai menyediakan bahan,
sisi-sisi kavling menjaga kualitas udara, pot menjaga kualitas tanah, dan box
antarmuka menyampaikan informasi kepada pengamat (@tbl-bagian).

#figure(
  kind: table,
  supplement: [Tabel],
  caption: [Lima bagian sistem Kavling Pintar],
  tabel(
    columns: (auto, 1fr, 1fr),
    align: (center, left, left),
    [*No*], [*Bagian*], [*Component*],
    [1], [Kavling ke Lingkungan Luar], [Atap Kavling],
    [2], [Kavling Source Supply], [Box di samping kavling],
    [3], [Kavling ke Lingkungan Internal], [Sisi-sisi kavling],
    [4], [Kavling Pot ke Tanaman], [Pot di dalam kavling],
    [5], [Kavling Interface ke User], [Box interface di samping kavling],
  ),
) <tbl-bagian>

#grid(
  columns: (1fr, 1fr),
  column-gutter: 1em,
  foto(
    "Tampak penuh Kavling Pintar",
    isi: image("foto/Tampak_Full.png", width: 100%, height: 5cm, fit: "contain"),
  ),
  foto(
    "Tampak rangka Kavling Pintar",
    isi: image("foto/Tampak_Rangka.png", width: 100%, height: 5cm, fit: "contain"),
  ),
)

#pagebreak(weak: true)

= Rincian Bagian Sistem

Setiap bagian sistem dijelaskan dengan tujuh poin yang seragam: tujuan dan
masalah, penjelasan visual, teknis bagian, pendalaman bagian, material
penyusun komponen, elektronika yang bekerja, serta rincian komponen dan
harga. Poin yang belum ditentukan ditandai _Belum ditentukan_ dan akan
dilengkapi pada tahap berikutnya.

== Kavling ke Lingkungan Luar

#bagian(
  tjn(
    [Tanaman di dalam kavling terancam hujan dan flux matahari yang terlalu tinggi.],
    [Menjaga tanaman di dalam kavling dari gangguan lingkungan luar (hujan, indeks matahari tinggi).],
  ),
  [
    Komponen: *atap kavling*.
    #grid(
      columns: (1fr, 1fr),
      column-gutter: 1em,
      foto("Atap kavling", h: 4.5cm),
      foto("Geared DC motor dan sensor infrared", h: 4.5cm),
    )
  ],
  teknis(
    lst([Flux matahari]),
    lst([Flux matahari / intensitas cahaya], [Air hujan]),
    lst([Buka-tutup atap kavling pada pagi hari, pukul 07:00 – 09:00]),
    lst([Buka-tutup atap kavling saat hujan atau saat flux UV matahari terlalu tinggi]),
  ),
  tbd,
  tbd,
  lst([Geared DC motor], [Sensor infrared #sym.times 2]),
  harga(
    [1], [Geared DC motor], tbd, tbd, tbd,
    [2], [Sensor infrared], [2], tbd, tbd,
  ),
)

== Kavling Source Supply

#bagian(
  tjn(
    [Lingkungan di dalam kavling membutuhkan suplai bahan pendukung yang tersedia dan terpantau.],
    [Menyediakan suplai bahan-bahan untuk mendukung lingkungan di dalam kavling.],
  ),
  [
    Komponen: *box di samping kavling*.
    #foto("Box suplai dan tangki-tangki di samping kavling", h: 5cm)
  ],
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
  tbd,
  tbd,
  tbd,
  tbd,
)

== Kavling ke Lingkungan Internal

#bagian(
  tjn(
    [Kualitas udara di dalam kavling harus dijaga agar tanaman tumbuh baik.],
    [Membuat lingkungan udara yang ideal sesuai parameter ideal.],
  ),
  [
    Komponen: *sisi-sisi kavling*.
    #foto("Sisi-sisi kavling", h: 5cm)
  ],
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
  tbd,
  tbd,
  tbd,
  tbd,
)

== Kavling Pot ke Tanaman

#bagian(
  tjn(
    [Kondisi tanah di dalam pot harus sesuai kebutuhan tanaman.],
    [Membuat lingkungan tanah yang ideal sesuai parameter ideal.],
  ),
  [
    Komponen: *pot di dalam kavling*.
    #foto("Pot tanaman dan sensor tanah", h: 5cm)
  ],
  teknis(
    lst([pH tanah], [Kelembapan tanah / kadar air tanah]),
    lst([pH tanah], [Kelembapan tanah / kadar air tanah]),
    lst([Pemasukan campuran air dan pupuk ke tanah]),
    lst([Pemasukan air ke tanah], [Pemasukan cairan pH]),
  ),
  tbd,
  tbd,
  tbd,
  tbd,
)

== Kavling Interface ke User

#bagian(
  tjn(
    [Pengamat perlu tahu kondisi kavling, dan status kavling perlu ditentukan.],
    lst(
      [Memberi tahu pengamat informasi terkini tentang kavling],
      [Menentukan keberlangsungan kavling: sedang "Merawat" atau "Panen"],
    ),
  ),
  [
    Komponen: *box interface di samping kavling*.
    #foto("Box interface (layar atau tampilan status)", h: 5cm)
  ],
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
  tbd,
  tbd,
  tbd,
  tbd,
)

= Penutup

Dokumen ini menjelaskan gambaran besar Kavling Pintar: lima bagian sistem
beserta komponen, parameter, pendeteksian, aksi, dan tujuannya. Nilai
parameter ideal akan ditentukan di dalam program, dan daftar komponen
elektronik akan dilengkapi untuk bagian suplai, udara internal, pot, dan
antarmuka.
