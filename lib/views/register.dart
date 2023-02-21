part of 'views.dart';

/// This view handles the username registration.
class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  static Route get route => CupertinoPageRoute(
      builder: (context) => const RegisterView(),
      title: "Register"
  );

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _controller = TextEditingController();
  
  void _next(String v) async {
    await (await SharedPreferences.getInstance()).setString("username", v);
    Navigator.of(context).pushAndRemoveUntil(HomeView.route, (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Choose a username.",
                style: TextStyle(
                  fontSize: 20,
                  color: CupertinoTheme.of(context).primaryColor
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text("This will only be stored on your device, and can be added to your posts."),
              ),
              CupertinoTextField(
                textInputAction: TextInputAction.next,
                onSubmitted: _next,
                controller: _controller,
                placeholder: "Username",
                // autofillHints: const [AutofillHints.username],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CupertinoButton.filled(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Text("Next"),
                    onPressed: () => _next(_controller.text),
                  ),
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}
