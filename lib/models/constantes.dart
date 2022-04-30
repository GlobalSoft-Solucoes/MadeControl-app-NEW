// const UrlServidor = 'http://globalsoft-solucoes.com.br:4596/';
const UrlServidor = 'https://api-madecontrol.globalsoft-solucoes.com.br/';

//
// =============== TABELA PEDIDO ================
const BuscaPedidoPorCodigo = UrlServidor + 'pedido/BuscarPorCodigoPedido/';
const BuscarPedidoPorId = UrlServidor + 'pedido/BuscarPedidoPorId/';
const CadastrarUmPedido = UrlServidor + 'pedido/Cadastrar/';
const DeletarPedido = UrlServidor + 'pedido/Deletar/';
const EditarumPedido = UrlServidor + 'pedido/Editar/';
const ListarPedidosEntregues = UrlServidor + 'pedido/ListarPedidosEntregues/';
const ListarPorGrupoPedido = UrlServidor + 'pedido/ListarPorGrupoPedido/';
const BuscaValorTotalPedidosPorData =
    UrlServidor + 'pedido/BuscaValorTotalPedidosPorData/';
const ListaPedidosAVulso = UrlServidor + 'pedido/ListarPedidosVendaAvulso/';
const BuscarPedidosPorIdCliente =
    UrlServidor + 'pedido/BuscarPedidoPorIdCliente/';

// ================= TABELA EMPRESA ==================
const BuscarEmpresaPorIdUsuario =
    UrlServidor + 'empresa/BuscarEmpresaPorIdUsuario/';

// ================ TABELA USUÁRIO =================
const ListarTodosUsuarios = UrlServidor + 'usuario/ListarTodos/';
const LogarUsuario = UrlServidor + 'usuario/LogarUsuario/';
const CadastrarUsuario = UrlServidor + 'usuario/Cadastrar/';
const DeletarUsuario = UrlServidor + 'usuario/Deletar/';
const EditarUsuario = UrlServidor + 'usuario/Editar/';
const VerificaEmailDisponivel = UrlServidor + 'usuario/validarEmail/';
const AlterarSenhaUsuario = UrlServidor + 'usuario/AlterarSenha/';
const VerificaUsuarioLogado = UrlServidor + 'usuario/VerificaUsuarioLogado/';
const BuscarUltimoUsuarioCadastrado =
    UrlServidor + 'usuario/BuscarUltimoUsuarioCadastrado/';
const BuscarUsuarioPorId = UrlServidor + 'usuario/BuscaUsuarioPorId/';

// ================ TABELA LOTE =================
const ListarTodosLotes = UrlServidor + 'lote/ListarTodos/';
const CadastrarDadosLote = UrlServidor + 'lote/Cadastrar/';
const DeletarLote = UrlServidor + 'lote/Deletar/';
const EditarLote = UrlServidor + 'lote/EditarLote/';
const BuscarUltimoLoteCadastrado =
    UrlServidor + 'lote/BuscaUltimoLoteCadastrado/';

// ================ TABELA CÁLCULO =================
const ListarCalculoPorLote = UrlServidor + 'calculo/ListarCalculosPorLote/';
const BuscaCalculoPorId = UrlServidor + 'calculo/BuscaCalculoPorID/';
const CadastrarDadosCalculo = UrlServidor + 'calculo/Cadastrar/';
const DeletarCalculo = UrlServidor + 'calculo/Deletar/';
const EditarCalculo = UrlServidor + 'calculo/Editar/';

// ================ TABELA LOGIN =================
const CadastrarRegistroLogin = UrlServidor + 'login/CadastraRegistroLogin/';
const DeletarLoginsPorData = UrlServidor + 'login/DeletarRegistrosPorData/';
const ListarDatasRegistros = UrlServidor + 'login/ListaDatasRegistros/';
const ListarRegistrosPorData = UrlServidor + 'login/ListarRegistrosPorData/';

