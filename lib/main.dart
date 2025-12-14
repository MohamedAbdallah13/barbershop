
import 'package:barber_shop/ui/forget_password_screen.dart';
import 'package:barber_shop/ui/login_screen.dart';
import 'package:barber_shop/ui/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(BarbershopApp());
}

// Models
class ServicePrice {
  final String name;
  final double price;
  final String currency;

  ServicePrice({
    required this.name,
    required this.price,
    required this.currency,
  });
}

class Worker {
  final String name;
  final double rating;
  final String speciality;

  Worker({
    required this.name,
    required this.rating,
    required this.speciality,
  });
}

class Service {
  final String name;
  final String description;
  final List<Worker> workers;
  final ServicePrice price;

  Service({
    required this.name,
    required this.description,
    required this.workers,
    required this.price,
  });
}

// App Widget
class BarbershopApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      
      debugShowCheckedModeBanner: false,
      title: 'Barbershop App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
        '/services': (context) => ServicesScreen(),
      },
    );
  }
}

// Services Screen
class ServicesScreen extends StatelessWidget {
  final List<Service> services = [
    Service(
      name: 'Hair Cutting',
      description: 'Professional haircuts for all styles',
      price: ServicePrice(name: 'Haircut', price: 30.00, currency: 'USD'),
      workers: [
        Worker(name: 'Karim Ayman', rating: 4.8, speciality: 'Modern Cuts'),
        Worker(name: 'Ahmed Mostafa', rating: 4.9, speciality: 'Classic Styles'),
      ],
    ),
    Service(
      name: 'Massage',
      description: 'Relaxing massage services',
      price: ServicePrice(name: 'Massage', price: 50.00, currency: 'USD'),
      workers: [
        Worker(name: 'Ahmed Hani ', rating: 4.7, speciality: 'Deep Tissue'),
        Worker(name: 'Ayman Mostafa', rating: 4.9, speciality: 'Swedish'),
      ],
    ),
    Service(
      name: 'Nails',
      description: 'Complete nail care services',
      price: ServicePrice(name: 'Nails', price: 25.00, currency: 'USD'),
      workers: [
        Worker(name: 'Mariam Karim', rating: 4.8, speciality: 'Manicure'),
        Worker(name: 'Mona Ahmed', rating: 4.7, speciality: 'Pedicure'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Our Services')),
      body: ListView.builder(
        itemCount: services.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(services[index].name),
            subtitle: Text(services[index].description),
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: services[index].workers.length,
                itemBuilder: (context, workerIndex) {
                  final worker = services[index].workers[workerIndex];
                  return ListTile(
                    title: Text(worker.name),
                    subtitle: Text(worker.speciality),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber),
                        Text(worker.rating.toString()),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookingScreen(
                                  worker: worker,
                                  service: services[index],
                                ),
                              ),
                            );
                          },
                          child: const Text('Book'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

// Booking Screen
class BookingScreen extends StatefulWidget {
  final Worker worker;
  final Service service;

  const BookingScreen({
    required this.worker,
    required this.service,
  });

  @override
  // ignore: library_private_types_in_public_api
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    initializeNotifications();
  }

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        // ignore: prefer_const_constructors
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _proceedToPayment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MockPaymentScreen(
          service: widget.service,
          worker: widget.worker,
          appointmentDate: selectedDate,
          appointmentTime: selectedTime,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Appointment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking with ${widget.worker.name}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            ListTile(
              title: Text('Date: ${selectedDate.toString().split(' ')[0]}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),
            ListTile(
              title: Text('Time: ${selectedTime.format(context)}'),
              trailing: const Icon(Icons.access_time),
              onTap: () => _selectTime(context),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _proceedToPayment,
                child: const Text('Proceed to Payment'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Mock Payment Screen
class MockPaymentScreen extends StatefulWidget {
  final Service service;
  final Worker worker;
  final DateTime appointmentDate;
  final TimeOfDay appointmentTime;

  MockPaymentScreen({
    required this.service,
    required this.worker,
    required this.appointmentDate,
    required this.appointmentTime,
  });

  @override
  // ignore: library_private_types_in_public_api
  _MockPaymentScreenState createState() => _MockPaymentScreenState();
}

class _MockPaymentScreenState extends State<MockPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isProcessing = false;

  void _simulatePayment() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isProcessing = true;
      });

      await Future.delayed(const Duration(seconds: 2));

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      await Future.delayed(const Duration(seconds: 2));
      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Payment Successful'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 50),
                SizedBox(height: 16),
                Text('Your booking has been confirmed!'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/services',
                    (route) => false,
                  );
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Booking Summary',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Text('Service: ${widget.service.name}'),
                      Text('Provider: ${widget.worker.name}'),
                      Text(
                          'Date: ${widget.appointmentDate.toString().split(' ')[0]}'),
                      Text('Time: ${widget.appointmentTime.format(context)}'),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total:'),
                          Text(
                            '${widget.service.price.currency} ${widget.service.price.price.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Payment Details',
                style: Theme.of(context).titleLarge,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cardNumberController,
                decoration: const InputDecoration(
                  labelText: 'Card Number',
                  hintText: '4242 4242 4242 4242',
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter card number' : null,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _expiryController,
                      decoration: const InputDecoration(
                        labelText: 'Expiry Date',
                        hintText: 'MM/YY',
                      ),
                      validator: (value) => value?.isEmpty ?? true
                          ? 'Please enter expiry date'
                          : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _cvvController,
                      decoration: const InputDecoration(
                        labelText: 'CVV',
                        hintText: '123',
                      ),
                      obscureText: true,
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Please enter CVV' : null,
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Cardholder Name',
                  hintText: 'John Doe',
                ),
                validator: (value) => value?.isEmpty ?? true
                    ? 'Please enter cardholder name'
                    : null,
              ),
              const SizedBox(height: 24),
              if (_isProcessing)
                const Center(child: CircularProgressIndicator())
              else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _simulatePayment,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                        'Pay ${widget.service.price.currency} ${widget.service.price.price.toStringAsFixed(2)}'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

extension on ThemeData {
  get titleLarge => null;
}
