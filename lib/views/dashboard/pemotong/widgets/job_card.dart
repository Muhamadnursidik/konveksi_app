import 'package:flutter/material.dart';
import '../../../../models/job_model.dart';

class JobCard extends StatelessWidget {
  final JobModel job;
  final VoidCallback onKerjakan;

  const JobCard({super.key, required this.job, required this.onKerjakan});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFFE0E7FF),
                  child: Icon(Icons.content_cut, color: Colors.indigo, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    job.modelPakaian,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Menunggu',
                    style: TextStyle(color: Colors.orange, fontSize: 12),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            _row(Icons.layers_outlined,   'Bahan',           job.bahan),
            const SizedBox(height: 6),
            _row(Icons.format_list_numbered, 'Target',       '${job.jumlahTarget} pcs'),
            const SizedBox(height: 6),
            _row(Icons.straighten,        'Kebutuhan Bahan', '${job.kebutuhanBahan} meter'),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.upload_rounded),
                label: const Text('Kerjakan & Upload Bukti'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: onKerjakan,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(IconData icon, String label, String value) => Row(
    children: [
      Icon(icon, size: 16, color: Colors.grey),
      const SizedBox(width: 6),
      Text('$label: ', style: const TextStyle(color: Colors.grey, fontSize: 13)),
      Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
    ],
  );
}