// ================ TABELA CARGO =================
const ListarTodosCargos = UrlServidor + 'cargo/ListarTodos/';
const CadastrarCargo = UrlServidor + 'cargo/Cadastrar/';
const DeletarCargo = UrlServidor + 'cargo/Deletar/';
const EditarCargo = UrlServidor + 'cargo/Editar/';
const BuscarCargoPorId = UrlServidor + 'Cargo/BuscarCargoPorId/';

// =============== TABELA GRUPO_PEDIDO ================
const BuscaGrupoPedidoPorId =
    UrlServidor + 'GrupoPedido/BuscarGrupoPedidoPorId/';
const CadastrarGrupoPedido = UrlServidor + 'GrupoPedido/Cadastrar/';
const DeletarGrupoPedido = UrlServidor + 'GrupoPedido/Deletar/';
const EditarumGrupoPedido = UrlServidor + 'GrupoPedido/Editar/';
const AlteraStatusGrupoPedidoParaCadastrado =
    UrlServidor + 'GrupoPedido/AlteraStatusGrupoParaCadastrado/';
const AlteraStatusGrupoPedidoParaEntregue =
    UrlServidor + 'GrupoPedido/AlteraStatusGrupoParaEntregue/';
const AlteraStatusGrupoPedidoParaExcluido =
    UrlServidor + 'GrupoPedido/AlteraStatusGrupoParaExcluido/';
const AlteraTodosStatusGrupoParaExcluido =
    UrlServidor + 'GrupoPedido/AlteraTodosStatusGrupoParaExcluido/';
const AlteraStatusGrupoPedidoParaRemovido =
    UrlServidor + 'GrupoPedido/AlteraStatusGrupoParaRemovido/';
const AlteraStatusGrupoPedidoParaPronto =
    UrlServidor + 'GrupoPedido/AlteraStatusGrupoParaPronto/';
const AlteraStatusGrupoPedidoParaProducao =
    UrlServidor + 'GrupoPedido/AlteraStatusGrupoParaProducao/';
const ListarGruposPedidosCadastrados =
    UrlServidor + 'GrupoPedido/ListarTodosGrupoPedidosCadastrados/';
const ListarGrupoPedidosEntregues =
    UrlServidor + 'GrupoPedido/ListarGrupoPedidosEntregues/';
const ListarGrupoPedidosRemovidos =
    UrlServidor + 'GrupoPedido/ListarGrupoPedidosRemovidos/';
const ListarGruposPedidosProntos =
    UrlServidor + 'GrupoPedido/ListarGrupoPedidosProntos/';
const ListarGruposPedidosProducao =
    UrlServidor + 'GrupoPedido/ListarTodosGrupoPedidosProducao/';
const BuscarUltimoGrupoPedidoCadastrado =
    UrlServidor + 'GrupoPedido/BuscarUltimoGrupoPedidoCadastrado/';
const BuscaDetalhesGrupoPedidoPorId =
    UrlServidor + 'GrupoPedido/BuscaDetalhesGrupoPedidoPorId/';
const BuscaQtdMetrosPorUndMedida =
    UrlServidor + 'GrupoPedido/BuscaQtdMetrosPorUndMedida/';
const BuscarGrupoPedidosPorIdCliente =
    UrlServidor + 'GrupoPedido/BuscarGrupoPedidoPorIdCliente/';
const ListaGruposPorDataPesquisa =
    UrlServidor + 'GrupoPedido/BuscarGuposPorData/';
//--------------------------------------------------
const ListaGruposPorOpcPesquisaDia =
    UrlServidor + 'GrupoPedido/BuscarGuposPorOpcPesquisaDia/';
const ListaGruposPorOpcPesquisaSemana =
    UrlServidor + 'GrupoPedido/BuscarGuposPorOpcPesquisaSemana/';
const ListaGruposPorOpcPesquisaMes =
    UrlServidor + 'GrupoPedido/BuscarGuposPorOpcPesquisaMes/';
