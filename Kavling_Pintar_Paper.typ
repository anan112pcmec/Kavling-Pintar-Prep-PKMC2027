// ============================================================
//  KAVLING PINTAR — Paper gambaran besar sistem
//  Compile: typst compile kavling-pintar.typ
//  Ganti placeholder foto dengan: image("foto/nama-file.jpg", width: 100%)
// ============================================================

#set document(title: "Kavling Pintar", author: "Faiz Hannan Hakim")
#set page(
  paper: "a4",
  margin: (x: 2.5cm, y: 2.5cm),
  numbering: "1",
  footer: context [
    #set text(size: 9pt, fill: gray)
    Kavling Pintar #h(1fr) #counter(page).display()
  ],
)
#set text(font: "New Computer Modern", size: 11pt, lang: "id")
#set par(justify: true, leading: 0.65em)
#set heading(numbering: "1.1")
#show heading.where(level: 1): set text(size: 14pt)
#show heading: set block(above: 1.4em, below: 0.8em)
#set figure(supplement: "Gambar")
#show figure.caption: set text(size: 9.5pt)

// ---------- Helper ----------

// Placeholder foto: nanti ganti isi `foto(...)` dengan image(...)
#let foto(caption, h: 5cm, isi: none) = figure(
  if isi == none {
    rect(
      width: 100%,
      height: h,
      stroke: (paint: gray, dash: "dashed"),
      fill: luma(247),
    )[
      #align(center + horizon, text(fill: gray, size: 10pt)[Tempat foto komponen])
    ]
  } else { isi },
  caption: caption,
)

// Daftar poin dalam sel tabel
#let lst(..items) = {
  let xs = items.pos()
  if xs.len() == 0 [—] else {
    list(tight: true, marker: [•], indent: 0pt, body-indent: 6pt, ..xs)
  }
}

#let tbd = text(fill: gray, style: "italic")[belum ditentukan]

// Tabel NTK satu subsistem
#let ntk(comp, ideal, detect, pasif, reaktif, elek, goal) = table(
  columns: (3.4cm, 1fr),
  inset: 7pt,
  stroke: 0.5pt + luma(160),
  fill: (x, y) => if x == 0 { luma(236) } else { none },
  [*Component*], comp,
  [*Parameter Ideal*], ideal,
  [*Pendeteksian*], detect,
  [*Aksi Pasif*], pasif,
  [*Aksi Reaktif*], reaktif,
  [*Attributes Electronic*], elek,
  [*Goal*], goal,
)

// ---------- Judul ----------

#align(center)[
  #v(1cm)
  #text(size: 24pt, weight: "bold")[Kavling Pintar]
  #v(0.3em)
  #text(size: 13pt)[Rancangan Sistem Kavling Otomatis untuk Perawatan Tanaman]
  #v(0.8em)
  Anan \
  #text(size: 10pt, fill: gray)[Draf gambaran besar]
  #v(1cm)
]

#block(inset: (x: 1cm))[
  #align(center)[*Abstrak*]
  #v(0.2em)
  #set par(justify: true)
  Kavling Pintar adalah rancangan kavling yang akan mengjaga tanaman yang ada di dalam nya, kavling berisi tanaman beserta pot-potnya
  dan bertugas merawat tanaman tersebut secara mandiri. Kavling dirancang untuk
  memanfaatkan sumber daya di sekitarnya, seperti cahaya matahari, udara luar,
  dan air, seefisien mungkin. Sistem dibagi menjadi lima bagian: atap,
  suplai bahan, lingkungan udara internal, pot tanaman, dan antarmuka
  pengguna. Setiap bagian dijelaskan dengan format NTK(Need To Know), yaitu
  komponen, parameter ideal, pendeteksian, aksi pasif, aksi reaktif, tujuan,
  dan atribut elektronik. Dokumen ini adalah gambaran besar; foto komponen
  dan nilai parameter akan dilengkapi pada tahap berikutnya.
]

#v(0.5cm)
#outline(title: "Daftar Isi", indent: 1.2em, depth: 2)
#pagebreak()

// ---------- Isi ----------

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

== NTK (Need To Know)

Setiap bagian sistem dijelaskan dengan tujuh elemen berikut.

