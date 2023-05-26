import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:contactinformation/Compouents/adaptive_indicator.dart';
import 'package:contactinformation/Compouents/constant_empty.dart';
import 'package:contactinformation/Compouents/widgets.dart';
import 'package:contactinformation/Model/contacts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    DataTableSource data = DataShowContacts(context);
    var cubit = HomeCubit.get(context);
    return BlocConsumer<HomeCubit, HomeStates>(listener: (context, state) {
      if (state is HomeCrudOperationsErrorState) {
        toastFailed(cubit.msgOperations);
      }

      if (state is HomeGetDataSuccessState) {
        data = DataShowContacts(context);
      }
      if (state is HomeCrudOperationsSuccessState) {
        if(cubit.msgOperations=="Contact deleted successfully"||cubit.msgOperations=="All contacts deleted successfully")
          {
            toastSuccess(cubit.msgOperations);
          }
        else{
          toastSuccess(cubit.msgOperations);
          Navigator.pop(context);
          firstNameController.clear();
          lastNameController.clear();
          emailController.clear();
          phoneNumberController.clear();
        }

      }
    }, builder: (context, state) {
      return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                if(state is HomeCrudOperationsLoadingState)
                  const LinearProgressIndicator(),
                ConditionalBuilder(
                  condition: state is! HomeGetDataLoadingState,
                  builder: (BuildContext context) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 0.7),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: PaginatedDataTable(
                        header: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                cubit.msgOperations = "";
                                showModalBottomSheet(isScrollControlled: true,context: context, builder: (context) =>
                                    SizedBox(
                                      width: double.infinity,
                                      child: SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children:  [
                                              TextField(
                                                controller: firstNameController,
                                                decoration: const InputDecoration(
                                                  labelText: 'First Name',
                                                ),
                                              ),
                                              TextField(
                                                controller: lastNameController,
                                                decoration: const InputDecoration(
                                                  labelText: 'Last Name',
                                                ),
                                              ),
                                              TextField(
                                                controller: emailController,
                                                keyboardType:
                                                TextInputType.emailAddress,
                                                decoration: const InputDecoration(
                                                  labelText: 'Email',
                                                ),
                                              ),
                                              TextField(
                                                controller: phoneNumberController,
                                                keyboardType: TextInputType.phone,
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                ],
                                                decoration: const InputDecoration(
                                                  labelText: 'Phone Number',
                                                ),
                                              ),
                                              const SizedBox(height: 16.0),
                                              SizedBox(
                                                width: double.infinity,
                                                child: ElevatedButton(
                                                  child: const Text('Add'),
                                                  onPressed: () {
                                                    setState(() {
                                                      Contacts data = Contacts(
                                                        action: "add",
                                                        email: emailController.text,
                                                        firstName:
                                                        firstNameController.text,
                                                        lastName:
                                                        lastNameController.text,
                                                        phoneNumber:
                                                        phoneNumberController.text,
                                                      );
                                                      cubit.crudOperationsContact(data);
                                                    });
                                                  },
                                                ),
                                              ),

                                              Padding(
                                                padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom,),
                                                child: const SizedBox(height: 20,),
                                              ),


                                            ],
                                          ),
                                        ),
                                      ),
                                    ));


                              },
                              child: const Text("Add Contacts"),
                            ),
                            ElevatedButton(
                              onPressed:cubit.contacts.isNotEmpty? () {

                                Contacts data = Contacts(
                                    action: "deleteAll",
                                );
                                HomeCubit.get(context).crudOperationsContact(data);
                              }:null,
                              child: const Text("Delete All Contacts"),
                            ),
                          ],
                        ),
                        primary: false,
                        showFirstLastButtons: true,
                        source: data,
                        columns: const [
                          DataColumn(
                              label: Text(
                            'id',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                          DataColumn(
                              label: Text(
                            'First Name',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                          DataColumn(
                              label: Text(
                            'Last Name',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                          DataColumn(
                              label: Text(
                            'Email',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                          DataColumn(
                              label: Text(
                            'Phone Number',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                          DataColumn(
                              label: Text(
                            'Edit',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                          DataColumn(
                              label: Text(
                            'Delete',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                        ],
                      ),
                    );
                  },
                  fallback: (context) => const Center(
                    child: AdaptiveIndicator(),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class DataShowContacts extends DataTableSource {
  final BuildContext context;
  late final List<Map<String, dynamic>> data;

  DataShowContacts(this.context) {
    data = List.generate(
        HomeCubit.get(context).contacts.length,
        (index) => {
              "Id": HomeCubit.get(context).contacts[index].id,
              "First Name": HomeCubit.get(context).contacts[index].firstName,
              "Last Name": HomeCubit.get(context).contacts[index].lastName,
              "Email": HomeCubit.get(context).contacts[index].email,
              "Phone Number":
                  HomeCubit.get(context).contacts[index].phoneNumber,
              "Edit": const Icon(Icons.edit),
              "Delete": const Icon(Icons.delete),
            });
  }

  @override
  DataRow? getRow(int index) {
    final TextEditingController updateFirstNameController = TextEditingController(text: HomeCubit.get(context).contacts[index].firstName);
    final TextEditingController updateLastNameController = TextEditingController(text: HomeCubit.get(context).contacts[index].lastName);
    final TextEditingController updateEmailController = TextEditingController(text: HomeCubit.get(context).contacts[index].email);
    final TextEditingController updatePhoneNumberController = TextEditingController(text: HomeCubit.get(context).contacts[index].phoneNumber);
    // updateFirstNameController.text=HomeCubit.get(context).contacts[index].firstName!;
    // updateLastNameController.text=HomeCubit.get(context).contacts[index].lastName!;
    // updateEmailController.text=HomeCubit.get(context).contacts[index].firstName!;
    // updatePhoneNumberController.text=HomeCubit.get(context).contacts[index].firstName!;
    return DataRow(cells: [
      DataCell(Text(
        data[index]['Id'].toString(),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        data[index]['First Name'].toString(),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        data[index]['Last Name'].toString(),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        data[index]['Email'].toString(),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        data[index]['Phone Number'].toString(),
        textAlign: TextAlign.center,
      )),
      DataCell(IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () {
          HomeCubit.get(context).msgOperations = "";
          showModalBottomSheet(isScrollControlled: true,context: context, builder: (context) =>
              SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children:  [
                        TextField(
                          controller: updateFirstNameController,
                          decoration: const InputDecoration(
                            labelText: 'First Name',
                          ),
                        ),
                        TextField(
                          controller: updateLastNameController,
                          decoration: const InputDecoration(
                            labelText: 'Last Name',
                          ),
                        ),
                        TextField(
                          controller: updateEmailController,
                          keyboardType:
                          TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                          ),
                        ),
                        TextField(
                          controller: updatePhoneNumberController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter
                                .digitsOnly,
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            child: const Text('Edit'),
                            onPressed: () {
                                Contacts data = Contacts(
                                  id: HomeCubit.get(context).contacts[index].id,
                                  action: "edit",
                                  email: updateEmailController.text,
                                  firstName:
                                  updateFirstNameController.text,
                                  lastName:
                                  updateLastNameController.text,
                                  phoneNumber:
                                  updatePhoneNumberController.text,
                                );
                                HomeCubit.get(context).crudOperationsContact(data);
                            },
                          ),
                        ),

                        Padding(
                          padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom,),
                          child: const SizedBox(height: 20,),
                        ),


                      ],
                    ),
                  ),
                ),
              ));
        },
      )),
      DataCell(IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          AwesomeDialog(
            customHeader: Icon(Icons.close,size:100,color: Theme.of(context).primaryColor,),
            btnOkColor: Theme.of(context).primaryColor,
            btnOkText: "yes",
            context: context,
            animType: AnimType.leftSlide,
            headerAnimationLoop: false,
            dialogType: DialogType.error,
            showCloseIcon: true,
            title:'Are you sure to delete this contact?\n\n'
                'Id: ${HomeCubit.get(context).contacts[index].id}\n'
                'First Name: ${HomeCubit.get(context).contacts[index].firstName}\n'
                'Last Name: ${HomeCubit.get(context).contacts[index].lastName}\n'
                'Email: ${HomeCubit.get(context).contacts[index].email}\n'
                'Phone Number: ${HomeCubit.get(context).contacts[index].phoneNumber}',
            btnOkOnPress: () {
              Contacts data = Contacts(
                id: HomeCubit.get(context).contacts[index].id,
                action: "delete",
              );
              HomeCubit.get(context).crudOperationsContact(data);
            },
            btnCancelOnPress:(){} ,
            btnOkIcon: Icons.check_circle,
            onDismissCallback: (type) {},
          ).show();
        },
      )),
    ]);
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => data.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}
