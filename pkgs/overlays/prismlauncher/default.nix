{
  prismlauncher,
  glfw,
  zulu17,
  zulu21,
}:

prismlauncher.override {
  additionalPrograms = [ glfw ];
  jdks = [
    zulu17
    zulu21
  ];
}
