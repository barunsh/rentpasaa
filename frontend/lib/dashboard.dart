import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'addproperty.dart';
import 'showproperty.dart';
import 'deleteandupdate.dart';

class Dashboard extends StatefulWidget {
  final String token;
  final String? role;
  final String? names;
  final int? phone;
  final String? id;
  final String? email;

  const Dashboard({
    required this.token,
    required this.role,
    required this.names,
    required this.phone,
    required this.id,
    required this.email,
    Key? key,
  }) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late String id;
  late String email;
  late String names;
  int? phone;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    id = jwtDecodedToken['_id'];
    email = jwtDecodedToken['email'];
    names = jwtDecodedToken['names'];
    phone = jwtDecodedToken['phone'];
    print(jwtDecodedToken);
  }

  @override
  void didUpdateWidget(Dashboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.names != oldWidget.names ||
        widget.phone != oldWidget.phone ||
        widget.id != oldWidget.id ||
        widget.email != oldWidget.email) {
      setState(() {
        names = widget.names!;
        phone = widget.phone!;
        id = widget.id!;
        email = widget.email!;
      });
    }
  }

  Future<void> _logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => MyLogin()),
    );
  }

  void _navigateToAddPropertyForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPropertyForm(
          token: widget.token,
          role: widget.role,
        ),
      ),
    );
  }

  void _navigateToShowPropertyForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GetDataPage(
          email: email,
          names: widget.names,
          phone: widget.phone,
          id:id,
        ),
      ),
    );
  }

  void _navigateToDeleteUpdateForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateDeletePage(
          // email: email,
          // names: widget.names,
          // phone: widget.phone,
          // id:id,
        ),
      ),
    );
  }

  Widget _buildDashboardContent() {
    if (widget.role == 'tenant') {
      return _buildTenantDashboard();
    } else if (widget.role == 'owner') {
      return _buildOwnerDashboard();
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Invalid role'),
          SizedBox(height: 20),
          _buildLogoutButton(),
        ],
      );
    }
  }

  Widget _buildTenantDashboard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Welcome Tenant: ${names ?? 'N/A'}',
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _navigateToAddPropertyForm,
          child: Text('Add Property'),
        ),
        ElevatedButton(
          onPressed: _navigateToShowPropertyForm,
          child: Text('Show Property'),
        ),
        SizedBox(height: 20),
        _buildLogoutButton(),
      ],
    );
  }

  Widget _buildOwnerDashboard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Welcome Owner: ${names ?? 'N/A'}',
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _navigateToAddPropertyForm,
          child: Text('Add Property'),
        ),
        ElevatedButton(
          onPressed: _navigateToShowPropertyForm,
          child: Text('Show Property'),
        ),
        ElevatedButton(
          onPressed: _navigateToDeleteUpdateForm,
          child: Text('Update/Delete User'),
        ),
        SizedBox(height: 20),
        _buildLogoutButton(),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return TextButton(
      onPressed: _logOut,
      child: Text('Log out', style: TextStyle(color: Colors.white)),
      style: TextButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ID: ${id ?? 'N/A'}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Names: ${names ?? 'N/A'}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Phone: ${phone ?? 'N/A'}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Email: ${email ?? 'N/A'}',
              style: TextStyle(fontSize: 16),
            ),
            _buildDashboardContent(),
          ],
        ),
      ),
    );
  }
}