const ListaGruposPorOpcPesquisaAno =
    UrlServidor + 'GrupoPedido/BuscarGuposPorOpcPesquisaAno/';
const ListaGruposPorOpcPesquisaTodos =
    UrlServidor + 'GrupoPedido/BuscarGuposPorOpcPesquisaTodos/';

// ================ TABELA CLIENTE =================
const ListarTodosClientes = UrlServidor + 'cliente/ListarTodosClientes/';
const CadastrarCliente = UrlServidor + 'cliente/Cadastrar/';
const DeletarCliente = UrlServidor + 'cliente/Deletar/';
const EditarCliente = UrlServidor + 'cliente/Editar/';
const BuscarClienteporId = UrlServidor + 'Cliente/BuscarClientePorId/';

// ================ TABELA PALLET =================
const ListarTodosOsPallet = UrlServidor + 'pallet/ListarTodosPallet/';
const CadastrarPallet = UrlServidor + 'pallet/Cadastrar/';
const DeletarPallet = UrlServidor + 'pallet/Deletar/';
const EditarPallet = UrlServidor + 'pallet/Editar/';
const BuscarPalletporId = UrlServidor + 'pallet/BuscarPalletPorId/';

// ================ TABELA ROMANEIO =================
const ListarTodosRomaneiosCadastrados =
    UrlServidor + 'romaneio/ListarTodosRomaneiosCadastrados/';
const ListarTodosRomaneiosRemovidos =
    UrlServidor + 'romaneio/ListarTodosRomaneiosRemovidos/';
const BuscarRomaneioPorId = UrlServidor + 'romaneio/BuscarRomaneioPorId/';
const CadastrarRomaneio = UrlServidor + 'romaneio/Cadastrar/';
const DeletarRomaneio = UrlServidor + 'romaneio/Deletar/';
const EditarRomaneio = UrlServidor + 'romaneio/Editar/';
const AlteraStatusRomaneioParaExcluido =
    UrlServidor + 'romaneio/AlteraStatusRomaneioParaExcluido/';
const AlteraStatusRomaneioParaRemovido =
    UrlServidor + 'romaneio/AlteraStatusRomaneioParaRemovido/';
const AlteraStatusRomaneioParaCadastrado =
    UrlServidor + 'romaneio/AlteraStatusRomaneioParaCadastrado/';

// ================ TABELA PROCESSO_MADEIRA =================
const ListarProcessosMadeiraCadastrados =
    UrlServidor + 'ProcessoMadeira/ListarTodosProcessosCadastrados/';
const ListarProcessoMadeiraRemovidos =
    UrlServidor + 'ProcessoMadeira/ListarProcessosRemovidos/';
const AlterarStatusProcessoMadParaCadastrado =
    UrlServidor + 'ProcessoMadeira/AlteraStatusProcessoParaCadastrado';
const AlterarStatusProcessoMadParaRemovido =
    UrlServidor + 'ProcessoMadeira/AlteraStatusProcessoParaRemovido/';
const AlterarStatusProcessoMadParaExcluido =
    UrlServidor + 'ProcessoMadeira/AlteraStatusProcessoExcluido/';
const BuscarProcessoMadeiraPorId =
    UrlServidor + 'ProcessoMadeira/BuscarProcessoPorId/';
const CadastrarProcessoMadeira = UrlServidor + 'ProcessoMadeira/Cadastrar/';
const DeletarProcessoMadeira = UrlServidor + 'ProcessoMadeira/Deletar/';
const EditarProcessoMadeira = UrlServidor + 'ProcessoMadeira/Editar/';
const BuscarUltimoProcessoMadeiraCadastrado =
    UrlServidor + 'ProcessoMadeira/BuscarUltimoProcessoCadastrado/';
const ListaProcessoMadeiraPorTipoTora =
    UrlServidor + 'ProcessoMadeira/ListaPorTipoTora/';
const BuscaDetalhesProcessoPorTipoTora =
    UrlServidor + 'ProcessoMadeira/BuscaDetalhesPortipoTora/';

