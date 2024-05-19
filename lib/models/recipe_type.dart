// Category of recipes
class RecipeType {
  final String name;
  final RecipeTypeCode code;
  final String description;

  const RecipeType(
    this.name,
    this.code,
    this.description,
  );

  RecipeType.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        code = codeStringToEnum(json['code']),
        description = json['description'];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': codeEnumToString(code),
      'description': description,
    };
  }

  RecipeType.fromSP(Map<dynamic, dynamic> json)
      : name = json['name'],
        code = codeStringToEnum(json['code']),
        description = json['description'];
}

enum RecipeTypeCode {
  APTZ, // Appertizer
  MAIN, // Main Course
  DSRT, // Dessert
  SLDS, // Salad
  BVRG, // Beverage
  NONE // Not classified
}

// Convert code in string to enum
RecipeTypeCode codeStringToEnum(String code) {
  switch (code) {
    case 'APTZ':
      return RecipeTypeCode.APTZ;

    case 'MAIN':
      return RecipeTypeCode.MAIN;

    case 'DSRT':
      return RecipeTypeCode.DSRT;

    case 'SLDS':
      return RecipeTypeCode.SLDS;

    case 'BVRG':
      return RecipeTypeCode.BVRG;

    default:
      return RecipeTypeCode.NONE;
  }
}

// Convert code in enum to string
String codeEnumToString(RecipeTypeCode code) {
  switch (code) {
    case RecipeTypeCode.APTZ:
      return 'APTZ';

    case RecipeTypeCode.MAIN:
      return 'MAIN';

    case RecipeTypeCode.DSRT:
      return 'DSRT';

    case RecipeTypeCode.SLDS:
      return 'SLDS';

    case RecipeTypeCode.BVRG:
      return 'BVRG';

    default:
      return 'NONE';
  }
}

String enumToDisplayName(RecipeTypeCode code) {
  switch (code) {
    case RecipeTypeCode.APTZ:
      return 'Appetizers';

    case RecipeTypeCode.MAIN:
      return 'Main Courses';

    case RecipeTypeCode.DSRT:
      return 'Desserts';

    case RecipeTypeCode.SLDS:
      return 'Salads';

    case RecipeTypeCode.BVRG:
      return 'Beverages';

    default:
      return 'All';
  }
}
