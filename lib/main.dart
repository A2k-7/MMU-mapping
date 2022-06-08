// import 'dart:html';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>
    with AutomaticKeepAliveClientMixin<MyApp> {
  @override
  bool get wantKeepAlive => true;

  int memSize = -1;
  int pageSize = -1;
  int n = -1;
  bool error = false;
  int m = -1;
  int pageNumber = -1;
  FilePickerResult? result;
  double logBase(num x, num base) => log(x) / log(base);
  double log2(num x) => logBase(x, 2);
  var _messangerKey = GlobalKey<ScaffoldMessengerState>();
  var physicalToLogical = <int, int>{};
  var pageTable = <int, String>{};
  var logicalTable = <String?>[];
  var physicalTable = <int, String>{};
  var logicalTable2 = <int, String>{};
  var physicalRows = <int, int>{};
  var address;
  var pageCntroller = <TextEditingController>[];
  var logicalController = <TextEditingController>[];
  var physicalList = <DataRow>[];
  var logicalList = <DataRow>[];
  var mappingList = <DataRow>[];
  var phyaddress;
  var logicaladdress;
  var binary = <Widget>[];
  var tempBinary = [];
  var data = "";
  var errorMsg = [
    "Write something",
    "Write something",
    "Write something",
    "Write something",
    "no error"
  ];

  int binaryToString(something) {
    int result = 0;
    something = something.split("").reversed.toList().join("");

    for (var i = 0; i < something.length; i++) {
      print(something[i]);
      print(pow(2, i).toInt());
      result += pow(2, i).toInt() * (int.parse(something[i]));
    }
    print("object is $result where something is $something");
    return result;
  }

  void openFile() async {
    result = await FilePicker.platform.pickFiles();
    if (result != null) {
      String? temp = result?.files.single.path;

      File file = File(temp!);
      var x = await file.readAsString();
      var obj = jsonDecode(x);
      print(obj);
      n = obj["n"];
      m = obj["m"];
      var count = 0;
      logicalTable = List.from(obj["logicalTable"]);
      for (var i = 0; i < obj["physicalToLogicalKeys"].length; i++) {
        physicalToLogical[obj["physicalToLogicalKeys"][i]] =
            obj["physicalToLogicalValues"][i];
      }

      for (var i = 0; i < obj["pageTableKeys"].length; i++) {
        physicalToLogical[List.from(obj["pageTableKeys"])[i]] =
            int.parse(List.from(obj["pageTableValues"])[i]);
      }

      for (var i = 0; i < obj["physicalTableKeys"].length; i++) {
        physicalTable[List.from(obj["physicalTableKeys"])[i]] =
            (List.from(obj["physicalTableValues"])[i]);
      }

      address = obj["address"];
      pageSize = obj["pageSize"];
      memSize = obj["mems"];
      pageNumber = memSize ~/ pageSize;
      print(memSize);
      print(pageSize);
      // print("page num" + pageNumber.toString());
      print("page num" + pageNumber.toString());
      errorMsg = List.from(errorMsg.map((e) => ""));
      setState(() {});

      click();
    }
  }

  void readData() {
    var something = stringToBinary(phyaddress.toString())
        .substring(0, m - n)
        .split("")
        .toList()
        .join("");
    var something2 = stringToBinary(phyaddress.toString())
        .substring(m - n)
        .split("")
        .toList()
        .join("");

    var result = binaryToString(something);
    var result2 = binaryToString(something2);
    print(physicalToLogical);
    if (physicalToLogical[result] == null || physicalToLogical[result]! < 0) {
      return;
    }
    print("index is $result");
    print("p t l " + physicalToLogical.toString());
    print("ph t is " + physicalToLogical[result].toString());
    print("page table " + pageTable[result].toString());
    // print(physicalTable[phyaddress]);
    print(logicalTable);
    print(pageTable);
    logicalTable[(pow(2, n) * physicalToLogical[result]! + result2).toInt()] =
        physicalTable[phyaddress];
    // logicalTable2[(pow(2, n) * result + result2).toInt()] =
    //     physicalTable[phyaddress]!;

    if (logicaladdress != null) {
      logicalTable[logicaladdress] = physicalTable[phyaddress];
      // logicalTable2[logicaladdress] = physicalTable[phyaddress]!;
    }

    // }    logicalTable[physicalToLogical[result]!.toInt() != null
    //     ? physicalToLogical[result]!.toInt()
    //     : 0 + (pow(2, n) * result2).toInt()] = physicalTable[phyaddress];

    // if (logicaladdress != null) {
    //   logicalTable[logicaladdress] = physicalTable[phyaddress];
    // }

    // logicalTable2[physicalToLogical[result]!.toInt() != null
    //     ? physicalToLogical[result]!.toInt()
    //     : 0 + (pow(2, n) * result2).toInt()] = physicalTable[phyaddress]!;
    // if (logicaladdress != null) {
    //   logicalTable2[logicaladdress] = physicalTable[phyaddress]!;
    // }
    click();
    // pageTable.
  }

  void insertData(data, address) {
    // print();
    var something = stringToBinary(address.toString())
        .substring(0, m - n)
        .split("")
        .toList()
        .join("");
    var something2 = stringToBinary(address.toString())
        .substring(m - n)
        .split("")
        .toList()
        .join("");
    print("string to binary = " + stringToBinary(address.toString()));
    print(" binary to string = " + binaryToString(something2).toString());

    // print(something);
    var result2 = (address! % (pow(2, n))).toString();
    var result = (address / pow(2, n)).floor();

    // var result = binaryToString(something);
    // var result = binaryToString(something);
    // var result2 = binaryToString(something2);

    // binaryToString(something);
    // print("debugging from here");
    // print(stringToBinary(address.toString()));
    // print(something);
    // print(something2);
    // print(result);
    // print(result2);
    // print(pageTable[result]);
    logicalTable[address] = data;
    print(result2);
    print(result);
    if (pageTable[result] != null &&
        int.tryParse(pageTable[result].toString()) is int) {
      physicalTable[int.parse(pageTable[result]!) * pow(2, n).toInt() +
          int.parse(result2.toString())] = data;
      click();
      setState(() {});
    } else {
      errorAlert(4, "Paging table is not complete yet");
    }
  }

  String stringToBinary(value) {
    int reminder = 0, result = 0, counter = 0;
    var stack = [];
    result = (int.parse(value) / 2).floor();
    stack.add(int.parse(value) % 2);
//     print(result);

    while (result != 0) {
      stack.add(result % 2);
      result = (result / 2).floor();
    }
    while (stack.length < 4) {
      stack.insert(stack.length, 0);
    }
    return stack.reversed.toList().join("");
  }

  void strtoB(value) {
    int reminder = 0, result = 0, counter = 0;
    var stack = [];
    result = (int.parse(value) / 2).floor();
    stack.add(int.parse(value) % 2);
//     print(result);

    while (result != 0) {
      stack.add(result % 2);
      result = (result / 2).floor();
    }
    for (var i in stack.reversed.toList()) {
      binary.add(Container(
        child: Center(
          child: Text(
            i.toString(),
            style: TextStyle(color: Colors.red),
          ),
        ),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          // color: Colors.blue[100]
        ),
      ));
      counter++;
    }
    while (counter < 4) {
      binary.insert(
          0,
          Container(
            child: Center(
              child: Text(
                0.toString(),
                style: TextStyle(color: Colors.red),
              ),
            ),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              // color: Colors.blue[100]
            ),
          ));
      counter++;
    }
    // tempBinary.add(stack.reversed.toList());
  }

  void click() {
    // var l = lis
    // logicalTable.clear();
    // logicalController.clear();
    // pageCntroller.clear();
    logicalList.clear();
    physicalList.clear();
    mappingList.clear();

    setState(() {
      for (var i in errorMsg) {
        if (!i.isEmpty) {
          return;
        }
      }

      var tempList = [for (var j = 0; j < pow(2, n); j++) j];
      for (var i = 0; i < pow(2, m) / pow(2, n); i++) {
        pageCntroller.add(TextEditingController());
        mappingList.add(DataRow(cells: [
          DataCell(Text(i.toString())),
          DataCell(TextField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            controller: pageCntroller[i],
            onChanged: (value) {
              setState(() {
                // if (pageTable[i] != null) {
                //   if (physicalToLogical[int.parse(pageTable[i]!)] != null) {
                //     physicalToLogical[int.parse(pageTable[i]!)] = -1;

                //   }
                // }
                if (value.isEmpty) {
                  return;
                }

                if (pageTable.containsValue(value)) {
                  print("it contains ");
                  print(pageTable);
                  print("after deleting...");
                  pageTable.removeWhere((key, v) => v == value);
                  // pageTable.remove(physicalToLogical[int.parse(value)]);

                  print(pageTable);
                }
                if (physicalToLogical.containsValue(i)) {
                  physicalToLogical.removeWhere((key, v) => v == i);
                }
                physicalToLogical[int.parse(value)] = i;
                pageTable[i] = value;
              });
              // pageTable[i] = int.parse(value);
            },
          )),
        ]));
      }
      for (var row = 0; row < pageNumber; row++) {
        physicalRows[row] = (row * pow(2, n)).toInt();
        // physicalToLogical[]
        for (var i in tempList) {
          physicalList.add(DataRow(cells: [
            DataCell(Text((i + (row * pow(2, n))).toString())),
            DataCell(Text(physicalTable[(i + (row * pow(2, n)))].toString())),
            DataCell(Text(row.toString())),
            DataCell(Text((row * pow(2, n)).toString())),
          ]));
        }
      }
      tempList = [for (var j = 0; j < pow(2, m) / pow(2, n); j++) j];

      for (var row in tempList) {
        for (var i = 0; i < pow(2, n); i++) {
          logicalList.add(DataRow(cells: [
            DataCell(Text((i + (row * pow(2, n))).toString())),
            DataCell(
                Text(logicalTable[i + (row * pow(2, n).toInt())].toString())),
            DataCell(Text(row.toString())),
          ]));
        }
      }
    });
  }

  void errorAlert(index, value) {
    setState(() {
      errorMsg[index] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Paging Project"),
            bottom: TabBar(tabs: [
              Tab(
                text: "Inputs",
              ),
              Tab(
                text: "Outputs",
              ),
              Tab(
                text: "Files",
              ),
            ]),
          ),
          body: TabBarView(children: [
            SingleChildScrollView(
              child: Wrap(
                runSpacing: 20,
                // alignment: WrapAlignment.start,
                // crossAxisCount: 2,
                // crossAxisSpacing: 1,
                // mainAxisSpacing: 0,
                // maxCrossAxisExtent: 700,

                // direction: Axis.vertical,
                spacing: 20,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    // color: Colors.amber,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: TextField(
                              onChanged: (value) {
                                print(value);
                                if (value.length > 0) {
                                  memSize = int.parse(value);

                                  // print(
                                  //     log2(memSize) - log2(memSize).toInt() != 0);
                                  if (memSize > 1) {
                                    error =
                                        log2(memSize) - log2(memSize).toInt() !=
                                                0
                                            ? true
                                            : false;
                                  } else {
                                    error = true;
                                  }
                                  if (error) {
                                    errorAlert(0,
                                        "Memory size should be larger than 1 and multiple of 2");
                                  } else {
                                    if (pageSize > -1) {
                                      pageNumber = memSize ~/ pageSize;
                                    }
                                    errorAlert(0, "");
                                  }
                                } else {
                                  errorAlert(0, "write something");
                                }
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(30),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          (Radius.circular(7)))),
                                  hintText: "Enter the memory size in bytes")),
                          width: MediaQuery.of(context).size.width * .5,
                          // width: MediaQuery.of(context).size.width * .50,
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width * .13,
                            child: Text(errorMsg[0]))
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * .5,
                        child: TextField(
                            onChanged: (value) {
                              if (value.length > 0) {
                                pageSize = int.parse(value);
                                if (pageSize > 1) {
                                  error =
                                      log2(pageSize) - log2(pageSize).toInt() !=
                                              0
                                          ? true
                                          : false;
                                } else {
                                  error = true;
                                }
                                if (error) {
                                  errorAlert(1,
                                      "Page size should be larger than 1 and multiple of 2");
                                } else {
                                  pageNumber = memSize ~/ pageSize;
                                  errorAlert(1, "");
                                }
                              } else {
                                errorAlert(1, "write something");
                              }
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(30),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all((Radius.circular(7)))),
                                hintText: "Enter the page size in bytes")),
                        // width: MediaQuery.of(context).size.width * .50,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width * .13,
                          child: Text(errorMsg[1]))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: TextField(
                            onChanged: (value) {
                              if (value.length > 0) {
                                n = int.parse(value);
                                error = n > 0 ? false : true;
                                if (error) {
                                  errorAlert(2, "N should be even !");
                                } else {
                                  errorAlert(2, "");
                                }
                              } else {
                                errorAlert(2, "write something");
                              }
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(30),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all((Radius.circular(7)))),
                                hintText: "Enter the n value")),
                        width: MediaQuery.of(context).size.width * .50,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width * .13,
                          child: Text(errorMsg[2]))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: TextField(
                            onChanged: (value) {
                              if (value.length > 0) {
                                m = int.parse(value);

                                error = m > 0 ? false : true;
                                if (error) {
                                  errorAlert(3, "M should be even !");
                                } else {
                                  errorAlert(3, "");
                                }
                              } else {
                                errorAlert(3, "write something");
                              }
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(30),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all((Radius.circular(7)))),
                                hintText: "Enter the m value")),
                        width: MediaQuery.of(context).size.width * .50,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width * .13,
                          child: Text(errorMsg[3]))
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  logicalTable.length =
                                      int.parse(pow(2, m).toString());

                                  click();
                                },
                                child: Text("create the table"))
                          ],
                        ),
                        SizedBox(height: 10),
                        Text("Number of pages is : " + pageNumber.toString()),
                        SizedBox(height: 10),
                        Text("number of addresses is : " +
                            (pow(2, m)).toString()),
                        SizedBox(height: 10),
                        Text("number of addressess per page is : " +
                            (pow(2, n)).toString()),
                        SizedBox(
                          height: 20,
                        ),
                        Wrap(children: binary),
                        SizedBox(
                          height: 10,
                        )
                      ])),
                  Container(
                    width: 420,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.blue)),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                          // width: 10,
                        ),
                        Text("Memory reading & writing"),
                        SizedBox(
                          height: 20,
                          // width: 10,
                        ),
                        Container(
                          child: Text(
                            errorMsg[4],
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.red,
                                fontStyle: FontStyle.italic),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: TextField(
                                onChanged: (value) {
                                  if (value.isNotEmpty && m > 0 && n > 0) {
                                    if (int.parse(value) > pow(2, m) - 1) {
                                      binary.clear();

                                      errorAlert(4, "Address out of range");
                                    } else {
                                      binary.clear();

                                      strtoB(value);
                                      address = int.parse(value);
                                      errorAlert(4, "");
                                    }
                                  } else {
                                    if (value.isEmpty) {
                                      binary.clear();

                                      errorAlert(4, "Address is not valid");
                                    }
                                  }
                                },
                                decoration: InputDecoration(
                                    hintText: ("Enter the address")),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                ],
                              ),
                              width: 200,
                            ),
                            Container(
                              child: TextField(
                                onChanged: (value) {
                                  data = value;
                                  if (!data.isEmpty) {
                                    errorAlert(4, "");
                                  }
                                },
                                decoration: InputDecoration(
                                    hintText: ("Enter the Data")),
                              ),
                              width: 200,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              if (data.toString().isEmpty) {
                                errorAlert(4, "No data was passed");
                                return;
                              }
                              _messangerKey.currentState?.showSnackBar(
                                  SnackBar(content: Text("hello")));

                              print(data);
                              print(address);
                              if (address == null) {
                                return;
                              }
                              insertData(data, address);
                              print(logicalTable[address]);
                            },
                            child: Text("Insert Data")),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: TextField(
                                onChanged: (value) {
                                  if (value.isNotEmpty && m > 0 && n > 0) {
                                    if (int.parse(value) > pow(2, m) - 1) {
                                      binary.clear();

                                      errorAlert(4, "Address out of range");
                                    } else {
                                      phyaddress = int.parse(value);
                                    }
                                  } else {
                                    if (value.isEmpty) {
                                      binary.clear();

                                      errorAlert(4, "Address is not valid");
                                    } else {
                                      errorAlert(4, "");
                                    }
                                  }
                                },
                                decoration: InputDecoration(
                                    hintText: ("physical address")),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                ],
                              ),
                              width: 200,
                            ),
                            Container(
                              child: TextField(
                                onChanged: (value) {
                                  data = value;
                                  if (!data.isEmpty) {
                                    logicaladdress = int.parse(value);

                                    errorAlert(4, "");
                                  } else {}
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]'))
                                ],
                                decoration: InputDecoration(
                                    hintText: ("Logical address")),
                              ),
                              width: 200,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              if (data.toString().isEmpty) {
                                errorAlert(4, "No data was passed");
                                return;
                              }
                              _messangerKey.currentState?.showSnackBar(
                                  SnackBar(content: Text("hello")));

                              print(data);
                              print(address);

                              readData();
                              print(logicalTable[address]);
                            },
                            child: Text("Load the Data"))
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        DataTable(
                            border: TableBorder.all(
                                borderRadius: BorderRadius.circular(10)),
                            columns: const [
                              DataColumn(label: Text("Page number")),
                              DataColumn(label: Text("Frame number")),
                            ],
                            rows: mappingList),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // color: Colors.amber[50],
              child: SingleChildScrollView(
                child: Center(
                  child: Wrap(
                    children: [
                      FittedBox(
                        // width: 800,
                        // decoration: BoxDecoration(color: Colors.amber[50]),
                        child: Wrap(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FittedBox(
                                alignment: Alignment.topLeft,
                                child: DataTable(
                                    border: TableBorder.all(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    columns: const [
                                      DataColumn(label: Text("Address")),
                                      DataColumn(label: Text("Content")),
                                      DataColumn(label: Text("Page Number")),
                                    ],
                                    rows: logicalList),
                              ),
                              FittedBox(
                                child: DataTable(
                                    border: TableBorder.all(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    columns: const [
                                      DataColumn(label: Text("Address")),
                                      DataColumn(label: Text("Content")),
                                      DataColumn(label: Text("Frame number")),
                                      DataColumn(label: Text("Frame Address")),
                                    ],
                                    rows: physicalList),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              child: SingleChildScrollView(
                  child: Center(
                child: Wrap(
                  direction: Axis.vertical,
                  spacing: 30,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          openFile();
                        },
                        child: Text("Load progress")),
                    ElevatedButton(
                        onPressed: () async {
                          print(pageTable.keys.toList());

                          var jsonText = jsonEncode({
                            "n": n,
                            "m": m,
                            "logicalTable": logicalTable,
                            "physicalToLogicalKeys":
                                List.from(physicalToLogical.keys),
                            "physicalToLogicalValues":
                                List.from(physicalToLogical.values),
                            "address": address,
                            // "logicalList": logicalList,
                            "pageTableKeys": List.from(pageTable.keys),
                            "pageTableValues": List.from(pageTable.values),
                            "physicalTableKeys": List.from(physicalTable.keys),
                            "physicalTableValues":
                                List.from(physicalTable.values),
                            "pageSize": pageSize,
                            "mems": memSize
                          });
                          print(jsonText);
                          String? outputFile =
                              await FilePicker.platform.saveFile(
                            dialogTitle: 'Please select an output file:',
                            fileName: 'output-file.json',
                          );

                          if (outputFile == null) {
                            // User canceled the picker
                          } else {
                            var x = File(outputFile);
                            x.writeAsString(jsonText);
                          }
                        },
                        child: Text("Save progress")),
                  ],
                ),
              )),
            )
          ]),
        ));
  }
}