#table(
  columns: (4cm, 1fr),
  inset: 7pt,
  stroke: 0.5pt + luma(160),
  fill: (x, y) => if y == 0 { luma(225) } else { none },
  [*Elemen*], [*Pengertian*],
  [Component], [Komponen yang bertugas atas suatu hal.],
  [Parameter Ideal], [Parameter yang nanti ditentukan di dalam program.],
  [Pendeteksian],
  [Pembacaan dinamika lingkungan yang dijadikan parameter penilaian.],

  [Aksi Pasif],
  [Aksi yang pasti dilakukan tanpa bergantung pada pendeteksian parameter.],

  [Aksi Reaktif], [Aksi yang merupakan hasil keputusan dari pendeteksian parameter.],
  [Goal], [Tujuan dari bagian yang dimaksud.],
  [Attributes Electronic], [Komponen robotik yang digunakan oleh component.],
)

#linebreak()
#linebreak()
#linebreak()
#linebreak()
#linebreak()
#linebreak()
#linebreak()
#linebreak()
#linebreak()
#linebreak()
#linebreak()
#linebreak()

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

#grid(
  columns: (1fr, 1fr, 1fr),
  column-gutter: 1em,
  row-gutter: 0.99em,
  ..tanaman.enumerate(start: 1).map(((i, t)) => {
    let (nama, ilmiah, ext) = t
    align(center)[
      #image("foto/" + lower(nama) + "." + ext, width: 100%, height: 3.5cm, fit: "cover")
      #v(0.2em)
      *#i. #nama* \
      #text(size: 9.5pt, emph(ilmiah))
    ]
  }),
)

#linebreak()
#linebreak()
#linebreak()
#linebreak()
#linebreak()
#linebreak()
#linebreak()
#linebreak()
#linebreak()
#linebreak()
#linebreak()
#linebreak()
#linebreak()
#linebreak()
#linebreak()
#linebreak()
#linebreak()
#linebreak()

= Gambaran Umum Sistem

Kavling Pintar terdiri dari lima bagian yang saling berhubungan. Atap
melindungi tanaman dari lingkungan luar, box suplai menyediakan bahan,
sisi-sisi kavling menjaga kualitas udara, pot menjaga kualitas tanah, dan box
antarmuka menyampaikan informasi kepada pengamat.

#table(
  columns: (auto, 1fr, 1fr),
  inset: 7pt,
  stroke: 0.5pt + luma(160),
  fill: (x, y) => if y == 0 { luma(225) } else { none },
  [*No*], [*Bagian*], [*Component*],
  [1], [Kavling ke Lingkungan Luar], [Atap Kavling],
  [2], [Kavling Source Supply], [Box di samping kavling],
  [3], [Kavling ke Lingkungan Internal], [Sisi-sisi kavling],
  [4], [Kavling Pot ke Tanaman], [Pot di dalam kavling],
  [5], [Kavling Interface ke User], [Box interface di samping kavling],
)

#v(0.5em)

#grid(
  columns: (1fr, 1fr),
  column-gutter: 1em,
  foto(
    "Tampak penuh Kavling Pintar",
    isi: image("foto/Tampak_Full.png", width: 100%, height: 7cm, fit: "contain"),
  ),
  foto(
    "Tampak rangka Kavling Pintar",
    isi: image("foto/Tampak_Rangka.png", width: 100%, height: 7cm, fit: "contain"),
  ),
)

#linebreak()
#linebreak()
#linebreak()
#linebreak()
#linebreak()
#linebreak()
#linebreak()
#linebreak()
#linebreak()
#linebreak()
#linebreak()
#linebreak()
#linebreak()
#linebreak()
#linebreak()
#linebreak()


= Rincian Bagian Sistem

== Kavling ke Lingkungan Luar

Bagian ini menangani hubungan kavling dengan kondisi di luar, terutama hujan
dan intensitas sinar matahari.

#ntk(
  [Atap Kavling],
  lst([Flux matahari]),
  lst([Flux matahari / intensitas cahaya], [Air hujan]),
  lst([Buka-tutup atap kavling pada pagi hari, pukul 07:00 – 09:00]),
  lst([Buka-tutup atap kavling saat hujan atau saat flux UV matahari terlalu tinggi]),
  lst([Geared DC motor], [Sensor infrared #sym.times 2]),
  [Menjaga tanaman di dalam kavling dari gangguan lingkungan luar (hujan dan
    indeks matahari tinggi).],
)

#grid(
  columns: (1fr, 1fr),
  column-gutter: 1em,
  foto("Atap kavling", h: 4.5cm),
  foto("Geared DC motor dan sensor infrared", h: 4.5cm),
)

