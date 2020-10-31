import 'package:mobx/mobx.dart';
part 'IdGrupoMedidas_Store.g.dart';

class IdGrupoMedidasStore = _IdGrupoMedidasStoreBase with _$IdGrupoMedidasStore;

abstract class _IdGrupoMedidasStoreBase with Store {
  @observable
  int idGrupoMedidas;
  @action
  void novoValor(int value) => idGrupoMedidas = value;
}
