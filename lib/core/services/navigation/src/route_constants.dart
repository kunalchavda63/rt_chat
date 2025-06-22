enum RoutesEnum {
  // onboard('/onboard')
  appEntryPoint('/appEntry'),
  login('/login'),
  register('/register'),
  forgot('/forgot'),

  //Chat Ui Screens
  chatScreen('/'),
  chatRoomScreen('/chatRoom'),

  callLogsScreen('/calls'),

  // Profile Setup
  profileSetup('/profileSetup'),
  editName('/editName'),
  editAbout('/editAbout'),
  newGroup('/newGroup'),
  newBrodCast('/newBrodCast'),
  linkedDevice('/linkedDevice'),
  starred('/starred'),
  searchUser('/searchUser'),
  settings('/settings');

  const RoutesEnum(this.path);

  final String path;
}
