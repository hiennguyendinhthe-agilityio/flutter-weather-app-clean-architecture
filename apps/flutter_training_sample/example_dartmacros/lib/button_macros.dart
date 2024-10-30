import 'package:macros/macros.dart';

macro class ButtonMacros implements ClassDeclarationsMacro {
  const ButtonMacros();

  @override
  Future<void> buildDeclarationsForClass(
    ClassDeclaration clazz,
    MemberDeclarationBuilder builder,
  ) async {
   
  final fields = await builder.fieldsOf(clazz);
    for (final f in fields) {
      final name = f.identifier.name;
      final capitalized = name[0].toUpperCase() + name.substring(1);
      builder.declareInType(DeclarationCode.fromString(
        "void log$capitalized() { print('Macro variable $name: \$$name'); }",
      ));
    }
  }
}