// ================= TABELA MAD_PROCESSADA ==================
const ListarTodosMadProcessada =
    UrlServidor + 'mad_processada/ListarTodosRegistros/';
const CadastrarMadProcessada = UrlServidor + 'mad_processada/Cadastrar/';
const DeletarMadProcessada = UrlServidor + 'mad_processada/Deletar/';
const ListarDatasProcesso = UrlServidor + 'mad_processada/ListarDatasProcesso/';
const listarRegistrosMadPorData =
    UrlServidor + 'mad_processada/listarRegistrosMadPorData/';
const BuscaDetalhesMadPorTipoTora =
    UrlServidor + 'mad_processada/BuscaDetalhesPorTipoTora/';
const ListaProcessoPorTipoTora =
    UrlServidor + 'mad_processada/ListaPorTipoTora/';
const BuscaTotalTorasPorData =
    UrlServidor + 'mad_processada/BuscaTotalTorasPorData/';

// ================= TABELA ACESSO_TELAS ==================
const CadastrarAcessoTelas = UrlServidor + 'AcessoTelas/Cadastrar/';
const EditarAcessoTelasUsuario =
    UrlServidor + 'AcessoTelas/EditarConfigAcessoPorUsuario/';
const BuscarConfigAcessoTelasPorUsuario =
    UrlServidor + 'AcessoTelas/BuscarConfigAcessoPorUsuario/';

// =================== TABELA TIPO_DESPESA ===================
const CadastrarTipoDespesa = UrlServidor + 'TipoDespesa/Cadastrar/';
const ExcluirTipoDespesa = UrlServidor + 'TipoDespesa/Excluir/';
const EditarTipoDespesa = UrlServidor + 'TipoDespesa/EditarTipoDespesa/';
const ListarTodosTipoDespesa =
    UrlServidor + 'TipoDespesa/ListarTodosTiposDespesas/';
const BuscarTipoDespesaPorId =
    UrlServidor + 'TipoDespesa/BuscaTipoDespesaPorId/';
const ResumoTotalTipoDespesaPorAno =
    UrlServidor + 'TipoDespesa/ResumoTotalTipoDespesaPorAno/';
const ListaMesesTipoDespesaPorAno =
    UrlServidor + 'TipoDespesa/ListaMesesTipoDespesaPorAno/';

// =================== TABELA SUB_TIPO_DESPESA ===================
const CadastrarSubTipoDespesa = UrlServidor + 'SubTipoDespesa/Cadastrar/';
const ExcluirSubTipoDespesa = UrlServidor + 'SubTipoDespesa/Excluir/';
const EditarSubTipoDespesa =
    UrlServidor + '/SubTipoDespesa/EditarSubTipoDespesa/';
const ListarTodosSubTipoDespesa =
    UrlServidor + 'SubTipoDespesa/ListarTodosSubTiposDespesa/';
const BuscarSubTipoDespesaPorId =
    UrlServidor + 'SubTipoDespesa/BuscaSubTipoDespesaPorId/';
const ListarSubTipoDespesaPorIdTipoDespesa =
    UrlServidor + 'SubTipoDespesa/ListarPorIdTipoDespesa/';
const BuscarTotalDespesaPorTipoDespesa =
    UrlServidor + 'SubTipoDespesa/BuscarTotalDespesaPorTipoDespesa/';
const BuscarTotalDespesaPorSubTipoDespesa =
    UrlServidor + 'SubTipoDespesa/BuscarTotalDespesaPorSubTipoDespesa/';

// =================== TABELA DESPESA ====================
const CadastrarDespesa = UrlServidor + 'Despesa/Cadastrar/';
const EditarDespesa = UrlServidor + 'Despesa/EditarDespesa/';
const ExcluirDespesa = UrlServidor + 'Despesa/Excluir/';
const ListarTodasDespesas = UrlServidor + 'Despesa/ListarTodasDespesas/';
const BuscarDetalhesDespesasPorDatas =
    UrlServidor + 'Despesa/BuscaDetalhesDespesaPorData/';
