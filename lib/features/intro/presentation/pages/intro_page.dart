import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_steps_tracker/di/injection_container.dart';
import 'package:flutter_steps_tracker/features/intro/presentation/manager/auth_actions/auth_cubit.dart';
import 'package:flutter_steps_tracker/features/intro/presentation/manager/auth_actions/auth_state.dart';
import 'package:flutter_steps_tracker/features/intro/presentation/manager/auth_status/auth_status_cubit.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider<AuthCubit>(
      create: (context) => getIt<AuthCubit>(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            // appBar: AppBar(),
            body: Stack(
              children: [
                Image.asset(
                  'assets/images/man-intro.jpeg',
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                ),
                const SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: Opacity(
                    opacity: 0.8,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 48.0,
                    ),
                    child: Center(
                      child: BlocConsumer<AuthCubit, AuthState>(
                        listener: (context, state) {
                          state.maybeWhen(loggedIn: () {
                            final cubit =
                                BlocProvider.of<AuthStatusCubit>(context);
                            cubit.checkAuthStatus();
                            debugPrint('hereeeeeee');
                            // Navigator.of(context).pop();
                          }, error: (message) {
                            debugPrint('Message here $message');
                            // showCustomAlertDialog(
                            //   context,
                            //   message,
                            //   isErrorDialog: true,
                            //   errorContext: S.of(context).login,
                            // );
                          }, orElse: () {
                            debugPrint('What is that!!!');
                          });
                        },
                        builder: (context, state) {
                          return state.maybeWhen(
                            loading: () => _buildColumn(true, context),
                            orElse: () => _buildColumn(false, context),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildColumn(bool isLoading, BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Spacer(
            flex: 1,
          ),
          Image.network(
            'https://iconape.com/wp-content/files/yn/145105/png/145105.png',
            fit: BoxFit.cover,
            color: Colors.white,
            height: 180,
          ),
          Text(
            'Your All-in one Activity Tracker!',
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: Colors.white,
                ),
          ),
          const Spacer(
            flex: 2,
          ),
          TextFormField(
            controller: _nameController,
            validator: (val) => val!.isEmpty ? 'Enter your name' : null,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'Enter your name',
            ),
          ),
          const SizedBox(height: 16.0),
          InkWell(
            onTap: () async {
              if (_formKey.currentState!.validate()) {
                await BlocProvider.of<AuthCubit>(context).signInAnonymously(
                  name: _nameController.text,
                );
              }
            },
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: Center(
                child: !isLoading
                    ? Text(
                        'Start Using Steps',
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      )
                    : const CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
