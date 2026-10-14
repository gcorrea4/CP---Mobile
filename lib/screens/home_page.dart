import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/pessoa.dart';
import '../theme/app_colors.dart';
import '../widgets/pessoa_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const int capacidadeMaxima = 50;

  final List<Pessoa> _pessoas = [];

  final _nomeController = TextEditingController();
  final _idController = TextEditingController();

  int get _pessoasNoAmbiente => _pessoas.where((p) => p.estaNoAmbiente).length;

  bool get _ambienteLotado => _pessoasNoAmbiente >= capacidadeMaxima;

  @override
  void dispose() {
    _nomeController.dispose();
    _idController.dispose();
    super.dispose();
  }

  void _mostrarMensagem(String mensagem, {bool erro = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: erro ? AppColors.danger : AppColors.statusDentro,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _cadastrarPessoa() {
    final nome = _nomeController.text.trim();
    final id = _idController.text.trim();

    // Regra 3 — campos obrigatórios.
    if (nome.isEmpty || id.isEmpty) {
      _mostrarMensagem('Preencha nome e identificação para cadastrar.', erro: true);
      return;
    }

    // Regra 4 — identificação não pode se repetir entre pessoas ativas.
    final jaExisteAtivo = _pessoas.any(
      (p) => p.identificacao == id && p.estaNoAmbiente,
    );
    if (jaExisteAtivo) {
      _mostrarMensagem('Já existe uma pessoa no ambiente com essa identificação.', erro: true);
      return;
    }

    // Regra 1 — capacidade máxima.
    if (_ambienteLotado) {
      _mostrarMensagem('Não é possível realizar a entrada. Ambiente lotado!', erro: true);
      return;
    }

    setState(() {
      _pessoas.insert(
        0,
        Pessoa(nome: nome, identificacao: id, dataEntrada: DateTime.now()),
      );
    });

    _nomeController.clear();
    _idController.clear();
    FocusScope.of(context).unfocus();
    _mostrarMensagem('Pessoa cadastrada com sucesso!');
  }

  void _registrarSaida(Pessoa pessoa) {
    // Regra 2 — não permitir registrar saída duas vezes.
    if (!pessoa.estaNoAmbiente) {
      _mostrarMensagem('Essa pessoa já saiu do ambiente.', erro: true);
      return;
    }

    setState(() => pessoa.registrarSaida());
    _mostrarMensagem('Saída registrada com sucesso!');
  }

  Future<void> _confirmarExclusao(Pessoa pessoa) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'Excluir registro?',
          style: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Deseja realmente excluir o registro de ${pessoa.nome}?',
          style: GoogleFonts.poppins(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('CANCELAR', style: GoogleFonts.poppins(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('CONFIRMAR', style: GoogleFonts.poppins(color: AppColors.danger)),
          ),
        ],
      ),
    );

    if (confirmou == true) {
      setState(() => _pessoas.remove(pessoa));
      _mostrarMensagem('Registro excluído com sucesso!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Controle de Acesso • Academia',
          style: GoogleFonts.bebasNeue(fontSize: 24, color: AppColors.textPrimary, letterSpacing: 1.2),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildFormulario(),
            const SizedBox(height: 8),
            _buildContadorLotacao(),
            const SizedBox(height: 8),
            Expanded(child: _buildLista()),
          ],
        ),
      ),
    );
  }

  Widget _buildFormulario() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              style: GoogleFonts.poppins(color: AppColors.textPrimary),
              decoration: _inputDecoration('Nome da pessoa', Icons.person_outline),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _idController,
              style: GoogleFonts.poppins(color: AppColors.textPrimary),
              keyboardType: TextInputType.text,
              decoration: _inputDecoration('Identificação / matrícula', Icons.badge_outlined),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _cadastrarPessoa,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.how_to_reg),
                label: Text(
                  'Registrar entrada',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary),
      prefixIcon: Icon(icon, color: AppColors.primary),
      filled: true,
      fillColor: AppColors.surfaceAlt,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _buildContadorLotacao() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(Icons.groups, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Pessoas no ambiente',
              style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 14),
            ),
          ),
          Text(
            '$_pessoasNoAmbiente / $capacidadeMaxima',
            style: GoogleFonts.poppins(
              color: _ambienteLotado ? AppColors.danger : AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLista() {
    if (_pessoas.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Nenhuma pessoa cadastrada ainda.\nUtilize o formulário acima para registrar uma entrada.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 4, bottom: 16),
      itemCount: _pessoas.length,
      itemBuilder: (context, index) {
        final pessoa = _pessoas[index];
        return PessoaItem(
          pessoa: pessoa,
          onSaida: () => _registrarSaida(pessoa),
          onExcluir: () => _confirmarExclusao(pessoa),
        );
      },
    );
  }
}
