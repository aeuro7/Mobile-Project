import 'package:cloud_firestore/cloud_firestore.dart';

class TicketsApi {
  final CollectionReference tickets = FirebaseFirestore.instance.collection('tickets');

  // Stream สำหรับดึงข้อมูลตั๋วทั้งหมด
  Stream<QuerySnapshot> getTicketsStream() {
    return tickets.orderBy('ticket_date', descending: false).snapshots();
  }

  // ฟังก์ชันสำหรับเพิ่มข้อมูลตั๋วใหม่
  Future<void> addTicket({
    required String city,
    required String country,
    required String date,
    required String seat,
    required String stadium,
    required String ticketId,
    required String time,
  }) async {
    await tickets.add({
      'ticket_id': tickets.doc().id, // สร้าง ID อัตโนมัติ
      'ticket_city': city,
      'ticket_country': country,
      'ticket_date': date,
      'ticket_seat': seat,
      'ticket_stadium': stadium,
      'ticket_ticketId': ticketId,
      'ticket_time': time,
    });
  }
}
