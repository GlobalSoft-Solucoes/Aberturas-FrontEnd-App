// URL DO SERVIDOR DO PROJETO ABERTURAS

const UrlServidor = 
'http://51.222.32.179:3333/';
// 'http://198.50.134.117:4321/';

//
// API'S PARA A TABELA GRUPO_MEDIDAS
const CadastrarGrupoMedidas = UrlServidor + 'GrupoMedidas/cadastrar/';
const ListarTodosGrupoMedidas = UrlServidor +  'GrupoMedidas/listarTodos/';
const DeletarGrupoMedidas = UrlServidor +  'GrupoMedidas/deletar/';
const EditarGrupoMedidas = UrlServidor + 'GrupoMedidas/editar/';
const ListarGruposFinalizados = UrlServidor + 'GrupoMedidas/ListaGruposFinalizados/';
const ListarUltimoIdGrupoCadastrado = UrlServidor +  'GrupoMedidas/ListaUltimoGrupoCadastrado';
const AlterarStatusParaFinalizado = UrlServidor + 
    'GrupoMedidas/AlteraStatusProcessoParaFinalizado/';
const AlterarStatusParaEnviado = UrlServidor + 
    'GrupoMedidas/AlteraStatusProcessoParaEnviado/';
const AlterarStatusParaCadastrado = UrlServidor + 
    'GrupoMedidas/AlteraStatusProcessoParaCadastrado/';
const BuscarGrupoPorId = UrlServidor +  'GrupoMedidas/BuscaGrupoPorId/';
const StatusRemoverGrupo = UrlServidor +  'GrupoMedidas/StatusRemoverGrupo/';
const StatusExcluirGrupo = UrlServidor +  'GrupoMedidas/StatusExcluirGrupo/';
const StatusNullGrupo = UrlServidor + 'GrupoMedidas/StatusNullGrupo/';
const ListarGrupoComStatusRemovido = UrlServidor + 'GrupoMedidas/ListarGruposRemovidos/';

// API'S PARA A TABELA MEDIDA_UNT
const CadastrarMedidaUnt = UrlServidor + 'MedidaUnt/cadastrar/';
const EditarMedidaUnt = UrlServidor + 'MedidaUnt/editar/';
const DeletarMedidaUnt = UrlServidor + 'MedidaUnt/deletar/';
const ListarMedidasPorGrupo = UrlServidor + 'MedidaUnt/ListarPorGrupoMedidas/';
const BuscarMedidaUntPorId = UrlServidor + 'MedidaUnt/BuscarUnicoRegistro/';

// API'S PARA A TABELA IMOVEL
const CadastrarImovel = UrlServidor + 'imovel/Cadastrar/';
const ListarTodosImoveis = UrlServidor + 'imovel/ListarTodos/';
const EditarImovel = UrlServidor + 'imovel/editar/';
const DeletarImovel = UrlServidor + 'imovel/deletar/';
const BuscaImovelPorNome = UrlServidor + 'imovel/BuscarUnicoRegistro/';

// API'S PARA A TABELA USUÁRIO
const CadastrarUsuario = UrlServidor + 'usuario/Cadastrar/';
const LoginUsuario = UrlServidor + 'usuario/LogarUsuario';
const VerficarSeEmailEstaDisponivel = UrlServidor + 'usuario/ValidarEmail/';
const DeletarUsuario = UrlServidor + 'usuario/Deletar/';
const RecuperarSenhaUsuario = UrlServidor + 'usuario/RecuperaSenha/AlterarSenha/';
const ListarUsuariosPorEmpresa = UrlServidor + 'usuario/ListarUsuariosPorEmpresa/';
const BuscaIdUsuarioLogado = UrlServidor + 'usuario/BuscarIdUsuarioLogado/';
const BuscaEmpresaPorUsuario = UrlServidor + 'usuario/BuscaEmpresaPorUsuario/';
const EditarUsuario = UrlServidor + 'usuario/Editar/';
const VerificaCodAdm = UrlServidor + 'usuario/VerificaCodAdm/';
const BuscarDadosUsuarioLogado = UrlServidor + 'usuario/BuscarDadosUsuarioLogado/';
const BuscarUsuarioPorId = UrlServidor + 'usuario/BuscaUsuarioPorId/';

// API'S PARA A TABELA EMPRESA
const BuscarCodigoAdm = UrlServidor + 'empresa/buscarCodigoAdm/';
const BuscarCodigoAcessoEmp = UrlServidor + 'empresa/buscarCodigoEmp/';
const BuscarEmpresaPorId = UrlServidor + 'empresa/BuscarEmpresaPorId/';

// API'S PARA A DOBRADIÇA
const CadastrarDobradica = UrlServidor + 'Dobradica/Cadastrar/';
const ListarTodosDobradica = UrlServidor + 'Dobradica/ListarTodos/';
const EditarDobradica = UrlServidor + 'Dobradica/editar/';
const DeletarDobradica = UrlServidor + 'Dobradica/deletar/';
const BuscaDobradicaPorNome = UrlServidor + 'Dobradica/BuscarUnicoRegistro/';

// API'S PARA A TABELA FECHADURA
const CadastrarFechadura = UrlServidor + 'fechadura/Cadastrar';
const ListarTodosFechadura = UrlServidor + 'fechadura/ListarTodos';
const EditarFechadura = UrlServidor + 'fechadura/editar/';
const DeletarFechadura = UrlServidor + 'fechadura/deletar/';
const BuscaFechaduraPorNome = UrlServidor + 'fechadura/BuscarUnicoRegistro';

// API'S PARA A TABELA PIVOTANTE
const CadastrarPivotante = UrlServidor + 'pivotante/Cadastrar';
const ListarTodosPivotante = UrlServidor + 'pivotante/ListarTodos';
const EditarPivotante = UrlServidor + 'pivotante/editar/';
const DeletarPivotante = UrlServidor + 'pivotante/deletar/';
const BuscaPivotantePorNome = UrlServidor + 'pivotante/BuscarUnicoRegistro';

// API'S PARA A TABELA TIPO_PORTA
const CadastrarTipoPorta = UrlServidor + 'TipoPorta/Cadastrar';
const ListarTodosTipoPorta = UrlServidor + 'TipoPorta/ListarTodos/';
const EditarTipoPorta = UrlServidor + 'TipoPorta/editar/';
const DeletarTipoPorta = UrlServidor + 'TipoPorta/Deletar/';
const BuscaTipoPortaPorId = UrlServidor + 'TipoPorta/BuscaTipoPortaPorId/';

// ===== API'S PARA A TABELA COD_REFERENCIA =======
const CadastrarCodReferencia = UrlServidor + 'CodReferencia/Cadastrar';
const EditarCodReferencia = UrlServidor + 'CodReferencia/editar/';
const DeletarCodReferencia = UrlServidor + 'CodReferencia/deletar/';
const ListarTodosCodReferencia = UrlServidor + 'CodReferencia/ListarTodos';
const BuscarCodReferenciaPorId = UrlServidor + 'CodReferencia/BuscarUnicoRegistro';