import 'package:flutter/material.dart';

class ServicesScreen extends StatelessWidget {
  final List<Service> services = [
    Service(
      name: 'Hair Cutting',
      description: 'Professional haircuts for all styles',
      workers: [
        Worker(name: 'Karim Ayman', rating: 4.8, speciality: 'Modern Cuts'),
        Worker(name: 'Ahmed Mostafa ', rating: 4.9, speciality: 'Classic Styles'),
      ],
    ),
    Service(
      name: 'Massage',
      description: 'Relaxing massage services',
      workers: [
        Worker(name: 'Ahmed Hani', rating: 4.7, speciality: 'Deep Tissue'),
        Worker(name: 'Ayman Mostafa', rating: 4.9, speciality: 'Swedish'),
      ],
    ),
    Service(
      name: 'Nails',
      description: 'Complete nail care services',
      workers: [
        Worker(name: 'Mariam Ibrahim', rating: 4.8, speciality: 'Manicure'),
        Worker(name: 'Mona Ahmed', rating: 4.7, speciality: 'Pedicure'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Our Services'), backgroundColor: Colors.deepOrange , 
      centerTitle: true,),
      body: ListView.builder(
        itemCount: services.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(services[index].name),
            subtitle: Text(services[index].description),
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: services[index].workers.length,
                itemBuilder: (context, workerIndex) {
                  final worker = services[index].workers[workerIndex];
                  return ListTile(
                    title: Text(worker.name),
                    subtitle: Text(worker.speciality),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: Colors.amber),
                        Text(worker.rating.toString()),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/booking',
                              arguments: worker,
                            );
                          },
                          child: Text('Book'),
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

// services_screen.dart
class Service {
  final String name;
  final String description;
  final List<Worker> workers;

  Service({
    required this.name,
    required this.description,
    required this.workers,
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
