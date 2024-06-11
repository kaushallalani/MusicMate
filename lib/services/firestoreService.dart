import 'package:cloud_firestore/cloud_firestore.dart';

class Firestoreservice{
  // final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final CollectionReference _userCollectionReference = FirebaseFirestore.instance.collection('users');

}