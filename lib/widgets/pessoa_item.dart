import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../models/pessoa.dart';
import '../theme/app_colors.dart';

/// Widget personalizado responsável por representar uma [Pessoa] na lista.
///
/// Recebe o objeto [pessoa] e as funções [onSaida] e [onExcluir], que são
/// chamadas pelos botões deslizantes (Slidable) para comunicar ao widget pai
/// que o usuário solicitou uma dessas ações.
class PessoaItem extends StatelessWidget {
  final Pessoa pessoa;
  final VoidCallback onSaida;
  final VoidCallback onExcluir;

  const PessoaItem({
    super.key,
    required this.pessoa,
    required this.onSaida,
    required this.onExcluir,
  });

  @override
  Widget build(BuildContext context) {
    final formatador = DateFormat("dd/MM/yyyy 'às' HH:mm");
    final dentro = pessoa.estaNoAmbiente;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Slidable(
        key: ValueKey(pessoa.identificacao),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.5,
          children: [
            SlidableAction(
              onPressed: (_) => onSaida(),
              backgroundColor: dentro ? AppColors.primary : AppColors.surfaceAlt,
              foregroundColor: Colors.white,
              icon: Icons.logout,
              label: 'Saída',
            ),
            SlidableAction(
              onPressed: (_) => onExcluir(),
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Excluir',
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.surfaceAlt),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: dentro
                    ? AppColors.statusDentro.withAlpha(40)
                    : AppColors.statusSaiu.withAlpha(40),
                child: Icon(
                  Icons.fitness_center,
                  color: dentro ? AppColors.statusDentro : AppColors.statusSaiu,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pessoa.nome,
                      style: GoogleFonts.poppins(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'ID: ${pessoa.identificacao}',
                      style: GoogleFonts.poppins(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      'Entrada: ${formatador.format(pessoa.dataEntrada)}',
                      style: GoogleFonts.poppins(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: dentro
                      ? AppColors.statusDentro.withAlpha(40)
                      : AppColors.statusSaiu.withAlpha(40),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  pessoa.situacao,
                  style: GoogleFonts.poppins(
                    color: dentro ? AppColors.statusDentro : AppColors.statusSaiu,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
