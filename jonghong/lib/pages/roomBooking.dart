import 'package:flutter/material.dart';

void main() {
  runApp(roomBooking());
}

class roomBooking extends StatelessWidget {
  TextEditingController textarea = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                width:
                    double.infinity, // Ensure the image covers the entire width
                height: MediaQuery.of(context).size.height *
                    0.4, // Responsive height
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color.fromARGB(255, 175, 81, 81),
                ),
                child: ClipRRect(
                  child: Image.asset(
                    'assets/images/room4.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 210.0),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.15,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Color(0xFFF54900),
                      ),
                      onPressed: () {
                        // Implement navigation back logic here
                        // For example:
                        Navigator.of(context).pop();
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 170),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Working Room Name',
                            style: TextStyle(
                                fontSize: 24.0,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFE5B3D)),
                          ),
                          SizedBox(height: 18.0),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.people,
                                    color: Colors.grey[700],
                                  ),
                                  SizedBox(width: 3.0),
                                  Text(
                                    'For 15 - 20 people',
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontFamily: 'Poppins',
                                        color: Color(0xFF9D9D9D)),
                                  ),
                                ],
                              ),
                              SizedBox(width: 8.0),
                              Row(
                                children: [
                                  Icon(
                                    Icons.aspect_ratio,
                                    color: Colors.grey[700],
                                  ),
                                  SizedBox(width: 3.0),
                                  Text(
                                    '200 sq.m.',
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontFamily: 'Poppins',
                                        color: Color(0xFF9D9D9D)),
                                  ),
                                ],
                              ),
                              SizedBox(width: 8.0),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.grey[700],
                                  ),
                                  SizedBox(width: 3.0),
                                  Text(
                                    'S14102',
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontFamily: 'Poppins',
                                        color: Color(0xFF9D9D9D)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 18.0),
                          Text(
                            'Details:',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            'This room is for...',
                            style: TextStyle(
                              fontSize: 10.0,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Row(
                            children: [
                              Text(
                                'Select Date:',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFFE5B3D)),
                              ),
                              SizedBox(width: 10.0),
                              selectDate(),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Select Duration:',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFFE5B3D)),
                              ),
                              SizedBox(width: 10.0),
                              selectDuration(),
                            ],
                          ),
                          Text(
                            'Caution: 2 hrs. max per reservation',
                            style: TextStyle(
                                fontSize: 12.0,
                                fontFamily: 'Poppins',
                                color: Color(0xFFFE5B3D)),
                          ),
                          SizedBox(height: 20.0),

                          //purpose
                          Text(
                            'Purpose:',
                            style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFFE5B3D)),
                          ),
                          SizedBox(height: 10.0),
                          TextField(
                            controller: textarea,
                            keyboardType: TextInputType.multiline,
                            maxLines: 4,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[200],
                              hintText: 'Please type your purpose of using',
                              hintStyle: TextStyle(
                                fontSize: 12.0,
                                fontFamily: 'Poppins',
                                color: Colors.grey[500],
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                // handle booking
                              },
                              child: Text('Book Room'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Select Date
class selectDate extends StatefulWidget {
  const selectDate({super.key});

  @override
  State<selectDate> createState() => _selectDateState();
}

class _selectDateState extends State<selectDate> {
  DateTime dateTime = DateTime.now();
  String initialDateString = 'dd/mm/yyyy';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFF1F1F1),
              side: BorderSide(color: Color(0xFF9D9D9D)),
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
            ),
            child: Row(
              children: [
                Tooltip(
                  message: 'dd-mm-yyyy',
                  child: Text(
                    initialDateString,
                    style: TextStyle(
                        fontSize: 12.0,
                        fontFamily: 'Poppins',
                        color: Color(0xFFFE5B3D)),
                  ),
                ),
                SizedBox(width: 2),
                if (initialDateString == 'dd/mm/yyyy')
                  Icon(Icons.arrow_drop_down),
              ],
            ),
            onPressed: () async {
              final date = await pickDate(context);
              if (date == null) return; // pressed 'CANCEL'
              setState(() {
                dateTime = date;
                initialDateString = '${date.day}/${date.month}/${date.year}';
              }); // pressed 'OK'
            },
          )
        ],
      ),
    );
  }

  Future<DateTime?> pickDate(BuildContext context) => showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(2024, 1, 1),
        lastDate: DateTime(2024, 12, 31),
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: Color(0xFFFE5B3D),
                onPrimary: Colors.white,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: Color(0xFFFE5B3D),
                ),
              ),
            ),
            child: child!,
          );
        },
      );
}

//Select Duration
class selectDuration extends StatefulWidget {
  const selectDuration({super.key});

  @override
  State<selectDuration> createState() => _selectDurationState();
}

class _selectDurationState extends State<selectDuration> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(children: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFF1F1F1),
            side: BorderSide(color: Color(0xFF9D9D9D)),
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
          ),
          onPressed: () {},
          child: Text(
            '08.00 - 10.00',
            style: TextStyle(
              color: Color(0xFFFE5B3D),
              fontFamily: 'Poppins',
              fontSize: 12.0,
            ),
          ),
        )
      ]),
    );
  }
}
