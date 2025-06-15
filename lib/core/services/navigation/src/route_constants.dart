enum RoutesEnum {
  // onboard('/onboard')
  appEntryPoint('/appEntry'),
  login('/login'),
  register('/register'),
  forgot('/forgot'),
  reset('/reset')
  //
  ;

  const RoutesEnum(this.path);

  final String path;
}
