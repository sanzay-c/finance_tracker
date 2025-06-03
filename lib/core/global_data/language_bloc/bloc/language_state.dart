part of 'language_bloc.dart';

@immutable
abstract class LanguageState {}

final class LanguageInitial extends LanguageState {}

class LanguageChanged extends LanguageState {
  final Locale locale;
  LanguageChanged(this.locale);
}