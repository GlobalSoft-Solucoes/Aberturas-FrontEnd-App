// URL DO SERVIDOR DO PROJETO ABERTURAS

final UrlServidor = ('http://globalsoft-st-com-br.umbler.net/');

// API'S PARA A TABELA GRUPO_MEDIDAS
const CadastrarGrupoMedidas = 'GrupoMedidas/cadastrar/';
const ListarTodosGrupoMedidas = 'GrupoMedidas/listarTodos/';
const DeletarGrupoMedidas = 'GrupoMedidas/deletar/';
const EditarGrupoMedidas = 'GrupoMedidas/editar/';
const ListarGruposFinalizados = 'GrupoMedidas/ListaGruposFinalizados/';
const ListarUltimoIdGrupoCadastrado = 'GrupoMedidas/ListaUltimoGrupoCadastrado';
const AlterarStatusParaFinalizado = 'GrupoMedidas/AlteraStatusParaFinalizado/';
const AlterarStatusParaEnviado = 'GrupoMedidas/AlteraStatusParaEnviado/';
const AlterarStatusParaNull = 'GrupoMedidas/AlteraStatusParaNull/';
const BuscarGrupoPorId = 'GrupoMedidas/BuscaGrupoPorId/';
const StatusRemoverGrupo = 'GrupoMedidas/StatusRemoverGrupo/';
const StatusExcluirGrupo = 'GrupoMedidas/StatusExcluirGrupo/';
const StatusNullGrupo = 'GrupoMedidas/StatusNullGrupo/';
const ListarGrupoComStatusRemovido = 'GrupoMedidas/ListarGruposRemovidos/';

// API'S PARA A TABELA MEDIDA_UNT
const CadastrarMedidaUnt = 'MedidaUnt/cadastrar/';
const EditarMedidaUnt = 'MedidaUnt/editar/';
const DeletarMedidaUnt = 'MedidaUnt/deletar/';
const ListarMedidasPorGrupo = 'MedidaUnt/ListarPorGrupoMedidas/';
const BuscaUnicoRegistro = 'MedidaUnt/BuscarUnicoRegistro/';

// API'S PARA A TABELA IMOVEL
const CadastrarImovel = 'imovel/Cadastrar/';
const ListarTodosImoveis = 'imovel/ListarTodos/';
const EditarImovel = 'imovel/editar/';
const DeletarImovel = 'imovel/deletar/';
const BuscaImovelPorNome = 'imovel/BuscarUnicoRegistro/';

// API'S PARA A TABELA USUÁRIO
const CadastrarUsuario = 'Usuario/Cadastrar/';
const LoginUsuario = 'Usuario/LogarUsuario/';
const VerficarSeEmailEstaDisponivel = 'Usuario/ValidarEmail/';
const DeletarUsuario = 'Usuario/Deletar/';
const RecuperarSenhaUsuario = 'Usuario/RecuperaSenha/AlterarSenha/';
const ListarUsuariosPorEmpresa = 'Usuario/ListarUsuariosPorEmpresa/';
const BuscaIdUsuarioLogado = 'Usuario/BuscarIdUsuarioLogado/';
const BuscaEmpresaPorUsuario = 'Usuario/BuscaEmpresaPorUsuario/';
const EditarUsuario = 'Usuario/Editar/';
const VerificaCodAdm = 'Usuario/VerificaCodAdm/';
const BuscarDadosUsuarioLogado = 'Usuario/BuscarDadosUsuarioLogado/';
const BuscarUsuarioPorId = 'usuario/BuscaUsuarioPorId/';
// API'S PARA A TABELA EMPRESA
const BuscarCodigoAdm = 'Empresa/buscarCodigoAdm/';
const BuscarCodigoAcessoEmp = 'Empresa/buscarCodigoEmp/';
const BuscarEmpresaPorId = 'Empresa/BuscarEmpresaPorId/';

// API'S PARA A DOBRADIÇA
const CadastrarDobradica = 'Dobradica/Cadastrar/';
const ListarTodosDobradica = 'Dobradica/ListarTodos/';
const EditarDobradica = 'Dobradica/editar/';
const DeletarDobradica = 'Dobradica/deletar/';
const BuscaDobradicaPorNome = 'Dobradica/BuscarUnicoRegistro/';

// API'S PARA A TABELA FECHADURA
const CadastrarFechadura = 'Fechadura/Cadastrar';
const ListarTodosFechadura = 'Fechadura/ListarTodos';
const EditarFechadura = 'Fechadura/editar/';
const DeletarFechadura = 'Fechadura/deletar/';
const BuscaFechaduraPorNome = 'Fechadura/BuscarUnicoRegistro';

// API'S PARA A TABELA PIVOTANTE
const CadastrarPivotante = 'Pivotante/Cadastrar';
const ListarTodosPivotante = 'Pivotante/ListarTodos';
const EditarPivotante = 'Pivotante/editar/';
const DeletarPivotante = 'Pivotante/deletar/';
const BuscaPivotantePorNome = 'Pivotante/BuscarUnicoRegistro';