const BuscarDespesaPorId = UrlServidor + 'Despesa/BuscaDespesaPorId/';
const ListaDespesasPorSubGrupo =
    UrlServidor + 'Despesa/ListaDespesasPorSubGrupo/';
const BuscaValorTotalDespesasPorData =
    UrlServidor + 'Despesa/BuscaValorTotalDespesasPorData/';
// =================== TABELA PARCELA_DESPESA ====================
const EditarParcelaDespesa = UrlServidor + 'ParcelasDespesa/Editar/';
const ListaParcelasPorDespesa =
    UrlServidor + 'ParcelasDespesa/ListaParcelasDespesa/';

// ================= APIS DA PARTE FINANCEIRA ==================
const BuscarSaldoDaEmpresaPorData =
    UrlServidor + 'Financeiro/BuscarSaldoEmCaixaEmpresaPorData/';
const BuscarSaldoDaEmpresaPorOpcoesPesquisa =
    UrlServidor + 'Financeiro/BuscarSaldoPorOpcoesPesquisa/';

// =================== TABELA RECEBIMENTO ====================
const CadastrarRecebimento = UrlServidor + 'Recebimento/Cadastrar/';
const EditarRecebimento = UrlServidor + 'Recebimento/EditarRecebimento/';
const ExcluirRecebimento = UrlServidor + 'Recebimento/Excluir/';
const ListarTodosRecebimentos =
    UrlServidor + 'Recebimento/ListarTodosRecebimentos/';
const BuscarRecebimentoPorId =
    UrlServidor + 'Recebimento/BuscaRecebimentoPorId/';
const ListarRecebimentosPorData =
    UrlServidor + 'Recebimento/BuscaDetalhesRecebimentoPorData/';
const BuscaValorTotalRecebimentoPorData =
    UrlServidor + 'Recebimento/BuscaValorTotalRecebimentoPorData/';
const BuscarRecebimentoPorIdCliente =
    UrlServidor + 'Recebimento/BuscaRecebimentoPorCliente/';
const BuscarRecebimentoPorClienteEData =
    UrlServidor + 'Recebimento/BuscaRecebimentoPorClienteEData/';

// =================== TABELA PARCELA_RECEBIBO ====================
const EditarParcelaRecibo = UrlServidor + 'ParcelasRecibo/Editar/';
const ListaParcelasPorRecebimento =
    UrlServidor + 'ParcelasRecibo/ListaParcelasRecebimento/';

// =================== TABELA UNIDADE_MEDIDA ====================
const ListarTodosUndMedida = UrlServidor + 'UndMedida/ListarTodosUndMedida/';

// =================== TABELA PRODUTO ====================
const CadastrarProduto = UrlServidor + 'Produto/Cadastrar/';
const EditarProduto = UrlServidor + 'Produto/Editar/';
const ExcluirProduto = UrlServidor + 'Produto/Deletar/';
const ListarTodosProdutos = UrlServidor + 'Produto/ListarTodosProduto/';
const BuscarProdutoPorId = UrlServidor + 'Produto/BuscarProdutoPorId/';

// =================== TABELA MADEIRA ====================
const CadastrarMadeira = UrlServidor + 'Madeira/Cadastrar/';
const EditarMadeira = UrlServidor + 'Madeira/Editar/';
const ExcluirMadeira = UrlServidor + 'Madeira/Deletar/';
const ListarTodasMadeiras = UrlServidor + 'Madeira/ListarTodasMadeiras/';
const BuscarMadeiraPorId = UrlServidor + 'Madeira/BuscarMadeiraPorId/';

// =================== ESTATISTICAS CLIENTES ====================
const EstatisticaDetalhesFaturamentoClientePorData =
    UrlServidor + 'EstCliente/BuscaDetalhesFaturamentoClientePorData/';
const EstatisticaListarClientes = UrlServidor + 'EstCliente/ListaClientes/';
const EstatisticaBuscarClientePorId =
    UrlServidor + 'EstCliente/BuscaClientePorID/';

