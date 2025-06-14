enum RoutesEnum {
  // onboard('/onboard')
  login('/login'),
  register('/register'),
  forgot('/forgot'),
  otp('/otp'),
  reset('/reset')
  //
  ;

  const RoutesEnum(this.path);

  final String path;
}