== Kavling Source Supply

Bagian ini adalah box di samping kavling yang menyimpan bahan-bahan pendukung
lingkungan kavling dan memantau ketersediaannya.

#ntk(
  [Box di samping kavling],
  lst(
    [Air dalam tangki],
    [Pestisida dalam tangki],
    [Pupuk dalam tangki],
    [Air pH dalam tangki],
    [Baking soda dalam tangki],
    [Cuka dalam tangki],
    [Hidrogen peroksida (H#sub[2]O#sub[2]) 3% dalam tangki],
    [Ragi roti (Fermipan)],
  ),
  lst(
    [Kadar air dalam tangki],
    [Kadar pestisida dalam tangki],
    [Kadar pupuk dalam tangki],
    [Kadar larutan pupuk dengan air dalam tangki],
    [Kadar air pH dalam tangki],
    [Baking soda dalam tangki],
    [Cuka dalam tangki],
    [Hidrogen peroksida 3% dalam tangki],
    [Ragi roti (Fermipan)],
  ),
  lst(),
  lst(
    [Membunyikan alarm bahwa tangki tertentu kurang atau kosong],
    [Memasukkan campuran pupuk dengan air lalu mengaduknya],
  ),
  tbd,
  [Menyediakan suplai bahan-bahan untuk mendukung lingkungan di dalam kavling.],
)

#foto("Box suplai dan tangki-tangki di samping kavling", h: 5cm)

== Kavling ke Lingkungan Internal

Bagian ini menjaga kualitas udara di dalam kavling melalui sisi-sisi kavling.

#ntk(
  [Sisi-sisi kavling],
  lst([Suhu], [Kadar oksigen], [Kadar karbon dioksida]),
  lst(
    [Suhu],
    [Kadar oksigen (malam)],
    [Kadar karbon dioksida (siang)],
    [Kelembapan udara],
  ),
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
  tbd,
  [Membuat lingkungan udara yang ideal sesuai parameter ideal.],
)

#foto("Sisi-sisi kavling dan komponen sirkulasi udara", h: 5cm)

== Kavling Pot ke Tanaman

Bagian ini menjaga kondisi tanah di dalam pot tempat tanaman tumbuh.

#ntk(
  [Pot di dalam kavling],
  lst([pH tanah], [Kelembapan tanah / kadar air tanah]),
  lst([pH tanah], [Kelembapan tanah / kadar air tanah]),
  lst([Pemasukan campuran air dan pupuk ke tanah]),
  lst([Pemasukan air ke tanah], [Pemasukan cairan pH]),
  tbd,
  [Membuat lingkungan tanah yang ideal sesuai parameter ideal.],
)

#foto("Pot tanaman dan sensor tanah", h: 5cm)

== Kavling Interface ke User

Bagian ini adalah box antarmuka di samping kavling yang menampilkan informasi
kavling dan menerima input status dari pengguna.

#ntk(
  [Box interface di samping kavling],
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
  tbd,
  lst(
    [Memberi tahu pengamat informasi terkini tentang kavling],
    [Menentukan keberlangsungan kavling: sedang "Merawat" atau "Panen"],
  ),
)

#foto("Box interface (layar atau tampilan status)", h: 5cm)

= Ringkasan Komponen Elektronik

Komponen elektronik yang sudah ditentukan sejauh ini adalah sebagai berikut.
Komponen untuk bagian lain akan ditambahkan seiring perancangan.

#table(
  columns: (auto, 1fr, 1fr),
  inset: 7pt,
  stroke: 0.5pt + luma(160),
  fill: (x, y) => if y == 0 { luma(225) } else { none },
  [*No*], [*Komponen*], [*Digunakan oleh*],
  [1], [Geared DC motor], [Atap kavling],
  [2], [Sensor infrared #sym.times 2], [Atap kavling],
)

#grid(
  columns: (1fr, 1fr),
  column-gutter: 1em,
  foto("Geared DC motor", h: 4.5cm),
  foto("Sensor infrared", h: 4.5cm),
)

= Penutup

Dokumen ini menjelaskan gambaran besar Kavling Pintar: lima bagian sistem
beserta komponen, parameter, pendeteksian, aksi, dan tujuannya. Nilai
parameter ideal akan ditentukan di dalam program, dan daftar komponen
elektronik akan dilengkapi untuk bagian suplai, udara internal, pot, dan
antarmuka.
