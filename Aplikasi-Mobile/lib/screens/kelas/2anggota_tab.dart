import 'package:flutter/material.dart';

class AnggotaTab extends StatelessWidget {
  final String namaKelas;
  final String waliKelas;
  final List<Map<String, dynamic>> anggotaKelas;

  const AnggotaTab({
    super.key,
    required this.namaKelas,
    required this.waliKelas,
    required this.anggotaKelas,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withAlpha(26),
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.primary.withAlpha(77),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.people_alt,
                color: Theme.of(context).colorScheme.primary,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Anggota Kelas $namaKelas',
                      style: TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Wali Kelas: $waliKelas',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                radius: 18,
                child: Text(
                  '${anggotaKelas.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Search bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withAlpha(77)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(13),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey[600]),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari anggota kelas...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: anggotaKelas.length,
            itemBuilder: (context, index) {
              final anggota = anggotaKelas[index];
              final bool isPengurus = anggota['jabatan'] != 'Anggota';
              
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: isPengurus 
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey[300],
                    child: Text(
                      anggota['nama'][0],
                      style: TextStyle(
                        color: isPengurus ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    anggota['nama'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text('NISN: ${anggota['nisn']}'),
                    ],
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isPengurus 
                          ? Theme.of(context).colorScheme.secondary
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      anggota['jabatan'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isPengurus ? Colors.white : Colors.grey[700],
                      ),
                    ),
                  ),
                  onTap: () {
                    // Detail anggota
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}