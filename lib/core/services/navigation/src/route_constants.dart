enum RoutesEnum {
  // onboard('/onboard')
  appEntryPoint('/appEntry'),
  login('/login'),
  register('/register'),
  forgot('/forgot');

  const RoutesEnum(this.path);

  final String path;
}
