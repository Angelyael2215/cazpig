import 'package:flutter/material.dart';

import '../../../controllers/level_generator.dart';
import '../../../controllers/nivel9_controller.dart';
import '../../../controllers/user_controller.dart';
import '../../widgets/game_bottom_sheet.dart';

class Nivel9Screen extends StatefulWidget {
  final int nivelInicial;

  const Nivel9Screen({
    super.key,
    required this.nivelInicial,
  });

  @override
  State<Nivel9Screen> createState() => _Nivel9ScreenState();
}

class _Nivel9ScreenState extends State<Nivel9Screen> {
  late final Nivel9Controller controller =
      Nivel9Controller(nivelInicial: widget.nivelInicial);

  static const Color dorado = Color(0xFFFFC857);
  static const Color doradoClaro = Color(0xFFFFE3A1);
  static const Color fondoHeader = Color(0xFF24150E);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _comprobar() {
    final bool correcto = controller.comprobarResultado();

    if (correcto) {
      UserController().completarNivel(widget.nivelInicial);

      GameBottomSheet.mostrarVictoria(
        context: context,
        pigmentosGanados: 30,
        datoCurioso: LevelGenerator.obtenerDatoCurioso(
          controller.datosNivel,
        ),
        onContinuar: () {
          Navigator.of(context).pop();
        },
      );

      return;
    }

    UserController().restarVida();

    final int vidas = UserController().currentUser.lives;

    GameBottomSheet.mostrarDerrota(
      context: context,
      mensaje: vidas <= 0
          ? 'Te has quedado sin vidas. ¡Repón vidas en el mapa!'
          : 'Ese cofre no corresponde al código. ¡Inténtalo de nuevo!',
      onReintentar: () {
        if (vidas <= 0) {
          Navigator.of(context).pop();
        } else {
          controller.reiniciarSeleccion();
          setState(() {});
        }
      },
      onVolver: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildHeader() {
    final user = UserController().currentUser;

    return Container(
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: fondoHeader,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF8B5A2B),
            width: 3,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.arrow_back,
              color: doradoClaro,
              size: 31,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          Expanded(
            child: Text(
              'ADIVINA EL HEX - Nivel ${widget.nivelInicial}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: doradoClaro,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                shadows: [
                  Shadow(
                    color: Colors.black87,
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
          const Icon(
            Icons.favorite,
            color: dorado,
            size: 22,
          ),
          const SizedBox(width: 4),
          Text(
            '${user.lives}',
            style: const TextStyle(
              color: doradoClaro,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 12),
          const Icon(
            Icons.diamond,
            color: Colors.tealAccent,
            size: 22,
          ),
          const SizedBox(width: 4),
          Text(
            '${user.pigments}',
            style: const TextStyle(
              color: doradoClaro,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

 Widget _buildInstructionPanel() {
  return SizedBox(
    width: double.infinity,
    height: 166,
    child: Container(
      // Aumentamos los paddings para que el texto no toque el marco metálico
      padding: const EdgeInsets.symmetric(
        horizontal: 36, // Espacio libre en los laterales
        vertical: 24,   // Espacio libre arriba y abajo
      ),
      alignment: Alignment.center, // Centra vertical y horizontalmente
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/imagenes/barramensaje.png',
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center, // Centra el contenido internamente
        crossAxisAlignment: CrossAxisAlignment.start, // Alinea el texto a la izquierda dentro del centro
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "CAPITÁN'S LOG",
            style: TextStyle(
              color: doradoClaro,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              shadows: [
                Shadow(
                  color: Colors.black87,
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Adivina el tesoro. Examina la marca del cobre. ¿A cuál de los siguientes botines corresponde?',
            softWrap: true,
            style: TextStyle(
              color: doradoClaro,
              fontSize: 13,
              height: 1.2,
              fontWeight: FontWeight.w800,
              shadows: [
                Shadow(
                  color: Colors.black87,
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildHexPanel(String hexCode) {
    return Column(
      children: [
        const Text(
          'CÓDIGO HEXADECIMAL DEL COFRE:',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: dorado,
            fontSize: 18,
            fontWeight: FontWeight.w900,
            shadows: [
              Shadow(
                color: Colors.black87,
                blurRadius: 4,
              ),
            ],
          ),
        ),
        const SizedBox(height: 7),
        SizedBox(
          width: double.infinity,
          height: 155,
          child: ClipRect(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/imagenes/placa.png',
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  left: 58,
                  right: 58,
                  top: 35,
                  bottom: 35,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      hexCode,
                      maxLines: 1,
                      style: const TextStyle(
                        color: doradoClaro,
                        fontSize: 30,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _imagenDelCofre(int indice) {
    const List<String> imagenes = [
      'assets/imagenes/cofrerojo.png',
      'assets/imagenes/cofregris.png',
      'assets/imagenes/cofrecafe.png',
      'assets/imagenes/cofreazul.png',
    ];

    return imagenes[indice % imagenes.length];
  }

  Widget _buildChest(
    Color color,
    int indice,
    bool seleccionado,
  ) {
    return GestureDetector(
      onTap: () {
        controller.seleccionarColor(color);
      },
      child: SizedBox(
        width: 135,
        height: 132,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            if (seleccionado)
              Container(
                width: 122,
                height: 122,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: doradoClaro,
                    width: 5,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: dorado,
                      blurRadius: 17,
                      spreadRadius: 3,
                    ),
                  ],
                ),
              ),
            Transform.scale(
              scale: 2.7,
              child: Image.asset(
                _imagenDelCofre(indice),
                width: 135,
                height: 125,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton() {
    return SizedBox(
      height: 108,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/imagenes/barrabaja.png',
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            left: 50,
            right: 50,
            top: 30,
            bottom: 3,
            child: InkWell(
              onTap: controller.listoParaComprobar
                  ? _comprobar
                  : null,
              borderRadius: BorderRadius.circular(18),
              child: Center(
                child: Text(
                  'COMPROBAR',
                  style: TextStyle(
                    color: controller.listoParaComprobar
                        ? doradoClaro
                        : Colors.white38,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                    shadows: const [
                      Shadow(
                        color: Colors.black,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        final datos = controller.datosNivel;

        return Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/imagenes/fondobarco.png',
                  fit: BoxFit.cover,
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    _buildHeader(),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(
                          13,
                          12,
                          13,
                          10,
                        ),
                        child: Column(
                          children: [
                            _buildInstructionPanel(),
                            const SizedBox(height: 10),
                            _buildHexPanel(datos.hexCode),
                            const SizedBox(height: 18),
                            const Text(
                              'PIGMENTOS DE LABORATORIO DISPONIBLES:',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: dorado,
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                shadows: [
                                  Shadow(
                                    color: Colors.black87,
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 13),
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 2,
                              runSpacing: 7,
                              children: datos.options.asMap().entries.map((entry) {
                                final int indice = entry.key;
                                final Color color = entry.value;

                                return _buildChest(
                                  color,
                                  indice,
                                  controller.colorSeleccionado == color,
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SafeArea(
                      top: false,
                      child: _buildButton(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}