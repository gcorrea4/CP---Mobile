# Controle de Lotação 2.0 — Gerenciamento de Acessos (Academia)

Aplicativo mobile desenvolvido em **Flutter/Dart** para controlar a lotação e o
acesso de pessoas em uma academia. Na versão 2.0 o app evoluiu do simples
contador do Checkpoint 01 para um sistema completo de **cadastro e
gerenciamento de pessoas**, registrando quem está no ambiente, horário de
entrada/saída e aplicando as regras de capacidade máxima.

## Vídeo de demonstração

[Assista aqui](https://youtu.be/lwDqGMWIxrE) *(vídeo de até 5 minutos
mostrando o cadastro, a lista, o controle de entrada/saída, o Slidable e o
AlertDialog funcionando)*

## Ambiente escolhido

**Academia** — o app controla a entrada e saída de alunos, respeitando a
capacidade máxima de pessoas simultâneas no espaço de treino.

## Integrantes

- Gabriel Correa Souza — RM567903
- Eric Maciel — RM567398

## Funcionalidades

- Cadastro de pessoas (nome, identificação/matrícula e data/hora de entrada)
  usando `TextField` + `TextEditingController`.
- Lista de pessoas em `ListView`, exibida através de um widget personalizado
  (`PessoaItem`).
- Controle de entrada e saída, com atualização da situação da pessoa
  ("No ambiente" / "Saiu") e da contagem de pessoas presentes.
- Capacidade máxima (50 pessoas), bloqueando novas entradas quando o
  ambiente está lotado.
- Feedback de todas as operações via `ScaffoldMessenger` + `SnackBar`.
- Ações rápidas por **Slidable**: deslizar um item da lista para registrar
  **Saída** ou **Excluir** o registro.
- Confirmação de exclusão via `AlertDialog`.
- Formatação de datas/horários com o pacote `intl`.
- Interface personalizada com tema escuro/laranja (tema de academia),
  `Google Fonts`, cores em hexadecimal, `SafeArea`, `Padding`, `SizedBox`,
  `Expanded` e ícones.
- Ícone do app personalizado (halter), gerado com `flutter_launcher_icons`.

## Regras de negócio

1. A quantidade de pessoas no ambiente não pode ultrapassar a capacidade
   máxima.
2. Uma pessoa que já saiu não pode ter sua saída registrada novamente.
3. Não é possível cadastrar uma pessoa sem nome e identificação.
4. Não é possível cadastrar duas pessoas com a mesma identificação enquanto
   ambas estiverem ativas (dentro do ambiente).
5. Toda operação relevante (cadastro, saída, exclusão, erro de lotação)
   gera um feedback visual via `SnackBar`.

## Tecnologias e pacotes utilizados

- [Flutter](https://flutter.dev) / Dart
- [`intl`](https://pub.dev/packages/intl) — formatação de data/hora
- [`flutter_slidable`](https://pub.dev/packages/flutter_slidable) — ações
  deslizantes na lista
- [`google_fonts`](https://pub.dev/packages/google_fonts) — tipografia
  personalizada
- [`flutter_launcher_icons`](https://pub.dev/packages/flutter_launcher_icons)
  — ícone do app

## Organização do projeto

```
lib/
  main.dart                 # Ponto de entrada, tema do app
  models/
    pessoa.dart              # Classe Pessoa (modelo de dados)
  screens/
    home_page.dart           # Tela principal: formulário, lista e regras
  widgets/
    pessoa_item.dart          # Widget personalizado (card + Slidable)
  theme/
    app_colors.dart           # Paleta de cores do app
assets/
  icon/icon.png               # Ícone personalizado do app
  images/                     # Imagens utilizadas na interface
```

## Como executar o projeto

1. Tenha o [Flutter SDK](https://docs.flutter.dev/get-started/install)
   instalado e configurado.
2. Clone o repositório e acesse a pasta do projeto:
   ```bash
   git clone <link-do-repositorio>
   cd CP---Mobile
   ```
3. Instale as dependências:
   ```bash
   flutter pub get
   ```
4. Execute o aplicativo em um dispositivo/emulador conectado:
   ```bash
   flutter run
   ```
