import 'dart:core';
import 'package:contactinformation/Layout/Home/cubit/states.dart';
import 'package:contactinformation/Model/contacts.dart';
import 'package:contactinformation/network/dio_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  List<Contacts> contacts = [];

  Future<void> getContacts() async {
    contacts.clear();
    emit(HomeGetDataLoadingState());
    await DioHelper.getData(
      url: "http://localhost/phpproject/contactInformation.php",
    ).then((value) {
      value.data["contacts"].forEach((e) {
        contacts.add(Contacts.fromJson(e));
      });
      emit(HomeGetDataSuccessState());
    }).catchError((error) {
      emit(HomeGetDataErrorState());
    });
  }

  String msgOperations = "";

  Future<void> crudOperationsContact(Contacts contactData) async {
    emit(HomeCrudOperationsLoadingState());
   await DioHelper.postData(
      url: "http://localhost/phpproject/contactInformation.php",
      data: contactData.toJson(),
    ).then((value) {
      msgOperations = value.data["message"];
      if (msgOperations == "Contact added successfully" ||
          msgOperations == "Contact updated successfully" ||
          msgOperations == "Contact deleted successfully"||
          msgOperations=="All contacts deleted successfully"
      ) {
        getContacts();
        emit(HomeCrudOperationsSuccessState());
      } else {
        emit(HomeCrudOperationsErrorState());
      }
    }).catchError((error) {
      emit(HomeCrudOperationsErrorState());
    });
  }
}
