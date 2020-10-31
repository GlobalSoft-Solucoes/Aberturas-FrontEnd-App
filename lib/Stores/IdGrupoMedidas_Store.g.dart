// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'IdGrupoMedidas_Store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$IdGrupoMedidasStore on _IdGrupoMedidasStoreBase, Store {
  final _$idGrupoMedidasAtom =
      Atom(name: '_IdGrupoMedidasStoreBase.idGrupoMedidas');

  @override
  int get idGrupoMedidas {
    _$idGrupoMedidasAtom.reportRead();
    return super.idGrupoMedidas;
  }

  @override
  set idGrupoMedidas(int value) {
    _$idGrupoMedidasAtom.reportWrite(value, super.idGrupoMedidas, () {
      super.idGrupoMedidas = value;
    });
  }

  final _$_IdGrupoMedidasStoreBaseActionController =
      ActionController(name: '_IdGrupoMedidasStoreBase');

  @override
  void novoValor(int value) {
    final _$actionInfo = _$_IdGrupoMedidasStoreBaseActionController.startAction(
        name: '_IdGrupoMedidasStoreBase.novoValor');
    try {
      return super.novoValor(value);
    } finally {
      _$_IdGrupoMedidasStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
idGrupoMedidas: ${idGrupoMedidas}
    ''';
  }
}
