{
  prismlauncher,
  glfw,
  zulu8,
  zulu17,
  zulu21,
}:

prismlauncher.override {
  additionalPrograms = [ glfw ];
  jdks = [
    zulu8
    zulu17
    zulu21
  ];
}
