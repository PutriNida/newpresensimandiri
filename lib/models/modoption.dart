class OptionMenu {
  OptionMenu({this.title});

  final String title;
}

List<OptionMenu> optionMenu = <OptionMenu>[
  OptionMenu(title: 'Profil'),
  OptionMenu(title: 'Pengaturan'),
  OptionMenu(title: 'Tentang'),
  OptionMenu(title: 'Jadwal Ujian'),
  OptionMenu(title: 'Logout')
];

class OptionProfile{
  OptionProfile({this.no, this.title});

  final int no;
  final String title;
}

List<OptionProfile> optionProfile = <OptionProfile>[
  OptionProfile(no:1, title: 'Ubah Password'),
  OptionProfile(no:2, title: 'Ubah Foto Profil'),
  OptionProfile(no:3, title: 'Ubah Data Profil')
];