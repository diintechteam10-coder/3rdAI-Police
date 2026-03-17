abstract class GoogleAuthEvent {
  const GoogleAuthEvent();
}

class GoogleSignInRequested extends GoogleAuthEvent {
  const GoogleSignInRequested();
}

class GoogleSignOutRequested extends GoogleAuthEvent {
  const GoogleSignOutRequested();
}
