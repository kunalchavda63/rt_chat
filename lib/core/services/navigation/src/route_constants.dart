enum RoutesEnum {
  // onboard('/onboard')
  appEntryPoint('/appEntry'),
  login('/login'),
  register('/register'),
  forgot('/forgot'),
  chatScreen('/'),
  callLogsScreen('/'),
  profileSetup('/profileSetup'),
  newGroup('/newGroup'),
  newBrodCast('/newBrodCast'),
  linkedDevice('/linkedDevice'),
  starred('/starred'),
  searchUser('/searchUser'),
  settings('/settings');

  const RoutesEnum(this.path);

  final String path;
}
