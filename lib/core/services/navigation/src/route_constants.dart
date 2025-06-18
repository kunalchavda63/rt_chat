enum RoutesEnum {
  // onboard('/onboard')
  appEntryPoint('/appEntry'),
  login('/login'),
  register('/register'),
  forgot('/forgot'),
  chatScreen('/'),
  callLogsScreen('/'),
  profileSetup('/profileSetup'),
  searchUser('/searchUser');

  const RoutesEnum(this.path);

  final String path;
}
