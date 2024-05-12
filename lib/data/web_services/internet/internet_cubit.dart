
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'internet_state.dart';

class InternetCubit extends Cubit<InternetStatus>{

  InternetCubit():super(const InternetStatus(ConnectivityStatus.disconnected));

  void checkConnectivity()async{
    var connectivityResult= await (Connectivity().checkConnectivity());
    print("-------Connection result--1");
    print(connectivityResult);
    print("-------Connection result--2");
    _updateConnectivityStatus(connectivityResult);
  }

  void _updateConnectivityStatus(ConnectivityResult  result){
   // final hasInternet=result !=ConnectivityResult.none;
    if(result ==ConnectivityResult.none){
      emit(const InternetStatus(ConnectivityStatus.disconnected));
    }else{
      emit(const InternetStatus(ConnectivityStatus.connected));
    }

    // if (result.contains(ConnectivityResult.mobile)) {
    //   // Mobile network available.
    // } else if (result.contains(ConnectivityResult.wifi)) {
    //   // Wi-fi is available.
    //   // Note for Android:
    //   // When both mobile and Wi-Fi are turned on system will return Wi-Fi only as active network type
    // } else if (result.contains(ConnectivityResult.ethernet)) {
    //   // Ethernet connection available.
    // } else if (result.contains(ConnectivityResult.vpn)) {
    //   // Vpn connection active.
    //   // Note for iOS and macOS:
    //   // There is no separate network interface type for [vpn].
    //   // It returns [other] on any device (also simulator)
    // } else if (result.contains(ConnectivityResult.bluetooth)) {
    //   // Bluetooth connection available.
    // } else if (result.contains(ConnectivityResult.other)) {
    //   // Connected to a network which is not in the above mentioned networks.
    // } else if (result.contains(ConnectivityResult.none)) {
    //   // No available network types
    // }
  }

  // StreamSubscription<List<ConnectivityResult>>? _subscription;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  void trackConnectivityChange(){
    _connectivitySubscription=Connectivity().onConnectivityChanged.listen((result) {
      _updateConnectivityStatus(result);
    });
  }


  void dispose(){
    // _subscription?.cancel();
    _connectivitySubscription.cancel();
  }

}



// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';
//
// part 'internet_state.dart';
//
// class InternetCubit extends Cubit<InternetState> {
//   InternetCubit() : super(InternetInitial());
// }
