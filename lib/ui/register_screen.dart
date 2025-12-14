import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register'), backgroundColor: Colors.deepOrange , 
      centerTitle: true,),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Full Name',  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
               SizedBox(height: 10),

              TextFormField(
                
                decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
                
                
               validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),

                             SizedBox(height: 10),

              TextFormField(
                decoration: InputDecoration(labelText: 'Password',  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
                obscureText: true,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    Navigator.pushReplacementNamed(context, '/services');
                  }
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