// =================== ESTATISTICAS FATURAMENTO ====================
const EstDetalhesTotalFaturamentoMeses =
    UrlServidor + 'EstFaturamento/BuscaDetalhesTotalFaturamentoMeses/';
const ListaMesesFaturamentoPorAno =
    UrlServidor + 'EstFaturamento/ListaMesesFaturamentoPorAno/';
const EstBuscaDetalhesPorMes =
    UrlServidor + 'EstFaturamento/BuscaDetalhesPorMes/';
const ListaClientesFaturamentoPorMes =
    UrlServidor + 'EstFaturamento/ListaClientesFaturamentoPorMes/';

// =================== ESTATISTICAS PRODUTO ====================
const BuscaDetalhesTotalProdutoPorAno =
    UrlServidor + 'EstProduto/BuscaDetalhesTotalProdutoPorAno/';
const ListaProdutoPorAno = UrlServidor + 'EstProduto/ListaProdutoPorAno/';
const BuscaDetalhesProdutoPorId =
    UrlServidor + 'EstProduto/BuscaDetalhesProdutoPorId/';
const ListaMesesProdutoPorId =
    UrlServidor + 'EstProduto/ListaMesesProdutoPorId/';
const BuscaDetalhesPalletPorId =
    UrlServidor + 'EstProduto/BuscaDetalhesPalletPorId/';
const ListaMesesPalletPorId = UrlServidor + 'EstProduto/ListaMesesPalletPorId/';

// =================== ESTATISTICAS SALDO DEVEDOR ====================
const BuscaDetalhesTotalSaldoDevedor =
    UrlServidor + 'SaldoDevedor/BuscaDetalhesTotalSaldoDevedor/';
const ListaClientesDevedores =
    UrlServidor + 'SaldoDevedor/ListaClientesDevedores/';
const BuscaSaldoDevedorClientePorId =
    UrlServidor + 'SaldoDevedor/BuscaDetalhesClientePorId/';

// =================== CONFIGURAÇÕES DE MODULO ====================
const CadastrarModulo = UrlServidor + 'modulo/CadastrarModulos/';
const EditarModuloEmpresa = UrlServidor + 'modulo/EditarModulos/';
const BuscarModuloPorEmpresa =
    UrlServidor + 'modulo/BuscarConfigModuloPorEmpresa/';

// =================== PRODUCAO DOS PEDIDOS ====================
const CadastrarProducao = UrlServidor + 'Producao/CadastrarProducao/';
const EditarProducao = UrlServidor + 'Producao/EditarProducao/';
const ExcluirProducaoPedido = UrlServidor + 'Producao/DeletarProducaoPedido/';
const ListaPedidoProducaoPorGrupo =
    UrlServidor + 'Producao/ListaPedidoProducaoPorGrupo/';
const BuscaUltimoProducaoPedidoCadastrado =
    UrlServidor + 'Producao/BuscaUltimoProducaoPedidoCadastrado/';
const BuscaProducaoPedidoPorId =
    UrlServidor + 'Producao/BuscarProducaoPedidoPorId/';

// ===================== ESTATISTICAS FATURAMENTO ======================
const EstDetalhesTotalLoteTodosAno =
    UrlServidor + 'EstLote/BuscaDetalhesTotalLoteMeses/';
const EstListaMesesTotalLotePorAno =
    UrlServidor + 'EstLote/ListaMesesTotalLotePorAno/';
const EstBuscaDetalhesLotePorMes =
    UrlServidor + 'EstLote/BuscaDetalhesLotePorMes/';
const EstListaoFornecedoresLotePorMes =
    UrlServidor + 'EstLote/ListaoFornecedoresLotePorMes/';

// ===================== ACOMPANHAMENTO PEDIDO ======================
const ListaGruposPedidosPorCodigoCliente =
    UrlServidor + 'AcomCliente/ListaPedidosProducaoPorCodCliente/';
