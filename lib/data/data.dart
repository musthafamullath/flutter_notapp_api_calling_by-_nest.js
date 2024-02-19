import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:note_app/data/get_all_notes_response/get_all_notes_response.dart';
import 'package:note_app/data/note_model/note_model.dart';
import 'package:note_app/data/uri.dart';

abstract class ApiCalls {
  Future<NoteModel?> createNote(NoteModel value);
  Future<List<NoteModel>> getAllNote();
  Future<NoteModel?> updateNote(NoteModel value);
  Future<void> deleteNote(String id);
}

class NoteDB extends ApiCalls {
  //singletonstart
  NoteDB.internal();
  static NoteDB instance = NoteDB.internal();
  NoteDB factory(){
    return instance;
  }
  //singletonend

  final dio = Dio();
  final url = Url();
  ValueNotifier<List<NoteModel>> noteListNotifier = ValueNotifier([]);

  NoteDB() {
    dio.options = BaseOptions(
      baseUrl: url.baseUrl,
      responseType: ResponseType.plain,
    );
  }
  @override
  Future<NoteModel?> createNote(NoteModel value) async {
    try {
      final result = await dio.post(
        url.createNote,
        data: value.toJson(),
      );
      final resultAsJson = jsonDecode(result.data);
      final note = NoteModel.fromJson(resultAsJson as Map<String, dynamic>);
      noteListNotifier.value.insert(0, note);
      noteListNotifier.notifyListeners();
      return note;
    } on DioError catch (e) {
      print(e.response?.data);
      print(e);
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
   
  }

  @override
  Future<void> deleteNote(String id) async {
   final result = await dio.delete(url.deleteNote.replaceFirst('{id}', id));
   if(result.data == null){
    return;
   }
   final index = noteListNotifier.value.indexWhere((note) => note.id == id);
   if(index == -1){
    return;
   }
   noteListNotifier.value.removeAt(index);
   noteListNotifier.notifyListeners();
  }

  @override
  Future<List<NoteModel>> getAllNote() async {
    final result = await dio.get(url.getAllNote);
    if (result.data != null) {
      final resultAsJson = jsonDecode(result.data);
      final getNoteResp = GetAllNotesResponse.fromJson(resultAsJson);
      noteListNotifier.value.clear();
      noteListNotifier.value.addAll(getNoteResp.data);
      return getNoteResp.data;
    } else {
      noteListNotifier.value.clear();
      return [];
    }
  }

  @override
  Future<NoteModel?> updateNote(NoteModel value) async {
    final result = await  dio.put(url.updateNote,data: value.toJson());
    if(result.data == null){
      return null;
    }
    //find index
    final index = noteListNotifier.value.indexWhere((note) => note.id == value.id);
    if(index == -1){
      return null;
    }
    //remove from index
    noteListNotifier.value.removeAt(index);
    //add note in that index
    noteListNotifier.value.insert(index, value);
    noteListNotifier.notifyListeners();
    return value;
  }
  NoteModel? getNoteByID(String id){
    try{
      return noteListNotifier.value.firstWhere((note) => note.id == id);
    }catch(_){
      return null;
    }
  
    
    
  }
}
