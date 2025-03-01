import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'tools/dot.dart';
import 'tools/dayformat.dart';

class Ticket extends StatelessWidget {
  const Ticket({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text(
          "My Ticket",
          style: TextStyle(color: Colors.black), // เปลี่ยนสีข้อความใน AppBar
        ),
        backgroundColor: const Color.fromARGB(
          255,
          255,
          255,
          255,
        ), // สีพื้นหลังของ AppBar
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ), // ไอคอนด้านซ้าย
          onPressed: () {
            Navigator.pushNamed(context, '/home'); // นำทางไปยังหน้าหลัก
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black), // ไอคอนด้านขวา
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/addTicket',
              ); // นำทางไปยังหน้าเพิ่ม Ticket
            },
          ),
        ],
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('tickets')
                .orderBy('ticket_date', descending: false)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error loading tickets"));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No tickets available"));
          }

          final tickets = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              final ticket = tickets[index];
              return TicketCard(ticket: ticket);
            },
          );
        },
      ),
    );
  }
}

class TicketCard extends StatelessWidget {
  final QueryDocumentSnapshot ticket;

  const TicketCard({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    // ดึงข้อมูลจาก snapshot
    final ticketData = ticket.data() as Map<String, dynamic>;
    List<String> dateList = splitDate(ticketData['ticket_date']);
    String month = dateList[0];
    String day = dateList[1];
    String year = dateList[2];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Row(
        children: [
          // ส่วนซ้ายของการ์ด
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF3562A6), Color(0xFF6594C0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${ticketData['ticket_city']} - ${ticketData['ticket_country']}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Time: ${ticketData['ticket_time']}",
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  Text(
                    "Seat: ${ticketData['ticket_seat']}",
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  Text(
                    "Stadium: ${ticketData['ticket_stadium']}",
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Booking ID: ${ticketData['ticket_ticketId']}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ส่วนขวาของการ์ด
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        month,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        day,
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF091442),
                        ),
                      ),
                      Text(
                        year,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: -8,
                top: -35,
                child: Container(
                  width: 17,
                  height: 17,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                left: -8,
                top: 120,
                child: Container(
                  width: 17,
                  height: 17,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                left: 1,
                top: -18,
                bottom: 0,
                child: CustomPaint(
                  size: const Size(2, 100),
                  painter: DottedLinePainter(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
